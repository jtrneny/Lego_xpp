#include "adsdbe.ch"
#include 'common.ch'
#include "dbstruct.ch"

#include "..\A_main\ace.ch"


#define CRLF       Chr(13) + Chr(10)
*
**
# xTRANSLATE .dbd_name       => \[1 \]  //  1_ dbd_name -- tady je UPPER
# xTRANSLATE .add_type       => \[2 \]  //  2_ add_type (N) vazba na ch + columns.Field_Type
# xTRANSLATE .adt_len        => \[3 \]  //  3_ adt_len
# xTRANSLATE .adt_dec        => \[4 \]  //  4_ adt_dec
# xTRANSLATE .adt_type       => \[5 \]  //  5_ dbd_type (C) které mapuje Alaska
# xTRANSLATE .sp_type        => \[6 \]  //  6_ sp_type  (C) pro ALTER / sp_
# xTRANSLATE .dbd_Field_Num  => \[7 \]  //  7_ dbd_Field_Num pozice v DBD
# xTRANSLATE .add_Field_Num  => \[8 \]  //  8_ add_Field_num pozice v ADD
# xTRANSLATE .add_alter      => \[9 \]  //  9_ modifikace 0-OK, 1-ALTER, -1-DELETE
# xTRANSLATE .add_default    => \[10\]  // 10_ add_defalut default value
# xTRANSLATE .org_name       => \[11\]  // 11_ originál názvu položky z DBD
*
**
# xTRANSLATE .adi_fileName   => \[1 \]  //  1_ dbd_cFileName
# xTRANSLATE .adi_tagName    => \[2 \]  //  2_ dbd_cName
# xTRANSLATE .adi_expression => \[3 \]  //  3_ dbd_cIndexKey
# xTRANSLATE .adi_condition  => \[4 \]  //  4_ dbd_cFor
# xTRANSLATE .adi_options    => \[5 \]  //  5_ vazba na ch - Options for creating indexes
# xTRANSLATE .adi_alter      => \[6 \]  //  6_ modifikace 0-OK, 1-NEW, -1-DROP, 2-CREATE



static pa_system := { ;
 { 's_tables' , "select left(Name,20)              as Name,"           + ;
                       "Table_Encryption from system.tables"                }, ;
 { 's_columns', "select left(Name  ,20)            as Name  ,"         + ;
                       "left(Parent,20)            as Parent,"         + ;
                       "Field_Num,"                                    + ;
                       "Field_Length,"                                 + ;
                       "Field_Type,"                                   + ;
                       "Field_decimal    from system.columns"               }, ;
 { 's_indexes', "select left(Name  ,20)           as Name  ,"          + ;
                       "left(Parent,20)           as Parent,"          + ;
                       "left(Index_File_Name ,20) as Index_File_Name," + ;
                       "Index_Expression,"                             + ;
                       "Index_Condition,"                              + ;
                       "Index_Options    from system.indexes"              }  }


static pa_stru  := { { { 'Name'            , 'C' ,  20, 0 }, ;
                       { 'Table_Encryption', 'L' ,   1, 0 }  }, ;
                     { { 'Name'            , 'C' ,  20, 0 }, ;
                       { 'Parent'          , 'C' ,  20, 0 }, ;
                       { 'Field_Num'       , 'I' ,   4, 0 }, ;
                       { 'Field_Type'      , 'I' ,   2, 0 }, ;
                       { 'Field_Length'    , 'I' ,   2, 0 }, ;
                       { 'Field_decimal'   , 'I' ,   4, 0 }  }, ;
                     { { 'Name'            , 'C' ,  20, 0 }, ;
                       { 'Parent'          , 'C' ,  20, 0 }, ;
                       { 'Index_File_Name' , 'C' ,  20, 0 }, ;
                       { 'Index_Expression', 'C' , 510, 0 }, ;
                       { 'Index_Condition' , 'C' , 510, 0 }, ;
                       { 'Index_Options'   , 'I' ,   4, 0 }  }  }

