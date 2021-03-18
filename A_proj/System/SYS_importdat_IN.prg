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


**  Import dat do systému
** CLASS for SYS_importdat_IN *********************************************
CLASS SYS_importdat_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postAppend
  METHOD  postValidate
  METHOD  onSave
  METHOD  runImport
  METHOD  dir

  METHOD  destroy

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


METHOD SYS_importdat_IN:init(parent)

  drgDBMS:open('impdathd')

  ::drgUsrClass:init(parent)

RETURN self



METHOD SYS_importdat_IN:drgDialogStart(drgDialog)
  LOCAL aUsers
  LOCAL n
  LOCAL oSle

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager


/*

  oSle := ::dataManager:get('USERS->NCISOSOBY', .F.)// :oDrg:oXpb:xbpSle
  osle:odrg:isEdit := .f.

  IF ::newRec
    ::dataManager:set("users->copravneni", "USR_ZAKLAD")
    ::dataManager:set("users->dPlatn_Od", Date())
    ::dataManager:set("users->cpassword", '')
  ELSE
    ::dataManager:set("m->paswordcheck", USERS->CPASSWORD)
    ::paswordCheck := USERS->CPASSWORD
  ENDIF
*/
RETURN self

                                  *
*****************************************************************
METHOD SYS_importdat_IN:postValidate(drgVar)
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


method SYS_importdat_IN:postAppend(parent)
  impdathd ->cidimpdath := "DIST000001"
return



METHOD SYS_importdat_IN:onSave()
  LOCAL aUsers
  LOCAL n

*  IF( ::newRec, IMPORTD->(dbAppend()), IMPORTD->(dbRlock()))
*  ::dm:save()
*  IMPORTD->(dbUnlock())

RETURN .T.


METHOD SYS_importdat_IN:runImport()
  local vstpath := 'c:\Asystem_instalace\Royal\aaa\'
  local vstfile
  local n1

  if drgIsYESNO(drgNLS:msg('Spustit import dat ?'))

    vstfile := 'FMA_07'
    dbUseArea(.T.,,vstpath+vstfile,'infile')
    ( drgDBMS:open('Firmy',.T.), Firmy->(dbZap()))
    ( drgDBMS:open('FirmyDa',.T.), FirmyDa->(dbZap()))
    ( drgDBMS:open('FirmyFi',.T.), FirmyFi->(dbZap()))
    ( drgDBMS:open('FirmyUc',.T.), FirmyUc->(dbZap()))
    n1 := 0
    do while .not. infile->(Eof())
      n1++
      Firmy->(dbAppend())

      Firmy->nCisFirmy  := n1
      Firmy->cNazev     := infile->OBCH_JMENO
      Firmy->cNazev2    := infile->DODATEK
      Firmy->nICO       := if(Val(AllTrim(StrTran(infile->KLIC_ADR,'-','')))< 99999999,Val(AllTrim(StrTran(infile->KLIC_ADR,'-',''))), 0)
      Firmy->cDIC       := infile->DIC
*      Firmy->cDIC_old   :=
      Firmy->cVAT_ID    := infile->DIC
      Firmy->cUlice     := infile->ULICE
*      Firmy->cCisPopis  :=
      Firmy->cUlicCiPop := infile->ULICE
      Firmy->cPoBOX     := infile->KLIC_ADR
      Firmy->cSidlo     := infile->MESTO
      Firmy->cPSC       := infile->PSC
      Firmy->cZkratStat := 'CZK'
*      Firmy->cCinnost   :=
      Firmy->cZastupce  := infile->OSOBA
*      Firmy->cZarazeni  :=
      Firmy->cTelefon   := infile->TELEFON
      Firmy->cFax       := infile->FAX
*      Firmy->nCisODE    :=
*      Firmy->cZastOBCH  :=
*      Firmy->cTelefon2  :=
*      Firmy->cModemBBS  :=
      Firmy->cMobilTEL  := infile->MOBIL
*      Firmy->cEmailTEL  :=
*      Firmy->cObVzth    :=
*      Firmy->cUzVzth    :=
      Firmy->nKlicObl   := if(infile->REGION='KM',2,1)
*      Firmy->nMnozNeOdb :=
*      Firmy->nMnozNeDod :=
      Firmy->cZkrProdej := infile->DEALER
