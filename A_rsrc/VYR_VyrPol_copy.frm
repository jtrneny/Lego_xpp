TYPE(drgForm) DTYPE(10) TITLE( Kop�rov�n� kusovn�ku a operac�);
              SIZE( 95, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

*TYPE(Action) CAPTION( ~spustit kop�rov�n�)  EVENT() TIPTEXT(Informa�n� karta v�robn� zak�zky)

  TYPE(Static) STYPE(12) SIZE(94.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)

    TYPE(Text) CAPTION(Zak�zka)              CPOS( 21, 1)   CLEN( 10) FONT(2)
    TYPE(Text) CAPTION(Vyr�b�n� polo�ka)     CPOS( 58, 1)   CLEN( 20) FONT(2)
    TYPE(Text) CAPTION(Varianta)             CPOS( 82, 1)   CLEN(  8) FONT(2)
    TYPE(Text) CAPTION(Zdrojov� polo�ka :)   CPOS(  2, 2)   CLEN( 17) FONT(2)
    TYPE(Text) CAPTION(C�lov� polo�ka     :) CPOS(  2, 3.2) CLEN( 17) FONT(2)

    TYPE(Text) NAME(m->zdrojZak)             CPOS( 21, 2) CLEN( 36) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(m->zdrojPol)             CPOS( 58, 2) CLEN( 21) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(GET)  NAME(m->zdrojPol)             FPOS( 58, 2) FLEN( 21) BGND( 13) FONT(5) GROUPS(clrGREY) PUSH(VYR_VYRPOL_SEL)
    TYPE(Text) NAME(m->zdrojVar)             CPOS( 82, 2) CLEN(  7) BGND( 13) FONT(5) GROUPS(clrGREY)

    TYPE(Text) NAME(m->cilZak)               CPOS( 21, 3.2) CLEN( 36) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(m->cilPol)               CPOS( 58, 3.2) CLEN( 21) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(GET)  NAME(m->cilPol)               FPOS( 58, 3.2) FLEN( 21) BGND( 13) FONT(5) GROUPS(clrGREY) PUSH(VYR_VYRPOL_SEL)
    TYPE(Text) NAME(m->cilVar)               CPOS( 82, 3.2) CLEN(  7) BGND( 13) FONT(5) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Kop�rovat )           CPOS( 19, 5)   CLEN( 10)
    TYPE(CHECKBOX) NAME(M->lKusov)           FPOS( 30, 5)   FLEN( 25) VALUES(T:v�etn� kusovn�ku, F:v�etn� kusovn�ku)
    TYPE(CHECKBOX) NAME(M->lPolOper)         FPOS( 30, 6)   FLEN( 25) VALUES(T:v�etn� operac�, F:v�etn� operac�) +
                                             ItemSelected( CheckItemSelected)


    TYPE(PushButton) POS(60, 6) SIZE(12,1.2) CAPTION(~Kop�rovat) EVENT( But_Copy )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(75, 6) SIZE(12,1.2) CAPTION(~Storno)    EVENT(140000002)          ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)