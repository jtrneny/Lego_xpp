TYPE(drgForm) SIZE(100,20) DTYPE(10) TITLE(Pøevod/Vyøazení Zmìny DIM v evidenci ...) FILE(MSDIMw) ;
              GUILOOK(Message:Y,Action:N,IconBar:Y:myIconBar,Menu:y:myMenuBar) ;
              POST(postValidate);
              CBLOAD(onLoad)    ;
              CBSAVE(onSave)

* PØEVOD -1-
    TYPE(TabPage) CAPTION(~Pøevod) OFFSET(1,82) FPOS(.5,.2) SIZE(99,10) PRE(tabSelect)
      TYPE(Static) STYPE(11) SIZE(68,8) FPOS(1,0.5)
        TYPE(Static) STYPE(2) SIZE(67,.15) FPOS(.5,4.6) CTYPE(2)
        TYPE(End)

        TYPE(Text) CAPTION(ze SKUP_místa)   CPOS( 4,1) 
        TYPE(Text) NAME(cKLICskMIS)         CPOS(20,1) CLEN(15) BGND(13) PP(2)                   CTYPE(2) 
        TYPE(Get)  NAME(M->KLICskmis)       FPOS(40,1) FLEN(15) PUSH(zmenydim_sel)                        GROUPS(1)

        TYPE(Text) FCAPTION(ODP_místa)      CPOS( 7,2) 
        TYPE(Text) NAME(cKLICodMIS)         CPOS(20,2) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
        TYPE(Get)  NAME(M->KLICodmis)       FPOS(40,2) FLEN(15) PUSH(zmenydim_sel)

        TYPE(Text) FCAPTION(INV_èíslo)      CPOS( 7,3) 
        TYPE(Text) NAME(NINVCISDIM)         CPOS(20,3) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
        TYPE(Text) FCAPTION(MNOŽTVÍ_)       CPOS( 4,6) CLEN( 9)
        TYPE(Text) NAME(CZKRATJEDN)         CPOS(13,6) 
        TYPE(Text) NAME(NPOCKUSDIM)         CPOS(20,6) CLEN(15) BGND(13) PP(2)                   CTYPE(2)
        TYPE(Get)  NAME(M->POCkusdim)       FPOS(40,6) FLEN(15) PICTURE(@N 99999999.99)
      TYPE(End)

      TYPE(PushButton) POS(70,6)   SIZE(27,1.2) CAPTION(~Pøevod všech položek) EVENT(BUTT_saveall) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(70,7.5) SIZE(12,1.2) CAPTION(~Pøevod)               EVENT(BUTT_save)    PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(85,7.5) SIZE(12,1.2) CAPTION(~Storno)               EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)
    TYPE(End)

* VYØAZENÍ -2-
    TYPE(TabPage) CAPTION(~Vyøazení) OFFSET(16,68) FPOS(.5,.2) SIZE(99,10) PRE(tabSelect)
      TYPE(Static) STYPE(11) SIZE(68,8) FPOS(1,0.5)
        TYPE(Static) STYPE(9) SIZE(67,.15) FPOS(1.5,4.5) CTYPE(2)
        TYPE(End)

        TYPE(Text) CAPTION(ze SKUP_místa)   CPOS( 4,1) 
        TYPE(Text) NAME(cKLICskMIS)         CPOS(20,1) CLEN(15) BGND(13) PP(2) 
        TYPE(Text) FCAPTION(ODP_místa)      CPOS( 7,2) 
        TYPE(Text) NAME(cKLICodMIS)         CPOS(20,2) CLEN(15) BGND(13) PP(2) 
        TYPE(Text) FCAPTION(INV_èíslo)      CPOS( 7,3) 
        TYPE(Text) NAME(NINVCISDIM)         CPOS(20,3) CLEN(15) BGND(13) PP(2) 
        TYPE(Text) FCAPTION(MNOŽTVÍ_)       CPOS( 4,6) CLEN( 9)
        TYPE(Text) NAME(CZKRATJEDN)         CPOS(13,6) 
        TYPE(Text) NAME(NPOCKUSDIM)         CPOS(20,6) CLEN(15) BGND(13) PP(2) 
        TYPE(Get)  NAME(M->POCkusdim)       FPOS(40,6) FLEN(15) PICTURE(@N 99999999.99)  GROUPS(2)
      TYPE(End) 

      TYPE(PushButton) POS(70,6)   SIZE(27,1.2) CAPTION(~Vyøazení všech položek) EVENT(BUTT_saveall) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(70,7.5) SIZE(12,1.2) CAPTION(~Vyøazení)               EVENT(BUTT_save)    PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(85,7.5) SIZE(12,1.2) CAPTION(~Storno)                 EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)
    TYPE(End)

* VÝDEJ -3-
    TYPE(TabPage) CAPTION(~Výdej) OFFSET(31,53) FPOS(.5,.2) SIZE(99,10) PRE(tabSelect)
      TYPE(Static) STYPE(11) SIZE(68,8) FPOS(1,0.5)
        TYPE(Static) STYPE(9) SIZE(67,.15) FPOS(1.5,4.5)
        TYPE(End)

        TYPE(Text) CAPTION(ze SKUP_místa)   CPOS( 4,1) 
        TYPE(Text) NAME(cKLICskMIS)         CPOS(20,1) CLEN(15) BGND(13) PP(2) 
        TYPE(Get)  NAME(M->KLICskmis)       FPOS(40,1) FLEN(15) PUSH(zmenydim_sel)              GROUPS(3)

        TYPE(Text) FCAPTION(ODP_místa)      CPOS( 7,2) 
        TYPE(Text) NAME(cKLICodMIS)         CPOS(20,2) CLEN(15) BGND(13) PP(2) 
        TYPE(Get)  NAME(M->KLICodmis)       FPOS(40,2) FLEN(15) PUSH(zmenydim_sel)

        TYPE(Text) FCAPTION(INV_èísla)      CPOS( 7,3) 
        TYPE(Text) NAME(NINVCISDIM)         CPOS(20,3) CLEN(15) BGND(13) PP(2) 
        TYPE(Get)  NAME(M->INVcisdim)       FPOS(40,3) FLEN(15) PICTURE(@N 999999)

        TYPE(Text) FCAPTION(MNOŽTVÍ_)       CPOS( 4,6) CLEN( 9)
        TYPE(Text) NAME(CZKRATJEDN)         CPOS(13,6) 
        TYPE(Text) NAME(NPOCKUSDIM)         CPOS(20,6) CLEN(15) BGND(13) PP(2) 
        TYPE(Get)  NAME(M->POCkusdim)       FPOS(40,6) FLEN(15) PICTURE(@N 99999999.99)
      TYPE(End)

      TYPE(PushButton) POS(70,6)   SIZE(27,1.2) CAPTION(~Výdej všech položek) EVENT(BUTT_saveall) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(70,7.5) SIZE(12,1.2) CAPTION(~Výdej)               EVENT(BUTT_save)    PRE(2) ICON1(101) ICON2(201) ATYPE(3)
      TYPE(PushButton) POS(85,7.5) SIZE(12,1.2) CAPTION(~Storno)              EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)
    TYPE(End)


* Browser definition
  TYPE(DBrowse) FILE(MSDIMw) SIZE(99,9) FPOS(.5,10.5);
               FIELDS(POCkusDIM()::1::2,cKLICskMIS,cKLICodMIS,nINVcisDIM,cNAZEVdim::34,dDATzarDIM,nPOCkusDIM,nCENcelDIM) ;
               CURSORMODE(3) PP(7) SCROLL(ny)



