`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2021 05:23:04 PM
// Design Name: 
// Module Name: yazmac_obegi
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

module yazmac_obegi(
    input                           clk_g                       ,
    input                           rst_g                       ,
    input         [`HY_BIT-1:0]     ky1_adres_g                 ,
    input         [`HY_BIT-1:0]     ky2_adres_g                 ,
    input         [`HY_BIT-1:0]     hy_adres_g                  ,
    input         [31:0]            hy_deger_g                  ,
    input                           yaz_g                       ,
    output reg    [31:0]            ky1_deger_c                 ,
    output reg    [31:0]            ky2_deger_c
    );
    
    reg           [31:0]    y_obek[31:0]                        ;
    
    always@* begin
        ky1_deger_c            = y_obek[ky1_adres_g]            ;
        ky2_deger_c            = y_obek[ky2_adres_g]            ;
    end
    
    always@(posedge clk_g) begin
        if (rst_g) begin
            y_obek[0]           <=  0                           ;
        end
        else if(yaz_g) begin
            y_obek[hy_adres_g]  <=  hy_deger_g                  ;
        end
    end
endmodule
