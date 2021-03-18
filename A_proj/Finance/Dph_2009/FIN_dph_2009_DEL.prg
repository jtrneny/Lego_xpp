#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "adsdbe.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



**
** CLASS for FIN_dph_2009_DEL ***************************************************
CLASS FIN_dph_2009_DEL FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz
  method  init, destroy, drgDialogStart, dph_Delete

  inline access assign method dotaz() var dotaz
    return 'Zrušit daòovou uzávìrku za období _' +DPH_2009 ->cOBDOBIDAN +'_'

HIDDEN:
  VAR     aEDITs

ENDCLASS


METHOD FIN_dph_2009_DEL:init(parent)
  ::drgUsrClass:init(parent)

  ::zprac  := 0
  ::dotaz  := 'Zrušit daòovou uzávìrku za období _' +DPH_2009 ->cOBDOBIDAN +'_'

  drgDBMS:open('UCETSYS' )
  drgDBMS:open('PRIJATPL')
  drgDBMS:open('USKUTPL' )
  drgDBMS:open('VYKDPH_I')
RETURN self


METHOD FIN_dph_2009_DEL:destroy()
  ::drgUsrClass:destroy()

  ::zprac  := ;
  ::dotaz  := ;
  ::aEDITs := NIL
RETURN


METHOD FIN_dph_2009_DEL:drgDialogStart(drgDialog)
  local x, pA, members  := drgDialog:oForm:aMembers, showDialog
  *
  local ky := upper(dph_2009->culoha) +strZero(dph_2009->nrok,4) +strZero(dph_2009->nobdobi,2)

  ::aEdits   := {}

  FOR x := 1 TO LEN(members)
    IF .not. Empty(members[x]:groups)
      pA  := ListAsArray(members[x]:groups,':')
      nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

      IF(nIn <> 0, ::aEDITs[nIn,5] := members[x], AAdd(::aEDITs, { pA[1], pA[2], pA[3], members[x], NIL }))
    ENDIF
  NEXT

  ucetsys->(dbseek(ky,,'UCETSYS3'))

  showDialog := (dph_2009->(rlock()) .and. ;
                 ucetsys ->(rlock()) .and. ;
                 prijatpl->(flock()) .and. uskutpl->(flock()))
  showDialog := (showDialog .and. .not. dph_2009->(eof()))

  if .not. showDialog
    if dph_2009->(eof())
      drgDialog:parent:oMessageBar:writeMessage('Nelze zrušit DAÒOVOU UZÁVÌRKU, není zpracována ...',DRG_MSG_WARNING)
    else
      drgDialog:parent:oMessageBar:writeMessage('Nelze zrušit DAÒOVOU UZÁVÌRKU, blokováno uživatelem ...',DRG_MSG_WARNING)
    endif

    dph_2009->(dbunlock())
     ucetsys ->(dbunlock())
      prijatpl->(dbunlock())
       uskutpl ->(dbunlock())
  endif
RETURN showDialog


**
method FIN_dph_2009_DEL:dph_Delete()
  local  x, nor, cin, cky := DPH_2009 ->cOBDOBIDAN, oXbp, prc
  *
  local  nreccnt, nkeycnt, nkeyno

  if dph_2009->(rlock()) .and. ucetsys->(rlock()) .and. prijatpl->(flock()) .and. uskutpl->(flock())
    for x  := 1 to len(::aedits) step 1
      cin     := ::aedits[x,1]
      nor     := val(::aedits[x,2])
      cex     := cky +::aedits[x,3]
      oxbp    := ::aedits[x,5]:oxbp
      nreccnt := 0

      (cin)->(AdsSetOrder(nor)          , ;
              dbsetscope(SCOPE_BOTH,cex), ;
              dbgotop()                 , ;
              dbeval({||nreccnt++})     , ;
              dbgotop()                   )

      nkeycnt := nreccnt / round(oXbp:currentSize()[1]/(drgINI:fontH -6),0)
      nkeyno  := 1

      do while .not. (cin)->(eof())
        prc := fin_dph_2009_pb(oxbp,nkeycnt,nkeyno,nreccnt)
        ::aedits[x,4]:oxbp:setcaption(prc)

        (cin)->(rlock(), dbdelete(), dbunlock(), dbskip())
        nkeyno++
      enddo

      (cin)->(dbclearscope())
    next
  endif

  * modifikace ucetsys
  ucetsys->cotvkdo   := SysConfig('SYSTEM:cUSERABB')
  ucetsys->dotvdat   := date()
  ucetsys->cotvcas   := time()
  ucetsys->lzavrend  := .f.

  dph_2009->(dbdelete())
   ucetsys ->(dbunlock())
    prijatpl->(dbunlock())
     uskutpl ->(dbunlock())

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return .t.


**
** PROGRESS BAR zpracování *****************************************************
FUNCTION FIN_dph_2009_pb(oXbp,nKeyCNT,nKeyNO, nRecCNT, lIsRED)
  LOCAL  oPS
  LOCAL  aAttr[GRA_AA_COUNT], aPos := {0,0}
//
  LOCAL  nCharINF, prc, val
  LOCAL  lOk := .F.

  val := min(100, Int(100 * nKeyCNT/nKeyNO))
  prc := IF( nKeyNO = nRecCNT, '100 %', AllTrim(Str(val)) + '%')

  IF !EMPTY(oPS := oXbp:lockPS())
    aAttr [ GRA_AA_COLOR ] := If( IsNULL(lIsRED), GRA_CLR_BLUE, GRA_CLR_RED )
    GraSetAttrArea( oPS, aAttr )

    nCharINF := Int( nKeyNO/ nKeyCNT )

    FOR nIn := 1 TO nCharINF
      GraBox( oPS, {aPos[1],2}, {aPos[1]+ drgINI:fontH -6, drgINI:fontH -3}, GRA_FILL)
      aPos[1] += (drgINI:fontH -5)
    NEXT

    oXbp:unlockPS(oPS)
  ENDIF
  IF( nKeyNO == nRecCNT, oXbp:SetCaption('Dokonèeno ...'), NIL )
RETURN prc
