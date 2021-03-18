#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"


function PRO_objhead_cpy(oDialog)
  local  file_name, ky, mky
  local  lNEWrec          := If( IsNull(oDialog), .F., oDialog:lNEWrec         )
  local  isparent_mainScr := if( IsNull(oDialog), .F., oDialog:isparent_mainScr)
  *
  * objednávky pøijaté
  drgDBMS:open('OBJHEADw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('OBJITEMw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  file_name := objitemw ->( DBInfo(DBO_FILENAME))
               objitemw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'objitemw', .t., .f.) ; objitemw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'objit_iw', .t., .t.) ; objit_iw->(AdsSetOrder(1))
  *

  if .not. lNEWrec
    mh_COPYFLD('OBJHEAD','OBJHEADw', .t., .t.)

    *
    ** volání z pro_objhead_scr, nebo z pro_objitem_scr
    if isparent_mainScr

      mky := upper(objhead->ccislobint)
      objitem->(AdsSetOrder('OBJITEM2'),dbsetscope(SCOPE_BOTH,mky),dbgotop())

      do while .not. OBJITEM ->(Eof())
        ky := upper(objitem->ccissklad) +upper(objitem->csklpol)
        cenzboz->(dbseek(ky,,'CENIK03'))

        mh_COPYFLD('OBJITEM','OBJITEMw',.t., .t.)

        * originál
        objitemw->cfile_iv   := 'cenzboz'
        objitemw->nrecs_iv   := cenzboz->(recNo())
        objitemw->_mnozPoOdb := objitem->nmnozPoOdb
        objitemw->_mnozVpInt := objitem->nmnozVpInt
        OBJITEM ->(DbSkip())
      enddo
      objitem->(dbgotop())
    else

      mky := upper(objhead->ccislobint)
      objit_lpc->(AdsSetOrder('OBJITEM2'),dbsetscope(SCOPE_BOTH,mky),dbgotop())

      do while .not. objit_lpc ->(Eof())
        ky := upper(objit_lpc->ccissklad) +upper(objit_lpc->csklpol)
        cenzboz->(dbseek(ky,,'CENIK03'))

        mh_COPYFLD('objit_lpc','OBJITEMw',.t., .t.)

        * originál
        objitemw->cfile_iv   := 'cenzboz'
        objitemw->nrecs_iv   := cenzboz->(recNo())
        objitemw->_mnozPoOdb := objitem->nmnozPoOdb
        objitemw->_mnozVpInt := objitem->nmnozVpInt
        objit_lpc ->(DbSkip())
      enddo
      objit_lpc->(dbclearScope(), dbgotop())

    endif

  else
    objheadw ->(dbappend())
    doklad := fin_range_key('OBJHEAD')[2]

    ( objheadw->culoha := 'P'                               , ;
      objheadw->ndoklad    := doklad                        , ;
      objheadw->ddatobj    := date()                        , ;
      objheadw->ddatdoodb  := date()                        , ;
      objheadw->ddatodvvyr := date()                        , ;
      objheadw->czkratmeny := sysconfig('finance:czaklmena'), ;
      objheadw->czkratmenz := sysconfig('finance:czaklmena'), ;
      objheadw->nkurZahMen := 1                             , ;
      objheadw->nmnozPrep  := 1                             , ;
      objheadw->cintpracov := logOsoba                      , ;
      objheadw->nextObj    := 1                               )
  endif

  c_staty->(dbseek(upper(objheadw->czkratStat),,'C_STATY1'))
return nil


*
** uložení objednávky pøijaté v transakci **************************************
function pro_objhead_wrt_inTrans(odialog)
  local  lDone

  lDone := pro_objhead_wrt(odialog)

   _clearEventLoop(.t.)
return lDone


