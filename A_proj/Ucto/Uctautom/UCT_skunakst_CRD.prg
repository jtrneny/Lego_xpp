#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "std.ch"
#include "drgRes.ch"

#include "..\A_main\ace.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"

Static nHandle
Static nRok, nObdobi, nObdDo
Static lNetWare
Static lTesty
Static cNAKpo2
Static netAdr, homAdr
Static cUcetPolS


*
** CLASS for UCT_skunakst_CRD **************************************************
CLASS UCT_skunakst_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  dir
  METHOD  rozpustit
  METHOD  kalkulace
//  METHOD  importmdav
  method  ucetsys_ks

  METHOD  destroy

  VAR     ddatzprac
  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg
  var cdirW

ENDCLASS


METHOD UCT_skunakst_CRD:init(parent)

  nRok    := uctOBDOBI:UCT:nrok
  nObdobi := uctOBDOBI:UCT:nobdobi
  nObdDO  := uctOBDOBI:UCT:nobdobi

  ::ddatzprac := mh_LastODate( nROK, nOBDOBI)
  drgDBMS:open('kalkzem',.t.)

  ::drgUsrClass:init(parent)

RETURN self


METHOD UCT_skunakst_CRD:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  ::cdirW  := drgINI:dir_USERfitm +userWorkDir() +'\'

  netAdr := drgINI:dir_DATA
  homAdr := drgINI:dir_USERfitm

  myCreateDir( ::cdirW )

RETURN self

                                  *
*****************************************************************
METHOD UCT_skunakst_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

/*
  DO CASE
  CASE(name = 'users->cosoba')
    if( !Empty( value) .and. (::newRec .or. changed)                         ;
          ,lOK := ::returnOsoba(value), NIL)

  CASE(name = 'users->cuser')
    IF Empty(value)
      ::msg:writeMessage('Zkratka uživatele je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    ELSE
      IF ::newRec .AND. USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,10)),, AdsCtag(1) ))
        ::msg:writeMessage('Zkratka uživatele již existuje, musíte zadat jinou ....',DRG_MSG_ERROR)
        lOk := .F.
      ENDIF
    ENDIF

  CASE(name = 'users->cprihljmen')
    if Empty(value)
      ::msg:writeMessage('Pøihlašovací jméno je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      if USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,20)),, AdsCtag(3) ))
        ::msg:writeMessage('Pøihlašovací jméno již existuje, musíte zadat jiné ....',DRG_MSG_ERROR)
        lOk := .F.
      endif
    endif

  CASE(name = 'm->paswordcheck')
    IF value <> ::dataManager:get("users->cpassword")
      ::msg:writeMessage('Chybnì zadané heslo ...',DRG_MSG_ERROR)
      lOk := .F.
    ENDIF

  ENDCASE
*/
  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk


METHOD UCT_skunakst_CRD:onSave()
  LOCAL aUsers
  LOCAL n


RETURN .T.


METHOD UCT_skunakst_CRD:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD UCT_skunakst_CRD:destroy()
  ::drgUsrClass:destroy()

RETURN NIL



//  základní funkce pro rozpuštìní pøímých nákladù na stroje

METHOD UCT_skunakst_CRD:rozpustit()
  Local cScope
  Local cVnSazStr := netAdr + 'C_VnSaSt'
  Local cMdav     := netAdr + 'M_Dav'
  Local cUcetPOL  := netAdr + 'UcetPol'
  Local cUcetPOLa := netAdr + 'UcetPola'
  Local cUcetPOLy := netAdr + 'UcetPoly'
  Local cUcetKUM  := netAdr + 'UcetKum'
  Local cMDavI    := homAdr + 'M_DavI'
  Local cUcetPolI := homAdr + 'UcetPolI'
  Local cUcetPoIa := homAdr + 'UcetPola'
  Local cTMP      := homAdr
  Local cTMPdav   := homAdr + 'TmpDav'
  Local cTMPdavI  := homAdr + 'TmpDav'
  Local cUcPSNak1 := homAdr + 'UcPSNak1'
  Local cUcPSNak2 := homAdr + 'UcPSNak2'
  Local cUcPSNak3 := homAdr + 'UcPSNak3'
  Local cUcPVVyn1 := homAdr + 'UcPVVyn1'
  Local cUcPVNak1 := homAdr + 'UcPVNak1'
  Local cUcPVNak2 := homAdr + 'UcPVNak2'
  Local cTmpVNUct := homAdr + 'TmpVNUct'
  Local cUcVNUct  := homAdr + 'UcVNUct'
  Local cTUcetPQA := homAdr + 'TUcetPQA'
  Local nRecCount1 := 0, nRecCount2 := 0, nCount, n
  Local aOutDEFHd
  Local aOutDEFIt
  Local cVst, cVyst
  Local xKEY, filter
  LOCAL nField
  LOCAL nFieldTMP
  Local cTXTKALK
  LOCAL cTYP, nX, cX, nSkuNakSt, nDokl, nHodCelkem
  LOCAL lKONEC := .F.
  LOCAL nWW1 := 0, nWW2 := 0
  LOCAL nStor960, nStor961, nStor962, nStor970
  LOCAL cnazPo_3
  local obdZpr

  drgServiceThread:progressStart( drgNLS:msg('Vytváøím podklady pro kalkulace'), 4)


  lNetWare := .T.
  nStor960 := nStor961 := nStor962 := nStor970 := 0

  obdZpr  := strzero(nrok,4) +strzero(nobdobi,2)
  cUcetPolS := homAdr + 'UcetPolS'

//  dbUseArea( .t., "FOXCDX", ( cMdav),,     if( .T. .or. .F., lNetWare, NIL ), .f. )
//  dbUseArea( .t., "FOXCDX", ( cUcetPOL),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

  drgDBMS:open('mzddavit',,,,,'m_dav')
  drgDBMS:open('ucetpol')

  drgDBMS:open('ucetpola')
  drgDBMS:open('ucetkum')
  ucetkum ->( OrdSetFOCUS( AdsCtag( 1 )))
  drgDBMS:open('c_vnsast')
  c_vnsast ->( OrdSetFOCUS( AdsCtag( 1)))

  nCount := 1


  ucetpola->(ads_setaof( format("nrok = %% .and. ( cdenik = 'YQ' .or. cdenik = 'YS')",{nRok})),dbgotop())
  ucetpola->( DbEval( {|| ( DbRLock(),DbDelete(),DbUnLock() )}))
  ucetpola->(ads_clearaof(),dbgotop())


*
** odpracovaný výkon stroje ****************************************************
  ctmpDav   := ::cdirW +'tmpDav2'
  indexKey  := 'cNazPol1+cNazPol2'
  filtr1    := "nRok = %% .and. nObdobi <= %%  .and. val(cnazPol2) < 800 .and. cnazPol5 <> '        '"
  condition := format( filtr1, { nrok, nobdobi })

* - 2
  hIndex    := m_dav->( Ads_CreateTmpIndex( ::cdirW +'m_davw2' , ;
                                                     'tmpDav2' , ;
                                                     indexKey  , ;
                                                     condition   ) )


  m_dav ->( dbTotal(  ctmpDav,  ;
                      { || cNazPol1 +cNazPol2 }, ;
                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))

  ** pro kontrolu
  dbSelectArea('tmpDav2')
  cTXTKALK := homAdr + 'StrVyOdD.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nHrubaMzd SDF
* - 2

* - 3
  ctmpDav   := ::cdirW +'tmpDav3'
  indexKey  := 'cNazPol1+cNazPol2+cnazPol5'

  hIndex    := m_dav->( Ads_CreateTmpIndex( ::cdirW +'m_davw3'  , ;
                                                     'tmpDav3'  , ;
                                                      indexKey  , ;
                                                      condition   ) )
  m_dav ->( dbTotal(  ctmpDav,  ;
                      { || cNazPol1 +cNazPol2 +cnazPol5}, ;
                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))

  tmpDav3->(dbgoTop())
  do while .not. tmpDav3->(eof())
    tmpDav2->(dbseek( tmpDav3->cnazPol1+ tmpDav3->cnazPol2))
    *
    ** kolik se stoj podílel na práci za pøíslušné støedsko a výkon
    tmpDav3->ntmpNum4 := ( tmpDav3->nhodDoklad / tmpDav2->nhodDoklad ) * 1000
    tmpDav3->(dbskip())
  enddo

  ** pro kontrolu
  dbSelectArea('tmpDav3')
  cTXTKALK := homAdr + 'StVyStMz.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nHrubaMzd SDF
* - 3

* - 6
  ctmpDav   := ::cdirW +'tmpDav6'
  indexKey  := 'cnazPol5'

  hIndex    := m_dav->( Ads_CreateTmpIndex( ::cdirW +'m_davw6'  , ;
                                                     'tmpDav6'  , ;
                                                      indexKey  , ;
                                                      condition   ) )
  m_dav ->( dbTotal(  ctmpDav,  ;
                      { || cnazPol5}, ;
                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))



  hIndex   := tmpdav6->( Ads_CreateTmpIndex( ::cdirW +'tmpdav61'  , ;
                                                      'tmpDav61'  , ;
                                                       indexKey   , ;
                                                                      ) )
  ** pro kontrolu
  dbSelectArea('tmpDav6')

  cTXTKALK := homAdr + 'StrojOdD.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,nHodDoklad,nMnPDoklad,nHrubaMzd SDF
* - 6

