TYPE(drgForm) SIZE(68,6) DTYPE(10) TITLE(Export faktur vystaven�ch za obdob� ...) ;
                                    POST(postValidate) ; 
                                    GUILOOK(Action:y)

TYPE(Action) CAPTION(~Export)     EVENT( expfakt)          TIPTEXT(Export faktur vystaven�ch)
             
*
** INPUT definition
  TYPE(Static) STYPE(13) SIZE(67, 5.5) FPOS(0.5,0.5) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Obdob�)          CPOS( 1, .8) CLEN( 8) FONT(5)
    TYPE(GET)  NAME(M->obdobi)              FPOS(14,.8) FLEN( 6) PICTURE(@N 99/99)

    TYPE(TEXT) CAPTION(V�st.soubor)     CPOS( 1,2) CLEN(12) FONT(5)    
    TYPE(GET)  NAME(M->fileexp)           FPOS(14,2) FLEN( 50) PUSH(dir)

  TYPE(End)






