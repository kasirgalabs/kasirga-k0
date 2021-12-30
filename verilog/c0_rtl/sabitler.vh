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
//-----------Diger----------------
`define BASLANGIC_ADRESI 32'h0
`define BASBEL_TABAN_ADR 32'h0 // baslangic bellegi (bootrom) taban adresi
`define BB_TABAN_ADR 32'h1_0000 // buyruk bellegi baslangic adresi
`define VB_TABAN_ADR 32'h4000_0000 // veri bellegi baslangic adresi

`define HIGH 1
`define LOW  0

`define VERI_BIT  32
//-----------Bellek---------------
`define ADRES_BIT 32

//-----------Mikroislem-----------
`define UIS_BIT 197

//-----------GetirCoz-------------
`define BB_ADRES_BIT 32
`define BUYRUK_BIT 32

`define BUY_ISKODU 0
`define BUY_ISKODU_BIT 7
`define BUY_HY 7
`define BUY_HY_BIT 5
`define BUY_KY1 15
`define BUY_KY1_BIT 5
`define BUY_KY2 20
`define BUY_KY2_BIT 5
`define BUY_F7 25
`define BUY_F7_BIT 7
`define BUY_F3 12
`define BUY_F3_BIT 3

`define I_ANLIK 20
`define I_ANLIK_BIT 12
`define I_ANLIK_ISARET 31

`define U_ANLIK 12
`define U_ANLIK_BIT 20

`define ODD_BIT 5

//-------------DDY---------------

// Kural disi durum kodlari
`define KDD_HBA   32'd0   // hizasiz buyruk adresi
`define KDD_YB    32'd2   // yanlis buyruk
`define KDD_HYA   32'd4   // hizasiz yukle buyrugu
`define KDD_HKA   32'd6   // hizasiz kaydet buyrugu
`define KDD_MRET  32'd11  // makine modundan ortam cagrisi

// Priv. mode degerleri
`define PRIV_USER         2'd0
`define PRIV_SUPER        2'd1
`define PRIV_MACHINE      2'd3

// Yazmac adresleri
// TODO, bunlar uyumlu mu?
`define DDY_MSTATUS       12'h300
`define DDY_MISA          12'h301
`define DDY_MEDELEG       12'h302
`define DDY_MIDELEG       12'h303
`define DDY_MIE           12'h304
`define DDY_MTVEC         12'h305
`define DDY_MSCRATCH      12'h340
`define DDY_MEPC          12'h341
`define DDY_MCAUSE        12'h342
`define DDY_MTVAL         12'h343
`define DDY_MIP           12'h344
`define DDY_MCYCLE        12'hc00
`define DDY_MTIME         12'hc01
`define DDY_MTIMEH        12'hc81
`define DDY_MHARTID       12'hF14

// MSTATUS yazmac offsetleri
`define MSTATUS_MIE       3       
`define MSTATUS_MPIE      7 
`define MSTATUS_MPP       11