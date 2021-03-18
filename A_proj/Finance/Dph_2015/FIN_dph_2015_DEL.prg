#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "adsdbe.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
** CLASS for FIN_dph_2015_DEL ***************************************************
CLASS FIN_dph_2015_DEL FROM drgUsrClass
EXPORTED:
  var     zprac, dotaz
  method  init, destroy, drgDialogStart, dph_Delete

  inline access assign method dotaz() var dotaz
    return 'Zrušit daòovou uzávìrku za období _ ' +str(dph_2015->nobdobi,2) +'/' +str(dph_2015->nrok,4) +' _'

HIDDEN:
  VAR     aEDITs

ENDCLASS


METHOD FIN_dph_2015_DEL:init(parent)
  ::drgUsrClass:init(parent)

  ::zprac  := 0
  ::dotaz  := 'Zrušit daòovou uzávìrku za období _' +DPH_2015 ->cOBDOBIDAN +'_'

  drgDBMS:open('UCETSYS' )
  drgDBMS:open('PRIJATPL')
  drgDBMS:open('USKUTPL' )
  drgDBMS:open('VYKDPH_I')
RETURN self


METHOD FIN_dph_2015_DEL:destroy()
  ::drgUsrClass:destroy()

  ::zprac  := ;
  ::dotaz  := ;
  ::aEDITs := NIL
RETURN


METHOD FIN_dph_2015_DEL:drgDialogStart(drgDialog)
  local x, pA, members  := drgDialog:oForm:aMembers, showDialog
  *
  local ky := upper(dph_2015->culoha) +strZero(dph_2015->nrok,4) +strZero(dph_2015->nobdobi,2)

  ::aEdits   := {}

  FOR x := 1 TO LEN(members)
    IF .not. Empty(members[x]:groups)
      pA  := ListAsArray(members[x]:groups,':')
      nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

      if nin <> 0
        if isNumber(members[x]:oxbp:caption)
          ::aEDITs[nIn,6] := members[x]
        else
          ::aEDITs[nIn,5] := members[x]
        endif
      else
        AAdd( ::aEDITs, { pA[1], pA[2], pA[3], members[x], NIL, NIL } )
      endif
    ENDIF
  NEXT

  pa := ::aEDITs
  aeval( pa, { |i| i[6]:oxbp:hide() } )

  ucetsys->(dbseek(ky,,'UCETSYS3'))

  showDialog := (dph_2015->(rlock()) .and. ;
                 ucetsys ->(rlock()) .and. ;
                 prijatpl->(flock()) .and. uskutpl->(flock()))
  showDialog := (showDialog .and. .not. dph_2015->(eof()))

  if .not. showDialog
    if dph_2015->(eof())
      drgDialog:parent:oMessageBar:writeMessage('Nelze zrušit DAÒOVOU UZÁVÌRKU, není zpracována ...',DRG_MSG_WARNING)
    else
      drgDialog:parent:oMessageBar:writeMessage('Nelze zrušit DAÒOVOU UZÁVÌRKU, blokováno uživatelem ...',DRG_MSG_WARNING)
    endif

    dph_2015->(dbunlock())
     ucetsys ->(dbunlock())
      prijatpl->(dbunlock())
       uskutpl ->(dbunlock())
  endif
RETURN showDialog


**
method FIN_dph_2015_DEL:dph_Delete()
  local  x, nor, cin, cky := DPH_2015 ->cOBDOBIDAN, oXbp, ostate, prc
  *
  local  nreccnt, nkeycnt, nkeyno
  local  cc    := str(dph_2015->nobdobi,2) +'/' +str(dph_2015->nrok,4)
  local  ctext := 'Zrušení daòové uzávìrky období _ ' +cc +' _'   +CRLF + ;
                  'Pøijatá plnìní    , zrušeno %PRIJATPL záznamù' +CRLF + ;
                  'Uskuteènìná plnìní, zrušeno %USKUTPL  záznamù' +CRLF + ;
                  'Daòové období _' +cc+ '_ %zavrend'


  if dph_2015->(rlock()) .and. ucetsys->(rlock()) .and. prijatpl->(flock()) .and. uskutpl->(flock())
    for x  := 1 to len(::aedits) step 1
      cin     := ::aedits[x,1]
      nor     := val(::aedits[x,2])
      cex     := cky +::aedits[x,3]
      oxbp    := ::aedits[x,5]:oxbp
      ostate  := ::aedits[x,6]:oxbp
      nreccnt := 0

      (cin)->(AdsSetOrder(nor)          , ;
              dbsetscope(SCOPE_BOTH,cex), ;
              dbgotop()                 , ;
              dbeval({||nreccnt++})     , ;
              dbgotop()                   )

      nkeycnt := nreccnt // / round(oXbp:currentSize()[1]/(drgINI:fontH -6),0)
      nkeyno  := 1

      do while .not. (cin)->(eof())
        prc := fin_dph_2015_pb(oxbp,nkeycnt,nkeyno,nreccnt)
        ::aedits[x,4]:oxbp:setcaption(prc)

        (cin)->(rlock(), dbdelete(), dbunlock(), dbskip())
        nkeyno++
      enddo

      ostate:show()
      ctext := strTran( ctext, '%' +cin, str(nreccnt,10))

      (cin)->(dbclearscope())
    next
  endif

  * modifikace ucetsys
  ucetsys->cotvkdo   := SysConfig('SYSTEM:cUSERABB')
  ucetsys->dotvdat   := date()
  ucetsys->cotvcas   := time()
  ucetsys->lzavrend  := .f.

  ctext := strTran( ctext, '%zavrend', if( .not. ucetsys->lzavrend, 'OTEVØENO', 'UZAVØENO') )
  mh_wrtZmena( 'ucetSys',,, ctext )

  dph_2015->(dbdelete())
   ucetsys ->(dbunlock())
    prijatpl->(dbunlock())
     uskutpl ->(dbunlock())

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return .t.


**
** PROGRESS BAR zpracování *****************************************************
function FIN_dph_2015_pb(oxbp, nkeyCnt, nkeyNo, ncolor)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  nSize   := oxbp:currentSize()[1]
  local  nHight  := oxbp:currentSize()[2] -2

  default ncolor to GRA_CLR_PALEGRAY

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  GraGradient( ops                 , ;
               { newPos+1,2 }      , ;
               { { nsize, nhight }}, ;
               {ncolor,0,0}, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return prc