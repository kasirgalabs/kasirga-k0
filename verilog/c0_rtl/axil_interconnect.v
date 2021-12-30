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
module axi_interconnect #(
    parameter                       SLAVE_NUM   = 16, //maximum 16 olabilir
    parameter [32*SLAVE_NUM - 1:0]  bases       = 0,
    parameter [32*SLAVE_NUM - 1:0]  ranges      = 0   
    ) (
        // Masterside WAC
        input [`ADRES_BIT - 1:0]                    m_axi_awaddr,
        input                                       m_axi_awvalid,
        input [2:0]                                 m_axi_awprot,
        output reg                                  m_axi_awready,
        // Masterside WDC
        input [`VERI_BIT - 1:0]                     m_axi_wdata,
        input [3:0]                                 m_axi_wstrb,
        input                                       m_axi_wvalid,
        output reg                                  m_axi_wready,
        // Masterside WRC
        input                                       m_axi_bready,
        output reg [1:0]                            m_axi_bresp,
        output reg                                  m_axi_bvalid,
        // Masterside RAC
        input [`ADRES_BIT - 1:0]                    m_axi_araddr,
        input                                       m_axi_arvalid,
        input [2:0]                                 m_axi_arprot,
        output reg                                  m_axi_arready,
        // Masterside RDC
        input                                       m_axi_rready,
        output reg [`VERI_BIT - 1:0]                m_axi_rdata,   
        output reg [1:0]                            m_axi_rresp,
        output reg                                  m_axi_rvalid,
        // Slaveside WAC
        input [SLAVE_NUM - 1:0]                     s_axi_awready,
        output reg [`ADRES_BIT*SLAVE_NUM - 1:0]     s_axi_awaddr,
        output reg [SLAVE_NUM - 1:0]                s_axi_awvalid,
        output reg [3*SLAVE_NUM - 1:0]              s_axi_awprot,
        // Slaveside WDC
        input [SLAVE_NUM - 1:0]                     s_axi_wready,
        output reg [`VERI_BIT*SLAVE_NUM - 1:0]      s_axi_wdata,
        output reg [4*SLAVE_NUM - 1:0]              s_axi_wstrb,
        output reg [SLAVE_NUM - 1:0]                s_axi_wvalid,
        // Slaveside WRC
        input [2*SLAVE_NUM - 1:0]                   s_axi_bresp,
        input [SLAVE_NUM - 1:0]                     s_axi_bvalid,
        output reg [SLAVE_NUM - 1:0]                s_axi_bready,
        // Slaveside RAC
        input [SLAVE_NUM - 1:0]                     s_axi_arready,
        output reg [`ADRES_BIT*SLAVE_NUM - 1:0]     s_axi_araddr,
        output reg [SLAVE_NUM - 1:0]                s_axi_arvalid,
        output reg [3*SLAVE_NUM - 1:0]              s_axi_arprot,
        // Slaveside RDC
        input [`VERI_BIT*SLAVE_NUM - 1:0]           s_axi_rdata,
        input [2*SLAVE_NUM - 1:0]                   s_axi_rresp,
        input [SLAVE_NUM - 1:0]                     s_axi_rvalid,
        output reg [SLAVE_NUM - 1:0]                s_axi_rready
    );
    
    wire [SLAVE_NUM - 1:0]  slave_write;
    wire [SLAVE_NUM - 1:0]  slave_read;
        
    genvar s;
    for( s = 0; s < SLAVE_NUM; s = s + 1) begin
        assign slave_write[s] = (m_axi_awvalid || m_axi_wvalid || m_axi_bready) ? ((m_axi_awaddr <= (ranges[s*32+:32] + bases[s*32+:32] - 1) && m_axi_awaddr >= bases[s*32+:32])? `HIGH: `LOW): `LOW;   
        assign slave_read[s] = (m_axi_arvalid || m_axi_rready)? ((m_axi_araddr <= (ranges[s*32+:32] + bases[s*32+:32] - 1) && m_axi_araddr >= bases[s*32+:32])? `HIGH: `LOW): `LOW;
    end
    
    reg[3:0] write_id;
    reg[3:0] read_id;
    
    integer i;
    always @* begin
        write_id  = 0;
        read_id   = 0;
        for( i = 0; i < SLAVE_NUM; i = i + 1) begin
            if(slave_write[i]) begin
                write_id = i;
                s_axi_awaddr[`ADRES_BIT*i+:`ADRES_BIT]   = m_axi_awaddr;
                s_axi_awprot[3*i+:3]                     = m_axi_awprot;
                s_axi_awvalid[i]                         = m_axi_awvalid;
                s_axi_wdata[`VERI_BIT*i+:`VERI_BIT]      = m_axi_wdata;
                s_axi_wstrb[`VERI_BIT/8*i+:`VERI_BIT/8]  = m_axi_wstrb;
                s_axi_wvalid[i]                          = m_axi_wvalid;
                s_axi_bready[i]                          = m_axi_bready;
            end else begin
                s_axi_awaddr[`ADRES_BIT*i+:`ADRES_BIT]   = {`ADRES_BIT{1'b0}};
                s_axi_awprot[3*i+:3]                     = {3{1'b0}};
                s_axi_awvalid[i]                         = {1'b0};
                s_axi_wdata[`VERI_BIT*i+:`VERI_BIT]      = {`VERI_BIT{1'b0}};
                s_axi_wstrb[`VERI_BIT/8*i+:`VERI_BIT/8]  = {`VERI_BIT/8{1'b0}};
                s_axi_wvalid[i]                          = {1'b0};
                s_axi_bready[i]                          = {1'b0};    
            end
            if(slave_read[i]) begin
                read_id = i;
                s_axi_araddr[`ADRES_BIT*i+:`ADRES_BIT]   = m_axi_araddr;
                s_axi_arprot[3*i+:3]                     = m_axi_arprot;
                s_axi_arvalid[i]                         = m_axi_arvalid;    
                s_axi_rready[i]                          = m_axi_rready;
            end else begin
                s_axi_araddr[`ADRES_BIT*i+:`ADRES_BIT]   = {`ADRES_BIT{1'b0}};
                s_axi_arprot[3*i+:3]                     = {3{1'b0}};
                s_axi_arvalid[i]                         = {1'b0};    
                s_axi_rready[i]                          = {1'b0};            
            end
        end
        m_axi_awready = s_axi_awready[write_id];
        m_axi_wready = s_axi_wready[write_id];
        m_axi_bvalid = s_axi_bvalid[write_id];
        m_axi_bresp = s_axi_bresp[write_id*2+:2];
        m_axi_arready = s_axi_arready[read_id];
        m_axi_rdata = s_axi_rdata[read_id*`VERI_BIT+:`VERI_BIT];
        m_axi_rresp = s_axi_rresp[read_id*2+:2];
        m_axi_rvalid = s_axi_rvalid[read_id];
    end
    
    
    
    
endmodule
