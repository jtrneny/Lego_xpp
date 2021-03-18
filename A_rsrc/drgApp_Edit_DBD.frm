***************************************************************************
*
*  Copyright:
*       DRGS d.o.o., (c) 2003. All rights reserved.
*
*   Contents:
*          Main DBD editor form.
*
***************************************************************************

TYPE(drgForm) DTYPE(0) TITLE('Edit DBD') SIZE(80,22) FILE(M) POST(postAll) PRE(preAll) BORDER(2)
  TYPE(TreeView) ATYPE(3) FPOS(0,0) SIZE(30,22)HASLINES(Y) HASBUTTONS(Y) POST(postTreeView)

  TYPE(Action) CAPTION(Defaults) EVENT(editDBDHeader) ATYPE(3) ICON1(114) ICON2(214) TIPTEXT(Edit DBD default database definitions)
  TYPE(Action) CAPTION(Import)   EVENT(ImportDBD)     ATYPE(3) ICON1(11)  ICON2(31)  TIPTEXT(Import database description from DBF file)
  TYPE(Action) CAPTION(Generate) EVENT(GenerateForm)  ATYPE(3) ICON1(13)  ICON2(33)  TIPTEXT(Generate default dialog form for file)

  TYPE(TabPage) FPOS(30,0) SIZE(50,22)CAPTION(TAB A) TABHEIGHT(0) OFFSET(0,80) RESIZE(ny)
    TYPE(Get) FPOS(15,1) FLEN(15)  NAME(oFile:Name) CPOS(1,1) FCAPTION(File name)
    TYPE(Get) FPOS(15,2) FLEN(30) NAME(oFile:Desc) CPOS(1,2) FCAPTION(Description) PICTURE(&64X)
*    TYPE(Get) FPOS(15,3) FLEN(8)  NAME(oFile:Alias) CPOS(1,3) FCAPTION(Alias name)
    TYPE(Get) FPOS(15,4) FLEN(15)  NAME(oFile:Like) CPOS(1,4) FCAPTION(Fields like) POST(postLastField)
  TYPE(End)

  TYPE(TabPage) FPOS(30,0) SIZE(50,22)CAPTION(TAB B) TABHEIGHT(0) OFFSET(10,70)  RESIZE(ny)
    TYPE(Get)        FPOS(15, 1) FLEN(10) NAME(oField:Name)       CPOS(1, 1) FCAPTION(Name)
    TYPE(Get)        FPOS(15, 2) FLEN(20) NAME(oField:Ref)        CPOS(1, 2) FCAPTION(From reference)
    TYPE(Get)        FPOS(15, 3) FLEN(30) NAME(oField:Desc)       CPOS(1, 3) FCAPTION(Description)    PICTURE(&64X)
    TYPE(Get)        FPOS(15, 4) FLEN(30) NAME(oField:Caption)    CPOS(1, 4) FCAPTION(Caption)        PICTURE(&64X)
    TYPE(ComboBox)   FPOS(15, 5) FLEN(10) NAME(oField:fType)      CPOS(1, 5) FCAPTION(Type)                         VALUES(getFLDTypes)
    TYPE(SpinButton) FPOS(15, 6) FLEN( 7) NAME(oField:fLen)       CPOS(1, 6) FCAPTION(Length)                       LIMITS(1,65536)
    TYPE(SpinButton) FPOS(15, 7) FLEN( 4) NAME(oField:dec)        CPOS(1, 7) FCAPTION(Decimals)                     LIMITS(0,16)
    TYPE(Get)        FPOS(15, 8) FLEN(30) NAME(oField:picture)    CPOS(1, 8) FCAPTION(Picture)        PICTURE(&64X)
*    TYPE(Get) FPOS(15,9) FLEN(30) NAME(oField:defvalue) CPOS(1,9) FCAPTION(Default value)            PICTURE(&64X)
    TYPE(Get)        FPOS(15,10) FLEN(15) NAME(oField:relateto)   CPOS(1,10) FCAPTION(Related file)
    TYPE(ComboBox)   FPOS(15,11) FLEN(10) NAME(oField:relateType) CPOS(1,11) FCAPTION(Relation)                     REF(DRGFLDREL)

    TYPE(Static) FPOS(1,12) SIZE(47,9) STYPE(2) CAPTION(Values) RESIZE(xx)
