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
// Create Date: 30.04.2021 15:05:00
// Design Name: 
// Module Name: yazmac_yaz
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

`include "sabitler.vh"
`include "mikroislem.vh"
// mikroislem denetim 53. bit yazmaca_yaz
// mikroislem denetim 21:52 hedef yazmacina yazilacak deger
// mikroislem denetim 16:20 hedef yazmac tanimlayicisi

`define DEBUG_YAZMAC_YAZ

module yazmac_yaz(
    input                                   clk_g                                                   ,
    input         [`UIS_BIT - 1: 0]         yoy_uis_g                                               ,

    output   reg                            yo_yaz_c                                                ,
    output   reg  [`BUY_HY_BIT - 1: 0]      yo_yaz_hedef_c                                          ,
    output   reg  [31: 0]                   yo_yaz_veri_c                                           ,
    
    output   reg                            ddy_yaz_c                                               ,
    output   reg  [11: 0]                   ddy_yaz_hedef_c                                         ,
    output   reg  [31: 0]                   ddy_yaz_veri_c      
    );

`ifdef DEBUG_YAZMAC_YAZ

    wire                            gecerli        =    yoy_uis_g[`GECERLI]                                                         ;
    wire        [`PS_BIT-1:0]       ps             =    yoy_uis_g[`PS +: `PS_BIT]                                                   ;
    wire        [`HY_DEGER_BIT-1:0] hy_deger       =    yoy_uis_g[`HY_DEGER +: `HY_DEGER_BIT]                                       ;
    wire        [`HY_BIT-1:0]       hy_adres       =    yoy_uis_g[`HY+:`HY_BIT];
    wire                            hy_yaz         =    yoy_uis_g[`HY_YAZ];

`endif


    always @* begin
        yo_yaz_c        =    yoy_uis_g[`GECERLI] && yoy_uis_g[`HY_YAZ] && (!yoy_uis_g[`HY+:`HY_BIT] == {`HY_BIT{1'b0}})   ;
        yo_yaz_hedef_c  =    yoy_uis_g[`HY+:`HY_BIT]                                               ;
        yo_yaz_veri_c   =    yoy_uis_g[`HY_DEGER+:`HY_DEGER_BIT]                                   ;

        ddy_yaz_c       =    yoy_uis_g[`GECERLI] &&  yoy_uis_g[`DDY_YAZ]                                                   ;
        ddy_yaz_hedef_c =    yoy_uis_g[`DDY_ADRES+:`DDY_ADRES_BIT]                                 ;
        ddy_yaz_veri_c  =    yoy_uis_g[`DDY_VERI+:`DDY_VERI_BIT]                                    ;
    end
endmodule