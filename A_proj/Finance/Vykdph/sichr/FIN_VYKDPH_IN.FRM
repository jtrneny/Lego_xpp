TYPE(drgForm) DTYPE(10) TITLE(Výkaz DPH ...) SIZE(102,15) FILE(VYKDPH_Iw) ;
              GUILOOK(All:n) BORDER(4) PRE(preValidate) POST(postValidate)

  TYPE(EBROWSE) FPOS(.1,1.2) SIZE(100.9,7.8) FILE(vykdph_IW)                                    ;
                             ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                             GUILOOK(ins:n,del:n,sizecols:n,headmove:n) REST(n)

*    TYPE(CHECKBOX) NAME(vykDph_Iw->lsetPreDan)   CLEN( 3)  CAPTION(pdp) REF(LYESNO) NOREVISION()
    TYPE(TEXT)     NAME(        M->preDanPov )   CLEN( 3)  CAPTION() BITMAP()
    TYPE(TEXT)     NAME(vykdph_IW->nradek_dph)   CLEN( 5)  CAPTION(øv)
    TYPE(TEXT)     NAME(        M->cradek_dph)   CLEN(26)  CAPTION(název øádku výkazu dph)
    TYPE(GET)      NAME(vykdph_IW->nzakld_dph)   FLEN(13)  PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(vykdph_IW->nsazba_dph)   FLEN(13)  
    TYPE(GET)      NAME(vykdph_IW->nkrace_nar)   FLEN(13)
    TYPE(COMBOBOX) NAME(vykdph_IW->ntypPreDan)   FLEN(15) REF(NTYPPREDAN)  
    TYPE(GET)      NAME(vykdph_IW->cucetu_dph)   FLEN( 8) 
  TYPE(END)

* RV pro pøíslušný soubor a typ
  TYPE(TabPage) SIZE(100,1.2) CAPTION(Osvobozeno)    OFFSET( 1,86) PRE(tabSelect)
*-    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* novinka od 1.1.2015
  TYPE(TabPage) SIZE(100,1.2) CAPTION(Snížená daò_2) OFFSET(13,72) PRE(tabSelect)
*-    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) SIZE(100,1.2) CAPTION(Snížená daò)   OFFSET(27,58) PRE(tabSelect)
*-    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) SIZE(100,1.2) CAPTION(Základní daò)  OFFSET(41,43) PRE(tabSelect)
*-    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* INFO ze základního souboru
  TYPE(Static) STYPE(13) SIZE(98,5) FPOS(.9,9.3) CTYPE(2)
    TYPE(Text) CAPTION(Bez danì      __________________) CPOS( 1, .3) CLEN(26)
    TYPE(Text) NAME(M->NOSVODDAN)                        CPOS(27, .3) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
*
*
    TYPE(Text) CAPTION(Základ danì _________) CPOS( 1,1.4) CLEN(18) 
    TYPE(Text) NAME(M->NPROCDAN_3)            CPOS(19,1.4) CLEN( 3) BGND(13) PP(2) PICTURE(@N 99)             CTYPE(2)
    TYPE(Text) CAPTION(%)                     CPOS(22,1.4) CLEN( 3) FONT(5)
    TYPE(Text) NAME(M->NZAKLDAN_3)            CPOS(27,1.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) CAPTION(daò)                   CPOS(42,1.4) CLEN( 4) FONT(5)
    TYPE(Text) NAME(M->NSAZDAN_3)             CPOS(47,1.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
*
    TYPE(Text) NAME(M->odvod_3)               CPOS(68,1.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) NAME(M->narok_3)               CPOS(82,1.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
*
*
    TYPE(Text) CAPTION(Základ danì _________) CPOS( 1,2.4) CLEN(18) 
    TYPE(Text) NAME(M->NPROCDAN_1)            CPOS(19,2.4) CLEN( 3) BGND(13) PP(2) PICTURE(@N 99)             CTYPE(2)
    TYPE(Text) CAPTION(%)                     CPOS(22,2.4) CLEN( 3) FONT(5)
    TYPE(Text) NAME(M->NZAKLDAN_1)            CPOS(27,2.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) CAPTION(daò)                   CPOS(42,2.4) CLEN( 4) FONT(5)
    TYPE(Text) NAME(M->NSAZDAN_1)             CPOS(47,2.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
*
    TYPE(Text) NAME(M->odvod_1)               CPOS(68,2.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) NAME(M->narok_1)               CPOS(82,2.4) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
*
*
    TYPE(Text) CAPTION(Základ danì _________) CPOS( 1,3.5) CLEN(18) 
    TYPE(Text) NAME(M->NPROCDAN_2)            CPOS(19,3.5) CLEN( 3) BGND(13) PP(2) PICTURE(@N 99)             CTYPE(2)
    TYPE(Text) CAPTION(%)                     CPOS(22,3.5) CLEN( 3) FONT(5)
    TYPE(Text) NAME(M->NZAKLDAN_2)            CPOS(27,3.5) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) CAPTION(daò)                   CPOS(42,3.5) CLEN( 4) FONT(5)
    TYPE(Text) NAME(M->NSAZDAN_2)             CPOS(47,3.5) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
*
    TYPE(Text) NAME(M->odvod_2)               CPOS(68,3.5) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)
    TYPE(Text) NAME(M->narok_2)               CPOS(82,3.5) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99)  CTYPE(2)

    TYPE(Text) CAPTION(odvod)                 CPOS(68, .3) CLEN(10) CTYPE(2)
    TYPE(Text) CAPTION(nárok)                 CPOS(81, .3) CLEN(10) CTYPE(2)

    TYPE(Static) STYPE(12) SIZE(30,4.8) FPOS(66.7,.1) CTYPE(2)
    TYPE(End)
  TYPE(End)