*      Firmy->nCisREG    :=
      Firmy->dREGdph_OD := infile->DAT_REG
*      Firmy->dREGdph_DO :=
*      Firmy->cKRAJ      :=
*      Firmy->cOKRES     :=


      FirmyDa->(dbAppend())

      FirmyDa->nCisFirmy  := n1
      FirmyDa->nCisFirDoa := n1
      FirmyDa->cNazevDoa  := infile->PRIJEMCE
      FirmyDa->cNazevDoa2 := infile->UMISTENI
*      FirmyDa->cCinnost   :=
*      FirmyDa->cPSCDoa    :=
      FirmyDa->cSidloDoa  := infile->MESTO_PRIJ
      FirmyDa->cUliceDoa  := infile->ULICE_PRIJ
*      FirmyDa->cTelDoa    :=
*      FirmyDa->cFaxDoa    :=
*      FirmyDa->cModDoa    :=
*      FirmyDa->cZastDoa   :=


      FirmyFi->(dbAppend())

      FirmyFi->nCisFirmy  := n1
      FirmyFi->cUct_Dod   := '321100'
      FirmyFi->cUct_FPZ   := '314100'
*      FirmyFi->nSplatnDod :=
*      FirmyFi->cSpecSymbo :=
*      FirmyFi->nKonstSymD :=
*      FirmyFi->nPen_Dod   :=
*      FirmyFi->cZkrTypUhr :=
*      FirmyFi->nSknDnyDod :=
*      FirmyFi->nSknPrcDod :=
*      FirmyFi->nUverDny   :=
*      FirmyFi->nLimZav    :=
*      FirmyFi->nSumZav    :=
*      FirmyFi->nSumZavCel :=
*      FirmyFi->dDatPosZav :=
*      FirmyFi->cZkrZpuDop :=
      FirmyFi->cUct_Odb   := '311100'
      FirmyFi->cUct_FVZ   := '324100'
      FirmyFi->nSplatnost := infile->SPLATNOST
*      FirmyFi->nPen_Odb   :=
*      FirmyFi->cSpecSymOd :=
*      FirmyFi->nKonstSymb :=
*      FirmyFi->cZkrTypUOd :=
*      FirmyFi->nSknDnyOdb :=
*      FirmyFi->nSknPrcOdb :=
*      FirmyFi->nUverDnyOd :=
*      FirmyFi->nLimPoh    :=
*      FirmyFi->nSumPoh    :=
*      FirmyFi->nSumPohCel :=
*      FirmyFi->dDatPosPoh :=
*      FirmyFi->cZkrZpuDOD :=


      FirmyUc->(dbAppend())

      FirmyUc->nCisFirmy := n1
      FirmyUc->cNazev    := Firmy->cNazev
      FirmyUc->nICO      := Firmy->nICO
      FirmyUc->cDIC      := Firmy->cDIC
      FirmyUc->cUcet     := infile->UCET
