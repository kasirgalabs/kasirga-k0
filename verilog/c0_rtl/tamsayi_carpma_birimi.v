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
// Create Date: 09/11/2021 03:15:46 PM
// Design Name: 
// Module Name: tamsayi_carpma_birimi
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


module tamsayi_carpma_birimi(
    input                 clk_g                                                         ,
    input        [3:0]    islev_kodu_g                                                  ,
    input        [31:0]   islec1_g                                                      ,
    input        [31:0]   islec2_g                                                      ,
    input                 hazir_g                                                     ,
    output                bitti_c                                                       ,
    output       [31:0]   sonuc_c
    );
    
    localparam MUL      = 4'h1; 
    localparam MULH     = 4'h2; 
    localparam MULHU    = 4'h4;
    localparam MULHSU   = 4'h8; 
    
    reg basla, basla_next;
    reg [3:0] islev_kodu_r, islev_kodu_ns_r;
    reg [31:0] A, A_next, B, B_next;
    // MUL ve MULH işin işlemleri işaretli gibi yap diğerleri için işaretsiz
    wire a_isaretli = ( islev_kodu_r == MUL | islev_kodu_r == MULH | islev_kodu_r == MULHSU);
    wire b_isaretli = ( islev_kodu_r == MUL | islev_kodu_r == MULH );

    // çarpma ünitesi sonucu 64 bit olarak döndürüyor
    wire [63:0] carpim;
    
    // işlemin bittiği clocku vermek için
    wire bitti;
    
    iki_bit_adimli_carpici carpma_birimi (
        .a_g(A),
        .b_g(B),
        .istek(basla),
        .a_isaretli(a_isaretli),
        .b_isaretli(b_isaretli),
        .clk(clk_g),
        .sonuc(carpim),
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
    
    // doğrudan çarpma biriminin verdiği değeri atıyoruz
    assign bitti_c = bitti;
    
    // MUL ve MULU için çarpımın ilk 32 basamağını yolla diğerleri için son 32 basamağı
    assign sonuc_c = (islev_kodu_r == MUL) ? carpim[31:0] : carpim[63:32];
    
    
    
endmodule

