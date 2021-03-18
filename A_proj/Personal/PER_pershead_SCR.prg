#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  PERSHEAD
** CLASS PER_pershead_SCR *****************************************************
CLASS PER_pershead_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init
  method  drgDialogStart
  METHOD  EventHandled
  METHOD  itemMarked

  * browColumn
  inline access assign method is_isZAM() var is_isZAM      // ? je v msPrc_mo
    return if( osoby->nis_ZAM = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isPER() var is_isPER      // ? je v personal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isDOH() var is_isDOH      // ? je v dsPohyby
    return if( osoby->nis_DOH = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isRPR() var is_isRPR      // ? je v rodPrisl
    return if( osoby->nis_RPR = 1, MIS_ICON_OK, 0 )


******
  inline  method osb_osoby_nova(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method osb_osoby_oprava(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.


  inline method postDelete()
    local  sid    := isNull(pershead->sid,0)
    local  ctitle := 'Zrušení návrhu plánu persAkce ...'
    local  cinfo  := 'Promiòte prosím,'                           +CRLF + ;
                     'požadujete zrušit návrh plánu persAkce ...' +CRLF + CRLF  + ;
                      padc( upper(pershead->ctypPohybu) +' / ' +upper(pershead->czkratka), 40)
    *
    local  cStatement, oStatement, cfiel_iv, c_in := ''
    local  stmt := "delete from pershead where sID = %sid;"       + ;
                   "delete from persitem where nPERSHEAD = %sid;" + ;
                   "update %cfile_iv set nstav_Pol = 0 where sid in (%c_in);"

    if sid <> 0
      nsel :=  confirmBox( , cinfo      , ;
                             ctitle     , ;
                             XBPMB_YESNO, ;
                             XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

      if nsel = XBPMB_RET_YES
        cfile_iv := persitem->cfile_iv

        persitem->( dbeval( { || c_in += allTrim(str(persitem->nfile_iv)) +',' } ))
        c_in     := subStr( c_in, 1, len(c_in) -1 )

        cStatement := strTran( stmt      , '%sid'     , allTrim(str(sid)) )
        cStatement := strTran( cStatement, '%c_in'    , c_in              )
        cStatement := strTran( cStatement, '%cfile_iv', cfile_iv          )
        oStatement := AdsStatement():New(cStatement,oSession_data)

        if oStatement:LastError > 0
          *  return .f.
        else
          oStatement:Execute( 'test', .f. )
          oStatement:Close()
        endif
        pershead->(dbskip())
      endif

      pershead->(dbcommit(), dbunlock())
      persitem->(dbcommit(), dbunlock())

      ::drgDialog:dialogCtrl:refreshPostDel()
    endif
  return .t.

ENDCLASS


*
********************************************************************************
METHOD PER_pershead_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.


METHOD PER_pershead_SCR:init(parent)
  ::drgUsrClass:init(parent)
RETURN self


method PER_pershead_SCR:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


METHOD PER_pershead_SCR:itemMarked(arowCol,unil,oxbp)
  local  sid := isNull(pershead->sid,0)
  local  cf  := "nPERSHEAD = %%", filter

  filter := format(cf, {sid} )
  persitem->( ads_setAof(filter), dbgoTop())
RETURN self


*METHOD AKC_akcionar_SCR:itemSelected()
*  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT ::drgDialog DESTROY
*  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
*RETURN self