TYPE(drgForm) DTYPE(10) TITLE(Pøehled zmìn DIM v evidenci ...) SIZE(110,25) OBDOBI(DIM) GUILOOK(MESSAGE:Y)

TYPE(Action) CAPTION(~pohyb DIm) EVENT(Cards_ZMENYDIM) TIPTEXT(Pøevod/Vyøazení/Výdej)

* Browser definition
  TYPE(DBrowse) SIZE(110,14) FILE(MSDIM)   ;
                FIELDS(POCkusDIM()::1::2 , ;
                cKLICskMIS               , ;
                cKLICodMIS               , ;
                nINVcisDIM               , ;
                cNAZEVdim::40            , ;
                dDATzarDIM::10           , ;
                nPOCkusDIM:::::1         , ;
                nCENcelDIM:::::1           ) ;
                ITEMMARKED(itemMarked) SCROLL(ny) CURSORMODE(3) PP(7) POPUPMENU(y) FOOTER(yy) 

  TYPE(DBrowse) FPOS(0,14) SIZE(110,9) FILE(ZMENYDIM)              ; 
                            FIELDS(ncisZMdim:doklad              , ;
                                   cobdobi:obdZm                 , ;                                   
                                   cpopZMdim:názZmìny            , ;
                                   cbroPOLdim:název položky zmìny, ;
                                   coldVal:pùvodní hodnota       , ;
                                   cnewVal:nová hodnota            ) ;
                CURSORMODE(3) INDEXORD(4) PP(7)


* DLE POHYBÚ -1-
*  TYPE(TabPage) TTYPE(3) CAPTION(~Pohyby)   OFFSET( 1,82) FPOS(0,14.2) SIZE(100,10.5)
*    TYPE(DBrowse) SIZE(100,9) FILE(ZMENYDIM) ; 
*                              FIELDS(nciszmDim:èísZmìny            , ;          
*                                     cpopzmDim:názZmìny            , ;
*                                     cbropolDim:název položky zmìny, ;
*                                     coldVal:pùvodní hodnota       , ;
*                                     cnewVal:nová hodnota            ) ;
*                  CURSORMODE(3) INDEXORD(4) PP(7)
*  TYPE(End)

* DLE ZMÌN  -2-
*  TYPE(TabPage) TTYPE(3) CAPTION(~Vyøazení) OFFSET(16,68) FPOS(0,14.2) SIZE(100,10.5)
*    TYPE(DBrowse) SIZE(100,9) FILE(ZMENYDIM) ;
*                              FIELDS(nciszmDim:èísZmìny            , ;
*                                     cpopzmDim:názZmìny            , ;
*                                     cbropolDim:název položky zmìny, ;
*                                     coldVal:pùvodní hodnota       , ;
*                                     cnewVal:nová hodnota            ) ;
*                  CURSORMODE(3) INDEXORD(4) PP(7)
*  TYPE(End)

  TYPE(TabPage) TTYPE(3) FPOS(0,23.2) SIZE(110,1.2) CAPTION(Pohyby)    OFFSET( 1,87) PRE(tabSelect) SUB(A)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(3) FPOS(0,23.2) SIZE(110,1.2) CAPTION(Zaøazení)  OFFSET(13,75) PRE(tabSelect) SUB(B)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(3) FPOS(0,23.2) SIZE(110,1.2) CAPTION(Oprava)    OFFSET(25,63) PRE(tabSelect) SUB(C)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(3) FPOS(0,23.2) SIZE(110,1.2) CAPTION(Pøevod)    OFFSET(37,51) PRE(tabSelect) SUB(D)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(3) FPOS(0,23.2) SIZE(110,1.2) CAPTION(Vyøazení)  OFFSET(49,38) PRE(tabSelect) SUB(E)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

