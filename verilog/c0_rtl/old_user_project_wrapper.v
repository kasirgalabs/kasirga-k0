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

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

//assign io_oeb[1] = 1'b0;


wire                                         vb_clk0                 ;
wire                                         vb_csb0                 ;
wire                                         vb_web0                 ;
wire         [3:0]                           vb_wmask0               ;
wire         [12:0]                          vb_addr0                ;
wire         [31:0]                          vb_din0                 ;
wire         [31:0]                          vb_dout0                ;
wire                                         vb_clk1                 ;
wire                                         vb_csb1                 ;
wire         [12:0]                          vb_addr1                ;
wire         [31:0]                          vb_dout1                ;
wire                                         bb_clk0                 ;
wire                                         bb_csb0                 ;
wire                                         bb_web0                 ;
wire         [3:0]                           bb_wmask0               ;
wire         [`BB_ADRES_BIT-1:0]             bb_addr0                ;
wire         [31:0]                          bb_din0                 ;
wire         [31:0]                          bb_dout0                ;
wire                                         bb_clk1                 ;
wire                                         bb_csb1                 ;
wire         [`BB_ADRES_BIT-1:0]             bb_addr1                ;
wire         [31:0]                          bb_dout1                ;    


c0_system mprj (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif
        
    .clk_g      (user_clock2),
    .rst_g      (wb_rst_i),

    //.la_data_in (la_data_in),
	//.la_data_out(la_data_out),

    .rx         (io_in[0]),
    .tx         (io_out[1]),

    .bb_csb0                                           (bb_csb0)                                                       ,
    .bb_web0                                           (bb_web0)                                                       ,
    .bb_wmask0                                         (bb_wmask0)                                                     ,
    .bb_addr0                                          (bb_addr0)                                                      ,
    .bb_din0                                           (bb_din0)                                                       ,
    .bb_dout0                                          (bb_dout0)                                                      ,

    .bb_csb1                                           (bb_csb1)                                                       ,
    .bb_addr1                                          (bb_addr1)                                                      ,
    .bb_dout1                                          (bb_dout1)                                                      ,

    .vb_csb0                                           (vb_csb0)                                                       ,
    .vb_web0                                           (vb_web0)                                                       ,
    .vb_wmask0                                         (vb_wmask0)                                                     ,
    .vb_addr0                                          (vb_addr0)                                                      ,
    .vb_din0                                           (vb_din0)                                                       ,
    .vb_dout0                                          (vb_dout0)                                                      ,

    .vb_csb1                                           (vb_csb1)                                                       ,
    .vb_addr1                                          (vb_addr1)                                                      ,
    .vb_dout1                                          (vb_dout1)                                                      ,
);

sky130_sram_1kbyte_1rw1r_32x256_8 VB_SRAM
(
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
    `endif        

    .clk0               (user_clock2)        ,
    .csb0               (vb_csb0)        ,
    .web0               (vb_web0)        ,
    .wmask0             (vb_wmask0)      ,
    .addr0              (vb_addr0)       ,
    .din0               (vb_din0)        ,
    .dout0              (vb_dout0)       ,
    .clk1               (user_clock2)        ,
    .csb1               (vb_csb1)        ,
    .addr1              (vb_addr1)       ,
    .dout1              (vb_dout1)     
);

sky130_sram_1kbyte_1rw1r_32x256_8 BB_SRAM
(
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),
        .vssd1(vssd1),
    `endif        

    .clk0               (user_clock2)      ,
    .csb0               (bb_csb0)      ,
    .web0               (bb_web0)      ,
    .wmask0             (bb_wmask0)    ,
    .addr0              (bb_addr0)     ,
    .din0               (bb_din0)      ,
    .dout0              (bb_dout0)     ,
    .clk1               (user_clock2)      ,
    .csb1               (bb_csb1)      ,
    .addr1              (bb_addr1)     ,
    .dout1              (bb_dout1)   
);

endmodule	// user_project_wrapper

`default_nettype wire
