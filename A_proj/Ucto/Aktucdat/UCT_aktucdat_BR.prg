#include "Appevent.ch"
#include "Common.ch"
#include "xbp.ch"
#include "gra.ch"
#include "CLASS.CH"
//
#include "drg.ch"
#include "drgRes.ch"
//
#include "..\UCTO\AKTUCDAT\UCT_aktucdat_.CH"


//**
CLASS  UCT_aktucdat_BR
EXPORTED:
  VAR CARGO
  VAR TREEs

  VAR UCTDOKHD
  VAR FAKPRIHD
  VAR FAKVYSHD
  VAR BANVYPHD
  VAR POKLADHD
  VAR UCETDOHD
  VAR PVPHEAD
  VAR MZDY_HM
  VAR MZDY_NE
  VAR MZDY_SR
  VAR MZDY_CM
  VAR ZMAJU
  VAR ZVZMENHD
  VAR ZMAJUZ

  **TREE**
  ACCESS ASSIGN METHOD TREEs_a    VAR TREEs

  INLINE METHOD init()
    ::CARGO    := ::CARGO_ini()

    **UCTO**
    ::UCTDOKHD := _UCTDOKHD

    **FINANCE**
    ::FAKPRIHD := _FAKPRIHD
    ::FAKVYSHD := _FAKVYSHD
    ::BANVYPHD := _BANVYPHD
    ::POKLADHD := _POKLADHD
    ::UCETDOHD := _UCETDOHD

    **SKLADY**
    ::PVPHEAD  := _PVPHEAD

    **MZDY**
    ::MZDY_HM  := _MZDY_HM
    ::MZDY_NE  := _MZDY_NE
    ::MZDY_SR  := _MZDY_SR
    ::MZDY_CM  := _MZDY_CM

    **IM**
    ::ZMAJU    := _ZMAJU

    **ZVÍØATA**
    ::ZVZMENHD := _ZVZMENHD
    ::ZMAJUZ   := _ZMAJUZ

    **TREE**
    ::TREEs_a()
  RETURN self

HIDDEN:
  METHOD CARGO_ini

  METHOD TASKS
  METHOD POCSTAV

  **UCTO**
  METHOD UCTDOKHD_TRe

  **FINANCE**
  METHOD FAKPRIHD_TRe
  METHOD FAKVYSHD_TRe
  METHOD BANVYPHD_TRe
  METHOD POKLADHD_TRe
  METHOD UCETDOHD_TRe

  **SKLADY**
  METHOD PVPHEAD_TRe

  **MZDY**
  METHOD MZDY_HM_TRe
  METHOD MZDY_NE_TRe
  METHOD MZDY_SR_TRe
  METHOD MZDY_CM_TRe

  **IM**
  METHOD ZMAJU_TRe

  **ZVÍØATA**
  METHOD ZVZMENHD_TRe
  METHOD ZMAJUZ_TRe
ENDCLASS


METHOD UCT_aktucdat_BR:CARGO_ini()
  LOCAL nROK := UCETSYS ->nROK, nRECNo := UCETSYS ->( RECNO())
  LOCAL cC
