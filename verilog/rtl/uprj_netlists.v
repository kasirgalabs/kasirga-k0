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

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS

`ifdef GL
    // Assume default net type to be wire because GL netlists don't have the wire definitions
    `default_nettype wire
    `include "gl/user_project_wrapper.v"
    `include "gl/c0_system.v"
`else
    `include "c0_rtl/axil_slave_gfa.v"
    `include "c0_rtl/adres_tekleyici.v"
    `include "c0_rtl/aritmetik_mantik_birimi.v"
    `include "c0_rtl/axil_interconnect.v"
    `include "c0_rtl/baslangic_bellegi.v"
    `include "c0_rtl/bellek_islem_birimi.v"
    `include "c0_rtl/buyruk_bellegi_sram.v"
    `include "c0_rtl/cekirdek.v"
    `include "c0_rtl/dallanma_birimi.v"
    `include "c0_rtl/denetim_durum_birimi.v"
    `include "c0_rtl/getir_coz.v"
    `include "c0_rtl/mikroislem.vh"
    `include "c0_rtl/on_taraf.v"
    `include "c0_rtl/sabitler.vh"
    `include "c0_rtl/UART_alici.v"
    `include "c0_rtl/UART_GFA.v"
    `include "c0_rtl/UART_verici.v"
    `include "c0_rtl/iki_bit_adimli_bolucu.v"
    `include "c0_rtl/tamsayi_bolme_birimi.v"
    `include "c0_rtl/iki_bit_adimli_carpici.v"
    `include "c0_rtl/tamsayi_carpma_birimi.v"
    `include "c0_rtl/veri_bellegi_sram.v"
    `include "c0_rtl/yazmac_obegi.v"
    `include "c0_rtl/yazmac_oku_yurut.v"
    `include "c0_rtl/yazmac_yaz.v"
    `include "c0_rtl/sky130_sram_2kbyte_1rw1r_32x512_8.v"
    `include "c0_rtl/c0_system.v"
    `include "user_project_wrapper.v"
`endif