* - 7
  ctmpDav   := ::cdirW +'tmpDav7'
  indexKey  := 'cnazPol5 +cnazPol1 +cnazPol2'

  hIndex    := m_dav->( Ads_CreateTmpIndex( ::cdirW +'m_davw7'  , ;
                                                     'tmpDav7'  , ;
                                                      indexKey  , ;
                                                      condition   ) )
  m_dav ->( dbTotal(  ctmpDav,  ;
                      { ||cnazPol5 +cnazPol1 +cnazPol2}, ;
                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))


  tmpDav7->(dbgoTop())
  do while .not. tmpDav7->(eof())
    tmpDav6->(dbseek( tmpDav7->cnazPol5))
    *
    ** ?? kolik se stoj podílel na práci za pøíslušné støedsko a výkon
    tmpDav7->ntmpNum4 := ( tmpDav7->nhodDoklad / tmpDav6->nhodDoklad ) * 1000
    tmpDav7->(dbskip())
  enddo

  * setøídíme tmpDav7
  hIndex    := tmpDav7->( Ads_CreateTmpIndex( ::cdirW +'tmpDav7'  , ;
                                                       'tmpDav7'  , ;
                                                        indexKey  , ;
                                                                    ) )
  ** pro kontrolu
  dbSelectArea('tmpDav7')
  cTXTKALK := homAdr + 'StrVykSt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,cNazPol1,cnazPol2,nHodDoklad,nMnPDoklad,nHrubaMzd,nTmpNum4 SDF

  tmpDav3->(dbgoTop())
  do while .not. tmpDav3->(eof())
    tmpDav7->(dbseek( tmpDav3->cnazPol5 +tmpDav3->cnazPol1 +tmpDav3->cnazPol2))
    tmpDav3->ntmpNum3 := tmpDav7->ntmpNum4
    tmpDav3->(dbskip())
  enddo

  * pro kontrolu
  dbselectArea('tmpDav3')
  cTXTKALK := homAdr + 'StrVySt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nUcetMzdy,nHodDoklad,nMnPDoklad,nTMPnum3,nTMPnum4  SDF
* - 7
  drgServiceThread:progressInc()

*
* skuteèné náklady na stroje podle úètù ****************************************
  cucpsNak1 := ::cdirW +'UcPSNak1'
  indexKey  := 'cnazPol5 +cucetMd'
  ucPsNakl  := "( nRok = %% .and. nObdobi <= %% .and. cnazPol5 <> '        ' )"
  condition := format( ucPsNakl, { nrok, nobdobi })

  hIndex    := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw1' , ;
                                                       'ucetpolw1' , ;
                                                       indexKey    , ;
                                                                   , ;
                                                                   , ;
                                                       ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                       .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    ok := ( val  ( ucetpol->cucetMd)     < 599000 .and. ;
            subStr( ucetpol->cucetMd,1,1) = '5'         ) .or. ;
          ( subStr( ucetpol->cucetMd,1,3) = '599' .and. subStr( ucetpol->cucetMd,6,1) = '8' )

    if ok
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw1'), dbgoTop())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol5 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))

  *
  * zjištìní skuteèných náklady na stroje
  * setøídíme cucpsNak1
  indexKey  := 'cnazPol5'
  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak1' , ;
                                                         'ucpsNak1' , ;
                                                          indexKey  , ;
                                                                      ) )
  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'SkuNakSu.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,cUcetMd,nkcMd  SDF

  cucpsNak2 := ::cdirW +'UcPSNak2'
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { ||cnazPol5}, ;
                      {  'nkcMd', 'nkcDal' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucpsNak2')
  cTXTKALK := homAdr +'SkuNakSt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,nKcMD SDF

*
* vnitropodnikové výnosy bez strojù podle úètù ************************************
  cucpvVyn1 := ::cdirW + 'UcPVVyn1'
  indexKey  := 'cnazPol5 +cucetMd'
  ucPvVyn1  := 'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. cTYPuct = "77"'
  condition := format( ucPvVyn1, { nrok, nobdobi })

  ucetpol->(ordSetFocus(0), dbgoTop())
  hIndex    := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw2' , ;
                                                       'ucetpolw2' , ;
                                                        indexKey   , ;
                                                        condition    ) )

  dbselectArea('ucetpol')
  COPY TO (cucpvVyn1)

*
* vnitropodnikové náklady na stroje podle úètù *********************************
  cucpvNak1 := ::cdirW + 'UcPVNak1'
  indexKey  := 'cnazPol5 +cucetMd'
   ucPvNak1  := ;
  'cDenik <> "YQ" .and. cDenik <> "YS" .and. ' + ;
  'nRok = %% .and. nObdobi <= %%  .and. cTYPuct = "76" .and. subStr(cUcetMD,1,3) = "599"'

  condition := format( ucPvNak1, { nrok, nobdobi })

  hIndex    := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw4'  , ;
                                                       'ucetpolw4'  , ;
                                                        indexKey    , ;
                                                                    , ;
                                                                    , ;
                                                        ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                        .f.          ))


  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    nnazPol2 := val ( ucetpol->cnazPol2    )
    cnazPo_3 := left( ucetpol->cnazPol2, 3 )

    ok       := nnazPol2 < 900 .or. nnazPol2 = 960 .or. nnazPol2 = 961 .or. nnazPol2 = 962 .or. nnazPol2 = 970 .and. ;
                .not. (cnazPo_3 = "860" .or. (cnazPo_3 >= "890" .and. cnazPo_3 <= "899") .or. cnazPo_3 = "955")

    if ok
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->( dbskip())
  enddo

  dbSelectArea( 'ucetpol' )
  ucetpol->( ads_clearAOF(), ordSetFocus('ucetpolw4'), dbgoTop())
  COPY TO (cucpvNak1)

  dbUsearea( .t., oSession_free, (::cdirW +'ucPvVyn1'),, .f.)

  *
  indexKey  := 'strZero(nRok,4) +strZero(nObdobi,2) +cDenik +strZero(nDoklad,10)+strZero(nOrdItem,5)'
  hIndex    := ucPvVyn1->( Ads_CreateTmpIndex( ::cdirW +'ucPvVyn1' , ;
                                                        'ucPvVyn1' , ;
                                                        indexKey   , ;
                                                                    ) )

  dbSelectArea( 'ucPvVyn1' )
  ucPvVyn1->(ordSetFocus('ucPvVyn1'), dbgoTop())
  * pro kontrolu
  dbUsearea( .t., oSession_free, (::cdirW +'ucPvNak1'),, .f.)
  cTXTKALK := homAdr +'NaklStrO.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nKcMD SDF

  ucPvNak1->(dbgoTop())
  do while .not. ucPvNak1->(eof())
    xkey := strZero( ucPvNak1->nRok,4) +strZero( ucPvNak1->nObdobi , 2) + ;
                     ucPvNak1->cDenik  +strZero( ucPvNak1->nDoklad ,10) + ;
                                        strZero( ucPvNak1->nordItem, 5)

    if ucPvVyn1->( dbseek( xkey))
      ucPvNak1->cnazPol5  := ucPvVyn1->cnazPol5
      ucPvVyn1->cprizLikv := 'W'
    endif

    ucPvNak1->(dbskip())
  enddo

  dbSelectArea( 'ucPvNak1' )
  COPY TO ( ::cdirW +'TmpVNUct')

  * spojení vnitropodnikových nákladù a výnosù
  dbUsearea( .t., oSession_free, (::cdirW +'TmpVNUct'),, .f.)
  ucPvVyn1->( dbgoTop())

  do while .not. ucPvVyn1->(eof())
    if ucPvVyn1->cprizLikv = 'W'
      mh_copyFld( 'ucPvVyn1', 'tmpVnUct',.t.)
    endif
    ucPvVyn1->(dbskip())
  enddo

  * tøídìní tmpVnUct
  indexKey  := 'strZero( nRok    , 4) +strZero( nObdobi , 2) +cDenik +strZero( nDoklad, 10) +' + ;
               'strZero( nOrdItem, 5) +strZero( nSubUcto, 3) +strZero( nOrdUcto, 1)'

  hIndex    := tmpVnUct->( Ads_CreateTmpIndex( ::cdirW +'tmpVnUct' , ;
                                                        'tmpVnUct' , ;
                                                        indexKey   , ;
                                                                     ) )

  dbSelectArea( 'ucetpola' )
  COPY TO ( ::cdirW +'TUcetPQA') FOR ucetpola->cdenik = 'YQ'

  dbUseArea( .t., oSession_free, (::cdirW +'TUcetPQA'),, .f.)

  indexKey  := 'strZero(nMainItem, 6) +left(cZkratJed2, 2) +strZero( nDokladOrg,10) + ' + ;
               'strZero(nOrdItem  ,5) +strZero( nSubUcto,2)+strZero(nOrdUcto,1)'


  hIndex    := tucetPqa->( Ads_CreateTmpIndex( ::cdirW +'tucetPqa' , ;
                                                        'tucetPqa' , ;
                                                        indexKey   , ;
                                                                     ) )
  ucetpola->( ordSetFocus( AdsCTag(12)))
  tmpVnUct->( dbgoTop())

  do while .not. tmpVnUct->(eof())
    xkey := strZero(tmpVNUct->nRok,4)     +strZero(tmpVNUct->nObdobi,  2) + ;
                    tmpVNUct->cDenik      +strZero(tmpVNUct->nDoklad, 10) + ;
            strZero(tmpVNUct->nOrdItem,5) +strZero(tmpVNUct->nSubUcto, 2) + ;
            strZero(tmpVNUct->nOrdUcto, 1)

    if .not. tucetPqa->( dbseek( xkey))
      mh_copyFld( 'tmpVnUct', 'ucetpola',.t.,.t.)

      ucetpola->cDenik     := "YQ"
      ucetpola->nRok       := nRok
      ucetpola->cObdobi    := strZero( nObdobi, 2) +"/" +Right( AllTrim( Str( nRok)), 2)
      ucetpola->nObdobi    := nObdobi
      ucetpola->nKcMD      := ucetpola->nKcMD  * (-1)
      ucetpola->nKcDAL     := ucetpola->nKcDAL * (-1)
      ucetpola->cText      := "Odúctování VN nákladu za stroje"
      ucetpola->nDokladOrg := tmpVNUct->nDoklad
      ucetpola->nMainItem  := Val( strZero( tmpVNUct ->nRok, 4) +strZero( tmpVNUct ->nObdobi, 2))
      ucetpola->cZkratJed2 := tmpVNUct ->cDenik
      if( ucetpola->cTypUCT = "76", ucetpola->cNazPol5 := "", nil)

      do case
      case ucetpola->cNazPol2 = "960"  ;  nStor960 += ucetpola->nKcMD
      case ucetpola->cNazPol2 = "961"  ;  nStor961 += ucetpola->nKcMD
      case ucetpola->cNazPol2 = "962"  ;  nStor962 += ucetpola->nKcMD
      case ucetpola->cNazPol2 = "970"  ;  nStor970 += ucetpola ->nKcMD
      endCase
    endif

    tmpVnUct->(dbskip())
  enddo


