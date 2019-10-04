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

	// Add ram chip 1.
	// Note that we don't feed clk into it, because iverilog
	// doesn't work correctly.
	wire [3:0] ramchip1_i;
	wire [3:0] ramchip1_o;
	wire ramchip1_oe;
	assign ramchip1_i = ramchip1_oe ? 4'bz : spiram4x0_dq;
	assign spiram4x0_dq = ramchip1_oe ? ramchip1_o : 4'bz;
	spiram ramchip1 (
		.spi_ncs(spiram4x0_cs_n),
		// .spi_clk(spiram4x0_clk),
		.spi_clk(clk48),
		.spi_sin(ramchip1_i),
		.spi_sout(ramchip1_o),
		.spi_oe(ramchip1_oe)
	);


	wire [3:0] ramchip2_i;
	wire [3:0] ramchip2_o;
	wire ramchip2_oe;
	assign ramchip2_i = ramchip2_oe ? 4'bz : spiram4x1_dq;
	assign spiram4x1_dq = ramchip2_oe ? ramchip2_o : 4'bz;

	spiram ramchip2 (
		.spi_ncs(spiram4x1_cs_n),
		// .spi_clk(spiram4x1_clk),
		.spi_clk(clk48),
		.spi_sin(ramchip2_i),
		.spi_sout(ramchip2_o),
		.spi_oe(ramchip2_oe)
	);

  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
