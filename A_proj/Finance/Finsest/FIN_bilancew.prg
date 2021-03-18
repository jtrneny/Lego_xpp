#include "Common.ch"
#include "DbStruct.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "class.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


// popis v GROUPS(FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK):DPH2009_FAV()) //
#xtranslate  _mFILE  =>  pA\[ 1\]        //_ základní soubor       _
#xtranslate  _mTAG   =>  pA\[ 2\]        //_                 tag   _
#xtranslate  _sFILE  =>  pA\[ 3\]        //_ spojený soubor        _
#xtranslate  _sTAG   =>  Val(pA\[ 4\])   //_                 tag   _
#xtranslate  _sSCOPE =>  pA\[ 5\]        //_                 scope _
#xtranslate  _mFUNC  =>  pA\[ 6\]        //_ funkce pro zpracování _
#xtranslate  _oPROC  =>  pA\[ 7\]        //_ objekt pro procento   _
#xtranslate  _oTHERM =>  pA\[ 8\]        //_ objekt pro teplomìr   _



*
*************** FIN_bilancew **************************************************
CLASS FIN_bilancew FROM drgUsrClass
exported:
  var     datZprac, lsetZprac, stavZprac

  method  init, drgDialogStart, drgDialogEnd
  method  zpracuj_podklady
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      return .f.

    case ( nEvent = drgEVENT_APPEND .or. ;
           nEvent = drgEVENT_EDIT   .or. ;
           nEvent = drgEVENT_DELETE .or. ;
           nEvent = drgEVENT_SAVE        )
      return .t.

    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, ab, xbp_therm
* datové
  var     aEdits, pa_obdZpr, cfilter

  method  m_bila_fil
  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')
ENDCLASS


