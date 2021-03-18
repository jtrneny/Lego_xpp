TYPE(drgForm) DTYPE(10) TITLE(Zaúètování mezd) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD)


TYPE(Action) CAPTION(~Likvidace mezd) EVENT(mzd_zauctmz_obd) TIPTEXT(Hromané zaúètování mezd za období)
*TYPE(Action) ATYPE(5)
*TYPE(Action) CAPTION(~Naètení dat) EVENT(ImportUctOld)       TIPTEXT(Naètení zaúètování mezd za období)

* TYPE(Action) ATYPE(5)
* TYPE(Action) ATYPE(5)
* TYPE(Action) CAPTION(~test Sumace) EVENT(ucetPol_suma)       TIPTEXT(test pro rozíly soc-zdr)




* TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)
*   TYPE(TEXT) CAPTION(Upøesòující  nabídka : ) CPOS(13,0.10) CLEN(25) FONT(2)
*   TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.10) FLEN(20);
*                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
*                  ITEMSELECTED(comboItemSelected)
* TYPE(END)

TYPE(DBrowse) FPOS( .5,.2) SIZE(98.75,24.15) FILE(UCETPOL)   ;
              FIELDS(NDOKLAD:doklad       , ;
                     COBDOBI:OBD_úè       , ;
                     CTEXT:Text dokladu:40, ;
                     CUCETMD:SuAu_Ø       , ;
                     NKCMD                , ;
                     NKCDAL               , ;
                     CUCETDAL:SuAu_S        ) ;
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(y)



   
