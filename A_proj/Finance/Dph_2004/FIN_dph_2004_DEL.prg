#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "adsdbe.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



**
** CLASS for FIN_dph_2004_DEL ***************************************************
CLASS FIN_dph_2004_DEL FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz
  method  init, destroy, drgDialogStart, dph_Delete

HIDDEN:
  VAR     aEDITs

ENDCLASS


METHOD FIN_dph_2004_DEL:init(parent)
  ::drgUsrClass:init(parent)

  ::zprac  := 0
  ::dotaz  := 'Zrušit daòovou uzávìrku za období _' +DPH_2004 ->cOBDOBIDAN +'_'

  drgDBMS:open('UCETSYS' )
  drgDBMS:open('PRIJATPL')
  drgDBMS:open('USKUTPL' )
  drgDBMS:open('VYKDPH_I')
RETURN self


METHOD FIN_dph_2004_DEL:destroy()
  ::drgUsrClass:destroy()

  ::zprac  := ;
  ::dotaz  := ;
  ::aEDITs := NIL
RETURN


METHOD FIN_dph_2004_DEL:drgDialogStart(drgDialog)
  local x, pA, members  := drgDialog:oForm:aMembers
  *
  local ky := upper(dph_2004->culoha) +strZero(dph_2004->nrok,4) +strZero(dph_2004->nobdobi,2)

  ::aEdits   := {}

  FOR x := 1 TO LEN(members)
    IF .not. Empty(members[x]:groups)
      pA  := ListAsArray(members[x]:groups,':')
      nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

      IF(nIn <> 0, ::aEDITs[nIn,5] := members[x], AAdd(::aEDITs, { pA[1], pA[2], pA[3], members[x], NIL }))
    ENDIF
  NEXT

  ucetsys->(dbseek(ky,,'UCETSYS3'))

  showDialog := (dph_2004->(rlock()) .and. ;
                 ucetsys ->(rlock()) .and. ;
                 prijatpl->(flock()) .and. uskutpl->(flock()))

  if .not. showDialog
    drgDialog:parent:oMessageBar:writeMessage('Nelze zrušit DAÒOVOU UZÁVÌRKU, blokováno uživatelem ...',DRG_MSG_WARNING)
  endif
RETURN showDialog


**
method FIN_dph_2004_DEL:dph_Delete()
  local  x, nor, cin, cky := DPH_2004 ->cOBDOBIDAN, oXbp, prc
  *
  local  nreccnt, nkeycnt, nkeyno

  if dph_2004->(rlock()) .and. ucetsys->(rlock()) .and. prijatpl->(flock()) .and. uskutpl->(flock())
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
        prc := fin_dph_2004_pb(oxbp,nkeycnt,nkeyno,nreccnt)
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

  dph_2004->(dbdelete())
   ucetsys ->(dbunlock())
    prijatpl->(dbunlock())
     uskutpl ->(dbunlock())

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return .t.


**
** PROGRESS BAR zpracování *****************************************************
FUNCTION FIN_dph_2004_pb(oXbp,nKeyCNT,nKeyNO, nRecCNT, lIsRED)
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
