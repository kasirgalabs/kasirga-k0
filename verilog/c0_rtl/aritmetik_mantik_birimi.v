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
