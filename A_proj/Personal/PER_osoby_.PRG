#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"



function PER_osoby_cpy(oDialog)
  local  lnewRec    := oDialog:lnewRec
  local  pa_vazRecs := oDialog:pa_vazRecs
  local  nKy        := if( lnewRec, 0, osoby->ncisOsoby )
  *
  local  cf := "OSOBY = %%", filtrs, pa

  ** tmp **
  drgDBMS:open('osobyW'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazOsobyW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('osoby_RpW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  drgDBMS:open('duchodyW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('prsmldohW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vzdelaniW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('lekprohlW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('skoleniW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

*** ven
  drgDBMS:open('vazLekprW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazSkolW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  osobyW->(dbAppend())

  if .not. lnewRec
    filtrs := format( cf, { isNull( osoby->sID, 0) })

    mh_copyFld('osoby', 'osobyW',, .t.)
    aadd( pa_vazRecs[1], osoby->(recNo()) )

    vazOsobyX  ->(ads_setAof(      filtrs ), ;
                  dbgoTop()                , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazOsobyX', 'vazOsobyW', .t., 'osoby_Rp' , pa_vazRecs[1]) } ))

    duchody    ->(dbgoTop()                , ;
                  dbEval( { || mh_copyFld('duchody' , 'duchodyW' , .t., .t.) }) )

    prSmlDoh   ->(dbgoTop()                , ;
                  dbEval( { || mh_copyFld('prsmldoh', 'prsmldohW', .t., .t.) }) )

    vzdelani   ->(dbgoTop()                , ;
                  dbEval( { || mh_copyFld('vzdelani', 'vzdelaniW', .t., .t.) }) )

    lekprohl   ->(dbgoTop()                , ;
                  dbEval( { || mh_copyFld('lekprohl', 'lekprohlW', .t., .t.) }) )

    skoleni    ->(dbgoTop()                , ;
                  dbEval( { || mh_copyFld('skoleni' , 'skoleniW' , .t., .t.) }) )


**** ven
    vazLekprX  ->(ads_setAof( "n" +filtrs ), ;
                  dbgoTop()                , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazLekprX', 'vazLekprW', .t., 'lekprohl' , pa_vazRecs[2]) } ))

    vazSkolX   ->(ads_setAof( "n" +filtrs ), ;
                  dbgoTop()                , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazSkolX' , 'vazSkolW' , .t., 'skoleni'  , pa_vazRecs[3]) } ))

  else


  endif
return nil