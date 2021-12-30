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
`include "sabitler.vh"
module axi_slave_gfi (
    // AXI4 LITE SLAVE signals
    // Global Signals
    input                       ACLK,
    input                       ARESETn,
    // Write Address Channel
    input [`ADRES_BIT - 1:0]    AWADDR,
    input                       AWVALID,
    input [2:0]                 AWPROT,
    output                      AWREADY,
    // Write Data Channel
    input [`VERI_BIT - 1:0]     WDATA,
    input [`VERI_BIT/8 - 1:0]   WSTRB,
    input                       WVALID,
    output                      WREADY,
    // Write Response Channel
    input                       BREADY,
    output                      BVALID,
    output [1:0]                BRESP,
    // Read Address Channel
    input [`ADRES_BIT - 1:0]    ARADDR,
    input                       ARVALID,
    input [2:0]                 ARPROT,
    output                      ARREADY,
    // Read Data Channel
    input                       RREADY,
    output [`VERI_BIT - 1:0]    RDATA,
    output                      RVALID,
    output [1:0]                RRESP,
    
    // Genel FIFO Aray�z�
    // Komut Kanali
    input                       komut_hazir,
    output                      komut_gecerli,
    output [`VERI_BIT - 1:0]    komut,
    // Veri Kanali
    input [`VERI_BIT - 1:0]     veri,
    input                       veri_gecerli,
    output                      veri_hazir
    );
    
    // AXI4 LITE SLAVE Connections
    localparam [1:0]
        YAZ_IDLE = 2'd0,
        YAZ_DATA = 2'd1,
        YAZ_RESP = 2'd2;
    localparam [0:0]
        OKU_IDLE = 1'd0,
        OKU_DATA = 1'd1;
    localparam [0:0]
        KOMUT_IDLE = 1'd0,
        KOMUT_DATA = 1'd1;
                    
    reg [1:0] yaz_state, yaz_state_ns;
    reg oku_state, oku_state_ns;
    reg komut_state, komut_state_ns;
    
    reg bvalid_r, bvalid_ns_r;
    reg rvalid_r, rvalid_ns_r;
    wire [`VERI_BIT - 1:0] strb_data;
    
    // Genel FIFO Aray�z� Sinyaller
    reg veri_reg_bos, veri_reg_bos_ns;
    reg [`VERI_BIT - 1:0] veri_reg, veri_reg_ns;
     
    reg komut_reg_bos, komut_reg_bos_ns;
    reg [`VERI_BIT - 1:0] komut_reg, komut_reg_ns;
    
    reg komut_gecerli_r, komut_gecerli_ns_r;
    

    // Applying WSTRB to WDATA before pushing into reg
    genvar i;
    for(i = 0; i < `VERI_BIT/8; i = i + 1)
    begin
        assign strb_data[i*8 +: 8] = WSTRB[i]? WDATA[i*8 +: 8]: 8'hff;
    end
    
    // AXI4 LITE SLAVE Logic
    assign AWREADY = (komut_reg_bos)? `HIGH: `LOW;
    assign ARREADY = (~veri_reg_bos)? `HIGH: `LOW;
    assign WREADY = (komut_reg_bos)? `HIGH: `LOW;
    assign BVALID = bvalid_r;
    assign BRESP = 2'b00;
    assign RDATA = veri_reg;
    assign RVALID = rvalid_r;
    assign RRESP = 2'b00;
    
    // Genel FIFO Aray�z� Mant?k
    assign komut_gecerli = komut_gecerli_r;
    assign komut = komut_reg;
    assign veri_hazir = (veri_reg_bos && ARESETn)? `HIGH: `LOW;

    always@* begin
        if(ARESETn) begin
            yaz_state_ns = yaz_state;
            oku_state_ns = oku_state;
            komut_state_ns = komut_state;
            komut_gecerli_ns_r = komut_gecerli_r;
            veri_reg_bos_ns = veri_reg_bos;
            komut_reg_bos_ns = komut_reg_bos;
            veri_reg_ns = veri_reg;
            komut_reg_ns = komut_reg;
            rvalid_ns_r = rvalid_r;
            bvalid_ns_r = bvalid_r;
            
            case(yaz_state)
                YAZ_IDLE: begin
                    if(komut_reg_bos && WVALID) begin
                        komut_reg_bos_ns = `LOW;
                        komut_reg_ns = strb_data;
                        yaz_state_ns = YAZ_DATA;
                    end else begin
                        yaz_state_ns = YAZ_IDLE;
                    end
                end
                YAZ_DATA: begin
                    if(BREADY) begin
                        bvalid_ns_r = `HIGH;
                        yaz_state_ns = YAZ_RESP;
                    end
                end
                YAZ_RESP: begin
                    bvalid_ns_r = `LOW;
                    yaz_state_ns = YAZ_IDLE;
                end
            endcase
            
            case(oku_state)
                OKU_IDLE: begin
                    if(RREADY && ~veri_reg_bos) begin
                        rvalid_ns_r = `HIGH;
                        veri_reg_bos_ns = `HIGH;
                        oku_state_ns = OKU_DATA;
                    end
                end
                OKU_DATA: begin
                    rvalid_ns_r = `LOW;
                    oku_state_ns = OKU_IDLE;
                end
            endcase
            
            case(komut_state)
                KOMUT_IDLE: begin
                    if(komut_hazir && ~komut_reg_bos) begin
                        komut_gecerli_ns_r = `HIGH;
                        komut_state_ns = KOMUT_DATA;
                    end
                end
                KOMUT_DATA: begin
                    komut_reg_bos_ns = `HIGH;
                    komut_gecerli_ns_r = `LOW;
                    komut_state_ns = KOMUT_IDLE;
                end
            endcase
    
            if(veri_gecerli && veri_reg_bos) begin
                veri_reg_bos_ns = `LOW;
                veri_reg_ns = veri;
            end
        end
    end
    
    always@(posedge ACLK) begin
        if(~ARESETn) begin
            komut_gecerli_r     <= `LOW;
            yaz_state           <= YAZ_IDLE;
            oku_state           <= OKU_IDLE;
            komut_state         <= KOMUT_IDLE;
            komut_reg           <= 0;
            veri_reg            <= 0;
            veri_reg_bos        <= `HIGH;
            komut_reg_bos       <= `HIGH;
            rvalid_r            <= `LOW;
            bvalid_r            <= `LOW;
        end else begin
            komut_gecerli_r     <= komut_gecerli_ns_r;
            yaz_state           <= yaz_state_ns;
            oku_state           <= oku_state_ns;
            komut_state         <= komut_state_ns;
            komut_reg           <= komut_reg_ns;
            veri_reg            <= veri_reg_ns;
            veri_reg_bos        <= veri_reg_bos_ns;
            komut_reg_bos       <= komut_reg_bos_ns;
            rvalid_r            <= rvalid_ns_r;
            bvalid_r            <= bvalid_ns_r;
        end
    end

endmodule
