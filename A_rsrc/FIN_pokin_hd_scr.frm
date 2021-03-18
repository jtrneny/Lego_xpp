TYPE(drgForm) DTYPE(10) TITLE( Inventury pokladen ...) SIZE(110,21) ;
                                                       CARGO(FIN_POKIN_HD_IN) OBDOBI(FIN)  


  TYPE(Action) CAPTION(~Bankovky)  EVENT(FIN_c_meny_mince) TIPTEXT(Bakovky a mince dané mìny ...)


* BROWSER DEFINITION
  TYPE(Static) STYPE(13) SIZE(55,24.8) FPOS( .1, .1) RESIZE(xy) CTYPE(2) GROUPS(SKL_PRE)
    TYPE(DBrowse) FPOS(-.2,.1) SIZE(54.8,16) FILE(POKIN_HD)                       ;
                                             FIELDS(NPOKLADNA:pokladna          , ; 
                                                    ncnt_inv:inv                , ;                                                  
                                                    ddat_inv:dat_inv:10         , ;
                                                    ccas_inv:èas_inv:8          , ;                                                  
                                                    naktStav:stavPokl           , ;
                                                    czkratMeny:zkrMìny:4          )  ;
                                             INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(xy) SCROLL(ny) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)

    
     TYPE(Static) STYPE(8) SIZE(54.5,3.8) FPOS( .3, 16.5) RESIZE(xy)  GROUPS(SKL_PRE)
       TYPE(TEXT) NAME(M->nazPokl) CPOS(.3,.1) CLEN(54) FONT(5) PP(3) BGND(12) CTYPE(1)

       TYPE(TEXT) CAPTION(pøedal  >)           CPOS( 1.5, 1.5) 
       TYPE(TEXT) NAME(pokin_hd->cjmenoPred)   CPOS(20  , 1.5)

       TYPE(TEXT) CAPTION(pøevzal >)           CPOS( 1.5, 2.5) 
       TYPE(TEXT) NAME(pokin_hd->cjmenoPrev)   CPOS(20  , 2.5)
     TYPE(END)
  TYPE(END)


  TYPE(Static) STYPE(13) SIZE(55,24.8) FPOS( 55, .1) RESIZE(yn) CTYPE(2) GROUPS(SKL_PRE)
    TYPE(DBrowse) FPOS(-.2,.1) SIZE(54.8,16) FILE(POKIN_IT)                    ;   
                                             FIELDS(nhodMince:mince:6        , ;
                                                    cnazMince:název mince:22 , ; 
                                                    npoc_mince:poèet         , ;
                                                    ncel_mince:celMince      , ; 
                                                    czkrMince:zkr              ) ;
                                             CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yn) 

     TYPE(Static) STYPE(8) SIZE(54.5,3.8) FPOS( .3, 16.5) CTYPE(1) RESIZE(xy) GROUPS(SKL_PRE)
       TYPE(TEXT) NAME(pokin_it->cnazMince)   CPOS(20  ,1.2) FONT(9) SIZE(600,30)

     TYPE(END)
  TYPE(END)



