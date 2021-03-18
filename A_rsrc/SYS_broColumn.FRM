TYPE(drgForm) DTYPE(10) TITLE(Uživatelské nastavení sloucù pohledu ...) SIZE(110,18) FILE(s_Fieldsw) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n)                 ; 
              BORDER(2) POST(postValidate)


* LEFT - s_Fieldsw - nastavené položky BRO uživatelem
*******
    TYPE(DBrowse) FPOS(0,2.3 ) SIZE(48,16) FILE(s_Fieldsw)     ;
                  FIELDS( M->c_operand::2.6::2               , ;
                          cvyraz_1u:Uživatelský název pole:30, ; 
                          M->c_fields:promìnná:11            ) ; 
                  CURSORMODE(3) PP(9) ITEMMARKED(ItemMarked) POPUPMENU(nn) SCROLL(ny)


* RIGHT - d_Fieldsw - seznam položek z DBD po nastavení uživatelem
******
    TYPE(Static)  FPOS(60,0.1) SIZE(48,1.3) RESIZE(y) CTYPE(2)
      TYPE(TEXT)     CAPTION(Seznam položek k nastavení pohledu) CPOS( 1,.5) CLEN(46) FONT(7) CTYPE(1)
    TYPE(End) 

    TYPE(DBrowse) FPOS(59,2.3) SIZE(49,16) FILE(d_Fieldsw)       ;
                  FIELDS( cvyraz_u:Uživatelský název pole:34, ; 
                          cfield:promìnná:11                  ) ;
                  CURSORMODE(3) PP(9) ITEMMARKED(ItemMarked) POPUPMENU(nn) SCROLL(ny)

*****
     TYPE(Static) FPOS(1,0.1) SIZE(47,1.3)  RESIZE(y) CTYPE(2)
       TYPE(TEXT)     CAPTION(Položky pohledu -->) CPOS( 1,.5) CLEN(15)
       TYPE(ComboBox) NAME(M->sel_dbrowse) FPOS(16,.6) FLEN(30) ;
                      VALUES(a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)  
     TYPE(End) 

     TYPE(PushButton) POS(49, 9) SIZE(10,1) CAPTION(<<) EVENT(addTo_s_Fieldsw)   ICON1(107) ATYPE(3)  
     TYPE(PushButton) POS(49,11) SIZE(10,1) CAPTION(>>) EVENT(delFrom_s_Fieldsw) ICON1(110) ATYPE(33)

TYPE(END)