*      FirmyUc->cBank_Naz :=
*      FirmyUc->cBank_Pob :=
*      FirmyUc->cBank_PSC :=
*      FirmyUc->cBank_Sid :=
*      FirmyUc->cBank_Uli :=
*      FirmyUc->cBank_Tel :=
*      FirmyUc->cBank_Fax :=
*      FirmyUc->cBank_Mod :=
*      FirmyUc->cBankOdpO :=
*      FirmyUc->cSpecSYMB :=
*      FirmyUc->cUcet_UCT :=
*      FirmyUc->cIBAN     :=
*      FirmyUc->cBIC      :=

      infile->(dbSkip())
    enddo
    infile->(dbCloseArea())

    vstfile := 'FMH_0706'

    dbUseArea(.T.,,vstpath+vstfile,'infile')
    ( drgDBMS:open('FakVysHD',.T.), FakVysHD->(dbZap()))
    n1 := 0
    do while  .not. infile->(Eof())
      FakVysHD->(dbAppend())

      FakVysHD->cUloha     := "F"
      FakVysHD->CTASK      := "FIN"
      FakVysHD->CSUBTASK   := ''
      FakVysHD->CTYPDOKLAD := 'FIN_FAKVB'
      FakVysHD->CTYPPOHYBU := 'FAKVBEZ'
      FakVysHD->cObdobi    := '06/07'
      FakVysHD->nROK       := 2007
      FakVysHD->nOBDOBI    := infile->UCT_OBD
      FakVysHD->nDoklad    := infile->CIS_FAK
      FakVysHD->nCisFak    := infile->CIS_FAK
      FakVysHD->nCISLODL   := 0
      FakVysHD->nCISLOEL   := 0
      FakVysHD->nCISLOPVP  := 0
      FakVysHD->cVarSym    := Str(infile->CIS_FAK)
      FakVysHD->cObdobiDan := '06/07'
      FakVysHD->CSTADOKLAD := ''
      FakVysHD->cZkrTypFak := 'FAKVB'
      FakVysHD->cZkrTypUhr := if(infile->FORMA_UHR == 'h','Hotov','PøevP')
      FakVysHD->nOsvOdDan  := infile->TRZBA_BD0
      FakVysHD->nPROCdan_1 := 5
      FakVysHD->nZaklDan_1 := infile->TRZBA_BD5
      FakVysHD->nSazDan_1  := infile->DPH5
      FakVysHD->nZAKLdar_1 := 0
      FakVysHD->nSAZdar_1  := 0
      FakVysHD->nZAKLdaz_1 := 0
      FakVysHD->nSAZdaz_1  := 0
      FakVysHD->nPROCdan_2 := 19
      FakVysHD->nZaklDan_2 := infile->TRZBA_BD23
      FakVysHD->nSazDan_2  := infile->DPH23
      FakVysHD->nZAKLdar_2 := 0
      FakVysHD->nSAZdar_2  := 0
      FakVysHD->nZAKLdaz_2 := 0
      FakVysHD->nSAZdaz_2  := 0
      FakVysHD->nCenZakCel := FakVysHD->nOsvOdDan+FakVysHD->nZaklDan_1+FakVysHD->nZaklDan_2
      FakVysHD->nCENfakCEL := infile->TRZBA
      FakVysHD->nCENfazCEL := infile->TRZBA
      FakVysHD->nCenDanCel := FakVysHD->nSazDan_1+FakVysHD->nSazDan_2
      FakVysHD->nZustPoZao := 0
      FakVysHD->nKodZaokr  := 21
      FakVysHD->nKodZaokrD := 21
      FakVysHD->cZkratMeny := 'CZK'
      FakVysHD->nCenZahCel := FakVysHD->nCENfakCEL
      FakVysHD->cZkratMenZ := 'CZK'
      FakVysHD->nKurZahMen := 1
      FakVysHD->nMnozPrep  := 1
      FakVysHD->nKonstSymb := 8
      FakVysHD->cSpecSymb  := ''
      FakVysHD->nCisFirmy  := 0
      FakVysHD->cNazev     := infile->OBCH_JMENO
      FakVysHD->cNazev2    := infile->DODATEK
      FakVysHD->nIco       := if(Val(AllTrim(StrTran(infile->KLIC_ADR,'-','')))< 99999999,Val(AllTrim(StrTran(infile->KLIC_ADR,'-',''))), 0)
      FakVysHD->cDic       := infile->DIC
      FakVysHD->cUlice     := infile->ULICE
      FakVysHD->cSidlo     := infile->MESTO
      FakVysHD->cPsc       := infile->PSC
      FakVysHD->cUcet      := ''
      FakVysHD->nCisFirDOA := 0
      FakVysHD->cNazevDOA  := infile->PRIJEMCE
      FakVysHD->cNazevDOA2 := ''
      FakVysHD->cUliceDOA  := infile->ULICE_PRIJ
      FakVysHD->cSidloDOA  := infile->MESTO_PRIJ
      FakVysHD->cPscDOA    := ''
      FakVysHD->cPrijemce1 := ''
      FakVysHD->cPrijemce2 := ''
      FakVysHD->cZkrZpuDop := ''
*      FakVysHD->dSplatFak
*      FakVysHD->dVystFak
*      FakVysHD->dPovinFak
*      FakVysHD->dDatTisk
*      FakVysHD->cPrizLikv  := ''
*      FakVysHD->nLikCelFak
*      FakVysHD->dPosLikFak
      FakVysHD->nUhrCelFak := infile->SUMA_ZAPL