static pa_tags  := { 'upper(name)'                         , ;
                     'upper(parent) +strZero(Field_Num,4)' , ;
                     'upper(parent)'                         }


*  1
** pøeèteme z ADD
** system.tables->s_tables, system.columns->s_columns, system.indexes->s_indexes
function get_system_data( nstart, nend )
  local x, cout_alias
  local cStatement, cwork_Dir  := drgINI:dir_USERfitm +userWorkDir() +'\', cwork_File
  local oStatement
  *
  local hCursor, cAlias, astru

  * pracovní adresáø
  createDir(cwork_Dir)

  * požadavek jen na 1 = tabulky, 2 = field, 3 = indexes
  if( IsNull( nStart ), nStart := 1               , nil)
  if( IsNull( nEnd   ), nEnd   := len( pa_system ), nil )

  for x := nStart to nEnd step 1
*  for x := 1 to len(pa_system) step 1
    cout_alias := pa_system[x,1]
    cStatement := pa_system[x,2]
    *
    cwork_File := cwork_Dir +cout_alias
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
      return .f.
    endif
    oStatement:Execute( pa_system[x,1] )

    cAlias  := oStatement:Alias
    hCursor := oStatement:hCursor

    astru   := pa_stru[x]
    DbCreate ( cwork_File, astru, oSession_free )
    DbUseArea( .t., oSession_free, cwork_File, , .f.)
    (cout_alias)->( Ads_createTmpIndex( cwork_File, cout_alias, pa_tags[x], , , ))

    save_to_file( calias, hCursor, astru, cout_alias )

    oStatement:alias := ''
    oStatement:Close()
  next
return nil


static function save_to_file( cin_alias, hCursor, astru, cout_alias )
  local x, cfield, pa
  *
  local  hObj := (cout_alias)->( DbInfo(ADSDBO_TABLE_HANDLE) )

  do while .not. (cin_alias) ->(eof())
    (cout_alias)->(dbAppend())

    for x := 1 to len(astru) step 1
      cfield := astru[x,DBS_NAME]
      pa := AdsGetField( hCursor, cfield)
      AdsSetField( hObj, cfield, pa[1], pa[2] )
    next

    (cin_alias)->(dbSkip())
  enddo
return nil
**
*


*  2
** kotrola ADD - DBD
function check_dbd_data( oXbp_text )
  local  x
  local  pao_drgFile := drgDBMS:dbd:values, fileName, o_drgFile, isCrypt
  *
  local  aext_data_struct, aext_adi_struct
  local  cStatement, cSQL_statement, pa_indexStatement
  *
  local  oStatement
  *
  local  ctest_Dir  := drgINI:dir_USERfitm +userWorkDir() +'\', nstep := 1
  local  oMLE

  for x := 1 to len(pao_drgFile) step 1
    fileName       := upper(pao_drgFile[x,1])
    o_drgFile      :=       pao_drgFile[x,2]
    isCrypt        := o_drgFile:isCrypt
    *
    cStatement     := ''
    cSQL_statement := ''

    if o_drgFile:lIsCheck .and. fileName <> 'LICASYS'

       if oXbp_text:className() = 'XbpMLE'
         oMLE := oXbp_text

         oMLE:setData( oMLE:getData() +'.' +if( nstep = 100, CRLF, '') )
         if( nstep = 100, nstep := 1, nstep++ )
       endif


*      oXbp_text:configure()
*      setup_work_textinfo(oXbp_text, o_drgFile:description )

      * vybudujeme pomocnou strukruru pro kontrolu/ založení tabulky
      aext_data_struct := create_ext_data_struct(o_drgFile)

      * vybudujeme pomocnou strukturu pro kontrolu/ založení indexù
      aext_adi_struct := create_ext_index_struct(o_drgFile)

      if s_tables->(dbseek( padr(fileName,20)))
        cStatement := alter_table(fileName, aext_data_struct )

      else

        cStatement := create_table(fileName, aext_data_struct, isCrypt )
      endif

      cStatement        += if( .not. empty(cStatement), CRLF, '' )
      paindex_Statement := check_dbd_indexes(fileName, aext_adi_struct )

      *                     DROP INDEX            ALTER/CREATE  sp_CreateIndex
      cSQL_statement     := paindex_Statement[1] +cStatement   +paindex_Statement[2]
