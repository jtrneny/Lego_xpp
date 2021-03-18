TYPE(drgForm) DTYPE(10) TITLE(Roèní výpoèet danì a daòového zvýhodnìní) SIZE(80,31) ;
              POST(postValidate)                                                   ;
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n,IconBar:n) 


 TYPE(Action) CAPTION(~Výpoèet_danì)       EVENT(mzd_generuj_vypdan)     TIPTEXT(Generuje výpoèet danì a daò.zvýhodnìní ...)
 TYPE(Action) CAPTION(~Ulož vyp_daò)       EVENT(140000001)              TIPTEXT(Uloží vypoètenou daò ...)


  TYPE(Static) CTYPE(13) FPOS(0.8,0.05) SIZE(78.5,2.3)  RESIZE(y)
    TYPE(TEXT) FCAPTION(Poplatník)                                CPOS(  1,0.5) CLEN( 8)
     TYPE(GET) NAME(vyucdanew->cosoba)                             FPOS( 12,0.5) FLEN( 38) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Rodné èíslo)                              CPOS( 53,0.5) CLEN(10)
     TYPE(GET) NAME(vyucdanew->crodcispra)                         FPOS( 63,0.5) FLEN( 13) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(Bydlištì)                                 CPOS(  1,1.5) CLEN( 8)
     TYPE(GET) NAME(vyucDanew->culicCiPop)                         FPOS( 12,1.5) FLEN( 18) PP(2) FONT(5)
     TYPE(GET) NAME(vyucDanew->cmisto)                             FPOS( 32,1.5) FLEN( 18) PP(2) FONT(5)
***     TYPE(GET) NAME(vyucdanew->cbydliste)                          FPOS( 12,1.5) FLEN( 38) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Psè)                                      CPOS( 53,1.5) CLEN( 8)
     TYPE(GET) NAME(vyucdanew->cpsc)                              FPOS( 63,1.5) FLEN( 13) PP(2) FONT(5)
  TYPE(End)

