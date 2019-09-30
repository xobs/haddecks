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


class SpiRamQuad(Module):
    def __init__(self, pads, dummy=5, div=2, endianness="big"):
        """
        Simple SPI flash.
        Supports multi-bit pseudo-parallel reads (aka Dual or Quad I/O Fast
        Read). Only supports mode0 (cpol=0, cpha=0).
        """
        self.bus = bus = wishbone.Interface()
        spi_width = len(pads.dq)
        assert spi_width >= 2

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

        dq = TSTriple(spi_width)
        self.specials.dq = dq.get_tristate(pads.dq)

        sr = Signal(max(cmd_width, addr_width, wbone_width))
        if endianness == "big":
            self.comb += bus.dat_r.eq(sr)
        else:
            self.comb += bus.dat_r.eq(reverse_bytes(sr))

        hw_read_logic = [
            pads.clk.eq(clk),
            pads.cs_n.eq(cs_n),
            dq.o.eq(sr[-spi_width:]),
            dq.oe.eq(dq_oe)
        ]

        self.comb += hw_read_logic

        if div < 2:
            raise ValueError("Unsupported value \'{}\' for div parameter for SpiFlash core".format(div))
        else:
            i = Signal(max=div)
            dqi = Signal(spi_width)
            dqo = Signal(spi_width)
            self.sync += [
                If(i == div//2 - 1,
                    clk.eq(1),
                    dqi.eq(dq.i),
                ),
                If(i == div - 1,
                    i.eq(0),
                    clk.eq(0),
                    If(bus.we & write_stage,
                        # If we're writing, reuse the `dat_r` lines
                        # as a temporary buffer to shift out the data.
                        sr.eq(Cat(Signal(spi_width), sr[:-spi_width])),
                    ).Else(
                        sr.eq(Cat(dqi, sr[:-spi_width]))
                    )
                ).Else(
                    i.eq(i + 1),
                ),
            ]

        # spi is byte-addressed, prefixed by zeroes
        z = Replicate(0, log2_int(wbone_width//8))
        seq = [
            # Send the `read_cmd` out the port, reusing the
            # Wishbone `rx` line as a temporary buffer
            (cmd_width//spi_width*div,
                [dq_oe.eq(1), cs_n.eq(0), sr[-cmd_width:].eq(read_cmd)]),
            # Write the address out the port, again by reusing the
            # Wishbone `rx` line as a temporary buffer
            (addr_width//spi_width*div,
                [sr[-addr_width:].eq(Cat(z, bus.adr))]),
            # Wait for 8 clock cycles for the read to appear
            ((dummy + wbone_width//spi_width)*div,
                [dq_oe.eq(0)]),
            (1,
                [bus.ack.eq(1), cs_n.eq(1)]),
            (div, # tSHSL!
                [bus.ack.eq(0)]),
            (0,
                []),
        ]

        # accumulate timeline deltas
        t, rd_tseq = 0, []
        for dt, a in seq:
            rd_tseq.append((t, a))
            t += dt

        addr_stage = Signal()
        seq = [
            # Send the `write_cmd` out the port
            (cmd_width//spi_width*div,
                [dq_oe.eq(1), cs_n.eq(0), sr[-cmd_width:].eq(write_cmd), write_stage.eq(0), addr_stage.eq(0)]),
            # Write the address out the port, again by reusing the
            # Wishbone `rx` line as a temporary buffer
            (addr_width//spi_width*div,
                [sr[-addr_width:].eq(Cat(z, bus.adr)), addr_stage.eq(1)]),
            # Immediately write the data out
            (1,
                [write_stage.eq(1), sr.eq(bus.dat_w)]),
            ((wbone_width//spi_width)*div,
                []),
            (1,
                [bus.ack.eq(1), cs_n.eq(1), dq_oe.eq(0)]),
            (div, # tSHSL!
                [bus.ack.eq(0),]),
            (0,
                []),
        ]

        # accumulate timeline deltas
        t, wr_tseq = 0, []
        for dt, a in seq:
            wr_tseq.append((t, a))
            t += dt

        self.sync += [
            timeline(bus.cyc & bus.stb & ~bus.we & (i == div - 1), rd_tseq),
            timeline(bus.cyc & bus.stb &  bus.we & (i == div - 1), wr_tseq),
        ]