*     cSQL_statement     := cStatement
    endif

    *
    ** pokud potøeba modifikovat, hotl to pustíme
    if .not. empty(cSQL_statement)
**      memowrit(ctest_Dir + fileName +'.txt', cSQL_statement)

      oStatement := AdsStatement():New(cSQL_statement,oSession_data)
      if oStatement:LastError > 0
        * mám tam chybu, nìjak se to musí ošetøit
        * buï je chybnì složený výraz pro modifikaci
        * - novì zakládaný soubor již existuje
        * - pøi alternaci tabulky je rušena položka s vazbou na TAG
        * --- asi je toho víc podle ERR

      else
        oStatement:Execute( '', .f. )
        oStatement:alias := ''
        oStatement:Close()

**        drgDump( fileName )
      endif

    endif
  next
return nil


static function create_ext_data_struct(o_drgFile)
  local x, pao, dbd_name, adt_type, adt_len, adt_dec, org_name
  local                               c_len,   c_dec
  local                               c_num
  local adesc := o_drgFile:desc
  *
  local adbd_struct := {}

  for x := 1 to len(adesc) step 1
    pao      := adesc[x]
    dbd_name := upper(pao:name)
    org_name := pao:org_name
    adt_type := pao:adt_type
    adt_len  := pao:adt_len
    adt_dec  := pao:adt_dec
    *
    c_len    := '(' +allTrim( str( adt_len)) +')'
    c_dec    := '(' +allTrim( str( adt_dec)) +')'
    c_num    := '(' +allTrim( str( adt_len)) +',' +allTrim( str( adt_dec)) +')'

    aadd( adbd_struct , ;
        { dbd_name    , ;   //  1_ dbd_name
                      , ;   //  2_ add_type (N) vazba na ch + columns.Field_Type
          adt_len     , ;   //  3_ adt_len
          adt_dec     , ;   //  4_ adt_dec
          adt_type    , ;   //  5_ adt_type (C) které mapuje Alaska
                      , ;   //  6_ sp_type  (C) pro ALTER / sp_
          x           , ;   //  7_ dbd_Field_Num pozice v DBD
                      , ;   //  8_ add_Field_num pozice v ADD
          0           , ;   //  9_ add_alte modifikace 0-OK, 1-ADD, -1-ALTER
                      , ;   // 10_ add_defalut default value
          org_name      } ) // 11_ originál názvu položky z DBD

    pao := atail(adbd_struct)

    do case
    case adt_type = 'C'
     ( pao.add_type := ADS_STRING   , pao.sp_type := 'Char' +c_len  , pao.add_default := "' '" )

    case adt_type = 'D'
     ( pao.add_type := ADS_DATE     , pao.sp_type := 'Date'         , pao.add_default := "' '" )

    case adt_type = 'L'
     ( pao.add_type := ADS_LOGICAL  , pao.sp_type := 'Logical'      , pao.add_default := "'NO'")

    case adt_type = 'M'
     ( pao.add_type := ADS_MEMO     , pao.sp_type := 'Memo'         )

    case adt_type = 'F'
     ( pao.add_type := ADS_DOUBLE   , pao.sp_type := 'Double' +c_dec, pao.add_default := "'0'" )

    case adt_type = 'I'
      if adt_len = 4  ;   ( pao.add_type := ADS_INTEGER  , pao.sp_type := 'Integer'   )
      else            ;   ( pao.add_type := ADS_SHORTINT , pao.sp_type := 'Short'     )
      endif
      pao.add_default := "'0'"

    case adt_type = 'N'
     ( pao.add_type := ADS_NUMERIC  , pao.sp_type := 'Numeric' +c_num, pao.add_default := "'0'" )

    case adt_type = 'Z'
     ( pao.add_type := ADS_IMAGE    , pao.sp_type := 'Blob'         )
    case adt_type = 'V'
     ( pao.add_type := ADS_IMAGE    , pao.sp_type := 'Blob'         )

    case adt_type = 'H'
     ( pao.add_type := ADS_TIME     , pao.sp_type := 'Time'         , pao.add_default := "' '" )

    case adt_type = 'T'
     ( pao.add_type := ADS_TIMESTAMP, pao.sp_type := 'TimeStamp'    , pao.add_default := "' '" )

    case adt_type = 'S'
     ( pao.add_type := ADS_AUTOINC  , pao.sp_type := 'AutoInc'      )

    case adt_type = 'F'
     ( pao.add_type := ADS_CURDOUBLE, pao.sp_type := 'CurDouble'    , pao.add_default := "'0'" )

    case adt_type = 'Y'
     ( pao.add_type := ADS_MONEY    , pao.sp_type := 'Money'        , pao.add_default := "'0'" )
    endcase
  next