*      FakVysHD->nUhrCelFaZ
*      FakVysHD->nKurzROZDf
*      FakVysHD->dPosUhrFak
*      FakVysHD->nPARzalFAK
*      FakVysHD->nPARzahFAK
*      FakVysHD->dPARzalFAK
      FakVysHD->cBank_Uct  := ''
      FakVysHD->cVnBan_Uct := ''
*      FakVysHD->nCisPenFak
*      FakVysHD->dDatPenFAK
*      FakVysHD->nPen_Odb
*      FakVysHD->nVYPpenODB
*      FakVysHD->nCisUpomin
*      FakVysHD->dUpominky
*      FakVysHD->nCisDobFak
*      FakVysHD->lHlasFak
      FakVysHD->cCisObj     := ''
      FakVysHD->cCislObInt  := ''
*      FakVysHD->nCisFak_Or
      FakVysHD->cTypFak_Or  := ''
*      FakVysHD->nCisUzv
*      FakVysHD->dDatUzv
*      FakVysHD->nTypSlevy
*      FakVysHD->nProcSlev
*      FakVysHD->nProcSlFaO
*      FakVysHD->nProcSlHot
*      FakVysHD->nHodnSlev
*      FakVysHD->nCenaZakl
*      FakVysHD->nKasa
*      FakVysHD->cZkrProdej
*      FakVysHD->cDenik
*      FakVysHD->cUcet_Uct
*      FakVysHD->cDENIK_puc
*      FakVysHD->cUCET_pucR
*      FakVysHD->cUCET_pucS
*      FakVysHD->cUCET_daz
*      FakVysHD->cZkratStat
*      FakVysHD->nFinTyp
*      FakVysHD->nKlicOBL
*      FakVysHD->nDOKLAD_DL
*      FakVysHD->nDOKLAD_PV
*      FakVysHD->cJMENOvys
*      FakVysHD->cOBDOBIo
*      FakVysHD->nHmotnost
*      FakVysHD->cZkratJedH
*      FakVysHD->nObjem
*      FakVysHD->cZkratJedO
*      FakVysHD->nKLikvid
*      FakVysHD->nZLikvid
*      FakVysHD->mPopisFAK
*      FakVysHD->lNo_InDPH
*      FakVysHD->mDOLFAKcis
*      FakVysHD->lIsZAHR
*      FakVysHD->nFAKDOLcis
*      FakVysHD->cCISZAKAZ
*      FakVysHD->cTYPzak
*      FakVysHD->cSTRED_odb
*      FakVysHD->cSTROJ_odb
*      FakVysHD->nPorCisLis
*      FakVysHD->nOsCisPrac
*      FakVysHD->cSPZ
*      FakVysHD->vlekSPZ
*      FakVysHD->cjmenoRid
*      FakVysHD->cCisloOP
*      FakVysHD->cVYPsazDAN
*      FakVysHD->cIsZAL_FAK

      infile->(dbSkip())

    enddo
    infile->(dbCloseArea())


    vstfile := 'FMV_0706'
    dbUseArea(.T.,,vstpath+vstfile,'infile')
    ( drgDBMS:open('FakVysIT',.T.), FakVysIT->(dbZap()))
    n1 := 0

    do while  .not. infile->(Eof())
      FakVysIT->(dbAppend())

      FakVysIT->cUloha     := 'F'
*      FakVysIT->nCisFirmy  :=
*      FakVysIT->nCisFirDoA :=
      FakVysIT->cObdobi    := '06/07'
      FakVysIT->nROK       := 2007
      FakVysIT->nOBDOBI    := 6
      FakVysIT->nDOKLAD    := infile->CIS_FAK
      FakVysIT->nCisFak    := infile->CIS_FAK
      FakVysIT->nCisloDL   := 0
      FakVysIT->nCISLOEL   := 0
      FakVysIT->nCISLOPVP  := 0
      FakVysIT->cZkrTypFak := ''
      FakVysIT->nIntCount  := n1++
      FakVysIT->cCisSklad  := infile->SKL
      FakVysIT->cSklPol    := infile->POLOZKA
      FakVysIT->cPolCen    := 'C'
      FakVysIT->cNazZbo    := ''
*      FakVysIT->CUCETSKUP
      FakVysIT->nCenJedZak := infile->CENA_BD
