#include "Common.ch"
#include "drg.ch"
#include "gra.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for UCT_uceterr_SCR **************************************************
CLASS UCT_uceterr_SCR FROM drgUsrClass
exported:
  method  init, drgDialogStart, itemMarked, drgDialogEnd, postDelete

  * uceterr deník, doklad, likvidace
  inline access assign method err_De var err_De
    return if( subStr(uceterr->cErr,1,1) = '1', MIS_ICON_ERR, 0)
  *
  inline access assign method err_Do var err_Do
    return if( subStr(uceterr->cErr,2,1) = '1', MIS_ICON_ERR, 0)
  *
  inline access assign method err_Li var err_Li
    return if( subStr(uceterr->cErr,3,1) = '1', MIS_ICON_ERR, 0)


  * uceterri úèet, symbol, datPoøízení, nákladová struktura
  inline access assign method err_Uc var err_Uc
    return if( subStr(uceterri->cErr,4,1) = '1', MIS_ICON_ERR, 0)
  *
  inline access assign method err_Sy var err_Sy
    return if( subStr(uceterr->cErr,5,1) = '1', MIS_ICON_ERR, 0)
  *
  inline access assign method err_Dp var err_Dp
    return if( subStr(uceterr->cErr,6,1) = '1', MIS_ICON_ERR, 0)
  *
  inline access assign method err_Ns() var err_Ns
    local cErr  := uceterri->cErr
    return if( subStr(cErr,7,1) = '1', MIS_ICON_ERR, 0)

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
*      ::postDelete()
      return .t.
    endcase
    return .f.
hidden:
  var     brow, it_brow, dm, ao_sumCol

  * suma
  inline method sumColumn(cKy)
    local  sumMd  := 0, sumDal := 0
    local  x, ocol

    uceteri_W->(dbSetScope(SCOPE_BOTH, cky), ;
                dbGoTop()                  , ;
                dbeval({ || (sumMd  += uceteri_W->nkcMd, sumDal += uceteri_W->nkcDal) }))

    for x := 1 to len(::ao_sumCol) step 1
      if isObject(ocol := ::ao_sumCol[x])
        ocol:Footing:hide()
        ocol:Footing:setCell(1,if(x = 1, sumMd, sumDal))
        ocol:Footing:show()
      endif
    next
  return
ENDCLASS


method UCT_uceterr_SCR:init(parent)
  ::drgUsrClass:init(parent)

  ::ao_sumCol := {,}
  drgDBMS:open('uceterri',,,,,'uceteri_W')  ;  uceteri_w->(ordSetFocus('UCETPOL4'))
return self


method UCT_uceterr_SCR:drgDialogStart(drgDialog)
  local  x, obro, ocolumn, pa, citem
  *
  local  h_err := {'cdenik' , 'ndoklad', 'ncenzakcel', 'nlikceldok' }


  ::brow := drgDialog:dialogCtrl:oBrowse
  ::dm   := drgDialog:dataManager

  for nBr := 1 to len(::brow) step 1
    obro := ::brow[nBr]:oxbp

    for x := 1 to obro:colCount step 1
      ocolumn := obro:getColumn(x)
      citem   := lower( listAsArray(ocolumn:frmColum,':')[1])

      if AScan(h_err, citem) <> 0
        ocolumn:colorBlock := &('{|a, b, c| UCT_uceterr_cb(a, b, c) }')
      endif

      * patièky
      if nBr = 2
        ::it_brow := obro

        ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
        ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
        ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
        ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
        ocolumn:configure()

        if( 'nkcmd'  $ lower(ocolumN:frmColum), ::ao_sumCol[1] := ocolumN, nil)
        if( 'nkcdal' $ lower(ocolumN:frmColum), ::ao_sumCol[2] := ocolumN, nil)
      endif
    next
  next

  ::brow[2]:oxbp:configure()
return


function UCT_uceterr_cb(xVal,oColumn)
  local  citem := lower( listAsArray(ocolumn:frmColum,':')[1])
  local  cErr  := uceterr->cErr, AClr
  *
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,32,32}), }

  AClr := aCOL_ok

  do case
  case( citem = 'cdenik' )
    AClr := if(subStr(cErr,1,1) = '1', aCOL_er, aCOL_ok)

  case( citem = 'ndoklad')
    AClr := if(subStr(cErr,2,1) = '1', aCOL_er, aCOL_ok)

  case( citem = 'ncenzakcel' .or. citem = 'nlikceldok')
    AClr := if(subStr(cErr,3,1) = '1', aCOL_er, aCOL_ok)
  endcase
return AClr



method UCT_uceterr_SCR:itemMarked()
  local  cky := Upper(uceterr->cdenik) +strZero(uceterr->ndoklad,10)

  uceterri->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())

  ::sumColumn(cKy)
return self


method UCT_uceterr_SCR:drgDialogEnd()

  uceterri->(dbclearScope())
return


method UCT_uceterr_SCR:postDelete()
  local  oinf := fin_datainfo():new('UCTDOKHD'), nsel, nodel := .f.

  if oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Požadujete zrušit úèetní doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_', ;
                         'Zrušení úèetního dokladu ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      uct_uctdokhd_cpy(self)
      nodel := .not. uct_uctdokhd_del()
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Úèetní doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení úèetního dokladu ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel