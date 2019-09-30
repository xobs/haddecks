# This file is Copyright (c) 2014 Yann Sionneau <ys@m-labs.hk>
# This file is Copyright (c) 2014-2018 Florent Kermarrec <florent@enjoy-digital.fr>
# This file is Copyright (c) 2013-2014 Robert Jordens <jordens@gmail.com>
# This file is Copyright (c) 2015-2014 Sebastien Bourdeauducq <sb@m-labs.hk>

# License: BSD


from migen import *
from migen.genlib.misc import timeline

from litex.gen import *

from litex.soc.interconnect import wishbone
from litex.soc.cores.spi import SPIMaster

# SpiRam Quad/Dual/Single (memory-mapped) --------------------------------------------------------

_FAST_READ = 0x0b
_DIOFR = 0xbb
_QIOFR = 0xeb

_WRITE = 0x02
_QIOW = 0x38


def _format_cmd(cmd, spi_width):
    """
    `cmd` is the read instruction. Since everything is transmitted on all
    dq lines (cmd, adr and data), extend/interleave cmd to full pads.dq
    width even if dq1-dq3 are don't care during the command phase:
    For example, for N25Q128, 0xeb is the quad i/o fast read, and
    extended to 4 bits (dq1,dq2,dq3 high) is: 0xfffefeff
    """
    c = 2**(8*spi_width)-1
    for b in range(8):
        if not (cmd>>b)%2:
            c &= ~(1<<(b*spi_width))
    return c


