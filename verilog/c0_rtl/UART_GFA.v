`timescale 1ns / 1ps

module UART_GFA(
  input                 clk_g,
  input                 rst_g,
  input         [31:0]  komut,
  input                 komut_gecerli,
  input                 veri_hazir,
  input                 RX,
  output                TX,
  output        reg     komut_hazir,
  output        [31:0]  veri,
  output                veri_gecerli 
);
   
  wire ver_hazir;
  wire ver_gecerli = komut_gecerli && (komut[2:0] == 3'b000);
  wire [7:0] ver_veri = komut[31:24];
  
  UART_verici verici(
    .clk_g(clk_g),
    .rst_g(rst_g),
    .ver_veri(ver_veri),
    .ver_gecerli(ver_gecerli),
    .TX(TX),
    .hazir(ver_hazir)
  );
  
  wire al_gecerli;
  wire [7:0] al_veri;
  
  assign veri = {24'b0, al_veri};
  assign veri_gecerli = al_gecerli;
  
  UART_alici alici(
    .clk_g(clk_g)             ,
    .rst_g(rst_g)             ,
    .RX(RX)                   ,
    
    .al_veri(al_veri)         ,
    .al_gecerli(al_gecerli)      
  );

  always @* begin
    komut_hazir           =       ver_hazir;
  end
      

endmodule