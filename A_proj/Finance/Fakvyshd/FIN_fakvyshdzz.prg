#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define  m_files   {'dph_2004','dphdata' ,'ucetsys','uzavisoz', 'vykdph_i', ;
                    'fakvyshd','ucetdohd','ucetdoit','firmy'    }


*  zaplacené zálohy vystavené
** CLASS for FIN_FAKVYSHDZZ_SCR ************************************************
CLASS FIN_FAKVYSHDZZ_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     typ_zz, lnewRec, oinf, oinf_ucd
  method  init, drgDialogStart, drgDialogEnd, itemMarked, onLoad

 *
 inline access assign method is_danDokUsed() var is_danDokUsed
   local  cKy := upper(fakvyshd->cdenik) +strZero(fakvyshd->ncisFak,10) +strZero(ucetdohd->ndoklad)
   return if( ucetdohd->ndoklad <> 0 .and. vykdph_i->(dbSeek(cKy,,'VYKDPH_6')), MIS_NO_RUN, 0)


 inline method eventHandled(nEvent, mp1, mp2, oXbp)
   do case
   case nEvent = drgEVENT_DELETE
     if ::is_danDokUsed <> 0
       ConfirmBox( ,'Daòový doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_' +' nelze zrušit, je již použit ...', ;
                    'Zrušení daòového dokladu ...' , ;
                    XBPMB_CANCEL                  , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
      else
        ::postDelete()
      endif
     return .t.
   endcase
   return .f.

 *
 inline method onSave()
   ::drgDialog:dialogCtrl:refreshPostDel()
   return .f.

hidden:
  method  postDelete
ENDCLASS


method FIN_fakvyshdzz_SCR:init(parent)
  local  filter := "upper(ciszal_fak) = '1'"

  ::drgUsrClass:init(parent)
  ::lnewRec := .f.

  * základní soubory
  ::openfiles(m_files)

  ** likvidace/rvdph
  ::FIN_finance_in:typ_lik := 'ucd'
  ::typ_zz                 := 'poh'

  ** info
  ::oinf     := fin_datainfo():new('FAKVYSHD')
  ::oinf_ucd := fin_datainfo():new('UCETDOHD')

  *
  ** nastavení programového filtru
  ::drgDialog:set_prg_filter(filter, 'fakvyshd')

RETURN self


METHOD FIN_fakvyshdzz_SCR:drgDialogStart(drgDialog)
RETURN


METHOD FIN_fakvyshdzz_SCR:itemMarked()
  LOCAL  cKy := Upper(FAKVYSHD ->cDENIK) +StrZero(FAKVYSHD ->nCISFAK,10)

  ucetdohd->(mh_ordSetScope(cKy))

   * daòový doklad nemá položky
  cKy := Upper(UCETDOHD ->cDENIK) +StrZero(UCETDOHD ->nDOKLAD,10)
  ucetdoit->(mh_ordSetScope(cKy))

  ::drgDialog:oMessageBar:writeMessage(,0)
RETURN SELF


method FIN_fakvyshdzz_scr:onLoad()
  local  am_area := ::drgDialog:dialogCtrl:dbAreaStack

  * po INS musím vrátit pozici záznamu
  (am_area[1])->(dbgoto(am_area[3]))
return self


method FIN_fakvyshdzz_scr:postDelete()
  local  oinf := fin_datainfo():new('UCETDOHD'), nsel, nodel := .f.

  if ucetdohd->ndoklad <> 0
    if oinf:danuzav() = 0 .and. oinf:ucuzav() = 0
      nsel := ConfirmBox( ,'Požadujete zrušit daòový doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_', ;
                           'Zrušení daòového dokladu ...' , ;
                            XBPMB_YESNO                   , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      if nsel = XBPMB_RET_YES
        fin_ucetdohd_cpy(self)
        nodel := .not. fin_ucetdohd_del()
      endif
    else
      nodel := .t.
    endif

    if nodel
      ConfirmBox( ,'Daòový doklad _' +alltrim(str(ucetdohd->ndoklad)) +'_' +' nelze zrušit ...', ;
                   'Zrušení daòového dokladu ...' , ;
                   XBPMB_CANCEL                  , ;
                   XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    endif

    ::itemMarked()
    ::drgDialog:dialogCtrl:refreshPostDel()
  endif
return .not. nodel

METHOD FIN_fakvyshdzz_SCR:drgDialogEnd()
RETURN