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
// Create Date: 09/13/2021 3:05:18 PM
// Design Name: 
// Module Name: iki_bit_adimli_bolucu
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


module iki_bit_adimli_bolucu(
    input       [31:0]      a_g,
    input       [31:0]      b_g,
    input                   istek,
    input                   isaretli,
    input                   overflow,
    input                   divbyzero,
    input                   clk,
    output      [31:0]      bolum,
    output      [31:0]      kalan,
    output      reg         bitti=0
    );
    
    /*
        İlk sayı sabit kalırken ikinci sayıyı 31 birim sola kaydırıyoruz kısaca 2^31 ile çarpmış oluyoruz.
        Daha sonra ikinci sayıyı birinciden çıkarıyoruz. Çıkardığımızda negatif bir sayı çıkıyorsa o çarpım içinde yok demektir.
        Var ise bölümü o basamaktaki değer bir oluyor ve ilk sayı yerine artık çıkarılmış halini kullanıyoruz.
        Tek saat dönümü içinde iki bit iki bit ilerlemeli olduğu için bir kaydırılmış hali ile yine bir çıkarma ve kontrol işlemi yapıyoruz.
        Negatif sayılar alınırken positif halleriyle alınıyor ve kalansızsa sadece sonucu negatife çeviriyoruz.
        Kalan var ise sonuç negatifinin bir eksiği ve kalan ikinci sayıdan kalanın çıkarılması ile bulunuyor.
    */
    
    localparam EVET = 1'b1;
    localparam HAYIR = 1'b0;
    
    // bölme işlemine 2^31 sayısıyla başlıyor
    localparam BOLME_BASLANGIC = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    
    reg [31:0] A, A_next;
    reg [63:0] B, B_next;
    reg [31:0] bolum, bolum_next;
    reg [31:0] kalan, kalan_next;
    
    // o anda hangi basamakta olduğu değeri, ikinci de ikinci çıkarma işlemi için
    reg [31:0] bolme_basamagi, bolme_basamagi_next = BOLME_BASLANGIC;
    wire [31:0] ikinci_bolme_basamagi = {1'b0, bolme_basamagi[31:1]};
    
    reg hesaplaniyor = HAYIR, hesaplaniyor_next = HAYIR; 
    reg sonuc_ver = HAYIR, sonuc_ver_next = HAYIR;
    
    reg bitti_next = 0;
    
    
    wire A_negatif_mi = isaretli & a_g[31];
    wire B_negatif_mi = isaretli & b_g[31];
    
    wire sonuc_negatif_mi = A_negatif_mi ^ B_negatif_mi;
    
    // sayının çıkarıldığı yer [32:0] olması bazı taşma durumları için
    wire [32:0] ilk_cikarma_sonucu = A - B[31:0];
    wire ilk_cikarma_sonucu_negatif_mi = ilk_cikarma_sonucu[32];
    wire ilk_cikarma_b_de_tasma_var_mi = |B[63:32];
    // eğer çıkarttığımızda pozitif bir sayı elde ediyorsak çıkarma işlemini yapmalıyız
    wire ilk_cikarmayi_yap = ~ (ilk_cikarma_sonucu_negatif_mi | ilk_cikarma_b_de_tasma_var_mi);
    // ilk çıkartmadan sonraki değer
    wire [31:0] A_ilk_cikarma_sonrasi = ( ilk_cikarmayi_yap ? ilk_cikarma_sonucu[31:0] : A );
    
    // ikinci çıkartmada ikinci sayının bir kaydırılmış hali ve ona göre taşma sonucuna bakıyoruz
    wire [32:0] ikinci_cikarma_sonucu = A_ilk_cikarma_sonrasi - B[32:1];
    wire ikinci_cikarma_sonucu_negatif_mi = ikinci_cikarma_sonucu[32];
    wire ikinci_cikarma_b_de_tasma_var_mi = |B[63:33];
    wire ikinci_cikarmayi_yap = ~ (ikinci_cikarma_sonucu_negatif_mi | ikinci_cikarma_b_de_tasma_var_mi);
    // ikinci çıkartmanın durumuna göre A'nın yeni durumunu atıyoruz
    wire [31:0] A_ikinci_cikarma_sonrasi = ( ikinci_cikarmayi_yap ? ikinci_cikarma_sonucu[31:0] : A_ilk_cikarma_sonrasi );
    
    
    always@ (*) begin
        bitti_next = HAYIR;
        hesaplaniyor_next = hesaplaniyor;
        A_next = A;
        B_next = B;
        bolme_basamagi_next = bolme_basamagi;
        sonuc_ver_next = sonuc_ver;
        kalan_next = kalan;
        bolum_next = bolum;
        if (hesaplaniyor) begin
            hesaplaniyor_next = ~bolme_basamagi[1];
            sonuc_ver_next = bolme_basamagi[1]; // iki kaydıra kaydıra bitmeden bir önceki adımda olan bir
            bitti_next = HAYIR;
            A_next = A_ikinci_cikarma_sonrasi; // ilki hesaplanan çıkarma sonucunu alıyor
            B_next = B >> 2; // ikinci sayıyı iki birim sağa kaydırıyoruz
            bolme_basamagi_next = bolme_basamagi >> 2; // bölme basamağı da beraber sola kayıyor
            case ( {ilk_cikarmayi_yap, ikinci_cikarmayi_yap} ) // çıkarma işlemini yapıp yapmamamıza göre o basamakları bölüme ekliyoruz
                2'b00:
                    bolum_next = bolum;
                2'b01:
                    bolum_next = bolum ^ ikinci_bolme_basamagi;
                2'b10:
                    bolum_next = bolum ^ bolme_basamagi;
                2'b11:
                    bolum_next = bolum ^ bolme_basamagi ^ ikinci_bolme_basamagi;
            endcase
        end
        else if(sonuc_ver) begin // çıkartma işlemlerinden sonraki negatif hesaplama kısmı
            hesaplaniyor_next = HAYIR;
            sonuc_ver_next = HAYIR;
            bitti_next = EVET;
            if (divbyzero) begin
                bolum_next = 32'hffffffff;
                kalan_next = a_g;
            end else if (overflow && isaretli) begin
                bolum_next = 32'h80000000;
                kalan_next = 32'h0;
            end
            else begin
                bolum_next = sonuc_negatif_mi? -bolum: bolum;
                kalan_next = A_negatif_mi? -A: A;
            end
        end
        else if (istek) begin // yeni istek
            hesaplaniyor_next = EVET;
            sonuc_ver_next = HAYIR;
            bitti_next = HAYIR;
            A_next = ( A_negatif_mi ? -a_g : a_g ); // A'yı pozitif olarak al
            B_next = ( B_negatif_mi ? {1'd0, -b_g, 31'd0} : {1'd0, b_g, 31'd0} ); // B 2^31 ile çarpılmış hali ile başlat
            bolme_basamagi_next = BOLME_BASLANGIC; // bölme basamağını başlangıca sıfırla
            kalan_next = 32'd0;
            bolum_next = 32'd0;
        end
    end
    
    always@ (posedge clk) begin
        A <= A_next;
        B <= B_next;
        kalan <= kalan_next;
        bolum <= bolum_next;
        bitti <= bitti_next;
        hesaplaniyor <= hesaplaniyor_next;
        sonuc_ver <= sonuc_ver_next;
        bolme_basamagi <= bolme_basamagi_next;
    end
    
    
    
endmodule
