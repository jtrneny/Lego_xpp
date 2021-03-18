//////////////////////////////////////////////////////////////////////
//
//  Asystem++_login.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2005. All rights reserved.
//
//  Contents:
//       Login Asystem++Dialog.
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"

Static nHandle
Static nRok, nObdDo
Static lNetWare
Static lTesty
Static cNAKpo2
Static netAdr, homAdr
Static cUcetPolS


**  Aktualizace licenèních údajù
** CLASS for SYS_users_IN *********************************************
CLASS UCT_skunakst_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  onSave
  METHOD  dir
  METHOD  rozpustit
  METHOD  kalkulace

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

ENDCLASS


METHOD UCT_skunakst_CRD:init(parent)

  ::ddatzprac := Date()
  drgDBMS:open('kalkzem',.t.)

  ::drgUsrClass:init(parent)

RETURN self




METHOD UCT_skunakst_CRD:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  netAdr := drgINI:dir_DATA
  homAdr := drgINI:dir_USERfitm

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

  lNetWare := .T.
  nStor960 := nStor961 := nStor962 := nStor970 := 0

  nRok   := uctOBDOBI:UCT:nrok
  nObdDO := uctOBDOBI:UCT:nobdobi

  cUcetPolS := homAdr + 'UcetPolS'

//  dbUseArea( .t., "FOXCDX", ( cMdav),,     if( .T. .or. .F., lNetWare, NIL ), .f. )
//  dbUseArea( .t., "FOXCDX", ( cUcetPOL),,  if( .T. .or. .F., lNetWare, NIL ), .f. )

  drgDBMS:open('m_dav')
  drgDBMS:open('ucetpol')

  drgDBMS:open('ucetpola')
  drgDBMS:open('ucetkum')
  ucetkum ->( OrdSetFOCUS( AdsCtag( 1 )))
  drgDBMS:open('c_vnsast')
  c_vnsast ->( OrdSetFOCUS( AdsCtag( 1)))

  nCount := 1

// --------------- odpracovany vìkon stroj… ----------------
  dbSelectArea( "m_dav")
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní skuteèných prací strojù na výkonech ...'),10)

  drgServiceThread:progressInc()
  cTmpDav := drgINI:dir_USERfitm +'TmpDav2'

  m_dav->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'TmpDav2', 'TmpDav2', 'cNazPol1+cNazPol2', Filtr1()))
    m_dav->(ordSetFocus('TmpDav2'), dbGotop())

//  INDEX ON M_Dav->cNazPol1 +M_Dav->cNazPol2 TO ( cMDavI) FOR Filtr1()

  drgServiceThread:progressInc()

  m_dav ->( dbGoTop())
  m_dav ->( dbTotal(  cTmpDav     ,  ;
                     { || cNazPol1 +cNazPol2 },  ;
                     {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))
  drgServiceThread:progressInc()

  dbUseArea( .t., oSession_free, ( cTmpDav),, if( .T. .or. .F., .F., NIL ), .f. )
  tmpdav2->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'TmpDav2', 'TmpDav2', 'cNazPol1+cNazPol2', Filtr1()))
    tmpdav2->(ordSetFocus('TmpDav2'), dbGotop())
