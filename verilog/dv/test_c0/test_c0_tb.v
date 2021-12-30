// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype wire

`timescale 1 ns / 1 ps

`include "uprj_netlists.v"
`include "c0_uart_prog_tb.v"
`include "caravel_netlists.v"
`include "spiflash.v"

module test_c0_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;

	wire c0_rx, c0_tx;
	wire [31:0] buyruk, pc;
	wire buyruk_gecerli;

	assign mprj_io[0] = c0_rx;
	assign c0_tx = mprj_io[1];
	assign pc = mprj_io[33:2];
	assign buyruk_gecerli = mprj_io[34];

	always #10 clock <= (clock === 1'b0);
	
	integer ps_dump;

	always @(uut.mprj.mprj.bbb_buy_ps_g_w) begin
		#1;
		$display("---------------------", $time, "---------------------"); 
		$display("PROB_EN = %h ", uut.mprj.mprj.bbb_buy_gecerli_g_w);
		$display("PROB_PC = %h ", uut.mprj.mprj.bbb_buy_ps_g_w);
	end

	initial begin
		clock = 0;
		ps_dump = $fopen("ps_dump.txt","w");
		wait(pc == 32'h10180);	// Update this with test_prog ps_dump
		#200;
		$finish();
		$fclose(ps_dump);
	end

	always @(pc or buyruk_gecerli) begin
		if(buyruk_gecerli)
			$fwrite(ps_dump, "%h\n", pc);
	end

	// Caravel
	// ----------------------------------------------
	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#170000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end
	// Caravel Ends
	// ----------------------------------------------

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire USER_VDD3V3 = power3;
	wire USER_VDD1V8 = power4;
	wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("test_c0.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);
	
	c0_uart_prog c0_prog
	(
		.c0_rx(c0_rx),
		.c0_tx(c0_tx)
	);




endmodule
`default_nettype wire
