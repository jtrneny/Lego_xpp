TYPE(drgForm) SIZE(110,22) DTYPE(10) TITLE(Po��zen�/Oprava pokladny ...) FILE(POKLADMS)  ;        
                                                                         POST(postValidate) ; 
                                                                         GUILOOK(Action:n,IconBar:y)  


  TYPE(Static) FPOS(.5,.5) SIZE(109,10.5) STYPE(13) CTYPE(2)
    TYPE(TEXT) CAPTION(Typ pokladny)    CPOS( 1,0.5)
    TYPE(TEXT) CAPTION(��slo/n�zev )    CPOS( 1,1.55)
    TYPE(TEXT) CAPTION(Pokladn�k )      CPOS( 1,2.7)
*    TYPE(TEXT) CAPTION(ID provozovny)   CPOS( 1,4.1) CLEN(12)
*    TYPE(TEXT) CAPTION(ID pokl.za��z.)  CPOS( 1,5.0) CLEN(11)

    TYPE(ComboBox) NAME(POKLADMs->ctypPoklad)  FPOS(13, .4) FLEN(31)  ;
                     VALUES(FIN:Finan�n� pokladna,                ;
                            PRO:Registra�n� pokladna,             ;  
                            FIN_EET:Finan�n� pokladna s EET,      ;
                            PRO_EET:Registra�n� pokladna s EET )     

    TYPE(ComboBox) NAME(pokladms->lno_inDPH) FPOS( 45, .4) FLEN(24) ;
                   VALUES( F:��doklady vstupuji do DPH, T:��doklady NE_vstupuji do DPH )    

*    TYPE(ComboBox) NAME(pokladms->nrezimEET) FPOS( 45, .4) FLEN(10) ;
*                   VALUES( 0:��on_Line, 1:��off_Line )    


    TYPE(GET) NAME(POKLADMS->nPOKLADNA)  FPOS( 13, 1.55) FLEN( 3)  PP(2) POST(drgPostUniqueKey)
    TYPE(GET) NAME(POKLADMS->cNAZPOKLAD) FPOS( 18, 1.55) FLEN(25) 
    TYPE(GET) NAME(POKLADMS->cJMENOPOKL) FPOS( 13, 2.6) FLEN(30) 

    TYPE(TEXT)                                 CAPTION(�p�ednastaven� forma �hrady pro registra�n� pokladnu) CPOS(.5, 3.9)
    TYPE(COMBOBOX) NAME(POKLADMS->czkrTypUrp)  FPOS(1, 4.9) FLEN(43) VALUES(a,a,a,a) 
*    TYPE(PushButton)                     POS( 5, 95) SIZE(375,23) CAPTION() EVENT(createContext_urp) ICON1(338) ATYPE(33)

