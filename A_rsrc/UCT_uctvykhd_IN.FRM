TYPE(drgForm) DTYPE(10) TITLE(Úèetní výkazy - pøehled) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(UCT)                      ;
              PRINTFILES(uctvykhd:,                                                ;
                         uctvykit:)                                              

*              PRINTFILES(uctvykhd:,                                                ;
*                         uctvykit:nuctvykhd=sid)                                              


TYPE(Action) CAPTION(~aktVýkazu ) EVENT(aktVykazu)   TIPTEXT(Aktualizace úèetního výkazu )
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)

*  TYPE(TEXT) CAPTION(Upøesòující  nabídka : ) CPOS(13,0.4) CLEN(25) CTYPE(3) FONT(2)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
*                VALUES(a,a,a,a,a,a,a,a,a);
*                COMBOINIT(comboBoxInit);
*                ITEMSELECTED(comboItemSelected)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
*                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
*                ITEMSELECTED(comboItemSelected)
TYPE(END)


TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Rozvaha) OFFSET( 1,82) PRE(tabSelect) TABHEIGHT(1.1) PRE(tabSelect)

  TYPE(EBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

      TYPE(TEXT) NAME(uctvykhd->nrok )            FLEN( 6) FCAPTION(rok        )
      TYPE(TEXT) NAME(uctvykhd->cobdobi )         FLEN( 8) FCAPTION(období     )
      TYPE(TEXT) NAME(uctvykhd->cTypUctVyk )      FLEN( 8) FCAPTION(úè_výk     )
      TYPE(TEXT) NAME(uctvykhd->cTypVykazu )      FLEN(12) FCAPTION(typ_výk    )
      TYPE(TEXT) NAME(uctvykhd->cNazVykazu )      FLEN(35) FCAPTION(název_výk  )
      TYPE(TEXT) NAME(uctvykhd->cIDvykazu )       FLEN(11) FCAPTION(id_výk     )

      TYPE(GET)  NAME(uctvykhd->dDatZprac )       FLEN(11) FCAPTION(dat_zprac  )

  TYPE(END)


*      TYPE(GET)  NAME(stojany->nstojan)        FLEN( 5) FCAPTION(stojan       ) NOREVISION()
*      TYPE(GET)  NAME(stojany->csklPol)        FLEN(15) FCAPTION(sklPoložka   ) PUSH(skl_cenzboz_sel)
 
    

  TYPE(EBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             CURSORMODE(3) PP(7) 

      TYPE(TEXT) NAME(uctvykit->cOznRadVyk )      FLEN( 8) FCAPTION(ozn_øád    )
      TYPE(TEXT) NAME(uctvykit->cTextRadek )      FLEN(35) FCAPTION(název_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadUctVyk )      FLEN( 5) FCAPTION(èís_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadekVyk  )      FLEN( 3) FCAPTION(è_ø_tm )

      TYPE(GET)  NAME(uctvykit->nSloupec01 )      FLEN(14) FCAPTION(brutto     )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec02 )      FLEN(14) FCAPTION(korekce    )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec03 )      FLEN(14) FCAPTION(netto      )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec04 )      FLEN(14) FCAPTION(bruttomin  )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec05 )      FLEN(14) FCAPTION(korekcemin )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec06 )      FLEN(14) FCAPTION(nettomin   )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup01 )      FLEN( 8) FCAPTION(zabrutto   )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup02 )      FLEN( 8) FCAPTION(zakorekce  )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup03 )      FLEN( 8) FCAPTION(zanetto    )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup04 )      FLEN( 8) FCAPTION(zabruttomin ) PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup05 )      FLEN( 8) FCAPTION(zakorekcemin ) PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nZaSloup06 )      FLEN( 8) FCAPTION(zanettomin   ) PICTURE(9999999999)

  TYPE(END)

TYPE(END) 


TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Výk.ziskù a ztrát)    OFFSET(17,66) PRE(tabSelect) TABHEIGHT(1.1)  PRE(tabSelect)

  TYPE(EBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

*      TYPE(STATIC) STYPE(5) NAME(M->aktStav )                FLEN( 3) FCAPTION(stav       )
      TYPE(TEXT) NAME(uctvykhd->nrok )            FLEN( 6) FCAPTION(rok        )
      TYPE(TEXT) NAME(uctvykhd->cobdobi )         FLEN( 8) FCAPTION(období     )
      TYPE(TEXT) NAME(uctvykhd->cTypUctVyk )      FLEN( 8) FCAPTION(úè_výk     )
      TYPE(TEXT) NAME(uctvykhd->cTypVykazu )      FLEN(12) FCAPTION(typ_výk    )
      TYPE(TEXT) NAME(uctvykhd->cNazVykazu )      FLEN(35) FCAPTION(název_výk  )
      TYPE(TEXT) NAME(uctvykhd->cIDvykazu )       FLEN(11) FCAPTION(id_výk     )

      TYPE(GET)  NAME(uctvykhd->dDatZprac )       FLEN(11) FCAPTION(dat_zprac  )

  TYPE(END) 

  TYPE(EBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             CURSORMODE(3) PP(7) 

      TYPE(TEXT) NAME(uctvykit->cOznRadVyk )      FLEN( 8) FCAPTION(ozn_øád    )
      TYPE(TEXT) NAME(uctvykit->cTextRadek )      FLEN(35) FCAPTION(název_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadUctVyk )      FLEN( 5) FCAPTION(èís_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadekVyk  )      FLEN( 3) FCAPTION(è_ø_tm )

      TYPE(GET)  NAME(uctvykit->nSloupec01 )      FLEN(14) FCAPTION(bìžné_období  )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec02 )      FLEN(14) FCAPTION(minulé_období )  PICTURE(9999999999)

  TYPE(END)

TYPE(END) 



TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Cash flow)    OFFSET(33,49) PRE(tabSelect) TABHEIGHT(1.1)  PRE(tabSelect)
  TYPE(EBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
*      TYPE(STATIC) STYPE(5) NAME(M->aktStav )                FLEN( 3) FCAPTION(stav       )
      TYPE(TEXT) NAME(uctvykhd->nrok )            FLEN( 6) FCAPTION(rok        )
      TYPE(TEXT) NAME(uctvykhd->cobdobi )         FLEN( 8) FCAPTION(období     )
      TYPE(TEXT) NAME(uctvykhd->cTypUctVyk )      FLEN( 8) FCAPTION(úè_výk     )
      TYPE(TEXT) NAME(uctvykhd->cTypVykazu )      FLEN(12) FCAPTION(typ_výk    )
      TYPE(TEXT) NAME(uctvykhd->cNazVykazu )      FLEN(35) FCAPTION(název_výk  )
      TYPE(TEXT) NAME(uctvykhd->cIDvykazu )       FLEN(11) FCAPTION(id_výk     )

      TYPE(GET)  NAME(uctvykhd->dDatZprac )       FLEN(11) FCAPTION(dat_zprac  )

  TYPE(END) 

  TYPE(EBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             CURSORMODE(3) PP(7) 
      TYPE(TEXT) NAME(uctvykit->cOznRadVyk )      FLEN( 8) FCAPTION(ozn_øád    )
      TYPE(TEXT) NAME(uctvykit->cTextRadek )      FLEN(35) FCAPTION(název_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadUctVyk )      FLEN( 5) FCAPTION(èís_øád  )
      TYPE(TEXT) NAME(uctvykit->nRadekVyk  )      FLEN( 3) FCAPTION(è_ø_tm )

      TYPE(GET)  NAME(uctvykit->nSloupec01 )      FLEN(14) FCAPTION(bìžné_období  )  PICTURE(9999999999)
      TYPE(GET)  NAME(uctvykit->nSloupec02 )      FLEN(14) FCAPTION(minulé_období )  PICTURE(9999999999)

  TYPE(END)

TYPE(END) 