*
** uložení objednávky pøijaté **************************************************
static function pro_objhead_wrt(odialog)
  local  mainOk   := .t., nrecor, ky
  local  anObi    := {}, anCen := {}

  objitemw->(AdsSetOrder(0),dbgotop())

  do while .not. objitemw->(eof())
    aadd(anObi, objitemw->_nrecor )
    aadd(anCen, objitemw->nrecs_iv)

    objitemw->(dbskip())
  enddo

  mainOk := cenzboz->(sx_rlock(anCen))

  if .not. odialog:lnewRec
    objhead->(dbgoto(objheadw->_nrecor))

    mainOk := mainOk                     .and. ;
              objhead->(sx_rlock())      .and. ;
              objitem->(sx_rlock(anObi))
  else
    odialog:int_cislObint(.t.)
    objitemw->(dbgotop(), dbeval( { || objitemw->ccislObint := objheadw->ccislObint } ))
  endif


  if mainOk
    if(objheadw->_delrec <> '9', mh_copyfld('objheadw','objhead',odialog:lnewRec, .f.), nil)
    objitemw->(dbgotop())

    do while .not. objitemw->(eof())
      cenzboz->(dbgoto(objitemw->nrecs_iv))

      if((nrecor := objitemw->_nrecor) = 0, nil, objitem->(dbgoto(nrecor)))
      if   objitemw->_delrec = '9'
        if nrecor <> 0
          pro_objhead_rez(xbeK_DEL)
          objitem->(dbdelete())
        endif
      else
        pro_objhead_rez( if(nrecor=0,xbeK_INS,xbeK_ENTER) )

        objitemw->ndoklad := objhead->ndoklad

        if odialog:ldat_HD_to_IT
          OBJITEMw->ddatobj    := objhead->ddatobj
          OBJITEMw->ddatdoodb  := objhead->ddatdoodb
          OBJITEMw->ddatodvvyr := objhead->ddatodvvyr
        endif

        mh_copyfld('objitemw','objitem',(nrecor=0), .f.)
      endif

      objitemw->(dbskip())
    enddo

    if(objheadw->_delrec = '9', objhead->(dbdelete()), nil )

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat OBJEDNÁVKU PØIJATOU, blokováno uživatelem ...'))
  endif

  objhead->(dbunlock(),dbcommit())
   objitem->(dbunlock(),dbcommit())
    cenzboz->(dbunlock(),dbcommit())
return mainOk


*
** zrušení objednávky pøijaté **
function pro_objhead_del(odialog)
  local  mainOk := .t.

  objheadw->_delrec := '9'
  objitemw->(objitemw->(AdsSetOrder(0),dbgotop()), dbeval({|| objitemw->_delrec := '9'}))

  objheadw->(dbcommit())
  objitemw->(dbcommit())

  mainOk := pro_objhead_wrt(odialog)
return mainOk


function pro_objhdead_cmp()

  objheadw->nkcsbdobj := ;
   objheadw->nkcszdobj := ;
    objheadw->nkcszdobjz := ;
     objheadw->nmnozobodb := ;
      objheadw->nmnozpoodb := ;
       objheadw->nmnozneodb := ;
        objheadw->nhodnslev  := ;
         objheadw->npocpolobj := objheadw->nhmotnost := objheadw->nobjem := 0

  objit_iw->(dbgotop())

  do while .not. objit_iw->(eof())
    if (objit_iw->_delrec <> '9')

      objheadw->nkcsbdobj  += objit_iw->nkcsbdobj
      objheadw->nkcszdobj  += objit_iw->nkcszdobj

      c_typuhr ->( dbseek(objheadw->czkrtypuhr))
      objheadw->nkcszdobjz := mh_roundnumb(objheadw->nkcszdobj, c_typuhr->nkodzaokr)

      objheadw->nmnozobodb += objit_iw->nmnozobodb
      objheadw->nmnozpoodb += objit_iw->nmnozpoodb
      objheadw->nhmotnost  += objit_iw->nhmotnost
      objheadw->nobjem     += objit_iw->nobjem

      objheadw->nmnozneodb := (objheadw ->nmnozobodb -objheadw ->nmnozpoodb)
      objheadw->nhodnslev  := objit_iw->ncelkslev
      objheadw->npocpolobj++
    endif

    objit_iw->(dbskip())
  enddo
return nil



