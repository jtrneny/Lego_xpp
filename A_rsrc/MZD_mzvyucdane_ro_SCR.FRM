TYPE(drgForm) DTYPE(10) TITLE(Roèní výpoètená daò a daòové zvýhodnìní ) SIZE(115,29)       ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_mzvyucdane_CRD) OBDOBI(MZD)            ; 
              PRINTFILES(vyucdane:,                                                        ;
                         vyucdani:sid=nvyucdane)                             

  TYPE(Action) CAPTION(~HromadnéZpr)    EVENT(mzd_generuj_vypDan)       TIPTEXT(Hromadný výpoèet roèní danì ...)
  TYPE(Action) CAPTION(~Podklady)       EVENT(mzd_mzvyucdane_it_scr)    TIPTEXT(Podklady za jednotlivá období)
*  TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)


  TYPE(DBrowse) FPOS(.45,.20) SIZE(45.8,27) FILE(vyucdane)    ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy)           ;
                FIELDS( nOsCisPrac                                         , ;
                        cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30, ;
                        cRodCisPra                                         , ;
                        ncisOsoby                                          ) ;                      
                 CURSORMODE(3) PP(7) ITEMMARKED(itemMarked)


****
TYPE(Static) FPOS( 46,.1 ) SIZE(69,28) RESIZE(y)

  TYPE(TEXT) FCAPTION(1. Úhrn pøíjmù od všech plátcù s vyjímkou pøíjmù, u nichž je daò vypoøádaná)  CPOS(   .5,0.5) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(TEXT) FCAPTION(zvlášní sazbou danì)                                                          CPOS(  2.5,1.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nUPR_Celk)                                                               FPOS( 57  , .5) FLEN(10) PP(2) 

  TYPE(TEXT) FCAPTION(2. Úhrn povinného pojistného /§ 6 odst- 13 zákona/)                           CPOS(   .5,2  ) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nPOJ_Celk)                                                               FPOS( 57  ,2  ) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(3. Dílèí základ danì od všech plátcù /ø. 1 + ø. 2/)                           CPOS(   .5,2.8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDZD_Celk)                                                               FPOS( 57  ,2.8) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(4.   /§ 15 odst. 1 zákona/           hodnota darù)                            CPOS(   .5,3.6) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Dary)                                                               FPOS( 57  ,3.6) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(5.   /§ 15 odst. 3 a 4 zákona/    úroky z úvìru)                              CPOS(   .5,4.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Uver)                                                               FPOS( 57  ,4.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(6.   /§ 15 odst. 5 zákona/        pøíspìvky na penz.pøipoj.,penz.pojišt.)     CPOS(   .5,5.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_PenPr)                                                              FPOS( 57  ,5.2) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(7.   /§ 15 odst. 6 zákona/        pojistné na soukromé životní pojištìní)     CPOS(   .5,6  ) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_SoZiP)                                                              FPOS( 57  ,6  ) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(8.   /§ 15 odst. 7 zákona/        èlenské pøíspìvky èlena odborové organ.)    CPOS(   .5,6.8) CLEN(52) GROUPS(ETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_ClPOO)                                                              FPOS( 57,6.8  ) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(9.   /§ 15 odst. 8 zákona/        úhrady ze zkoušky ovìøuj.výs.dalš.vzdìl.)   CPOS(   .5,7.6) CLEN(54) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_ZkVzd)                                                              FPOS( 57  ,7.6) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(10. Nezdanitelné èástky celkem)                                               CPOS(   .5,8.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Celk)                                                               FPOS( 57  ,8.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(11. Základ danì snížený o nezdanitelné èástky)                                CPOS(   .5,9.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nZaklDane)                                                               FPOS( 57  ,9.2) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(12. Vypoètená daò)                                                            CPOS(   .5,10 ) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nVypocDan)                                                               FPOS( 57  ,10 ) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(13.               písm. a/ základní sleva na poplatníka)                      CPOS(   .5,10.8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Prac)                                                               FPOS( 57  ,10.8) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(14.               písm. b/ na manželku /manžela/)                             CPOS(   .5,11.6) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Manz)                                                               FPOS( 57  ,11.6) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(15.               písm. c/ základní sleva na invaliditu)                      CPOS(   .5,12.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_CasIn)                                                              FPOS( 57  ,12.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(16.               písm. d/ rozšíøená sleva na invaliditu)                     CPOS(   .5,13.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_PlnIn)                                                              FPOS( 57  ,13.2) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(17.               písm. e/ na držitele prùkazu ZTP/P)                         CPOS(   .5,14  ) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_ZTP)                                                                FPOS( 57  ,14  ) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(18.               písm. f/ na studenta)                                       CPOS(   .5,14.8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_Stud)                                                               FPOS( 57  ,14.8) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(18a.              písm. g/ za umístìní dítìte)                                CPOS(   .5,15.6) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nNEZ_UmDit)                                                              FPOS( 57  ,15.6) FLEN(10) PP(2) 


  TYPE(TEXT) FCAPTION(19. Slevy na dani podle § 35ba zákona celkem)                                 CPOS(   .5,16.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nSLD_Celk)                                                               FPOS( 57  ,16.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(20. Daò po slevì na dani podle § 35ba zákona /èástka musí být >= 0)           CPOS(   .5,17.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDSL_Celk)                                                               FPOS( 57  ,17.2) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(21. Úhrn sražených záloh na daò /po slevì na dani/)                           CPOS(   .5,18.0) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nUSZ_Celk)                                                               FPOS( 57  ,18.0) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(22. Pøeplatek /oznaè + je li 21>20/  Nedoplatek /oznaè - je li 21<20/)        CPOS(   .5,18.8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nPrepNedop)                                                              FPOS( 57  ,18.8) FLEN(10) PP(2) FONT(5)
  TYPE(TEXT) FCAPTION(23.                      Nárok celkem)                                        CPOS(   .5,19.6) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDZN_Zames)                                                              FPOS( 57  ,19.6) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(24. Daòové zvýhodnìní    z toho sleva na dani)                                CPOS(   .5,20.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDZS_Celk)                                                               FPOS( 57  ,20.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(25.                      daòový bonus /ø.23-ø.24/)                            CPOS(   .5,21.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDZB_Zames)                                                              FPOS( 57  ,21.2) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(26. Zúètování záloh      Daò po slevì /ø.20-ø.24/)                            CPOS(   .5,22.0) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nZDS_Dan)                                                                FPOS( 57  ,22.0) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(27. na daò po slevì      Rozdíl na dani po slevì /ø.21-ø.26/)                 CPOS(   .5,22.8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nZDS_Rozd)                                                               FPOS( 57  ,22.8) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(28. Zúètování mìsíèních    Vyplacené mìsíèní daòové bonusy od všech plátcù)   CPOS(   .5,23.6) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nMDB_Celk)                                                               FPOS( 57  ,23.6) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(29. daòových bonusù        Rozdíl na daòovém bonusu /ø.25-ø.28/)              CPOS(   .5,24.4) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nMDB_Rozd)                                                               FPOS( 57  ,24.4) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(30. Kompenzace vzniklých rozdílù na daòi a na bonusu /ø.27+ø.29/)             CPOS(   .5,25.2) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nKVR_DanBo)                                                              FPOS( 57  ,25.2) FLEN(10) PP(2) FONT(5)
  TYPE(TEXT) FCAPTION(31. Doplatek ze zúètování      a/ -pøeplatek na dani po slevì)                CPOS(   .5,26.0) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDoplZu31a)                                                              FPOS( 57  ,26.0) FLEN(10) PP(2) 
  TYPE(TEXT) FCAPTION(    /z ø.30/ èiní              b/ -doplatek na daòovém bonusu)                CPOS(   .5,26,8) CLEN(52) GROUPS(SETFONT, 12.Cambria)
  TYPE(GET) NAME(vyucdane->nDoplZu31b)                                                              FPOS( 57  ,26,8) FLEN(10) PP(2) 
TYPE(End)
****

*** QUICK FILTR ***
*TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(39.2,1.25) RESIZE(yn)
*  TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
*   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
*     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*   TYPE(END) 

*TYPE(END)




