TYPE(drgForm) DTYPE(10) TITLE(Nevykryté objednávky dle oblastí ...) SIZE(84,16) ;
              FILE(c_oblastW)                                                   ;
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n)            ;  
              BORDER(2) PRE(preValidate) POST(postValidate)

  TYPE(STATIC) STYPE(2) FPOS(1,-0.25) SIZE(82.05,1.25) RESIZE(yn)
    TYPE(TEXT) CAPTION(Datum dodání zboží OD : )  CPOS(  7, .5) CLEN(18)  FONT(1) 
    TYPE(GET) NAME(M->ddatDO_od)                  FPOS( 26, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION( __ do __ )                CPOS( 41, .5) CLEN( 7)  FONT(1) 
    TYPE(GET) NAME(M->ddatDO_do)                  FPOS( 51, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE) 
  TYPE(END)


 TYPE(DBrowse) FPOS( 0, 1.75) SIZE(83,12.5) FILE( c_oblastW )   ;
                             FIELDS( nklicObl:obl:6          , ;
                                     cnazevObl:názevObl:30   , ;
                                     nnevykOdb:nevykrOdb:10  , ; 
                                     nnevykPol:nevykrPol:10  , ;
                                     nnevykMnoz:nevykrMnož:20   ) ;
                             ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                             POPUPMENU(y)                                                      ;
                             GUILOOK(sizecols:n,headmove:n)                                 


  TYPE(STATIC) STYPE(2) FPOS(1,14) SIZE(82.05,1.3) RESIZE(yn)
    TYPE(PushButton) POS( 55, .7) SIZE(13,1.3) CAPTION(~Start ) EVENT( btn_START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 69, .7) SIZE(13,1.3) CAPTION(S~torno) EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)
  TYPE(END)

TYPE(END)