//  INDEX ON TmpDav2 ->cNazPol1 +TmpDav2 ->cNazPol2 TO (cTmpDav)
  drgServiceThread:progressInc()

  cTXTKALK := homAdr + 'StrVyOdD.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nHrubaMzd SDF
  drgServiceThread:progressInc()

  dbSelectArea( "M_Dav")
  cTmpDav := homAdr +'TmpDav3'
  INDEX ON M_Dav ->cNazPol1 +M_Dav ->cNazPol2 +M_Dav ->cNazPol5 TO ( cMDavI) FOR Filtr1()
  M_Dav ->( dbGoTop())
  M_Dav ->( dbTotal( ( cTmpDav )    ,  ;
                           { || M_Dav ->cNazPol1 +M_Dav ->cNazPol2 +M_Dav ->cNazPol5},  ;
                           {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cTmpDav),, if( .T. .or. .F., .F., NIL ), .f. )
  TmpDav3 ->( dbGoTop())
  DO WHILE !TmpDav3 ->( Eof())
    TmpDav2 ->( dbSeek( TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 ))
    // kolik se stroj pod¡lel na pr ci za pý¡sluçnì vìkon
    TmpDav3 ->nTMPnum4 := ( TmpDav3 ->nHodDoklad/TmpDav2 ->nHodDoklad) * 1000
    TmpDav3 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

  cTXTKALK := homAdr + 'StVyStMz.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nHodDoklad,nMnPDoklad,nHrubaMzd,nTmpNum4 SDF

  dbSelectArea( "M_Dav")
  cTmpDav := homAdr +'TmpDav6'
  INDEX ON M_Dav ->cNazPol5 TO ( cMDavI) FOR Filtr1()

  M_Dav ->( dbGoTop())
  M_Dav ->( dbTotal( ( cTmpDav )    ,  ;
                            { || M_Dav ->cNazPol5 },  ;
                            {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))
  dbUseArea( .t., "FOXCDX", ( cTmpDav),, if( .T. .or. .F., .F., NIL ), .f. )
  drgServiceThread:progressInc()

  INDEX ON TmpDav6 ->cNazPol5 TO (cTmpDav)

  cTXTKALK := homAdr + 'StrojOdD.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,nHodDoklad,nMnPDoklad,nHrubaMzd SDF

  dbSelectArea( "M_Dav")
  cTmpDav := homAdr +'TmpDav7'
  INDEX ON M_Dav ->cNazPol5 +M_Dav ->cNazPol1 +M_Dav ->cNazPol2 TO ( cMDavI) FOR Filtr1()
  M_Dav ->( dbGoTop())
  M_Dav ->( dbTotal( ( cTmpDav )    ,  ;
               { || M_Dav ->cNazPol5 +M_Dav ->cNazPol1 +M_Dav ->cNazPol2},  ;
               {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cTmpDav),, if( .T. .or. .F., .F., NIL ), .f. )
  TmpDav7 ->( dbGoTop())
  DO WHILE !TmpDav7 ->( Eof())
    TmpDav6 ->( dbSeek( TmpDav7 ->cNazPol5))
    TmpDav7 ->nTMPnum4 := ( TmpDav7 ->nHodDoklad/TmpDav6 ->nHodDoklad) * 1000
    TmpDav7 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

  dbSelectArea( "TmpDav7")
  INDEX ON TmpDav7 ->cNazPol5 +TmpDav7 ->cNazPol1 +TmpDav7 ->cNazPol2 TO (cTmpDav)

  cTXTKALK := homAdr + 'StrVykSt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nHrubaMzd,nTMPnum4 SDF

  dbSelectArea( "TmpDav3")
  TmpDav3 ->( dbGoTop())
  DO WHILE !TmpDav3 ->( Eof())
    TmpDav7 ->( dbSeek( TmpDav3 ->cNazPol5 +TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2))
    TmpDav3 ->nTMPnum3 := TmpDav7 ->nTMPnum4
    TmpDav3 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()


  cTXTKALK := homAdr + 'StrVySt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nUcetMzdy,nHodDoklad,nMnPDoklad,nTMPnum3,nTMPnum4  SDF

  drgServiceThread:progressEnd()
*  Box_Make()

// --------------- skuteèné‚ náklady na stroje podle úètù ----------------
  drgServiceThread:progressStart( drgNLS:msg( 'Zjištìní skuteèných nákladù na stroje podle úètù ...'),2)

  drgServiceThread:progressInc()

  dbSelectArea( "UcetPol")
  INDEX ON UcetPol ->cNazPol5 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNakl()
  drgServiceThread:progressInc()

  UcetPol ->( dbGoTop())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
               { || UcetPol ->cNazPol5 +UcetPol ->cUcetMD},  ;
               {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()

  drgServiceThread:progressEnd()


// --------------- skuteèné‚ náklady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní skuteèných nákladù výkony za stroje ...'),3)

  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol5 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  cTXTKALK := homAdr + 'SkuNakSU.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,cUcetMD,nKcMD SDF

  UcPSNak1 ->( dbGoTop())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                 { || UcPSNak1 ->cNazPol5 },  ;
                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())


  cTXTKALK := homAdr +'SkuNakSt.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol5,nKcMD SDF
  UcPSNak2 ->( dbGoTop())
  drgServiceThread:progressInc()

  drgServiceThread:progressEnd()

// --------------- vnitropodnikové výnosy na bez stroj… podle £Ÿt… ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní vnitropodnikových výnosù a nákladù na výkony za stroje ...'),14)
  drgServiceThread:progressInc()
  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol5 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPVVyn1()
  drgServiceThread:progressInc()

  UcetPol ->( dbGoTop())
  COPY TO ( cUcPVVyn1)
  drgServiceThread:progressInc()
// --------------- vnitropodnikov‚ n klady na stroje podle £Ÿt… ----------------
  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol5 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPVNak1()
  drgServiceThread:progressInc()

  UcetPol ->( dbGoTop())
  COPY TO ( cUcPVNak1)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPVVyn1),, if( .T. .or. .F., .F., NIL ), .f. )
        dbSelectArea( "UcPVVyn1")
  INDEX ON StrZero( UcPVVyn1 ->nRok) +StrZero( UcPVVyn1 ->nObdobi)       ;
                  +UcPVVyn1 ->cDenik +StrZero( UcPVVyn1 ->nDoklad)             ;
                                                 +StrZero( UcPVVyn1 ->nOrdItem) TO ( cUcPVVyn1)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPVNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPVNak1")
  UcPVNak1 ->( dbGoTop())

  cTXTKALK := homAdr +'NaklStrO.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nKcMD SDF
  UcPVNak1 ->( dbGoTop())
  DO WHILE !UcPVNak1 ->( Eof())
    xKEY := StrZero( UcPVNak1 ->nRok) +StrZero( UcPVNak1 ->nObdobi)       ;
             +UcPVNak1 ->cDenik +StrZero( UcPVNak1 ->nDoklad)             ;
              +StrZero( UcPVNak1 ->nOrdItem)
    IF UcPVVyn1 ->( dbSeek( xKEY))
      UcPVNak1 ->cNazPol5  := UcPVVyn1 ->cNazPol5
      UcPVVyn1 ->cPrizLikv := "W"
    ENDIF
    UcPVNak1 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

  dbSelectArea( "UcPVNak1")
  COPY TO ( cTmpVNUct)
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cTmpVNUct),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "TmpVNUct")

  // spojení vnitropodnikových nákladù a výnosù dohromady
*  if( Select('UcPVVyn1') > 0, UcPVVyn1 ->( dbCloseArea()), nil)
*  APPEND FROM ( cUcPVVyn1) FOR UcPVVyn1->cPrizLikv == "W"

  UcPVVyn1->( dbGoTop())
  do while .not. UcPVVyn1->( Eof())
    if UcPVVyn1->cPrizLikv == "W"
      mh_copyFLD('UcPVVyn1','TmpVNUct',.T.)
    endif
    UcPVVyn1->( dbSkip())
  enddo
  drgServiceThread:progressInc()

  INDEX ON StrZero( TmpVNUct ->nRok) +StrZero( TmpVNUct ->nObdobi)          ;
            +TmpVNUct ->cDenik +StrZero( TmpVNUct ->nDoklad)                ;
             +StrZero( TmpVNUct ->nOrdItem) +StrZero( TmpVNUct ->nSubUcto)  ;
              +StrZero( TmpVNUct ->nOrdUcto) TO ( cTmpVNUct)
  drgServiceThread:progressInc()


  dbSelectArea( "UcetPola")//dbSelectArea( "TmpVNUct")
  COPY TO ( cTUcetPQA) FOR UcetPola ->cDenik == "YQ"
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cTUcetPQA),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "TUcetPQA")
  INDEX ON StrZero( TUcetPQA ->nMainItem, 6)                                    ;
             +Left( TUcetPQA ->cZkratJed2, 2) +StrZero( TUcetPQA ->nDokladOrg,10) ;
              +StrZero( TUcetPQA ->nOrdItem,5) +StrZero( TUcetPQA ->nSubUcto,2)   ;
               +StrZero( TUcetPQA ->nOrdUcto,1) TO ( cTUcetPQA)
  drgServiceThread:progressInc()

  UcetPola ->( OrdSetFOCUS( AdsCtag( 12 )))
  TmpVNUct ->( dbGoTop())
  DO WHILE !TmpVNUct ->( Eof())
    cX := StrZero(TmpVNUct ->nRok) +StrZero( TmpVNUct ->nObdobi)             ;
            +TmpVNUct ->cDenik +StrZero( TmpVNUct ->nDoklad)                 ;
             +StrZero( TmpVNUct ->nOrdItem) +StrZero( TmpVNUct ->nSubUcto,2) ;
              +StrZero( TmpVNUct ->nOrdUcto)

    IF !TUcetPQA ->( dbSeek( cX))
      UcetPola ->( dbAppend())
      FOR nField = 1 TO UcetPola ->( Fcount())
        nFieldTMP := TmpVNUct ->( FieldPos( UcetPola ->( FieldName( nField))))
        IF nFieldTMP <> 0
          UcetPola ->( FieldPut( nField, TmpVNUct ->( FieldGet( nFieldTMP))))
        ENDIF
      NEXT

      UcetPola ->cDenik     := "YQ"
      UcetPola ->nRok       := nRok
      UcetPola ->cObdobi    := StrZero( nObdDO, 2) +"/" +Right( AllTrim( Str( nRok)), 2)
      UcetPola ->nObdobi    := nObdDO
      UcetPola ->nKcMD      := UcetPola ->nKcMD  * (-1)
      UcetPola ->nKcDAL     := UcetPola ->nKcDAL * (-1)
      UcetPola ->cText      := "Odúètování VN nákladù za stroje"
      UcetPola ->nDokladOrg := TmpVNUct ->nDoklad
      UcetPola ->nMainItem  := Val( StrZero( TmpVNUct ->nRok, 4)             ;
                                  +StrZero( TmpVNUct ->nObdobi, 2))
      UcetPola ->cZkratJed2 := TmpVNUct ->cDenik
      IF( UcetPola ->cTypUCT == "76", UcetPola ->cNazPol5 := "", NIL)

      DO CASE
      CASE UcetPola ->cNazPol2 = "960"
        nStor960 += UcetPola ->nKcMD
      CASE UcetPola ->cNazPol2 = "961"
        nStor961 += UcetPola ->nKcMD
      CASE UcetPola ->cNazPol2 = "962"
        nStor962 += UcetPola ->nKcMD
      CASE UcetPola ->cNazPol2 = "970"
        nStor970 += UcetPola ->nKcMD
      ENDCASE

    ENDIF
    TmpVNUct ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