//
  LOCAL pA := _CARGO
  LOCAL oClass, oData

  oClass := RecordSet():createClass( "aktucdat_CRG", pA )
  oData  := oClass:new({ ARRAY(LEN(pA)) })

  ucetsys->(dbgotop())

  ** OBDOBÍ PRO POÈÁTEÈNÍ STAVY
  oData:cOBD_PSn := StrZero( UCETSYS ->nROK,4) +StrZERO( UCETSYS ->nOBDOBI,2)

  ** OBDOBÍ OD
  oData:cOBD_OD  := UPPER( UCETSYS ->cOBDOBI)
  oData:cOBD_ODn := StrZero( UCETSYS ->nROK,4) +StrZero(UCETSYS ->nOBDOBI,2)

  ** OBDOBÍ DO
  ucetsys->(dbgoBottom())
  oData:cOBD_DO  := UPPER( UCETSYS ->cOBDOBI)
  oData:cOBD_DOn := StrZERO( UCETSYS ->nROK,4) +StrZero( UCETSYS ->nOBDOBI,2)
  oData:aOBD_AKT := {}

  //---------- POLE OBDOBÍ pro AKTUALIZACI -------------------------------------
  ucetsys->(dbgotop())
  do while .not. ucetsys->(eof())
    cc := substr(ucetsys->(sx_keyData()),2,6)
    if ucetsys->naktuc_ks <> 2
      if cc >= oData:cobd_odn .and. cc <= oData:cobd_don
        aadd(oData:aobd_akt,cc)
      endif
    endif
    ucetsys->(dbskip())
  enddo
  ucetsys->(dbgoto(nrecNo))


  oData:cUSERABB := SysCONFIG( 'SYSTEM:cUSERABB')
  oData:cPathEXP := AllTrim( SysConfig( 'SYSTEM:cPathEXP'))
  oData:cDiskEXP := Upper( Left( oData:cPathEXP, 1))
  oData:cDirEXP  := drgINI:dir_USERfitm +'EXP\'
  oData:lIsERRs  := .F.
  oData:lIsZAL   := .F.
**  oData:nLEVLs   := nLEVLs
  oData:lAUTO_NV := AUTOM_HD ->( mh_SEEK( '11', 2, .T.,, .F. ))
  oData:lAUTO_VR := AUTOM_HD ->( mh_SEEK( '21', 2, .T.,, .F. ))
  oData:lAUTO_SR := AUTOM_HD ->( mh_SEEK( '31', 2, .T.,, .F. ))
  oData:lAUTO_ZR := AUTOM_HD ->( mh_SEEK( '41', 2, .T.,, .F. ))
  oData:lIsAUTO  := oData:lAUTO_NV .or. oData:lAUTO_VR .or. oData:lAUTO_SR .or. oData:lAUTO_ZR
  oData:lDELAUTO := .F.
  oData:lIsEXCL  := !SYSCONFIG( 'SYSTEM:lNETWARE' )

  //----------- ZPÚSOB výpoètu AUTOMATÚ (OBRo/KSr) -----------------------------
  If SysConfig( 'UCTO:lAUTO_obr' )
    oData:aAUTO_VY := { '( UCETKUM ->nKCmdOBRO  -UCETKUM ->nKCdalOBRo )', ;
                        '( UCETKUM ->nKCdalOBRO -UCETKUM ->nKCmdOBRo  )'  }
  Else
    oData:aAUTO_VY := { '( UCETKUM ->nKCmdKSr  -UCETKUM ->nKCdalKSr )', ;
                        '( UCETKUM ->nKCdalKSr -UCETKUM ->nKCmdKSr  )'  }
  EndIf

  drgDBMS:open('confighd')
  confighd->(dbClearScope(), dbGoTop())
  oData:aDENIKY := { { 'X ', 'úèt_Autom_PS  '}, ;
                     { 'AN', 'úèt_Autom_NV  '}, ;
                     { 'AV', 'úèt_Autom_VR  '}, ;
                     { 'AS', 'úèt_Autom_SR  '}, ;
                     { 'AZ', 'úèt_Autom_ZR  '}, ;
                     { 'MC', 'mzd_Èisté_MZ  '}  }

  do while .not. confighd->(eof())
    if left(lower(confighd->citem),6) = 'cdenik'
      AAdd( oData:aDENIKY, { left(confighd->cvalue,2), confighd->citem })
    endif

    confighd->(dbskip())
  enddo
RETURN oData


method UCT_aktucdat_br:trees_a()
  if isNil(::trees)
    ::trees := ;
{ { 'Naètení dat pro centrál ÚÈTO'                            , '1' , .f., .f., '', ;
    { { 'Naètení vstupních dat'                               , '1' , .f., .f., 'neco', 'neco' }, ;
      { 'Kontrola vstupních dat'                              , '1' , .f., .f., 'neco', 'neco' }, ;
      { 'Aktualizace základního souboru'                      , '1' , .f., .f., 'neco', 'neco' }  }}, ;
  { 'Kontrola základních souborù ÚÈTO'                        , '2' , .f., .f., '', ;
      ::TASKS('2')                                                                          }, ;
  { 'Aktualizace úèetních knih a modifikace salda'            , '3' , .f., .f., '', ;
    { { 'Kontrola základních souborù ÚÈTO'                    ,'31' , .t., .t., '', ;
         ::TASKS('31')                                                                      }, ;
      { 'Výpoèet zùstatkù/obratù na úètech a modifikace SALDA','32' , .t., .f., '', ;
         ::POCSTAV()                                                                        }, ;
      { 'Zpracování aktualizace saldokontních položek'        ,'321', .f., .f., 'saldo', ''    }  }  } }
  endif