*      TYPE(ListBrowse) FIELDS(1:Value:16, 2:Description:32) ;
*       FPOS(1,1) SIZE(45,8) NAME(oField:values) ;
*       SCROLL(ny) PP(2) POST(postLastField) RESIZE(xx)
    TYPE(End)

  TYPE(End)

  TYPE(TabPage) FPOS(30,0) SIZE(50,22)CAPTION(TAB C) TABHEIGHT(0) OFFSET(20,60) RESIZE(ny)
    TYPE(Get) FPOS(15,1) FLEN(15) NAME(oIndex:Name) CPOS(1,1) FCAPTION(Index Name)
    TYPE(Get) FPOS(15,2) FLEN(15) NAME(oIndex:fName) CPOS(1,2) FCAPTION(File name)
    TYPE(Get) FPOS(15,3) FLEN(30) NAME(oIndex:caption) CPOS(1,3) FCAPTION(Caption) PICTURE(&64X)
    TYPE(Get) FPOS(15,4) FLEN(30) NAME(oIndex:data) CPOS(1,4) FCAPTION(INDEX ON) PICTURE(&128X)
    TYPE(Get) FPOS(15,5) FLEN(30) NAME(oIndex:cFor) CPOS(1,5) FCAPTION(FOR) PICTURE(&128X)
    TYPE(Get) FPOS(15,6) FLEN(30) NAME(oIndex:cWhile) CPOS(1,6) FCAPTION(WHILE) PICTURE(&128X)
    TYPE(Get) FPOS(15,7) FLEN(6)  NAME(oIndex:nRecord) CPOS(1,7) FCAPTION(RECORD)
    TYPE(CheckBox) FPOS(15,8) FLEN(10) NAME(oIndex:cDescend) CPOS(1,8) +
      FCAPTION(Descend) VALUES('Y:Yes, :No')
    TYPE(CheckBox) FPOS(15,9) FLEN(10) NAME(oIndex:unique) CPOS(1,9) +
      FCAPTION(Unique) VALUES('Y:Yes, :No')
    TYPE(CheckBox) FPOS(15,10) FLEN(10) NAME(oIndex:dupkeys) CPOS(1,10) +
      FCAPTION(Allow duplicates) VALUES(' :Yes,N:No') POST(postLastField) +
      TIPTEXT(Allow duplicate key values at record updation)
  TYPE(End)

  TYPE(TabPage) FPOS(30,0) SIZE(50,22)CAPTION(TAB D) TABHEIGHT(0) OFFSET(30,50)) RESIZE(ny)
    TYPE(Get) FPOS(15,1) FLEN(4) NAME(oSearch:Order) CPOS(1,1) FCAPTION(Index order)
    TYPE(Get) FPOS(15,2) FLEN(10) NAME(oSearch:Ret) CPOS(1,2) FCAPTION(Returned field) PICTURE(&128X)
    TYPE(Static) FPOS(1,3) SIZE(47,9) STYPE(2) CAPTION(Fields displayed) RESIZE(xx)
**      TYPE(ListBrowse) FIELDS(1:Name:10, 2:Description:16, 3:Len:2, 4:Type:4, 5:Picture:16 ) ;
**       FPOS(1,1) SIZE(45,8) NAME(oSearch:fields) ;
**       SCROLL(yy) PP(2) POST(postLastField) RESIZE(xx)
    TYPE(End)

*    TYPE(Text) CPOS(1,3) CLEN(25) CAPTION(Fields)
*    TYPE(Mle) FPOS(1,4) SIZE(25,7) NAME(oSearch:fields) HSCROLL(N) VSCROLL(N) POST(postLastField) RESIZE(xx)
  TYPE(End)

  TYPE(TabPage) FPOS(30,0) SIZE(50,22)CAPTION(TAB E) TABHEIGHT(0) OFFSET(40,40) RESIZE(ny)
  TYPE(End)