return adbd_struct


static function create_ext_index_struct(o_drgFile)
  local x, pao, adi_fileName, adi_tagName, adi_expression, adi_condition, adi_options
  local aindex := o_drgFile:indexDef
  *
  local aadi_struct := {}

  for x := 1 to len(aindex) step 1
    pao      := aindex[x]

    adi_fileName   := pao:cFileName
    adi_tagName    := pao:cName
    adi_expression := upper( strTran( pao:cIndexKey, "'", '"'))
    adi_condition  := isNull(pao:cFor, '')
    adi_options    := ADS_COMPOUND + ;
                      if(pao:lUnique , ADS_UNIQUE    , 0) + ;
                      if(pao:lDescend, ADS_DESCENDING, 0)

    aadd( aadi_struct   , ;
        { adi_fileName  , ;    //  1_ dbd_cFileName
          adi_tagName   , ;    //  2_ dbd_cName
          adi_expression, ;    //  3_ dbd_cIndexKey
          adi_condition , ;    //  4_ dbd_cFor
          adi_options   , ;    //  5_ vazba na ch - Options for creating indexes
          0               } )  //  6_ modifikace 0-OK, 1-NEW, -1-DROP, 2-CREATE
  next
return aadi_struct


* ovìøíme datovou strukturu DBD vs ADD vytvoøíme SQL ALTER TABLE ...
static function alter_table(fileName, aext_data_struct)
  local x, pao, npos, dbd_name, adt_type, adt_len, adt_dec, org_name
  *
  local add_struct     := {}
  local add_del_column := {}, add_alter_column := {}
  *
  local cDEFAULT
  local cStatement     := ''

  s_columns->(dbsetScope( SCOPE_BOTH, padr(fileName,20) ), dbgoTop() )

  do while .not. s_columns->(eof())
    dbd_name := upper( allTrim( s_columns->Name))
    adt_type :=                 s_columns->Field_Type
    adt_len  :=                 s_columns->Field_Length
    adt_dec  :=                 s_columns->Field_decimal

    aadd( add_struct, ;
        { dbd_name  , ;
          adt_type  , ;
          adt_len   , ;
          adt_dec   , ;
          0           } )

    s_columns->(dbskip())
  enddo

  s_columns->(dbclearScope())

  * kotrola struktury
  for x := 1 to len(aext_data_struct) step 1
    pao      := aext_data_struct[x]
    dbd_name := lower(pao.dbd_name)
    npos     := ascan( add_struct, {|a| a[1] = dbd_name } )

    pao.add_Field_Num := npos

    do case
    case npos = 0  ;  pao.add_alter := 1                // ADD COLUMN ...
    otherwise
      do case
      case pao.add_type <> add_struct[npos, 2]
        * tohle je fatální chyba - nelze zmìnit TYP
        * jen nìkteré lze alteronovat

        if (pao.add_type = ADS_NUMERIC) .and. (add_struct[npos, 2] = ADS_DOUBLE)
          pao.add_alter := 2
        endif

      case pao.adt_len  <> add_struct[npos,3] .or. pao.adt_dec <> add_struct[npos,4]
        * ALTER COLUMN ...
        pao.add_alter := 2
      endcase
    endcase

    * položka je ok
    if( npos <> 0, add_struct[npos,5] := 1, nil )
  next

  * do add_alter_column uložíme data pro ALTER COLUMN
  * a setøídíme si to podle typu zmìny 0 - nic / 1 - ADD / 2 - ALTER
  AEval( aext_data_struct , {|a| if( a[9] <> 0, AAdd( add_alter_column, a), nil ) } )

  * do add_del_column   uložíme data pro DROP  COLUMN
  AEval( add_struct, { |a| if( a[5] = 0, AAdd(add_del_column, a), nil ) } )


  * musím modifikovat tabulku ?
  if len(add_alter_column) <> 0 .or. len(add_del_column) <> 0
    cStatement := "ALTER TABLE " +upper(fileName) +CRLF

    * ALTER
    if len(add_alter_column) <> 0
       ASort( add_alter_column, , , { |aX,aY| aX[9] < aY[9] } )

       for x := 1 to len(add_alter_column) step 1
         pao        := add_alter_column[x]
         cDefault   := if( isNull( pao.add_default), '', " DEFAULT " +pao.add_default )

         if pao.add_alter = 1
           cStatement += "      ADD   COLUMN "                    + ;
                                space(15)                         + ;
                                padR(pao.org_name, 15)            + ;
                                padR(UPPER(pao.sp_type ), 15)     + ;
                                cDEFAULT                          + ;
                                " POSITION "                      + ;
                                allTrim( str( pao.dbd_Field_Num)) + ;
                                CRLF

         else
           cStatement += "      ALTER COLUMN "                    + ;
                                padR(pao.org_name, 15)            + ;
                                padR(pao.org_name, 15)            + ;
                                padR(UPPER(pao.sp_type ), 15)     + ;
                                cDEFAULT                          + ;
                                CRLF
         endif
       next
    endif

    * DEL
    if len(add_del_column)   <> 0
      for x := 1 to len(add_del_column) step 1

        cStatement += "      DROP  COLUMN " +add_del_column[x,1] +CRLF
      next
    endif

    if( .not. empty(cStatement), cStatement += ";" +CRLF, nil)
  endif
