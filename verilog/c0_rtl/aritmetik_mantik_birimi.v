`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2021 08:40:19 PM
// Design Name: 
// Module Name: AMB
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

`include "mikroislem.vh"

module aritmetik_mantik_birimi(
    input         [11:0]    islev_kodu_g                                         ,
    input         [31:0]    islec1_g                                             ,
    input         [31:0]    islec2_g                                             ,
    output reg    [31:0]    sonuc_c
    );
    
    always@* begin
        sonuc_c             = 0                                                  ;
        case(islev_kodu_g)
            `ADD:   sonuc_c = islec1_g + islec2_g                                ;
            `SUB:   sonuc_c = islec1_g - islec2_g                                ;
            `AND:   sonuc_c = islec1_g & islec2_g                                ;
            `OR:    sonuc_c = islec1_g | islec2_g                                ;
            `XOR:   sonuc_c = islec1_g ^ islec2_g                                ;
            `SLT:   sonuc_c = ($signed(islec1_g) < $signed(islec2_g))            ; 
            `SLTU:  sonuc_c = (islec1_g < islec2_g)                              ; 
            `SLL:   sonuc_c = islec1_g << islec2_g[4:0]                          ; 
            `SRL:   sonuc_c = $signed({1'b0, islec1_g}) >>> islec2_g[4:0]        ; 
            `SRA:   sonuc_c = $signed({islec1_g[31], islec1_g}) >>> islec2_g[4:0]; 
            `LUI:   sonuc_c = islec2_g[19:0]  << 12                              ; // islec2 = anlik
            `AUIPC: sonuc_c = islec1_g + (islec2_g[19:0]  << 12)                 ; //islec1=ps, islec2=anlik
        endcase
    end

    
endmodule