static function pro_objhead_rez(ky)
  local  zbyva, zbyva_2
  local  oldO_mnozPoODB := objitemW->_mnozPoODB, ;
         oldO_mnozReODB := objitemW->nmnozReODB, ;
         aktC_mnozDzbo  := cenZboz  ->nmnozDzbo, ;
         oldO_mnozVpInt := objitemw->_mnozVpInt
  *
  local  cmp_mnozPoODB


  do case
  *
  ** INS
  case(ky = xbeK_INS )

    * musíme naplnit nmnozDzbo z cenZboz
    * mohlo dojít ke zmìnì pøed vystavením zámku

    objitemW->nmnozDzbo := cenZboz->nmnozDzbo

    do case
    case objitemW->nmnozDzbo = 0
      cenzboz ->nmnozKzbo  += objitemw->nmnozPoODB
      objitemw->nmnozKoDOD := objitemw->nmnozPoODB

    case objitemW->nmnozDzbo >= objitemW->nmnozPoODB
      cenzboz ->nmnozDzbo  -= objitemW->nmnozPoODB
      cenzboz ->nmnozRzbo  += objitemW->nmnozPoODB
      objitemW->nmnozReODB := objitemW->nmnozPoODB

    case objitemW->nmnozDzbo <  objitemW->nmnozPoODB
      cenzboz ->nmnozDZbo  :=  0
      cenzboz ->nmnozRzbo  +=  objitemw->nmnozDzbo
      cenzboz ->nmnozKzbo  += (objitemW->nmnozPoODB -objitemW->nmnozDzbo)
      objitemW->nmnozReODB :=  objitemW->nmnozDzbo
      objitemW->nmnozKoDOD := (objitemW->nmnozPoODB -objitemW->nmnozDzbo)
    endcase
  *
  ** ENTER
  case(ky = xbeK_ENTER)

    cenzboz ->nmnozDZbo  += objitemW->nmnozReODB
    cenZboz ->nmnozRzbo  := max( 0, cenzboz ->nmnozRzbo -objitemW->nmnozReODB)
    cenZboz ->nmnozKzbo  := max( 0, cenZboz ->nmnozKzbo -objitemW->nmnozKoDOD)
    *
    objitemW->nmnozReODB := 0
    objitemW->nmnozKoDOD := 0

    do case
    case cenZboz->nmnozDzbo = 0
      cenzboz ->nmnozKzbo  += objitemw->nmnozPoODB
      objitemw->nmnozKoDOD := objitemw->nmnozPoODB

    case cenZboz->nmnozDzbo >= objitemW->nmnozPoODB
      cenzboz ->nmnozDzbo  -= objitemW->nmnozPoODB
      cenzboz ->nmnozRzbo  += objitemW->nmnozPoODB
      objitemW->nmnozReODB := objitemW->nmnozPoODB

    case cenZboz->nmnozDzbo < objitemW->nmnozPoODB
      cenzboz ->nmnozDZbo  :=  0
      cenzboz ->nmnozRzbo  +=  objitemw->nmnozDzbo
      cenzboz ->nmnozKzbo  += (objitemW->nmnozPoODB -objitemW->nmnozDzbo)
      objitemW->nmnozReODB :=  objitemW->nmnozDzbo
      objitemW->nmnozKoDOD := (objitemW->nmnozPoODB -objitemW->nmnozDzbo)
    endcase
  *
  ** DEL
  case(ky = xbeK_DEL )
    if objitemW->nmnozKoDOD > 0
      cenzboz->nmnozKzbo -= objitemw->nmnozKoDOD
      cenZboz->nmnozKzbo := max( 0, cenZboz->nmnozKzbo)
    endif

    if objitemW->nmnozObDOD > 0
      cenzboz->nmnozOzbo -= objitemW->nmnozObDOD
      cenZboz->nmnozOzbo := max( 0, cenZboz->nmnozOzbo)
    endif

    if objitemw->nmnozReODB > 0
      cenzboz->nmnozDzbo += objitemw->nmnozReODB
      cenzboz->nmnozRzbo -= objitemw->nmnozReODB
    endif
  endCase

return nil