*
* doposud zúètované pøímé náklady strojù ****************************************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  hIndex    := ucetpola->( Ads_CreateTmpIndex( ::cdirW +'tmUcpoa1' , ;
                                                        'tmUcpoa1' , ;
                                                         indexKey  , ;
                                                                     ) )
  dbSelectArea( 'ucetpola' )
  ucetpola->( ordSetFocus( 'tmUcpoa1'))

  genUctpolS( 'YS', '5995' )
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )
  * zaùètování skuteèných nákladù na výkony a stroje
  * pro kontrolu
  dbSelectArea( 'ucetpols' )
  ucetpols->( ordSetFocus( 'ucetpols'))
  cTXTKALK := ::cdirW +'NaklStr.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nKcMD SDF

  ucPsNak2 ->(dbgoTop())

  do while .not. ucPsNak2->(eof())
    nx    := 0
    ndokl := newDokl_as()

    if c_vnsast->( dbseek( upper( ucPsNak2->cnazPol5)))

      if( c_vnsast->cnazPol2 = "890     ", nww1 += ucPsNak2->nkcMd, nil )
      nww2 := 0

      tmpDav3->( dbgoTop())

      do while .not. tmpDav3->( eof())
        if ucPsNak2->cnazPol5 = tmpDav3->cnazPol5
          ucPsNak2->cuzavreni := 'Q'

          xkey := tmpDav3->cnazPol1 +tmpDav3->cnazPol2 +tmpDav3->cnazPol5
          nx++

          ucetpols->( dbseek( xkey))
          nww2      += tmpDav3->ntmpNum3
          nskuNakSt := round(( ucPsNak2->nkcMd *tmpDav3->ntmpNum3) / 1000, 2)
          nskuNakSt := nskuNakSt  - ucetpols->nkcMd

          if nskuNakSt <> 0
            for n := 1 to 2 step 1
              naplnUp( ndokl, nx, n )

              ucetpola->ctext := 'Pøímé náklady na stroje'
              ctyp            := typCase()

              if n = 1
                UcetPola ->cNazPol1 := TmpDav3 ->cNazPol1
                UcetPola ->cNazPol2 := TmpDav3 ->cNazPol2
                UcetPola ->cNazPol5 := ""
                UcetPola ->cSklPol  := TmpDav3 ->cNazPol5
                UcetPola ->cUcetMD  := "5995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cUcetDAL := "6995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cTyp_R   := "MD"
                UcetPola ->nKcMD    := nSkuNakSt
                UcetPola ->nKcDAL   := 0
              ELSE
                C_VnSaSt ->( dbSeek( Upper( TmpDav3 ->cNazPol5)))
                UcetPola ->cNazPol1 := C_VnSaSt ->cKmenStrSt
                UcetPola ->cNazPol2 := C_VnSaSt ->cNazPol2
                UcetPola ->cNazPol5 := TmpDav3 ->cNazPol5
                UcetPola ->cUcetMD  := "6995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cUcetDAL := "5995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cTyp_R   := "DAL"
                UcetPola ->nKcMD    := 0
                UcetPola ->nKcDAL   := nSkuNakSt
              ENDIF
            next
          endif
        endif

        tmpDav3->( dbskip())
      enddo
    endif

    ucPsNak2->(dbskip())
  enddo

*
* pøípad kdy stroj nepracoval na žádném výkonu *********************************

  ucPsNak2 ->( dbgoTop())

  drgServiceThread:progressInc()

  nx := 0

  DO WHILE !UcPSNak2 ->( Eof())
    IF Empty( UcPSNak2 ->cUzavreni)
      nX    := 0
      nDokl := NewDokl_AS()
      cNAKpo2 := UcPSNak2 ->cNazPol2
      VyberMDAV(::cdirW)
      IF C_VnSaSt ->( dbSeek( Upper( UcPSNak2 ->cNazPol5)))
        TmpDav3 ->( dbGoTop())
        DO WHILE !TmpDav3 ->( Eof())
//             UcPSNak2 ->cUzavreni := "Q"
          xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +UcPSNak2 ->cNazPol5
          nX++
          UcetPolS ->( dbSeek( xKey))
          nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum4) / 1000000, 2)
          nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
          IF nSkuNakSt <> 0
            FOR n := 1 TO 2
              NaplnUP( ndokl, nx, n)
              UcetPola ->cText    := "Prímé náklady za stroje"
              cTYP                := TypCASE()
              IF n == 1
                UcetPola ->cNazPol1 := TmpDav3 ->cNazPol1
                UcetPola ->cNazPol2 := TmpDav3 ->cNazPol2
                UcetPola ->cNazPol5 := ""
                UcetPola ->cSklPol  := UcPSNak2 ->cNazPol5
                UcetPola ->cUcetMD  := "5995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cUcetDAL := "6995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cTyp_R   := "MD"
                UcetPola ->nKcMD    := nSkuNakSt
                UcetPola ->nKcDAL   := 0
              ELSE
                UcetPola ->cNazPol1 := C_VnSaSt ->cKmenStrSt
                UcetPola ->cNazPol2 := C_VnSaSt ->cNazPol2
                UcetPola ->cNazPol5 := UcPSNak2 ->cNazPol5
                UcetPola ->cUcetMD  := "6995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cUcetDAL := "5995" + cTYP +Left( Str(TmpDav3 ->nUcetMzdy,3),1)
                UcetPola ->cTyp_R   := "DAL"
                UcetPola ->nKcMD    := 0
                UcetPola ->nKcDAL   := nSkuNakSt
              ENDIF
            NEXT
          ENDIF
          TmpDav3 ->( dbSkip())
        ENDDO
      ENDIF
    ENDIF
    UcPSNak2 ->( dbSkip())
  ENDDO


*
* skuteèné náklady na stroje podle úètù ****************************************
  cucPsNak1  := ::cdirW + 'UcPSNak1'
  indexKey   := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPsNak850 := 'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. cnazPol2 = "850"'
  condition  := format( ucPsNak850, { nrok, nobdobi })

  hIndex     := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw3' , ;
                                                        'ucetpolw3' , ;
                                                        indexKey    , ;
                                                                    , ;
                                                                    , ;
                                                        ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                        .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    ok := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)) )

    if ok
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw3'), dbgoTop())

  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol1 +cnazPol2 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))


  *
  * skuteèné náklady na stroje *************************************************
  cucpsNak3 := ::cdirW +'UcPSNak3'
  indexKey := 'cnazPol2'
  hIndex   := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak11' , ;
                                                        'ucpsNak11' , ;
                                                         indexKey  , ;
                                                                     ) )
  ucpsNak1->( dbTotal(  cucpsNak3,  ;
                      { || cnazPol2}, ;
                      { 'nkcMd', 'nkcDal' },,,,,,.f.))

  *
  * Zjištìní ostatních skuteèných nákladù mechanizace podle úètù ***************
  cucPsNak1  := ::cdirW + 'UcPSNak1'
  inexKey    := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPsNak800 := ;
  'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. ' + ;
  '(( cnazPol2 = "860" .or. (cnazPol2 >= "890" .and. cnazPol2 <= "899") .or. cnazPol2 = "955" ) .and. cnazPol2 <> "850" )'

  condition := format( ucPsNak800, { nrok, nobdobi })

  hIndex    := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw5' , ;
                                                       'ucetpolw5' , ;
                                                       indexKey    , ;
                                                                   , ;
                                                                   , ;
                                                       ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                       .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    lstroj := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)))
    lucet  := .f.

    if subStr( ucetpol->cucetMd, 1, 1) = '5'
      lucet := if( subStr( ucetpol->cucetMd, 1, 3) = '599' .and. substr( ucetpol->cucetMd, 6, 1) = '8', lstroj, .t.)
    endif

    if lstroj .and. lucet
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw5'), dbgoTop())
  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol5 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))


  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'MechOsVU.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMd,nkcMd,nkcDal  SDF

  * Zjištìní ostatních nákladù za výkony mechanizace ***************************
  cucPSNak2 := ::cdirW + 'UcPSNak2'
  cucPsNak3 := ::cdirW + 'UcPSNak3'
  indexKey  := 'cnazPol2'

  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak12' , ;
                                                         'ucpsNak12' , ;
                                                          indexKey  , ;
                                                                     ) )
  ucpsNak2 ->( dbCloseArea())
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { || cnazPol2}, ;
                      { 'nkcMd', 'nkcDal' },,,,,,.f.))

  dbselectArea( 'ucPsNak2' )

  ucPsNak3->( dbgoTop())

  do while .not. ucPsNak3->( eof())
    mh_copyFld( 'ucPsNak3', 'ucPsNak2',.t. )

    ucPsNak3->( dbskip())
  enddo

