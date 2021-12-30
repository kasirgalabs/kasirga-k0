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
