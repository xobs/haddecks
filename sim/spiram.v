module spiram (
	input csn,
	input clk,
	inout io0, // MOSI
	inout io1, // MISO
	inout io2,
	inout io3
);

	reg io0_oe = 0;
	reg io1_oe = 0;
	reg io2_oe = 0;
	reg io3_oe = 0;

	reg io0_dout = 0;
	reg io1_dout = 0;
	reg io2_dout = 0;
	reg io3_dout = 0;

	assign #1 io0 = io0_oe ? io0_dout : 1'bz;
	assign #1 io1 = io1_oe ? io1_dout : 1'bz;
	assign #1 io2 = io2_oe ? io2_dout : 1'bz;
	assign #1 io3 = io3_oe ? io3_dout : 1'bz;

    // 8 MB memory chip
	reg [7:0] memory [0:8*1024*1024-1];
	reg [1023:0] firmware_file;
	initial begin
		if (!$value$plusargs("firmware=%s", firmware_file))
			firmware_file = "firmware.hex";
        // Fill this with multiple lines of the string "00"
        // e.g. `yes 00 | head -n 1024 > firmware.hex`
		$readmemh(firmware_file, memory);
	end

    reg [23:0] counter = 0;
    reg [7:0] cmd = 0;
    reg [23:0] addr = 0;
    reg [7:0] next_byte = 0;
    reg nybble = 0;
    reg started = 0;
    reg reset = 1;

    always @(*)
    begin
        if(csn & ~reset)
        begin
            reset <= 1;
            counter <= 0;
            addr <= 0;
            cmd <= 0;
            nybble <= 0;
            started <= 0;
        end
    end

    always @(posedge clk)
    begin
        reset <= 0;
        counter <= counter + 1;

        if (counter <= 8)
        begin
            cmd <= {cmd, io0};//(cmd << 1) | io0;
            io0_oe <= 0;
            io1_oe <= 0;
            io2_oe <= 0;
            io3_oe <= 0;
        end else if (counter <= 8 + 7)
        begin
            io0_oe <= 0;
            io1_oe <= 0;
            io2_oe <= 0;
            io3_oe <= 0;
            addr <= {addr, io3, io2, io1, io0};
        end else begin
            if (cmd == 8'h eb) // Quad Fast Read
            begin
                if (counter <= 8 + 7 + 5)
                begin
                    io0_oe <= 0;
                    io1_oe <= 0;
                    io2_oe <= 0;
                    io3_oe <= 0;
                    io0_dout <= memory[addr][0];
                    io1_dout <= memory[addr][1];
                    io2_dout <= memory[addr][2];
                    io3_dout <= memory[addr][3];
                end else begin
                    io0_oe <= 1;
                    io1_oe <= 1;
                    io2_oe <= 1;
                    io3_oe <= 1;
                    nybble <= ~nybble;
                    if (nybble)
                    begin
                        addr <= addr + 1;
                        io0_dout <= memory[addr][4];
                        io1_dout <= 1;//memory[addr][5] ^ addr[0];
                        io2_dout <= 1;//memory[addr][6];
                        io3_dout <= memory[addr][7] ^ addr[1];
                    end else begin
                        io0_dout <= 1;//memory[addr][0];
                        io1_dout <= memory[addr][1];
                        io2_dout <= memory[addr][2];
                        io3_dout <= memory[addr][3];
                    end
                end
            end else if (cmd == 8'h 38) // Quad Write
            begin
                io0_oe <= 0;
                io1_oe <= 0;
                io2_oe <= 0;
                io3_oe <= 0;
                next_byte <= {next_byte[3:0], io3, io2, io1, io0};
                nybble <= ~nybble;
                if (nybble == 1)
                begin
                    if(started)
                    begin
                        addr <= addr + 1;
                        memory[addr] <= next_byte;
                    end
                    else begin
                        started <= 1;
                    end
                end
            end
        end
    end
endmodule