// --------------- doposud z…Ÿtovan‚ pý¡m‚ n klady stroj… ----------------
  dbSelectArea( "UcetPola")

  ucetpola ->(Ads_CreateTmpIndex( drgINI:dir_USERfitm +'TMucpoa1', 'TMucpoa1',  'cNazPol1+cNazPol2+Left(cSklPol,8)' ))

**  INDEX ON cNazPol1+cNazPol2+Left(cSklPol,8) TO (drgINI:dir_USERfitm +'TMucpoa1') ADDITIVE

  GenUctPolS('YS','5995')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()
*  UcetPola->( OrdDestroy('TMPcdx1'))
  drgServiceThread:progressEnd()


  drgServiceThread:progressStart( drgNLS:msg('Zaúètování skuteèných nákladù na výkony za stroje ...'),3)

  drgServiceThread:progressInc()
  cTXTKALK := homAdr +'NaklStr.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol1,cNazPol2,cNazPol5,nKcMD SDF
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbGoTop())
  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    IF C_VnSaSt ->( dbSeek( Upper( UcPSNak2 ->cNazPol5)))
      IF C_VnSaSt ->cNazPol2 == "890     "
        nWW1 += UcPSNak2 ->nKcMD
      ENDIF
      nWW2 := 0
      TmpDav3 ->( dbGoTop())
      DO WHILE !TmpDav3 ->( Eof())
        IF UcPSNak2 ->cNazPol5 == TmpDav3 ->cNazPol5
          UcPSNak2 ->cUzavreni := "Q"
          xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +TmpDav3 ->cNazPol5
          nX++
          UcetPolS ->( dbSeek( xKey))
          nWW2 += TmpDav3 ->nTmpNum3
          nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum3) / 1000, 2)
          nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
          IF nSkuNakSt <> 0
            FOR n := 1 TO 2
              NaplnUP( ndokl, nx, n)
              UcetPola ->cText    := "Pøímé náklady za stroje"
              cTYP                := TypCASE()
              IF n == 1
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
            NEXT
          ENDIF
        ENDIF
        TmpDav3 ->( dbSkip())
      ENDDO
    ENDIF
    UcPSNak2 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()


// pøípad kdy stroj nepracoval na žádném výkonu

  UcPSNak2 ->( dbGoTop())

  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    IF Empty( UcPSNak2 ->cUzavreni)
      nX    := 0
      nDokl := NewDokl_AS()
      cNAKpo2 := UcPSNak2 ->cNazPol2
      VyberMDAV()
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
              UcetPola ->cText    := "Pøímé náklady za stroje"
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
  drgServiceThread:progressInc()

  drgServiceThread:progressEnd()

// --------------- skuteèné náklady na stroje podle úètù ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní režijních nákladù dílen podle úètù ...'),2)
  drgServiceThread:progressInc()
  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak850()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

// --------------- skuteŸn‚ n klady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('ZjiŠtÌnÍ ostatních nákladù za režii mechanizace ...'),2)
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbTotal( ( cUcPSNak3)    ,  ;
                 { || UcPSNak1 ->cNazPol2 },  ;
                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()


// --------------- skuteŸn‚ n klady na stroje podle £Ÿt… ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní ostatních skuteèných nákladù mechanizace podle úètù ...'),2)
  drgServiceThread:progressInc()
  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak800()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'MechOsVU.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMD,nKcMD,nKcDAL SDF

// --------------- skuteŸn‚ n klady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní ostatních nákladù za výkony mechanizace ...'),3)
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbCloseArea())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                 { || UcPSNak1 ->cNazPol2 },  ;
                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
  APPEND FROM (cUcPSNak3)
  drgServiceThread:progressInc()
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'MechOsVy.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF
  UcPSNak2 ->( dbGoTop())
// --------------- doposud z…Ÿtovan‚ ostatn¡ pý¡m‚ n klady mechanizace -------
  drgServiceThread:progressStart( drgNLS:msg('Zaúètování ostatních skuteèných nákladù mechanizace na výkony ...'),3)
  drgServiceThread:progressInc()

  GenUctPolS('YS','5996')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
        dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbGoTop())
  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberMDAV()

    DO WHILE !TmpDav3 ->( Eof())
      xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum4) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Pøímé náklady mechanizace"
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
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()


