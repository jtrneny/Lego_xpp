#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "Xbp.ch"
*
#include "..\Asystem++\Asystem++.ch"


*
* 1
* majOper/ oplOper
# define tabPage_1_mle       CRLF + ;
                             '  Zru�en� operace, '                                  +CRLF +CRLF+ ;
                             '  po�adejete zru�it operaci k vyr�b�n� polo�ce ?'     +CRLF +CRLF+ ;
                             '  Skute�n� chcete zru�it operace k vyr�b�n� polo�ce ?'
*
* 2
* kusov / kusTree
# define tabPage_2_mle1      CRLF + ;
                             '  Zru�en� kusovn�kov� vazby, '                                                +CRLF+       ;
                             '  zru�en� vazby mezi polo�kami vy��� - ni��� se prom�tne do v�ech kusovn�k�,' +CRLF+       ;
                             '  kde se tato vazba vyskytuje '                                               +CRLF+CRLF

# define tabPage_2_mle2      CRLF + ;
                             '  Ru��te z�kladn� variantu pozice ��slo 1, '                  +CRLF+      ;
                             '  proto je bezpodm�ne�n� nutn� tuto pozici znovu definovat !' +CRLF+ CRLF


/*
pro 1 i 2
cKEY := Upper( PolOper->cVyrPol) + StrZero( PolOper->nCisOper, 4) + ;
              StrZero( PolOper->nUkonOper, 2) + StrZero( PolOper->nVarOper, 3)
*/


*
** class VYR_kusTree_DEL ******************************************************
class VYR_kusTree_EX_DEL from drgUsrClass
  exported:
  method  init, getForm, drgDialogInit, drgDialogStart

  var     VtabPage1_chBox, VtabPage2_chBox

  *
  * 1
  * majOper / polOper
  inline access assign method VtabPage1_mle() var VtabPage1_mle
    return tabPage_1_mle
  *
  * 2
  * kusov / kusTree
  inline access assign method VtabPage2_mle() var VtabPage2_mle
    return tabPage_2_mle1 +if( kustree->nvarPoz = 1, tabPage_2_mle2, '') +'  Skute�n� chcete zru�it vazbu v kusovn�ku ?'


  inline method tabSelect(otabPage,tabNum)

    ::dm:set('M->VtabPage1_chBox', .f.)
    ::dm:set('M->VtabPage2_chBox', .f.)

    ( ::pb_del_Operace:disable(), ::pb_del_Kusov:disable() )
  return .t.


  inline method CheckItemSelected(drgVar)
    local  value := drgVar:value
    local  name  := drgVar:name

    ( ::pb_del_Operace:disable(), ::pb_del_Kusov:disable() )

    do case
    case ( name = 'M->VtabPage1_chBox' )
      if( value, ::pb_del_Operace:enable(), nil )

    case ( name = 'M->VtabPage2_chBox' )
      if( value, ::pb_del_Kusov:enable() , nil )
    endcase
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      Return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        RETURN .F.
      endcase

    otherwise
      RETURN .F.
    endcase
  RETURN .T.

  hidden:
  * sys
  var     msg, dm, dc, df
  var     pb_del_Operace, pb_del_Kusov
endclass



method VYR_kusTree_EX_DEL:init(parent)
  ::drgUsrClass:init(parent)

  ::VtabPage1_chBox     := .F.
  ::VtabPage2_chBox     := .F.
return self


method VYR_kusTree_EX_DEL:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 80,14 DTYPE '10' TITLE 'Ru�en� operac� a materi�lov�ch vazeb kusovn�ku ...' ;
                                           POST  'postValidate'                                       ;
                                           GUILOOK 'All:N,Border:Y,ACTION:N'
*
* 1
* OPERACE - ru��me majOper / polOper
  DRGTABPAGE INTO drgFC CAPTION 'operace' FPOS 0,.2 SIZE 80,15  OFFSET 1,81 PRE 'tabselect'
*    DRGSTATIC INTO drgFC CAPTION '2' FPOS 0,1 SIZE 150,200 STYPE XBPSTATIC_TYPE_BITMAP

    DRGMLE M->VtabPage1_mle  INTO drgFC FPOS .2, .2 SIZE 79.6, 11 SCROLL 'NN'
    odrg:rOnly := .t.

    DRGCHECKBOX M->VtabPage1_chBox INTO drgFC FPOS  4.5,11.5 FLEN 30 VALUES 'T:��Souhlas�m se zru�en�m operace, ' + ;
                                                                            'F:��Souhlas�m se zru�en�m operace'

    DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start    '         ;
                  EVENT 'del_Operace' SIZE 13,1.1 POS 50, 11.5 ;
                  ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3

    DRGPUSHBUTTON INTO drgFC CAPTION '  ~Storno'                    ;
                  EVENT drgEVENT_QUIT     SIZE 13,1.1 POS 64, 11.5 ;
                  ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3
  DRGEND INTO drgFC
*
*  2
*  MATERIAL - ru��me kusov / kusTree
   DRGTABPAGE INTO drgFC CAPTION 'materi�l' FPOS 0,.2 SIZE 80,15  OFFSET 18,63 PRE 'tabSelect'

     DRGMLE M->VtabPage2_mle INTO drgFC FPOS .2, .2 SIZE 79.6, 11 SCROLL 'NN'
     odrg:rOnly := .t.

     DRGCHECKBOX M->VtabPage2_chBox INTO drgFC FPOS  4.5,11.5 FLEN 35 VALUES 'T:��Souhlas�m se zru�en�m kusovn�kov� vazby,' + ;
                                                                             'F:��Souhlas�m se zru�en�m kusovn�kov� vazby'

     DRGPUSHBUTTON INTO drgFC CAPTION '   ~Start    '         ;
                   EVENT 'del_Kusov' SIZE 13,1.1 POS 50, 11.5 ;
                   ICON1  MIS_ICON_PAY ICON2 0 ATYPE 3

     DRGPUSHBUTTON INTO drgFC CAPTION '  ~Storno'                    ;
                   EVENT drgEVENT_QUIT     SIZE 13,1.1 POS 64, 11.5 ;
                   ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3
   DRGEND INTO drgFC

return drgFC


method VYR_kusTree_EX_DEL:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  XbpDialog:titleBar := .F.

return


method VYR_kusTree_EX_DEL:drgDialogStart(drgDialog)
  local  x
  local  members := drgDialog:oForm:aMembers, odrg_MLE

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  *
   for x := 1 to len(members) step 1
    do case
    case ( members[x]:ClassName() = 'drgPushButton' )
      if isCharacter( members[x]:event )
        do case
        case ( members[x]:event = 'del_Operace') ; ::pb_del_Operace := members[x]
        case ( members[x]:event = 'del_kusov'  ) ; ::pb_del_Kusov   := members[x]
        endcase
      endif
    endCase
  next

  odrg_MLE := ::dm:has('M->VtabPage1_mle'):odrg
  odrg_MLE:oxbp:setFontCompoundName('11.Arial CE')
  odrg_MLE:oXbp:setColorFG(GRA_CLR_RED)

  odrg_MLE := ::dm:has('M->VtabPage2_mle'):odrg
  odrg_MLE:oxbp:setFontCompoundName('11.Arial CE')
  odrg_MLE:oXbp:setColorFG(GRA_CLR_RED)

  ::pb_del_Operace:disable()
  ::pb_del_Kusov:disable()

  ::df:tabPageManager:showPage(2)
return self

