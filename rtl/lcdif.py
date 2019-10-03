from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect.csr import AutoCSR, CSRStatus, CSRStorage, CSRField

from migen import *
from migen.genlib import fifo

class LCDIF(Module, AutoCSR, AutoDoc):
    def __init__(self, pads):
        # All MIPI commands and data are 8-bits, with the exception of commands
        # to read and write memory to the LCD.
        # self.intro = ModuleDoc(title="LCDIF", body=""" """)
        self.cmd = CSRStorage(8, description="Send an 8-bit command to the LCD panel")
        self.data = CSRStorage(8, description="Send an 8-bit data byte to the LCD panel")
        self.ctrl = CSRStorage(6, fields=[
            CSRField("bl", description="Control the backlight state"),
            CSRField("reset", reset=1, description="Directly connected to the LCD ``reset`` line"),
            CSRField("cs", reset=1, description="Directly connected to the LCD ``cs`` line"),
            CSRField("fbstart", description="Switch to line renderer on the next VBL"),
            CSRField("fbena", description="Enable input to the line renderer"),
            CSRField("read", description="Set to ``1`` to read data from the device", pulse=True),
        ])
        self.status = CSRStatus(2, fields=[
            CSRField("fmark", description="Start-of-frame marker"),
            CSRField("id", description="LCD ID pin"),
        ])
        self.fb = CSRStorage(1, fields=[
            CSRField("startcmd", description="???")
        ])
        self.response = CSRStorage(8, description="Response data after reading from the device.")
        self.tpg = CSRStorage(1, description="Test pattern generators", fields=[
            CSRField("bluething", description="Kinda pretty blue display"),
            CSRField("rainbow", description="RGB pattern test"),
        ])

        self.submodules.wheel = Wheel()
        idx_counter = Signal(16)

        # Data pins
        d = TSTriple(len(pads.db))
        self.specials.d = d.get_tristate(pads.db)

        # D/CX (If 1, this is a data packet, otherwise it's a command packet)
        dcx = Signal()

        # RDX is 1 if this is a `read` packet (i.e. device-to-FPGA)
        rdx = Signal()

        # WRX is 1 if this is a `write` packet (i.e. device-to-FPGA)
        wrx = Signal()

        # TE is 1 on start-of-frame (?)
        te = Signal()

        self.comb += [
            self.status.fields.fmark.eq(pads.fmark),
            self.status.fields.id.eq(pads.id),
            pads.cs.eq(self.ctrl.fields.cs),
            pads.rst.eq(~self.ctrl.fields.reset),
            pads.blen.eq(self.ctrl.fields.bl),
            pads.rs.eq(dcx),
            pads.wr.eq(wrx),
            pads.rd.eq(rdx),
            te.eq(pads.fmark),
        ]

        self.submodules.fsm = fsm = FSM()

        fsm.act("IDLE",
            wrx.eq(1),
            rdx.eq(1),
            If(self.cmd.re,
                wrx.eq(0),
                d.o.eq(self.cmd.storage),
                d.oe.eq(1),
                NextState("SEND_CMD"),
            ).Elif(self.data.re,
                wrx.eq(0),
                dcx.eq(1),
                d.o.eq(self.data.storage),
                d.oe.eq(1),
                NextState("SEND_DATA"),
            ).Elif(self.ctrl.fields.read,
                rdx.eq(0),
                dcx.eq(1),
                d.oe.eq(0),
                NextState("READ_DATA"),
            ).Elif(self.tpg.fields.rainbow,
                wrx.eq(0),
                d.o.eq(0x2c),
                d.oe.eq(1),
                NextValue(idx_counter, 1),
                NextState("START_SEND_RAINBOW"),
            ).Elif(self.tpg.fields.bluething,
                wrx.eq(0),
                d.o.eq(0x2c),
                d.oe.eq(1),
                NextValue(idx_counter, 1),
                NextState("START_SEND_BLUETHING"),
            )
        )

        fsm.act("SEND_DATA",
            dcx.eq(1),
            wrx.eq(1),
            rdx.eq(1),
            d.o.eq(self.data.storage),
            d.oe.eq(1),
            NextState("IDLE"),
        )

        fsm.act("SEND_CMD",
            dcx.eq(0),
            wrx.eq(1),
            rdx.eq(1),
            d.o.eq(self.cmd.storage),
            d.oe.eq(1),
            NextState("IDLE"),
        )

        fsm.act("READ_DATA",
            dcx.eq(1),
            wrx.eq(1),
            rdx.eq(1),
            d.oe.eq(0),
            NextValue(self.response.storage, d.i),
            NextState("IDLE"),
        )

        offset_counter = Signal(16)
        x = Signal(9)
        y = Signal(9)

        fsm.act("START_SEND_RAINBOW",
            NextValue(x, 0),
            NextValue(y, 0),
            wrx.eq(1),
            rdx.eq(1),
            dcx.eq(1),
            d.o.eq(0x2c),
            d.oe.eq(1),
            NextState("SEND_RAINBOW")
        )

        fsm.act("SEND_RAINBOW",
            dcx.eq(1),
            rdx.eq(1),
            wrx.eq(idx_counter[0]),
            NextValue(idx_counter, idx_counter + 1),

            # If the bottom bit is set, then increment X and/or Y.
            # We do it this way because of how the LCD encoding works.
            If(idx_counter[0],
                If(x < 479,
                    NextValue(x, x + 1)
                ).Else(
                    NextValue(x, 0),
                    If(y < 319,
                        NextValue(y, y + 1),
                    ).Else(
                        NextValue(y, 0),
                    )
                ),
            ),

            # Assign the actual pixel data
            If(y < 90,
                d.o.eq(Cat(x[0:5], Signal(6), Signal(5)))
            ).Elif(y < 180,
                d.o.eq(Cat(Signal(5), x[0:6], Signal(6)))
            ).Else(
                d.o.eq(Cat(Signal(5), Signal(6), x[0:5]))
            ),
            d.oe.eq(1),
            If(~self.tpg.fields.rainbow,
                NextState("IDLE"),
            ),
        )

        fsm.act("START_SEND_BLUETHING",
            wrx.eq(1),
            rdx.eq(1),
            dcx.eq(1),
            d.o.eq(0x2c),
            d.oe.eq(1),
            NextState("SEND_BLUETHING")
        )

        fsm.act("SEND_BLUETHING",
            dcx.eq(1),
            rdx.eq(1),
            wrx.eq(idx_counter[0]),
            self.wheel.pos.eq(idx_counter[6:] + offset_counter[15:]),
            If(idx_counter > 320 * 2,
                NextValue(idx_counter, 0)
            ).Else(
                NextValue(idx_counter, idx_counter + 1 + pads.fmark),
            ),
            NextValue(offset_counter, offset_counter + 1),
            d.oe.eq(1),
            d.o.eq(Cat(self.wheel.r[0:6], self.wheel.g[0:6], self.wheel.b[0:6])),
            If(~self.tpg.fields.bluething,
                NextState("IDLE"),
            ),
        )

