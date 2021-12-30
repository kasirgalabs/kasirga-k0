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
///////////////////////////
// Mikroislem sinyalleri//
`define DDY_ADRES_BIT 12
`define DDY_ADRES 185

`define DDY_VERI_BIT 32
`define DDY_VERI 153

`define DDY_ANLIK_BIT 5
`define DDY_ANLIK 148

`define DDY_YAZ 147

`define GECERLI 146

`define YURUT_KODU_BIT 7
`define YURUT_KODU 139
`define YURUT_KODU_AMB 'h1
`define YURUT_KODU_DB 'h2
`define YURUT_KODU_BIB 'h4
`define YURUT_KODU_TCB 'h8
`define YURUT_KODU_TBB 'h10
`define YURUT_KODU_CSR 'h20
`define YURUT_KODU_SISTEM 'h40

`define ISLEV_KODU_BIT 12
`define ISLEV_KODU 127

`define IS1_SEC_BIT 3
`define IS1_SEC 124
`define IS1_SEC_KY1 'h1
`define IS1_SEC_PS 'h2
`define IS1_SEC_0 'h4


`define IS2_SEC_BIT 5
`define IS2_SEC 119
`define IS2_SEC_CSR_AD 'h10 // AD: Anlik deger
`define IS2_SEC_0 'h8
`define IS2_SEC_4 'h4
`define IS2_SEC_AD 'h2
`define IS2_SEC_KY2 'h1

`define ANLIK_DEGER_BIT 32
`define ANLIK_DEGER 87

`define KY1_BIT 5
`define KY1 82

`define KY2_BIT 5
`define KY2 77

`define BELLEK_BUYRUGU_BIT 3
`define BELLEK_BUYRUGU 74
`define YUKLE_BUYRUGU 76
`define KAYDET_BUYRUGU 75
`define FENCE_BUYRUGU 74


`define BELLEK_TURU_BIT 3
`define BELLEK_TURU 71
`define BELLEK_TURU_W 73
`define BELLEK_TURU_HW 72
`define BELLEK_TURU_B 71


`define BELLEK_ISARETLI 70

`define HY_YAZ 69

`define HY_DEGER_BIT 32 
`define HY_DEGER 37


`define HY_BIT 5
`define HY 32

`define PS_BIT 32
`define PS 0


////////////////////////
 // AMB islev kodlari//
 `define ADD 'h1
 `define SUB 'h2
 `define AND 'h4
 `define OR 'h8
 `define XOR 'h10
 `define SLT 'h20
 `define SLTU 'h40
 `define SLL 'h80
 `define SRL 'h100
 `define SRA 'h200
 `define LUI 'h400
 `define AUIPC 'h800
////////////////////////
 // DB islev kodlari //
 `define JAL  'h1
 `define JALR 'h2
 `define BEQ  'h4
 `define BNE  'h8
 `define BLT  'h10
 `define BLTU 'h20
 `define BGE  'h40
 `define BGEU 'h80
/////////////////////////
 // BIB islev kodlari //
 `define LW    'h1 
 `define LH    'h2 
 `define LHU   'h4 
 `define LB    'h8 
 `define LBU   'h10
 `define SW    'h20
 `define SH    'h40
 `define SB    'h80
 `define FENCE 'h100
 /////////////////////////////
 // Bellk Buyrugu tanimlamalari//
 `define FENCE_b 'h1
 `define KAYDET_b 'h2
 `define YUKLE_b 'h4
 ///////////////////////////////
//////////////////////////////
 // CSR islev kodlari //
 `define ECALL  'h1
 `define EBREAK 'h2
 `define URET   'h4
 `define MRET   'h8
 `define CSRRW  'h10
 `define CSRRS  'h20
 `define CSRRC  'h40 
 `define CSRRWI  'h80
 `define CSRRSI  'h100
 `define CSRRCI  'h200
/////////////////////////
 // TCB islev kodlari //
 `define MUL 'h1
 `define MULH 'h2
 `define MULHU 'h4
 `define MULHSU 'h8
/////////////////////////
 // TBB islev kodlari //
 `define DIV 'h1
 `define DIVU 'h2
 `define REM 'h4
 `define REMU 'h8