return cStatement


* založíme novou tabulku do ADD
static function create_table(fileName, aext_data_struct, isCrypt)
  local x, pao
  *
  local cDEFAULT, fail_fileName := fileName +'fail'
  local cStatement := "CREATE TABLE " +upper(fileName) + "(" +CRLF

  * vlastní založení tabulky
  for x := 1 to len(aext_data_struct) step 1
    pao      := aext_data_struct[x]
    cDEFAULT := if( isNull( pao.add_default), '', " DEFAULT " +pao.add_default )

    cStatement +=  space(7)                       + ;
                   padR(pao.org_name, 15)         + ;
                   padR(UPPER(pao.sp_type ), 15)  + ;
                   cDEFAULT                       + ;
                   if( x = len(aext_data_struct), "",  "," +CRLF )

  next

  cStatement += ") IN DATABASE;" +CRLF

  * pokud zakládáme šifrovanou tabulku
  if isCrypt
    cStatement += CRLF
    cStatement += "EXECUTE PROCEDURE sp_ModifyTableProperty("          + ;
                      "   '" +fileName              +"',"        +CRLF + ;
                      "   'Table_Encryption'"       +","         +CRLF + ;
                      "   'True'"                   +","         +CRLF + ;
                      "   'APPEND_FAIL'"            +","         +CRLF + ;
                      "   '" +fail_fileName         +"');"       +CRLF +CRLF
  endif
return cStatement


