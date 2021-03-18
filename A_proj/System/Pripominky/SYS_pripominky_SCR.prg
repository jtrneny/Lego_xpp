#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'asysprhd', 'asysprit', 'dokument', 'vazdokum' }


*
** CLASS for PRO_explsthd_SCR **************************************************
CLASS SYS_pripominky_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked
  method  export_pripom

  * polo�ky - bro
  * explstit
/*
  inline access assign method is_vyrZakit() var is_vyrZakit
    return if( .not. empty(explstit->ccisZakazI), MIS_ICON_OK, 0)

  inline access assign method is_dodList() var is_dodList
    return if( .not. empty(explstit->ncisloDL), MIS_ICON_OK, 0)

  inline access assign method firmaODB() var firmaODB
    local retVal := ''

    if .not. empty(explstit->ncisFirmy)
      retVal := str(explstit->ncisFirmy) +' _' +left(explstit->cnazev,25)
    endif
  return retVal

  inline access assign method firmaDOA() var firmaDOA
    local retVal := ''

    if .not. empty(explstit->ncisFirDOA)
      retVal :=  str(explstit->ncisFirDOA) +' _' +left(explstit->cnazevDOA,25)
    endif
   return retVal
*/

  * pripomhd
  inline access assign method stav_pripom() var stav_pripom
    local retVal := 0

    do case
    case(asysprhd->nstapripom =  0)  ;  retVal := 304   // zaevidovan�
    case(asysprhd->nstapripom =  1)  ;  retVal := 303   // �e�� se
    case(asysprhd->nstapripom =  2)  ;  retVal := 315   // �ek� se na vyj�d�en�
    case(asysprhd->nstapripom =  3)  ;  retVal := 600   // po�aduje se up�esnit
    case(asysprhd->nstapripom =  4)  ;  retVal := 606   // p�ipraveno k testov�n�
    case(asysprhd->nstapripom =  5)  ;  retVal := 338   // �ek� se na odpov��
    case(asysprhd->nstapripom = 80)  ;  retVal := 301   // zam�tnut�
    case(asysprhd->nstapripom = 81)  ;  retVal := 601   // odlo�en�
    case(asysprhd->nstapripom = 90)  ;  retVal := 302   // vy�e�en�
    case(asysprhd->nstapripom = 91)  ;  retVal := 300   // ukon�en�
    otherwise
      retVal := 604
    endcase
    return retVal

  inline access assign method priorita_pripom() var priorita_pripom
    local retVal := 0

    do case
    case(asysprhd->npripripom =  0)  ;  retVal := 348   // zaevidovan�
    case(asysprhd->npripripom =  1)  ;  retVal := 349   // zaevidovan�
    case(asysprhd->npripripom =  2)  ;  retVal := 350   // zaevidovan�
    case(asysprhd->npripripom =  3)  ;  retVal := 351   // zaevidovan�
    endcase
    return retVal

  inline access assign method komunik_pripom() var komunik_pripom
    local retVal := 0

    do case
    case(asysprhd->nstakomuni =  0)  ;  retVal := 0     // ��dn� export neprob�hl
    case(asysprhd->nstakomuni =  1)  ;  retVal := 516   // vyexportovan�
    case(asysprhd->nstakomuni =  2)  ;  retVal := 515   // importovan�
    case(asysprhd->nstakomuni =  3)  ;  retVal := 514   // �ek� na nov� export
    case(asysprhd->nstakomuni = 90)  ;  retVal := 503   // z�kaz exportu
    endcase
    return retVal


  inline method mleinit(odrg)
    local  omle := oDrg:oXbp
    omle:setWrap(.t.)
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow
  method  postDelete
ENDCLASS


METHOD SYS_pripominky_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * z�kladn� soubory
  ::openfiles(m_files)

*** likvidace
*  ::FIN_finance_in:typ_lik := 'poh'
RETURN self


METHOD SYS_pripominky_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
*-  dodlsthd->(dbgobottom())
RETURN


METHOD SYS_pripominky_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method SYS_pripominky_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)

    asysprit ->( ads_setaof(Format("cIDpripom = '%%'", {asysprhd ->cIDpripom})))
 endif
return self


method SYS_pripominky_scr:postDelete()
  local  nsel, nodel := .f.

  if asysprit->nidpripom = 0
    nsel := ConfirmBox( ,'Po�adujete zru�it p�ipom�nku', ;
                         'Zru�en� p�ipom�nky ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      sys_pripominky_cpy(self)
      nodel := .not. sys_pripominky_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'P�ipom�nku _' +alltrim(str(asysprhd->nidpripom)) +'_' +' nelze zru�it ...', ;
                 'Zru�en� p�ipom�nky ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel

*
**
/*
method pro_explsthd_scr:explst_dodlst()
  local  oxbp := ::drgDialog:oMessageBar:msgStatus
  local  o    := explst_dodlst():new()

  o:processed()

  oXbp:SetCaption('Zpracov�n� dodac�ho listu bylo dokon�eno ...')

  tone(100,13)
   tone(200,13)
    tone(300,13)
     tone(500,16)

  sleep(50)
  oxbp:setCaption('')
return self
*/


method SYS_pripominky_scr:export_pripom()
  local  nsel, o, oxbp := ::drgDialog:oMessageBar:msgStatus


  nsel := ConfirmBox( ,'Po�adujete exportovat p�ipom�nky', ;
                       'Export p�ipom�nek...', ;
                        XBPMB_YESNO                    , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
//    o := export_pripom():new()
//    o:processed()

    oXbp:SetCaption('Export p�ipom�nek byl dokon�en ...')
    (tone(100,13), tone(200,13), tone(300,13), tone(500,16))

    sleep(50)
  endif

  oxbp:setCaption('')
return self