method FIN_bilancew:init(parent)

  ::drgUsrClass:init(parent)

  ::datZprac  := date()
  ::lsetZprac := .t.
  ::stavZprac := 0
  ::cfilter   := ''

  if( select('bilancew') <> 0, ::cfilter := bilancew->(ads_GetAof()), nil )
  *
  drgDBMS:open('fakvyshd')
  drgDBMS:open('fakvysit')

  * holt jedeme znovu
  if select('bilancew') <> 0
    bilancew->(dbclosearea())
    FErase( drgINI:dir_USERfitm +'bilancew.adt')
    FErase( drgINI:dir_USERfitm +'bilancew.adi')
  endif

  drgDBMS:open('bilancew',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  ::pa_obdZpr := {}
return self


method FIN_bilancew:drgDialogStart(drgDialog)
  local x, pA, members  := drgDialog:oForm:aMembers

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::ab         := drgDialog:oActionBar:members      // actionBar
  *
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  ::aEdits   := {}

  for x := 1 to LEN(members) step 1
   if .not. Empty(members[x]:groups)
     pA  := ListAsArray(members[x]:groups,':')
     nIn := AScan( ::aEDITs,{|X| X[1] = pA[1]})

     if(nIn <> 0, ::aEDITs[nIn,8] := members[x], ;
                  AAdd(::aEDITs, { pA[1], pA[2], pA[3], pA[4], pA[5], pA[6], members[x], NIL }))
    endif
  next
return self


method FIN_bilancew:drgDialogEnd(drgDialog)
  ::msg   := ;
  ::dm    := ;
  ::dc    := ;
  ::df    := NIL

  if( .not. empty(::cfilter), bilancew->(Ads_setAOF(::cfilter), dbgotop()), nil )
return self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method fin_bilancew:zpracuj_podklady()
  local x, pa, oXbp, nreccnt, nkeycnt, nkeyno, prc, ops
  *
  local  in_file, ctag, nstep
  local  paFils, ndny_p, ckeys, lisZal, ancisFak

  ::datZprac  := ::dm:get('M->datZprac' )
  ::lsetZprac := ::dm:get('M->lsetZprac')

  for x := 1 to len(::aedits) step 1
    pa      := ::aedits[x]
    oxbp    := _oTHERM:oxbp
    *
    nSize   := oxbp:currentSize()[1]
    nHight  := oxbp:currentSize()[2] -2

    nreccnt := 0

    in_file := lower(_mFILE)
    ctag    := _mTAG

    drgDBMS:open(in_file)
    (in_file) ->(AdsSetOrder(ctag), dbgoTop() )
    nreccnt := (in_file)->(lastRec())

    nkeycnt := nreccnt // / round(oxbp:currentSize()[1]/(drgINI:fontH -6),0)
    nkeyno  := 1
    nstep   := 0
    *
    paFils    := ::m_bila_fil( in_file, 'bilancew', If( x = 1, NIL, 'x'))


    do while .not. (in_file)->(eof())
      ndny_p := ::datZprac -(in_file)->dsplatFak
      ckeys  := strZero((in_file)->nico, 8)
      lisZal := .f.

      if     in_file = 'fakprihd'
        lisZal := ( (in_file)->nfinTyp = 3 .or. ;
                    (in_file)->nfinTyp = 5      )

      elseif in_file = 'fakvyshd'
        lisZal := ( (in_file)->nfinTyp = 2 .or. ;
                    (in_file)->nfinTyp = 4 .or. ;
                    (in_file)->nfinTyp = 5      )
      endif


      if        (in_file)->dsplatFak <= ::datZprac .and. .not. lisZal
        if (in_file)->nuhrCelFak = 0
          fin_bilancew_db_to_db( in_file, 'bilancew', (x = 1), paFils, ckeys )
          if( x = 1, bilancew->ndny_preks := ndny_p, bilancew->xdny_preks := ndny_p )

        elseif (in_file)->dposUhrFak > ::datZprac .or. ;
               (in_file)->nuhrCelFak < (in_file)->ncenZakCel
          fin_bilancew_db_to_db( in_file, 'bilancew', (x = 1), paFils, ckeys )
          if( x = 1, bilancew->ndny_preks := ndny_p, bilancew->xdny_preks := ndny_p )
        endif
      endif

      (in_file)->(dbskip())
      nkeyno++

      if( x = 2 .and. bilancew->nico = 0, bilancew->nico := val(ckeys), nil )

      nstep++
      if nstep = 25 .or. (in_file)->(eof())
        if( (in_file)->(eof()), nkeyno := nkeyCnt, nil )
        fin_bilancew_pb(oxbp,nkeycnt,nkeyno,nsize,nhight)
        nstep := 0
      endif
    enddo
  next

  *
  ** dokonèení výpoètu
  bilancew->(dbcommit(), ordSetFocus('BILA_03'), dbGoTop() )

  nico     := bilancew->nico
  nkeyCnt  := 0
  ancisFak := { bilancew->ncisFak, bilancew->xcisFak }

  do while .not. bilancew->(eof())
    if nico = bilancew->nico
      nkeyCnt++
      bilancew->npor_zap := nkeyCnt
      bilancew->lind_zap := ( anCisFak[1] <> 0 .and. ancisFak[2] <> 0 )

    else
      nico     := bilancew->nico
      nkeyCnt  := 1
      ancisFak := { bilancew->ncisFak, bilancew->xcisFak }

      bilancew->npor_zap := nkeyCnt
      bilancew->lind_zap := ( anCisFak[1] <> 0 .and. ancisFak[2] <> 0 )
    endif


    bilancew->(dbskip())

    if nico = bilancew->nico
      ancisFak[1] := max( ancisFak[1], bilancew->ncisFak )
      ancisFak[2] := max( ancisFak[2], bilancew->xcisFak )
    endif
  enddo


  bilancew->(ordSetFocus( 'BILA_01' ), dbGoTop())

  sleep(150)
  PostAppEvent(xbeP_Close, drgEVENT_QUIT,,oXbp)
return self


*
** PROGRESS BAR zpracování *****************************************************
method fin_bilancew:m_bila_fil( cDbIn, cDbTo, cFs)
  local  npos, nin, nou
  local  paFils := {}, aDbIn := (cDbIn)->( dbStruct())

  if isNil( cFs)
    aeval( aDbIn, { |x,m| aadd( paFils, { m, (cDbTo) ->( fieldPos( x[DBS_NAME])) } ) })

  else

    for npOs := 1 to len( aDbIn) step 1

      if (cDbTo) ->( fieldPos( left( cFs +aDbIn[ npos, DBS_NAME], 10 ))) <> 0
        cname := left( cFs +aDbIn[ npos, DBS_NAME], 10 )
      else
        cname := cFs +subStr( aDbIn[ npos, DBS_NAME], 2 )
      endif

      if( nou := (cDbTo) ->( fieldPos( cname ))) <> 0
        nin := (cDbIn) ->( fieldPos( aDbIn[ npOs, DBS_NAME] ))
        aadd( paFils, { nin, nou } )
      endif
    next
  endif
return paFils


static function fin_bilancew_db_to_db( cDbIn, cDbTo, lDbApp, paFils, cKeys )
  local  npos, xval
  local  xkeys := cKeys +'0000000000'

  if       lDbApp
    (cDbTo)->(dbAppend())
    (cDbTo)->xcisFak := 0

  elseif   .not. (cDbTo)->(dbseek( xkeys,, 'BILA_02'))
    (cDbTo)->(dbAppend())
    (cDbTo)->xcisFak := 0
  endif

  aeval( paFils, { |x,m| (cDbTo)->(fieldPut( x[2], (cDbIn)->(fieldGet(x[1])))) })
return .t.

static function fin_bilancew_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.


static function fin_bilancew_inf(oXbp,ctext)
  local  oPS, oFont, aAttr, nSize := oxbp:currentSize()[1]

  if .not. empty(oPS := oXbp:lockPS())
    oFont := XbpFont():new():create( "12.Arial CE" )
    aAttr := ARRAY( GRA_AS_COUNT )

    GraSetFont( oPS, oFont )

    aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
    GraSetAttrString( oPS, aAttr )

    GraStringAt( oPS, { 20, 4}, ctext)

    oXbp:unlockPS(oPS)
  endif
return .t.