class Wheel(Module):
    """Color wheel

    Generate an RGB value from a given wheel index (0-255)
    """
    def __init__(self):
        self.pos = Signal(8)
        self.r = Signal(8)
        self.g = Signal(8)
        self.b = Signal(8)

        pos_1 = Signal(8)
        pos_1_n = Signal(8)
        pos_check = Signal(8)
        pos_2 = Signal(8)
        pos_2_n = Signal(8)
        pos_3 = Signal(8)
        pos_3_n = Signal(8)
        # Input a value 0 to 255 to get a color value.
        # The colours are a transition r - g - b - back to r.
        self.comb += [
            pos_check.eq(255 - self.pos),

            pos_1.eq(pos_check * 3),
            pos_1_n.eq(255 - pos_1),

            pos_2.eq((pos_check - 85) * 3),
            pos_2_n.eq(255 - pos_2),

            pos_3.eq((pos_check - 170) * 3),
            pos_3_n.eq(255 - pos_3),

            If(pos_check < 85,
                self.r.eq(pos_1_n),
                self.g.eq(0),
                self.b.eq(pos_1),
            ).Elif(pos_check < 170,
                self.r.eq(0),
                self.g.eq(pos_2),
                self.b.eq(pos_2_n),
            )
            .Else(
                self.r.eq(pos_3),
                self.g.eq(pos_3_n),
                self.b.eq(0),
            )
        ]