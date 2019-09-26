#!/usr/bin/env python3
# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.
LX_DEPENDENCIES = ["riscv", "nextpnr-ecp5", "yosys"]

# Import lxbuildenv to integrate the deps/ directory
import lxbuildenv

# Disable pylint's E1101, which breaks completely on migen
#pylint:disable=E1101

from migen import *
from litex.build.lattice import LatticePlatform
from litex.build.generic_platform import Pins, IOStandard, Subsignal, Inverted, Misc
from litex.soc.integration import SoCCore
from litex.soc.integration.builder import Builder
from litex.soc.integration.soc_core import csr_map_update

_io = [
    ("clk8", 0, Pins("U18"), IOStandard("LVCMOS33")),
    ("serial", 0,
        Subsignal("rx", Pins("U2")),
        Subsignal("tx", Pins("U1"), Misc("PULLUP")),
        IOStandard("LVCMOS33")
    ),
    ("led", 0,
        Subsignal("led1", Pins("E3"), IOStandard("LVCMOS33")),
        Subsignal("led2", Pins("D3"), IOStandard("LVCMOS33")),
        Subsignal("led3", Pins("C3"), IOStandard("LVCMOS33")),
        Subsignal("led4", Pins("C4"), IOStandard("LVCMOS33")),
        Subsignal("led5", Pins("C2"), IOStandard("LVCMOS33")),
        Subsignal("led6", Pins("B1"), IOStandard("LVCMOS33")),
        Subsignal("led7", Pins("B20"), IOStandard("LVCMOS33")),
        Subsignal("led8", Pins("B19"), IOStandard("LVCMOS33")),
        Subsignal("led9", Pins("A18"), IOStandard("LVCMOS33")),
        Subsignal("led10", Pins("K20"), IOStandard("LVCMOS33")),
        Subsignal("led11", Pins("K19"), IOStandard("LVCMOS33")),
    ),
    ("usb", 0,
        Subsignal("d_p", Pins("F3")),
        Subsignal("d_n", Pins("G3")),
        Subsignal("pullup", Pins("E4")),
        Subsignal("vbusdet", Pins("F4")),
        IOStandard("LVCMOS33")
    ),
    ("keypad", 0,
        Subsignal("left", Pins("G2"), Misc("PULLUP")),
        Subsignal("right", Pins("F2"), Misc("PULLUP")),
        Subsignal("up", Pins("F1"), Misc("PULLUP")),
        Subsignal("down", Pins("C1"), Misc("PULLUP")),
        Subsignal("start", Pins("E1"), Misc("PULLUP")),
        Subsignal("select", Pins("D2"), Misc("PULLUP")),
        Subsignal("a", Pins("D1"), Misc("PULLUP")),
        Subsignal("b", Pins("E2"), Misc("PULLUP")),
    ),
    ("hdmi_out", 0,
        Subsignal("clk_p", Pins("P20"), Inverted(), IOStandard("TMDS_33")),
        Subsignal("clk_n", Pins("R20"), Inverted(), IOStandard("TMDS_33")),
        Subsignal("data0_p", Pins("N19"), IOStandard("TMDS_33")),
        Subsignal("data0_n", Pins("N20"), IOStandard("TMDS_33")),
        Subsignal("data1_p", Pins("L20"), IOStandard("TMDS_33")),
        Subsignal("data1_n", Pins("M20"), IOStandard("TMDS_33")),
        Subsignal("data2_p", Pins("L16"), IOStandard("TMDS_33")),
        Subsignal("data2_n", Pins("L17"), IOStandard("TMDS_33")),
        Subsignal("hpd_notif", Pins("R18"), IOStandard("LVCMOS33"), Inverted()),  # Also called HDMI_HEAC_n (note active low)
        Subsignal("hdmi_heac_p", Pins("T19"), IOStandard("LVCMOS33"), Inverted()),
    ),
    ("lcd", 0,
        Subsignal("db", Pins("J3 H1 K4 J1 K3 K2 L4 K1 L3 L2 M4 L1 M3 M1 N4 N2 N3 N1"), IOStandard("LVCMOS33")),
		Subsignal("rd", Pins("P2"), IOStandard("LVCMOS33")),
		Subsignal("wr", Pins("P4"), IOStandard("LVCMOS33")),
		Subsignal("rs", Pins("P1"), IOStandard("LVCMOS33")),
		Subsignal("cs", Pins("P3"), IOStandard("LVCMOS33")),
		Subsignal("id", Pins("J4"), IOStandard("LVCMOS33")),
		Subsignal("rst", Pins("H2"), IOStandard("LVCMOS33")),
		Subsignal("fmark", Pins("G1"), IOStandard("LVCMOS33")),
		Subsignal("blen", Pins("P5"), IOStandard("LVCMOS33")),
    ),
    ("spiflash", 0,
        Subsignal("cs_n", Pins("R2"), IOStandard("LVCMOS33")),
        Subsignal("clk", Pins("U3"), IOStandard("LVCMOS33")),
        Subsignal("mosi", Pins("W2"), IOStandard("LVCMOS33")),
        Subsignal("miso", Pins("V2"), IOStandard("LVCMOS33")),
        Subsignal("wp",   Pins("Y2"), IOStandard("LVCMOS33")),
        Subsignal("hold", Pins("W1"), IOStandard("LVCMOS33")),
    ),
    ("spiflash4x", 0,
        Subsignal("cs_n", Pins("R2"), IOStandard("LVCMOS33")),
        Subsignal("clk",  Pins("U3"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("W2 V2 Y2 W1"), IOStandard("LVCMOS33")),
    ),
    ("spiram4x", 0,
        Subsignal("cs_n", Pins("D20"), IOStandard("LVCMOS33")),
        Subsignal("clk",  Pins("E20"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("E19 D19 C20 F19"), IOStandard("LVCMOS33")),
    ),
    ("spiram4x", 1,
        Subsignal("cs_n", Pins("F20"), IOStandard("LVCMOS33")),
        Subsignal("clk",  Pins("J19"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("J20 G19 G20 F19"), IOStandard("LVCMOS33")),
    ),
    ("sao", 0,
        Subsignal("sda", Pins("B2")),
        Subsignal("scl", Pins("B3")),
        Subsignal("gpio", Pins("A2 A3 B4")),
        Subsignal("drm", Pins("A4")),
    ),
    ("sao", 1,
        Subsignal("sda", Pins("B17")),
        Subsignal("scl", Pins("A16")),
        Subsignal("gpio", Pins("B18 A17 B16")),
        Subsignal("drm", Pins("C17")),
    )
]

_connectors = [
    ("pmoda", "A15 C16 A14 D16"),
    ("pmodb", "B15 C15 A13 B13"),
    ("genio", "C5 B5 A5 C6 B6 A6 D6 C7 A7 C8 B8 A8 D9 C9 B9 A9 D10 C10 B10 A10 D11 C11 B11 A11 G18 H17 B12 A12 E17 C14"),
]

class Platform(LatticePlatform):
    def __init__(self, architecture="45k", package="CABGA381"):
        LatticePlatform.__init__(self, device="45k", io=_io, connectors=_connectors, toolchain="trellis")

    def create_programmer(self):
        raise ValueError("{} programmer is not supported"
                             .format(self.programmer))

    def do_finalize(self, fragment):
        LatticePlatform.do_finalize(self, fragment)

class BaseSoC(SoCCore):
    # csr_peripherals = [
    #     "cpu_or_bridge",
    # ]
    # csr_map_update(SoCCore.csr_map, csr_peripherals)

    def __init__(self, platform, **kwargs):
        clk_freq = int(100e6)
        SoCCore.__init__(self, platform, clk_freq,
                         cpu_variant="linux+debug",
                         **kwargs)

def main():
    platform = Platform()
    soc = BaseSoC(platform)
    builder = Builder(soc, output_dir="build", csr_csv="build/csr.csv")
    vns = builder.build()
    soc.do_exit(vns)

if __name__ == "__main__":
    main()