// --------------- skuteèné náklady na stroje podle úètù ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní skuteèných nákladù externích strojù ...'),2)
  drgServiceThread:progressInc()

  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak900()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                                 { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                                 {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'MechOsVU.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMD,nKcMD,nKcDAL SDF

// --------------- skuteŸn‚ n klady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní skuteèných nákladù externích strojù ...'),3)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1) FOR TEST850()  // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbCloseArea())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                                 { || UcPSNak1 ->cNazPol2 },  ;
                                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'MechOsVy.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF
  UcPSNak2 ->( dbGoTop())
// --------------- doposud zùètované ostatní pøímé náklady mechanizace -------
  drgServiceThread:progressStart( drgNLS:msg('Zaúètování skuteèných nákladù externích strojù na výkony ...'),3)
  drgServiceThread:progressInc()

  GenUctPolS('YS','5997')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbGoTop())
  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberMDAV()
    DO WHILE !TmpDav3 ->( Eof())
      xKEY := TmpDav3 ->cNazPol1 +TmpDav3 ->cNazPol2 +UcPSNak2 ->cNazPol2
      nX++
      UcetPolS ->( dbSeek( xKey))
      nSkuNakSt := Round( ( UcPSNak2 ->nKcMD * TmpDav3 ->nTmpNum4) / 1000000, 2)
      nSkuNakSt := nSkuNakSt - UcetPolS ->nKcMD
      IF nSkuNakSt <> 0
        FOR n := 1 TO 2
          NaplnUP( ndokl, nx, n)
          UcetPola ->cText    := "Pøímé náklady mechanizace"
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
  drgServiceThread:progressInc()

  drgServiceThread:progressEnd()


// --------------- rozpuštìní režií RV 960 ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (úèty - výkony) pro rozpuštìní režií RV - 960 ...'),2)
  drgServiceThread:progressInc()

  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak960()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                                 { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                                 {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl960uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMD,nKcMD,nKcDAL SDF

// --------------- skuteèné náklady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (výkony) pro rozpuštìní režií RV - 960 ...'),3)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbCloseArea())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                                 { || UcPSNak1 ->cNazPol2 },  ;
                                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl960v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF
  UcPSNak2 ->( dbGoTop())
// --------------- doposud zúètované ostatní pøímé náklady mechanizace -------
  drgServiceThread:progressStart( drgNLS:msg('Zaúètování režie 960 na výkony ...'),3)
  drgServiceThread:progressInc()

  GenUctPolS('YS','5995')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()

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
    VyberZAKL( "RV")
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
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()



// --------------- rozpuštìní režií RV 961 ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (úèty - výkony) pro rozpuštìní režií ZV - 961 ...'),2)
  drgServiceThread:progressInc()

  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak961()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                                 { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                                 {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl961uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMD,nKcMD,nKcDAL SDF

// --------------- skuteèné náklady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (výkony) pro rozpuštìní režií RV - 961 ...'),3)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbCloseArea())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                             { || UcPSNak1 ->cNazPol2 },  ;
                             {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl961v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF
  UcPSNak2 ->( dbGoTop())
// --------------- doposud zúètované ostatní pøímé náklady mechanizace -------
  drgServiceThread:progressStart( drgNLS:msg('Zaúètování režie 961 na výkony ...'),3)
  drgServiceThread:progressInc()

  GenUctPolS('YS','59995')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbGoTop())
  IF nRok = 2009
    UcetKum ->( dbSeek( "200912" +Upper( "699911201     961     ")))
    UcPSNak2 ->nKcMD := UcPSNak2 ->nKcMD - UcetKum ->nKcDalKSR
    UcetKum ->( dbSeek( "200912" +Upper( "699911220     961     ")))
    UcPSNak2 ->nKcMD := UcPSNak2 ->nKcMD - UcetKum ->nKcDalKSR
  ENDIF
  UcPSNak2 ->( dbGoTop())
  nX := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberZAKL( "ZV")
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
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

// --------------- rozpuštìní režií CD 970+962 ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (úèty - výkony) pro rozpuštìní režií CD - 970+962 ...'),2)
  drgServiceThread:progressInc()

  dbSelectArea( "UcetPol")
  UcetPol ->( dbClearInd())
  INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMd TO ( cUcetPolI) FOR UcPSNak970()
  drgServiceThread:progressInc()

  UcPSNak1 ->( dbCloseArea())
  UcetPol ->( dbTotal( ( cUcPSNak1)    ,  ;
                                 { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2 +UcetPol ->cUcetMD},  ;
                                 {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl970uv.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,cUcetMD,nKcMD,nKcDAL SDF


// --------------- skuteèné náklady na stroje ----------------
  drgServiceThread:progressStart( drgNLS:msg('Zjištìní nákladù (výkony) pro rozpuštìní režií CD - 970+962 ...'),3)
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcPSNak1),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak1")
  INDEX ON UcPSNak1 ->cNazPol2 TO ( cUcPSNak1)   // FOR UcPoNakl()
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbCloseArea())
  UcPSNak1 ->( dbTotal( ( cUcPSNak2)    ,  ;
                                 { || UcPSNak1 ->cNazPol2 },  ;
                                 {  'nKcMD', 'nKcDAL' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cUcPSNak2),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcPSNak2")
*  UcPSNak2 ->( DbSetDescend( .T. ))
*  UcPSNak2 ->( Sx_Descend())
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  cTXTKALK := homAdr +'Zakl970v.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF
  UcPSNak2 ->( dbGoTop())


// --------------- doposud zúètované ostatní pøímé náklady mechanizace -------
  drgServiceThread:progressStart( drgNLS:msg('Zaúètování režie 970 + 962 na výkony ...'),3)
  drgServiceThread:progressInc()

  GenUctPolS('YS','59996')
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cUcetPolS),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "UcetPolS")
  INDEX ON UcetPolS ->cNazPol1 +UcetPolS ->cNazPol2 +Left(UcetPolS ->cSklPol,8) TO ( cUcetPolS)
  drgServiceThread:progressInc()

  UcPSNak2 ->( dbGoTop())
  cTXTKALK := homAdr +'Rozp970.TXT'
  COPY TO (cTXTKALK) FIELDS cNazPol2,nKcMD,nKcDAL SDF

  UcPSNak2 ->( dbGoTop())
  nX := 0
  nTest1 := 0
  nTest2 := 0
  DO WHILE !UcPSNak2 ->( Eof())
    nX    := 0
    nDokl := NewDokl_AS()
    cNAKpo2 := UcPSNak2 ->cNazPol2
    VyberZAKL( "CD")
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
  drgServiceThread:progressInc()
  drgServiceThread:progressEnd()

  UcetPol->( dbCloseArea())
  UcetPola->( dbCloseArea())

  drgMsgBox(drgNLS:msg('První krok rozpuštìní skonèil. Proveïte aktualizaci úèetnictví !!!'))


*  UcetPola ->( dbClearInd())
*  INDEX ON StrZero(UcetPola ->nRok) +StrZero(UcetPola ->nObdobi) +UcetPola ->cUcetMd         ;
*                  +UcetPola ->cNazPol1 +UcetPola ->cNazPol2 +UcetPola ->cNazPol3  ;
*                   +UcetPola ->cNazPol4 +UcetPola ->cNazPol5 +UcetPola ->cNazPol6 TO ( cUcetPoIa) FOR FLT_Yx()

*  NaplnKUMwy()

*  UcetPola ->( dbTotal( ( cUcetPolY)    ,  ;
*                 { || StrZero(UcetPola ->nRok) +StrZero(UcetPola ->nObdobi) +UcetPola ->cUcetMd +UcetPola ->cNazPol1 ;
*                       +UcetPola ->cNazPol2 +UcetPola ->cNazPol3+UcetPola ->cNazPol4               ;
*                        +UcetPola ->cNazPol5 +UcetPola ->cNazPol6 },  ;
*                         {  'nKcMD', 'nKcDAL', 'nMnozNAT', 'nMnozNAT2' },,))
*  dbCloseAll()

Return(.T.)


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


Function TEST850()
  LOCAL  lOk

  lOK := UcPSNak1->cNazPol2 <> "850"

Return( lOK)


Function Filtr1()
  Local lOk

  lOk := ( M_Dav ->nRok == nRok .AND. M_Dav ->nObdobi <= nObdDo              ;
           .AND. Val(M_Dav ->cNazPol2) < 800 .AND. !Empty( M_Dav ->cNazPol5))
Return(lOk)


Function UcPSNakl()
  Local lOk, lOPRAVY
  Local nX

  lOPRAVY := SubStr( UcetPol ->cUcetMD,1,3)="599" .AND. SubStr( UcetPol ->cUcetMD,6,1)="8"
  nX      := Val( UcetPol ->cUcetMd)

  lOk := ( UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo .AND. !Empty( UcetPol ->cNazPol5) .AND.(( nX < 599000 .AND. SubStr( UcetPol ->cUcetMD,1,1)="5") .OR. lOPRAVY))

Return(lOk)


Function UcPSNak800()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  lSTROJ := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))) )
  lUCET  := .F.
  IF SubStr( UcetPol ->cUcetMD,1,1)="5"
    lUCET := IF( SubStr( UcetPol ->cUcetMD,1,3)="599"                      ;
                 .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8", lSTROJ, .T.)
  ENDIF

  nX      := Val( UcetPol ->cUcetMd)
  lVYKON  := ( UcetPol ->cNazPol2 = "860" .OR. UcetPol ->cNazPol2 = "890"    ;
                                                 .OR. UcetPol ->cNazPol2 = "891" .OR. UcetPol ->cNazPol2 = "892"  ;
                                                        .OR. UcetPol ->cNazPol2 = "893" .OR. UcetPol ->cNazPol2 = "894" ;
                                                         .OR. UcetPol ->cNazPol2 = "895" .OR. UcetPol ->cNazPol2 = "896" ;
                                                                .OR. UcetPol ->cNazPol2 = "897" .OR. UcetPol ->cNazPol2 = "898" ;
                                                                 .OR. UcetPol ->cNazPol2 = "899" .OR. UcetPol ->cNazPol2 = "955");
                                                 .AND. UcetPol ->cNazPol2 <> "850"


  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)


Function UcPSNak900()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  lSTROJ := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))) )
  lUCET  := .F.
  IF SubStr( UcetPol ->cUcetMD,1,1)="5"
    lUCET := IF( SubStr( UcetPol ->cUcetMD,1,3)="599"                      ;
                 .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8", lSTROJ, .T.)
  ENDIF

  nX      := Val( UcetPol ->cUcetMd)
  lVYKON  := UcetPol ->cNazPol2 = "900" .AND. UcetPol ->cNazPol2 <> "850"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)



