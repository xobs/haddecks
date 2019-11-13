#!/usr/bin/env python3
# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.
LX_DEPENDENCIES = ["riscv", "nextpnr-ecp5", "yosys"]

# Import lxbuildenv to integrate the deps/ directory
import lxbuildenv

import argparse
import os

# Disable pylint's E1101, which breaks completely on migen
#pylint:disable=E1101

from migen import *
from litex.build.lattice import LatticePlatform
from litex.build.sim.platform import SimPlatform
from litex.build.generic_platform import Pins, IOStandard, Subsignal, Inverted, Misc
from litex.soc.integration.soc_core import SoCCore
from litex.soc.integration.builder import Builder
from litex.soc.integration.doc import AutoDoc, ModuleDoc
from litex.soc.interconnect.csr import *

from litex.soc.cores.bitbang import I2CMaster
from litex.soc.cores import gpio
from litex.soc.cores.spi_flash import SpiFlashDualQuad

from valentyusb.usbcore.cpu.dummyusb import DummyUsb
from valentyusb.usbcore import io as usbio

from rtl.crg import _CRG
from rtl.lcdif import LCDIF
from rtl.messible import Messible
from rtl.reboot import Reboot
from rtl.spi_ram import SpiRamQuad
from rtl.spi_ram_dual import SpiRamDualQuad
from rtl.version import Version
from rtl.picorvspi import PicoRVSpi

import lxsocdoc

