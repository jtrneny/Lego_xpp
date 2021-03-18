//
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
* Pro TISK
*
********************** MZD_prescasy *****************************************


function fpotvrzup(poradi)
  local  filtr
  local  aret := {}
  local  n

  drgDBMS:open('mzddavhd',,,,,'mzddavhdw')

  filtr := Format("nRok >= %% .and. noscisprac = %% .and. cdenik = 'MN'", {msprc_mo ->nrok-2,msprc_mo ->noscisprac})
  mzddavhdw ->( ads_setaof(filtr), OrdSetFocus('ID'), dbGoTop())

   do while !mzddavhdw ->( Eof())
     if ( n := aScan( aret,{|X| X[1] = mzddavhdw->nporadi })) = 0
       AAdd( aret,{mzddavhdw->nporadi,mzddavhdw->dDatumOD,mzddavhdw->dDatumDO })
       mzddavhdw ->( dbSkip())
     else
       aret[n,2] := mzddavhdw->dDatumOD
       aret[n,3] := mzddavhdw->dDatumDO
     endif
     mzddavhdw ->( dbSkip())
   enddo
  mzddavhdw ->( ads_clearaof(), dbGoTop())

  nod := if( Empty( aret), 1, Len( aret)+1 )

  if Len(aret) <= 4
    for n := nod  to 4
      AAdd( aret,{999, ctod('  .  .    '), ctod('  .  .    ')})
    next
  endif

return( aret[poradi])