return ::trees


method UCT_aktucdat_br:tasks(citem)
  local  nIn
  local  cNAMe, cTRe, cFILe
  local  pA := {}, pC := ::classDescribe(CLASS_DESCR_MEMBERS), pB

  pB := ASort( pC,,, {|aX,aY| aX[1] < aY[1] } )

  for nIn := 1 TO len(pB) step 1
    cFILe := pB[nIn,CLASS_MEMBER_NAME]
    cNAMe := cFILe +'_TRe'
    if isMethod(self, cNAMe, CLASS_HIDDEN)
      cTRe := self:&cNAMe()
      if isCharacter(cTRe)
        AAdd(pA,{ cTRe, citem +'1', .f., (citem='3'), 'verify', cFILe })
      endif
    endif
  next
return pA


method UCT_aktucdat_br:pocstav()
  local pA := {}

  AAdd(pA,{ 'Zpracování aktualizace zùstatkù a obratù','321', .f., .f., 'obraty', '' })

  autom_hd->(dbGoTop())

  if .not. autom_hd->(eof())
    AAdd(pA, ;
    { 'Zpracování automatických výpoètù        '            ,'33' , .f., .t., 'automaty', ;
      { { 'Automatický výpoèet _   VÝROBNÍ   _ režie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatický výpoèet _   SPRÁVNÍ   _ režie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatický výpoèet _   ZÁSOBOVÉ  _ režie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatický výpoèet _ NEDOKONÈENÉ _ výroby'      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Aktualizace zùstatkù a obratù z automatù  '      ,'331', .f., .f., 'neco', 'neco' }  }} )
  endif
return pA


**UCTO**
METHOD UCT_aktucdat_BR:UCTDOKHD_TRe() ; RETURN ::UCTDOKHD[6,1,3]

**FINANCE**
METHOD UCT_aktucdat_BR:FAKPRIHD_TRe() ; RETURN ::FAKPRIHD[6,1,3]
METHOD UCT_aktucdat_BR:FAKVYSHD_TRe() ; RETURN ::FAKVYSHD[6,1,3]
METHOD UCT_aktucdat_BR:BANVYPHD_TRe() ; RETURN ::BANVYPHD[6,1,3]
METHOD UCT_aktucdat_BR:POKLADHD_TRe() ; RETURN ::POKLADHD[6,1,3]
METHOD UCT_aktucdat_BR:UCETDOHD_TRe() ; RETURN ::UCETDOHD[6,1,3]

**SKLADY**
METHOD UCT_aktucdat_BR:PVPHEAD_TRe()  ; RETURN ::PVPHEAD[6,1,3]

*MZDY**
METHOD UCT_aktucdat_BR:MZDY_HM_TRe()  ; RETURN ::MZDY_HM[6,1,3]
METHOD UCT_aktucdat_BR:MZDY_NE_TRe()  ; RETURN ::MZDY_NE[6,1,3]
METHOD UCT_aktucdat_BR:MZDY_SR_TRe()  ; RETURN ::MZDY_SR[6,1,3]
METHOD UCT_aktucdat_BR:MZDY_CM_TRe()  ; RETURN ::MZDY_CM[6,1,3]

**IM**
METHOD UCT_aktucdat_BR:ZMAJU_TRe()    ; RETURN ::ZMAJU[6,1,3]

*ZVÍØATA**
METHOD UCT_aktucdat_BR:ZVZMENHD_TRe() ; RETURN ::ZVZMENHD[6,1,3]
METHOD UCT_aktucdat_BR:ZMAJUZ_TRe()   ; RETURN ::ZMAJUZ[6,1,3]