*  TYPE(Static) CTYPE(3) SIZE(109,1.2) FPOS(0.4,2.8) RESIZE(y)
*  TYPE(End)

  TYPE(Static) CTYPE(2) FPOS(0.8,2.6)  SIZE(78.5,27.7) RESIZE(y)
    TYPE(TEXT) FCAPTION(1. Úhrn pøíjmù od všech plátcù s vyjímkou pøíjmù, u nichž je daò vypoøádaná)    CPOS( 0.5,0.5) CLEN(55) GROUPS(SETFONT, 12.Cambria)
    TYPE(TEXT) FCAPTION(zvlášní sazbou danì)                                                            CPOS( 2.5,1.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nUPR_Celk)                                                                FPOS( 60,0.5) FLEN(10) PP(2) GROUPS(UPR) PUSH(mzd_vyucDane_plat)

    TYPE(TEXT) FCAPTION(2. Úhrn povinného pojistného /§ 6 odst- 13 zákona/)                             CPOS( 0.5,2.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nPOJ_Celk)                                                                FPOS( 60,2.0) FLEN(10) PP(2) GROUPS(POJ) PUSH(mzd_vyucDane_plat)

    TYPE(TEXT) FCAPTION(3. Dílèí základ danì od všech plátcù /ø. 1 + ø. 2/)                             CPOS( 0.5,2.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDZD_Celk)                                                                FPOS( 60,2.8) FLEN(10) PP(2)

    TYPE(TEXT) FCAPTION(4.   /§ 15 odst. 1 zákona/           hodnota darù)                              CPOS( 0.5,3.6) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Dary)                                                                FPOS( 60,3.6) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(5.   /§ 15 odst. 3 a 4 zákona/    úroky z úvìru)                                CPOS( 0.5,4.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Uver)                                                                FPOS( 60,4.4) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(6.   /§ 15 odst. 5 zákona/        pøíspìvky na penz.pøipoj.,penz.pojišt.)       CPOS( 0.5,5.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_PenPr)                                                                FPOS( 60,5.2) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(7.   /§ 15 odst. 6 zákona/        pojistné na soukromé životní pojištìní)       CPOS( 0.5,6.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_SoZiP)                                                                FPOS( 60,6.0) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(8.   /§ 15 odst. 7 zákona/        èlenské pøíspìvky èlena odborové organ.)      CPOS( 0.5,6.8) CLEN(55) GROUPS(ETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_ClPOO)                                                                FPOS( 60,6.8) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(9.   /§ 15 odst. 8 zákona/        úhrady ze zkoušky ovìøuj.výsledky dalš.vzdìl.)   CPOS( 0.5,7.6) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_ZkVzd)                                                               FPOS( 60,7.6) FLEN(10) PP(2)  

    TYPE(TEXT) FCAPTION(10.                       Nezdanitelné èástky celkem)                           CPOS( 0.5,8.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Celk)                                                                FPOS( 60,8.4) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(11. Základ danì snížený o nezdanitelné èástky)                                  CPOS( 0.5,9.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nZaklDane)                                                                FPOS( 60,9.2) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(12. Vypoètená daò)                                                              CPOS( 0.5,10.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nVypocDan)                                                                FPOS( 60,10.0) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(13.               písm. a/ základní sleva na poplatníka)                        CPOS( 0.5,10.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Prac)                                                                FPOS( 60,10.8) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(14.               písm. b/ na manželku /manžela/)                               CPOS( 0.5,11.6) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Manz)                                                                FPOS( 60,11.6) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(15.               písm. c/ základní sleva na invaliditu )                       CPOS( 0.5,12.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_CasIn)                                                               FPOS( 60,12.4) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(16.               písm. d/ rozšíøená sleva na invaliditu)                       CPOS( 0.5,13.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_PlnIn)                                                               FPOS( 60,13.2) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(17.               písm. e/ na držitele prùkazu ZTP/P)                           CPOS( 0.5,14.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_ZTP)                                                                 FPOS( 60,14.0) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(18.               písm. f/ na studenta)                                         CPOS( 0.5,14.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_Stud)                                                                FPOS( 60,14.8) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(18a.              písm. g/ za umístìní dítìte)                                  CPOS( 0.5,15.6) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nNEZ_UmDit)                                                                FPOS( 60,15.6) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(19. Slevy na dani podle § 35ba zákona celkem)                                   CPOS( 0.5,16.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nSLD_Celk)                                                                FPOS( 60,16.4) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(20. Daò po slevì na dani podle § 35ba zákona /èástka musí být >= 0)             CPOS( 0.5,17.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDSL_Celk)                                                                FPOS( 60,17.2) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(21. Úhrn sražených záloh na daò /po slevì na dani/)                             CPOS( 0.5,18.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nUSZ_Celk)                                                                FPOS( 60,18.0) FLEN(10) PP(2) GROUPS(USZ) PUSH(mzd_vyucDane_plat)

    TYPE(TEXT) FCAPTION(22. Pøeplatek /oznaè + je li 21>20/  Nedoplatek /oznaè - je li 21<20/)          CPOS( 0.5,18.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nPrepNedop)                                                               FPOS( 60,18.8) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(23.                                          Nárok celkem)                      CPOS( 0.5,19.6) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDZN_Zames)                                                               FPOS( 60,19.6) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(24. Daòové zvýhodnìní         z toho sleva na dani)                             CPOS( 0.5,20.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDZS_Celk)                                                                FPOS( 60,20.4) FLEN(10) PP(2) 
    TYPE(TEXT) FCAPTION(25.                                          daòový bonus /ø.23-ø.24/)          CPOS( 0.5,21.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDZB_Zames)                                                               FPOS( 60,21.2) FLEN(10) PP(2) 

    TYPE(TEXT) FCAPTION(26. Zúètování záloh                Daò po slevì /ø.20-ø.24/)                    CPOS( 0.5,22.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nZDS_Dan)                                                                 FPOS( 60,22.0) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(27. na daò po slevì                Rozdíl na dani po slevì /ø.21-ø.26/)         CPOS( 0.5,22.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nZDS_Rozd)                                                                FPOS( 60,22.8) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(28. Zúètování mìsíèních         Vyplacené mìsíèní daòové bonusy od všech plátcù) CPOS( 0.5,23.6) CLEN(58) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nMDB_Celk)                                                                FPOS( 60,23.6) FLEN(10) PP(2) GROUPS(MDB) PUSH(mzd_vyucDane_plat)

    TYPE(TEXT) FCAPTION(29. daòových bonusù             Rozdíl na daòovém bonusu /ø.25-ø.28/)           CPOS( 0.5,24.4) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nMDB_Rozd)                                                                FPOS( 60,24.4) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(30. Kompenzace vzniklých rozdílù na daòi a na bonusu /ø.27+ø.29/)               CPOS( 0.5,25.2) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nKVR_DanBo)                                                               FPOS( 60,25.2) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(31. Doplatek ze zúètování      a/ -pøeplatek na dani po slevì)                  CPOS( 0.5,26.0) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDoplZu31a)                                                               FPOS( 60,26.0) FLEN(10) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(.   /z ø.30/ èiní                         b/ -doplatek na daòovém bonusu)       CPOS( 0.5,26.8) CLEN(55) GROUPS(SETFONT, 12.Cambria)
     TYPE(GET) NAME(vyucdanew->nDoplZu31b)                                                               FPOS( 60,26.8) FLEN(10) PP(2) FONT(5)

*  TYPE(Static) CTYPE(2) SIZE(109,4.5) FPOS(0.4,9.8) RESIZE(y)
 
*  TYPE(End)

TYPE(End)