Function UcPSNak960()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  nX      := Val( UcetPol ->cUcetMd)
  lSTROJ  := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))))
  lUCET   := .F.
  lUCET := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
                                                        .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
                                                         .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                                                                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                                                                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                                                                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                                                                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                                                                     .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "599"      ;
                                                                                  .OR. ( VAL( UcetPol ->cUcetMD) >= 613311           ;
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lVYKON  := UcetPol ->cNazPol2 = "960"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)


Function UcPSNak961()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  nX      := Val( UcetPol ->cUcetMd)
  lSTROJ  := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))))
  lUCET   := .F.

  lUCET := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
                                                        .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
                                                         .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                                                                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                                                                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                                                                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                                                                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                                                                     .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "599"      ;
                                                                                  .OR. ( VAL( UcetPol ->cUcetMD) >= 613311           ;
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lVYKON  := UcetPol ->cNazPol2 = "961"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)


Function UcPSNak962()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  nX      := Val( UcetPol ->cUcetMd)
  lSTROJ  := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))))
  lUCET   := .F.

  IF SubStr( UcetPol ->cUcetMD,1,1)="5" .AND. nX < 599000
    lUCET := IF( SubStr( UcetPol ->cUcetMD,1,3)="599"                      ;
                 .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8", lSTROJ, .T.)
  ENDIF

  lVYKON  := UcetPol ->cNazPol2 = "962"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)


