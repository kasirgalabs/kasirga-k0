`timescale 1ns / 1ps

`include "sabitler.vh"

module cekirdek(
    input                                               clk_g                                                ,
    input                                               rst_g                                                ,
    
    //    Buyruk Bellegi <-> GetirCoz
    input                                               bb_buy_gecerli_g                                     ,
    input           [`BUYRUK_BIT-1:0]                   bb_buy_g                                             ,
    input           [`BB_ADRES_BIT-1:0]                 bb_buy_ps_g                                          ,
    output                                              gc_hazir_c                                           ,
    output          [`BB_ADRES_BIT-1:0]                 bb_buy_istek_adres_c                                 ,
    output                                              bb_buy_istek_c                                       ,
    
    //    Kesme Denetleyicisi <-> DDB
    input                                               kesme_g                                              ,
    input                                               zamanlayici_kesme_g                                  ,  

    //    Veri bellegi <-> C0
    //    TODO: bunlar baglanmadi  
    input                                               oku_hazir_g                                          ,
    input           [31:0]                              oku_veri_g                                           ,
    input                                               oku_veri_gecerli_g                                   ,
    input                                               yaz_hazir_g                                          ,
                                                                                                               
    output                                              oku_gecerli_c                                        ,
    output          [31:0]                              yaz_veri_c                                           ,
    output          [3:0]                               yaz_gecerli_c                                        ,
    output          [31:0]                              adres_c                                          

    
    );
    
    //==============================================================================
    //                                  GETIR-COZ
    //==============================================================================

   (* dont_touch = "true" *) wire                                                bb_buy_gecerli_w                                      ;
    wire            [`BUYRUK_BIT-1:0]                   bb_buy_w                                              ;
   (* dont_touch = "true" *) wire            [`BB_ADRES_BIT-1:0]                 bb_buy_ps_w                                           ;
    wire                                                gc_hazir_w                                            ;
    wire            [`UIS_BIT-1:0]                      gc_uis_w                                              ;  
    wire                                                gc_odd_w                                              ;
    wire            [31:0]                              gc_odd_ps_w                                           ;

    //==============================================================================
    //                             YAZMAC-OKU-YURUT
    //==============================================================================
    
   (* dont_touch = "true" *) wire            [31:0]                              oku_veri_w                                            ;
   (* dont_touch = "true" *) wire                                                oku_veri_gecerli_w                                    ;
    wire                                                yaz_hazir_w                                           ;
    wire                                                oku_hazir_w                                           ;
    wire            [31:0]                              yo_ky1_veri_w                                         ;
    wire            [31:0]                              yo_ky2_veri_w                                         ;

    wire            [`UIS_BIT-1:0]                      yoy_uis_w                                             ; 
    (* dont_touch = "true" *) wire                                                oku_gecerli_w                                         ;
    wire                                                gc_duraklat_w                                         ;
    wire            [31:0]                              siradaki_ps_w                                         ;
    wire            [`ODD_BIT-1:0]                      yoy_odd_kod_w                                         ; 
    wire                                                yoy_odd_w                                             ;
    // @ismail bellek islemlerinde oddye yol acan buyruklarina adresi lazim
    wire            [31:0]                              yoy_odd_adres_w                                       ;
    // @ismail odd ps degeri lazim
    wire            [31:0]                              yoy_odd_ps_w                                          ;
    wire                                                gc_bosalt_w                                           ;
    wire            [31:0]                              yaz_veri_w                                            ;
    wire            [3:0]                               yaz_gecerli_w                                         ;
    (* dont_touch = "true" *) wire            [31:0]                              adres_w                                               ; 
    wire            [4:0]                               yo_ky1_adres_w                                        ;
    wire            [4:0]                               yo_ky2_adres_w                                        ;

    //==============================================================================
    //                              DENETIM-DURUM-BIRIMI
    //==============================================================================   
    wire                                                kesme_w                                               ;
    wire                                                zamanlayici_kesme_w                                   ;
    wire            [`ODD_BIT-1:0]                      odd_kod_w                                             ;
    wire            [`PS_BIT-1:0]                       odd_ps_w                                              ;
    wire            [`ADRES_BIT-1:0]                    odd_adres_w                                           ;
                                                                                               
    wire                                                ddy_oku_gecerli_w                                     ;
    wire            [11:0]                              ddy_oku_adres_w                                       ;
    wire                                                ddy_yaz_gecerli_w                                     ;
    wire            [11:0]                              ddy_yaz_adres_w                                       ;
    wire            [31:0]                              ddy_yaz_veri_w                                        ;
    wire            [31:0]                              ddy_oku_veri_w                                        ;
                                                                                                
    wire                                                odd_ps_al_gecerli_w                                   ;
    wire            [`PS_BIT-1:0]                       odd_ps_al_w                                           ;  

    //==============================================================================
    //                                  YAZMAC-YAZ
    //==============================================================================

    wire                                                yo_yaz_w                                              ;
    wire            [`HY_BIT - 1: 0]                    yo_yaz_hedef_w                                        ;
    wire            [`HY_DEGER_BIT - 1: 0]              yo_yaz_veri_w                                         ;      

    //==============================================================================
    //                                  GETIR-COZ                                   
    //==============================================================================
    
    assign                                              bb_buy_gecerli_w      =       bb_buy_gecerli_g        ;                                        
    assign                                              bb_buy_w              =       bb_buy_g                ;                                        
    assign                                              bb_buy_ps_w           =       bb_buy_ps_g             ;                                        

    assign                                              gc_hazir_c            =       gc_hazir_w              ;

    getir_coz gc
    (
        .clk_g                                          (clk_g)                                               ,                                                        
        .rst_g                                          (rst_g)                                               ,       
        .bb_buy_gecerli_g                               (bb_buy_gecerli_w)                                    , 
        .bb_buy_g                                       (bb_buy_w)                                            , 
        .bb_buy_ps_g                                    (bb_buy_ps_w)                                         , 
        .gc_hazir_c                                     (gc_hazir_w)                                          , 
        .gc_duraklat_g                                  (gc_duraklat_w)                                       , 
        .gc_bosalt_g                                    (gc_bosalt_w)                                         , 
        .gc_uis_c                                       (gc_uis_w)                                            ,   
        .gc_odd_c                                       (gc_odd_w)                                            ,           
        .gc_odd_ps_c                                    (gc_odd_ps_w)                                                    
    );

    //==============================================================================
    //                             YAZMAC-OKU-YURUT
    //==============================================================================   

    assign                                              oku_veri_w            =       oku_veri_g              ;
    assign                                              oku_veri_gecerli_w    =       oku_veri_gecerli_g      ;
    assign                                              yaz_hazir_w           =       yaz_hazir_g             ;
    assign                                              oku_hazir_w           =       oku_hazir_g             ;

    assign                                              adres_c               =       adres_w                 ;
    assign                                              oku_gecerli_c         =       oku_gecerli_w           ;
    assign                                              yaz_veri_c            =       yaz_veri_w              ;
    assign                                              yaz_gecerli_c         =       yaz_gecerli_w           ;

    
    yazmac_oku_yurut yoy
    (
        .clk_g                                          (clk_g)                                               ,
        .rst_g                                          (rst_g)                                               ,
        .gc_uis_g                                       (gc_uis_w)                                            ,  
        .oku_veri_g                                     (oku_veri_w)                                          ,
        .oku_veri_gecerli_g                             (oku_veri_gecerli_w)                                  ,
        .yo_ky1_veri_g                                  (yo_ky1_veri_w)                                       ,
        .yo_ky2_veri_g                                  (yo_ky2_veri_w)                                       ,
        .ddy_oku_veri_g                                 (ddy_oku_veri_w)                                      ,
        .bellek_hazir_g                                 (yaz_hazir_w && oku_hazir_w)                          ,

        .yoy_uis_c                                      (yoy_uis_w)                                           , 
        .oku_gecerli_c                                  (oku_gecerli_w)                                       ,
        .gc_duraklat_c                                  (gc_duraklat_w)                                       ,
        .siradaki_ps_c                                  (siradaki_ps_w)                                       ,
        .yoy_odd_kod_c                                  (yoy_odd_kod_w)                                       , 
        .yoy_odd_ps_c                                   (yoy_odd_ps_w)                                        , 
        .yoy_odd_adres_c                                (yoy_odd_adres_w)                                     , 
        .yoy_odd_c                                      (yoy_odd_w)                                           ,
        .gc_bosalt_c                                    (gc_bosalt_w)                                         ,
        .yaz_veri_c                                     (yaz_veri_w)                                          ,
        .yaz_veri_maske_c                               (yaz_gecerli_w)                                       ,
        .adres_c                                        (adres_w)                                             , 
        .yo_ky1_adres_c                                 (yo_ky1_adres_w)                                      ,
        .yo_ky2_adres_c                                 (yo_ky2_adres_w)                                      ,
        .ddy_oku_adres_c                                (ddy_oku_adres_w)                                     ,                                                 
        .ddy_oku_gecerli_c                              (ddy_oku_gecerli_w)                     
    );
 
    //==============================================================================
    //                              DENETIM-DURUM-BIRIMI
    //==============================================================================  

    assign                                              kesme_w               =       kesme_g                 ;
    assign                                              zamanlayici_kesme_w   =       zamanlayici_kesme_g     ;
    
    assign                                              odd_kod_w             =       yoy_odd_kod_w           ;
                                        
    assign                                              odd_ps_w              =       yoy_odd_w               ?
                                                            yoy_odd_ps_w      :       gc_odd_ps_w             ;
    
    assign                                              odd_adres_w          =       yoy_odd_adres_w         ;

    assign                                              bb_buy_istek_adres_c  =       odd_ps_al_gecerli_w     ?
                                                            odd_ps_al_w       :       siradaki_ps_w           ;
    
    assign                                              bb_buy_istek_c        =       odd_ps_al_gecerli_w     |
                                                                                      gc_bosalt_w             ; 
                                        
    
    denetim_durum_birimi ddb
    (
        .clk_g                                          (clk_g)                                               ,
        .rst_g                                          (rst_g)                                               ,
        
        .kesme_g                                        (kesme_w)                                             ,
        .zamanlayici_kesme_g                            (zamanlayici_kesme_w)                                 ,
        .gc_odd_g                                       (!yoy_odd_w && gc_odd_w)                              ,
        .yoy_odd_g                                      (yoy_odd_w)                                           ,
        .odd_kod_g                                      (odd_kod_w)                                           ,
        .odd_ps_g                                       (odd_ps_w)                                            ,
        .odd_adres_g                                    (odd_adres_w)                                         ,
        
        .oku_gecerli_g                                  (ddy_oku_gecerli_w)                                   ,
        .oku_adres_g                                    (ddy_oku_adres_w)                                     ,
        .yaz_gecerli_g                                  (ddy_yaz_gecerli_w)                                   ,
        .yaz_adres_g                                    (ddy_yaz_adres_w)                                     ,
        .yaz_veri_g                                     (ddy_yaz_veri_w)                                      ,
        .oku_veri_c                                     (ddy_oku_veri_w)                                      ,
        
        .odd_ps_al_gecerli_c                            (odd_ps_al_gecerli_w)                                 ,
        .odd_ps_al_c                                    (odd_ps_al_w)                   
    );   


    //==============================================================================
    //                                  YAZMAC-YAZ
    //==============================================================================
    
    yazmac_yaz yy
    (
        .clk_g                                          (clk_g)                                               ,
        .yoy_uis_g                                      (yoy_uis_w)                                           ,

        .yo_yaz_c                                       (yo_yaz_w)                                            ,
        .yo_yaz_hedef_c                                 (yo_yaz_hedef_w)                                      ,
        .yo_yaz_veri_c                                  (yo_yaz_veri_w)                                       ,
        
        .ddy_yaz_c                                      (ddy_yaz_gecerli_w)                                   ,
        .ddy_yaz_hedef_c                                (ddy_yaz_adres_w)                                     ,
        .ddy_yaz_veri_c                                 (ddy_yaz_veri_w)                                       
    );

    //==============================================================================
    //                                  YAZMAC-OBEGI
    //==============================================================================

    yazmac_obegi yo     (
        .clk_g                                          (clk_g)                                               ,
        .rst_g                                          (rst_g)                                               ,
        .ky1_adres_g                                    (yo_ky1_adres_w)                                      ,
        .ky2_adres_g                                    (yo_ky2_adres_w)                                      ,
        .hy_adres_g                                     (yo_yaz_hedef_w)                                      , 
        .hy_deger_g                                     (yo_yaz_veri_w)                                       ,
        .yaz_g                                          (yo_yaz_w)                                            ,
        .ky1_deger_c                                    (yo_ky1_veri_w)                                       ,
        .ky2_deger_c                                    (yo_ky2_veri_w)   
    );
                         
endmodule