*      FakVysIT->nCenJedZaD
*      FakVysIT->nCenZakCel
*      FakVysIT->nCenZakCeD
*      FakVysIT->nCenZahCel
*      FakVysIT->nJEDDAN
*      FakVysIT->nSazDan
      FakVysIT->nFaktMnoz  := infile->MNOZSTVI
*      FakVysIT->cZkratJedn
*      FakVysIT->nFaktMno2
*      FakVysIT->cZkratJed2
*      FakVysIT->nKlicDph
*      FakVysIT->nProcDPH
*      FakVysIT->nNAPOCET
*      FakVysIT->nNullDPH
*      FakVysIT->nTypPrep
*      FakVysIT->nVYPSAZDAN
*      FakVysIT->nRadVykDph
*      FakVysIT->cDoplnTxt
*      FakVysIT->cCisObj
*      FakVysIT->cCislObInt
*      FakVysIT->nCislPolOb
*      FakVysIT->nMNOZreodb
*      FakVysIT->nCisPenFak
*      FakVysIT->nCelPenFak
*      FakVysIT->nCenPenCel
*      FakVysIT->dSplatFak
*      FakVysIT->dPosUhrFak
*      FakVysIT->nPen_Odb
*      FakVysIT->nCisFak_Or
*      FakVysIT->cZkrTyp_Or
*      FakVysIT->nKlicNS
*      FakVysIT->cNazPol1
*      FakVysIT->cNazPol2
*      FakVysIT->cNazPol3
*      FakVysIT->cNazPol4
*      FakVysIT->cNazPol5
*      FakVysIT->cNazPol6
*      FakVysIT->nTypSlevy
*      FakVysIT->nProcSlev
*      FakVysIT->nProcSlFaO
*      FakVysIT->nProcSlMn
*      FakVysIT->nHodnSlev
*      FakVysIT->nCenaZakl
*      FakVysIT->nCenaZakC
*      FakVysIT->nCelkSlev
*      FakVysIT->nKasa
*      FakVysIT->cZkrProdej
*      FakVysIT->cUcet
*      FakVysIT->cUCET_pucR
*      FakVysIT->cUCET_pucS
*      FakVysIT->nCountDL
*      FakVysIT->nDokladORG
*      FakVysIT->nUcetSkup
*      FakVysIT->nZboziKat
*      FakVysIT->nPodilProd
*      FakVysIT->cDenik
*      FakVysIT->nCisZalFAK
*      FakVysIT->nRECfaz
*      FakVysIT->nRECpar
*      FakVysIT->nRECdol
*      FakVysIT->nRECpen
*      FakVysIT->nRECvyr
*      FakVysIT->nKlicOBL
*      FakVysIT->nCenasZBO
*      FakVysIT->NMNOZSZBO
*      FakVysIT->NCENACZBO
*      FakVysIT->mPozZBO
*      FakVysIT->nFAKTm_ORG
*      FakVysIT->nORDIT_PVP
*      FakVysIT->cCISZAKAZ
*      FakVysIT->cCisZakazI
*      FakVysIT->cSKP
*      FakVysIT->cDanpZBO
*      FakVysIT->nIND_ceo
*      FakVysIT->lIND_mod
*      FakVysIT->nCISLOkusu
*      FakVysIT->mDOLcis
*      FakVysIT->aULOZENI
*      FakVysIT->cTypSKp
*      FakVysIT->nKoefMn
*      FakVysIT->nFaktMnKOE
      FakVysIT->nCeJPrZBZ := infile->CENA_BD
      FakVysIT->nCeJPrKBZ := infile->CENA_BD
*      FakVysIT->nCeJPrKDZ
*      FakVysIT->nCeCPrZBZ
*      FakVysIT->nCeCPrKBZ
*      FakVysIT->nCeCPrKDZ
*      FakVysIT->nHmotnost
*      FakVysIT->cZkratJedH
*      FakVysIT->nObjem
*      FakVysIT->cZkratJedO
*      FakVysIT->lSLUZBA
*      FakVysIT->nKLikvid
*      FakVysIT->nZLikvid
*      FakVysIT->nCisVYSFAK
*      FakVysIT->dVykladky
*      FakVysIT->cCasVyklad

      infile->(dbSkip())

    enddo


  endif


RETURN .t.


METHOD SYS_importdat_IN:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  path := selDIR(,cfile )

RETURN .t.



** END of CLASS ****************************************************************
METHOD SYS_importdat_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL