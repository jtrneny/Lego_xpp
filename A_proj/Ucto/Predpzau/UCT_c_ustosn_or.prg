#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



**
** CLASS for FRM UCT_c_uctosn **************************************************
CLASS UCT_c_uctosn FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart, eventHandled
  METHOD  postValidate, onSave
  *
  method  treeViewInit

HIDDEN:
  method  postLastField
  METHOD showGroup

  VAR    panGroup, members, msg, nState       // 0 - inBrowse  1 - inEdit  2 - inAppend
  var    oTree
ENDCLASS


METHOD UCT_c_uctosn:init(parent)
  ::drgUsrClass:init(parent)

  ::panGroup := '1'
  ::nState   := 0

  drgDBMS:open('C_SKUPUC')
  drgDBMS:open('C_UCTOSN')  ;  drgDBMS:open('c_uctosn',,,,,'c_uctosnw')
  drgDBMS:open('CONFIG'  )

  ** tree
  drgDBMS:open('c_triduc')
  drgDBMS:open('c_grupuc')
  drgDBMS:open('c_syntuc')
  drgDBMS:open('c_uctosn',,,,,'c_uctosnT')
RETURN self


method uct_c_uctosn:treeViewInit(odrg)
  local cky
  local cky_trid, cky_grup, cky_synt
  local o_triduc, o_grupuc, o_syntuc, o_uctosn

  ::oTree := odrg:oXbp

  do while .not. c_triduc->(eof())
    o_triduc := XbpTreeViewItem():New()
    o_triduc:caption := c_triduc->cucet + c_triduc->cnaz_uct
    o_triduc:create()

    ::oTree:rootItem:addItem(o_triduc)

    cky_trid := strTran(c_triduc->cucet, ' ', '')
    c_grupuc->(ordSetFocus('CGRUPUC1'), dbsetScope(SCOPE_BOTH, cky_trid), dbgotop())

    do while .not. c_grupuc->(eof())
      o_grupuc := XbpTreeViewItem():New()
      o_grupuc:caption := c_grupuc->cucet +c_grupuc->cnaz_uct
      o_grupuc:create()

      o_triduc:addItem(o_grupuc)

        cky_grup := strTran(c_grupuc->cucet, ' ', '')
        c_syntuc->(ordSetFocus('CSYNTUC1'), dbsetScope(SCOPE_BOTH, cky_grup), dbgotop())

        do while .not. c_syntuc->(eof())
          o_syntuc := XbpTreeViewItem():New()
          o_syntuc:caption := c_syntuc->cucet +c_syntuc->cnaz_uct
          o_syntuc:create()

          o_grupuc:addItem(o_syntuc)

            cky_synt := strTran(c_syntuc->cucet, ' ', '')
            c_uctosnT->(ordSetFocus('UCTOSN1'), dbsetScope(SCOPE_BOTH, cky_synt), dbgotop())

            do while .not. c_uctosnT->(eof())
              o_uctosn := XbpTreeViewItem():New()
              o_uctosn:caption := c_uctosnT->cucet +'  ' +c_uctosnT->cnaz_uct
              o_uctosn:create()

              o_syntuc:addItem(o_uctosn)

              c_uctosnT->(dbskip())
            enddo

          c_syntuc->(dbskip())
        enddo
        c_syntuc->(dbclearScope())

      c_grupuc->(dbskip())
    enddo
    c_grupuc->(dbclearScope())


    c_triduc->(dbskip())
  enddo
return self



METHOD UCT_c_uctosn:drgDialogStart(drgDialog)
  ::members  := drgDialog:oForm:aMembers
  ::msg      := drgDialog:oMessageBar             // messageBar

  ::showGroup()
RETURN self


METHOD UCT_c_uctosn:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL  nBRo, nCOLn, nRESc, nIn
  LOCAL  cC
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  dbArea   := ALIAS(dc:dbArea)

  DO CASE
  CASE (nEvent = xbeBRW_ItemMarked)
    BEGIN SEQUENCE
      FOR nBRo := 1 TO LEN(dc:oBrowse)
        FOR nCOLn := 1 TO dc:oBrowse[nBRo]:oXbp:colCount
          IF dc:oBrowse[nBRo]:oXbp:getColumn(nCOLn) = oXbp:parent
    BREAK
          ENDIF
        NEXT
      NEXT
    END SEQUENCE

    IF nBRo <= 2
      dc:oaBrowse                             := dc:oBrowse[nBRo]
      dc:drgDialog:oForm:oLastDrg             := dc:oaBrowse
      dc:dataManager:drgDialog:lastXbpInFocus := dc:oaBrowse:oXbp
      dc:dbArea                               := dc:oaBrowse:dbArea

      SetAppFocus(dc:oaBrowse:oXbp)

      IF dbArea <> ALIAS(dc:dbArea)
        ::panGroup := STR(nBRo,1)
        ::showGroup()
      ENDIF
    ENDIF
    ::nState := 0
    RETURN .F.

  CASE (nEvent = xbeP_Selected)
    ::postValidate(oXbp:cargo:oVar,.T.)
    RETURN .F.

  case(nevent = drgEVENT_EDIT  .or. nevent = drgEVENT_APPEND)
    cc := IF(dbArea = 'C_UCTOSN', 'C_UCTOSN->cUCET', 'C_SKUPUC->cSKUPUCT')

    if nevent = drgEVENT_APPEND
      nRECs := (dbarea)->(recno())
               (dbarea)->(dbgoto(0))
               ::drgDialog:dataManager:refresh()
               (dbarea)->(dbgoto(nRECs))
      ::nstate := 2
    else
      ::nstate := 1
    endif
    ::drgDialog:oForm:setNextFocus(cc,, .T. )
    return .t.

  CASE nEvent = drgEVENT_DELETE
    IF dbArea = 'C_UCTOSN' .and. drgIsYESNO( 'Zrušit úèet ->' +AllTrim(C_UCTOSN ->cUCET) +'<- ?')
      IF( C_UCTOSN ->( DbRLock()), ;
          C_UCTOSN ->(DbDelete()), ;
          drgMsgBox('Nelze uložit zmìny, BLOKOVÁNO uživatelem ...') )
      ::drgDialog:dialogCtrl:refreshPostDel()
    ENDIF
    C_SKUPUC ->( DbUnlock())
    RETURN .T.

  CASE nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::drgDialog:oForm:setNextFocus(IF(dbArea = 'C_UCTOSN',2,3),, .T. )
      RETURN .T.
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


METHOD UCT_c_uctosn:postValidate(drgVar,lSelected)                                     // kotroly a výpoèty
  Local  lOk  := .T., lVALUe
  Local  dm   := ::dataManager
  Local  name := drgVar:name

  DEFAULT lSelected TO .F.

  IF lSelected
    IF (('C_UCTOSN->LNAKLUCT'  = name) .or. ('C_UCTOSN->LVYNOSUCT' = name) .or. ;
        ('C_UCTOSN->LAKTIVUCT' = name) .or. ('C_UCTOSN->LPASIVUCT' = name) .or. ;
        ('C_UCTOSN->LZAVERUCT' = name) .or. ('C_UCTOSN->LPODRZUCT' = name) .or. ;
        ('C_UCTOSN->LNATURUCT' = name))

       lVALUe := !drgVar:get()
       dm:has('C_UCTOSN->LNAKLUCT' ):set(.F.)
       dm:has('C_UCTOSN->LVYNOSUCT'):set(.F.)
       dm:has('C_UCTOSN->LAKTIVUCT'):set(.F.)
       dm:has('C_UCTOSN->LPASIVUCT'):set(.F.)
       dm:has('C_UCTOSN->LZAVERUCT'):set(.F.)
       dm:has('C_UCTOSN->LPODRZUCT'):set(.F.)
       dm:has('C_UCTOSN->LNATURUCT'):set(.F.)

       drgVar:set(lValue)
    ENDIF

  else
    do case
    case(name = 'C_UCTOSN->CUCET' .and. drgVar:itemChanged())
      if c_uctosnw->(dbseek(upper(drgvar:value),, AdsCtag(1) ))
        ::msg:writeMessage('Duplicitní _ÚÈET_ nelze zadat ...',DRG_MSG_ERROR)
        lok := .f.
      endif
    endcase
  ENDIF
RETURN lOk


METHOD UCT_c_uctosn:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  * ukládáme C_UCTOSN - C_SKUPUC na posledním prvku

  IF(::panGroup = '1' .and. ('C_SKUPUC->cNAZSKUPUC' = name), name := 'C_UCTOSN->LMIMORUCT', NIL)

  DO CASE
  CASE( 'C_UCTOSN->cNAZ_UCT'    = name)
     ::drgDialog:oForm:setNextFocus('C_UCTOSN->LNAKLSTR',, .T. )

  CASE( 'C_UCTOSN->LMIMORUCT'   = name)
    IF lZMENa .and. If( ::nState == 2, ADDrec('C_UCTOSN'), REPLrec( 'C_UCTOSN'))
      ::dataManager:save()
      C_UCTOSN ->cUSERABB  := SYSCONFIG('SYSTEM:cUSERABB')
      C_UCTOSN ->dDATZMENY := DATE()
    ENDIF
    ::drgDialog:oForm:setNextFocus(1,, .T.)

  CASE( 'C_SKUPUC->cNAZSKUPUC'  = name)
    IF lZMENa .and. If( ::nState == 2, ADDrec('C_SKUPUC'), REPLrec( 'C_SKUPUC'))
      ::dataManager:save()
      C_SKUPUC ->cUSERABB  := SYSCONFIG('SYSTEM:cUSERABB')
      C_SKUPUC ->dDATZMENY := DATE()
    ENDIF
    ::drgDialog:oForm:setNextFocus(2,, .T.)
  ENDCASE

  C_UCTOSN ->( DbUnLock())
  C_SKUPUC ->( DbUnLock())
RETURN .T.


METHOD UCT_c_uctosn:onSave()
  Local  cC

  cC := IF(::panGroup = '1', 'C_UCTOSN->LMIMORUCT', 'C_SKUPUC->cNAZSKUPUC')
  ::postLastField(::dataManager:has(cC))
RETURN .T.


// HIDDEN METHOD and FUNCTION //
METHOD UCT_c_uctosn:showGroup()
  Local  iEdit, x

  FOR x := 1 TO LEN(::members)
    If IsMemberVar(::members[x],'groups') .and. IsNull(::members[x]:groups,'') <> ''
      isEdit := ( At(::panGroup,::members[x]:groups) == 1)

      IF ::members[x]:groups <> ::panGroup
        IF(::members[x]:groups = '12', NIL , ::members[x]:oXbp:hide() )
        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := isEdit)
      ELSE
        ::members[x]:oXbp:show()
        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := isEdit)
      ENDIF
    ENDIF
  NEXT
RETURN self