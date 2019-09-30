import subprocess

from migen.fhdl.module import Module, If
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect.csr import CSRStorage, CSRStatus, CSRField, AutoCSR

class Reboot(Module, AutoCSR, AutoDoc):
    def __init__(self, pin):
        self.reboot = CSRStorage(8, description="Write `0xac` here to reboot the device")
        self.intro = ModuleDoc(title="Reboot Control", body="""
        Access reboot control for the badge.  Write the key to ``reboot`` in
        order to initiate a reboot.""")
        self.comb += If(self.reboot.storage != 0xac, pin.eq(1))