* ovìøíme indexy DBD vs ADD
static function check_dbd_indexes(fileName, aext_adi_struct)
  local x, pao, npos, adi_fileName, adi_tagName, adi_expression, adi_condition, adi_options
  local adi_pageSize   := '512'                                                 // , adi_Collations := "''"
  local add_struct     := {}
  *
  local Index_File_name
  local cStatement := '', sp_CreateIndex, cdrop_Index := ''

  s_indexes->(dbsetScope( SCOPE_BOTH, padr(fileName,20) ), dbgoTop() )

  do while .not. s_indexes->(eof())
    adi_fileName   := upper( allTrim( strTran(s_indexes->Index_File_name, '.adi', '')))
    adi_tagName    := allTrim(s_indexes->Name)
    adi_expression := upper( strTran( s_indexes->Index_Expression, "'", "'"))
    adi_condition  := s_indexes->Index_Condition
    adi_options    := s_indexes->Index_Options

    aadd( add_struct    , ;
        { adi_fileName  , ;    //  1_ dbd_cFileName
          adi_tagName   , ;    //  2_ dbd_cName
          adi_expression, ;    //  3_ dbd_cIndexKey
          adi_condition , ;    //  4_ dbd_cFor
          adi_options   , ;    //  5_ vazba na ch - Options for creating indexes
          0               } )  //  6_ modifikace 0-OK, 1-NEW, -1-DROP, 2-CREATE

    s_indexes->(dbskip())
  enddo

  s_indexes->(dbclearScope())


  * kotrola indexákù
  for x := 1 to len(aext_adi_struct) step 1
    pao            := aext_adi_struct[x]
    adi_tagName    := upper( pao.adi_tagName)
    npos           := ascan( add_struct, { |a| a[2] = adi_tagName })
    *
    sp_CreateIndex := .f.


    do case
    case npos = 0  ;  pao.adi_alter  := 1                // new_TAG
                      sp_CreateIndex := .t.

    otherwise
      do case
      case pao.adi_expression <> add_struct[npos,3] .or. ;
           pao.adi_condition  <> add_struct[npos,4] .or. ;
           pao.adi_options    <> add_struct[npos,5]

        * DROP and sp_CreateIndex
        cStatement     += "DROP INDEX " +pao.adi_fileName +"." +pao.adi_tagName +";" +CRLF
        sp_CreateIndex := .t.
      endcase
    endcase

    if sp_CreateIndex
      adi_options := strTran( str(pao.adi_options), ' ', '')
      * ver 8.
      cStatement += "EXECUTE PROCEDURE sp_CreateIndex("                     +CRLF + ;
                    "   '" +fileName                           +"',"        +CRLF + ;
                    "   '" +pao.adi_fileName +".adi"           +"',"        +CRLF + ;
                    "   '" +pao.adi_tagName                    +"',"        +CRLF + ;
                    "   '" +pao.adi_expression                 +"',"        +CRLF + ;
                    "   '" +pao.adi_condition                  +"',"        +CRLF + ;
                    "    " +    adi_options                    +" ,"        +CRLF + ;
                    "    " +    adi_pageSize                   +");"        +CRLF + CRLF


      * ver 9.
*      cStatement += "EXECUTE PROCEDURE sp_CreateIndex90("                   +CRLF + ;
*                    "   '" +fileName                           +"',"        +CRLF + ;
*                    "   '" +pao.adi_fileName +".adi"           +"',"        +CRLF + ;
*                    "   '" +pao.adi_tagName                    +"',"        +CRLF + ;
*                    "   '" +pao.adi_expression                 +"',"        +CRLF + ;
*                    "   '" +pao.adi_condition                  +"',"        +CRLF + ;
*                    "    " +    adi_options                    +" ,"        +CRLF + ;
*                    "    " +    adi_pageSize                   +" ,"        +CRLF + ;
*                    "    " +    adi_Collations                 +");"        +CRLF +CRLF
    endif

    * co je OK, nebo se musí znovu založit mùžeme zrušit
    if( npos <> 0, ARemove( add_struct, npos), nil )
  next

  * co zùstane v add_struct se musí DROP  ... nout
  * POZOR musí to být první èást SQL

  for x := 1 to len(add_struct) step 1
    cdrop_Index += "DROP INDEX " +add_struct[x,1] +"." +add_struct[x,2] +";" +CRLF +CRLF
  next
return { cdrop_Index, cStatement }