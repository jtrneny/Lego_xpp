TYPE(drgForm) DTYPE(10) TITLE(Zapuštìní zakázky) SIZE(100, 25);
               GUILOOK(Action:y,Message:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(info ~Zakázky)   EVENT(VYR_VyrZAK_info)   TIPTEXT( Informaèní karta zapouštìné zakázky)
TYPE(Action) CAPTION(Ko~ntr.na Ceník) EVENT(VYR_CENZBOZ_EXIST) TIPTEXT(Kontrola na existenci materiálù v ceníku)
TYPE(Action) CAPTION(~Zapustit)       EVENT(ZAK_zapustit)      TIPTEXT( Spustí zapouštìní zakázky)

* VÝROBNÍ ZAKÁZKA
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS( 2, 0.1) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZAKIT->cCisZakaz)   CPOS( 2, 1.3) CLEN( 40) BGND(13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Název zakázky)      CPOS(44, 0.1) CLEN( 15) FONT(2)
    TYPE(Text) NAME(VyrZAKIT->cNazevZak1)  CPOS(44, 1.3) CLEN( 50) BGND(13) FONT(5) PP(2)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

*
  TYPE(Static) STYPE(12) SIZE(99, 1.4) FPOS(0.5, 3) RESIZE(yn)
   TYPE(Text) CAPTION( PARAMETRY zapuštìní)  CPOS( 0.5, 0.1) CLEN( 20) FONT(2)
  TYPE(End)

  TYPE(Static) STYPE(12) SIZE(99,8) FPOS(0.5, 4.4) RESIZE(yn) CTYPE(2)
*
    TYPE(GET)   NAME(M->nMnZapus)  FPOS( 2, 2) FLEN( 12) FCAPTION(Mn. k zapuštìní) CPOS( 2,1) PP(2) PICTURE(@N 999 999.99)
*
    TYPE(Static) STYPE( 2) SIZE(20,3) FPOS( 20, 1) CAPTION(Kontrolní rozpady) RESIZE(xx)
      TYPE(CHECKBOX) NAME( M->lRozpadK)       FPOS( 1, 1)   FLEN(17) ;
         VALUES(T:konstrukèní rozpad,F:konstrukèní rozpad)
      TYPE(CHECKBOX) NAME( M->lRozpadT)       FPOS( 1, 2)   FLEN(17) ;
         VALUES(T:technologický rozpad,F:technologický rozpad)
    TYPE(END)
*
    TYPE(Static) FPOS(42,1) SIZE(23,4) STYPE(2) CAPTION(Zpùsob zapuštìní) RESIZE(xx)
      TYPE(RadioButton) NAME( M->nZpusobZAP) FPOS(1,1) SIZE(20,4) ;
        VALUES( 1:pouze materiál      ,;
                2:pouze mzdové lístky ,;
                3:materiál i mzdové lístky),;
        COMBOINIT( ComboBoxInit)
    TYPE(END)
*
    TYPE(Static) FPOS(67,1) SIZE(25,6) STYPE(2) CAPTION(Typ zapuštìní) RESIZE(xx)
      TYPE(RadioButton) NAME( M->nTypZAP) FPOS(1,1) SIZE(22,5) ;
        VALUES( 1:kompletní           ,;
                2:dílèí               ,;
                3:rozpad po položkách ,;
                4:rozpad po skupinách ,;
                5:rozpad dle dílen a pracoviš)
    TYPE(END)

  TYPE(END)

  TYPE(Static) STYPE(12) SIZE(99, 1.4) FPOS(0.5,12.5) RESIZE(yn)
   TYPE(Text) CAPTION( PRÙBÌH zapuštìní)   CPOS( 0.5, 0.1) CLEN( 20) FONT(2)
  TYPE(End)
  TYPE(Static) STYPE(12) SIZE(99,4) FPOS(0.5, 13.9) RESIZE(yn) CTYPE(2)
   TYPE(Text) NAME(M->INFO_zapus)    CPOS(10, 1) CLEN( 80) BGND(13) FONT(5) PP(2) CTYPE(3)
  TYPE(END)

*
  TYPE(Static) STYPE(12) SIZE(99, 1.4) FPOS(0.5,18) RESIZE(yn)
   TYPE(Text) CAPTION( VÝSLEDEK zapuštìní)   CPOS( 0.5, 0.1) CLEN( 20) FONT(2)
  TYPE(End)
  TYPE(Static) STYPE(12) SIZE(99,4) FPOS(0.5, 19.4) RESIZE(yn) CTYPE(2)
   TYPE(Text) CAPTION( Poèet materiál. požadavkù) CPOS(  2, 1) CLEN( 20)
   TYPE(Text) NAME( M->nOBJ)                      CPOS( 24, 1) CLEN(  7) BGND(13) FONT(5) PP(2) CTYPE(2) PICTURE(@N 99 999)
   TYPE(Text) CAPTION( Poèet mzdových lístkù)     CPOS(  2, 2) CLEN( 20)
   TYPE(Text) NAME( M->nMZD)                      CPOS( 24, 2) CLEN(  7) BGND(13) FONT(5) PP(2) CTYPE(2) PICTURE(@N 99 999)
   TYPE(Text) CAPTION( Konstrukèní rozpad)        CPOS( 35, 1) CLEN( 20)
   TYPE(Text) NAME(M->cRozpadK)                   CPOS( 56, 1) CLEN( 15) BGND(13) FONT(5) PP(2)
   TYPE(Text) CAPTION( Technologický rozpad)      CPOS( 35, 2) CLEN( 20)
   TYPE(Text) NAME(M->cRozpadT)                   CPOS( 56, 2) CLEN( 15) BGND(13) FONT(5) PP(2)

  TYPE(END)