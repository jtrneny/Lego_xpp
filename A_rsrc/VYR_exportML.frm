TYPE(drgForm) DTYPE(10) TITLE(Export mzdov�ch l�stk� ... );
              SIZE( 80, 7) GUILOOK(Action:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(~Spustit export)  EVENT( ExportML_Start) TIPTEXT(Spust� export mzdov�ch l�stk�)
TYPE(Action) CAPTION(~Zru�it export)   EVENT( ExportML_Del)   TIPTEXT(Zru�� export mzdov�ch l�stk�)
TYPE(Action) CAPTION(~Nastavit exp.)   EVENT( ExportML_Ucto ) TIPTEXT(Nastaven� exportu mzdov�ch l�stk� do ��etnictv�)

  TYPE(Text)  NAME(M->cExportML) CPOS(  1, 1.3)   CLEN( 15) FONT(5)
*
  TYPE(TEXT)  CAPTION(Za obdob�)      CPOS( 20, 1.3) CLEN( 15)
  TYPE(TEXT)  CAPTION(Za st�edisko)   CPOS( 20, 2.3) CLEN( 15)
  TYPE(TEXT)  CAPTION(Pr�b�h exportu) CPOS(  1,   5) CLEN( 15)
  TYPE(GET)   NAME( M->cExpObd)       FPOS( 35, 1.3) FLEN( 10) PUSH( VYR_UCETSYS_SEL) POST( PostLastField)
  TYPE(GET)   NAME( M->cExpStr)       FPOS( 35, 2.3) FLEN( 10) PUSH( VYR_Stred_SEL  )
  TYPE(TEXT)  NAME( M->cExpNazStr)    CPOS( 47, 2.3) CLEN( 30) BGND( 13)
*
  TYPE(TEXT)  NAME( M->Info_export)   CPOS( 20,   5) CLEN( 58) BGND( 13) FONT(5) CTYPE(3)