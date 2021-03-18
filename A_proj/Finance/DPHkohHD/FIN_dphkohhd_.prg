#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_dphkohhd_cpy(oDialog)
  local  cky        := dphKohHd->cidHlaseni

  ** tmp soubory **
  drgDBMS:open('dphKohHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('dphkohITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  mh_copyFld('dphKohhd', 'dphKohHDw',.t., .t.)

  dphKohit->( dbsetScope(SCOPE_BOTH, cky), ;
              dbgoTop()                  , ;
              dbeval( { || if( 'i' $ dphKohit->coddilKohl, nil, mh_copyFld('dphKohit', 'dphKohITw', .t., .t. ) ) } ) )
  dphKohITw->( dbgoTop())
RETURN NIL


*
** uložení kontrolního hlášení o DPH *******************************************
function FIN_dphkohhd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := fin_dphkohhd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE

  _clearEventLoop(.t.)
return lDone


static function FIN_dphkohhd_wrt(odialog)
  local  anKoi      := {}
  local  mainOk     := .t., nrecOr, lnewRec
  local  omoment

  dphKohITw->(AdsSetOrder(0), ;
              dbgotop()     , ;
              dbeval({|| aadd(anKoi,dphKohITw->_nrecor) }))


  dphKohHd->(dbgoto(dphKohHDw->_nrecor))
  mainOk  := ( dphKohHd->(sx_rlock()) .and. dphKohIt->(sx_rlock(anKoi)) )
  lnewRec := .f.

  if mainOk
    omoment := SYS_MOMENT( '=== UKLÁDÁM KONTROLNÍ HLÁŠENÍ ===')

    dphKohHDw->lrucOprava := .t.
    mh_copyFld( 'dphKohHDw', 'dphKohHd', lnewRec, .f. )
    dphKohHd->(dbcommit())
    *
    ** položky
    dphKohITw->( AdsSetOrder(0), dbgoTop() )

    do while .not. dphKohITw->( eof())
      if((nrecOr := dphKohITw->_nrecor) = 0, nil, dphKohIt->(dbgoto(nrecor)))

      if   dphKohITw->_delrec = '9'
        if ( nrecOr <> 0, dphKohIt->(dbdelete()), nil )
      else

        dphKohITW->cidHlaseni := dphKohHd ->cidHlaseni
        dphKohITW->ndphKohlHD := dphKohHd ->sid

        mh_copyfld('dphKohITw','dphKohIt',(nrecOr=0), .f.)
      endif

      dphKohITw->( dbskip())
    enddo

    omoment:destroy()
  else
    drgMsg(drgNLS:msg('Nelze modifikovat KONTROLNÍ HLÁŠENÍ, blokováno uživatelem ...'),,odialog)
  endif

  dphKohHd->(dbunlock(), dbcommit())
   dphKohIt->(dbunlock(), dbcommit())
return mainOk


*
** zrušení opravovaného hlášení, opravené nahradí pùvodní opravu
static function FIN_dphkohhd_del()
  local  sid, nsel, nodel := .f.
  *
  local  cStatement, oStatement
  local  stmt     := "delete from %file where %c_sid = %sid"
  local  pa_files := { { 'dphKohHd', 'sid' }, { 'dphKohIt', 'ndphKohlHd' } }, x

  sid := dphKohHDw->_nsidOR

  for x := 1 to len(pa_files) step 1
    cStatement := strTran( stmt      , '%file' , pa_files[x,1]    )
    cStatement := strTran( cStatement, '%c_sid', pa_files[x,2]    )
    cStatement := strTran( cStatement, '%sid'  , allTrim(str(sid)))

    oStatement := AdsStatement():New(cStatement, oSession_data)

    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
    endif

    oStatement:Close()

    (pa_files[x,1])->(dbUnlock(), dbCommit())
  next
return self