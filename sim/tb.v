`timescale 100ps / 100ps

module tb(
	input clk48,
	input reset,
	inout usb_d_p,
	inout usb_d_n,
	output usb_pullup,
	output usb_tx_en,
	output spiram4x0_cs_n,
	output spiram4x0_clk,
	inout [3:0] spiram4x0_dq,
	output spiram4x1_cs_n,
	output spiram4x1_clk,
	inout [3:0] spiram4x1_dq,
	input [29:0] wishbone_adr,
	output [31:0] wishbone_datrd,
	input [31:0] wishbone_datwr,
	input [3:0] wishbone_sel,
	input wishbone_cyc,
	input wishbone_stb,
	output wishbone_ack,
	input wishbone_we,
	input [2:0] wishbone_cti,
	input [1:0] wishbone_bte,
	input [4095:0] test_name,
	output wishbone_err
);

dut dut (
	.clk8(clk48),
	.reset(reset),
	.spiram4x0_cs_n(spiram4x0_cs_n),
	.spiram4x0_clk(spiram4x0_clk),
	.spiram4x0_dq(spiram4x0_dq),
	.spiram4x1_cs_n(spiram4x1_cs_n),
	.spiram4x1_clk(spiram4x1_clk),
	.spiram4x1_dq(spiram4x1_dq),
	.wishbone_adr(wishbone_adr),
	.wishbone_dat_r(wishbone_datrd),
	.wishbone_dat_w(wishbone_datwr),
	.wishbone_sel(wishbone_sel),
	.wishbone_cyc(wishbone_cyc),
	.wishbone_stb(wishbone_stb),
	.wishbone_ack(wishbone_ack),
	.wishbone_we(wishbone_we),
	.wishbone_cti(wishbone_cti),
	.wishbone_bte(wishbone_bte),
	.wishbone_err(wishbone_err)
);

spiram ramchip1 (
	.csn(spiram4x0_cs_n),
	.clk(spiram4x0_clk),
	.io0(spiram4x0_dq[0]), // MOSI
	.io1(spiram4x0_dq[1]), // MISO
	.io2(spiram4x0_dq[2]),
	.io3(spiram4x0_dq[3])
);

spiram ramchip2 (
	.csn(spiram4x1_cs_n),
	.clk(spiram4x1_clk),
	.io0(spiram4x1_dq[0]), // MOSI
	.io1(spiram4x1_dq[1]), // MISO
	.io2(spiram4x1_dq[2]),
	.io3(spiram4x1_dq[3])
);

  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
