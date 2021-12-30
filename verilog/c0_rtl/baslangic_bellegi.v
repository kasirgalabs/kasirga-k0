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

module baslangic_bellegi(
  input                             clk_g                                 ,
  input                             rst_g                                 ,
 
  input           [31:0]            adres_g                               ,
  output          [31:0]            buyruk_c                              ,
  input                             ena_g                         
);

  wire            [31:0]            buyruklar     [40:0]                  ;
  reg             [31:0]            buyruk_r                              ;
  reg             [31:0]            buyruk_ns                             ;

  assign buyruk_c                   =         buyruk_r                    ;
    
  assign buyruklar[0]               =         32'H800000B7                ;
  assign buyruklar[1]               =         32'H00010537                ;
  assign buyruklar[2]               =         32'H40000A37                ;
  assign buyruklar[3]               =         32'H0000A103                ;
  assign buyruklar[4]               =         32'H0000A183                ;
  assign buyruklar[5]               =         32'H0000A203                ;
  assign buyruklar[6]               =         32'H0000A283                ;
  assign buyruklar[7]               =         32'H00028313                ;
  assign buyruklar[8]               =         32'H00831313                ;
  assign buyruklar[9]               =         32'H00436333                ;
  assign buyruklar[10]              =         32'H00831313                ;
  assign buyruklar[11]              =         32'H00336333                ;
  assign buyruklar[12]              =         32'H00831313                ;
  assign buyruklar[13]              =         32'H00236333                ;
  assign buyruklar[14]              =         32'H00000393                ;
  assign buyruklar[15]              =         32'H00008103                ;
  assign buyruklar[16]              =         32'H00250023                ;
  assign buyruklar[17]              =         32'H00138393                ;
  assign buyruklar[18]              =         32'H00150513                ;
  assign buyruklar[19]              =         32'H00638463                ;
  assign buyruklar[20]              =         32'HFEDFF06F                ;
  assign buyruklar[21]              =         32'H0000A103                ;
  assign buyruklar[22]              =         32'H0000A183                ;
  assign buyruklar[23]              =         32'H0000A203                ;
  assign buyruklar[24]              =         32'H0000A283                ;
  assign buyruklar[25]              =         32'H00028313                ;
  assign buyruklar[26]              =         32'H00831313                ;
  assign buyruklar[27]              =         32'H00436333                ;
  assign buyruklar[28]              =         32'H00831313                ;
  assign buyruklar[29]              =         32'H00336333                ;
  assign buyruklar[30]              =         32'H00831313                ;
  assign buyruklar[31]              =         32'H00236333                ;
  assign buyruklar[32]              =         32'H00000393                ;
  assign buyruklar[33]              =         32'H00008103                ;
  assign buyruklar[34]              =         32'H002A0023                ;
  assign buyruklar[35]              =         32'H00138393                ;
  assign buyruklar[36]              =         32'H001A0A13                ;
  assign buyruklar[37]              =         32'H00638463                ;
  assign buyruklar[38]              =         32'HFEDFF06F                ;
  assign buyruklar[39]              =         32'H00010537                ;
  assign buyruklar[40]              =         32'H00050067                ;                       
                                                    
  always @* begin                                 
    buyruk_ns                       =         buyruklar[(adres_g>>2)]     ;
  end
  
  always @(posedge clk_g) begin
    if (rst_g)
      buyruk_r                      <=        buyruklar[0]                ;
    else begin
      if(ena_g) 
        buyruk_r                    <=        buyruk_ns                   ;
      else
        buyruk_r                    <=        buyruk_r                    ;
      
    end        
  end
  

endmodule