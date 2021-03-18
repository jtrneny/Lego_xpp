TYPE(drgForm) DTYPE(10) TITLE(Vnitropodnikové sazby mzdových úètù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

*TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)

TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)

  TYPE(TEXT) CAPTION(Vnitropodnikové sazby mzdových úètù) CPOS(13,0.10) CLEN(25) FONT(2)

TYPE(END)

  TYPE(EBrowse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(C_VNMZUC) INDEXORD(1)      ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
    TYPE(GET)      NAME(C_VNMZUC->nUcetMzdy)    FPOS( 1,0)  FLEN(5)  FCAPTION(ÚèetMZ)
    TYPE(GET)      NAME(C_VNMZUC->cUcetNak1)    FPOS( 2,0)  FLEN(6)  FCAPTION(ÚèetNák1)
    TYPE(GET)      NAME(C_VNMZUC->cUcetVyn1)    FPOS( 3,0)  FLEN(6)  FCAPTION(ÚèetVýn1)
    TYPE(GET)      NAME(C_VNMZUC->nSazbaVNU1)   FPOS( 4,0)  FLEN(6)  FCAPTION(SazbaVNU1)
    TYPE(COMBOBOX) NAME(C_VNMZUC->nTypVypoc1)   FPOS( 5,0)  FLEN(15) FCAPTION(Výpoèet1)   REF(nTypVypVNU) 
    TYPE(COMBOBOX) NAME(C_VNMZUC->nTypNulov1)   FPOS( 6,0)  FLEN(11) FCAPTION(Nulován1)   REF(nTypNulVNU) 
    TYPE(GET)      NAME(C_VNMZUC->cNazPol1)     FPOS( 7,0)  FLEN(6)  FCAPTION(Støedisko)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol2)     FPOS( 8,0)  FLEN(6)  FCAPTION(Výrobek)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol3)     FPOS( 9,0)  FLEN(6)  FCAPTION(Zakázka)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol4)     FPOS(10,0)  FLEN(6)  FCAPTION(VýrMísto)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol5)     FPOS(11,0)  FLEN(6)  FCAPTION(Stroj)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol6)     FPOS(12,0)  FLEN(6)  FCAPTION(Operace)
*    TYPE(GET)     NAME(C_VNMZUC->lOpravNak1)   FPOS(13,0)  FLEN(6)  FCAPTION(OpravaNS1)
    TYPE(GET)      NAME(C_VNMZUC->cUcetNak2)    FPOS(14,0)  FLEN(6)  FCAPTION(ÚèetNák2)
    TYPE(GET)      NAME(C_VNMZUC->cUcetVyn2)    FPOS(15,0)  FLEN(6)  FCAPTION(ÚèetVýn2)
    TYPE(GET)      NAME(C_VNMZUC->nSazbaVNU2)   FPOS(16,0)  FLEN(6)  FCAPTION(SazbaVNU2)
    TYPE(COMBOBOX) NAME(C_VNMZUC->nTypVypoc2)   FPOS(17,0)  FLEN(15) FCAPTION(Výpoèet2)   REF(nTypVypVNU) 
    TYPE(COMBOBOX) NAME(C_VNMZUC->nTypNulov2)   FPOS(18,0)  FLEN(11) FCAPTION(Nulován2)   REF(nTypNulVNU) 
    TYPE(GET)      NAME(C_VNMZUC->cNazPol1_2)   FPOS(19,0)  FLEN(6)  FCAPTION(Støedisko)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol2_2)   FPOS(20,0)  FLEN(6)  FCAPTION(Výrobek)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol3_2)   FPOS(21,0)  FLEN(6)  FCAPTION(Zakázka)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol4_2)   FPOS(22,0)  FLEN(6)  FCAPTION(VýrMísto)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol5_2)   FPOS(23,0)  FLEN(6)  FCAPTION(Stroj)
    TYPE(GET)      NAME(C_VNMZUC->cNazPol6_2)   FPOS(24,0)  FLEN(6)  FCAPTION(Operace)
    TYPE(GET)      NAME(C_VNMZUC->nSazbaPrac)   FPOS(25,0)  FLEN(6)  FCAPTION(SazbaPrac)
    TYPE(GET)      NAME(C_VNMZUC->nSazbaStro)   FPOS(26,0)  FLEN(6)  FCAPTION(SazbaStroj)
*    TYPE(GET)   NAME(C_VNMZUC->lOpravNak2)   FPOS(27,0)  FLEN(6) FCAPTION(OpravaNS2)
    
  TYPE( End)