module user_project_wrapper (user_clock2,
    vccd1,
    vccd2,
    vdda1,
    vdda2,
    vssa1,
    vssa2,
    vssd1,
    vssd2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vccd1;
 input vccd2;
 input vdda1;
 input vdda2;
 input vssa1;
 input vssa2;
 input vssd1;
 input vssd2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \bb_addr0[0] ;
 wire \bb_addr0[10] ;
 wire \bb_addr0[11] ;
 wire \bb_addr0[12] ;
 wire \bb_addr0[13] ;
 wire \bb_addr0[14] ;
 wire \bb_addr0[15] ;
 wire \bb_addr0[16] ;
 wire \bb_addr0[17] ;
 wire \bb_addr0[18] ;
 wire \bb_addr0[19] ;
 wire \bb_addr0[1] ;
 wire \bb_addr0[20] ;
 wire \bb_addr0[21] ;
 wire \bb_addr0[22] ;
 wire \bb_addr0[23] ;
 wire \bb_addr0[24] ;
 wire \bb_addr0[25] ;
 wire \bb_addr0[26] ;
 wire \bb_addr0[27] ;
 wire \bb_addr0[28] ;
 wire \bb_addr0[29] ;
 wire \bb_addr0[2] ;
 wire \bb_addr0[30] ;
 wire \bb_addr0[31] ;
 wire \bb_addr0[3] ;
 wire \bb_addr0[4] ;
 wire \bb_addr0[5] ;
 wire \bb_addr0[6] ;
 wire \bb_addr0[7] ;
 wire \bb_addr0[8] ;
 wire \bb_addr0[9] ;
 wire \bb_addr1[0] ;
 wire \bb_addr1[10] ;
 wire \bb_addr1[11] ;
 wire \bb_addr1[12] ;
 wire \bb_addr1[13] ;
 wire \bb_addr1[14] ;
 wire \bb_addr1[15] ;
 wire \bb_addr1[16] ;
 wire \bb_addr1[17] ;
 wire \bb_addr1[18] ;
 wire \bb_addr1[19] ;
 wire \bb_addr1[1] ;
 wire \bb_addr1[20] ;
 wire \bb_addr1[21] ;
 wire \bb_addr1[22] ;
 wire \bb_addr1[23] ;
 wire \bb_addr1[24] ;
 wire \bb_addr1[25] ;
 wire \bb_addr1[26] ;
 wire \bb_addr1[27] ;
 wire \bb_addr1[28] ;
 wire \bb_addr1[29] ;
 wire \bb_addr1[2] ;
 wire \bb_addr1[30] ;
 wire \bb_addr1[31] ;
 wire \bb_addr1[3] ;
 wire \bb_addr1[4] ;
 wire \bb_addr1[5] ;
 wire \bb_addr1[6] ;
 wire \bb_addr1[7] ;
 wire \bb_addr1[8] ;
 wire \bb_addr1[9] ;
 wire bb_csb0;
 wire bb_csb1;
 wire \bb_din0[0] ;
 wire \bb_din0[10] ;
 wire \bb_din0[11] ;
 wire \bb_din0[12] ;
 wire \bb_din0[13] ;
 wire \bb_din0[14] ;
 wire \bb_din0[15] ;
 wire \bb_din0[16] ;
 wire \bb_din0[17] ;
 wire \bb_din0[18] ;
 wire \bb_din0[19] ;
 wire \bb_din0[1] ;
 wire \bb_din0[20] ;
 wire \bb_din0[21] ;
 wire \bb_din0[22] ;
 wire \bb_din0[23] ;
 wire \bb_din0[24] ;
 wire \bb_din0[25] ;
 wire \bb_din0[26] ;
 wire \bb_din0[27] ;
 wire \bb_din0[28] ;
 wire \bb_din0[29] ;
 wire \bb_din0[2] ;
 wire \bb_din0[30] ;
 wire \bb_din0[31] ;
 wire \bb_din0[3] ;
 wire \bb_din0[4] ;
 wire \bb_din0[5] ;
 wire \bb_din0[6] ;
 wire \bb_din0[7] ;
 wire \bb_din0[8] ;
 wire \bb_din0[9] ;
 wire \bb_dout0[0] ;
 wire \bb_dout0[10] ;
 wire \bb_dout0[11] ;
 wire \bb_dout0[12] ;
 wire \bb_dout0[13] ;
 wire \bb_dout0[14] ;
 wire \bb_dout0[15] ;
 wire \bb_dout0[16] ;
 wire \bb_dout0[17] ;
 wire \bb_dout0[18] ;
 wire \bb_dout0[19] ;
 wire \bb_dout0[1] ;
 wire \bb_dout0[20] ;
 wire \bb_dout0[21] ;
 wire \bb_dout0[22] ;
 wire \bb_dout0[23] ;
 wire \bb_dout0[24] ;
 wire \bb_dout0[25] ;
 wire \bb_dout0[26] ;
 wire \bb_dout0[27] ;
 wire \bb_dout0[28] ;
 wire \bb_dout0[29] ;
 wire \bb_dout0[2] ;
 wire \bb_dout0[30] ;
 wire \bb_dout0[31] ;
 wire \bb_dout0[3] ;
 wire \bb_dout0[4] ;
 wire \bb_dout0[5] ;
 wire \bb_dout0[6] ;
 wire \bb_dout0[7] ;
 wire \bb_dout0[8] ;
 wire \bb_dout0[9] ;
 wire \bb_dout1[0] ;
 wire \bb_dout1[10] ;
 wire \bb_dout1[11] ;
 wire \bb_dout1[12] ;
 wire \bb_dout1[13] ;
 wire \bb_dout1[14] ;
 wire \bb_dout1[15] ;
 wire \bb_dout1[16] ;
 wire \bb_dout1[17] ;
 wire \bb_dout1[18] ;
 wire \bb_dout1[19] ;
 wire \bb_dout1[1] ;
 wire \bb_dout1[20] ;
 wire \bb_dout1[21] ;
 wire \bb_dout1[22] ;
 wire \bb_dout1[23] ;
 wire \bb_dout1[24] ;
 wire \bb_dout1[25] ;
 wire \bb_dout1[26] ;
 wire \bb_dout1[27] ;
 wire \bb_dout1[28] ;
 wire \bb_dout1[29] ;
 wire \bb_dout1[2] ;
 wire \bb_dout1[30] ;
 wire \bb_dout1[31] ;
 wire \bb_dout1[3] ;
 wire \bb_dout1[4] ;
 wire \bb_dout1[5] ;
 wire \bb_dout1[6] ;
 wire \bb_dout1[7] ;
 wire \bb_dout1[8] ;
 wire \bb_dout1[9] ;
 wire bb_web0;
 wire \bb_wmask0[0] ;
 wire \bb_wmask0[1] ;
 wire \bb_wmask0[2] ;
 wire \bb_wmask0[3] ;
 wire \vb_addr0[0] ;
 wire \vb_addr0[10] ;
 wire \vb_addr0[11] ;
 wire \vb_addr0[12] ;
 wire \vb_addr0[1] ;
 wire \vb_addr0[2] ;
 wire \vb_addr0[3] ;
 wire \vb_addr0[4] ;
 wire \vb_addr0[5] ;
 wire \vb_addr0[6] ;
 wire \vb_addr0[7] ;
 wire \vb_addr0[8] ;
 wire \vb_addr0[9] ;
 wire \vb_addr1[0] ;
 wire \vb_addr1[10] ;
 wire \vb_addr1[11] ;
 wire \vb_addr1[12] ;
 wire \vb_addr1[1] ;
 wire \vb_addr1[2] ;
 wire \vb_addr1[3] ;
 wire \vb_addr1[4] ;
 wire \vb_addr1[5] ;
 wire \vb_addr1[6] ;
 wire \vb_addr1[7] ;
 wire \vb_addr1[8] ;
 wire \vb_addr1[9] ;
 wire vb_csb0;
 wire vb_csb1;
 wire \vb_din0[0] ;
 wire \vb_din0[10] ;
 wire \vb_din0[11] ;
 wire \vb_din0[12] ;
 wire \vb_din0[13] ;
 wire \vb_din0[14] ;
 wire \vb_din0[15] ;
 wire \vb_din0[16] ;
 wire \vb_din0[17] ;
 wire \vb_din0[18] ;
 wire \vb_din0[19] ;
 wire \vb_din0[1] ;
 wire \vb_din0[20] ;
 wire \vb_din0[21] ;
 wire \vb_din0[22] ;
 wire \vb_din0[23] ;
 wire \vb_din0[24] ;
 wire \vb_din0[25] ;
 wire \vb_din0[26] ;
 wire \vb_din0[27] ;
 wire \vb_din0[28] ;
 wire \vb_din0[29] ;
 wire \vb_din0[2] ;
 wire \vb_din0[30] ;
 wire \vb_din0[31] ;
 wire \vb_din0[3] ;
 wire \vb_din0[4] ;
 wire \vb_din0[5] ;
 wire \vb_din0[6] ;
 wire \vb_din0[7] ;
 wire \vb_din0[8] ;
 wire \vb_din0[9] ;
 wire \vb_dout0[0] ;
 wire \vb_dout0[10] ;
 wire \vb_dout0[11] ;
 wire \vb_dout0[12] ;
 wire \vb_dout0[13] ;
 wire \vb_dout0[14] ;
 wire \vb_dout0[15] ;
 wire \vb_dout0[16] ;
 wire \vb_dout0[17] ;
 wire \vb_dout0[18] ;
 wire \vb_dout0[19] ;
 wire \vb_dout0[1] ;
 wire \vb_dout0[20] ;
 wire \vb_dout0[21] ;
 wire \vb_dout0[22] ;
 wire \vb_dout0[23] ;
 wire \vb_dout0[24] ;
 wire \vb_dout0[25] ;
 wire \vb_dout0[26] ;
 wire \vb_dout0[27] ;
 wire \vb_dout0[28] ;
 wire \vb_dout0[29] ;
 wire \vb_dout0[2] ;
 wire \vb_dout0[30] ;
 wire \vb_dout0[31] ;
 wire \vb_dout0[3] ;
 wire \vb_dout0[4] ;
 wire \vb_dout0[5] ;
 wire \vb_dout0[6] ;
 wire \vb_dout0[7] ;
 wire \vb_dout0[8] ;
 wire \vb_dout0[9] ;
 wire \vb_dout1[0] ;
 wire \vb_dout1[10] ;
 wire \vb_dout1[11] ;
 wire \vb_dout1[12] ;
 wire \vb_dout1[13] ;
 wire \vb_dout1[14] ;
 wire \vb_dout1[15] ;
 wire \vb_dout1[16] ;
 wire \vb_dout1[17] ;
 wire \vb_dout1[18] ;
 wire \vb_dout1[19] ;
 wire \vb_dout1[1] ;
 wire \vb_dout1[20] ;
 wire \vb_dout1[21] ;
 wire \vb_dout1[22] ;
 wire \vb_dout1[23] ;
 wire \vb_dout1[24] ;
 wire \vb_dout1[25] ;
 wire \vb_dout1[26] ;
 wire \vb_dout1[27] ;
 wire \vb_dout1[28] ;
 wire \vb_dout1[29] ;
 wire \vb_dout1[2] ;
 wire \vb_dout1[30] ;
 wire \vb_dout1[31] ;
 wire \vb_dout1[3] ;
 wire \vb_dout1[4] ;
 wire \vb_dout1[5] ;
 wire \vb_dout1[6] ;
 wire \vb_dout1[7] ;
 wire \vb_dout1[8] ;
 wire \vb_dout1[9] ;
 wire vb_web0;
 wire \vb_wmask0[0] ;
 wire \vb_wmask0[1] ;
 wire \vb_wmask0[2] ;
 wire \vb_wmask0[3] ;

 sky130_sram_2kbyte_1rw1r_32x512_8 BB_SRAM (.csb0(bb_csb0),
    .csb1(bb_csb1),
    .web0(bb_web0),
    .clk0(user_clock2),
    .clk1(user_clock2),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\bb_addr0[8] ,
    \bb_addr0[7] ,
    \bb_addr0[6] ,
    \bb_addr0[5] ,
    \bb_addr0[4] ,
    \bb_addr0[3] ,
    \bb_addr0[2] ,
    \bb_addr0[1] ,
    \bb_addr0[0] }),
    .addr1({\bb_addr1[8] ,
    \bb_addr1[7] ,
    \bb_addr1[6] ,
    \bb_addr1[5] ,
    \bb_addr1[4] ,
    \bb_addr1[3] ,
    \bb_addr1[2] ,
    \bb_addr1[1] ,
    \bb_addr1[0] }),
    .din0({\bb_din0[31] ,
    \bb_din0[30] ,
    \bb_din0[29] ,
    \bb_din0[28] ,
    \bb_din0[27] ,
    \bb_din0[26] ,
    \bb_din0[25] ,
    \bb_din0[24] ,
    \bb_din0[23] ,
    \bb_din0[22] ,
    \bb_din0[21] ,
    \bb_din0[20] ,
    \bb_din0[19] ,
    \bb_din0[18] ,
    \bb_din0[17] ,
    \bb_din0[16] ,
    \bb_din0[15] ,
    \bb_din0[14] ,
    \bb_din0[13] ,
    \bb_din0[12] ,
    \bb_din0[11] ,
    \bb_din0[10] ,
    \bb_din0[9] ,
    \bb_din0[8] ,
    \bb_din0[7] ,
    \bb_din0[6] ,
    \bb_din0[5] ,
    \bb_din0[4] ,
    \bb_din0[3] ,
    \bb_din0[2] ,
    \bb_din0[1] ,
    \bb_din0[0] }),
    .dout0({\bb_dout0[31] ,
    \bb_dout0[30] ,
    \bb_dout0[29] ,
    \bb_dout0[28] ,
    \bb_dout0[27] ,
    \bb_dout0[26] ,
    \bb_dout0[25] ,
    \bb_dout0[24] ,
    \bb_dout0[23] ,
    \bb_dout0[22] ,
    \bb_dout0[21] ,
    \bb_dout0[20] ,
    \bb_dout0[19] ,
    \bb_dout0[18] ,
    \bb_dout0[17] ,
    \bb_dout0[16] ,
    \bb_dout0[15] ,
    \bb_dout0[14] ,
    \bb_dout0[13] ,
    \bb_dout0[12] ,
    \bb_dout0[11] ,
    \bb_dout0[10] ,
    \bb_dout0[9] ,
    \bb_dout0[8] ,
    \bb_dout0[7] ,
    \bb_dout0[6] ,
    \bb_dout0[5] ,
    \bb_dout0[4] ,
    \bb_dout0[3] ,
    \bb_dout0[2] ,
    \bb_dout0[1] ,
    \bb_dout0[0] }),
    .dout1({\bb_dout1[31] ,
    \bb_dout1[30] ,
    \bb_dout1[29] ,
    \bb_dout1[28] ,
    \bb_dout1[27] ,
    \bb_dout1[26] ,
    \bb_dout1[25] ,
    \bb_dout1[24] ,
    \bb_dout1[23] ,
    \bb_dout1[22] ,
    \bb_dout1[21] ,
    \bb_dout1[20] ,
    \bb_dout1[19] ,
    \bb_dout1[18] ,
    \bb_dout1[17] ,
    \bb_dout1[16] ,
    \bb_dout1[15] ,
    \bb_dout1[14] ,
    \bb_dout1[13] ,
    \bb_dout1[12] ,
    \bb_dout1[11] ,
    \bb_dout1[10] ,
    \bb_dout1[9] ,
    \bb_dout1[8] ,
    \bb_dout1[7] ,
    \bb_dout1[6] ,
    \bb_dout1[5] ,
    \bb_dout1[4] ,
    \bb_dout1[3] ,
    \bb_dout1[2] ,
    \bb_dout1[1] ,
    \bb_dout1[0] }),
    .wmask0({\bb_wmask0[3] ,
    \bb_wmask0[2] ,
    \bb_wmask0[1] ,
    \bb_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 VB_SRAM (.csb0(vb_csb0),
    .csb1(vb_csb1),
    .web0(vb_web0),
    .clk0(user_clock2),
    .clk1(user_clock2),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\vb_addr0[8] ,
    \vb_addr0[7] ,
    \vb_addr0[6] ,
    \vb_addr0[5] ,
    \vb_addr0[4] ,
    \vb_addr0[3] ,
    \vb_addr0[2] ,
    \vb_addr0[1] ,
    \vb_addr0[0] }),
    .addr1({\vb_addr1[8] ,
    \vb_addr1[7] ,
    \vb_addr1[6] ,
    \vb_addr1[5] ,
    \vb_addr1[4] ,
    \vb_addr1[3] ,
    \vb_addr1[2] ,
    \vb_addr1[1] ,
    \vb_addr1[0] }),
    .din0({\vb_din0[31] ,
    \vb_din0[30] ,
    \vb_din0[29] ,
    \vb_din0[28] ,
    \vb_din0[27] ,
    \vb_din0[26] ,
    \vb_din0[25] ,
    \vb_din0[24] ,
    \vb_din0[23] ,
    \vb_din0[22] ,
    \vb_din0[21] ,
    \vb_din0[20] ,
    \vb_din0[19] ,
    \vb_din0[18] ,
    \vb_din0[17] ,
    \vb_din0[16] ,
    \vb_din0[15] ,
    \vb_din0[14] ,
    \vb_din0[13] ,
    \vb_din0[12] ,
    \vb_din0[11] ,
    \vb_din0[10] ,
    \vb_din0[9] ,
    \vb_din0[8] ,
    \vb_din0[7] ,
    \vb_din0[6] ,
    \vb_din0[5] ,
    \vb_din0[4] ,
    \vb_din0[3] ,
    \vb_din0[2] ,
    \vb_din0[1] ,
    \vb_din0[0] }),
    .dout0({\vb_dout0[31] ,
    \vb_dout0[30] ,
    \vb_dout0[29] ,
    \vb_dout0[28] ,
    \vb_dout0[27] ,
    \vb_dout0[26] ,
    \vb_dout0[25] ,
    \vb_dout0[24] ,
    \vb_dout0[23] ,
    \vb_dout0[22] ,
    \vb_dout0[21] ,
    \vb_dout0[20] ,
    \vb_dout0[19] ,
    \vb_dout0[18] ,
    \vb_dout0[17] ,
    \vb_dout0[16] ,
    \vb_dout0[15] ,
    \vb_dout0[14] ,
    \vb_dout0[13] ,
    \vb_dout0[12] ,
    \vb_dout0[11] ,
    \vb_dout0[10] ,
    \vb_dout0[9] ,
    \vb_dout0[8] ,
    \vb_dout0[7] ,
    \vb_dout0[6] ,
    \vb_dout0[5] ,
    \vb_dout0[4] ,
    \vb_dout0[3] ,
    \vb_dout0[2] ,
    \vb_dout0[1] ,
    \vb_dout0[0] }),
    .dout1({\vb_dout1[31] ,
    \vb_dout1[30] ,
    \vb_dout1[29] ,
    \vb_dout1[28] ,
    \vb_dout1[27] ,
    \vb_dout1[26] ,
    \vb_dout1[25] ,
    \vb_dout1[24] ,
    \vb_dout1[23] ,
    \vb_dout1[22] ,
    \vb_dout1[21] ,
    \vb_dout1[20] ,
    \vb_dout1[19] ,
    \vb_dout1[18] ,
    \vb_dout1[17] ,
    \vb_dout1[16] ,
    \vb_dout1[15] ,
    \vb_dout1[14] ,
    \vb_dout1[13] ,
    \vb_dout1[12] ,
    \vb_dout1[11] ,
    \vb_dout1[10] ,
    \vb_dout1[9] ,
    \vb_dout1[8] ,
    \vb_dout1[7] ,
    \vb_dout1[6] ,
    \vb_dout1[5] ,
    \vb_dout1[4] ,
    \vb_dout1[3] ,
    \vb_dout1[2] ,
    \vb_dout1[1] ,
    \vb_dout1[0] }),
    .wmask0({\vb_wmask0[3] ,
    \vb_wmask0[2] ,
    \vb_wmask0[1] ,
    \vb_wmask0[0] }));
 c0_system mprj (.bb_csb0(bb_csb0),
    .bb_csb1(bb_csb1),
    .bb_web0(bb_web0),
    .bbb_buy_gecerli_g_w(io_out[34]),
    .clk_g(user_clock2),
    .rst_g(wb_rst_i),
    .rx(io_in[0]),
    .tx(io_out[1]),
    .vb_csb0(vb_csb0),
    .vb_csb1(vb_csb1),
    .vb_web0(vb_web0),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .bb_addr0({\bb_addr0[31] ,
    \bb_addr0[30] ,
    \bb_addr0[29] ,
    \bb_addr0[28] ,
    \bb_addr0[27] ,
    \bb_addr0[26] ,
    \bb_addr0[25] ,
    \bb_addr0[24] ,
    \bb_addr0[23] ,
    \bb_addr0[22] ,
    \bb_addr0[21] ,
    \bb_addr0[20] ,
    \bb_addr0[19] ,
    \bb_addr0[18] ,
    \bb_addr0[17] ,
    \bb_addr0[16] ,
    \bb_addr0[15] ,
    \bb_addr0[14] ,
    \bb_addr0[13] ,
    \bb_addr0[12] ,
    \bb_addr0[11] ,
    \bb_addr0[10] ,
    \bb_addr0[9] ,
    \bb_addr0[8] ,
    \bb_addr0[7] ,
    \bb_addr0[6] ,
    \bb_addr0[5] ,
    \bb_addr0[4] ,
    \bb_addr0[3] ,
    \bb_addr0[2] ,
    \bb_addr0[1] ,
    \bb_addr0[0] }),
    .bb_addr1({\bb_addr1[31] ,
    \bb_addr1[30] ,
    \bb_addr1[29] ,
    \bb_addr1[28] ,
    \bb_addr1[27] ,
    \bb_addr1[26] ,
    \bb_addr1[25] ,
    \bb_addr1[24] ,
    \bb_addr1[23] ,
    \bb_addr1[22] ,
    \bb_addr1[21] ,
    \bb_addr1[20] ,
    \bb_addr1[19] ,
    \bb_addr1[18] ,
    \bb_addr1[17] ,
    \bb_addr1[16] ,
    \bb_addr1[15] ,
    \bb_addr1[14] ,
    \bb_addr1[13] ,
    \bb_addr1[12] ,
    \bb_addr1[11] ,
    \bb_addr1[10] ,
    \bb_addr1[9] ,
    \bb_addr1[8] ,
    \bb_addr1[7] ,
    \bb_addr1[6] ,
    \bb_addr1[5] ,
    \bb_addr1[4] ,
    \bb_addr1[3] ,
    \bb_addr1[2] ,
    \bb_addr1[1] ,
    \bb_addr1[0] }),
    .bb_din0({\bb_din0[31] ,
    \bb_din0[30] ,
    \bb_din0[29] ,
    \bb_din0[28] ,
    \bb_din0[27] ,
    \bb_din0[26] ,
    \bb_din0[25] ,
    \bb_din0[24] ,
    \bb_din0[23] ,
    \bb_din0[22] ,
    \bb_din0[21] ,
    \bb_din0[20] ,
    \bb_din0[19] ,
    \bb_din0[18] ,
    \bb_din0[17] ,
    \bb_din0[16] ,
    \bb_din0[15] ,
    \bb_din0[14] ,
    \bb_din0[13] ,
    \bb_din0[12] ,
    \bb_din0[11] ,
    \bb_din0[10] ,
    \bb_din0[9] ,
    \bb_din0[8] ,
    \bb_din0[7] ,
    \bb_din0[6] ,
    \bb_din0[5] ,
    \bb_din0[4] ,
    \bb_din0[3] ,
    \bb_din0[2] ,
    \bb_din0[1] ,
    \bb_din0[0] }),
    .bb_dout0({\bb_dout0[31] ,
    \bb_dout0[30] ,
    \bb_dout0[29] ,
    \bb_dout0[28] ,
    \bb_dout0[27] ,
    \bb_dout0[26] ,
    \bb_dout0[25] ,
    \bb_dout0[24] ,
    \bb_dout0[23] ,
    \bb_dout0[22] ,
    \bb_dout0[21] ,
    \bb_dout0[20] ,
    \bb_dout0[19] ,
    \bb_dout0[18] ,
    \bb_dout0[17] ,
    \bb_dout0[16] ,
    \bb_dout0[15] ,
    \bb_dout0[14] ,
    \bb_dout0[13] ,
    \bb_dout0[12] ,
    \bb_dout0[11] ,
    \bb_dout0[10] ,
    \bb_dout0[9] ,
    \bb_dout0[8] ,
    \bb_dout0[7] ,
    \bb_dout0[6] ,
    \bb_dout0[5] ,
    \bb_dout0[4] ,
    \bb_dout0[3] ,
    \bb_dout0[2] ,
    \bb_dout0[1] ,
    \bb_dout0[0] }),
    .bb_dout1({\bb_dout1[31] ,
    \bb_dout1[30] ,
    \bb_dout1[29] ,
    \bb_dout1[28] ,
    \bb_dout1[27] ,
    \bb_dout1[26] ,
    \bb_dout1[25] ,
    \bb_dout1[24] ,
    \bb_dout1[23] ,
    \bb_dout1[22] ,
    \bb_dout1[21] ,
    \bb_dout1[20] ,
    \bb_dout1[19] ,
    \bb_dout1[18] ,
    \bb_dout1[17] ,
    \bb_dout1[16] ,
    \bb_dout1[15] ,
    \bb_dout1[14] ,
    \bb_dout1[13] ,
    \bb_dout1[12] ,
    \bb_dout1[11] ,
    \bb_dout1[10] ,
    \bb_dout1[9] ,
    \bb_dout1[8] ,
    \bb_dout1[7] ,
    \bb_dout1[6] ,
    \bb_dout1[5] ,
    \bb_dout1[4] ,
    \bb_dout1[3] ,
    \bb_dout1[2] ,
    \bb_dout1[1] ,
    \bb_dout1[0] }),
    .bb_wmask0({\bb_wmask0[3] ,
    \bb_wmask0[2] ,
    \bb_wmask0[1] ,
    \bb_wmask0[0] }),
    .bbb_buy_ps_g_w({io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2]}),
    .vb_addr0({\vb_addr0[12] ,
    \vb_addr0[11] ,
    \vb_addr0[10] ,
    \vb_addr0[9] ,
    \vb_addr0[8] ,
    \vb_addr0[7] ,
    \vb_addr0[6] ,
    \vb_addr0[5] ,
    \vb_addr0[4] ,
    \vb_addr0[3] ,
    \vb_addr0[2] ,
    \vb_addr0[1] ,
    \vb_addr0[0] }),
    .vb_addr1({\vb_addr1[12] ,
    \vb_addr1[11] ,
    \vb_addr1[10] ,
    \vb_addr1[9] ,
    \vb_addr1[8] ,
    \vb_addr1[7] ,
    \vb_addr1[6] ,
    \vb_addr1[5] ,
    \vb_addr1[4] ,
    \vb_addr1[3] ,
    \vb_addr1[2] ,
    \vb_addr1[1] ,
    \vb_addr1[0] }),
    .vb_din0({\vb_din0[31] ,
    \vb_din0[30] ,
    \vb_din0[29] ,
    \vb_din0[28] ,
    \vb_din0[27] ,
    \vb_din0[26] ,
    \vb_din0[25] ,
    \vb_din0[24] ,
    \vb_din0[23] ,
    \vb_din0[22] ,
    \vb_din0[21] ,
    \vb_din0[20] ,
    \vb_din0[19] ,
    \vb_din0[18] ,
    \vb_din0[17] ,
    \vb_din0[16] ,
    \vb_din0[15] ,
    \vb_din0[14] ,
    \vb_din0[13] ,
    \vb_din0[12] ,
    \vb_din0[11] ,
    \vb_din0[10] ,
    \vb_din0[9] ,
    \vb_din0[8] ,
    \vb_din0[7] ,
    \vb_din0[6] ,
    \vb_din0[5] ,
    \vb_din0[4] ,
    \vb_din0[3] ,
    \vb_din0[2] ,
    \vb_din0[1] ,
    \vb_din0[0] }),
    .vb_dout0({\vb_dout0[31] ,
    \vb_dout0[30] ,
    \vb_dout0[29] ,
    \vb_dout0[28] ,
    \vb_dout0[27] ,
    \vb_dout0[26] ,
    \vb_dout0[25] ,
    \vb_dout0[24] ,
    \vb_dout0[23] ,
    \vb_dout0[22] ,
    \vb_dout0[21] ,
    \vb_dout0[20] ,
    \vb_dout0[19] ,
    \vb_dout0[18] ,
    \vb_dout0[17] ,
    \vb_dout0[16] ,
    \vb_dout0[15] ,
    \vb_dout0[14] ,
    \vb_dout0[13] ,
    \vb_dout0[12] ,
    \vb_dout0[11] ,
    \vb_dout0[10] ,
    \vb_dout0[9] ,
    \vb_dout0[8] ,
    \vb_dout0[7] ,
    \vb_dout0[6] ,
    \vb_dout0[5] ,
    \vb_dout0[4] ,
    \vb_dout0[3] ,
    \vb_dout0[2] ,
    \vb_dout0[1] ,
    \vb_dout0[0] }),
    .vb_dout1({\vb_dout1[31] ,
    \vb_dout1[30] ,
    \vb_dout1[29] ,
    \vb_dout1[28] ,
    \vb_dout1[27] ,
    \vb_dout1[26] ,
    \vb_dout1[25] ,
    \vb_dout1[24] ,
    \vb_dout1[23] ,
    \vb_dout1[22] ,
    \vb_dout1[21] ,
    \vb_dout1[20] ,
    \vb_dout1[19] ,
    \vb_dout1[18] ,
    \vb_dout1[17] ,
    \vb_dout1[16] ,
    \vb_dout1[15] ,
    \vb_dout1[14] ,
    \vb_dout1[13] ,
    \vb_dout1[12] ,
    \vb_dout1[11] ,
    \vb_dout1[10] ,
    \vb_dout1[9] ,
    \vb_dout1[8] ,
    \vb_dout1[7] ,
    \vb_dout1[6] ,
    \vb_dout1[5] ,
    \vb_dout1[4] ,
    \vb_dout1[3] ,
    \vb_dout1[2] ,
    \vb_dout1[1] ,
    \vb_dout1[0] }),
    .vb_wmask0({\vb_wmask0[3] ,
    \vb_wmask0[2] ,
    \vb_wmask0[1] ,
    \vb_wmask0[0] }));
 assign io_oeb[0] = wb_rst_i;
 assign io_oeb[10] = wb_rst_i;
 assign io_oeb[11] = wb_rst_i;
 assign io_oeb[12] = wb_rst_i;
 assign io_oeb[13] = wb_rst_i;
 assign io_oeb[14] = wb_rst_i;
 assign io_oeb[15] = wb_rst_i;
 assign io_oeb[16] = wb_rst_i;
 assign io_oeb[17] = wb_rst_i;
 assign io_oeb[18] = wb_rst_i;
 assign io_oeb[19] = wb_rst_i;
 assign io_oeb[1] = wb_rst_i;
 assign io_oeb[20] = wb_rst_i;
 assign io_oeb[21] = wb_rst_i;
 assign io_oeb[22] = wb_rst_i;
 assign io_oeb[23] = wb_rst_i;
 assign io_oeb[24] = wb_rst_i;
 assign io_oeb[25] = wb_rst_i;
 assign io_oeb[26] = wb_rst_i;
 assign io_oeb[27] = wb_rst_i;
 assign io_oeb[28] = wb_rst_i;
 assign io_oeb[29] = wb_rst_i;
 assign io_oeb[2] = wb_rst_i;
 assign io_oeb[30] = wb_rst_i;
 assign io_oeb[31] = wb_rst_i;
 assign io_oeb[32] = wb_rst_i;
 assign io_oeb[33] = wb_rst_i;
 assign io_oeb[34] = wb_rst_i;
 assign io_oeb[35] = wb_rst_i;
 assign io_oeb[36] = wb_rst_i;
 assign io_oeb[37] = wb_rst_i;
 assign io_oeb[3] = wb_rst_i;
 assign io_oeb[4] = wb_rst_i;
 assign io_oeb[5] = wb_rst_i;
 assign io_oeb[6] = wb_rst_i;
 assign io_oeb[7] = wb_rst_i;
 assign io_oeb[8] = wb_rst_i;
 assign io_oeb[9] = wb_rst_i;
endmodule
