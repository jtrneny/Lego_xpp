TYPE(drgForm) DTYPE(10) TITLE(Dopravní prostøedky - nákladní doprava ...) FILE(STROJE) ;
              CARGO()                                                                  ;
              POST(postValidate)                                                       ;
              SIZE(115,20) GUILOOK(Action:n,IconBar:y)


  TYPE(EBROWSE) SIZE(115,19.5) FILE(STROJE)                                                      ;
                               ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(9) SCROLL(yy) ;
                               POPUPMENU(y)                                                      ;
                               LFREEZE(1)                                                        ;
                               GUILOOK(ins:y,del:n) 

      TYPE(GET)  NAME(stroje->nTypStroje)      FLEN( 3) FCAPTION(TypStroje )
      TYPE(GET)  NAME(stroje->nStroj)          FLEN( 8) FCAPTION(Èíslo     )
      TYPE(GET)  NAME(stroje->cStroj)          FLEN(15) FCAPTION(Oznaèení  )
      TYPE(GET)  NAME(stroje->cNazStroj)       FLEN(25) FCAPTION(Název     )
      TYPE(GET)  NAME(stroje->ncisFirmy)       FLEN( 7) FCAPTION(Firma     ) PUSH(fir_firmy_sp_sel)     
      TYPE(GET)  NAME(stroje->cSpzStroj)       FLEN(25) FCAPTION(SPZ       )
      TYPE(GET)  NAME(stroje->cZnStroje)       FLEN(25) FCAPTION(Znaèka    )

  TYPE(END)



* info 114,9.7  .5,15.5
*  TYPE(Static) CTYPE(2) SIZE(114,6) FPOS(.5,19.5) RESIZE(y)

* 4 - X. øádek
*    TYPE(TEXT) CAPTION(plán)                  CPOS( 77,  .2) CLEN( 10)  
*    TYPE(TEXT) CAPTION(skuteènost)            CPOS( 93,  .2) CLEN( 10)  

*    TYPE(Text) CAPTION( Obchodní úsek)        CPOS(  1, 1.2) CLEN( 15) 
*      TYPE(GET)      NAME(cJmeOsOdp)          FPOS( 17, 1.2) FLEN( 25) PUSH(osb_osoby_sel)
*      TYPE(GET)      NAME(DZAPIS)             FPOS( 45, 1.2) FLEN( 13) PUSH(CLICKDATE)
*      TYPE(GET)      NAME(DODVEDZAKA)         FPOS( 61, 1.2) FLEN( 13) PUSH(CLICKDATE)
*      TYPE(GET)      NAME(DMOZODVZAK)         FPOS( 77, 1.2) FLEN( 13) PUSH(CLICKDATE)
*      TYPE(GET)      NAME(DSKUODVZAK)         FPOS( 93, 1.2) FLEN( 13) PUSH(CLICKDATE) 


    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)




