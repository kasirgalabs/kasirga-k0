`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////
//**************TODO:**********************
//+Testbench yazimi
//+MRET???
////////////////////////////////////////////////////////////////////////////////////////
`include "mikroislem.vh"
`include "sabitler.vh"
module yazmac_oku_yurut
    (
    input                               clk_g                                                            ,
    input                               rst_g                                                            ,
    input        [`UIS_BIT - 1:0]       gc_uis_g                                                         ,  
    input        [31:0]                 oku_veri_g                                                       ,
    input                               oku_veri_gecerli_g                                               ,
    
    input        [31:0]                 yo_ky1_veri_g                                                    ,
    input        [31:0]                 yo_ky2_veri_g                                                    ,
    input        [31:0]                 ddy_oku_veri_g                                                   ,
    input                               bellek_hazir_g                                                   ,


    output       [`UIS_BIT - 1:0]       yoy_uis_c                                                        , 
    output                              oku_gecerli_c                                                    ,
    output reg                          gc_duraklat_c                                                    ,
    output reg   [31:0]                 siradaki_ps_c                                                    ,
    output reg   [`ODD_BIT-1:0]         yoy_odd_kod_c                                                    , 
    output reg                          yoy_odd_c                                                        ,
    output reg   [31:0]                 yoy_odd_ps_c                                                     ,
    output reg   [31:0]                 yoy_odd_adres_c                                                  ,
    output reg                          gc_bosalt_c                                                      ,
    output       [31:0]                 yaz_veri_c                                                       ,
    output       [3:0]                  yaz_veri_maske_c                                                 ,
    output                              yaz_gecerli_c                                                    ,
    output       [31:0]                 adres_c                                                          , 
    output reg   [4:0]                  yo_ky1_adres_c                                                   ,
    output reg   [4:0]                  yo_ky2_adres_c                                                   ,                                  
    output                              ddy_oku_gecerli_c                                                ,
    output       [11:0]                 ddy_oku_adres_c                                              

    );

    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////*************************************uis ayirma***********************************************////
    wire                                     gecerli_w         = gc_uis_g[`GECERLI]                      ;
    wire         [`YURUT_KODU_BIT - 1: 0]    yurut_kodu_w      = gc_uis_g[`YURUT_KODU+:`YURUT_KODU_BIT]  ;
    wire         [`ISLEV_KODU_BIT - 1: 0]    islev_kodu_w      = gc_uis_g[`ISLEV_KODU+:`ISLEV_KODU_BIT]  ;
    wire         [`IS1_SEC_BIT - 1: 0]       is1_sec           = gc_uis_g[`IS1_SEC+:`IS1_SEC_BIT]        ;
    wire         [`IS2_SEC_BIT - 1: 0]       is2_sec           = gc_uis_g[`IS2_SEC+:`IS2_SEC_BIT]        ;
    wire         [`ANLIK_DEGER_BIT - 1: 0]   anlik_deger_w     = gc_uis_g[`ANLIK_DEGER+:`ANLIK_DEGER_BIT];
    wire         [`KY1_BIT - 1: 0]           ky1_w             = gc_uis_g[`KY1+:`KY1_BIT]                ;
    wire         [`KY2_BIT - 1: 0]           ky2_w             = gc_uis_g[`KY2+:`KY2_BIT]                ;
    wire         [`BELLEK_BUYRUGU_BIT - 1: 0] bellek_buyrugu   = {gc_uis_g[`YUKLE_BUYRUGU],
                                                                  gc_uis_g[`KAYDET_BUYRUGU],
                                                                  gc_uis_g[`FENCE_BUYRUGU]};
    wire         [`BELLEK_TURU_BIT - 1: 0]   bellek_turu       = {gc_uis_g[`BELLEK_TURU_W],
                                                                  gc_uis_g[`BELLEK_TURU_HW],
                                                                  gc_uis_g[`BELLEK_TURU_B]};
    wire                                     bellek_isaretli_w = gc_uis_g[`BELLEK_ISARETLI]              ;
    wire         [`HY_BIT - 1: 0]            hy_w              = gc_uis_g[`HY+:`HY_BIT]                  ;
    wire         [`PS_BIT - 1: 0]            ps_w              = gc_uis_g[`PS+:`PS_BIT]                  ;
    wire         [`DDY_ADRES_BIT - 1: 0]     ddy_adres_w       = gc_uis_g[`DDY_ADRES+:`DDY_ADRES_BIT]    ;
    wire         [`DDY_ANLIK_BIT - 1: 0]     ddy_anlik_w       = gc_uis_g[`DDY_ANLIK+:`DDY_ANLIK_BIT]    ;
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////***********************************uis birlestirme********************************************////

    reg          [`UIS_BIT - 1: 0]           yoy_uis_r                                                   ;
    reg          [`UIS_BIT - 1: 0]           yoy_uis_sonraki_r                                           ;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////********************************Degisken tanimlamalari****************************************////
    //Islec1 ve Islec2 icin yazmac tanimlamalari
    reg          [31:0]                      is1_sec_r      =0                                             ; 
    reg          [31:0]                      is2_sec_r      =0                                             ;
 
    //YOY asamasinda guncellenecek uop bitleri icin yazmac tanimlamalari
    //Hedef yazmacina yazma yapilacagi durumda -> 1, d.d. -> 0
    reg                                      yazmac_yaz_r    =0                                             ;     
    //Islem sonucunun yazilacagi yazmac
    reg          [31:0]                      hy_deger_r      =0                                            ; 
    // DDBye yazma yapilacagi durumda 1 
    reg                                      ddy_yaz_r       =0                                            ;
    reg                                      ddy_oku_r       =0                                            ;
    reg          [31:0]                      ddy_yaz_veri_r  =0                                            ;

                                   
                                                     
    //Cagirilan moduller icin degisken tanimlamalari
    //AMB'de yapilan islemin sonucu
    wire         [31:0]                      amb_sonuc_w                                                 ; 
    // JAL ve JALR buyruklari icin hedef yazmaci degeri
    wire         [31:0]                      jal_sonuc_w                                                 ;
    //Dallanma buyruklari icin atliyorsa 1'b1, atlamiyorsa 1'b0 veren cikis
    wire                                     db_sonuc_w                                                  ;
    //DB'de guncellenmis program sayaci cikisi
    wire         [31:0]                      siradaki_ps_db_w                                            ;
    //TCB icin durum sinyalleri
    reg                                      tcb_hazir_r      =0                                           ;
    wire                                     tcb_bitti_w                                                 ;
    wire         [31:0]                      tcb_sonuc_w                                                 ;
    //TBB icin durum ve sonuc sinyalleri
    reg                                      tbb_hazir_r      =0                                         ;
    wire                                     tbb_bitti_w                                                 ;
    wire         [31:0]                      tbb_sonuc_w                                                 ;
    //TCB ve TBB icin durum sinyalleri
    reg                                      tcb_tbb_mesgul_r         = 0                                ;
    reg                                      tcb_tbb_mesgul_sonraki_r = 0                                ; 
    //BIB icin durum sinyalleri
    wire         [31:0]                      oku_veri_bib_w                                              ;
    wire                                     bib_bitti_w                                                 ;
    //////////////////////////////////////////////////////////////////////////////////////////////////////

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////*************************************Modul Cagirma********************************************////
    aritmetik_mantik_birimi amb_unit (
                 //Girisler
                 .islev_kodu_g             (islev_kodu_w)      ,
                 .islec1_g                 (is1_sec_r)         ,
                 .islec2_g                 (is2_sec_r)         ,
                 //Cikislar
                 .sonuc_c                  (amb_sonuc_w)
                 );
                 
    dallanma_birimi db(
                 //Girisler                 
                 .islev_kodu_g             (islev_kodu_w[7:0]) ,
                 .ps_g                     (ps_w)              ,
                 .islec1_g                 (is1_sec_r)         ,
                 .islec2_g                 (is2_sec_r)         ,
                 .anlik_g                  (anlik_deger_w)     ,
                 //Cikislar
                 .jal_sonuc_c              (jal_sonuc_w)       ,
                 .dallanma_sonuc_c         (db_sonuc_w)        ,
                 .ps_c                     (siradaki_ps_db_w)
                 );

   tamsayi_carpma_birimi tcb_unit (
                //Girisler                
                .clk_g                    (clk_g)             ,
                .islev_kodu_g             (islev_kodu_w[3:0]) ,
                .islec1_g                 (is1_sec_r)         ,
                .islec2_g                 (is2_sec_r)         ,
                .hazir_g                  (tcb_hazir_r)       ,
                //Cikislar
                .bitti_c                  (tcb_bitti_w)       ,
                .sonuc_c                  (tcb_sonuc_w)
                );

   tamsayi_bolme_birimi tbb_unit (
                //Girisler                
                .clk_g                    (clk_g)             ,
                .islev_kodu_g             (islev_kodu_w[3:0]) ,
                .islec1_g                 (is1_sec_r)         ,
                .islec2_g                 (is2_sec_r)         ,
                .hazir_g                  (tbb_hazir_r)       ,
                //Cikislar
                .bitti_c                  (tbb_bitti_w)       ,
                .sonuc_c                  (tbb_sonuc_w)
                );

    bellek_islem_birimi bib_unit (
                 //Girisler
                 .clk_g                     (clk_g)            ,  
                 .rst_g                     (rst_g)            ,  
                 .bellek_buyrugu            (bellek_buyrugu)   , 
                 .islec1_g                  (is1_sec_r)        ,
                 .islec2_g                  (is2_sec_r)        ,
                 .anlik_g                   (anlik_deger_w)    ,
                 .bellek_isaretli           (bellek_isaretli_w),
                 .bellek_turu               (bellek_turu)      ,
                 .bellek_hazir_g            (bellek_hazir_g)   ,
                 .oku_veri_g                (oku_veri_g)       ,
                 .oku_veri_gecerli_g        (oku_veri_gecerli_g)  ,
                 //Cikislar
                 .bitti_c                   (bib_bitti_w)      ,
                 .oku_veri_c                (oku_veri_bib_w)   ,
                 .adres_bib_c               (adres_c)          ,
                 .oku_gecerli_bib_c         (oku_gecerli_c)    ,
                 .yaz_gecerli_bib_c         (yaz_gecerli_c)    ,
                 .yaz_veri_bib_c            (yaz_veri_c)       ,
                 .yaz_veri_bib_maske_c      (yaz_veri_maske_c)
                 );
    //////////////////////////////////////////////////////////////////////////////////////////////////////

    assign                                   yoy_uis_c         = yoy_uis_r                               ;
    // Atb: DDB'ye giden cikis sinyalleri
    assign       ddy_oku_adres_c        =    ddy_adres_w                                                 ;                                                 
    assign       ddy_oku_gecerli_c      =    ddy_oku_r                                                   ;                                                 
        
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////*************************************Birlesik Devre*******************************************////
    always@* begin
        yoy_odd_adres_c         = 0             ; // TODO duzelt

        siradaki_ps_c           = ps_w          ;
        ddy_yaz_r               = `LOW          ;
        yazmac_yaz_r            = `LOW          ;
        yoy_odd_c               = `LOW          ;
        //Yazmac obegine gonderilec ek kaynak yazmaclarinin adresleri
        // 1.kaynak-yazmac adresinin yazmac obegine gonderilmesi
        yo_ky1_adres_c          = ky1_w         ;
        // 2.kaynak-yazmac adresinin yazmac obegine gonderilmesi
        yo_ky2_adres_c          = ky2_w         ; 
        
        ddy_oku_r               = 0             ;
        //yoy_uis_sonraki_r       = yoy_uis_r   ;
        yoy_uis_sonraki_r       = gc_uis_g      ;

        yoy_odd_ps_c            = ps_w          ;  

        gc_duraklat_c           = `LOW          ;
        gc_bosalt_c             = `LOW          ;
        
        // Inferred latchleri onlemek icin
        // is2_sec_r               = 0             ;
        // is1_sec_r               = 0             ;
        yoy_odd_kod_c           = 0             ;
        ddy_yaz_veri_r          = 0             ;
        hy_deger_r              = 0             ;
        
        if(gecerli_w) begin

            //Islec1 Secimi
            case(is1_sec) 
                //Islec1 -> Kaynak Yazmaci 
                `IS1_SEC_KY1: begin
                //(bir onceki buyruktaki hedef yazmaci mi okunacak?)
                    if((ky1_w == yoy_uis_c[`HY+:`HY_BIT]) 
                            && yoy_uis_c[`GECERLI] && yoy_uis_c[`HY_YAZ] 
                            && yoy_uis_c[`HY+:`HY_BIT] != 5'b0)
                        is1_sec_r = yoy_uis_c[`HY_DEGER+:`HY_DEGER_BIT]       ;
                    else 
                        is1_sec_r = yo_ky1_veri_g                             ;
                end
                //Islec1 -> Program sayac
                `IS1_SEC_PS : is1_sec_r    = ps_w                             ;
                //Islec1 -> 
                `IS1_SEC_0  : is1_sec_r    = 0                                ;
                default     : is1_sec_r               = 0             ;
            endcase
            
            // Islec2 Secimi
            case(is2_sec) 
                //Islec2 -> Kaynak Yazmaci 
                `IS2_SEC_KY2: begin 
                //(bir onceki buyruktaki hedef yazmaci mi okunacak?)
                    if((ky2_w == yoy_uis_c[`HY+:`HY_BIT])
                            && yoy_uis_c[`GECERLI] && yoy_uis_c[`HY_YAZ]
                            && yoy_uis_c[`HY+:`HY_BIT] != 5'b0)
                        is2_sec_r = yoy_uis_c[`HY_DEGER+:`HY_DEGER_BIT]       ;
                    else 
                        is2_sec_r = yo_ky2_veri_g                             ;      
                 end
                //Islec2 -> Anlik Deger
                `IS2_SEC_AD    : is2_sec_r   = anlik_deger_w                  ;
                //Islec2 ->
                `IS2_SEC_4     : is2_sec_r   = 4                              ; 
                //Islec2 ->
                `IS2_SEC_0     : is2_sec_r   = 0                              ; 
                //Islec2 -> CSR anlik dege
                `IS2_SEC_CSR_AD: is2_sec_r   = 0                              ;
                default: is2_sec_r               = 0             ;
            endcase
            // Yurutme asamasinda yapilacak islem secimi
            case(yurut_kodu_w) 
                // AMB islemi
                `YURUT_KODU_AMB: begin 
                    // Hedef yazmacina amb sonucu yazilacak deger
                    hy_deger_r   = amb_sonuc_w;
                    // Hedef yazmacina deger yazilacagini belirtmek icin 1'b1
                    yazmac_yaz_r = 1'b1       ;
                 end
                 //DB islem
                `YURUT_KODU_DB : begin 
                    //Atlama buyruklari geldiyse
                    if(islev_kodu_w == `JAL || islev_kodu_w == `JALR ) begin
                        //Hedef yazmacina yazilacak deger
                        hy_deger_r     = jal_sonuc_w     ;
                        //Hedef yazmacina deger yazilacagini belirtmek icin 1'b1
                        yazmac_yaz_r   = 1'b1            ;
                        // Program sayaci guncelleme
                        gc_bosalt_c    = 1'b1            ;
                        if (siradaki_ps_db_w[1:0] != 2'b00)
                        begin
                            yoy_odd_ps_c        =   siradaki_ps_db_w;
                            yoy_odd_c           =   `HIGH;
                            yoy_odd_kod_c       =   `KDD_HBA; 
                        end 
                        else begin
                            siradaki_ps_c  = siradaki_ps_db_w;
                        end
                    end
                    //Dallanma buyruklari geldiyse
                    else begin
                        //Eger dallanma yanlis cozulduyse
                        if(db_sonuc_w) begin
                            //Boruhatiini bosaltma
                            gc_bosalt_c                 =   1'b1            ;
                            if (siradaki_ps_db_w[1:0] != 2'b00)
                            begin
                                yoy_odd_ps_c        =   siradaki_ps_db_w;
                                yoy_odd_c           =   `HIGH;
                                yoy_odd_kod_c       =   `KDD_HBA; 
                            end 
                            else begin
                            // Program sayaci guncelleme
                                siradaki_ps_c         = siradaki_ps_db_w;
                            end
                        end
                    end
                        
                end    
                // Bellek islemleri
                `YURUT_KODU_BIB: begin 
                    // Bellek islemleri bitene kadar boru hattini durdur
                    gc_duraklat_c = ~bib_bitti_w; 
                    case(bellek_buyrugu)
                        `FENCE_b: begin
                            //gc_bosalt_c = 1'b1;
                        end
                        `YUKLE_b: begin
                            if(oku_veri_gecerli_g) begin
                                hy_deger_r   = oku_veri_bib_w    ; 
                                yazmac_yaz_r = 1'b1              ;
                            end
                            else gc_duraklat_c = `HIGH;
   
                        end
                        `KAYDET_b: begin
                            yazmac_yaz_r = 1'b0;
                        end
                    endcase
                end
                `YURUT_KODU_TCB: begin
                    // Islem bitene kadar boruhattini durdur
                    gc_duraklat_c = ~tcb_bitti_w;
                     
                     // Islem yapilmaya baslandiysa
                    if(tcb_tbb_mesgul_r) begin 
                        //Sadece tek cevrim 1'b1 degerini almali(bkz.tcb_unit)
                        tcb_hazir_r = 1'b0;
                    end
                    else begin
                        //Islem yapmaya baslamadiysa basla
                        tcb_hazir_r              = 1'b1;
                        //Yeni islem gonderilmesini engelle
                        tcb_tbb_mesgul_sonraki_r = 1'b1;
                    end
                    // Islem tamamlandiysa
                    if(tcb_bitti_w) begin
                        //Hedef yazmacina islem sonucunu yaz
                        hy_deger_r   = tcb_sonuc_w;
                        yazmac_yaz_r = 1'b1       ;
                        //Yeni islem almaya hazir hale getir
                        tcb_tbb_mesgul_sonraki_r = 1'b0;
                    end            
                end
                //TCB'nin aynisi
                `YURUT_KODU_TBB: begin 
                    gc_duraklat_c = ~tbb_bitti_w;
                    if(tcb_tbb_mesgul_r) begin
                        tbb_hazir_r = 1'b0;
                    end
                    else begin
                        tbb_hazir_r               = 1'b1;
                        tcb_tbb_mesgul_sonraki_r  = 1'b1;
                    end
                    if(tbb_bitti_w) begin
                        hy_deger_r                = tbb_sonuc_w;
                        yazmac_yaz_r              = 1'b1       ;
                        tcb_tbb_mesgul_sonraki_r  = 1'b0       ;
                    end            
                end
                `YURUT_KODU_CSR: begin
                    gc_bosalt_c = 1'b1;
                    siradaki_ps_c = ps_w + 32'd4;
                    if (islev_kodu_w == `CSRRW || islev_kodu_w == `CSRRWI) begin
                        ddy_yaz_r = 1'b1;
                        ddy_yaz_veri_r = is1_sec_r;
                        if(hy_w == 0) begin
                            ddy_oku_r = 1'b0;
                        end
                        else begin
                            ddy_oku_r = 1'b1;
                            yazmac_yaz_r = 1'b1;
                            hy_deger_r =  (islev_kodu_w == `CSRRW)  ?
                                           ddy_oku_veri_g : ddy_anlik_w;              
                        end
                    end
                    else if (islev_kodu_w == `CSRRS || islev_kodu_w == `CSRRSI) begin
                        ddy_oku_r = 1'b1;
                        yazmac_yaz_r = 1'b0;
                        if(ky1_w != 'd0) begin
                            ddy_yaz_r = 1'b1;
                            ddy_yaz_veri_r =  (islev_kodu_w == `CSRRS) ?
                                              (ddy_oku_veri_g == 32'b0 ? 32'b0 : is1_sec_r) :
                                              (ddy_oku_veri_g == 32'b0 ? 32'b0 : ky1_w);
                        end 
                    end
                    else if (islev_kodu_w == `CSRRC || islev_kodu_w == `CSRRCI) begin
                         ddy_oku_r = 1'b1;
                        yazmac_yaz_r = 1'b0;
                        if (ddy_anlik_w != 'd0) begin
                            ddy_yaz_r = 1'b1;
                            ddy_yaz_veri_r = (islev_kodu_w == `CSRRC) ?
                                               (ddy_oku_veri_g == 32'b0 ? 32'b0 : ~is1_sec_r) :
                                               (ddy_oku_veri_g == 32'b0 ? 32'b0 : ~ky1_w);
                        end
                    end
    
                end // YURUT_KODU_CSR
                `YURUT_KODU_SISTEM: begin
                    gc_bosalt_c     =       `HIGH               ;
                    if (islev_kodu_w == `MRET) begin
                        yoy_odd_c               = `HIGH         ;
                        yoy_odd_kod_c           = `KDD_MRET     ;
                    end
                    yazmac_yaz_r    =       `LOW                ;
                    ddy_yaz_r       =       `LOW                ;
                end
            endcase
            
        yoy_uis_sonraki_r[`HY_YAZ]                      = yazmac_yaz_r;
        yoy_uis_sonraki_r[`GECERLI]                     = ~gc_duraklat_c;
        yoy_uis_sonraki_r[`DDY_YAZ]                     = ddy_yaz_r;
        yoy_uis_sonraki_r[`HY_DEGER+:`HY_DEGER_BIT]     = hy_deger_r;  
        yoy_uis_sonraki_r[`DDY_VERI+:`DDY_VERI_BIT]     = ddy_yaz_veri_r;
        end // if gecerli  
        else begin
            is1_sec_r               = 0             ;
            is2_sec_r               = 0             ;


        end 
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ////*************************************Sirali Devre*********************************************////

    always@(posedge clk_g) begin
        if (rst_g) begin
            tcb_tbb_mesgul_r        <= `LOW;
            yoy_uis_r[`GECERLI]     <= `LOW;
        end
        else begin
            tcb_tbb_mesgul_r <= tcb_tbb_mesgul_sonraki_r ;
            yoy_uis_r        <= yoy_uis_sonraki_r        ;
        end
        
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
endmodule
