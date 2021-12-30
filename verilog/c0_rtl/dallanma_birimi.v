`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 
//
// 
// 
// 
// 
// 
// 
// 
//
// 
//
// 
// 
// 
//
//////////////////////////////////////////////////////////////////////////////////

`include "mikroislem.vh"

module dallanma_birimi(
    input         [7:0]     islev_kodu_g                                   , // ?slev tipi girisi
    input         [31:0]    ps_g                                           , //Program sayaci girisi
    input         [31:0]    islec1_g                                       , //?lk islec
    input         [31:0]    islec2_g                                       , //?kinci islec
    input         [31:0]    anlik_g                                        ,  // Dallanma buyruklari icin anlik girisi
    output reg    [31:0]    jal_sonuc_c                                    , // JAL ve JALR buyruklari icin hedef yazmaci degeri
    output reg              dallanma_sonuc_c                               , //Dallanma buyruklari icin atliyorsa 1'b1, atlamiyorsa 1'b0 veren cikis
    output reg    [31:0]    ps_c                                             //Guncellenmis program sayaci cikisi
    );
    
    always@* begin
        ps_c              = 0        ;
        dallanma_sonuc_c  = 0        ;
        jal_sonuc_c       = 0        ;
        case(islev_kodu_g)
            `JAL: begin
                jal_sonuc_c = ps_g + 3'b100                                ;
                ps_c        = ps_g + $signed(islec2_g)                     ; 
            end
            `JALR: begin
            //ayrica risc-v'te anlik degeri 2'nin kati yapmak icin en anlamsiz bitin 0 
            //yapilma olayi kodlanmamis
                jal_sonuc_c      = ps_g + 3'b100; 
                //burada iki islece de signed koydum ama emin degilim
                ps_c             =  ($signed(islec1_g) +  $signed(islec2_g)) & -2 ;
            end
            `BEQ: begin
                dallanma_sonuc_c =  $signed(islec1_g) ==  $signed(islec2_g);
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
            `BNE: begin
                dallanma_sonuc_c =  $signed(islec1_g) != $signed(islec2_g) ;
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
            `BLT: begin
                dallanma_sonuc_c = ($signed(islec1_g) < $signed(islec2_g)) ;
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
            `BLTU: begin
                dallanma_sonuc_c =  islec1_g < islec2_g                    ;
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
            `BGE: begin
                dallanma_sonuc_c = ($signed(islec1_g) >= $signed(islec2_g)); 
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
            `BGEU: begin
                dallanma_sonuc_c =  islec1_g >= islec2_g                   ;
                ps_c             = ps_g +  $signed(anlik_g)                ;
            end 
        endcase

    end
endmodule
