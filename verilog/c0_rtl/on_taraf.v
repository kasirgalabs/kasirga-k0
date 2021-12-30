`timescale 1ns / 1ps

//==============================================================================
// On taraf buyruk bellegi ile C0 arasindaki haberlesmeyi denetler
//==============================================================================

`include "sabitler.vh"

module on_taraf(

    input                                                       clk_g                                                                                 ,
    input                                                       rst_g                                                                                 ,
    
    // TODO buraya buyruk adresi gelecek
    
    
    //      On_taraf <-> GC
    input                                                       gc_hazir_g                                                                            ,
    output                                                      bb_buy_gecerli_c                                                                      ,
    output              [`BUYRUK_BIT-1:0]                       bb_buy_c                                                                              ,
    output              [`BB_ADRES_BIT-1:0]                     bb_buy_ps_c                                                                           ,
    input               [`BB_ADRES_BIT-1:0]                     bb_buy_istek_adres_g                                                                  ,
    input                                                       bb_buy_istek_g                                                                        ,
    
    //      On_taraf <-> Buyruk Bellegi
    output              [`BB_ADRES_BIT-1:0]                     bb_addra_c                                                                            ,                                       
    input               [31:0]                                  bb_douta_g                                                                            ,                                      
    output                                                      bb_ena_c                                                                              ,   
    
    //      On_taraf <-> Baslangic Bellegi
    output              [`BB_ADRES_BIT-1:0]                     basbel_addra_c                                                                        ,                                       
    input               [31:0]                                  basbel_douta_g                                                                        ,
    output    reg                                               basbel_ena_c                      
   
    );
    
    reg                                                         gc_hazir_degildi_r                                                                    ;
    reg                                                         gc_hazir_degildi_ns_r                                                                 ;
    
    wire                [`BB_ADRES_BIT-1:0]                     baslangic_adresi_w                  =           `BASLANGIC_ADRESI                     ;
        
    reg                 [`BB_ADRES_BIT-1:0]                     program_sayaci_r                                                                      ;                                                    
    reg                 [`BB_ADRES_BIT-1:0]                     program_sayaci_ns_r                                                                   ;
    
    reg                                                         buyruk_gecerli_r                                                                      ;
    reg                                                         buyruk_gecerli_ns_r                                                                   ;
    
    reg                 [31:0]                                  buyruk_r                                                                              ;
    reg                 [31:0]                                  buyruk_ns_r                                                                           ;
    
    // TODO: bb_ena_c, baslangic bellegi de okunsa 1 oluyor, cok onemli olmamasi lazim
    wire                                                        basbel_oku_w                        =           program_sayaci_r < `BB_TABAN_ADR      ;
    assign                                                      bb_ena_c                            =           basbel_oku_w ? `LOW: basbel_ena_c;
    
    assign                                                      bb_buy_c                            =           basbel_oku_w                          ? 
                                                                                                                  basbel_douta_g                      : 
                                                                                                                  (gc_hazir_degildi_r)                ?
                                                                                                                  buyruk_r : bb_douta_g               ;
                                                                                                                  
    assign                                                      bb_buy_ps_c                         =           program_sayaci_r    -   3'b100        ;
    assign                                                      bb_buy_gecerli_c                    =           buyruk_gecerli_r                      ;
    assign                                                      bb_addra_c                          =           program_sayaci_r - `BB_TABAN_ADR      ;
    
    assign                                                      basbel_addra_c                      =           program_sayaci_r - `BASBEL_TABAN_ADR  ;
    
    // TODO: iki portlu bram farkli calisiyor, ona gore kodu duzenle
    // ena 1 olmayinca Z baglaniyor
    
    always @* begin
        program_sayaci_ns_r                     =               program_sayaci_r                                                                      ;
        buyruk_gecerli_ns_r                     =               buyruk_gecerli_r                                                                      ;
        basbel_ena_c                            =               `LOW                                                                                  ;
        buyruk_ns_r                             =               buyruk_r                                                                              ;
        gc_hazir_degildi_ns_r                   =               !gc_hazir_g                                                                           ;
        
        if (!gc_hazir_degildi_r && (!gc_hazir_g)) // hazirdi, artik hazir degil
            buyruk_ns_r                         =               bb_douta_g                                                                            ; 
        
        if (gc_hazir_g) 
        begin
            //buyruk_ns_r                         =               bb_douta_g                                                                            ;
            basbel_ena_c                        =               `HIGH                                                                                 ;
            buyruk_gecerli_ns_r                 =               `HIGH                                                                                 ;          
            program_sayaci_ns_r                 =               program_sayaci_r                    +           3'b100                                ;
            if (bb_buy_istek_g) 
            begin
                program_sayaci_ns_r             =               bb_buy_istek_adres_g                                                                  ;
                buyruk_gecerli_ns_r             =               `LOW                                                                                  ;
            end
        end
    end
    
    always @(posedge clk_g) begin
        if (rst_g)
        begin
            program_sayaci_r                    <=              baslangic_adresi_w                                                                    ;
            buyruk_gecerli_r                    <=              `LOW                                                                                  ;
            buyruk_r                            <=              32'b0                                                                                 ;
            gc_hazir_degildi_r                  <=              `LOW                                                                                  ;                   
        end
        else
        begin
            program_sayaci_r                    <=              program_sayaci_ns_r                                                                   ;
            buyruk_gecerli_r                    <=              buyruk_gecerli_ns_r                                                                   ;
            buyruk_r                            <=              buyruk_ns_r                                                                           ;
            gc_hazir_degildi_r                  <=              gc_hazir_degildi_ns_r                                                                 ;
        end    
    end                                                                
    
endmodule
