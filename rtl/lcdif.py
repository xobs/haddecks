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

        # Data pins
        d = Signal(18)

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
            pads.db.eq(d),
            pads.rs.eq(dcx),
            pads.wr.eq(wrx),
            pads.rd.eq(rdx),
            te.eq(pads.fmark),
        ]

        self.submodules.fsm = fsm = FSM()

        fsm.act("IDLE",
            wrx.eq(1),
            rdx.eq(1),
            NextValue(self.response.storage, d),
            If(self.cmd.re,
                wrx.eq(0),
                d.eq(self.cmd.storage),
                NextState("SEND_CMD"),
            ).Elif(self.data.re,
                wrx.eq(0),
                dcx.eq(1),
                d.eq(self.data.storage),
                NextState("SEND_DATA"),
            ).Elif(self.ctrl.fields.read,
                rdx.eq(0),
                dcx.eq(1),
                NextState("READ_DATA"),
            ),
        )

        fsm.act("SEND_DATA",
            dcx.eq(1),
            wrx.eq(1),
            rdx.eq(1),
            d.eq(self.data.storage),
            NextState("IDLE"),
        )

        fsm.act("SEND_CMD",
            dcx.eq(0),
            wrx.eq(1),
            rdx.eq(1),
            d.eq(self.cmd.storage),
            NextState("IDLE"),
        )

        fsm.act("READ_DATA",
            dcx.eq(1),
            wrx.eq(1),
            rdx.eq(1),
            NextState("IDLE"),
        )