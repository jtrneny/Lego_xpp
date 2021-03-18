TYPE(drgForm) DTYPE(10) TITLE(Vnitropodnikové sazby strojù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

*TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)

TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)

  TYPE(TEXT) CAPTION(Vnitropodnikové sazby strojù) CPOS(13,0.10) CLEN(25) FONT(2)

TYPE(END)

  TYPE(EBrowse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(C_VNSAST) INDEXORD(1)      ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
    TYPE(GET)      NAME(C_VNSAST->cCisStroje)   FPOS( 1,0)  FLEN(5)  FCAPTION(ÈísStroje)
    TYPE(GET)      NAME(C_VNSAST->cNazevStro)   FPOS( 2,0)  FLEN(35) FCAPTION(NázStroje)
    TYPE(GET)      NAME(C_VNSAST->cKmenStrSt)   FPOS( 3,0)  FLEN(8)  FCAPTION(KmenStøStr)
    TYPE(GET)      NAME(C_VNSAST->cUcetNak1)    FPOS( 4,0)  FLEN(6)  FCAPTION(ÚèetNák1)
    TYPE(GET)      NAME(C_VNSAST->cUcetVyn1)    FPOS( 5,0)  FLEN(6)  FCAPTION(ÚèetVýn1)
    TYPE(GET)      NAME(C_VNSAST->nSazbaVNU1)   FPOS( 6,0)  FLEN(6)  FCAPTION(SazbaVNU1)
    TYPE(COMBOBOX) NAME(C_VNSAST->nTypVypoc1)   FPOS( 7,0)  FLEN(15) FCAPTION(Výpoèet1)   REF(nTypVypVNU) 
    TYPE(COMBOBOX) NAME(C_VNSAST->nTypNulov1)   FPOS( 8,0)  FLEN(11) FCAPTION(Nulován1)   REF(nTypNulVNU) 
    TYPE(GET)      NAME(C_VNSAST->nSazbaVNU2)   FPOS( 9,0)  FLEN(6)  FCAPTION(SazbaVNU2)
    TYPE(COMBOBOX) NAME(C_VNSAST->nTypVypoc2)   FPOS( 7,0)  FLEN(15) FCAPTION(Výpoèet2)   REF(nTypVypVNU) 
    TYPE(COMBOBOX) NAME(C_VNSAST->nTypNulov2)   FPOS( 8,0)  FLEN(11) FCAPTION(Nulován2)   REF(nTypNulVNU) 
    TYPE(GET)      NAME(C_VNSAST->cNazPol1)     FPOS(12,0)  FLEN(8)  FCAPTION(Støedisko)
    TYPE(GET)      NAME(C_VNSAST->cNazPol2)     FPOS(13,0)  FLEN(8)  FCAPTION(Výrobek)
    TYPE(GET)      NAME(C_VNSAST->cNazPol3)     FPOS(14,0)  FLEN(8)  FCAPTION(Zakázka)
    TYPE(GET)      NAME(C_VNSAST->cNazPol4)     FPOS(15,0)  FLEN(8)  FCAPTION(VýrMísto)
    TYPE(GET)      NAME(C_VNSAST->cNazPol5)     FPOS(16,0)  FLEN(8)  FCAPTION(Stroj)
    TYPE(GET)      NAME(C_VNSAST->cNazPol6)     FPOS(17,0)  FLEN(8)  FCAPTION(Operace)
    
  TYPE( End)