class SpiRamDualQuad(Module):
    def __init__(self, pads_1, pads_2, dummy=5, endianness="big"):
        """
        Simple SPI flash.
        Supports multi-bit pseudo-parallel reads (aka Dual or Quad I/O Fast
        Read). Only supports mode0 (cpol=0, cpha=0).
        """
        self.bus = bus = wishbone.Interface()
        spi_width = len(pads_1.dq)
        assert spi_width >= 2
        assert len(pads_1.dq) == len(pads_2.dq)

        # # #

        cs_n = Signal(reset=1)
        clk = Signal()
        dq_oe = Signal()
        wbone_width = len(bus.dat_r)


        read_cmd_params = {
            4: (_format_cmd(_QIOFR, 4), 4*8),
            2: (_format_cmd(_DIOFR, 2), 2*8),
            1: (_format_cmd(_FAST_READ, 1), 1*8)
        }
        read_cmd, cmd_width = read_cmd_params[spi_width]
        write_cmd_params = {
            4: _format_cmd(_QIOW, 4),
            1: _format_cmd(_WRITE, 1),
        }
        write_cmd = write_cmd_params[spi_width]
        write_stage = Signal() # 0 during address stage, 1 during write stage
        addr_width = 24

        dq1 = TSTriple(spi_width)
        dq2 = TSTriple(spi_width)
        self.specials.dq1 = dq1.get_tristate(pads_1.dq)
        self.specials.dq2 = dq2.get_tristate(pads_2.dq)

        sr = Signal(max(cmd_width, addr_width, wbone_width))
        if endianness == "big":
            self.comb += bus.dat_r.eq(sr)
        else:
            self.comb += bus.dat_r.eq(reverse_bytes(sr))

        gang_outputs = Signal()
        hw_read_logic = [
            pads_1.clk.eq(clk),
            pads_1.cs_n.eq(cs_n),
            pads_2.clk.eq(clk),
            pads_2.cs_n.eq(cs_n),
            dq1.o.eq(sr[-spi_width:]),
            If(gang_outputs,
                dq2.o.eq(sr[-spi_width:]),
            ).Else(
                dq2.o.eq(sr[-(spi_width*2):-spi_width]),
            ),
            dq1.oe.eq(dq_oe),
            dq2.oe.eq(dq_oe),
        ]

        self.comb += hw_read_logic

        # if div < 2:
        #     raise ValueError("Unsupported value \'{}\' for div parameter for SpiFlash core".format(div))
        # else:
        #     i = Signal(max=div)
        #     dqi = Signal(spi_width*2)
        #     dqo = Signal(spi_width*2)
        #     self.sync += [
        #         If(i == div//2 - 1,
        #             clk.eq(1),
        #             dqi.eq(Cat(dq1.i, dq2.i)),
        #         ),
        #         If(i == div - 1,
        #             i.eq(0),
        #             clk.eq(0),
        #             If(bus.we & write_stage,
        #                 # If we're writing, reuse the `dat_r` lines
        #                 # as a temporary buffer to shift out the data.
        #                 sr.eq(Cat(Signal(spi_width*2), sr[:-spi_width*2])),
        #             ).Else(
        #                 sr.eq(Cat(dqi, sr[:-spi_width*2]))
        #             )
        #         ).Else(
        #             i.eq(i + 1),
        #         ),
        #     ]

        self.submodules.fsm = fsm = FSM()
        cycle_counter = Signal(5, reset_less=True)
        cycle_counter_reset = Signal()
        cycle_counter_ce = Signal()
        is_write = Signal()
        next_addr = Signal(32)
        self.sync += \
            If(cycle_counter_reset,
                cycle_counter.eq(0)
            ).Elif(cycle_counter_ce,
                cycle_counter.eq(cycle_counter + 1)
            )

        print("cmd_width: {}  wbone_width: {}".format(cmd_width, wbone_width))
        fsm.act("IDLE",
            cycle_counter_reset.eq(1),
            If(bus.cyc & bus.stb,
                NextState("SEND_CMD"),
                NextValue(is_write, bus.we), # Cache the write value so we can speed up sequences
                If(bus.we,
                    NextValue(sr, write_cmd),
                ).Else(
                    NextValue(sr, read_cmd),
                ),
            )
        )
        fsm.act("SEND_CMD",
            cycle_counter_ce.eq(1),
            dq_oe.eq(1),
            cs_n.eq(0),
            clk.eq(ClockSignal()),
            gang_outputs.eq(1),
            NextValue(sr, Cat(Signal(cmd_width - wbone_width + spi_width), sr)),
            If(cycle_counter == cmd_width//spi_width - 1,
                cycle_counter_reset.eq(1),
                # Strip off the bottom address bit, since we're striping across two chips.
                NextValue(sr, bus.adr << 1),
                # However, Litex Wishbone addresses are missing the bottom two bits,
                # so the next address to read is just bus.adr + 1.
                NextValue(next_addr, bus.adr + 1),
                NextState("SEND_ADDR"),
            ),
        )
        fsm.act("SEND_ADDR",
            cycle_counter_ce.eq(1),
            dq_oe.eq(1),
            cs_n.eq(0),
            clk.eq(ClockSignal()),
            gang_outputs.eq(1),
            NextValue(sr, Cat(Signal(cmd_width - wbone_width + spi_width), sr)),
            If(cycle_counter == addr_width//spi_width - 1,
                cycle_counter_reset.eq(1),
                If(is_write,
                    NextState("SEND_DATA"),
                    NextValue(sr, bus.dat_w),
                ).Else(
                    NextState("RECV_DATA_DUMMY"),
                ),
            ),
        )
        fsm.act("SEND_DATA",
            cycle_counter_ce.eq(1),
            dq_oe.eq(1),
            cs_n.eq(0),
            clk.eq(ClockSignal()),
            NextValue(sr, Cat(Signal(cmd_width - wbone_width + (spi_width * 2)), sr)),
            If(cycle_counter == wbone_width//spi_width//2 - 1,
                cycle_counter_reset.eq(1),
                NextState("WAIT_SEND_MORE"),
                bus.ack.eq(1),
            ),
        )
        fsm.act("RECV_DATA_DUMMY",
            cycle_counter_ce.eq(1),
            dq_oe.eq(0),
            cs_n.eq(0),
            clk.eq(ClockSignal()),
            If(cycle_counter == dummy,
                cycle_counter_reset.eq(1),
                NextState("RECV_DATA"),
            ),
        )
        fsm.act("RECV_DATA",
            cycle_counter_ce.eq(1),
            dq_oe.eq(0),
            cs_n.eq(0),
            clk.eq(ClockSignal()),
            NextValue(sr, Cat(dq1.i, dq2.i, sr[:-spi_width*2])),
            If(cycle_counter == wbone_width//spi_width//2,
                cycle_counter_reset.eq(1),
                NextState("WAIT_RECV_MORE"),
                bus.ack.eq(1),
            ),
        )
        fsm.act("WAIT_SEND_MORE",
            cs_n.eq(0),
            If(bus.cyc & bus.stb,
                NextState("IDLE"),
                If(bus.adr == next_addr,
                    If(bus.we,
                        NextState("SEND_DATA")
                    )
                )
            )
        )
        fsm.act("WAIT_RECV_MORE",
            cs_n.eq(0),
            If(bus.cyc & bus.stb,
                NextState("IDLE"),
                If(bus.adr == next_addr,
                    If(~bus.we,
                        NextState("RECV_DATA")
                    )
                )
            )
        )
        # # spi is byte-addressed, prefixed by zeroes
        # z = Replicate(0, log2_int(wbone_width//8))
        # seq = [
        #     # Send the `read_cmd` out the port, reusing the
        #     # Wishbone `rx` line as a temporary buffer
        #     (cmd_width//spi_width*div,
        #         [dq_oe.eq(1), cs_n.eq(0), sr[-cmd_width:].eq(read_cmd)]),
        #     # Write the address out the port, again by reusing the
        #     # Wishbone `rx` line as a temporary buffer
        #     (addr_width//spi_width*div,
        #         [sr[-addr_width:].eq(Cat(z, bus.adr))]),
        #     # Wait for 8 clock cycles for the read to appear
        #     ((dummy + wbone_width//spi_width)*div,
        #         [dq_oe.eq(0)]),
        #     (1,
        #         [bus.ack.eq(1), cs_n.eq(1)]),
        #     (div, # tSHSL!
        #         [bus.ack.eq(0)]),
        #     (0,
        #         []),
        # ]

        # # accumulate timeline deltas
        # t, rd_tseq = 0, []
        # for dt, a in seq:
        #     rd_tseq.append((t, a))
        #     t += dt

        # addr_stage = Signal()
        # seq = [
        #     # Send the `write_cmd` out the port
        #     (cmd_width//spi_width*div,
        #         [dq_oe.eq(1), cs_n.eq(0), sr[-cmd_width:].eq(write_cmd), write_stage.eq(0), addr_stage.eq(0)]),
        #     # Write the address out the port, again by reusing the
        #     # Wishbone `rx` line as a temporary buffer
        #     (addr_width//spi_width*div,
        #         [sr[-addr_width:].eq(Cat(z, bus.adr)), addr_stage.eq(1)]),
        #     # Immediately write the data out
        #     (1,
        #         [write_stage.eq(1), sr.eq(bus.dat_w)]),
        #     ((wbone_width//spi_width)*div,
        #         []),
        #     (1,
        #         [bus.ack.eq(1), cs_n.eq(1), dq_oe.eq(0)]),
        #     (div, # tSHSL!
        #         [bus.ack.eq(0),]),
        #     (0,
        #         []),
        # ]

        # # accumulate timeline deltas
        # t, wr_tseq = 0, []
        # for dt, a in seq:
        #     wr_tseq.append((t, a))
        #     t += dt

        # self.sync += [
        #     timeline(bus.cyc & bus.stb & ~bus.we & (i == div - 1), rd_tseq),
        #     timeline(bus.cyc & bus.stb &  bus.we & (i == div - 1), wr_tseq),
        # ]