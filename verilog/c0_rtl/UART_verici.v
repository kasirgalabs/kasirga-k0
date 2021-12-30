`timescale 1ns / 1ps

module UART_verici(
  input           clk_g           ,
  input           rst_g           ,
  
  input   [7:0]   ver_veri        ,
  input           ver_gecerli     ,
 
  output reg      TX              ,
  output          hazir 
  );
  
  localparam UART_SAAT = 5208;
  
  localparam BOSTA  = 0;
  localparam BASLA  = 1;
  localparam VER    = 2;
  localparam DUR    = 3;

  reg [7:0] veri_ns, veri_r;    
  reg [1:0] durum_ns, durum_r;
  reg [31:0] baud_sayac_ns, baud_sayac_r;
  reg [2:0] TX_ek_ns, TX_ek_r; 
  
  wire      saat_ac   = baud_sayac_r == UART_SAAT;
  
  assign    hazir     = durum_r == BOSTA;
  
  always @* begin
    durum_ns                    =                   durum_r;
    veri_ns                     =                   veri_r ;
    baud_sayac_ns               =                   baud_sayac_r;
    TX                          =                   1'b1;
    TX_ek_ns                    =                   TX_ek_r;
    case (durum_r)
      BOSTA: begin
        if (ver_gecerli) begin
          veri_ns               =                   ver_veri;
          durum_ns              =                   BASLA;
        end        
      end
      BASLA: begin
        TX                      =                   1'b0;
        if (saat_ac) begin
          durum_ns              =                   VER;
        end
      end
      VER: begin
        TX                      =                   veri_r[TX_ek_r];
        if (saat_ac) begin
          if (TX_ek_r == 3'b111) begin 
            TX_ek_ns            =                   3'b000;
            durum_ns            =                   DUR;
          end
          else begin
            TX_ek_ns            =                   TX_ek_r + 1;
          end
        end
      end
      DUR: begin
        TX                      =                   1'b1; //dur?
        if (saat_ac) begin
          durum_ns              =                   BOSTA;    
        end
      end 
    endcase
  
    if (durum_r != BOSTA) begin
      baud_sayac_ns             =                   baud_sayac_ns + 1;
    end
  
    if (saat_ac) begin
      baud_sayac_ns             =                   32'd0;        
    end          
  end
  
  always @(posedge clk_g) begin
    if (rst_g) begin
      durum_r                     <=                  BOSTA;
      baud_sayac_r                <=                  0;
      TX_ek_r                     <=                  0;    
    end
    else begin
      veri_r                      <=                  veri_ns;
      durum_r                     <=                  durum_ns;
      baud_sayac_r                <=                  baud_sayac_ns;
      TX_ek_r                     <=                  TX_ek_ns;
    end
  end   
    
endmodule