*    TYPE(GET) NAME(POKLADMS->cID_provoz) FPOS( 13, 4.0) FLEN(30) 
*    TYPE(GET) NAME(POKLADMS->cID_pokl)   FPOS( 13, 5.0) FLEN(30) 

    TYPE(GET) NAME(POKLADMS->dPOCSTAV)   FPOS( 70, 1.1) FLEN(12) FCAPTION(po��te�n� stav pokladny) CPOS(77,.1) CLEN(30) FONT(5) PUSH(CLICKDATE)
    TYPE(GET) NAME(POKLADMS->nPOCSTAV)   FPOS( 84, 1.1) FLEN(13) 
    TYPE(GET) NAME(POKLADMS->cZKRATMENY) FPOS(100, 1.1) FLEN( 6) PP(2)      

    TYPE(TEXT) CAPTION(po��te�n� stav) CPOS(55,2.1) 
    TYPE(GET)  NAME(POKLADMS->nPOCST_TUZ) FPOS( 84, 2.1) FLEN(13) 
    TYPE(TEXT) NAME(M->zaklMena)          CPOS(100, 2.1) CLEN( 7) BGND(13)    
    TYPE(STATIC) FPOS(55,3.1) SIZE(13,.1) STYPE(14)
    TYPE(END)  

    TYPE(TEXT) CAPTION(p��jem) CPOS(55,3.1)
    TYPE(GET)  NAME(POKLADMS->dPOSPRIJEM) FPOS( 70, 3.1) FLEN(12) PUSH(CLICKDATE)
    TYPE(GET)  NAME(POKLADMS->nPOSPRIJEM) FPOS( 84, 3.1) FLEN(13)
    TYPE(TEXT) NAME(POKLADMS->cZKRATMENY) CPOS(100, 3.1) CLEN( 7) BGND(13)
    TYPE(STATIC) FPOS(55,4.1) SIZE(13,.1) STYPE(14)
    TYPE(END)   

    TYPE(TEXT) CAPTION(v�dej)  CPOS(55,4.1) 
    TYPE(GET)  NAME(POKLADMS->dPOSVYDEJ)  FPOS( 70, 4.1) FLEN(12) PUSH(CLICKDATE)
    TYPE(GET)  NAME(POKLADMS->nPOSVYDEJ)  FPOS( 84, 4.1) FLEN(13) BGND(13) CTYPE(2)
    TYPE(TEXT) NAME(POKLADMS->cZKRATMENY) CPOS(100, 4.1) CLEN( 7) BGND(13)
    TYPE(STATIC) FPOS(55,5.1) SIZE(13,.1) STYPE(14)
    TYPE(END)   

    TYPE(TEXT) CAPTION(aktu�ln� Stav) CPOS(55,5.3) FONT(5)
    TYPE(TEXT) NAME(M->AKT_datum)         CPOS( 70, 5.1) CLEN(13) BGND(13) CTYPE(2) FONT(2)
    TYPE(TEXT) NAME(POKLADMS->nAKTSTAV)   CPOS( 84, 5.1) CLEN(14) BGND(13) CTYPE(2) FONT(2)
    TYPE(TEXT) NAME(POKLADMS->cZKRATMENY) CPOS(100, 5.1) CLEN( 7) BGND(13) FONT(2)

    TYPE(GET)  NAME(POKLADMS->cUCET_UCT)  FPOS( 1,7)   FLEN( 9) FCAPTION(SuAu_�) CPOS( 1,6) CLEN(7) PP(2)
    TYPE(TEXT) NAME(C_UCTOSN->cNAZ_UCT)   CPOS(12,7)   CLEN(25) BGND(13)
    TYPE(GET)  NAME(POKLADMS->cVNBAN_UCT) FPOS(41,7)   FLEN(28) FCAPTION(vnitro ��et) CPOS(41,6) CLEN(9)

    TYPE(TEXT) CAPTION(p�ednastaven� typPohybu)         CPOS(74,6.1) CLEN(20)
    TYPE(PushButton)                                    POS(74,7.2) SIZE(33,1.1) CAPTION() EVENT(createContext) ICON1(338) ATYPE(33)

*    TYPE(ComboBox) NAME(cTYPPOHYBU)       FPOS(74,7.1) FLEN(33) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()


    TYPE(STATIC) FPOS(0.4,6.6) SIZE(108.6,.1) STYPE(13)
    TYPE(End)

    TYPE(TEXT) CAPTION(Export)                   CPOS( 7, 8) CLEN(7) GROUPS(SETFONT,10.Arial CE)
    TYPE(TEXT) CAPTION(EET   komunikace s MFCR ) CPOS( 7, 9) CLEN(26) 
    TYPE(COMBOBOX) NAME(POKLADMS->CIDDatKomE)    FPOS(34, 9) FLEN(50) VALUES(a,a,a) 
    TYPE(PushButton) CAPTION(�����Nastaven�)      POS(86, 9) SIZE(13,1.1) EVENT(set_datkomE) ICON1(142) ATYPE(3)  

    TYPE(STATIC) FPOS(0.4,8.5) SIZE(108.6,.2) STYPE(13)
    TYPE(End)

    TYPE(MLE)  NAME(mdefin_kom) FPOS(0,0) SIZE(0,0) 
  TYPE(End)

  TYPE(DBrowse) FPOS(.1,11.5) SIZE(110,10.5) FILE(POKLADMS)                      ;
                                            FIELDS(FIN_POKLADMS_BC(1)::2.6::2  , ;
                                                   M->isDatKomE:e:2.4::2       , ;
                                                   M->pokl_inDPH:dph:2.2::2    , ;  
                                                   nPOKLADNA:pokladna          , ;
                                                   cNAZPOKLAD:n�zev Pokladny:28, ;
                                                   cZKRATMENY:m�na             , ;
                                                   nPOCSTAV:po� Stav           , ;
                                                   nPOSPRIJEM:p��jem           , ; 
                                                   nPOSVYDEJ:v�dej             , ;
                                                   nAKTSTAV:stav Pokladny        ) ;
                                            CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) POPUPMENU(y)


*
* neviditeln� pomocn� polo�ky
TYPE(TEXT) NAME(pokladms->ctypPohybu)   FPOS(0,0) FLEN(0)
TYPE(TEXT) NAME(pokladms->ctypDoklad)   FPOS(0,0) FLEN(0) 