//  APPEND FROM (cucPsNak3 )

   * pro kontrolu
  dbselectArea('ucPsNak2')
  cTXTKALK := homAdr + 'MechOsVy.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nkcMd, nkcDal SDF

  * Zaúètování ostatních skuteèných nákladù mechanizace na výkony **************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  genUctPols( 'YS', '5996' )
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )
  UcPSNak2 ->( dbGoTop())

  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberMDAV(::cdirW)

    DO WHILE !TmpDav3 ->( Eof())
      xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum4) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Pøímé náklady mechanizace 1 "
          IF n == 1
            UcetPola ->cNazPol1 := TmpDav3 ->cNazPol1
            UcetPola ->cNazPol2 := TmpDav3 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "5996" + cTYP
            UcetPola ->cUcetDAL := "6996" + cTYP
            UcetPola ->cTyp_R   := "MD"
            UcetPola ->nKcMD    := nSkuNakSt
            UcetPola ->nKcDAL   := 0
            UcetPola ->cSklPol  := UcPSNak2 ->cNazPol2
          ELSE
            UcetPola ->cNazPol1 := UcPSNak2 ->cNazPol1
            UcetPola ->cNazPol2 := UcPSNak2 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "6996" + cTYP
            UcetPola ->cUcetDAL := "5996" + cTYP
            UcetPola ->cTyp_R   := "DAL"
            UcetPola ->nKcMD    := 0
            UcetPola ->nKcDAL   := nSkuNakSt
          ENDIF
        NEXT
      ENDIF
      TmpDav3 ->( dbSkip())
    ENDDO
    UcPSNak2 ->( dbSkip())
  ENDDO

  * skuteèné náklady na stroje podle úètù
  * Zjištìní skuteèných nákladù externích strojù 2 *****************************
  cucPsNak1  := ::cdirW + 'UcPSNak1'
  indexKey   := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPsNak900 := ;
    'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. ' + ;
    'cnazPol2 = "900" .and. cnazPol2 <> "850"'

  condition  := format( ucPsNak900, { nrok, nobdobi })

  hIndex     := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw5' , ;
                                                        'ucetpolw5' , ;
                                                        indexKey    , ;
                                                                    , ;
                                                                    , ;
                                                        ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                        .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    lstroj := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)))
    lucet  := .f.

    if subStr( ucetpol->cucetMd, 1, 1) = '5'
      lucet := if( subStr( ucetpol->cucetMd, 1, 3) = '599' .and. substr( ucetpol->cucetMd, 6, 1) = '8', lstroj, .t.)
    endif

    if lstroj .and. lucet
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw5'), dbgoTop())
  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol1 +cnazPol2 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))


  drgServiceThread:progressInc()

  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'MechOsVU.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMd,nkcMd,nkcDal  SDF


  * skuteèné náklady na stoje
  * Zjištení skutecných nákladu externích stroju 3 *****************************
  cucpsNak2 := ::cdirW +'UcPSNak2'
  indexKey  := 'cnazPol2'
  condition := 'cNazPol2 <> "850"'

  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak13' , ;
                                                         'ucpsNak13' , ;
                                                          indexKey  , ;
                                                          condition   ) )

  ucpsNak2 ->( dbCloseArea())
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { || cnazPol2}, ;
                      {  'nkcMd', 'nkcDal' },,,,,,.f.))


  * pro kontrolu
  dbselectArea('ucPsNak2')
  cTXTKALK := homAdr + 'MechOsVy.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nkcMd, nkcDal  SDF

  * doposud zuctované ostatní prímé náklady mechanizace
  * Zaùètování skutecných nákladu externích stroju na výkony 3 *****************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  GenUctPolS('YS','5997')
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )

  UcPSNak2 ->( dbGoTop())

  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberMDAV(::cdirW)
    DO WHILE !TmpDav3 ->( Eof())
      xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum4) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Prímé náklady mechanizace 2"
          IF n == 1
            UcetPola ->cNazPol1 := TmpDav3 ->cNazPol1
            UcetPola ->cNazPol2 := TmpDav3 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "5997" + cTYP
            UcetPola ->cUcetDAL := "6997" + cTYP
            UcetPola ->cTyp_R   := "MD"
            UcetPola ->nKcMD    := nSkuNakSt
            UcetPola ->nKcDAL   := 0
            UcetPola ->cSklPol  := UcPSNak2 ->cNazPol2
          ELSE
            UcetPola ->cNazPol1 := UcPSNak2 ->cNazPol1
            UcetPola ->cNazPol2 := UcPSNak2 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "6997" + cTYP
            UcetPola ->cUcetDAL := "5997" + cTYP
            UcetPola ->cTyp_R   := "DAL"
            UcetPola ->nKcMD    := 0
            UcetPola ->nKcDAL   := nSkuNakSt
          ENDIF
        NEXT
      ENDIF
      TmpDav3 ->( dbSkip())
    ENDDO
    UcPSNak2 ->( dbSkip())
  ENDDO


* rozpuštení režií RV 960
* Zjištení nákladu (úcty - výkony) pro rozpuštení režií RV - 960 2 *************

  cucPsNak1  := ::cdirW + 'UcPSNak1'
  indexKey   := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPSNak960 := 'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. cNazPol2 = "960"'
  condition  := format( ucPsNak960, { nrok, nobdobi })

   hIndex    := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw6' , ;
                                                       'ucetpolw6' , ;
                                                       indexKey    , ;
                                                                   , ;
                                                                   , ;
                                                       ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                       .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    cucetMd := ucetpol->cucetMd
    cucet_2 := left(ucetpol->cucetMd, 2)
    cucet_3 := left(ucetpol->cucetMd, 3)
    nucetMd := val( ucetpol->cucetMd)

    lstroj  := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)))
    lucet   := .f.

    lucet   := ( ( val(cucet_2) >= 50 .and. val(cucet_2) <= 54 ) .or. ;
                 ( cucet_3 = "551" .or. cucet_3 = "562" .or. cucet_3 = "568" .or. cucet_3 = "582" .or. cucet_3 = "599" ) .or. ;
                 ( nucetMd >= 613311 .and. nucetMd <= 613329 ) .and. ;
                   cucet_3 <> "542" .and. cuet_3 <> "546" )

    if lstroj .and. lucet
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

     ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw6'), dbgoTop())
  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol1 +cnazPol2 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'Zakl960uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMd,nkcMd,nkcDal  SDF


* skutecné náklady na stroje
* Zjištení nákladu (výkony) pro rozpuštení režií RV - 960 3 ********************
  cucPSNak2 := ::cdirW + 'UcPSNak2'
  indexKey  := 'cnazPol2'

  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak13' , ;
                                                        'ucpsNak13' , ;
                                                         indexKey  , ;
                                                                     ) )
  ucpsNak2 ->( dbCloseArea())
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { || cnazPol2}, ;
                      { 'nkcMd', 'nkcDal' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucPsNak2')
  cTXTKALK := homAdr + 'Zakl960v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nkcMd, nkcDal SDF


  * doposud zúctované ostatní prímé náklady mechanizace
  * Zaúctování režie 960 na výkony  3 ******************************************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  GenUctPolS('YS','5995')
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )
  UcPSNak2 ->( dbGoTop())

  IF nRok = 2009
    UcetKum ->( dbSeek( "200912" +Upper( "699910100     960     ")))
    UcPSNak2 ->nKcMD := UcPSNak2 ->nKcMD - UcetKum ->nKcDalKSR
  ENDIF
  UcPSNak2 ->( dbGoTop())

  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberZAKL( "RV", ::cdirW)
    UcPSNak2 ->nKcMD += nStor960
    DO WHILE !ZaklUct ->( Eof())
      xKEY := ZaklUct ->cNazPol1 +ZaklUct ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * ZaklUct ->nMnozNat2) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Režie RV"
          IF n == 1
            UcetPola ->cNazPol1 := ZaklUct ->cNazPol1
            UcetPola ->cNazPol2 := ZaklUct ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 1)
            UcetPola ->cUcetMD  := "59995" + cTYP
            UcetPola ->cUcetDAL := "69995" + cTYP
            UcetPola ->cTyp_R   := "MD"
            UcetPola ->nKcMD    := nSkuNakSt
            UcetPola ->nKcDAL   := 0
            UcetPola ->cSklPol  := UcPSNak2 ->cNazPol2
          ELSE
            UcetPola ->cNazPol1 := UcPSNak2 ->cNazPol1
            UcetPola ->cNazPol2 := UcPSNak2 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 1)
            UcetPola ->cUcetMD  := "69995" + cTYP
            UcetPola ->cUcetDAL := "59995" + cTYP
            UcetPola ->cTyp_R   := "DAL"
            UcetPola ->nKcMD    := 0
            UcetPola ->nKcDAL   := nSkuNakSt
          ENDIF
        NEXT
      ENDIF
      ZaklUct ->( dbSkip())
    ENDDO
    UcPSNak2 ->( dbSkip())
  ENDDO


