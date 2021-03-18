TYPE(drgForm) SIZE(100,20) DTYPE(10) TITLE(Pøevod/Vyøazení Zmìny DIM v evidenci ...) FILE(MSDIMw) ;
              GUILOOK(Message:Y,Action:N,IconBar:Y:myIconBar,Menu:y:myMenuBar) ;
              POST(postValidate);
              CBLOAD(onLoad)    ;
              CBSAVE(onSave)

* PØEVOD -1-
  TYPE(TabPage) SIZE(100,1.2) CAPTION(~Pøevod)   OFFSET( 1,84) PRE(tabSelect) SUB(A)
  TYPE(End)

* VÝDEJ -2-
  TYPE(TabPage) SIZE(100,1.2) CAPTION(~Výdej)    OFFSET(16,69) PRE(tabSelect) SUB(B)
  TYPE(End)

* VYØAZENÍ -3-
  TYPE(TabPage) SIZE(100,1.2) CAPTION(~Vyøazení) OFFSET(31,54) PRE(tabSelect) SUB(C)
  TYPE(End)

  TYPE(Static) STYPE(12) SIZE(68,8) FPOS(.5,1.4) CTYPE(2) RESIZE(yn)
    TYPE(Static) STYPE(2) SIZE(67,.15) FPOS(.5,4.6) CTYPE(2)
    TYPE(End)

    TYPE(Text) CAPTION(ze SKUP_místa)   CPOS( 4,1) 
    TYPE(Text) NAME(cKLICskMIS)         CPOS(20,1) CLEN(15) BGND(13) PP(2)                   CTYPE(2) 
    TYPE(Get)  NAME(M->KLICskmis)       FPOS(40,1) FLEN(15) PUSH(zmenydim_sel)               GROUPS(1,3)       

    TYPE(Text) FCAPTION(ODP_místa)      CPOS( 7,2) 
    TYPE(Text) NAME(cKLICodMIS)         CPOS(20,2) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
    TYPE(Get)  NAME(M->KLICodmis)       FPOS(40,2) FLEN(15) PUSH(zmenydim_sel)

    TYPE(Text) FCAPTION(INV_èíslo)      CPOS( 7,3) 
    TYPE(Text) NAME(NINVCISDIM)         CPOS(20,3) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
    TYPE(Get)  NAME(M->INVcisdim)       FPOS(40,3) FLEN(15) PICTURE(@N 999999)

    TYPE(Text) FCAPTION(MNOŽSTVÍ)       CPOS( 4,6) CLEN( 9)
    TYPE(Text) NAME(CZKRATJEDN)         CPOS(13,6) 
    TYPE(Text) NAME(NPOCKUSDIM)         CPOS(20,6) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
    TYPE(Get)  NAME(M->POCkusdim)       FPOS(40,6) FLEN(15) PICTURE(@N 99999999.99)          GROUPS(2)
  TYPE(End)

  TYPE(Static) STYPE(11) SIZE(31,8) FPOS(68,1.4) CTYPE(2)
    TYPE(PushButton) POS(  3, 5.0) SIZE(26,1.2) CAPTION(~Pøevod všech položek) EVENT(BUTT_saveall) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(  3, 6.5) SIZE(12,1.2) CAPTION(~Pøevod)               EVENT(BUTT_save)    PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 17, 6.5) SIZE(12,1.2) CAPTION(~Storno)               EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)
  TYPE(End)

* Browser definition
  TYPE(DBrowse) FILE(MSDIMw) SIZE(99,10) FPOS(-.2,9.7);
                FIELDS(POCkusDIM()::1::2,cKLICskMIS,cKLICodMIS,nINVcisDIM,cNAZEVdim::34,dDATzarDIM::10,nPOCkusDIM,nCENcelDIM) ;
                CURSORMODE(3) PP(7) SCROLL(ny)