Function UcPSNak970()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  nX      := Val( UcetPol ->cUcetMd)
  lSTROJ  := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))))
  lUCET   := .F.

  lUCET := ( SubStr( UcetPol ->cUcetMD, 1, 2) == "50"                    ;
                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "51"               ;
                                                        .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "52"              ;
                                                         .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "53"             ;
                                                                .OR. SubStr( UcetPol ->cUcetMD, 1, 2) == "54"            ;
                                                                 .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                                                                  .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "551"          ;
                                                                   .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                                                                    .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "562"         ;
                                                                     .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "568"        ;
                                                                      .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "582"       ;
                                                                       .OR. SubStr( UcetPol ->cUcetMD, 1, 3) == "599"      ;
                                                                            .OR. ( VAL( UcetPol ->cUcetMD) >= 613311           ;
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"


  lVYKON  := UcetPol ->cNazPol2 = "962" .OR. UcetPol ->cNazPol2 = "970"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON .AND. lUCET)

Return(lOk)


Function UcPSNak850()
  Local lOk, lOPRAVY, lSTROJ, lVYKON, lUCET
  Local nX

  nX      := Val( UcetPol ->cUcetMd)
  lSTROJ  := IF( Empty( UcetPol ->cNazPol5), .T., !( C_VnSaSt ->( dbSeek(UcetPol ->cNazPol5))) )
  lOPRAVY := SubStr( UcetPol ->cUcetMD,1,3)="599"                      ;
                 .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8"
  lUCET   := .F.
  IF SubStr( UcetPol ->cUcetMD,1,1)="5" .AND. nX < 599000
    lUCET := IF( SubStr( UcetPol ->cUcetMD,1,3)="599"                      ;
                 .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8", lSTROJ, .T.)
  ENDIF

  lVYKON  := UcetPol ->cNazPol2 = "850"

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo    ;
           .AND. lSTROJ .AND. lVYKON)

Return(lOk)


Function UcPVVyn1()
  Local lOk, lOPRAVY
  Local nX

  lOPRAVY := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"           ;
               .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo   ;
                                              .AND. UcetPol ->cTYPuct = "75"                                  ;
                                                                 .AND.SubStr( UcetPol ->cUcetMD,1,3)="699"                      ;
                   .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8" )

  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"          ;
          .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo   ;
                                          .AND. UcetPol ->cTYPuct = "77")   // .OR. lOPRAVY

Return(lOk)


Function UcPVNak1()
  Local lOk, lOPRAVY, lVYKON, lVYKONno
  Local nX

  lOPRAVY := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"      ;
           .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo  ;
                                           .AND. UcetPol ->cTYPuct = "74"                                ;
                                                  .AND. SubStr( UcetPol ->cUcetMD,1,3) = "599"                 ;
                                                         .AND. SubStr( UcetPol ->cUcetMD,6,1) = "8"                  ;
                                                          .AND. !Empty( UcetPol ->cNazPol5))

  lVYKON  :=  Val( UcetPol ->cNazPol2) < 900                              ;
              .OR. Val( UcetPol ->cNazPol2) = 960                        ;
                                                         .OR. Val( UcetPol ->cNazPol2) = 961                       ;
                                                          .OR. Val( UcetPol ->cNazPol2) = 962                      ;
                                                           .OR. Val( UcetPol ->cNazPol2) = 970                     // £prava JT 28.08.2007

  lVYKONno := UCETPOLA ->cNazPol2 = "860" .OR. UCETPOLA ->cNazPol2 = "890"    ;
                                                 .OR. UCETPOLA ->cNazPol2 = "891" .OR. UCETPOLA ->cNazPol2 = "892"  ;
                                                        .OR. UCETPOLA ->cNazPol2 = "893" .OR. UCETPOLA ->cNazPol2 = "894" ;
                                                         .OR. UCETPOLA ->cNazPol2 = "895" .OR. UCETPOLA ->cNazPol2 = "896" ;
                                                                .OR. UCETPOLA ->cNazPol2 = "897" .OR. UCETPOLA ->cNazPol2 = "898" ;
                                                                 .OR. UCETPOLA ->cNazPol2 = "899" .OR. UCETPOLA ->cNazPol2 = "955"


  lOk := ( UcetPol ->cDenik <> "YQ" .AND. UcetPol ->cDenik <> "YS"          ;
           .AND. UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo  ;
                                           .AND. UcetPol ->cTYPuct = "76"                                ;
                                                  .AND. SubStr( UcetPol ->cUcetMD,1,3) = "599"                 ;
                                                         .AND. lVYKON .AND. !lVYKONno)   //  .OR. lOPRAVY

Return(lOk)


Function UcPVNak2()
  Local lOk, lOPRAVY
  Local nX

  lOPRAVY := SubStr( UcetPol ->cUcetMD,1,3)="699" .AND. SubStr( UcetPol ->cUcetMD,6,1)="8"
  nX      := Val( UcetPol ->cUcetMd)

  lOk := ( UcetPol ->nRok == nRok .AND. UcetPol ->nObdobi <= nObdDo .AND. !Empty( UcetPol ->cNazPol5) .AND. ( SubStr( UcetPol ->cUcetMD,1,3) = "699" .AND. !lOPRAVY))

Return(lOk)



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


Function UctPol3()
  Local lOk, lOPRAVY
  Local nX

  lOk := ( UcetPola ->nRok == nRok .AND. UcetPola ->nObdobi <= nObdDo           ;
           .AND. UcetPola ->cDenik == "AV" .AND. UcetPola ->cUcetMD = "59995"   ;
                                          .AND. UcetPola ->nOrdUcto==1)

Return(lOk)


Function UctPol4()
  Local lOk, lOPRAVY
  Local nX
  Local lVYKON

  lVYKON  := UCETPOLA ->cNazPol2 = "860" .OR. UCETPOLA ->cNazPol2 = "890"    ;
                                                 .OR. UCETPOLA ->cNazPol2 = "891" .OR. UCETPOLA ->cNazPol2 = "892"  ;
                                                        .OR. UCETPOLA ->cNazPol2 = "893" .OR. UCETPOLA ->cNazPol2 = "894" ;
                                                         .OR. UCETPOLA ->cNazPol2 = "895" .OR. UCETPOLA ->cNazPol2 = "896" ;
                                                                .OR. UCETPOLA ->cNazPol2 = "897" .OR. UCETPOLA ->cNazPol2 = "898" ;
                                                                 .OR. UCETPOLA ->cNazPol2 = "899" .OR. UCETPOLA ->cNazPol2 = "955"


  lOk := ( UcetPola ->nRok == nRok .AND. UcetPola ->nObdobi <= nObdDo           ;
           .AND. UcetPola ->cDenik == "AS" .AND. UcetPola ->cUcetMD = "59996"   ;
                                          .AND. UcetPola ->nOrdUcto==1 .AND. lVYKON)

Return(lOk)


Static Function NewDokl_AS()
  LOCAL  nDokl
  LOCAL  cSCOPE, cTAGold, nRECold
  LOCAL  xKEY := StrZero( nRok, 4) +StrZero( nObdDo, 2) +Upper("YS")

  nRECold := UcetPola ->( Recno())
  cTAGold := UcetPola ->( OrdSetFOCUS())
  cSCOPE  := UcetPola ->( dbScope())
