from migen import *
from litex.soc.cores.clock import ECP5PLL, AsyncResetSynchronizer

# CRG ----------------------------------------------------------------------------------------------

class _CRG(Module):
    """Clock Resource Generator"

    Input: 8 MHz
    Output: 48 MHz
    """
    def __init__(self, platform, fast_sysclk=False):
        self.clock_domains.cd_por = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys = ClockDomain()
        self.clock_domains.cd_clk12 = ClockDomain()
        self.clock_domains.cd_clk48 = ClockDomain()

        # # #

        self.cd_sys.clk.attr.add("keep")
        self.cd_por.clk.attr.add("keep")
        self.cd_clk12.clk.attr.add("keep")
        self.cd_clk48.clk.attr.add("keep")

        self.stop = Signal()

        # clk / rst
        clk8 = platform.request("clk8")
        # rst_n = platform.request("rst_n")
        platform.add_period_constraint(clk8, 1e9/8e6)
        if fast_sysclk:
            platform.add_period_constraint(self.cd_sys.clk, 1e9/48e6)
        else:
            platform.add_period_constraint(self.cd_sys.clk, 1e9/12e6)
        platform.add_period_constraint(self.cd_clk12.clk, 1e9/12e6)
        platform.add_period_constraint(self.cd_clk48.clk, 1e9/48e6)

        # power on reset
        por_count = Signal(16, reset=2**16-1)
        por_done = Signal()
        self.comb += self.cd_por.clk.eq(clk8)
        self.comb += por_done.eq(por_count == 0)
        self.sync.por += If(~por_done, por_count.eq(por_count - 1))

        # pll
        self.submodules.pll = pll = ECP5PLL()
        pll.register_clkin(clk8, 8e6)
        pll.create_clkout(self.cd_clk48, 48e6, phase=0, margin=1e-9)
        pll.create_clkout(self.cd_clk12, 12e6, phase=39, margin=1e-9)
        if fast_sysclk:
            self.comb += self.cd_sys.clk.eq(self.cd_clk48.clk)
        else:
            self.comb += self.cd_sys.clk.eq(self.cd_clk12.clk)

        # Synchronize USB48 and USB12, and drive USB12 from USB48
        self.specials += [
            AsyncResetSynchronizer(self.cd_clk48, ~por_done | ~pll.locked),# | ~rst_n),
            AsyncResetSynchronizer(self.cd_clk12, ~por_done | ~pll.locked),# | ~rst_n),
        ]
