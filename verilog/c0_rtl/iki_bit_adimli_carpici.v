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
// Create Date: 09/09/2021 03:30:10 PM
// Design Name: 
// Module Name: iki_bit_adimli_carpici
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


module iki_bit_adimli_carpici(
    input       [31:0]      a_g,
    input       [31:0]      b_g,
    input                   istek,
    input                   a_isaretli,
    input                   b_isaretli,
    input                   clk,
    output      [63:0]      sonuc,
    output      reg         bitti = 0
    );
    
    /*
        Çarpma her clock başı b'nin en küçük iki biti a ile çarpılarak çarpıma ekleniyor.
        Sonraki adımda b'yi iki sağa kaydırıp a'yı iki sola kaydırarak yeni en küçük bitiyle olacak çarpımın asıl değerini koruyoruz.
        Sayılar negatif veya pozitif olmasına bakılmaksızın pozitif olarak alınıyor.
        Eğer sonuç negatif olması gerkiyorsa sonucu negatife çevirilmiş haliyle veriyor aksi halde normal kalıyor.
        Örnek:
            3   x   5   =   15
            -2  x   -3  =   2   x   3   =   6
            -2  x   4   = -(2   x   4)  =  -8
    */
    
    localparam EVET = 1'b1;
    localparam HAYIR = 1'b0;
    
    reg[63:0] A, A_next;
    reg[31:0] B, B_next;
    
    reg[63:0] carpim, carpim_next;
    
    reg hesaplaniyor = HAYIR, hesaplaniyor_next;
    
    reg bitti_next = 0;
    
    
    wire a_negatif_mi = a_isaretli & a_g[31];
    wire b_negatif_mi = b_isaretli & b_g[31];
    
    wire sonuc_negatif_mi = a_negatif_mi ^ b_negatif_mi;
    
    // B'nin ilk biti ile A'nın çarpımı B'nin ilk bit 1 ise A'nın kendisi değilse sıfırdır
    wire[63:0] ilk_bit_carpim = ( B[0] ? A : 64'd0 );
    
    // B'nin ikinci biti ile A'nın çarpımı B'nin ikinci biti 1 ise A'nın ikiyle çarpılmış/bir kaydırılmış halidir değilse 0
    wire[63:0] ikinci_bit_carpim = ( B[1] ? {A[62:0], 1'd0} : 64'd0 );
    
    
    reg[3:0] adim = 4'hf, adim_next = 4'h7; // sabit clock sayısı
    
    
    always@ (*) begin
        bitti_next = HAYIR;
        hesaplaniyor_next = hesaplaniyor;
        A_next = A;
        B_next = B;
        carpim_next = carpim;
        adim_next = adim;
        if (hesaplaniyor) begin
            hesaplaniyor_next = |(adim);
            bitti_next = (adim == 4'h0); // sabit clock sayısı // bitti_next = ~ (|B[31:2]) & ~bitti;
            adim_next = adim - 1'b1; // sabit clock sayısı
            A_next = A << 2;
            B_next = B >> 2;
            carpim_next = carpim + ilk_bit_carpim + ikinci_bit_carpim;
        end
        else if (istek) begin
            hesaplaniyor_next = EVET;
            A_next = ( a_negatif_mi ? {32'd0, -a_g} : {32'd0, a_g} ); // A 64 bit olduğu için yanına 0 ekliyoruz
            B_next = ( b_negatif_mi ? -b_g : b_g );
            carpim_next = 64'd0; // çarpımı sıfırla
            bitti_next = HAYIR;
            adim_next = 4'hf; // sabit clock sayısı
        end
    end
    
    always@ (posedge clk) begin
        A <= A_next;
        B <= B_next;
        carpim <= carpim_next;
        bitti <= bitti_next;
        hesaplaniyor <= hesaplaniyor_next;;
        adim <= adim_next; // sabit clock sayısı
    end
    
    assign sonuc = ( sonuc_negatif_mi ? -carpim : carpim );
    
endmodule
