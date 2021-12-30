`timescale 1ns / 1ps

`include "sabitler.vh"

module buyruk_bellegi_sram
(
    input           [`BB_ADRES_BIT-1:0]             addra                   ,
    input                                           clka                    ,
    input           [31:0]                          dina                    ,
    input                                           ena                     ,
    input           [3:0]                           wea                     ,
                
    output          [31:0]                          douta                   ,

    // To SRAM outside c0's macro
    output                                          csb0                    ,
    output                                          web0                    ,
    output          [3:0]                           wmask0                  ,
    output          [`BB_ADRES_BIT-1:0]             addr0                   ,
    output          [31:0]                          din0                    ,
    input           [31:0]                          dout0                   ,

    output                                          csb1                    ,
    output          [`BB_ADRES_BIT-1:0]             addr1                   ,
    input           [31:0]                          dout1                         

);

    assign      csb0        =           ~(ena&(|wea))       ;
    assign      web0        =           ~(|wea)             ;
    assign      wmask0      =           wea                 ;

    assign      addr0       =           addra               ;
    assign      din0        =           dina                ;
    //assign      dout0       =           32'b0           ;

    assign      csb1        =           ~(ena&(~(|wea)))    ;
    assign      addr1       =           addra               ;
    assign      douta       =           dout1               ;


endmodule