* rozpuštení režií RV 961
* Zjištení nákladu (úcty - výkony) pro rozpuštení režií ZV - 961 2 *************
  cucPsNak1  := ::cdirW + 'UcPSNak1'
  inexKey    := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPSNak961 := 'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. cNazPol2 = "961"'
  condition  := format( ucPsNak961, { nrok, nobdobi })

  hIndex     := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw7' , ;
                                                        'ucetpolw7' , ;
                                                        indexKey    , ;
                                                                    , ;
                                                                    , ;
                                                        ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                        .f.          ))


  drgServiceThread:progressInc()


  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    cucetMd := ucetpol->cucetMd
    cucet_2 := left(ucetpol->cucetMd, 2)
    cucet_3 := left(ucetpol->cucetMd, 3)
    nucetMd := val( ucetpol->cucetMd)

    lstroj  := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)))
    lucet   := .f.

    lucet   := ( ( val(cucet_2) >= 50 .and. val(cucet_2) <= 54 ) .or. ;
                 ( cucet_3 = "551" .or. cucet_3 = "562" .or. cucet_3 = "568" .or. cucet_3 = "582" .or. cucet_3 = "599" ) .or. ;
                 ( nucetMd >= 613311 .and. nucetMd <= 613329 ) .and. ;
                   cucet_3 <> "542" .and. cuet_3 <> "546" )

    if lstroj .and. lucet
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

     ucetpol->(dbskip())
  enddo


  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw7'), dbgoTop())
  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol1 +cnazPol2 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'Zakl961uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMd,nkcMd,nkcDal  SDF

  * skutecné náklady na stroje
  * Zjištení nákladu (výkony) pro rozpuštení režií RV - 961 3 ******************
  cucpsNak2 := ::cdirW +'UcPSNak2'
  indexKey  := 'cnazPol2'

  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak14' , ;
                                                         'ucpsNak14' , ;
                                                          indexKey  , ;
                                                                      ) )
  ucpsNak2 ->( dbCloseArea())
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { || cnazPol2}, ;
                      { 'nkcMd', 'nkcDal' },,,,,,.f.))

  * pro kontrolu
  dbselectArea( 'ucpsNak2' )
  cTXTKALK := homAdr +'Zakl961v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF

  * doposud zúctované ostatní prímé náklady mechanizace
  * Zaúctování režie 961 na výkony  3 ******************************************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  GenUctPolS('YS','5997')
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )

  ucPSNak2 ->( dbGoTop())

  IF nRok = 2009
    UcetKum ->( dbSeek( "200912" +Upper( "699911201     961     ")))
    UcPSNak2 ->nKcMD := UcPSNak2 ->nKcMD - UcetKum ->nKcDalKSR
    UcetKum ->( dbSeek( "200912" +Upper( "699911220     961     ")))
    UcPSNak2 ->nKcMD := UcPSNak2 ->nKcMD - UcetKum ->nKcDalKSR
  ENDIF

  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberZAKL( "ZV", ::cdirW)
    UcPSNak2 ->nKcMD += nStor961
    DO WHILE !ZaklUct ->( Eof())
      xKEY := ZaklUct ->cNazPol1 +ZaklUct ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * ZaklUct ->nMnozNat2) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Režie ZV"
          IF n == 1
            UcetPola ->cNazPol1 := ZaklUct ->cNazPol1
            UcetPola ->cNazPol2 := ZaklUct ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 1)
            UcetPola ->cUcetMD  := "59995" + cTYP
            UcetPola ->cUcetDAL := "69995" + cTYP
            UcetPola ->cTyp_R   := "MD"
            UcetPola ->nKcMD    := nSkuNakSt
            UcetPola ->nKcDAL   := 0
            UcetPola ->cSklPol  := UcPSNak2 ->cNazPol2
          ELSE
            UcetPola ->cNazPol1 := UcPSNak2 ->cNazPol1
            UcetPola ->cNazPol2 := UcPSNak2 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 1)
            UcetPola ->cUcetMD  := "69995" + cTYP
            UcetPola ->cUcetDAL := "59995" + cTYP
            UcetPola ->cTyp_R   := "DAL"
            UcetPola ->nKcMD    := 0
            UcetPola ->nKcDAL   := nSkuNakSt
          ENDIF
        NEXT
      ENDIF
      ZaklUct ->( dbSkip())
    ENDDO
    UcPSNak2 ->( dbSkip())
  ENDDO