*  cSCOPE  := UcetPola ->( Sx_SetScope())

  UcetPola ->( OrdSetFOCUS( AdsCtag( 9 )))
  UcetPola->( dbSetScope( SCOPE_BOTH, xkey))
*  UcetPola ->( SET_sSCOPE( 9, xKEY))

  UcetPola ->( dbGoBotTom())
  nDokl := IF( UcetPola ->nDoklad = 0                                       ;
                 , Val( StrZero( nRok, 4) +StrZero( nObdDo, 2) +"0001")      ;
                                            , UcetPola ->nDoklad +1)

  IF !Empty( cSCOPE)
    UcetPola ->( OrdSetFOCUS( cTAGold))
    UcetPola->( dbSetScope( SCOPE_BOTH, cSCOPE))
*    UcetPola ->( SET_sSCOPE( cTAGold, cSCOPE))
  else
    UcetPola->( dbClearScope())
*    UcetPola ->( Clr_Scope())
  endif

  UcetPola ->( OrdSetFOCUS( cTAGold))
  UcetPola ->( dbGoTo( nRECold))

Return( nDokl)


Function VyberMDAV()
  Local  lOk, lOPRAVY
  Local  nX, cTmp
  Local  cFILE, cFI
  Local  cMDavI  := homAdr + 'M_DavI'
  Local  cTMPdav := homAdr + 'TmpDav'
  Local  nHodCelkem, nKeyCNT

  dbSelectArea( "M_Dav")
  cTmp := homAdr +'TmpDav3'
  INDEX ON M_Dav ->cNazPol1 +M_Dav ->cNazPol2 TO ( cMDavI) FOR FiltMdav()
  nKeyCNT := M_Dav ->( SX_KeyCOUNT())
  IF nKeyCNT == 0
    INDEX ON M_Dav ->cNazPol1 +M_Dav ->cNazPol2 TO ( cMDavI) FOR FiltMdav2()
  ENDIF

  TmpDav3 ->( dbCloseArea())
  M_Dav ->( dbTotal( ( cTmp )    ,  ;
                 { || M_Dav ->cNazPol1 +M_Dav ->cNazPol2},  ;
                 {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))

  cFI := "TmpDav3"
  dbUseArea( .t., "FOXCDX", (cTmp),, if( .T. .or. .F., .F., NIL ), .f. )

  TmpDav3 ->( dbGoTop())
  nHodCelkem := 0

  DO WHILE !TmpDav3 ->( Eof())
    nHodCelkem += TmpDav3 ->nHodDoklad
    TmpDav3 ->( dbSkip())
  ENDDO

  TmpDav3 ->( dbGoTop())
  DO WHILE !TmpDav3 ->( Eof())
    TmpDav3 ->nTMPnum4 := ( TmpDav3 ->nHodDoklad/nHodCelkem) * 1000000
    TmpDav3 ->( dbSkip())
  ENDDO

  cFile := homAdr +"Mdav"+AllTrim( TmpDav3 ->cNazPol2) +".TXT"
  COPY TO &cFile FIELDS cNazPol1,cNazPol2,nHodDoklad,nMnPDoklad,nTMPnum4 SDF

  TmpDav3 ->( dbGoTop())

Return(lOk)


Function VyberZAKL( cTYP)
  Local  lOk, lOPRAVY
  Local  nX, cTmp
  Local  cFILE, cFI
  Local  cUctPol_Z := homAdr + 'UctPol_Z'
  Local  nZaklCelkem, nKeyCNT

  dbSelectArea( "UcetPol")
  cTmp := homAdr +'ZaklUct'
  DO CASE
  CASE cTYP == "RV"
    INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 TO ( cUctPol_Z) FOR Zak_RezRV()
  CASE cTYP == "ZV"
    INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 TO ( cUctPol_Z) FOR Zak_RezZV()
  CASE cTYP == "CD"
    INDEX ON UcetPol ->cNazPol1 +UcetPol ->cNazPol2 TO ( cUctPol_Z) FOR Zak_RezCD()
  ENDCASE

  IF( Select( "ZaklUct") <> 0, ZaklUct ->( dbCloseArea()), NIL)
  UcetPol ->( dbTotal( ( cTmp ), { || UcetPol ->cNazPol1 +UcetPol ->cNazPol2}, { 'nKcMD' } ,,))

  dbUseArea( .t., "FOXCDX", ( cTmp),, if( .T. .or. .F., .F., NIL ), .f. )

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

  cFile := homAdr +"ZaklUct.TXT"

  COPY TO &cFile FIELDS cNazPol1,cNazPol2,nKcMD,nMnozNat2 SDF

  ZaklUct ->( dbGoTop())

Return( lOk)



Function Zak_RezRV()
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
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := ( ( Val( UcetPol ->cNazPol2) >= 100 .AND. Val( UcetPol ->cNazPol2) <= 290)         ;
                                            .OR. ( Val( UcetPol ->cNazPol2) >= 400 .AND. Val( UcetPol ->cNazPol2) <= 590)) ;
                                                   .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo

RETURN( lOK)


Function Zak_RezZV()
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
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := Val( UcetPol ->cNazPol2) >= 700 .AND. Val( UcetPol ->cNazPol2) <= 799    ;
                                                .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo


RETURN( lOK)


Function Zak_RezCD()
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
                                                                       .AND. VAL( UcetPol ->cUcetMD) <= 613329))   ;
                                                        .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "542"            ;
                                                         .AND. SubStr( UcetPol ->cUcetMD, 1, 3) <> "546"

  lOK := ( ( Val( UcetPol ->cNazPol2) >= 100 .AND. Val( UcetPol ->cNazPol2) <= 290)        ;
                                        .OR. ( Val( UcetPol ->cNazPol2) >= 400 .AND. Val( UcetPol ->cNazPol2) <= 590) ;
                                         .OR. ( Val( UcetPol ->cNazPol2) >= 700 .AND. Val( UcetPol ->cNazPol2) <= 799) )   ;
                                                .AND. lUCTY .AND. UcetPol ->nRok = nRok .AND. UcetPola ->nObdobi <= nObdDo

RETURN( lOK)




