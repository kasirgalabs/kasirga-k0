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

module adres_tekleyici(
    input                                               clk_g                                           ,
    input                                               rst_g                                           ,
    // C0 <-> Adres Tekleyici
    
    output                                              c0_oku_hazir_c                                  ,
    output          [31:0]                              c0_oku_veri_c                                   ,
    output                                              c0_oku_veri_gecerli_c                           ,
    output                                              c0_yaz_hazir_c                                  ,
   
    input           [31:0]                              c0_oku_adres_g                                  ,
    input                                               c0_oku_gecerli_g                                ,
    input           [31:0]                              c0_yaz_veri_g                                   ,
    input           [3:0]                               c0_yaz_gecerli_g                                ,
    input           [31:0]                              c0_yaz_adres_g                                  ,

    // C0 <-> Disarisi (UART + Veri Bellegi
    output          [12:0]                              vb_addra_c                                      ,
    output          [31:0]                              vb_dina_c                                       ,
    input           [31:0]                              vb_douta_g                                      ,
    output    reg                                       vb_ena_c                                        ,
    output    reg   [3:0]                               vb_wea_c                                        ,

    output    reg   [3:0]                               bb_wea_c                                        ,
    output    reg                                       bb_ena_c                                        ,
    output          [31:0]                              bb_dina_c                                       ,
    output          [31:0]                              bb_addra_c                                      ,

 
    output          [31:0]                              s_axi_araddr_c                                  ,
    input                                               s_axi_arready_g                                 ,                                   
    output    reg                                       s_axi_arvalid_c                                 ,
    output          [31:0]                              s_axi_awaddr_c                                  ,
    input                                               s_axi_awready_g                                 ,
    output    reg                                       s_axi_awvalid_c                                 ,
    output                                              s_axi_bready_c                                  ,
    input           [1:0]                               s_axi_bresp_g                                   ,
    input                                               s_axi_bvalid_g                                  ,
    input           [31:0]                              s_axi_rdata_g                                   ,
    output    reg                                       s_axi_rready_c                                  ,
    input           [1:0]                               s_axi_rresp_g                                   ,
    input                                               s_axi_rvalid_g                                  ,
    output          [31:0]                              s_axi_wdata_c                                   ,
    input                                               s_axi_wready_g                                  ,
    output    reg   [3:0]                               s_axi_wstrb_c                                   ,
    output    reg                                       s_axi_wvalid_c                                  
    
    );
    
    // TODO b kanali ile ilgilenmeyebiliriz? bready hep 1 olur
    localparam      AXI_BOSTA_S         =               0                                               ;            
    localparam      AXI_OKU_AR_S        =               1                                               ;            
    localparam      AXI_OKU_R_S         =               2                                               ;            
    localparam      AXI_YAZ_AW_W_S      =               3                                               ;            
    localparam      AXI_YAZ_AW_S        =               4                                               ;            
    localparam      AXI_YAZ_W_S         =               5                                               ;            
   
    localparam      BRAM_BOSTA_S        =               0                                               ;
    localparam      BRAM_OKU_S          =               1                                               ;
    localparam      BRAM_OKU_BEKLE_S    =               2                                               ;
    localparam      BRAM_YAZ_S          =               3                                               ;
   
   
    reg             [2:0]                               axi_durum_r                                     ;
    reg             [2:0]                               axi_durum_ns_r                                  ;
    reg             [1:0]                               bram_durum_r                                    ;
    reg             [1:0]                               bram_durum_ns_r                                 ;
   
    reg                                                 yaz_bb_r                                        ;
    reg                                                 yaz_bb_ns_r                                     ;
   
    (*dont_touch = "true"*) reg             [31:0]                              adres_r                                         ;
    (*dont_touch = "true"*) reg             [31:0]                              adres_ns_r                                      ;

    (*dont_touch = "true"*) reg             [31:0]                              yaz_veri_r                                      ;
    (*dont_touch = "true"*) reg             [31:0]                              yaz_veri_ns_r                                   ;
    reg             [3:0]                               yaz_maske_r                                     ;
    reg             [3:0]                               yaz_maske_ns_r                                  ;
   
    wire                                                yaz_axi_istegi_w                                ;
    wire                                                oku_axi_istegi_w                                ;
    
    wire                                                yaz_vb_w                                        ;
    wire                                                yaz_bb_w                                        ;
    
    // TODO: bu daha da genellenebilir, su anda duragan bir adres eslemesi varsayiyor
    assign          yaz_axi_istegi_w        =           c0_yaz_adres_g >= 32'h8000_0000                 ;
    assign          oku_axi_istegi_w        =           c0_oku_adres_g >= 32'h8000_0000                 ;
    
    assign          yaz_bb_w                =           (c0_yaz_adres_g >= `BB_TABAN_ADR) &&          
                                                        (c0_yaz_adres_g < 32'h4000_0000)                ;    
    
    // TODO: yalniz bir hazir sinyali?
    assign          c0_yaz_hazir_c          =           axi_durum_r == 2'b00 && bram_durum_r == 2'b00   ;
    assign          c0_oku_hazir_c          =           axi_durum_r == 2'b00 && bram_durum_r == 2'b00   ;

    assign          c0_oku_veri_c           =           axi_durum_r == AXI_OKU_R_S                      ?
                                                        s_axi_rdata_g         :     vb_douta_g          ;             
    assign          c0_oku_veri_gecerli_c   =           (axi_durum_r == AXI_OKU_R_S && s_axi_rvalid_g)  ||
                                                        (bram_durum_r == BRAM_OKU_BEKLE_S);
  
    assign          s_axi_araddr_c          =           adres_r                                         ;
    assign          s_axi_awaddr_c          =           adres_r                                         ;
    assign          s_axi_wdata_c           =           yaz_veri_r                                      ;

    assign          vb_addra_c              =           adres_r                                         ;
    assign          vb_dina_c               =           yaz_veri_r                                      ;
    assign          bb_dina_c               =           yaz_veri_r                                      ;

    assign          vb_addra_c              =           adres_r                                         ;
    assign          bb_addra_c              =           adres_r                                         ;
    assign          vb_dina_c               =           yaz_veri_r                                      ;

    assign          s_axi_bready_c          =           1'b1                                            ;
  
    always @* 
    begin
        axi_durum_ns_r                      =           axi_durum_r                                     ;
        bram_durum_ns_r                     =           bram_durum_r                                    ;
        adres_ns_r                          =           adres_r                                         ;
        yaz_veri_ns_r                       =           yaz_veri_r                                      ;
        yaz_maske_ns_r                      =           yaz_maske_r                                     ;
        s_axi_arvalid_c                     =           1'b0                                            ;
        s_axi_awvalid_c                     =           1'b0                                            ;
        s_axi_rready_c                      =           1'b0                                            ;
        s_axi_wstrb_c                       =           4'b0                                            ;
        s_axi_wvalid_c                      =           1'b0                                            ;
        vb_ena_c                            =           1'b0                                            ;
        vb_wea_c                            =           4'b0                                            ;
        bb_wea_c                            =           4'b0                                            ;
        bb_ena_c                            =           1'b0                                            ;
        yaz_bb_ns_r                         =           yaz_bb_r                                        ;
        // Su anda herhangi bir veri aktarimi gerceklestirilmiyor
        if ((axi_durum_r == AXI_BOSTA_S) && (bram_durum_r == BRAM_BOSTA_S)) begin            
            if (c0_oku_gecerli_g) 
            begin
                if (oku_axi_istegi_w) 
                begin
                    axi_durum_ns_r          =           AXI_OKU_AR_S                                    ;
                    adres_ns_r              =           c0_oku_adres_g      -       32'h8000_0000       ;
                end
                else 
                begin
                    bram_durum_ns_r         =           BRAM_OKU_S                                      ;
                    // BRAM word adresleme kullaniyor
                    adres_ns_r              =           c0_oku_adres_g      >>      2                   ;                
                end    
            end
            else if (c0_yaz_gecerli_g != 0)
            begin
                yaz_veri_ns_r               =           c0_yaz_veri_g                                   ;
                yaz_maske_ns_r              =           c0_yaz_gecerli_g                                ;
                if (yaz_axi_istegi_w) 
                begin
                    axi_durum_ns_r          =           AXI_YAZ_AW_W_S                                  ;
                    adres_ns_r              =           c0_yaz_adres_g      -       32'h8000_0000       ;
                end
                else 
                begin
                    bram_durum_ns_r         =           BRAM_YAZ_S                                      ;
                    // BRAM word adresleme kullaniyor
                    adres_ns_r              =           (c0_yaz_adres_g - `VB_TABAN_ADR) >> 2           ;
                    if (yaz_bb_w) begin
                      yaz_bb_ns_r           =           1'b1                                            ;
                      adres_ns_r            =           (c0_yaz_adres_g - `BB_TABAN_ADR) >> 2           ;
                    end
                end            
            end
        end
        else 
        begin
            // axi arayuzunde veri aktarimi gerceklestiriliyor
            if (axi_durum_r != AXI_BOSTA_S) 
            begin
                case (axi_durum_r)
                    AXI_OKU_AR_S: begin
                        s_axi_arvalid_c         =       1'b1                                            ;
                        if(s_axi_arready_g)
                            axi_durum_ns_r      =       AXI_OKU_R_S                                     ;
                    end
                    AXI_OKU_R_S: begin
                        s_axi_rready_c          =       1'b1                                            ;
                        if(s_axi_rvalid_g)
                            axi_durum_ns_r      =       AXI_BOSTA_S                                     ;                                           
                    end
                    // https://forums.xilinx.com/t5/Processor-System-Design-and-AXI/AXI-UART-Lite-v2-0-is-never-ready/td-p/1064124
                    AXI_YAZ_AW_W_S: begin
                        s_axi_awvalid_c         =       1'b1                                            ;
                        s_axi_wvalid_c          =       1'b1                                            ;
                        s_axi_wstrb_c           =       yaz_maske_r                                     ;                     
                        if(s_axi_awready_g && s_axi_wready_g)
                            axi_durum_ns_r      =       AXI_BOSTA_S                                     ;                        
                        else if (s_axi_awready_g) 
                            axi_durum_ns_r      =       AXI_YAZ_W_S                                     ;
                        else if (s_axi_wready_g)
                            axi_durum_ns_r      =       AXI_YAZ_AW_S                                    ;                        
                    end
                    AXI_YAZ_AW_S: begin
                        s_axi_awvalid_c         =       1'b1                                            ;
                        if(s_axi_awready_g)
                            axi_durum_ns_r      =       AXI_BOSTA_S                                     ;                     
                    end                        
                    AXI_YAZ_W_S: begin
                        s_axi_wstrb_c           =       yaz_maske_r                                     ;
                        s_axi_wvalid_c          =       1'b1                                            ;
                        if(s_axi_wready_g)
                            axi_durum_ns_r      =       AXI_BOSTA_S                                     ;                     
                    end    
                endcase
            end
            // veri belleginden veri okunuyor veya veri bellegine (ya da buyruk bellegine) yaziliyor
            else 
            begin
                case (bram_durum_r)
                    BRAM_OKU_S: begin
                        vb_ena_c                =       1'b1                                            ;
                        bram_durum_ns_r         =       BRAM_OKU_BEKLE_S                                ;       
                    end
                    BRAM_OKU_BEKLE_S: begin
                        bram_durum_ns_r         =       BRAM_BOSTA_S                                    ;
                    end
                    BRAM_YAZ_S: begin
                        yaz_bb_ns_r             =       1'b0                                            ;
                        if (yaz_bb_r) begin
                          bb_ena_c              =       1'b1                                            ;
                          bb_wea_c              =       yaz_maske_r                                     ;                          
                        end else begin
                          vb_ena_c              =       1'b1                                            ;
                          vb_wea_c              =       yaz_maske_r                                     ;                        
                        end
                        bram_durum_ns_r         =       BRAM_BOSTA_S                                    ;
                    end                        
                endcase           
            end
        end    
    end
    
    always @(posedge clk_g) 
    begin
        if (rst_g) 
        begin
            axi_durum_r                 <=          AXI_BOSTA_S                                         ;
            bram_durum_r                <=          BRAM_BOSTA_S                                        ;
            adres_r                     <=          0                                                   ;
            yaz_veri_r                  <=          0                                                   ;        
            yaz_maske_r                 <=          0                                                   ;
            yaz_bb_r                    <=          0                                                   ;        
        end
        else begin
            axi_durum_r                 <=          axi_durum_ns_r                                      ;
            bram_durum_r                <=          bram_durum_ns_r                                     ;
            adres_r                     <=          adres_ns_r                                          ;
            yaz_veri_r                  <=          yaz_veri_ns_r                                       ;
            yaz_maske_r                 <=          yaz_maske_ns_r                                      ;
            yaz_bb_r                    <=          yaz_bb_ns_r                                         ;                                       
        end
        
    end
    
endmodule