* rozpuštení režií CD 970+962
* Zjištení nákladu (úcty - výkony) pro rozpuštení režií CD - 970+962 2 *********
  cucPsNak1  := ::cdirW + 'UcPSNak1'
  indexKey   := 'cnazPol1 +cnazPol2 +cucetMd'
  ucPSNak970 := 'cDenik <> "YQ" .and. cDenik <> "YS" .and. nRok = %% .and. nObdobi <= %% .and. ' + ;
                '(cnazPol2 = "962" .or. cnazPol2 = "970")'

  condition  := format( ucPsNak970, { nrok, nobdobi })

  hIndex     := ucetpol->( Ads_CreateTmpIndex( ::cdirW +'ucetpolw8' , ;
                                                        'ucetpolw8' , ;
                                                        indexKey    , ;
                                                                    , ;
                                                                    , ;
                                                        ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                        .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    cucetMd := ucetpol->cucetMd
    cucet_2 := left(ucetpol->cucetMd, 2)
    cucet_3 := left(ucetpol->cucetMd, 3)
    nucetMd := val( ucetpol->cucetMd)

    lstroj  := if( empty(ucetpol->cnazPol5), .t., .not. c_vnsast->( dbseek( ucetpol->cnazPol5)))
    lucet   := .f.

    lucet   := ( ( val(cucet_2) >= 50 .and. val(cucet_2) <= 54 ) .or. ;
                 ( cucet_3 = "551" .or. cucet_3 = "562" .or. cucet_3 = "568" .or. cucet_3 = "582" .or. cucet_3 = "599" ) .or. ;
                 ( nucetMd >= 613311 .and. nucetMd <= 613329 ) .and. ;
                   cucet_3 <> "542" .and. cucet_3 <> "546" )

    if lstroj .and. lucet
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

     ucetpol->(dbskip())
  enddo

  ucetpol->( ads_clearAOF(), ordSetFocus( 'ucetpolw8'), dbgoTop())
  ucpsNak1 ->( dbCloseArea())
  UcetPol->( dbTotal( cucpsNak1              , ;
                      { || cnazPol1 +cnazPol2 +cucetMD}, ;
                      {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucpsNak1')
  cTXTKALK := homAdr + 'Zakl970uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMd,nkcMd,nkcDal  SDF

  * skutecné náklady na stroje
  * Zjištení nákladu (výkony) pro rozpuštení režií CD - 970+962  3 *************
  cucPSNak2 := ::cdirW + 'UcPSNak2'
  indexKey  := 'cnazPol2'

  hIndex    := ucpsNak1->( Ads_CreateTmpIndex( ::cdirW +'ucpsNak15' , ;
                                                        'ucpsNak15' , ;
                                                         indexKey  , ;
                                                                     ) )

  ucpsNak2 ->( dbCloseArea())
  ucpsNak1->( dbTotal(  cucpsNak2,  ;
                      { || cnazPol2}, ;
                      { 'nkcMd', 'nkcDal' },,,,,,.f.))

  * pro kontrolu
  dbselectArea('ucPsNak2')
  cTXTKALK := homAdr + 'Zakl970v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nkcMd, nkcDal SDF

  * doposud zúctované ostatní prímé náklady mechanizace
  * Zaúctování režie 970 + 962 na výkony  3 ************************************
  cucetPolS := ::cdirW + 'UcetPolS'
  indexKey  := 'cnazPol1 +cnazPol2 +left(csklPol,8)'

  ucPsNak2->(dbGoTop())

  GenUctPolS('YS','59996')
  dbUsearea( .t., oSession_free, (::cdirW + 'UcetPolS'),, .f.)

  hIndex    := ucetpols->( Ads_CreateTmpIndex( ::cdirW +'ucetpols' , ;
                                                        'ucetpols' , ;
                                                         indexKey  , ;
                                                                     ) )
 * pro kontrolu
  dbselectArea('ucetpols')
  cTXTKALK := homAdr + 'Rozp970.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nkcMd, nkcDal SDF

  UcPSNak2 ->( dbGoTop())

  nX := 0
  nTest1 := 0
  nTest2 := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberZAKL( "CD", ::cdirW)
    DO CASE
    CASE UcPSNak2 ->cNazPol2 = "962"
      UcPSNak2 ->nKcMD += nStor962
    CASE UcPSNak2 ->cNazPol2 = "970"
      UcPSNak2 ->nKcMD += nStor970
    ENDCASE
    DO WHILE !ZaklUct ->( Eof())
      xKEY := ZaklUct ->cNazPol1 +ZaklUct ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * ZaklUct ->nMnozNat2) / 1000000, 2)
      nTest1    += nSkuNakSt
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      nTest2    += nSkuNakSt
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Režie CDR+962"
          IF n == 1
            UcetPola ->cNazPol1 := ZaklUct ->cNazPol1
            UcetPola ->cNazPol2 := ZaklUct ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "59996" + cTYP
            UcetPola ->cUcetDAL := "69996" + cTYP
            UcetPola ->cTyp_R   := "MD"
            UcetPola ->nKcMD    := nSkuNakSt
            UcetPola ->nKcDAL   := 0
            UcetPola ->cSklPol  := UcPSNak2 ->cNazPol2
          ELSE
            UcetPola ->cNazPol1 := UcPSNak2 ->cNazPol1
            UcetPola ->cNazPol2 := UcPSNak2 ->cNazPol2
            cTYP := Right( AllTrim( UcPSNak2 ->cNazPol2), 2)
            UcetPola ->cUcetMD  := "69996" + cTYP
            UcetPola ->cUcetDAL := "59996" + cTYP
            UcetPola ->cTyp_R   := "DAL"
            UcetPola ->nKcMD    := 0
            UcetPola ->nKcDAL   := nSkuNakSt
          ENDIF
        NEXT
      ENDIF
      ZaklUct ->( dbSkip())
    ENDDO
    UcPSNak2 ->( dbSkip())
  ENDDO

  ::ucetsys_ks(obdZpr)
  ucetpola->( dbCloseArea())

  drgServiceThread:progressEnd()

*
** První krok rozpuštení skoncil. Provedte aktualizaci úcetnictví !!!
*
return .t.
*
* END UCT_skunakst_CRD:rozpustit ***********************************************
*


//  kalkulace výrobkù
METHOD UCT_skunakst_CRD:kalkulace(drgdialog)
  LOCAL cFileKAtm  := homAdr + 'KalkKtm'
  Local cTmUctKUM  := homAdr + 'TmUctKUM'
  Local cMdav      := netAdr + 'M_Dav'
  Local cMDavI     := homAdr + 'M_DavI'
  LOCAL aOutDEFtmp := { { "cOznac",    "c",  1, 0},                              ;
                        { "cNazPol2",  "c",  8, 0}, { "cNazev",    "c", 25, 0 }, ;
                        { "cPrimNakl", "c", 10, 0}, { "cSpoVlVyr", "c", 10, 0 }, ;
                        { "cVnNakPoCi","c", 10, 0}, { "cVyrRezie", "c", 10, 0 }, ;
                        { "cVyrNakl",  "c", 10, 0}, { "cOdpVedlVy","c", 10, 0 }, ;
                        { "cNakBezCDR","c", 10, 0}, { "cCelDruRez","c", 10, 0 }, ;
                        { "cNakSCDR",  "c", 10, 0}, { "cVyrobaMn", "c", 10, 0 }, ;
                        { "cNakJedBeC","c", 13, 0}, { "cNakJedSC", "c", 13, 0 } }
  Local cTXTKALK
  LOCAL xKEY, nUCET
  LOCAL nKCmd, nKCdal, nKCzust
  LOCAL cTmpDav, nSumaHOD, nVyk, nVAL, cPOLE, lOK
  LOCAL aROZvyk := {}
  LOCAL dc := ::drgDialog:dialogCtrl

  drgServiceThread:progressStart( drgNLS:msg('Vytváøím tabulku kalkulace'), 3)

  nRok    := uctOBDOBI:UCT:nrok
  nObdDO  := uctOBDOBI:UCT:nobdobi
  nObdobi := uctOBDOBI:UCT:nobdobi

  drgDBMS:open('cnazpol2')
  drgDBMS:open('ucetkum')

  kalkzem->( dbZap())

 *
  cfileKAtm  := ::cdirW +'KalkKtm'
  dbCreate( cfileKAtm, aOutDefTmp, oSession_free)
  dbuseArea( .t., oSession_free, ( cfileKAtm ),, .f.)

  *
  ctmUctKUM  := ::cdirW + 'TmUctKUM'
  dbSelectArea( "UcetKum")
  COPY TO (cTmUctKum) FOR UcetKum ->nRok = nRok .AND. UcetKum ->nObdobi = nObdobi

  *
  dbUseArea( .t., oSession_free, (ctmUctKum),, .f. )
  indexKey := 'cnazPol2 +cucetMD'

  hIndex   := tmUctKum ->( Ads_CreateTmpIndex( ::cdirW +'tmUctKum' , ;
                                                        'tmUctKum' , ;
                                                         indexKey  , ;
                                                                     ) )
  drgServiceThread:progressInc()

  tmUctKum ->( dbGoTop())

  DO WHILE !TmUctKum ->( Eof())
    IF TmUctKum ->cNazPol2 <> kalkzem ->cNazPol2 .OR. kalkzem ->( LastRec()) = 0
      cNazPol2 ->( dbSeek( TmUctKum ->cNazPol2,,1))
      kalkzem ->( dbAppend())
      kalkzem ->cNazPol2   := TmUctKum ->cNazPol2
      kalkzem ->cNazev     := CNazPol2 ->cNazev
      kalkzem ->dDatPoriz  := ::ddatzprac
      kalkzem ->dZpracKDat := mh_LastODate( nROK, nOBDOBI)
    ENDIF
    nUCET   := Val( TmUctKum ->cUcetMD)
    IF nUCET >= 500000 .AND. nUCET < 599000
      kalkzem ->nPrimNAKL  += ( TmUctKum ->nKcMDKSR - TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET >= 613300 .AND. nUCET <= 613399
      kalkzem ->nSpoVlVyr  += ( TmUctKum ->nKcMDKSR - TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET >= 599000 .AND. nUCET <= 599800
      kalkzem ->nVnNakPoCi += ( TmUctKum ->nKcMDKSR - TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET = 613132 .OR. nUCET = 613112 .OR. nUCET = 614110
      kalkzem ->nOdpVedlVy += ( TmUctKum ->nKcDALKSR - TmUctKum ->nKcMDKSR)
    ENDIF
    IF ( nUCET >= 599950 .AND. nUCET <= 599959 )
      kalkzem ->nVyrRezie  += ( TmUctKum ->nKcMDKSR - TmUctKum ->nKcDALKSR)
    ENDIF
    IF ( nUCET >= 599960 .AND. nUCET <= 599969 )
      kalkzem ->nCelDruRez += ( TmUctKum ->nKcMDKSR - TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET = 999500
      kalkzem ->nVyrobaMn   += ( TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET = 999520
      kalkzem ->nRealizace  += ( TmUctKum ->nKcDALKSR)
    ENDIF
    IF nUCET = 999002
      kalkzem ->nPlOsetaHa  += ( TmUctKum ->nKcDALKSR)
    ENDIF
    TmUctKum ->( dbSkip())
  ENDDO

  *
  drgDBMS:open( 'mzddavit',,,,,'m_dav' )

  ctmpDav   := ::cdirW +'TmpDav5'
  indexKey  := 'cnazPol2'
  filtrkal  := "( nRok = %% .and. nObdobi <= %% .and. cnazPol2 <> '        ' .and. cnazPol5 <> '        ')"
  condition := format( filtrkal, { nrok, nobdobi })

  hIndex    := m_dav ->( Ads_CreateTmpIndex( ::cdirW +'m_davw5'    , ;
                                                      'm_davw5 '   , ;
                                                       indexKey    , ;
                                                                   , ;
                                                                   , ;
                                                       ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                       .f.          ))


  m_dav->( ordSetFocus(0), dbgoTop())
  m_dav->( ads_setAof( condition ), dbgoTop())

  do while .not. m_dav->(eof())
    nnazPol2 := val( m_dav->cnazPol2 )

    if nnazPol2 < 800 .or. nnazPol2 = 870
      m_dav->(AdsAddCustomKey( hIndex ))
    endif

    m_dav->(dbskip())
  enddo

  m_dav ->( ads_clearAOF(), ordSetFocus( 'm_davw5'), dbgoTop())
  m_dav ->( dbTotal(  ctmpDav,  ;
                      { || cNazPol1 +cNazPol2 }, ;
                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))

  dbUsearea( .t., oSession_free, (ctmpDav),, .f.)

  hIndex    := tmpDav5->( Ads_CreateTmpIndex( ::cdirW +'tmpDav5'  , ;
                                                       'tmpDav5'  , ;
                                                        indexKey  , ;
                                                                    ) )

  nSumaHOD := 0

  drgServiceThread:progressInc()

  TmpDav5 ->( dbGoTop())

  DO WHILE !TmpDav5 ->( Eof())
    nVYK := Val( TmpDav5 ->cNazPol2)
    IF nVYK < 800 .OR. nVYK == 870
      nSumaHOD += TmpDav5 ->nHodDoklad
    ENDIF
    TmpDav5 ->( dbSkip())
  ENDDO

  TmpDav5 ->( dbGoTop())

  DO WHILE !TmpDav5 ->( Eof())
    nVYK := Val( TmpDav5 ->cNazPol2)
    IF nVYK < 800 .OR. nVYK == 870
      TmpDav5 ->nTMPnum3 := (TmpDav5 ->nHodDoklad*100)/(nSumaHOD*100)
    ENDIF
    TmpDav5 ->( dbSkip())
  ENDDO

  nVAL := 0

  kalkzem ->( dbGoTop())

  DO WHILE !kalkzem ->( Eof())
    nVYK := Val( kalkzem ->cNazPol2)
    kalkzem ->nPrimNAKL  := Round( kalkzem ->nPrimNAKL,  0)
    kalkzem ->nSpoVlVyr  := Round( kalkzem ->nSpoVlVyr,  0)
    kalkzem ->nVnNakPoCi := Round( kalkzem ->nVnNakPoCi, 0)
    kalkzem ->nOdpVedlVy := Round( kalkzem ->nOdpVedlVy, 0)
    kalkzem ->nVyrRezie  := Round( kalkzem ->nVyrRezie,  0)
    kalkzem ->nCelDruRez := Round( kalkzem ->nCelDruRez, 0)
    IF nVYK == 850 .OR. nVYK == 860 .OR. nVYK == 890 .OR. nVYK == 891        ;
       .OR. nVYK == 893 .OR. nVYK == 894 .OR. nVYK == 895 .OR. nVYK == 896  ;
         .OR. nVYK == 898 .OR. nVYK == 899 .OR. nVYK == 955
      nVAL += kalkzem ->nPrimNAKL
    ENDIF
    kalkzem ->( dbSkip())
  ENDDO

  * poslední prùchod ***********************************************************
  kalkzem ->( dbGoTop())

  DO WHILE !kalkzem ->( Eof())
    nVYK := Val( kalkzem ->cNazPol2)
    kalkzem ->nVyrNakl   := kalkzem ->nPrimNAKL +kalkzem ->nSpoVlVyr  ;
                              +kalkzem ->nVnNakPoCi +kalkzem ->nVyrRezie
    kalkzem ->nNakBezCDR := Round( kalkzem ->nVyrNakl   - kalkzem ->nOdpVedlVy, 0)
    kalkzem ->nNakSCDR   := Round( kalkzem ->nNakBezCDR + kalkzem ->nCelDruRez, 0)
    kalkzem ->nNakJedBeC := kalkzem ->nNakBezCDR / kalkzem ->nVyrobaMn
    kalkzem ->nNakJedSC  := kalkzem ->nNakSCDR   / kalkzem ->nVyrobaMn
    kalkzem ->cPrimNAKL  := StrTran( Str( Round( kalkzem ->nPrimNAKL,  0)), ".", ",")
    kalkzem ->cSpoVlVyr  := StrTran( Str( Round( kalkzem ->nSpoVlVyr,  0)), ".", ",")
    kalkzem ->cVnNakPoCi := StrTran( Str( Round( kalkzem ->nVnNakPoCi, 0)), ".", ",")
    kalkzem ->cVyrRezie  := StrTran( Str( Round( kalkzem ->nVyrRezie,  0)), ".", ",")

    kalkzem ->cVyrNakl   := StrTran( Str( Round( kalkzem ->nVyrNakl,   0)), ".", ",")
    kalkzem ->cOdpVedlVy := StrTran( Str( Round( kalkzem ->nOdpVedlVy, 0)), ".", ",")
    kalkzem ->cNakBezCDR := StrTran( Str( Round( kalkzem ->nNakBezCDR, 0)), ".", ",")
    kalkzem ->cCelDruRez := StrTran( Str( Round( kalkzem ->nCelDruRez, 0)), ".", ",")
    kalkzem ->cNakSCDR   := StrTran( Str( Round( kalkzem ->nNakSCDR,   0)), ".", ",")
    kalkzem ->cVyrobaMn  := StrTran( Str( Round( kalkzem ->nVyrobaMn,  0)), ".", ",")
    kalkzem ->cNakJedBeC := StrTran( Str( kalkzem ->nNakJedBeC), ".", ",")
    kalkzem ->cNakJedSC  := StrTran( Str( kalkzem ->nNakJedSC), ".", ",")

    kalkzem ->( dbSkip())
  ENDDO

  kalkzem ->( dbGoTop())

  DO WHILE !kalkzem ->( Eof())
    lOK := IF( kalkzem ->nPrimNakl <> 0, .T.,           ;
            IF( kalkzem ->nSpoVlVyr <> 0, .T.,          ;
             IF( kalkzem ->nVnNakPoCi <> 0, .T.,        ;
              IF( kalkzem ->nVyrRezie <> 0, .T.,        ;
               IF( kalkzem ->nVyrNakl <> 0, .T.,        ;
                IF( kalkzem ->nOdpVedlVy <> 0, .T.,     ;
                 IF( kalkzem ->nNakBezCDR <> 0, .T.,    ;
                  IF( kalkzem ->nCelDruRez <> 0, .T.,   ;
                   IF( kalkzem ->nNakSCDR <> 0, .T.,   ;
                    IF( kalkzem ->nVyrobaMn <> 0, .T., .F.))))))))))

    IF( !lOK, kalkzem ->( dbDelete()), NIL)
    kalkzem ->( dbSkip())
  ENDDO

  dbSelectArea( "KalkKtm")

  kalkzem->( dbGoTop())

/*
  do while .not. kalkzem->( Eof())
    mh_copyFLD('kalkzem','kalkktm', .t. )
    kalkzem->( dbSkip())
  enddo

  *
  cTXTKALK := homAdr + 'kalkzem.txt'
  COPY TO ( cTXTKALK) SDF ALL
  cTXTKALK := homAdr + 'Kalk_RVb.txt'
  cPOLE    := "cOznac,cPrimNakl,cNazPol2"
  COPY TO ( cTXTKALK) FOR Kalk_Rvb() SDF ALL
  cTXTKALK := homAdr + 'Kalk_RVp.txt'
  COPY TO ( cTXTKALK) FOR Kalk_Rvp() SDF ALL
  cTXTKALK := homAdr + 'Kalk_ZV.txt'
  COPY TO ( cTXTKALK) FOR Kalk_ZV() SDF ALL

  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  kalkzem->( dbGoTop())
*/

  drgServiceThread:progressEnd()

  ::dm:refresh()

  dc:oBrowse[1]:oxbp:refreshAll()

RETURN( NIL)

/*

METHOD UCT_skunakst_CRD:ImportMdav(drgDialog)
  local cPath, cFile, cIndex
  local key

  cPath  := AllTrim( SysConfig( "System:cPathUcto"))
  IF( Right( cPath, 1) <> "\", cPath := cPath +"\", NIL)

  cPath := StrTran( cpath, 'UCTO\DAT', 'MZDY\DAT\POHYBY')

  cFile  := cpath +'M_dav.dbf'
  cIndex := cpath +'M_dav.cdx'

  drgDBMS:open('m_dav')

  if drgIsYESNO(drgNLS:msg('Naèíst hrubé mzdy za [' +uctOBDOBI:MZD:COBDOBI +'] ?'))
    if File(cFile) .and. file(cIndex)
      key := uctOBDOBI:MZD:NROK
      drgServiceThread:progressStart( drgNLS:msg('Ruším pøedchozí mzdy'), m_dav->( mh_COUNTREC()))
      m_dav->( dbGoTop())
      do while .not. m_dav->( Eof())
        if m_dav->nrok = key
          if m_dav->( RLock())
            m_dav->( dbDelete())
          endif
          m_dav->( dbUnlock())
        endif
        drgServiceThread:progressInc()
        m_dav->( dbSkip())
      enddo
      drgServiceThread:progressEnd()

      dbUseArea( .T.,'FOXCDX', cFile,'MdavOld',.T.)
*      uctold->(DbSetIndex(cindex))

*      UctOld->( AdsSetOrder(6))
      MdavOld->( AdsSetOrder(0))
*      UctOld->( dbSetScope( SCOPE_BOTH, key), dbgoTop())
      drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy'), MdavOld->( LastRec()))
      MdavOld->( dbGoTop())

      do while .not. MdavOld->( Eof())
        if MdavOld->nRok == key
          if MdavOld->cUloha =='M'
            mh_COPYFLD('MdavOld', 'm_dav', .T.)
            m_dav->( dbUnlock())
          endif
        endif
        drgServiceThread:progressInc()
        MdavOld->( dbSkip())
      enddo
      drgServiceThread:progressEnd()
      MdavOld->( dbCloseArea())
    else
      MsgBox( 'Chybí vstupní soubory'+' '+ cPath +' !!!', 'CHYBA...' )
    endif
  endif
RETURN nil
*/


method UCT_skunakst_CRD:ucetsys_ks(obdDokl)
  local  anUc := {}

  drgDBMS:open('ucetsys')

  fordRec({'UCETSYS,3'})
  ucetsys->( DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())
  ucetsys->( dbSeek('U' +obdDokl))

  do while .not. ucetsys->(eof())
    if( ucetsys->nAKTUc_KS = 2, AAdd(anUc, ucetsys->(recNo())), nil)
    ucetsys->(dbSkip())
  enddo

  if ucetsys->(sx_rlock(anUc))
    AEval(anUc, {|x| ( ucetsys->(dbGoTo(x))          , ;
                       ucetsys->nAKTUc_KS := 1       , ;
                       ucetsys->cuctKdo   := logOsoba, ;
                       ucetsys->ductDat   := date()  , ;
                       ucetsys->cuctCas   := time()    ) })
  endif

  ucetsys->(dbCommit(), dbUnlock(), dbClearScope())
  fordRec()
return




********************************************************************************
Static Function NaplnUP( ndokl, nx, n)
  UcetPola ->( dbAppend())
  UcetPola ->cDenik   := "YS"
  UcetPola ->nRok     := nRok
  UcetPola ->cObdobi  := StrZero( nObdDO, 2) +"/" +Right( AllTrim( Str( nRok)), 2)
  UcetPola ->nObdobi  := nObdDO
  UcetPola ->nDoklad  := nDokl
  UcetPola ->nOrdItem := nX
  UcetPola ->nOrdUcto := n
  UcetPola ->nSubUcto := 1
  UcetPola ->cTypUCT  := ""
  UcetPola ->nRecItem := 0
Return( nil)


Static Function TypCASE()
  Local cTYP

  DO CASE
  CASE UcetPola ->cNazPol2 <= "399"  ;   cTYP := "1"
  CASE UcetPola ->cNazPol2 <= "699"  ;   cTYP := "2"
  CASE UcetPola ->cNazPol2 <= "799"  ;   cTYP := "3"
  CASE UcetPola ->cNazPol2 <= "849"  ;   cTYP := "4"
  CASE UcetPola ->cNazPol2 <= "899"  ;   cTYP := "5"
  CASE UcetPola ->cNazPol2 <= "929"  ;   cTYP := "6"
  CASE UcetPola ->cNazPol2 <= "959"  ;   cTYP := "7"
  CASE UcetPola ->cNazPol2 <= "964"  ;   cTYP := "9"
  CASE UcetPola ->cNazPol2 <= "969"  ;   cTYP := "8"
  CASE UcetPola ->cNazPol2 <= "973"  ;   cTYP := "9"
  CASE UcetPola ->cNazPol2 <= "999"  ;   cTYP := "8"
  ENDCASE
Return( cTYP)


Static Function GenUctPolS(cden, cuct)
  dbSelectArea( "UcetPola")
  UcetPola->(OrdSetFocus('TMucpoa1'))

  filter := '(strZero(nrok,4) = "' +strZero(nrok,4) +'"' +             ;
            ' .and. strZero(nobdobi,2) <= "' +strzero(nObdDo,2) +'"'+  ;
            ' .and. Upper(cDenik) = "'+ cden+'"'+                      ;
            ' .and. Upper(cUcetMD) = "'+ cuct+'"'+                     ;
            ' .and. strZero(nOrdUcto) = "1")'
  UcetPola ->(Ads_setAof(filter),DbGoTop())

  if( Select('UcetPolS')<>0, UcetPolS ->(dbCloseArea()), nil)
  UcetPola ->( dbTotal( ( cUcetPolS)    ,  ;
                                 { || UcetPola ->cNazPol1 +UcetPola ->cNazPol2 +Left(UcetPola ->cSklPol,8) },  ;
                                 {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' } ,, ))
  ucetpola->(ADS_clearAOF())

Return( nil)


Static Function NewDokl_AS()
  LOCAL  nDokl
  LOCAL  cSCOPE, cTAGold, nRECold
  LOCAL  xKEY := StrZero( nRok, 4) +StrZero( nObdDo, 2) +Upper("YS")

  nRECold := UcetPola ->( Recno())
  cTAGold := UcetPola ->( OrdSetFOCUS())
  cSCOPE  := UcetPola ->( dbScope())

  UcetPola ->( OrdSetFOCUS( AdsCtag( 9 )))
  UcetPola->( dbSetScope( SCOPE_BOTH, xkey))

  UcetPola ->( dbGoBotTom())
  nDokl := IF( UcetPola ->nDoklad = 0                                       ;
                , Val( StrZero( nRok, 4) +StrZero( nObdDo, 2) +"0001")      ;
                                            , UcetPola ->nDoklad +1)

  IF !Empty( cSCOPE)
    UcetPola ->( OrdSetFOCUS( cTAGold))
    UcetPola->( dbSetScope( SCOPE_BOTH, cSCOPE))
  else
    UcetPola->( dbClearScope())
  endif

  UcetPola ->( OrdSetFOCUS( cTAGold))
  UcetPola ->( dbGoTo( nRECold))
Return( nDokl)


Function Kalk_RVb()
  LOCAL lOK

 lOK := Val( KalkKtm ->cNazPol2) >= 100 .AND. Val( KalkKtm ->cNazPol2) <= 399
RETURN( lOK)


Function Kalk_RVp()
  LOCAL lOK

  lOK := Val( KalkKtm ->cNazPol2) >= 400 .AND. Val( KalkKtm ->cNazPol2) <= 590
RETURN( lOK)


Function Kalk_ZV()
  LOCAL lOK

  lOK := Val( KalkKtm ->cNazPol2) >= 700 .AND. Val( KalkKtm ->cNazPol2) <= 799
RETURN( lOK)


Function VyberMDAV(cdirW)
  Local  lOk, lOPRAVY
  Local  nX, cTmp
  Local  cFILE, cFI
  Local  cMDavI  := homAdr + 'M_DavI'
  Local  nHodCelkem, nKeyCNT

  if Select( 'tmpDav3') <> 0
    tmpdav3->( dbCloseArea())
  endif

  m_dav->(ads_clearAOF(), ordSetFocus(0) )

  *
  indexKey  := 'cnazPol1 +cnazPol2'
  filtrmdav := 'nRok = %% .and. nObdobi <= %%'
  condition := format( filtrmdav, { nrok, nobdobi })

  hIndex    := m_dav ->( Ads_CreateTmpIndex( cdirW +'m_davw8'    , ;
                                                    'm_davw8'    , ;
                                                     indexKey    , ;
                                                                 , ;
                                                                 , ;
                                                     ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                     .f.          ))

  m_dav->( ordSetFocus(0), dbgoTop())
  m_dav->( ads_setAof( condition ), dbgoTop())

  do while .not. m_dav->(eof())
    nnazPol2 := val( m_dav->cnazPol2)
    lstroj   := if( c_vnsast->( dbseek( m_dav->cnazPol5))         ;
                    ,AllTrim(c_vnsast->cnazpol2)== AllTrim(cnakpo2), .f.)

    if( nnazPol2 < 800 .and. .not. empty(  m_dav->cnazPol5) .and. lstroj )
      m_dav->(AdsAddCustomKey( hIndex ))
    endif

    m_dav->(dbskip())
  enddo

  m_dav->( ordSetFocus( 'm_davw8' ), dbgoTop() )

  if m_dav->(Ads_GetKeyCount()) = 0
    m_dav->( ordSetFocus(0), dbgoTop())

    do while .not. m_dav->(eof())
      nnazPol2 := val( m_dav->cnazPol2)

      if( nnazPol2 < 800 .and. .not. empty(  m_dav->cnazPol5))
        m_dav->(AdsAddCustomKey( hIndex ))
      endif

      m_dav->(dbskip())
    enddo
  endif


  *
  ctmpDav := cdirW +'tmpDav3'

  m_dav ->( ads_clearAOF(), ordSetFocus( 'm_davw8'), dbgoTop())
  m_dav ->( dbTotal( ctmpDav    ,  ;
                   { || cnazPol1 +cnazPol2},  ;
                   {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))

  dbUsearea( .t., oSession_free, (ctmpDav),, .f.)

  TmpDav3 ->( dbGoTop())
  nHodCelkem := 0

  DO WHILE .not. tmpDav3 ->( Eof())
    nHodCelkem += TmpDav3 ->nHodDoklad
    TmpDav3 ->( dbSkip())
  ENDDO

  tmpDav3 ->( dbGoTop())

  DO WHILE .not. tmpDav3 ->( Eof())
    TmpDav3 ->nTMPnum4 := ( TmpDav3 ->nHodDoklad/nHodCelkem) * 1000000
    TmpDav3 ->( dbSkip())
  ENDDO

  * pro kontrolu
  dbselectArea('tmpDav3')
  cTXTKALK := homAdr +"Mdav"+AllTrim( TmpDav3 ->cNazPol2) +".TXT"
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nTMPnum4 SDF

  tmpDav3 ->( dbGoTop())
Return(lOk)

*
**
function VyberZAKL( cTYP,cdirW)
  local  ctmpUct := cdirW +'ZaklUct'

  if Select( 'zakluct') <> 0
    zakluct->( dbCloseArea())
  endif

  *
  indexKey   := 'cnazPol1 +cnazPol2'
  zak_rez    := 'nRok = %% .and. nObdobi <= %%'
  condition  := format( zak_rez, { nrok, nobdobi })

  hIndex     := ucetpol->( Ads_CreateTmpIndex( cdirW +'ucetpolw21' , ;
                                                      'ucetpolw21' , ;
                                                       indexKey   , ;
                                                                  , ;
                                                                  , ;
                                                       ADS_COMPOUND +ADS_CUSTOM +ADS_NOT_AUTO_OPEN, ;
                                                       .f.          ))

  ucetpol->( ordSetFocus(0), dbgoTop())
  ucetpol->( ads_setAof( condition ), dbgoTop())

  do while .not. ucetpol->(eof())
    ok := .f.

    do case
    case ctyp = 'RV'  ;  ok := Zak_RezRV()
    case ctyp = 'ZV'  ;  ok := Zak_RezZV()
    case ctyp = 'CD'  ;  ok := Zak_RezCD()
    endcase

    if ok
      ucetpol->(AdsAddCustomKey( hIndex ))
    endif

    ucetpol->(dbskip())
  enddo


  ucetpol->( ads_clearAOF(), ordSetFocus('ucetpolw21'), dbgoTop())
  if( select( 'zaklUct') <> 0, zaklUct->(dbcloseArea()), nil )

  ucetpol ->( dbTotal( ctmpUct, ;
                     { || cnazPol1 +cnazPol2 }, ;
                     { 'nkcMd' },, ))

  dbUsearea( .t., oSession_free, (ctmpUct),, .f.)

  ZaklUct ->( dbGoTop())
  nZaklCelkem := 0

  DO WHILE !ZaklUct ->( Eof())
    nZaklCelkem += ZaklUct ->nKcMD
    ZaklUct ->( dbSkip())
  ENDDO

  ZaklUct ->( dbGoTop())
  DO WHILE !ZaklUct ->( Eof())
    ZaklUct ->nMnozNat2 := 0
    ZaklUct ->nMnozNat2 := ( ZaklUct ->nKcMD/nZaklCelkem) * 1000000
    ZaklUct ->( dbSkip())
  ENDDO


  * pro kontrolu
  dbselectArea('zaklUct')
  cTXTKALK := homAdr + 'ZaklUct.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,nKcMD,nMnozNat2 SDF

  ZaklUct ->( dbGoTop())
return nil


static function Zak_RezRV()
  LOCAL lOK
  LOCAL lUCTY

  lUCTY := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
             .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
              .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
               .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                     .OR. ( VAL( UcetPol ->cUcetMD) >= 613311            ;
                      .AND. VAL( UcetPol ->cUcetMD) <= 613329))          ;
                       .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"   ;
                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := ( ( Val( UcetPol ->cNazPol2) >= 100 .AND. Val( UcetPol ->cNazPol2) <= 290)         ;
           .OR. ( Val( UcetPol ->cNazPol2) >= 400 .AND. Val( UcetPol ->cNazPol2) <= 590)) ;
           .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo
RETURN( lOK)


static function Zak_RezZV()
  LOCAL lOK
  LOCAL lUCTY

  lUCTY := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
             .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
              .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
               .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                     .OR. ( VAL( UcetPol ->cUcetMD) >= 613311            ;
                      .AND. VAL( UcetPol ->cUcetMD) <= 613329))          ;
                       .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"   ;
                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := Val( UcetPol ->cNazPol2) >= 700 .AND. Val( UcetPol ->cNazPol2) <= 799    ;
              .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo
RETURN( lOK)


static function Zak_RezCD()
  LOCAL lOK
  LOCAL lUCTY

  lUCTY := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
             .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
              .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
               .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                     .OR. ( VAL( UcetPol ->cUcetMD) >= 613311            ;
                      .AND. VAL( UcetPol ->cUcetMD) <= 613329))          ;
                       .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"   ;
                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := ( ( Val( UcetPol ->cNazPol2) >= 100 .AND. Val( UcetPol ->cNazPol2) <= 290)        ;
            .OR. ( Val( UcetPol ->cNazPol2) >= 400 .AND. Val( UcetPol ->cNazPol2) <= 590) ;
            .OR. ( Val( UcetPol ->cNazPol2) >= 700 .AND. Val( UcetPol ->cNazPol2) <= 799) )   ;
            .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo
RETURN( lOK)