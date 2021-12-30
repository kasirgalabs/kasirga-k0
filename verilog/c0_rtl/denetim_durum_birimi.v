`timescale 1ns / 1ps 

`include "sabitler.vh"

module denetim_durum_birimi
    (
    input                               clk_g                                                               ,
    input                               rst_g                                                               ,

    // YOY, GC, Sistem <-> DDB
    input                               kesme_g                                                             ,
    input                               zamanlayici_kesme_g                                                 ,
    input                               gc_odd_g                                                            ,
    input                               yoy_odd_g                                                           ,
    input        [`ODD_BIT-1:0]         odd_kod_g                                                           ,
    input        [`PS_BIT-1:0]          odd_ps_g                                                            ,
    input        [`ADRES_BIT-1:0]       odd_adres_g                                                         ,

    // YOY <-> Denetim Durum Yazmaclari
    input                               oku_gecerli_g                                                       ,
    input        [11:0]                 oku_adres_g                                                         ,
    input                               yaz_gecerli_g                                                       ,
    input        [11:0]                 yaz_adres_g                                                         ,
    input        [31:0]                 yaz_veri_g                                                          ,
    output       [31:0]                 oku_veri_c                                                          ,

    // DDB <-> Buyruk Bellegi
    output                              odd_ps_al_gecerli_c                                                 ,
    output       [`PS_BIT-1:0]          odd_ps_al_c                                                          
    );

    // ===================================================================================================
    // ========================================= CSR YAZMACLARI ==========================================

    // TODO, bunlar duzgunce doldurulabilir
    // hartid == 0, cunku tek bir hardware threadimiz (tek cekirdek/tek thread) var
    // ================================== INFORMATION REGISTERS ===========================================
    wire          [31:0]                mvendorid_w         =       32'h00000000                            ;
    wire          [31:0]                marchid_w           =       32'h00000000                            ;
    wire          [31:0]                mimpid_w            =       32'h00000000                            ;
    wire          [31:0]                mhartid_w           =       32'h00000000                            ;

    // ======================================= TRAP SETUP ================================================
    // MISA yazmacini read only bir sekilde implement ediyoruz.
    // Aslinda bu yazmac WARL, write-any-read-legal, yani herhangi bir deger yazilabilir
    // ancak okunan degerler legal olmali. Yazma yapildiginda exception'a yol acmayacak
    // read-only bir yazmac bu tanimlamaya uyuyor.
    wire          [31:0]                misa_w = 32'b010000_000001000000X100100000000; // TODO X: User-level interrupts
    // Bunlar 0, trap handling isini usera birakmayacagiz.
    reg           [31:0]                medeleg_w           =       32'b00000000                            ;
    reg           [31:0]                mideleg_w           =       32'h00000000                            ;
    // XS & FS = 0 (FP ve additional state gerektiren extensionlarimiz yok)
    // SD = 0, yukaridakilerden oturu
    // SIE, SPIE, UIE, UPIE = 0
    // MPIE = machine previous interrupt enable? interrupt trapi oldugunda: MPIE = MIE, MIE = 0, MPP = M
    // MPP = machine previous privilege mode?
    // MRET calisinca: MIE = MPIE, MPIE = 1, MPP = M

    reg           [31:0]                mstatus_r, mstatus_ns_r                                             ;
    // machine interrupt enable/pending registerlari
    //  bit3: software interrupt e/p
    //  bit7: timer interrupt e/p
    //  bit11: external interrupt e/p
    // mie ve mip'te ayni iki bit set ise (yani interrupt enable ve interrupt geldi) interrupt handle edilir
    reg           [31:0]                mie_r, mie_ns_r                                                     ;
    reg           [31:0]                mip_r, mip_ns_r                                                     ;
    // Trap vector. Bunu bootloader dolduracak.
    reg           [31:0]                mtvec_r, mtvec_ns_r                                                 ;
    reg           [31:0]                mcounteren_r, mcounteren_ns_r                                       ;
    // ===================================== TRAP HANDLING ===============================================
    // Galiba context switch yapildiginda context switchlenen verinin bellekteki adresine isaret ediyor
    reg           [31:0]                mscratch_r, mscratch_ns_r                                           ;
    // trap'a yol acan buyrugun program sayaci
    reg           [31:0]                mepc_r, mepc_ns_r                                                   ;
    reg           [31:0]                mcause_r, mcause_ns_r                                               ;
    // load/store/if faultlarinda, page-faultlarda, misaligned load/storelarda sanal adresi kaydeden yazmac
    reg           [31:0]                mtval_r, mtval_ns_r                                                 ;
    // ==================================== COUNTERS/TIMERS ==============================================
    reg           [31:0]                mcycle_r, mcycle_ns_r                                               ;
    reg           [31:0]                minstret_r, minstret_ns_r                                           ;
    
    // ===================================================================================================
    // ====================================== DURUM DEGISKENLERI =========================================    

    reg                                 odd_ps_al_gecerli_r                                                 ;
    reg           [31:0]                oku_veri_r                                                          ;

    // ===================================================================================================
    // ========================================MODUL TANIMLAMASI==========================================


    assign                              odd_ps_al_c             = odd_kod_g == `KDD_MRET ? mepc_r : mtvec_r ;
    assign                              odd_ps_al_gecerli_c     = odd_ps_al_gecerli_r                       ;
    assign                              oku_veri_c              = oku_veri_r                                ;


    // TODOlar (oncelige gore): 
    //      - interruptlari handle et
    //      - privilege duzeyini tutan register priv-spec'te belirtilmemis
    //              bunu yine de tutmamiz gerekiyor mu?
    //      - instret'i fonksiyonel hale getir
    always @* begin
        odd_ps_al_gecerli_r            =               0                                                    ;
        mie_ns_r                       =               mie_r                                                ;
        mip_ns_r                       =               mip_r                                                ;
        mtvec_ns_r                     =               mtvec_r                                              ;
        mcounteren_ns_r                =               mcounteren_r                                         ;
        mscratch_ns_r                  =               mscratch_r                                           ;
        mepc_ns_r                      =               mepc_r                                               ;
        mcause_ns_r                    =               mcause_r                                             ;
        mtval_ns_r                     =               mtval_r                                              ;
        mcycle_ns_r                    =               mcycle_r + 1'b1                                      ;
        minstret_ns_r                  =               minstret_r                                           ;
        mstatus_ns_r                   =               mstatus_r                                            ;
        oku_veri_r                     =               0                                                    ;
  
        // Kural disi durum denetimi
        if (gc_odd_g) begin
            mepc_ns_r                  =               odd_ps_g                                             ;
            mtval_ns_r                 =               32'b0                                                ;
            mcause_ns_r                =               `KDD_YB                                              ;
            odd_ps_al_gecerli_r        =               `HIGH                                                ;
        end
        else if (yoy_odd_g) begin
            if (odd_kod_g == `KDD_MRET) begin
                mstatus_ns_r[`MSTATUS_MIE]          =        mstatus_r[`MSTATUS_MPIE]                       ;
                mstatus_ns_r[`MSTATUS_MPIE]         =        `HIGH                                          ;
                mstatus_ns_r[`MSTATUS_MPP +: 2]     =        `PRIV_MACHINE                                  ;
            end 
            mepc_ns_r                  =               odd_ps_g                                             ;
            mtval_ns_r                 =               odd_adres_g                                          ;
            mcause_ns_r                =               odd_kod_g                                            ;
            odd_ps_al_gecerli_r        =               `HIGH                                                ;
        end

        // Okuma islemi
        if(oku_gecerli_g) begin  
            case (oku_adres_g)
                `DDY_MSCRATCH: oku_veri_r       =       mscratch_r                                          ;
                `DDY_MEPC:     oku_veri_r       =       mepc_r                                              ;
                `DDY_MTVEC:    oku_veri_r       =       mtvec_r                                             ;
                `DDY_MCAUSE:   oku_veri_r       =       mcause_r                                            ;
                `DDY_MTVAL:    oku_veri_r       =       mtval_r                                             ;
                `DDY_MSTATUS:  oku_veri_r       =       mstatus_r                                           ;
                `DDY_MIP:      oku_veri_r       =       mip_r                                               ;
                `DDY_MIE:      oku_veri_r       =       mie_r                                               ;
                `DDY_MCYCLE:   oku_veri_r       =       mcycle_r                                            ;
                `DDY_MTIME:    oku_veri_r       =       minstret_r                                          ;  
            endcase     
        end             
        
        // Yazma islemi     
        if(yaz_gecerli_g) begin     
            case (yaz_adres_g)      
                `DDY_MSCRATCH: mscratch_ns_r    =       yaz_veri_g                                          ;
                `DDY_MEPC:     mepc_ns_r        =       yaz_veri_g                                          ;
                `DDY_MTVEC:    mtvec_ns_r       =       yaz_veri_g                                          ;
                `DDY_MCAUSE:   mcause_ns_r      =       yaz_veri_g                                          ;
                `DDY_MTVAL:    mtval_ns_r       =       yaz_veri_g                                          ;
                `DDY_MSTATUS:  mstatus_ns_r     =       yaz_veri_g                                          ;
                `DDY_MIP:      mip_ns_r         =       yaz_veri_g                                          ;
                `DDY_MIE:      mie_ns_r         =       yaz_veri_g                                          ;           
            endcase
        end

    end

    always @ (posedge clk_g) begin  
        if(rst_g) begin
            mepc_r                              <=      0                                                   ;
            mstatus_r                           <=      0                                                   ;
            mcause_r                            <=      0                                                   ;
            mtval_r                             <=      0                                                   ;
            mtvec_r                             <=      0                                                   ;
            mip_r                               <=      0                                                   ;
            mie_r                               <=      0                                                   ;
            mcycle_r                            <=      0                                                   ;
            minstret_r                          <=      0                                                   ;
            mscratch_r                          <=      0                                                   ;
        end
        else begin
            mepc_r                              <=      mepc_ns_r                                           ;
            mstatus_r                           <=      mstatus_ns_r                                        ;
            mcause_r                            <=      mcause_ns_r                                         ;
            mtval_r                             <=      mtval_ns_r                                          ;
            mtvec_r                             <=      mtvec_ns_r                                          ;
            mip_r                               <=      mip_ns_r                                            ;
            mie_r                               <=      mie_ns_r                                            ;
            mcycle_r                            <=      mcycle_ns_r                                         ;
            minstret_r                          <=      minstret_ns_r                                       ;
            mscratch_r                          <=      mscratch_ns_r                                       ;
        end
    end

endmodule