Function FiltMDAV( cNaPo2)
  Local lOk, lSTROJ
  Local nX

  lSTROJ := IF( ( C_VnSaSt ->( dbSeek(M_Dav ->cNazPol5)))                  ;
                         , AllTrim( C_VnSaSt ->cNazPol2) == AllTrim(cNAKpo2), .F.)

  lOk := ( M_Dav ->nRok == nRok .AND. M_Dav ->nObdobi <= nObdDo              ;
           .AND. Val(M_Dav ->cNazPol2) < 800 .AND. !Empty( M_Dav ->cNazPol5);
                                          .AND. lSTROJ)

Return(lOk)


Function FiltMDAV2( cNaPo2)
  Local lOk, lSTROJ
  Local nX

  lOk := ( M_Dav ->nRok == nRok .AND. M_Dav ->nObdobi <= nObdDo              ;
           .AND. Val(M_Dav ->cNazPol2) < 800 .AND. !Empty( M_Dav ->cNazPol5))

Return(lOk)




//  kalkulace výrobkù

METHOD UCT_skunakst_CRD:kalkulace(drgdialog)
*  LOCAL cNazPol2   := netAdr + 'cnazpol2'
*  LOCAL cUcetKUM   := netAdr + 'UcetKum'
*  LOCAL cFileKALK  := homAdr + 'kalkzem'
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

  drgServiceThread:progressStart( drgNLS:msg('Vytvoøení podkladù pro kalkulaci výrobkù ...'),11)
  drgServiceThread:progressInc()

  nRok   := uctOBDOBI:UCT:nrok
  nObdDO := uctOBDOBI:UCT:nobdobi


  drgDBMS:open('cnazpol2')
  drgDBMS:open('ucetkum')

*  dbCreate( cFileKALK, aOutDefKal)
*  dbUseArea( .t., "FOXCDX", ( cFileKALK),, if( .T. .or. .F., .F., NIL ), .f. )
*  drgDBMS:open('kalkzem'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  kalkzem->( dbZap())
  dbCreate( cFileKAtm, aOutDefTmp)
  dbUseArea( .t., "FOXCDX", ( cFileKAtm),, if( .T. .or. .F., .F., NIL ), .f. )

*  dbUseArea( .t., "FOXCDX", ( cUcetKUM),, if( .T. .or. .F., lNetWare, NIL ), .f. )

  dbSelectArea( "UcetKum")
  COPY TO ( cTmUctKum) FOR UcetKum ->nRok == nRok .AND. UcetKum ->nObdobi == nObdDO
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cTmUctKum),, if( .T. .or. .F., .F., NIL ), .f. )
  dbSelectArea( "TmUctKum")
  INDEX ON TmUctKum ->cNazPol2 +TmUctKum ->cUcetMD TO ( cTmUctKum)
  TmUctKum->(OrdSetFocus( AdsCtag( 1 )))
  drgServiceThread:progressInc()

*  dbUseArea( .t., "FOXCDX", ( cNazPol2),, if( .T. .or. .F., .F., NIL ), .f. )
*  cNazPol2 ->( OrdSetFOCUS( AdsCtag( 1 )))
  TmUctKum ->( dbGoTop())
  DO WHILE !TmUctKum ->( Eof())
    IF TmUctKum ->cNazPol2 <> kalkzem ->cNazPol2 .OR. kalkzem ->( LastRec()) = 0
      cNazPol2 ->( dbSeek( TmUctKum ->cNazPol2,,1))
      kalkzem ->( dbAppend())
      kalkzem ->cNazPol2 := TmUctKum ->cNazPol2
      kalkzem ->cNazev   := CNazPol2 ->cNazev
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
      kalkzem ->nVyrobaMn  += ( TmUctKum ->nKcDALKSR)
    ENDIF
    TmUctKum ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

  dbUseArea( .t., "FOXCDX", ( cMdav),, if( .T. .or. .F., lNetWare, NIL ), .f. )

  dbSelectArea( "M_Dav")
  cTmpDav := homAdr +'TmpDav5'
  INDEX ON M_Dav ->cNazPol2 TO ( cMDavI) FOR FiltrKal()

  M_Dav ->( dbTotal( ( cTmpDav),{ || M_Dav ->cNazPol2},  ;
                         {'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' } ,, ))
  drgServiceThread:progressInc()
  dbUseArea( .t., "FOXCDX", ( cTmpDav),, if( .T. .or. .F., .F., NIL ), .f. )
  INDEX ON TmpDav5 ->cNazPol2 TO (cTmpDav)
  drgServiceThread:progressInc()

  nSumaHOD := 0
  TmpDav5 ->( dbGoTop())
  DO WHILE !TmpDav5 ->( Eof())
    nVYK := Val( TmpDav5 ->cNazPol2)
    IF nVYK < 800 .OR. nVYK == 870
      nSumaHOD += TmpDav5 ->nHodDoklad
    ENDIF
    TmpDav5 ->( dbSkip())
  ENDDO
  drgServiceThread:progressInc()

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
  drgServiceThread:progressInc()

// ------- poslední prùchod -----------------
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
  drgServiceThread:progressInc()

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
  drgServiceThread:progressInc()

  kalkzem ->( dbPack())

*        dbSelectArea( "kalkzem")
*        Browse()
*        kalkzem ->( dbCloseArea())

  dbSelectArea( "KalkKtm")
*  APPEND FROM ( cFileKALK)

  kalkzem->( dbGoTop())
  do while .not. kalkzem->( Eof())
    mh_copyFLD('kalkzem','kalkktm', .t. )
    kalkzem->( dbSkip())
  enddo
  drgServiceThread:progressInc()

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
  ::dm:refresh()


RETURN( NIL)


Function FiltrKal()
 Local lOk
 lOk := ( M_Dav ->nRok == nRok .AND. M_Dav ->nObdobi <= nObdDo             ;
           .AND. !Empty( M_Dav ->cNazPol2) .AND. !Empty( M_Dav ->cNazPol5) ;
                                          .AND. ( Val( M_Dav ->cNazPol2) < 800 .OR. Val( M_Dav ->cNazPol2) = 870))
Return(lOk)

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


Function TestXXX6()
  Local lOk, lOPRAVY
  Local nX

  lOk := ( UcetPola ->nRok == nRok .AND. UcetPola ->nObdobi <= nObdDo           ;
           .AND. UcetPola ->cDenik == "YS" .AND. UcetPola ->cUcetMD = "59996"   ;
                                          .AND. UcetPola ->nOrdUcto==1)

Return(lOk)