_io = [
    ("clk8", 0, Pins("U18"), IOStandard("LVCMOS33")),
    ("programn", 0, Pins("R1"), IOStandard("LVCMOS33")),
    ("serial", 0,
        Subsignal("rx", Pins("U2"), IOStandard("LVCMOS33"), Misc("PULLMODE=UP")),
        Subsignal("tx", Pins("U1"), IOStandard("LVCMOS33")),
    ),
    ("led", 0, Pins("E3 D3 C3 C4 C2 B1 B20 B19 A18 K20 K19"), IOStandard("LVCMOS33")),  # Anodes
    ("led", 1, Pins("P19 L18 K18"), IOStandard("LVCMOS33")), # Cathodes via FET
    ("usb", 0,
        Subsignal("d_p", Pins("F3")),
        Subsignal("d_n", Pins("G3")),
        Subsignal("pullup", Pins("E4")),
        Subsignal("vbusdet", Pins("F4")),
        IOStandard("LVCMOS33")
    ),
    ("keypad", 0,
        Subsignal("left", Pins("G2"), Misc("PULLMODE=UP")),
        Subsignal("right", Pins("F2"), Misc("PULLMODE=UP")),
        Subsignal("up", Pins("F1"), Misc("PULLMODE=UP")),
        Subsignal("down", Pins("C1"), Misc("PULLMODE=UP")),
        Subsignal("start", Pins("E1"), Misc("PULLMODE=UP")),
        Subsignal("select", Pins("D2"), Misc("PULLMODE=UP")),
        Subsignal("a", Pins("D1"), Misc("PULLMODE=UP")),
        Subsignal("b", Pins("E2"), Misc("PULLMODE=UP")),
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
        Subsignal("hpd_notif", Pins("R18"), IOStandard("LVCMOS33"), Inverted()),  # Also called HDMI_HEAC_n
        Subsignal("hdmi_heac_p", Pins("T19"), IOStandard("LVCMOS33"), Inverted()),
        Misc("DRIVE=4"),
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
    ("spiflash", 0, # clock needs to be accessed through USRMCLK
        Subsignal("cs_n", Pins("R2"), IOStandard("LVCMOS33")),
        Subsignal("mosi", Pins("W2"), IOStandard("LVCMOS33")),
        Subsignal("miso", Pins("V2"), IOStandard("LVCMOS33")),
        Subsignal("wp",   Pins("Y2"), IOStandard("LVCMOS33")),
        Subsignal("hold", Pins("W1"), IOStandard("LVCMOS33")),
    ),
    ("spiflash4x", 0, # clock needs to be accessed through USRMCLK
        Subsignal("cs_n", Pins("R2"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("W2 V2 Y2 W1"), IOStandard("LVCMOS33")),
    ),
    ("spiram4x", 0,
        Subsignal("cs_n", Pins("D20"), IOStandard("LVCMOS33")),
        Subsignal("clk",  Pins("E20"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("E19 D19 C20 F19"), IOStandard("LVCMOS33"), Misc("PULLMODE=UP")),
    ),
    ("spiram4x", 1,
        Subsignal("cs_n", Pins("F20"), IOStandard("LVCMOS33")),
        Subsignal("clk",  Pins("J19"), IOStandard("LVCMOS33")),
        Subsignal("dq",   Pins("J20 G19 G20 H20"), IOStandard("LVCMOS33"), Misc("PULLMODE=UP")),
    ),
    ("sao", 0,
        Subsignal("sda", Pins("B3")),
        Subsignal("scl", Pins("B2")),
        Subsignal("gpio", Pins("A2 A3 B4")),
        Subsignal("drm", Pins("A4")),
    ),
    ("sao", 1,
        Subsignal("sda", Pins("A16")),
        Subsignal("scl", Pins("B17")),
        Subsignal("gpio", Pins("B18 A17 B16")),
        Subsignal("drm", Pins("C17")),
    ),
    ("testpts", 0,
        Subsignal("a1", Pins("A15")),
        Subsignal("a2", Pins("C16")),
        Subsignal("a3", Pins("A14")),
        Subsignal("a4", Pins("D16")),
        Subsignal("b1", Pins("B15")),
        Subsignal("b2", Pins("C15")),
        Subsignal("b3", Pins("A13")),
        Subsignal("b4", Pins("B13")),
    ),

    # Only used for simulation
    ("wishbone", 0,
        Subsignal("adr",   Pins(30)),
        Subsignal("dat_r", Pins(32)),
        Subsignal("dat_w", Pins(32)),
        Subsignal("sel",   Pins(4)),
        Subsignal("cyc",   Pins(1)),
        Subsignal("stb",   Pins(1)),
        Subsignal("ack",   Pins(1)),
        Subsignal("we",    Pins(1)),
        Subsignal("cti",   Pins(3)),
        Subsignal("bte",   Pins(2)),
        Subsignal("err",   Pins(1))
    ),
    ("reset", 0, Pins(1), IOStandard("LVCMOS33")),
]

_connectors = [
    ("pmod", "A15 C16 A14 D16 B15 C15 A13 B13"),
    ("genio", "C5 B5 A5 C6 B6 A6 D6 C7 A7 C8 B8 A8 D9 C9 B9 A9 D10 C10 B10 A10 D11 C11 B11 A11 G18 H17 B12 A12 E17 C14"),
]

_pmod_gpio = [
    ("pmod_gpio", 0,
     Subsignal("p0", Pins("pmod:0")),
     Subsignal("p1", Pins("pmod:1")),
     Subsignal("p2", Pins("pmod:2")),
     Subsignal("p3", Pins("pmod:3")),
     Subsignal("p4", Pins("pmod:4")),
     Subsignal("p5", Pins("pmod:5")),
     Subsignal("p6", Pins("pmod:6")),
     Subsignal("p7", Pins("pmod:7")),
     IOStandard("LVCMOS33")
    ),
]

_genio_gpio = [
    ("genio_gpio", 0,
     Subsignal("p0", Pins("genio:0")),
     Subsignal("p1", Pins("genio:1")),
     Subsignal("p2", Pins("genio:2")),
     Subsignal("p3", Pins("genio:3")),
     Subsignal("p4", Pins("genio:4")),
     Subsignal("p5", Pins("genio:5")),
     Subsignal("p6", Pins("genio:6")),
     Subsignal("p7", Pins("genio:7")),
     Subsignal("p8", Pins("genio:8")),
     Subsignal("p9", Pins("genio:9")),

     Subsignal("p10", Pins("genio:10")),
     Subsignal("p11", Pins("genio:11")),
     Subsignal("p12", Pins("genio:12")),
     Subsignal("p13", Pins("genio:13")),
     Subsignal("p14", Pins("genio:14")),
     Subsignal("p15", Pins("genio:15")),
     Subsignal("p16", Pins("genio:16")),
     Subsignal("p17", Pins("genio:17")),
     Subsignal("p18", Pins("genio:18")),
     Subsignal("p19", Pins("genio:19")),

     Subsignal("p20", Pins("genio:20")),
     Subsignal("p21", Pins("genio:21")),
     Subsignal("p22", Pins("genio:22")),
     Subsignal("p23", Pins("genio:23")),
     Subsignal("p24", Pins("genio:24")),
     Subsignal("p25", Pins("genio:25")),
     Subsignal("p26", Pins("genio:26")),
     Subsignal("p27", Pins("genio:27")),
     Subsignal("p28", Pins("genio:28")),
     Subsignal("p29", Pins("genio:29")),
    )
]

class GPIOBidirectional(Module, AutoCSR):
    def __init__(self, pads, disable_i2c=False):
        pad_count = len(pads)
        self._pins_in = CSRStatus(pad_count)
        self._pins_out = CSRStorage(pad_count)
        self._pins_oe = CSRStorage(pad_count)
        gpio_pins_t = [None] * pad_count
        bit = 0
        for pin_group in pads.layout:
            if disable_i2c or (pin_group[0] != "scl" and pin_group[0] != "sda") :
                for pin in getattr(pads, pin_group[0]):
                    gpio_pins_t[bit] = TSTriple()
                    self.specials += gpio_pins_t[bit].get_tristate(pin)
                    self.comb += gpio_pins_t[bit].o.eq(self._pins_out.storage[bit])
                    self.comb += gpio_pins_t[bit].oe.eq(self._pins_oe.storage[bit])
                    self.comb += self._pins_in.status[bit].eq(gpio_pins_t[bit].i)
                    bit=bit+1
            else:
                # skip i2c pins
                bit=bit+1

class ShittyAddOn(Module, AutoCSR):
    def __init__(self, platform, pads, disable_i2c=False):
        pad_count = len(pads)
        if not disable_i2c:
            self.i2c_master = I2CMaster(pads)
        self.gpio = GPIOBidirectional(pads, disable_i2c)

    def get_fragment(self):
        fragment = super().get_fragment()
        if getattr(self, "i2c_master", None):
            fragment += self.i2c_master.get_fragment()
        fragment += self.gpio.get_fragment()
        return fragment

class CocotbPlatform(SimPlatform):
    def __init__(self, toolchain="verilator"):
        SimPlatform.__init__(self, "sim", _io, _connectors, toolchain="verilator")

    def create_programmer(self):
        raise ValueError("programming is not supported")

    class _CRG(Module):
        def __init__(self, platform):
            clk8 = platform.request("clk8")
            rst = platform.request("reset")

            clk12 = Signal()

            self.clock_domains.cd_sys = ClockDomain()
            self.clock_domains.cd_clk12 = ClockDomain()
            self.clock_domains.cd_clk48 = ClockDomain()
            self.clock_domains.cd_clk48_to_clk12 = ClockDomain()

            clk48 = clk8 # We actually run this at 48 MHz

            self.comb += self.cd_clk48.clk.eq(clk48)
            self.comb += self.cd_clk48_to_clk12.clk.eq(clk48)

            clk12_counter = Signal(2)
            self.sync.clk48_to_clk12 += clk12_counter.eq(clk12_counter + 1)

            self.comb += clk12.eq(clk12_counter[1])

            self.comb += self.cd_sys.clk.eq(clk48)
            self.comb += self.cd_clk12.clk.eq(clk12)

            self.comb += [
                ResetSignal("sys").eq(rst),
                ResetSignal("clk12").eq(rst),
                ResetSignal("clk48").eq(rst),
            ]
    def add_fsm_state_names():
        """Hack the FSM module to add state names to the output"""
        from migen.fhdl.visit import NodeTransformer
        from migen.genlib.fsm import NextState, NextValue, _target_eq
        from migen.fhdl.bitcontainer import value_bits_sign

        class My_LowerNext(NodeTransformer):
            def __init__(self, next_state_signal, next_state_name_signal, encoding, aliases):
                self.next_state_signal = next_state_signal
                self.next_state_name_signal = next_state_name_signal
                self.encoding = encoding
                self.aliases = aliases
                # (target, next_value_ce, next_value)
                self.registers = []

            def _get_register_control(self, target):
                for x in self.registers:
                    if _target_eq(target, x[0]):
                        return x[1], x[2]
                raise KeyError

            def visit_unknown(self, node):
                if isinstance(node, NextState):
                    try:
                        actual_state = self.aliases[node.state]
                    except KeyError:
                        actual_state = node.state
                    return [
                        self.next_state_signal.eq(self.encoding[actual_state]),
                        self.next_state_name_signal.eq(int.from_bytes(actual_state.encode(), byteorder="big"))
                    ]
                elif isinstance(node, NextValue):
                    try:
                        next_value_ce, next_value = self._get_register_control(node.target)
                    except KeyError:
                        related = node.target if isinstance(node.target, Signal) else None
                        next_value = Signal(bits_sign=value_bits_sign(node.target), related=related)
                        next_value_ce = Signal(related=related)
                        self.registers.append((node.target, next_value_ce, next_value))
                    return next_value.eq(node.value), next_value_ce.eq(1)
                else:
                    return node
        import migen.genlib.fsm as fsm
        def my_lower_controls(self):
            self.state_name = Signal(len(max(self.encoding,key=len))*8, reset=int.from_bytes(self.reset_state.encode(), byteorder="big"))
            self.next_state_name = Signal(len(max(self.encoding,key=len))*8, reset=int.from_bytes(self.reset_state.encode(), byteorder="big"))
            self.comb += self.next_state_name.eq(self.state_name)
            self.sync += self.state_name.eq(self.next_state_name)
            return My_LowerNext(self.next_state, self.next_state_name, self.encoding, self.state_aliases)
        fsm.FSM._lower_controls = my_lower_controls

class BadgePlatform(LatticePlatform):
    def __init__(self):
        LatticePlatform.__init__(self, device="LFE5U-45F-CABGA381", io=_io, connectors=_connectors, toolchain="trellis")

    def create_programmer(self):
        raise ValueError("{} programmer is not supported"
                             .format(self.programmer))

    def do_finalize(self, fragment):
        LatticePlatform.do_finalize(self, fragment)

class BaseSoC(SoCCore, AutoDoc):
    SoCCore.csr_map = {
        "ctrl":           0,  # provided by default (optional)
        "crg":            1,  # user
        "uart_phy":       2,  # provided by default (optional)
        "uart":           3,  # provided by default (optional)
        "identifier_mem": 4,  # provided by default (optional)
        "timer0":         5,  # provided by default (optional)
        "picorvspi":      7,
        "lcdif":          8,
        "usb":            9,
        "reboot":         12,
        "rgb":            13,
        "version":        14,
        "lxspi":          15,
        "messible":       16,
    }

    # We must define memory offsets here rather than using the litex
    # defaults.  This is because the mmu only allows for certain
    # regions to be unbuffered:
    # https://github.com/m-labs/VexRiscv-verilog/blob/master/src/main/scala/vexriscv/GenCoreDefault.scala#L139-L143
    SoCCore.mem_map = {
        "rom":          0x00000000,
        "sram":         0x10000000,
        "emulator_ram": 0x20000000,
        "ethmac":       0x30000000,
        "spiflash":     0x50000000,
        "main_ram":     0xc0000000,
        "csr":          0xe0000000,
    }

    def __init__(self, platform, is_sim=False, debug=True, **kwargs):
        clk_freq = int(48e6)
        SoCCore.__init__(self, platform, clk_freq,
                         integrated_rom_size=16384,
                         integrated_sram_size=65536,
                        #  wishbone_timeout_cycles=1e8,
                         **kwargs)
        if is_sim:
            self.submodules.crg = CocotbPlatform._CRG(self.platform)
        else:
            self.submodules.crg = _CRG(self.platform)

        # Add a "Version" module so we can see what version of the board this is.
        self.submodules.version = Version("proto2", [
            (0x02, "proto2", "Prototype Version 2 (red)")
        ], 0)

        # Add a "USB" module to let us debug the device.
        usb_pads = platform.request("usb")
        usb_iobuf = usbio.IoBuf(usb_pads.d_p, usb_pads.d_n, usb_pads.pullup)
        self.submodules.usb = ClockDomainsRenamer({
            "usb_48": "clk48",
            "usb_12": "clk12",
        })(DummyUsb(usb_iobuf, debug=debug, product="Hackaday Supercon Badge"))

        if debug:
            self.add_wb_master(self.usb.debug_bridge.wishbone)

            if self.cpu_type is not None:
                self.register_mem("vexriscv_debug", 0xf00f0000, self.cpu.debug_bus, 0x200)
                self.cpu.use_external_variant("rtl/VexRiscv_HaD_Debug.v")
        elif self.cpu_type is not None:
            self.cpu.use_external_variant("rtl/VexRiscv_HaD.v")

        # Add the 16 MB SPI flash as XIP memory at address 0x03000000
        if not is_sim:
            # flash = SpiFlashDualQuad(platform.request("spiflash4x"), dummy=5)
            # flash.add_clk_primitive(self.platform.device)
            # self.submodules.lxspi = flash
            # self.register_mem("spiflash", 0x03000000, self.lxspi.bus, size=16 * 1024 * 1024)
            self.submodules.picorvspi = flash = PicoRVSpi(self.platform, pads=platform.request("spiflash"), size=16 * 1024 * 1024)
            self.register_mem("spiflash", self.mem_map["spiflash"], self.picorvspi.bus, size=self.picorvspi.size)

        # # Add the 16 MB SPI RAM at address 0x40000000 # Value at 40010000: afbfcfef
        reset_cycles = 2**14-1
        if is_sim:
            reset_cycles = 0
        ram = SpiRamDualQuad(platform.request("spiram4x", 0), platform.request("spiram4x", 1), dummy=5, reset_cycles=reset_cycles, qpi=False)
        self.submodules.ram = ram
        self.register_mem("main_ram", self.mem_map["main_ram"], self.ram.bus, size=16 * 1024 * 1024)

        # Let us reboot the device
        self.submodules.reboot = Reboot(platform.request("programn"))

        # Add a Messible for sending messages to the host
        self.submodules.messible = Messible()

        # Add an LCD so we can see what's up
        self.submodules.lcdif = LCDIF(platform.request("lcd"))

        # Ensure timing is correctly set up
        if not is_sim:
            self.platform.toolchain.build_template[1] += " --speed 8" # Add "speed grade 8" to nextpnr-ecp5
            self.platform.toolchain.freq_constraints["sys"] = 48

        if is_sim:
            self.add_wb_master(self.platform.request("wishbone"))

        # SAO
        self.submodules.sao0 = ShittyAddOn(self.platform, self.platform.request("sao", 0),  disable_i2c=kwargs["sao0_disable_i2c"]);
        self.add_csr("sao0")
        self.submodules.sao1 = ShittyAddOn(self.platform, self.platform.request("sao", 1),  disable_i2c=kwargs["sao1_disable_i2c"]);
        self.add_csr("sao1")
        # PMOD
        platform.add_extension(_pmod_gpio)
        self.submodules.pmod = GPIOBidirectional(self.platform.request("pmod_gpio"))
        self.add_csr("pmod")
        # GENIO
        platform.add_extension(_genio_gpio)
        self.submodules.genio = GPIOBidirectional(self.platform.request("genio_gpio"))
        self.add_csr("genio")
        # LEDs
        self.submodules.led0 = gpio.GPIOOut(self.platform.request("led", 0))
        self.add_csr("led0")
        self.submodules.led1 = gpio.GPIOOut(self.platform.request("led", 1))
        self.add_csr("led1")
        # Keypad
        self.submodules.keypad = gpio.GPIOIn(Cat(self.platform.request("keypad", 0).flatten()))
        self.add_csr("keypad")

def main():
    parser = argparse.ArgumentParser(description="Build the Hack a Day Supercon 2019 Badge firmware")
    parser.add_argument(
        "-D", "--document-only", action="store_true", help="don't build software or gateware, only build documentation",
    )
    parser.add_argument(
        "--sim", help="generate files for simulation", action="store_true"
    )
    parser.add_argument(
        "--no-cpu", help="don't generate a cpu", action="store_true"
    )
    parser.add_argument(
        "--no-debug", help="don't generate the debug bus", action="store_true"
    )
    parser.add_argument(
        "--sao0-disable-i2c", help="Disable i2c on sao0", action="store_true"
    )
    parser.add_argument(
        "--sao1-disable-i2c", help="Disable i2c on sao1", action="store_true"
    )
    args = parser.parse_args()

    compile_gateware = True
    compile_software = True

    if args.sim:
        compile_gateware = False
        compile_software = False
        platform = CocotbPlatform()
        CocotbPlatform.add_fsm_state_names()
    else:
        platform = BadgePlatform()

    if args.document_only:
        compile_gateware = False
        compile_software = False

    cpu_type = "vexriscv"
    cpu_variant = "linux+debug"
    if args.no_debug:
        cpu_variant = "linux"

    if args.no_cpu or args.sim:
        cpu_type = None
        cpu_variant = None

    soc = BaseSoC(platform, is_sim=args.sim, debug=not args.no_debug,
                            cpu_type=cpu_type, cpu_variant=cpu_variant,
                            sao0_disable_i2c=args.sao0_disable_i2c,
                            sao1_disable_i2c=args.sao1_disable_i2c,
    )
    builder = Builder(soc, output_dir="build",
                            csr_csv="build/csr.csv",
                            compile_software=compile_software,
                            compile_gateware=compile_gateware)
    # # If we comile software, pull the code from somewhere other than
    # # the built-in litex "bios" binary, which makes assumptions about
    # # what peripherals are available.
    # if compile_software:
    #     builder.software_packages = [
    #         ("bios", os.path.abspath(os.path.join(os.path.dirname(__file__), "rom")))
    #     ]
    vns = builder.build()
    soc.do_exit(vns)
    lxsocdoc.generate_docs(soc, builder.output_dir + "/documentation", project_name="Hack a Day Supercon 2019 Badge", author="Sean \"xobs\" Cross")

if __name__ == "__main__":
    main()
