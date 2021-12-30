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
`include "mikroislem.vh"

module getir_coz
    (
    input                               clk_g                                                               ,
    input                               rst_g                                                               ,

    // Buyruk bellegi <-> GetirCoz
    input                               bb_buy_gecerli_g                                                    ,
    input        [`BUYRUK_BIT-1:0]      bb_buy_g                                                            ,
    input        [`BB_ADRES_BIT-1:0]    bb_buy_ps_g                                                         ,
    output                              gc_hazir_c                                                          ,

    // GetirCoz <-> YazmacOkuYurut
    input                               gc_duraklat_g                                                       ,
    input                               gc_bosalt_g                                                         ,
    output       [`UIS_BIT-1:0]         gc_uis_c                                                            ,  

    // GetirCoz <-> DDY birimi
    output                              gc_odd_c                                                            ,
    output      [`BB_ADRES_BIT-1:0]     gc_odd_ps_c                                                                      
    );

    // ===================================================================================================
    // ========================================MODUL TANIMLAMASI==========================================
    // ===================================================================================================

    // Getirilen buyruk
    wire         [`BUYRUK_BIT-1:0]       buyruk_w          = bb_buy_g                                       ;

    // Buyruk cozmek icin gereken sinyaller
    wire         [`BUY_ISKODU_BIT-1:0]   iskodu_w          = buyruk_w[`BUY_ISKODU +: `BUY_ISKODU_BIT]       ;
    wire         [`BUY_HY_BIT-1:0]       hy_w              = buyruk_w[`BUY_HY +: `BUY_HY_BIT]               ;
    wire         [`BUY_KY1_BIT-1:0]      ky1_w             = buyruk_w[`BUY_KY1 +: `BUY_KY1_BIT]             ;
    wire         [`BUY_KY2_BIT-1:0]      ky2_w             = buyruk_w[`BUY_KY2 +: `BUY_KY2_BIT]             ;
    wire         [`BUY_F7_BIT-1:0]       f7_w              = buyruk_w[`BUY_F7 +: `BUY_F7_BIT]               ;
    wire         [`BUY_F3_BIT-1:0]       f3_w              = buyruk_w[`BUY_F3 +: `BUY_F3_BIT]               ;

    // Mikroislem sinyalleri
    reg                                      gecerli_r                                                      ;
    reg          [`YURUT_KODU_BIT - 1: 0]    yurut_kodu_r                                                   ;
    reg          [`ISLEV_KODU_BIT - 1: 0]    islev_kodu_r                                                   ;
    reg          [`IS1_SEC_BIT - 1: 0]       is1_sec_r                                                      ;
    reg          [`IS2_SEC_BIT - 1: 0]       is2_sec_r                                                      ;
    reg          [`ANLIK_DEGER_BIT - 1: 0]   anlik_deger_r                                                  ; 
    reg                                      yukle_buyrugu_r                                                ;
    reg                                      kaydet_buyrugu_r                                               ;
    reg                                      fence_buyrugu_r                                                ;
    reg                                      bellek_turu_w_r                                                ;
    reg                                      bellek_turu_hw_r                                               ;
    reg                                      bellek_isaretli_r                                              ;
    reg                                      bellek_turu_b_r                                                ;
    reg          [`PS_BIT - 1: 0]            ps_r                                                           ;

    reg          [`UIS_BIT - 1: 0]           gc_uis_r                                                       ;
    reg          [`UIS_BIT - 1: 0]           yazmac_gc_uis_r                                                ;

    // Comb. devrede hesaplanan sinyaller
    reg          [31:0]                      i_anlik                                                        ;
    reg          [31:0]                      u_anlik                                                        ;
    reg          [31:0]                      j_anlik                                                        ;
    reg          [31:0]                      s_anlik                                                        ;
    reg          [31:0]                      b_anlik                                                        ;

    reg                                      yanlis_buyruk_r                                                ;

    // denetim sayilabilecek sinyaller
    assign                                  gc_hazir_c              =       !gc_duraklat_g;
    assign                                  gc_uis_c                =       yazmac_gc_uis_r                 ;    
    assign                                  gc_odd_c                =       gecerli_r && yanlis_buyruk_r    ;
    assign                                  gc_odd_ps_c             =       ps_r                            ;

    // Cozmek icin kocaman bir if else/switch agaci koyacagiz.
    // Ataberk: Raven-SoC'deki kod da bu (^) sekilde.
    always @* begin
        gc_uis_r                        =               yazmac_gc_uis_r                                     ;
        // Tum reglerin degerlerini belirle, latch olusturmak istemiyoruz.
        gecerli_r                       =               0                                                   ;
        yurut_kodu_r                    =               0                                                   ;
        islev_kodu_r                    =               0                                                   ;
        is1_sec_r                       =               0                                                   ;
        is2_sec_r                       =               0                                                   ;
        anlik_deger_r                   =               0                                                   ;
        yukle_buyrugu_r                 =               0                                                   ;
        kaydet_buyrugu_r                =               0                                                   ;
        fence_buyrugu_r                 =               0                                                   ;
        bellek_turu_w_r                 =               0                                                   ;
        bellek_turu_hw_r                =               0                                                   ;
        bellek_turu_b_r                 =               0                                                   ;
        bellek_isaretli_r               =               0                                                   ;
        ps_r                            =               bb_buy_ps_g                                         ;

        

        // -------------------------- anlik deger hesapla --------------------------
        // TODO: asagidakileri kontrol et
        i_anlik = buyruk_w[`I_ANLIK_ISARET] ? {{20{1'b1}}, 
                                                buyruk_w[`I_ANLIK+:`I_ANLIK_BIT]} 
                                            : 
                                              {{20{1'b0}},
                                                buyruk_w[`I_ANLIK+:`I_ANLIK_BIT]};
        u_anlik = buyruk_w[`U_ANLIK+:`U_ANLIK_BIT];
        
        // J, S ve B tipi anliklar icin tum indisleri `define'lamak kafa
        // karistirici olabilir, o yuzden yoklar
        // Asagidaki bit alanlari icin riscv tanimlamasina bakabilirsiniz.
        j_anlik = { (buyruk_w[19] ? {11{1'b1}} : {11{1'b0}}),
                    buyruk_w[19], 
                    buyruk_w[12+:8],
                    buyruk_w[20],
                    buyruk_w[21+:10],
                    1'b0
                  };
        s_anlik = { (buyruk_w[31] ? {20{1'b1}} : {20{1'b0}}),
                    buyruk_w[25+:7],
                    buyruk_w[7+:5]
                  };
        b_anlik = { (buyruk_w[31] ? {19{1'b1}} : {19{1'b0}}),
                    buyruk_w[31],
                    buyruk_w[7],
                    buyruk_w[25+:6],
                    buyruk_w[8+:4],
                    1'b0
                  };
        
        // --------------------------- islec sec -----------------------------------
        if (iskodu_w == 7'h3 || iskodu_w == 7'h67 || iskodu_w == 7'h13) begin
            is1_sec_r = `IS1_SEC_KY1;
            is2_sec_r = `IS2_SEC_AD;
            anlik_deger_r = i_anlik;
        end
        
        if (iskodu_w == 7'h37) begin
            is1_sec_r = `IS1_SEC_0;
            is2_sec_r = `IS2_SEC_AD;
            anlik_deger_r = u_anlik;
        end
        
        if (iskodu_w == 7'h17) begin
            is1_sec_r = `IS1_SEC_PS;
            is2_sec_r = `IS2_SEC_AD;
            anlik_deger_r = u_anlik;
        end

        if (iskodu_w == 7'h6f) begin
            is1_sec_r = `IS1_SEC_PS;
            is2_sec_r = `IS2_SEC_AD;
            anlik_deger_r = j_anlik;
        end

        if (iskodu_w == 7'h63) begin
            is1_sec_r = `IS1_SEC_KY1;
            is2_sec_r = `IS2_SEC_KY2;
            anlik_deger_r = b_anlik;
        end

        if (iskodu_w == 7'h23) begin
            is1_sec_r = `IS1_SEC_KY1;
            is2_sec_r = `IS2_SEC_KY2;
            anlik_deger_r = s_anlik;
        end

        if (iskodu_w == 7'h33) begin
            is1_sec_r = `IS1_SEC_KY1;
            is2_sec_r = `IS2_SEC_KY2;
        end
        
        if (iskodu_w == 7'h73) begin
            is1_sec_r = `IS1_SEC_KY1;
            is2_sec_r = `IS2_SEC_AD;
        end
        
        // -------------------- yurut ve islev kodu belirle ------------------------
        // TODO: hint parallel case
        case (iskodu_w)
        7'h37: begin // LUI 
            yurut_kodu_r = `YURUT_KODU_AMB;
            islev_kodu_r = `LUI;
        end 
        7'h17: begin // AUIPC
            yurut_kodu_r = `YURUT_KODU_AMB;
            islev_kodu_r = `AUIPC;            
        end
        7'h13: begin
            yurut_kodu_r = `YURUT_KODU_AMB;
            case (f3_w)
            3'h0: islev_kodu_r = `ADD; 
            3'h1: islev_kodu_r = `SLL;
            3'h2: islev_kodu_r = `SLT;
            3'h3: islev_kodu_r = `SLTU;
            3'h4: islev_kodu_r = `XOR;
            3'h5: islev_kodu_r = f7_w[5] ? `SRA : `SRL; 
            3'h6: islev_kodu_r = `OR;
            3'h7: islev_kodu_r = `AND;
            endcase
        end
        7'h33: begin
            if (f7_w[0]) begin
                yurut_kodu_r = f3_w < 3'h4 ? `YURUT_KODU_TCB : `YURUT_KODU_TBB;
                case (f3_w)
                3'h0: islev_kodu_r = `MUL; 
                3'h1: islev_kodu_r = `MULH;
                3'h2: islev_kodu_r = `MULHSU;
                3'h3: islev_kodu_r = `MULHU;
                3'h4: islev_kodu_r = `DIV;
                3'h5: islev_kodu_r = `DIVU; 
                3'h6: islev_kodu_r = `REM;
                3'h7: islev_kodu_r = `REMU;
                endcase                
            end
            else begin
                yurut_kodu_r = `YURUT_KODU_AMB;
                case (f3_w)
                3'h0: islev_kodu_r = f7_w[5] ? `SUB : `ADD; 
                3'h1: islev_kodu_r = `SLL;
                3'h2: islev_kodu_r = `SLT;
                3'h3: islev_kodu_r = `SLTU;
                3'h4: islev_kodu_r = `XOR;
                3'h5: islev_kodu_r = f7_w[5] ? `SRA : `SRL; 
                3'h6: islev_kodu_r = `OR;
                3'h7: islev_kodu_r = `AND;
                endcase                
            end
        end
        7'h6f: begin
            yurut_kodu_r = `YURUT_KODU_DB;
            islev_kodu_r = `JAL;
        end
        7'h67: begin
            yurut_kodu_r = `YURUT_KODU_DB;
            islev_kodu_r = `JALR;
        end
        7'h63: begin
            yurut_kodu_r = `YURUT_KODU_DB;
            case (f3_w)
            3'h0: islev_kodu_r = `BEQ; 
            3'h1: islev_kodu_r = `BNE;
            3'h4: islev_kodu_r = `BLT;
            3'h5: islev_kodu_r = `BGE; 
            3'h6: islev_kodu_r = `BLTU;
            3'h7: islev_kodu_r = `BGEU;
            endcase
        end
        7'h03: begin
            yurut_kodu_r = `YURUT_KODU_BIB;
            yukle_buyrugu_r = 1'b1;
            case (f3_w)
            3'h0: begin
               islev_kodu_r = `LB;
               bellek_turu_b_r = 1'b1;
               bellek_isaretli_r = 1'b1; 
            end
            3'h1: begin
               islev_kodu_r = `LH;
               bellek_turu_hw_r = 1'b1;
               bellek_isaretli_r = 1'b1; 
            end
            3'h2: begin
               islev_kodu_r = `LW;
               bellek_turu_w_r = 1'b1;
               bellek_isaretli_r = 1'b1; 
            end
            3'h4: begin
               islev_kodu_r = `LBU;
               bellek_turu_b_r = 1'b1;
            end
            3'h5: begin
               islev_kodu_r = `LHU;
               bellek_turu_hw_r = 1'b1;
            end
            endcase           
        end
        7'h23: begin
            yurut_kodu_r = `YURUT_KODU_BIB;
            kaydet_buyrugu_r = 1'b1;
            case (f3_w)
            3'h0: begin
               islev_kodu_r = `SB;
               bellek_turu_b_r = 1'b1;
            end
            3'h1: begin
               islev_kodu_r = `SH;
               bellek_turu_hw_r = 1'b1;
            end
            3'h2: begin
               islev_kodu_r = `SW;
               bellek_turu_w_r = 1'b1;
            end
            endcase           
        end    
        7'h0f: begin
            yurut_kodu_r = `YURUT_KODU_BIB;
            fence_buyrugu_r = 1'b1;
            if (f3_w == 0) islev_kodu_r = `FENCE;
        end  
        7'h73: begin
            // CSR
            yurut_kodu_r = `YURUT_KODU_CSR;
            if (f3_w == 0) begin
                yurut_kodu_r = `YURUT_KODU_SISTEM;
                if (ky2_w == 'h1) islev_kodu_r = `EBREAK;
                if (ky2_w == 'h0) islev_kodu_r = `ECALL;
                if (ky2_w == 'h2) begin 
                    if (f7_w == 'h0) islev_kodu_r = `URET;
                    if (f7_w == 'h18) islev_kodu_r = `MRET;
                end
            end
            if (f3_w == 'h1)  islev_kodu_r = `CSRRW;
            if (f3_w == 'h2)  islev_kodu_r = `CSRRS;
            if (f3_w == 'h3)  islev_kodu_r = `CSRRC;
            if (f3_w == 'h5)  islev_kodu_r = `CSRRWI;
            if (f3_w == 'h6)  islev_kodu_r = `CSRRSI;
            if (f3_w == 'h7)  islev_kodu_r = `CSRRCI;
        end        
        endcase

        // ------------------------------ denetim ----------------------------------
        // ancak ve ancak islev kodu belirlenmediyse
        // yanlis buyruk oddsi olusur
        yanlis_buyruk_r = islev_kodu_r == 0 ? 1'b1 : 1'b0;
        gecerli_r = bb_buy_gecerli_g && ~gc_bosalt_g;
        
        gc_uis_r[`GECERLI]                              = gecerli_r  && ~yanlis_buyruk_r;
        // TODO: if icinde olmasi davranisi degistiriyor mu?
        if (gecerli_r) begin
            // mikroislem sinyallerini bagla
            // TODO: DDB alanlarini doldur
            gc_uis_r[`YURUT_KODU+:`YURUT_KODU_BIT]      = yurut_kodu_r;
            gc_uis_r[`ISLEV_KODU+:`ISLEV_KODU_BIT]      = islev_kodu_r;
            gc_uis_r[`IS1_SEC+:`IS1_SEC_BIT]            = is1_sec_r;
            gc_uis_r[`IS2_SEC+:`IS2_SEC_BIT]            = is2_sec_r;
            gc_uis_r[`ANLIK_DEGER+:`ANLIK_DEGER_BIT]    = anlik_deger_r;
            gc_uis_r[`KY1+:`KY1_BIT]                    = ky1_w;
            gc_uis_r[`KY2+:`KY2_BIT]                    = ky2_w;
            gc_uis_r[`YUKLE_BUYRUGU]                    = yukle_buyrugu_r;
            gc_uis_r[`KAYDET_BUYRUGU]                   = kaydet_buyrugu_r;
            gc_uis_r[`FENCE_BUYRUGU]                    = fence_buyrugu_r;
            gc_uis_r[`BELLEK_TURU_W]                    = bellek_turu_w_r;
            gc_uis_r[`BELLEK_TURU_HW]                   = bellek_turu_hw_r;
            gc_uis_r[`BELLEK_TURU_B]                    = bellek_turu_b_r;
            gc_uis_r[`BELLEK_ISARETLI]                  = bellek_isaretli_r;
            gc_uis_r[`HY+:`HY_BIT]                      = hy_w;
            gc_uis_r[`PS+:`PS_BIT]                      = ps_r;
            gc_uis_r[`DDY_ADRES+:`DDY_ADRES_BIT]        = i_anlik;
            gc_uis_r[`DDY_ANLIK+:`DDY_ANLIK_BIT]        = ky1_w;
        end
    end

    always @(posedge clk_g) begin
        if (rst_g) begin
            yazmac_gc_uis_r[`GECERLI] <= 1'b0;
        end
        else begin
            if (gc_duraklat_g) begin
                yazmac_gc_uis_r <= yazmac_gc_uis_r;
            end
            else begin
                yazmac_gc_uis_r <= gc_uis_r;
            end
        end
    end

endmodule