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

    **ZV��ATA**
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

  **ZV��ATA**
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

  ** OBDOB� PRO PO��TE�N� STAVY
  oData:cOBD_PSn := StrZero( UCETSYS ->nROK,4) +StrZERO( UCETSYS ->nOBDOBI,2)

  ** OBDOB� OD
  oData:cOBD_OD  := UPPER( UCETSYS ->cOBDOBI)
  oData:cOBD_ODn := StrZero( UCETSYS ->nROK,4) +StrZero(UCETSYS ->nOBDOBI,2)

  ** OBDOB� DO
  ucetsys->(dbgoBottom())
  oData:cOBD_DO  := UPPER( UCETSYS ->cOBDOBI)
  oData:cOBD_DOn := StrZERO( UCETSYS ->nROK,4) +StrZero( UCETSYS ->nOBDOBI,2)
  oData:aOBD_AKT := {}

  //---------- POLE OBDOB� pro AKTUALIZACI -------------------------------------
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

  //----------- ZP�SOB v�po�tu AUTOMAT� (OBRo/KSr) -----------------------------
  If SysConfig( 'UCTO:lAUTO_obr' )
    oData:aAUTO_VY := { '( UCETKUM ->nKCmdOBRO  -UCETKUM ->nKCdalOBRo )', ;
                        '( UCETKUM ->nKCdalOBRO -UCETKUM ->nKCmdOBRo  )'  }
  Else
    oData:aAUTO_VY := { '( UCETKUM ->nKCmdKSr  -UCETKUM ->nKCdalKSr )', ;
                        '( UCETKUM ->nKCdalKSr -UCETKUM ->nKCmdKSr  )'  }
  EndIf

  drgDBMS:open('confighd')
  confighd->(dbClearScope(), dbGoTop())
  oData:aDENIKY := { { 'X ', '��t_Autom_PS  '}, ;
                     { 'AN', '��t_Autom_NV  '}, ;
                     { 'AV', '��t_Autom_VR  '}, ;
                     { 'AS', '��t_Autom_SR  '}, ;
                     { 'AZ', '��t_Autom_ZR  '}, ;
                     { 'MC', 'mzd_�ist�_MZ  '}  }

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
{ { 'Na�ten� dat pro centr�l ��TO'                            , '1' , .f., .f., '', ;
    { { 'Na�ten� vstupn�ch dat'                               , '1' , .f., .f., 'neco', 'neco' }, ;
      { 'Kontrola vstupn�ch dat'                              , '1' , .f., .f., 'neco', 'neco' }, ;
      { 'Aktualizace z�kladn�ho souboru'                      , '1' , .f., .f., 'neco', 'neco' }  }}, ;
  { 'Kontrola z�kladn�ch soubor� ��TO'                        , '2' , .f., .f., '', ;
      ::TASKS('2')                                                                          }, ;
  { 'Aktualizace ��etn�ch knih a modifikace salda'            , '3' , .f., .f., '', ;
    { { 'Kontrola z�kladn�ch soubor� ��TO'                    ,'31' , .t., .t., '', ;
         ::TASKS('31')                                                                      }, ;
      { 'V�po�et z�statk�/obrat� na ��tech a modifikace SALDA','32' , .t., .f., '', ;
         ::POCSTAV()                                                                        }, ;
      { 'Zpracov�n� aktualizace saldokontn�ch polo�ek'        ,'321', .f., .f., 'saldo', ''    }  }  } }
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

  AAdd(pA,{ 'Zpracov�n� aktualizace z�statk� a obrat�','321', .f., .f., 'obraty', '' })

  autom_hd->(dbGoTop())

  if .not. autom_hd->(eof())
    AAdd(pA, ;
    { 'Zpracov�n� automatick�ch v�po�t�        '            ,'33' , .f., .t., 'automaty', ;
      { { 'Automatick� v�po�et _   V�ROBN�   _ re�ie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatick� v�po�et _   SPR�VN�   _ re�ie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatick� v�po�et _   Z�SOBOV�  _ re�ie '      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Automatick� v�po�et _ NEDOKON�EN� _ v�roby'      ,'331', .f., .f., 'neco', 'neco' }, ;
        { 'Aktualizace z�statk� a obrat� z automat�  '      ,'331', .f., .f., 'neco', 'neco' }  }} )
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

*ZV��ATA**
METHOD UCT_aktucdat_BR:ZVZMENHD_TRe() ; RETURN ::ZVZMENHD[6,1,3]
METHOD UCT_aktucdat_BR:ZMAJUZ_TRe()   ; RETURN ::ZMAJUZ[6,1,3]