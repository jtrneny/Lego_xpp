#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
** pomocná funkce pro slepení údajù souboru osoby
function OSB_glueItems()

  osobyW->cosoba     := if( .not. empty(osobyW->ctitulPred), allTrim(osobyW->ctitulPred) +' ', '' ) + ;
                        allTrim(osobyW->cprijOsob)  +' '                                   + ;
                        allTrim(osobyW->cjmenoOsob) +' '                                   + ;
                        if( .not. empty(osobyW->ctitulZa), ',' +allTrim(osobyW->ctitulZa), '' )

  osobyW->cjmenoRozl := allTrim(osobyW->cprijOsob)  +' ' + ;
                        allTrim(osobyW->cjmenoOsob) +' ' + ;
                                osobyW->crozlJmena

  osobyW->culicCiPop := allTrim(osobyW->culice)     +' ' + ;
                                osobyW->ccisPopis
return nil

*
** pomocná funkce pro kopii ( VAZ ) souborù pro editaci
function OSB_copyfldto_w(from_db, to_db, app_db, main_db, pa_vazRecs)
  local  npos, xval, afrom := (from_db)->(dbstruct()), x
  *
  local  m_db := if( at('_', main_db) = 0, main_db, left( main_db, at('_', main_db) -1) )
  local  nky
  *
  * vazební soubor sám na sebe
  if ( npos := at('_', main_db) ) <> 0
    nky := DBGetVal( from_db +'->n' +upper(m_db) )
  else
    nky  := DBGetVal( from_db +'->' +upper(m_db) )
  endif


  if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)

  if (main_db) ->(dbSeek( nky,, 'ID'))
    aadd( pa_vazRecs, (main_db) ->(RecNo()) )
  endif

  for x := 1 to len(afrom) step 1
    if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec')
      xval := (from_db)->(fieldget(x))
      npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

      if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
    endif
  next
  *
  ** relaèní soubor
  afrom := (to_db)->(dbstruct())
  for x := 1 to len(afrom) step 1
    if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec')

      if( npos := (main_db)->(fieldpos(afrom[x,DBS_NAME]))) <> 0
        (to_db)->(fieldput(x, (main_db)->(fieldget(npos))))
      endif
    endif
  next
  *
  ** èíslo záznamu pøi opravì pro zámek
  if ( npos := (to_db) ->(FieldPos('_nrecor'))) <> 0 .and. .not. (from_db) ->(EOF())
    (to_db) ->(FieldPut(npos, (from_db) ->(RecNo())))
  endif
return nil


function OSB_osoby_cpy(oDialog)
  local  lnewRec    := oDialog:lnewRec
  local  pa_vazRecs := oDialog:pa_vazRecs
  local  nKy        := if( lnewRec, 0, osoby->ncisOsoby )
  *
  local  cf := "nOSOBY = %%", filtrs, pa

  ** tmp **
  drgDBMS:open('osobyW'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazSpojeW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazFirmyW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazUkolyW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('vazDokumW',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('osobySkW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  osobyW->(dbAppend())

  if .not. lnewRec
    filtrs := format( cf, { isNull( osoby->sID, 0) })

    mh_copyFld('osoby', 'osobyW',, .t.)

    vazSpojeX ->( ads_setAof( filtrs ), ;
                  dbgoTop()           , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazSpojeX', 'vazSpojeW', .t., 'spojeni' , pa_vazRecs[1]) } ))

    vazFirmyX ->( ads_setAof( filtrs ), ;
                  dbgoTop()           , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazFirmyX', 'vazFirmyW', .t., 'firmy'   , pa_vazRecs[2]) } ))

    vazUkolyX ->( ads_setAof( filtrs ), ;
                  dbgoTop()           , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazUkolyX', 'vazUkolyW', .t., 'ukoly'   , pa_vazRecs[3]) } ))

    vazDokumX ->( ads_setAof( filtrs ), ;
                  dbgoTop()           , ;
                  dbEval( { || OSB_copyFldTo_W( 'vazDokumX', 'vazDokumW', .t., 'dokument', pa_vazRecs[4] ) } ))

  else


  endif
  *
  ** vyøešíme skupiny osob jak pro INS tak pro ENTER
  drgDBMS:open('c_osobySk')
  drgDBMS:open('osobySk'  )
  drgDBMS:open('osobySkW' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  osobySk->( adsSetOrder('OSOBYSK01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  do while .not. osobySk->(eof())
    mh_COPYFLD('osobySk', 'osobySkW', .t., .t.)
    osobySkW->_setsku := .t.
    osobySk->(dbSkip())
  enddo

  c_osobySk->(AdsSetOrder('C_OSOBSK01'), dbgoTop(), ;
              DbEval( { || if(osobySkW->( dbSeek(upper(c_osobySk->czkr_Skup))), ;
                           nil                                                , ;
                           mh_copyFld('c_osobySk', 'osobySkW', .t., .f.)        ) }))
return nil


function AktSkupOSB( cisosb, skup, stav)
  local key

  drgDBMS:open('osobySk',,,,,'osobySkx' )

  key := StrZero( cisosb, 6) + Upper(skup)

  if osobyskx->( dbSeek(key,,'OSOBYSK02'))
    if Upper(stav) = 'DEL'
      if osobyskx->( dbRlock())
        osobyskx->( dbDelete())
      endif
    endif
  else
    if Upper(stav) = 'NEW'
      osobyskx->( dbAppend())
      osobyskx->nCisOsoby := cisosb
      osobyskx->czkr_Skup := Upper( skup)
    endif
  endif

  osobyskx->(dbUnlock())

return( nil )


function retZdrStav(datum, alias)
  local nsid := 0

  default datum to date()
  default alias to 'zdrstavyx'

  drgDBMS:open('zdrstavy',,,,,'zdrstavyx')
  filtr := format("ncisosoby = %%", {osoby->ncisosoby})
  zdrstavyx->( ads_setAof(filtr),dbgotop())
  zdrstavyx->( AdsSetOrder('ZDRSTAVY05'), ads_setaof(filtr), DBGoBotTom())
  nsid := zdrstavyx->sid
  zdrstavyx->(ads_clearaof(), dbCloseArea())

return(nsid)