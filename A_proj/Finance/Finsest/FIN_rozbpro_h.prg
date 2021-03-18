#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys', 'rozbpz_h', 'rozbpz_i' }


function FIN_rozbpro_h(typ)
  local  xRETval := ''
  local  key, keyobj
  local  pocet := 0


  drgDbms:open('fakvysit')  ;  fakvysit->(AdsSetOrder('FVYSIT14'))
  drgDBMS:open('tmfavyhdw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  key    := StrZero(fakvysit->nrok,4)+StrZero(fakvysit->ndoklad,10)
  keyobj := StrZero(fakvysit->nrok,4)+StrZero(fakvysit->ndoklad,10)+fakvysit->ccislobint

  filtr     := format( "nrok >= %%", { Year(Date())-1})
  fakvysit->( ads_setAof(filtr),dbgoTop())

  do while .not. fakvysit->(Eof())
    if keyobj <> StrZero(fakvysit->nrok,4)+StrZero(fakvysit->ndoklad,10)
      pocet++
      keyobj := StrZero(fakvysit->nrok,4)+StrZero(fakvysit->ndoklad,10)+fakvysit->ccislobint
    endif

    if key <> StrZero(fakvysit->nrok,4)+StrZero(fakvysit->ndoklad,10)
      tmfavyhdw ->(dbAppend())

      tmfavyhdw ->nrok      := Val( SubStr(key,1,4))
      tmfavyhdw ->ndoklad   := Val( SubStr(key,5))
      tmfavyhdw ->npocetobj := pocet
      pocet                 := 0
    endif
    fakvysit->(dbSkip())
  enddo

  tmfavyhdw ->nrok      := Val( SubStr(key,1,4))
  tmfavyhdw ->nobdobi   := Val( SubStr(key,5,2))
  tmfavyhdw ->ndoklad   := Val( SubStr(key,7))
  tmfavyhdw ->npocetobj := pocet

  fakvysit->(dbCloseArea())
   tmfavyhdw->(dbCloseArea())

return nil