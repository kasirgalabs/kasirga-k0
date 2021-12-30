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
`timescale 1ns / 1ps

`include "sabitler.vh"

module c0_system(
	`ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
	`endif
        input                                           clk_g                   ,
        input                                           rst_g                   ,

        input                                           rx                      ,
        output                                          tx                      ,
        //output reg [15:0]                                   count                   ,

        output          [31:0]                          bbb_buy_ps_g_w           ,
        output                                          bbb_buy_gecerli_g_w           ,

        output                                          vb_csb0                 ,
        output                                          vb_web0                 ,
        output          [3:0]                           vb_wmask0               ,
        output          [12:0]                          vb_addr0                ,
        output          [31:0]                          vb_din0                 ,
        input           [31:0]                          vb_dout0                ,

        output                                          vb_csb1                 ,
        output          [12:0]                          vb_addr1                ,
        input           [31:0]                          vb_dout1                ,

        output                                          bb_csb0                 ,
        output                                          bb_web0                 ,
        output          [3:0]                           bb_wmask0               ,
        output          [`BB_ADRES_BIT-1:0]             bb_addr0                ,
        output          [31:0]                          bb_din0                 ,
        input           [31:0]                          bb_dout0                ,

        output                                          bb_csb1                 ,
        output          [`BB_ADRES_BIT-1:0]             bb_addr1                ,
        input           [31:0]                          bb_dout1                         
    );

    //==============================================================================
    //                        Bellek Adresi Tekleyici ve C0
    //==============================================================================
    
    wire                                                c0_oku_hazir_w                                                  ;
    wire           [31:0]                               c0_oku_veri_w                                                   ;
    wire                                                c0_oku_veri_gecerli_w                                           ;
    wire                                                c0_yaz_hazir_w                                                  ;
                                                                                                      
    wire                                                c0_oku_gecerli_w                                                ;
    wire           [31:0]                               c0_yaz_veri_w                                                   ;
    wire           [3:0]                                c0_yaz_gecerli_w                                                ;
    wire           [31:0]                               c0_adres_w                                                  ;

    //==============================================================================
    //                  C0 Cekirdegi, On Taraf ve Kesme Denetleyici
    //==============================================================================
    
    wire                                                bbb_buy_gecerli_g_w                                              ;
    wire           [`BUYRUK_BIT-1:0]                    bb_buy_g_w                                                      ;
    wire           [`BB_ADRES_BIT-1:0]                  bbb_buy_ps_g_w                                                   ;
    wire                                                gc_hazir_c_w                                                    ;
    wire           [`BB_ADRES_BIT-1:0]                  bb_buy_istek_adres_c_w                                          ;
    wire                                                bb_buy_istek_c_w                                                ; 
    
    wire                                                kesme_g_w                                                       ;
    wire                                                zamanlayici_kesme_g_w                                           ;
    
    //==============================================================================
    //                                Buyruk Bellegi
    //==============================================================================
        
    wire           [`BB_ADRES_BIT-1:0]                  bb_addra_w                                                      ;                                        
    wire           [`BB_ADRES_BIT-1:0]                  bat_bb_addra_w                                                  ;                                        
    wire           [`BB_ADRES_BIT-1:0]                  ot_bb_addra_w                                                   ;                                        
    wire                                                bb_clka_w                                                       ;                                      
    wire           [31:0]                               bb_dina_w                                                       ;                                     
    wire           [31:0]                               bb_douta_w                                                      ;                                      
    wire                                                ot_bb_ena_w                                                     ;                                     
    wire                                                bat_bb_ena_w                                                    ;                                     
    wire                                                bb_ena_w                                                        ;                                     
    wire           [3:0]                                bb_wea_w                                                        ;                                       

        
    wire           [`BB_ADRES_BIT-1:0]                  basbel_addra_w                                                  ;                                        
    wire           [31:0]                               basbel_douta_w                                                  ;
    wire                                                basbel_ena_w                                                    ;
    
    //==============================================================================
    //                                 Veri Bellegi
    //==============================================================================
        
    wire           [12:0]                               vb_addra_w                                                      ;                                        
    wire                                                vb_clka_w                                                       ;                                      
    wire           [31:0]                               vb_dina_w                                                       ;                                     
    wire           [31:0]                               vb_douta_w                                                      ;                                      
    wire                                                vb_ena_w                                                        ;                                     
    wire           [3:0]                                vb_wea_w                                                        ;        

    //==============================================================================
    //                                AXI SISTEMI
    //==============================================================================
                             
    wire                                                interrupt_w                                                     ;                                     
    wire           [31:0]                               s_axi_araddr_w                                                  ;                                      
    wire                                                s_axi_arready_w                                                 ;                                     
    wire                                                s_axi_arvalid_w                                                 ; 
    wire           [2:0]                                s_axi_arprot_w                                                  ;
    wire           [31:0]                               s_axi_awaddr_w                                                  ;
    wire           [2:0]                                s_axi_awprot_w                                                  ;
    wire                                                s_axi_awready_w                                                 ;
    wire                                                s_axi_awvalid_w                                                 ;
    wire                                                s_axi_bready_w                                                  ;
    wire           [1:0]                                s_axi_bresp_w                                                   ;
    wire                                                s_axi_bvalid_w                                                  ;
    wire           [31:0]                               s_axi_rdata_w                                                   ;
    wire                                                s_axi_rready_w                                                  ;
    wire           [1:0]                                s_axi_rresp_w                                                   ;
    wire                                                s_axi_rvalid_w                                                  ;
    wire           [31:0]                               s_axi_wdata_w                                                   ;
    wire                                                s_axi_wready_w                                                  ;
    wire           [3:0]                                s_axi_wstrb_w                                                   ;
    wire                                                s_axi_wvalid_w                                                  ;
    wire                                                s_axi_aclk_w                                                    ;
    wire                                                s_axi_aresetn_w                                                 ;

    adres_tekleyici bat
    (
        .clk_g                                          (clk_g)                                                         ,
        .rst_g                                          (rst_g)                                                         ,
                                                        
        .c0_oku_hazir_c                                 (c0_oku_hazir_w)                                                ,
        .c0_oku_veri_c                                  (c0_oku_veri_w)                                                 ,
        .c0_oku_veri_gecerli_c                          (c0_oku_veri_gecerli_w)                                         ,
        .c0_yaz_hazir_c                                 (c0_yaz_hazir_w)                                                ,
                                                        
        .c0_oku_adres_g                                 (c0_adres_w)                                                    ,
        .c0_oku_gecerli_g                               (c0_oku_gecerli_w)                                              ,
        .c0_yaz_veri_g                                  (c0_yaz_veri_w)                                                 ,
        .c0_yaz_gecerli_g                               (c0_yaz_gecerli_w)                                              ,
        .c0_yaz_adres_g                                 (c0_adres_w)                                                    ,
                                                        
        .vb_addra_c                                     (vb_addra_w)                                                    ,
        .vb_dina_c                                      (vb_dina_w)                                                     ,
        .vb_douta_g                                     (vb_douta_w)                                                    ,
        .vb_ena_c                                       (vb_ena_w)                                                      ,
        .vb_wea_c                                       (vb_wea_w)                                                      ,

        .bb_wea_c                                       (bb_wea_w)                                                      ,
        .bb_ena_c                                       (bat_bb_ena_w)                                                  ,
        .bb_addra_c                                     (bat_bb_addra_w)                                                ,
        .bb_dina_c                                      (bb_dina_w)                                                     ,

        .s_axi_araddr_c                                 (s_axi_araddr_w)                                                ,                                    
        .s_axi_arready_g                                (s_axi_arready_w)                                               ,                                     
        .s_axi_arvalid_c                                (s_axi_arvalid_w)                                               ,
        .s_axi_awaddr_c                                 (s_axi_awaddr_w)                                                ,
        .s_axi_awready_g                                (s_axi_awready_w)                                               ,
        .s_axi_awvalid_c                                (s_axi_awvalid_w)                                               ,
        .s_axi_bready_c                                 (s_axi_bready_w)                                                ,
        .s_axi_bresp_g                                  (s_axi_bresp_w)                                                 ,        
        .s_axi_bvalid_g                                 (s_axi_bvalid_w)                                                ,
        .s_axi_rdata_g                                  (s_axi_rdata_w)                                                 ,
        .s_axi_rready_c                                 (s_axi_rready_w)                                                ,
        .s_axi_rresp_g                                  (s_axi_rresp_w)                                                 ,    
        .s_axi_rvalid_g                                 (s_axi_rvalid_w)                                                ,
        .s_axi_wdata_c                                  (s_axi_wdata_w)                                                 ,
        .s_axi_wready_g                                 (s_axi_wready_w)                                                ,
        .s_axi_wstrb_c                                  (s_axi_wstrb_w)                                                 ,
        .s_axi_wvalid_c                                 (s_axi_wvalid_w)        
    );

    localparam SLAVE_NUM = 1;
    localparam [32*SLAVE_NUM - 1:0] bases = {32'h00000000};
    localparam [32*SLAVE_NUM - 1:0] ranges = {32'h7fffffff};
    
    // INTER - SLAVE connections
    // Write Address Channel
    wire [SLAVE_NUM - 1:0]              AWVALID_s_w;
    wire [SLAVE_NUM - 1:0]              AWREADY_s_w;
    wire [`ADRES_BIT*SLAVE_NUM - 1:0]   AWADDR_s_w;
    wire [3*SLAVE_NUM - 1:0]            AWPROT_s_w;
    // Write Data Channel
    wire [SLAVE_NUM - 1:0]              WVALID_s_w;
    wire [SLAVE_NUM - 1:0]              WREADY_s_w;
    wire [`VERI_BIT*SLAVE_NUM - 1:0]    WDATA_s_w;
    wire [`VERI_BIT/8*SLAVE_NUM - 1:0]  WSTRB_s_w;
    // Write Response Channel
    wire [SLAVE_NUM - 1:0]              BVALID_s_w;
    wire [SLAVE_NUM - 1:0]              BREADY_s_w;
    wire [2*SLAVE_NUM - 1:0]            BRESP_s_w;
    // Read Address Channel
    wire [SLAVE_NUM - 1:0]              ARVALID_s_w;
    wire [SLAVE_NUM - 1:0]              ARREADY_s_w;
    wire [`ADRES_BIT*SLAVE_NUM - 1:0]   ARADDR_s_w;
    wire [3*SLAVE_NUM - 1:0]            ARPROT_s_w;
    // Read Data Channel
    wire [SLAVE_NUM - 1:0]              RVALID_s_w;
    wire [SLAVE_NUM - 1:0]              RREADY_s_w;
    wire [`VERI_BIT*SLAVE_NUM - 1:0]    RDATA_s_w;
    wire [2*SLAVE_NUM - 1:0]            RRESP_s_w;
    
    // SLAVE - PERIPHERAL connections
    // Komut Kanali
    wire [SLAVE_NUM - 1:0]              komut_hazir_p_w;
    wire [SLAVE_NUM - 1:0]              komut_gecerli_p_w;
    wire [`VERI_BIT*SLAVE_NUM - 1:0]    komut_p_w;
    // Veri Kanali
    wire [SLAVE_NUM - 1:0]              veri_hazir_p_w;
    wire [SLAVE_NUM - 1:0]              veri_gecerli_p_w;
    wire [`VERI_BIT*SLAVE_NUM - 1:0]    veri_p_w;    
    
    // INTERCONNECT
    axi_interconnect #(.SLAVE_NUM(SLAVE_NUM),
                       .bases(bases),
                       .ranges(ranges)) 
        interconnect0 (
        // Masterside WAC
        .m_axi_awaddr                                   (s_axi_awaddr_w),
        .m_axi_awprot                                   (s_axi_awprot_w),
        .m_axi_awvalid                                  (s_axi_awvalid_w),
        .m_axi_awready                                  (s_axi_awready_w),
        // Masterside WDC                                
        .m_axi_wdata                                    (s_axi_wdata_w),
        .m_axi_wstrb                                    (s_axi_wstrb_w),
        .m_axi_wvalid                                   (s_axi_wvalid_w),
        .m_axi_wready                                   (s_axi_wready_w),
        // Masterside WRC                                
        .m_axi_bresp                                    (s_axi_bresp_w),
        .m_axi_bvalid                                   (s_axi_bvalid_w),
        .m_axi_bready                                   (s_axi_bready_w),
        // Masterside RAC                                
        .m_axi_araddr                                   (s_axi_araddr_w),
        .m_axi_arvalid                                  (s_axi_arvalid_w),
        .m_axi_arready                                  (s_axi_arready_w),
        .m_axi_arprot                                   (s_axi_arprot_w),
        // Masterside RDC                                
        .m_axi_rdata                                    (s_axi_rdata_w),
        .m_axi_rresp                                    (s_axi_rresp_w),
        .m_axi_rvalid                                   (s_axi_rvalid_w),
        .m_axi_rready                                   (s_axi_rready_w),
        // Slaveside WAC
        .s_axi_awaddr                                   (AWADDR_s_w),
        .s_axi_awprot                                   (AWPROT_s_w),
        .s_axi_awvalid                                  (AWVALID_s_w),
        .s_axi_awready                                  (AWREADY_s_w),
        // Slaveside WDC
        .s_axi_wdata                                    (WDATA_s_w),
        .s_axi_wstrb                                    (WSTRB_s_w),
        .s_axi_wvalid                                   (WVALID_s_w),
        .s_axi_wready                                   (WREADY_s_w),
        // Slaveside WRC
        .s_axi_bresp                                    (BRESP_s_w),
        .s_axi_bvalid                                   (BVALID_s_w),
        .s_axi_bready                                   (BREADY_s_w),
        // Slaveside RAC
        .s_axi_araddr                                   (ARADDR_s_w),
        .s_axi_arvalid                                  (ARVALID_s_w),
        .s_axi_arready                                  (ARREADY_s_w),
        .s_axi_arprot                                   (ARPROT_s_w),
        // Slaveside RDC
        .s_axi_rdata                                    (RDATA_s_w),
        .s_axi_rresp                                    (RRESP_s_w),
        .s_axi_rvalid                                   (RVALID_s_w),
        .s_axi_rready                                   (RREADY_s_w)
    );
    
    // SLAVE
    genvar s;
    generate
        for(s = 0; s < SLAVE_NUM; s = s + 1) begin
            axi_slave_gfi axi_slave(
                .ACLK(clk_g),
                .ARESETn(~(rst_g)),
                .AWADDR(AWADDR_s_w[s*`ADRES_BIT +: `ADRES_BIT]),
                .AWVALID(AWVALID_s_w[s]),
                .AWPROT(AWPROT_s_w[s*3 +: 3]),
                .AWREADY(AWREADY_s_w[s]),
                .WDATA(WDATA_s_w[s*`VERI_BIT +: `VERI_BIT]),
                .WSTRB(WSTRB_s_w[s*`VERI_BIT/8 +: `VERI_BIT/8]),
                .WVALID(WVALID_s_w[s]),
                .WREADY(WREADY_s_w[s]),
                .BREADY(BREADY_s_w[s]),
                .BVALID(BVALID_s_w[s]),
                .BRESP(BRESP_s_w[s*2 +: 2]),
                .ARADDR(ARADDR_s_w[s*`ADRES_BIT +: `ADRES_BIT]),
                .ARVALID(ARVALID_s_w[s]),
                .ARPROT(ARPROT_s_w[s*3 +: 3]),
                .ARREADY(ARREADY_s_w[s]),
                .RREADY(RREADY_s_w[s]),
                .RDATA(RDATA_s_w[s*`VERI_BIT +: `VERI_BIT]),
                .RVALID(RVALID_s_w[s]),
                .RRESP(RRESP_s_w[s*2 +: 2]),
                .komut_hazir(komut_hazir_p_w[s]),
                //.komut_hazir(komut_hazir_tb[s]),
                .komut_gecerli(komut_gecerli_p_w[s]),
                .komut(komut_p_w[s*`VERI_BIT +: `VERI_BIT]),
                .veri(veri_p_w[s*`VERI_BIT +: `VERI_BIT]),
                //.veri(veri_tb[s*`VERI_BIT +: `VERI_BIT]),
                .veri_gecerli(veri_gecerli_p_w[s]),
                //.veri_gecerli(veri_gecerli_tb[s]),
                .veri_hazir(veri_hazir_p_w[s])
            );
        end
    endgenerate    
    
    UART_GFA uart(
        .clk_g                                          (clk_g)                                                         ,
        .rst_g                                          (rst_g)                                                           ,
        
        .komut_hazir                                    (komut_hazir_p_w[0])                                              ,
        .komut_gecerli                                  (komut_gecerli_p_w[0])                                            ,
        .komut                                          (komut_p_w[0 +: `VERI_BIT])                                       ,
        .veri                                           (veri_p_w[0 +: `VERI_BIT])                                        ,    
        .veri_gecerli                                   (veri_gecerli_p_w[0])                                             ,
        .veri_hazir                                     (veri_hazir_p_w[0])                                               ,
        
        .RX                                             (rx)                                                            ,
        .TX                                             (tx)
    );

    //==============================================================================
    //                                CEKIRDEK & BELLEKLER
    //==============================================================================    


    cekirdek c0
    (
        .clk_g                                          (clk_g)                                                         ,
        .rst_g                                          (rst_g)                                                         ,
        .bb_buy_gecerli_g                               (bbb_buy_gecerli_g_w)                                            ,
        .bb_buy_g                                       (bb_buy_g_w)                                                    ,
        .bb_buy_ps_g                                    (bbb_buy_ps_g_w)                                                 ,
 
        .bb_buy_istek_adres_c                           (bb_buy_istek_adres_c_w)                                        ,
        .bb_buy_istek_c                                 (bb_buy_istek_c_w)                                              ,
        
        .gc_hazir_c                                     (gc_hazir_c_w)                                                  ,        
        .kesme_g                                        (kesme_g_w)                                                     ,
        .zamanlayici_kesme_g                            (zamanlayici_kesme_g_w)                                         ,
        
        .oku_hazir_g                                    (c0_oku_hazir_w)                                                ,
        .oku_veri_g                                     (c0_oku_veri_w)                                                 ,
        .oku_veri_gecerli_g                             (c0_oku_veri_gecerli_w)                                         ,
        .yaz_hazir_g                                    (c0_yaz_hazir_w)                                                ,
                                                         
        .adres_c                                        (c0_adres_w)                                                    ,
        .oku_gecerli_c                                  (c0_oku_gecerli_w)                                              ,
        .yaz_veri_c                                     (c0_yaz_veri_w)                                                 ,
        .yaz_gecerli_c                                  (c0_yaz_gecerli_w)                                              
    );

    assign                                              bb_clka_w         =       clk_g                                 ;
    

    baslangic_bellegi basbel
    (
      .clk_g                                            (clk_g)                                                         ,
      .rst_g                                            (rst_g)                                                         ,
      
      .adres_g                                          (basbel_addra_w)                                                ,
      .buyruk_c                                         (basbel_douta_w)                                                ,
      .ena_g                                            (basbel_ena_w)
    );

    assign                                              bb_ena_w        =       bat_bb_ena_w | ot_bb_ena_w              ;
    assign                                              bb_addra_w      =       (bb_wea_w != 0) ?
                                                                                bat_bb_addra_w : (ot_bb_addra_w  >> 2)  ;    

    // la_data_in'i buraya sentez aracini kandirmak icin bagliyoruz.
    buyruk_bellegi_sram bb
    (
        .addra                                          (bb_addra_w)                                                    ,
        .clka                                           (bb_clka_w)                                                     ,
        .dina                                           (bb_dina_w)                                                     ,
        .douta                                          (bb_douta_w)                                                    ,
        .ena                                            (bb_ena_w)                                                      ,
        .wea                                            (bb_wea_w)                                                      ,

        .csb0                                           (bb_csb0)                                                       ,
        .web0                                           (bb_web0)                                                       ,
        .wmask0                                         (bb_wmask0)                                                     ,
        .addr0                                          (bb_addr0)                                                      ,
        .din0                                           (bb_din0)                                                       ,
        .dout0                                          (bb_dout0)                                                      ,

        .csb1                                           (bb_csb1)                                                       ,
        .addr1                                          (bb_addr1)                                                      ,
        .dout1                                          (bb_dout1)                                          
    );
    
    assign                                              vb_clka_w       =       clk_g                                   ;
    
    
    veri_bellegi_sram vb
    (
        .addra                                          (vb_addra_w)                                                    ,
        .clka                                           (vb_clka_w)                                                     ,
        .dina                                           (vb_dina_w)                                                     ,
        .douta                                          (vb_douta_w)                                                    ,
        .ena                                            (vb_ena_w)                                                      ,
        .wea                                            (vb_wea_w/*  SA */)                                                      ,
        
        .csb0                                           (vb_csb0)                                                       ,
        .web0                                           (vb_web0)                                                       ,
        .wmask0                                         (vb_wmask0)                                                     ,
        .addr0                                          (vb_addr0)                                                      ,
        .din0                                           (vb_din0)                                                       ,
        .dout0                                          (vb_dout0)                                                      ,

        .csb1                                           (vb_csb1)                                                       ,
        .addr1                                          (vb_addr1)                                                      ,
        .dout1                                          (vb_dout1)                                          
    );
    on_taraf ot
    (
        .clk_g                                          (clk_g)                                                         ,
        .rst_g                                          (rst_g)                                                         ,
                                                                                                               
        .gc_hazir_g                                     (gc_hazir_c_w)                                                  ,
        .bb_buy_gecerli_c                               (bbb_buy_gecerli_g_w)                                            ,
        .bb_buy_c                                       (bb_buy_g_w)                                                    ,
        .bb_buy_ps_c                                    (bbb_buy_ps_g_w)                                                 ,
        
        .bb_buy_istek_adres_g                            (bb_buy_istek_adres_c_w)                                       ,
        .bb_buy_istek_g                                  (bb_buy_istek_c_w)                                             ,                 
        
        .bb_addra_c                                     (ot_bb_addra_w)                                                    ,                                       
        .bb_douta_g                                     (bb_douta_w)                                                    ,                                      
        .bb_ena_c                                       (ot_bb_ena_w)                                                      ,

        .basbel_addra_c                                 (basbel_addra_w)                                                ,                                       
        .basbel_douta_g                                 (basbel_douta_w)                                                ,  
        .basbel_ena_c                                   (basbel_ena_w)                                                   
    );

    reg [31:0] count;
    always @(posedge clk_g) begin
        if(rst_g) begin
            count = 0;
        end else begin
            count = count + 1;
        end
    end






endmodule