/*
      if objitemw->nmnozKoDod >= (o_mnozPoOdb -objitemw->nmnozPoOdb)
        cenzboz ->nmnozKzbo  -= (o_mnozPoOdb -objitemw->nmnozPoOdb)
        objitemw->nmnozKoDod -= (o_mnozPoOdb -objitemw->nmnozPoOdb)
      else
        zbyva :=(o_mnozPoOdb -objitemw->nmnozPoOdb ) -objitemw->nmnozKoDod
        cenzboz ->nmnozKzbo  -= (o_mnozPoOdb -objitemw->nmnozPoOdb)
        objitemw->nmnozKoDod -= (o_mnozPoOdb -objitemw->nmnozPoOdb)

        if objitemw->nmnozObDod <> 0
          if zbyva <= objitemw->nmnozObDod
            cenzboz ->nmnozOzbo   -= zbyva
            objitemw->nmnozObDod  -= zbyva
*-            vztahobj ->nmnozObDod -= zbyva
*-            if(vztahobj->nmnozObDod = 0, vztahobj->(dbdelete()), nil)
          else
            zbyva_2 := zbyva -objitemw->nmnozObDod
            cenzboz ->nmnozOzbo   -= zbyva
            objitemw->nmnozObDod  -= zbyva
*-            vztahobj->nmnozObDod -= zbyva
*-            if(vztahobj->nmnozObDod = 0, vztahobj->(dbdelete()), nil)

            if objitemw->nmnozReOdb <> 0
              cenzboz ->nmnozDzbo  += zbyva_2
              cenzboz ->nmnozRzbo  -= zbyva_2
              objitemw->nmnozReOdb -= zbyva_2
            endif
          endif
        endif

        if objitemw->nmnozReOdb <> 0
          cenzboz ->nmnozDzbo  += zbyva
          cenzboz ->nmnozRzbo  -= zbyva
          objitemw->nmnozReOdb -= zbyva
        endif
      endif

    case objitemW->nmnozPoODB > o_mnozPoODB
      do case
      case objitemw->nmnozDzbo == 0
        cenzboz ->nmnozKzbo  += (objitemw->nmnozPoOdb -o_mnozPoOdb)
        objitemw->nmnozKoDod += (objitemw->nmnozPoOdb -o_mnozPoOdb)

      case objitemw->nmnozDzbo >= (objitemw->nmnozPoOdb -o_mnozPoOdb)
        cenzboz ->nmnozRzbo  += (objitemw->nmnozPoOdb -o_mnozPoOdb)
        cenzboz ->nmnozDzbo  := objitemw->nmnozSzbo -objitemw->nmnozRzbo
        objitemw->nmnozReOdb := (objitemw->nmnozPoOdb -o_mnozPoOdb)

      case objitemw->nmnozDzbo < (objitemw->nmnozPoOdb -o_mnozPoOdb)
        cenzboz ->nmnozRzbo  += objitemw->nmnozDzbo
        objitemw->nmnozReOdb += objitemw->nmnozDzbo
        cenzboz ->nmnozKzbo  += (objitemw->nmnozPoOdb -o_mnozPoOdb) -objitemw->nmnozDzbo
        objitemw->nmnozKoDod := (objitemw->nmnozPoOdb -o_mnozPoOdb) -objitemw->nmnozDzbo
        cenzboz->nmnozDzbo  := 0
      endcase

    endcase

  case(ky = xbeK_DEL )
    if objitemw->nmnozKzbo <> 0
      cenzboz->nmnozKzbo -= objitemw->nmnozKoDod
    endif

    if objitemw->nmnozObDod <> 0
      cenzboz->nmnozOzbo -= objitemw->nmnozObDod
*-      vztahobj->(dbdelete())
    endif

    if objitemw->nmnozReOdb <> 0
      zbyva := objitemw->nmnozDzbo +objitemw->nmnozReOdb
      cenzboz->nmnozDzbo := min(objitemw->nmnozSzbo, zbyva)
      cenzboz->nmnozRzbo -= objitemw->nmnozReOdb
    endif
  endcase

return nil
*/