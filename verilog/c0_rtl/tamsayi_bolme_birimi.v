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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2021 12:04:40 PM
// Design Name: 
// Module Name: tamsayi_bolme_birimi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tamsayi_bolme_birimi(
    input                 clk_g                                                         ,
    input        [3:0]    islev_kodu_g                                                  ,
    input        [31:0]   islec1_g                                                      ,
    input        [31:0]   islec2_g                                                      ,
    input                 hazir_g                                                     ,
    output                bitti_c                                                       ,
    output       [31:0]   sonuc_c
    );
    
    
    localparam DIV  = 4'h1; 
    localparam DIVU = 4'h2; 
    localparam REM  = 4'h4; 
    localparam REMU = 4'h8; 
    
    reg basla, basla_next;

    reg [3:0] islev_kodu_r, islev_kodu_ns_r;
    reg [31:0] A, A_next, B, B_next;
        
    // DIV ve REM işlemleri işin işaretli gibi yap diğerleri için işaretsiz
    wire isaretli = ( islev_kodu_r == DIV | islev_kodu_r == REM );
    wire overflow = ((A == 32'h80000000) && (B == 32'hffffffff));
    wire divbyzero = (B == 32'd0);
    
    // bölme ünitesi bölüm ve kalan/mod'u döndürüyor
    wire [31:0] bolum;
    wire [31:0] kalan;
    
    // işlemin bittiği clocku vermek için
    wire bitti;
    
    iki_bit_adimli_bolucu bolme_birimi (
        .a_g(A),
        .b_g(B),
        .istek(basla),
        .isaretli(isaretli),
        .overflow(overflow),
        .divbyzero(divbyzero),
        .clk(clk_g),
        .bolum(bolum),
        .kalan(kalan),
        .bitti(bitti)
    );
    
    always @* begin
        islev_kodu_ns_r = (hazir_g)? islev_kodu_g: islev_kodu_r;
        A_next = (hazir_g)? islec1_g: A;
        B_next = (hazir_g)? islec2_g: B;
        basla_next = hazir_g;
    end
    
    always @(posedge clk_g) begin
        islev_kodu_r <= islev_kodu_ns_r;
        A <= A_next;
        B <= B_next;
        basla <= basla_next;
    end
    
    // doğrudan bölme biriminin verdiği değeri atıyoruz
    assign bitti_c = bitti;
    
    // DIV ve DIVU için bölümü diğerleri için kalanı veriyoruz
    assign sonuc_c = ( islev_kodu_r == DIV | islev_kodu_r == DIVU ) ? bolum : kalan;
    
    
    
    
    
    
endmodule