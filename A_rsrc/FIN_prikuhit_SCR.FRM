TYPE(drgForm) DTYPE(10) TITLE( Pøehled pøíkazù k úhradì dle položek...) SIZE(100,25)                           ;
                                                             CARGO(FIN_PRIKUHHD_IN)                 ; 
                                                             PRINTFILES(prikuhit:ndoklad=ndoklad) 


*   TYPE(Action) CAPTION(~Odeslat ABO)    EVENT(prikuhhd_abo)       TIPTEXT(Automatické odeslání pøíkazu)
*   TYPE(Action) CAPTION(~Odeslat pøíkaz) EVENT(prikuhhd_abo_new)   TIPTEXT(Automatické odeslání pøíkazu)

*   TYPE(Action) CAPTION(~Test)           EVENT(prikuhhd_in_pzo)    TIPTEXT(Test - PZO)


   TYPE(DBrowse) FPOS(.2,.2) SIZE(99.6,24.1) FILE(PRIKUHIT);
                                               FIELDS( FIN_PRIKUHHD_BC(21)::2.6::2                   , ;
                                                       nDOKLAD:èísloPøíkazu                          , ;
                                                       dUHRBANDNE:datÚhrady                          , ;
                                                       nCISFAK:èíslo Faktury                         , ;
                                                       cVARSYM:varSymbol                             , ; 
                                                       cUCET:èíslo Úètu                              , ;
                                                       cTextPol:text položky (dodavatel-odbìratel):26, ;
                                                       nPRIUHRCEL:èástka Úhrady                        ) ;
                                               CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yn) INDEXORD(5)



*   TYPE(DBrowse) FPOS(.2,.2) SIZE(99.6,12.1) FILE(PRIKUHHD)                       ;
*                                             FIELDS( FIN_PRIKUHHD_BC(1):a:2.6::2, ;
*                                                     FIN_PRIKUHHD_BC(2):t:2.6::2, ;
*                                                     FIN_PRIKUHHD_BC(3):u:2.6::2, ;
*                                                     nDOKLAD:èísloPøíkazu       , ;    
*                                                     dPORIZPRI:datVyst          , ;
*                                                     cBANK_UCT:bankovní úèet:20 , ;
*                                                     cBANK_NAZ:název banky:20   , ;
*                                                     czkratMeny:mìna            , ;
*                                                     dPRIKUHR:datÚhrady         , ;
*                                                     nCENZAKCEL:celkem Úhrada   , ;
*                                                     czkratMenU:mìna              ) ; 
*                                            CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemMarked) ATSTART(LAST) POPUPMENU(y) 
