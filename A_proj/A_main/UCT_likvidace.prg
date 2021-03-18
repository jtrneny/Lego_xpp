#include "class.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "dmlb.ch"


#include "..\Asystem++\Asystem++.ch"


#define     GetDBVal(c)   Eval( &("{||" + c + "}"))
#xtranslate PutDBVal(<cf>,<cs>) => ( mh_BLANKREC(<cf>)                           , ;
                                     Eval( &("{||" + <cs> + "}"))                , ;
                                     UCETPOLp ->nPOLUCTPR := UCETPRIT ->nPOLUCTPR  )


*
********* OBECNÁ TØÍDA PRO LIKVIDACI DOKLADÚ ***********************************
CLASS UCT_likvidace
EXPORTED:
  var     ucetpol_rlo                     // array RecNo z UCETPOL pro zámky
  var     main_File, main_Key, ucetpol_Sco, main_Method, klikvid, zlikvid

  method  init, destroy, zauctuj

  * SKL
  method  pvphead, pvpitem_40

  * IM,ZVIM
  method  zmaju

  * MZDY
  method  zauctuj_MZDY

  method  ucetpol_wrt, ucetpol_del

HIDDEN:
  var     inEdit, inLikv, stepBy

  method  ucetpol_tac, ucetpol_tst, ucetpolw_wrt, ucetsys_ks
ENDCLASS


METHOD UCT_likvidace:init(mainKey,inEdit,inLikv,stepBy)
  LOCAL  condUcto
  LOCAL  x, nIn, cC, pA, oClass

  local nTYPsym := SysConfig( "Mzdy:nSymUctMZD")

  ::inEdit   := IsNull(inEdit ,.f.)
  ::inLikv   := isnull(inLikv ,.f.)
  ::stepBy   := isnull(stepBy ,'' )

  ::klikvid  := 0
  ::zlikvid  := 0

  * mzdy
  if( select('c_vnMzUc') = 0, drgDBMS:open('C_VNMZUC'), nil )
  if( select('c_vnSaSt') = 0, drgDBMS:open('C_VNSAST'), nil )
  if( nTYPsym = 2, drgDBMS:open('mzdzavhd',,,,,'mzdzavhdu'), nil)

*
  drgDBMS:open('C_VYKDPH')
  *
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UCETPOL' )
  *
  drgDBMS:open('TYPDOKL' )
  drgDBMS:open('UCETPRHD')
  drgDBMS:open('UCETPRIT')
  drgDBMS:open('ucetprit',,,,,'ucetprit_w')
  drgDBMS:open('UCETPRSY')
  *
  ** tmp **
  if(select('ucetpolw') <> 0, ucetpolw->(dbclosearea()), nil)
  drgDBMS:open('UCETPOLp' ,.T.,.T.,drgINI:dir_USERfitm); ZAP; UCETPOLp  ->( DbAppend())
  drgDBMS:open('UCETPOLw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP; UCETPOLw  ->( AdsSetOrder(1))
  drgDBMS:open('UCETPOLw2',.T.,.T.,drgINI:dir_USERfitm); ZAP; UCETPOLw2 ->( AdsSetOrder(1))
  *
  TYPDOKL ->(DbSeek(mainKey,,'TYPDOKL02'))
  condUcto := ListAsArray(MemoTran(TYPDOKL ->mCONDUCTO,,''),';')

  ::ucetpol_rlo := {}
  ::main_File   := AllTrim(TYPDOKL ->cMAINFILE)
  ::ucetpol_sco := {}

  FOR x := 1 TO LEN(condUcto) STEP 1
    pA := ListAsArray(condUcto[x], ':')

    IF IsMemberVar(self,pA[1])
      cC := pA[1]

      IF( IsArray(self:&cC), AAdd(self:&cC, AllTrim(pA[2])), self:&cC := AllTrim(pA[2]))
    ENDIF
  NEXT

  *
  IF( ::inEdit, ::ucetpol_tac(), NIL )
RETURN self


METHOD UCT_likvidace:destroy()
  ::ucetpol_rlo := ;
  ::main_File   := ;
  ::main_Key    := ;
  ::ucetpol_sco := NIL
RETURN


method UCT_likvidace:zauctuj()
  local  mainFile, aFile := {}, cKEY
  local  is_ucskup, ucskup, ok, is_deleted
  *
  UCETPRHD ->( DbSeek( GetDBVal(::main_Key)))
  UCETPRIT ->( DbSetScope(SCOPE_BOTH,UCETPRHD ->(sx_KeyData())), DbGoTop())

  mainFile := AllTrim(Upper(UCETPRIT ->cMAINFILE))
  AAdd( aFile, ::main_File)
  (::main_File)->nKLikvid := (::main_File)->nZLikvid := 0


  DO WHILE .not. UCETPRIT ->(Eof())
    mainFile  := AllTrim(Upper(UCETPRIT ->cMAINFILE))
    (mainFile) ->(DbGoTop())
    is_ucskup := ((mainFile)->(fieldpos('cucetskup')) <> 0)

    UCETPRSY ->( DbSeek(Upper(UCETPRIT ->cTYPUCT),,'UCETPRSY01'))
    if aScan( aFile, mainfile) == 0
      AAdd( aFile, mainfile)
      (mainFile)->nKLikvid := (mainFile)->nzlikvid := 0
    endif

    *
    DO WHILE .not. (mainFile) ->(Eof())
      is_deleted := .f.
      if (mainFile)->(fieldPos('_delRec')) <> 0
        is_deleted := ((mainFile)->_delRec = '9')
      endif

      IF mainFile = 'VYKDPH_IW'
         C_VYKDPH ->(DbSeek(STRZERO( VYKDPH_IW ->nODDIL_dph,2) +STRZERO( VYKDPH_IW ->nRADEK_dph,3),,'VYKDPH1'))
      ENDIF

      if mainFile = 'FAKVNPITW'
        fakVnpit->( dbseek( strZero( fakVnpitW->ncisFak,10) +strZero( fakVnpitW->nintCount,5),, 'FVYSIT3' ))
      endif


      if is_ucskup
        cKey := GetDBVal(::main_Key)
        do case
        case ucetprit_w->(dbseek(GetDBVal(::main_Key) +upper((mainFile)->cucetskup),,'UCETPRIT01'))
          * - najdu konkrétní cucetskup nelze použít       prázdnou cucetskup v ucetprit
          ucskup := (mainFile)->cucetskup

        case ucetprit_w->(dbseek(GetDBVal(::main_Key) +'          '                ,,'UCETPRIT01'))
          * - najdu prázdnou  cucetskup lze   použít pouze prázdnou cucetskup v ucetprit
          ucskup := '          '

        otherwise
          * - prùšvich
          ucskup := ''

        endcase
      endif

      ok := if( is_ucskup, (ucetprit->cucetskup = ucskup), .t.)

      if(ok .and. .not. is_deleted, ::ucetpolw_wrt(mainFile), nil)
      (mainFile) ->(DbSkip())
    ENDDO
    (mainFile) ->(DbGoTop())

    UCETPRIT ->(DbSkip())
    mainFile := AllTrim(Upper(UCETPRIT ->cMAINFILE))
  ENDDO

  UCETPRIT ->( DbClearScope())
return


METHOD UCT_likvidace:Zmaju()
  local  mainFile, aFile := {}
  local  is_ucskup, ucskup, ok
  *
  UCETPRHD ->( DbSeek( GetDBVal(::main_Key)))
  UCETPRIT ->( DbSetScope(SCOPE_BOTH,UCETPRHD ->(sx_KeyData())), DbGoTop())

  mainFile := AllTrim(Upper(UCETPRIT ->cMAINFILE))
  AAdd( aFile, ::main_File)
  if( (::main_file)->( sx_IsLocked()), nil, (::main_file)->( RLock()) )
  (::main_File)->nKLikvid := (::main_File)->nZLikvid := 0

  DO WHILE .not. UCETPRIT ->(Eof())
    mainFile  := AllTrim(Upper(UCETPRIT ->cMAINFILE))
*    (mainFile) ->(DbGoTop())
    is_ucskup := ((mainFile)->(fieldpos('cucetskup')) <> 0)

    UCETPRSY ->( DbSeek(Upper(UCETPRIT ->cTYPUCT),,'UCETPRSY01'))
    if aScan( aFile, mainfile) == 0
      AAdd( aFile, mainfile)
      (mainFile)->nKLikvid := (mainFile)->nzlikvid := 0
    endif

    if is_ucskup
      do case
      case ucetprit_w->(dbseek(GetDBVal(::main_Key) +upper((mainFile)->cucetskup),,'UCETPRIT01'))
        * - najdu konkrétní cucetskup nelze použít       prázdnou cucetskup v ucetprit
        ucskup := (mainFile)->cucetskup
      case ucetprit_w->(dbseek(GetDBVal(::main_Key) +'          '                ,,'UCETPRIT01'))
        * - najdu prázdnou  cucetskup lze   použít pouze prázdnou cucetskup v ucetprit
        ucskup := '          '
      otherwise
        * - prùšvih
        ucskup := ''
      endcase
    endif

    ok := if( is_ucskup, (ucetprit->cucetskup = ucskup) .or. empty(ucetprit->cucetskup), .t.)
    if( ok, ::ucetpolw_wrt(mainFile), NIL )
    *
    UCETPRIT ->(DbSkip())
  ENDDO
  *
  ::ucetPol_wrt()
RETURN

*
** SKL - DOKLADY ************************************************************
**
METHOD UCT_likvidace:PVPHead()
  LOCAL  nRec := PVPItem->( RecNO()), cScope
  LOCAL  lDatLikv := .F., isZauctovano := .T.
  *

  UCETPRHD->( DbSeek( GetDBVal(::main_Key)))
  IF (::main_FILE)->( sx_RLock())
    PVPHead->nKlikvid := PVPHead->nZlikvid := 0
    * POL
    PVPItem->( dbGoTOP())
    DO WHILE .not. PVPITEM->(Eof())
*      cScope := GetDBVal(::main_Key) + Upper( PVPITEM->cUcetSkup )
*      cScope := Upper(PVPHEAD->cUloha) + Upper(PVPHEAD->cTypDoklad) + ;
      cScope := Upper(PVPHEAD->cUloha) + Upper(TYPDOKL->cTypDoklad) + ;
                PADR( ALLTRIM( STR( PVPItem->nCislPoh)),10) // + Upper( PVPITEM->cUcetSkup )

      UCETPRIT->( DbSetScope(SCOPE_BOTH, cScope), DbGoTop())
      DO WHILE .not. UCETPRIT->(Eof())
        IF UCETPRIT->cMainFile = 'PVPITEM'
          IF (  PVPITEM->cUcetSkup = UCETPRIT->cUcetSkup .or. EMPTY( UCETPRIT->cUcetSkup) )
            IF UCETPRSY->( DbSeek(Upper(UCETPRIT ->cTYPUCT),,'UCETPRSY01'))

              IF PVPItem->( sx_RLock()) .and. PVPHead->( sx_RLock())
                PVPItem->nKlikvid := PVPItem->nZlikvid := 0
                ::ucetpolw_wrt('PVPITEM')
                *
                IF PVPItem->nCislPoh == 80
                  ::PVPItem_40()
                ENDIF
                PVPHead->( dbRUnlock())
                PVPItem->( dbRUnlock())
                *
              ENDIF
            ENDIF
          ENDIF
        ENDIF
        UCETPRIT->(DbSkip())
      ENDDO
      UCETPRIT->( DbClearScope())
      PVPITEM->(DbSkip())
    ENDDO
    PVPITEM->( dbGoTO( nREC))
    * HLA
    cScope := GetDBVal(::main_Key)
    UCETPRIT ->( DbSetScope(SCOPE_BOTH, cScope), DbGoTop())
    DO WHILE .not. UCETPRIT->(Eof())
      IF UCETPRIT->cMainFile = ::main_FILE .and. ;
         UCETPRSY->( DbSeek(Upper(UCETPRIT ->cTYPUCT),,'UCETPRSY01'))
         IF (::main_FILE)->( sx_RLock())
           ::ucetpolw_wrt(::main_FILE)
           (::main_FILE)->( dbUnlock())
         ENDIF
      ENDIF
      UCETPRIT->(DbSkip())
    ENDDO
    UCETPRIT ->( DbClearScope())

    (::main_FILE)->( dbUnlock())
  ENDIF
  *
  ::ucetpol_wrt()

  UcetPOL->( dbUnlock(), dbCommit() )
RETURN

********************************************************************************
METHOD UCT_likvidace:PVPItem_40()
  Local cKEY, isHD, isIT
  Local nRecHD  := PVPHead->( RecNO()) , cFilter := PVPHead->( ADS_GetAOF())
  Local nRecIT  := PVPItem->( RecNO()) , aScoIT := PVPItem->( dbScope( SCOPE_BOTH))
  Local nRec    := UCETPRIT->( RecNO()), aSco   := UCETPRIT->( dbScope( SCOPE_BOTH))

  PVPHead->( ADS_ClearAOF())
  cKEY := Upper( PVPItem->cSkladKAM) + '00040' +  StrZero( PVPItem->nDoklad,10)
  isHD := PVPHead->( dbSEEK( cKey,,'PVPHEAD03'))

  PVPItem->( dbClearScope())
  cKEY := Upper( PVPItem->cSkladKAM) + StrZero( PVPItem->nDoklad,10)+;
          StrZero( PVPItem->nOrdItKAM, 5)
  isIT := PVPItem->( dbSeek( cKEY))

  IF isHD .and. isIT
    UCETPRIT->( dbClearScope())
    cKey := Upper(PVPHEAD->cUloha) + Upper(PVPHEAD->cTypDoklad) + ;
            PADR( ALLTRIM( STR( PVPItem->nCislPoh)),10) + Upper( PVPITEM->cUcetSkup )
    IF UCETPRIT->( DbSeek( cKey))
      IF UCETPRSY->( DbSeek(Upper(UCETPRIT ->cTYPUCT),,'UCETPRSY01'))
        IF PVPHEAD->( sx_RLock()) .and. PVPITEM->( sx_RLock())
          ::ucetpolw_wrt('PVPITEM')
          PVPHead->( dbRUnlock())
          PVPItem->( dbRUnlock())
        ENDIF
      ENDIF
    ENDIF
  ENDIF
  *
  IF Empty( cFilter)
  *  Jde o pøípad pøecenìní skladu z kalkulací
  ELSE
    PVPHead->( ADS_SetAOF( cFilter), dbGoTO( nRecHD))
    PVPItem->( dbSetScope( SCOPE_TOP, aScoIT[1]), dbSetScope( SCOPE_BOTTOM, aScoIT[2]), dbGoTO( nRecIT))
    UCETPRIT->( dbSetScope( SCOPE_TOP, aSco[1]) , dbSetScope( SCOPE_BOTTOM, aSco[2])  , dbGoTO( nRec)  )
  ENDIF
RETURN


*
** MZDY  -  mzdDavHD / IT  mzdyHD / IT
method UCT_likvidace:zauctuj_MZDY()
  local  mainFile, mainKey
  local  is_deleted, is_scoped

  ucetPrHD ->( dbSeek( GetDBVal(::main_Key)   ))    // culoha + ctypDoklad
    mainKey  := ucetPrHD->( sx_keyData())           // culoha + ctypDoklad + ctypPohybu

  if ucetPrIT ->( dbseek( mainKey,, 'UCETPRIT01'))
    mainFile  := allTrim( upper( ucetPrIT->cmainFile ))
    is_scoped := .f.

    (mainFile)->(dbgotop())

    do while .not. (mainFile)->(eof())

      is_deleted := .f.
      is_scoped  := .f.

      if (mainFile)->(fieldPos('_delRec')) <> 0
        is_deleted := ((mainFile)->_delRec = '9')
      endif

      if .not. is_deleted
        ucetPrIT->( dbsetscope( SCOPE_BOTH, mainKey +upper( (mainFile)->cucetSkup)), dbgotop())
        is_scoped := .t.

        do while .not. ucetPrIT->( eof())
          ucetPrSY->( dbseek( upper( ucetPrIT->ctypUct),,'UCETPRSY01'))

          ::ucetpolw_wrt( mainFile )
          ucetPrIT->( dbskip())
        enddo
      endif
     (mainFile)->( dbskip())
    enddo

    if( is_scoped, ucetPrIT->( dbclearScope()), nil )
    (mainFile)->( dbgotop())
  endif
return



*
**
Function LIKzavZAKL()
  Local  nRET_val := 0

  Do Case
  Case (FAKPRIHDw ->nFINtyp == 4)                                               // zahranièní faktura
    nRET_val := (FAKPRIHDw ->nCENzakCEL +FAKPRIHDw ->nPARzalFAK)

  Case (FAKPRIHDw ->nFINtyp == 2)                                               // celní      faktura
    nRET_val := FAKPRIHDw ->nCENzakCEL

  Case (FAKPRIHDw ->nFINtyp == 6)                                               // euro       faktura
    nRET_val := (FAKPRIHDw ->nCENzakCEL +FAKPRIHDw ->nPARzalFAK)

//  JS  Case (FAKPRIHDw ->nKURzahMEN <> FAKPRIHDw ->nKURzahMED)
//  JS  nRET_val := (FAKPRIHDw ->nCENzakCEL +FAKPRIHDw ->nPARzalFAK)

  OtherWise
    nRET_val := (FAKPRIHDw ->nOSVodDAN +FAKPRIHDw ->nZAKLdan_1 +FAKPRIHDw ->nZAKLdan_2 +FAKPRIHDw ->nZAKLdan_3)
  EndCase
Return(nRET_val)

*
**  pro vykdph_i
** local  nORD_dph := (VYKDPH_Iw ->nPORADI +100) * (-1)
Function UcPOL_ORD(nORD)
  local  nORD_dph

  if vykDph_iw->lpreDanPov
    nORD_dph := (ucetPrit->npoluctPR +100) * (-1)
  else
    nORD_dph := ( isNull(VYKDPH_Iw->sID, 0) +100) * (-1)
  endif
Return( nORD_dph)


*
**
METHOD UCT_likvidace:ucetpol_tac()
  local  cC := IsNull(::main_Method,'')

  * není pøedpis, nebo se doklad nelikviduje *
  if IsMethod(self, cC)

    * smyèka pro nìjaký soubor eof()
    if .not. empty(::stepBy)  ; (::stepBy)->(dbgotop())
                                do while .not. (::stepBy)->(eof())
                                  ::ucetpol_tst()
                                  (::stepBy)->(dbskip())
                                enddo
                                (::stepBy)->(dbgotop())
    else                      ; ::ucetpol_tst()
    endif

    self:&cC()
  endif
return

*
** zjistí existujíci záznamy v ucetpol pro zámky/pøepis
method UCT_likvidace:ucetpol_tst()
  local x, scope

  for x := 1 to len(::ucetpol_sco) step 1
    scope := GetDBVal(::ucetpol_sco[x])
    ucetpol->(dbsetscope(SCOPE_BOTH, scope), dbgotop())

    do while .not. ucetpol ->(eof())
      aadd(::ucetpol_rlo, ucetpol->(recno()))

      if( ::inLikv, mh_copyfld('ucetpol','ucetpolw',.t.), nil)
      ucetpol->(dbskip())
    enddo
  next
  ucetpol->(dbclearscope())
return

*
** pøed - úètuje do ucetpolw s vazbou na ucetpol *******************************
METHOD UCT_likvidace:ucetpolw_wrt( file)
  LOCAL  muctuj_1, muctuj_2, podminka, mKy, isIn, condto_w, cblok
  local  condto_ := '( .not. empty(ucetpolp->cucetmd) .and. .not. empty(ucetpolp->cucetdal) .and. (ucetpolp->nkcmd +ucetpolp->nkcdal) <> 0)'
  local  ok      := .t.

  podminka := CoalesceEmpty(likvidace_mem(UCETPRIT ->mPODMINKA), '.T.')

  * mzdy
  if( lower(file) = 'mzddavitw', VNU_mzddavitw(), nil )

  if GetDBVal(podminka)
    muctuj_1 := likvidace_mem(UCETPRSY ->mUCTUJ_MD , .T.)
    muctuj_2 := likvidace_mem(UCETPRSY ->mUCTUJ_DAL, .T.)

    PutDBVal('UCETPOLp',muctuj_1)

    if .not. empty(ucetpolp->cucetmd +ucetpolp->cucetdal)
      (file)->nKLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal
      if( file <> ::main_File, (::main_File)->nKLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal, nil)
      ::klikvid += (ucetpolp->nkcmd+ucetpolp->nkcdal)
    endif

    do case
    case ::inLikv
      mky := strzero(ucetpolp->npoluctpr,3) + ;
               strzero(ucetpolp->norditem,5) + ;
                strzero(ucetpolp->nsubucto,3) +strzero(ucetpolp->norducto,1)

      * má smysl nabízet k likvidaci
      if .not. empty(ucetpolp->cucetmd +ucetpolp->cucetdal) .and. (ucetpolp->nkcmd+ucetpolp->nkcdal) <> 0
        if .not. ucetpolw->(dbseek(mky,,'UCETPOw_a'))
          mh_copyfld('ucetpolp','ucetpolw',.t.)
          PutDBVal('UCETPOLp',muctuj_2)
          mh_COPYFLD('ucetpolp','ucetpolw', .t.)
          (file)->nZLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal
          if( file <> ::main_File, (::main_File)->nZLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal, nil)
          ::zlikvid += ucetpolp->nkcmd+ucetpolp->nkcdal
        endif
      endif

    otherwise
      condto_w := coalesceempty(ucetprsy->mpodminka,condto_)

      if GetDBVal(condto_w)
        mh_copyfld('ucetpolp','ucetpolw',.t.)
        PutDBVal('UCETPOLp',muctuj_2)
        mh_COPYFLD('ucetpolp', 'ucetpolw', .t.)
        (file)->nZLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal
        if( file <> ::main_File, (::main_File)->nZLikvid += ucetpolp->nkcmd+ucetpolp->nkcdal, nil)
        ::zlikvid += ucetpolp->nkcmd+ucetpolp->nkcdal
      endif
    endcase
  endif
return


static function likvidace_mem(memStr,toP)
  local cStr := MemoTran(memStr, ', ', '')

  toP := IsNull(toP,.F.)

  do while At(',', cStr, Len(cStr)) <> 0
    cStr := SubStr(cStr,1,Len(cStr) -1)
  enddo

  cStr := IF( toP, StrTran(cStr,'UCETPOL','UCETPOLp'), cStr)
return upper( AllTrim( cStr))


*
** pøeklopí UCETPOLw do UCETPOL ************************************************
METHOD UCT_likvidace:ucetpol_wrt()
  local  obdDokl, pa := AClone(::ucetpol_rlo)

  if .not. (::ucetpol_rlo == ucetpol->(dbrlocklist()))
    ucetpol->(sx_rlock(::ucetpol_rlo))
  endif

  ucetpolw->(dbCommit(), dbgotop())
  do while .not. ucetpolw ->(eof())
    obdDokl := IsNull(obdDokl, strzero(ucetpolw ->nrok,4) +strzero(ucetpolw ->nobdobi,2))

    IF .not. empty(pa) ; ucetpol ->(dbgoto(pa[1]))
                         (adel(pa,1), asize(pa, len(pa) -1))
    ELSE               ; ucetpol ->(dbappend(), rlock())
    ENDIF

    mh_COPYFLD('UCETPOLw','UCETPOL')
    ucetpolw ->(dbskip())
  ENDDO

  aeval(pa, {|x| ucetpol->(dbgoto(x),dbdelete()) })
  UCETPOL ->(DbCommit(), DbUnLock())
  *
  if( isNull(obdDokl), nil, ::ucetsys_ks(obdDokl))
RETURN


method UCT_likvidace:ucetpol_del()
  local obdDokl, pa := AClone(::ucetpol_rlo)

  ucetpol->(dbCommit(), dbGoTop())

  if len(pa) > 0
    ucetpol->(dbgoto(pa[1]))
    obdDokl := strzero(ucetpol->nrok,4) +strzero(ucetpol ->nobdobi,2)
  endif

  aeval(pa, {|x| ucetpol->(dbgoto(x),dbrlock(),dbdelete(),dbrunlock()) })
  *
  if( isNull(obdDokl), nil, ::ucetsys_ks(obdDokl))
RETURN

*
** zhodí pøíznak aktualizac v UCETSYS RRRRMM************************************
method uct_likvidace:ucetsys_ks(obdDokl)
  local  anUc := {}

  if select('ucetSys_kx') = 0
    drgDBMS:open('ucetSys',,,,,'ucetSys_kx')
  endif

  ucetSys_kx->( ordSetFocus( 'UCETSYS3' ))
  ucetSys_kx->( DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())
  ucetSys_kx->( dbSeek('U' +obdDokl))

  do while .not. ucetSys_kx->(eof())
    if( ucetSys_kx->nAKTUc_KS = 2, AAdd(anUc, ucetSys_kx->(recNo())), nil)
    ucetSys_kx->(dbSkip())
  enddo

  if ucetSys_kx->(sx_rlock(anUc))
    AEval(anUc, {|x| ( ucetSys_kx->(dbGoTo(x))          , ;
                       ucetSys_kx->nAKTUc_KS := 1       , ;
                       ucetSys_kx->cuctKdo   := logOsoba, ;
                       ucetSys_kx->ductDat   := date()  , ;
                       ucetSys_kx->cuctCas   := time()    ) })
  endif

  ucetSys_kx->(dbCommit(), dbUnlock(), dbClearScope())
return


*   mzdy
**  z èíselníkù c_vnMzUc / cc_vnSaSt vezme cucetvyn1 nebo cucetnak1
function fgenVnUcZm(cucet, file)
  local  nazPol2, cfak, ctyp := '0'

  default file to 'mzdDavItw'

  nazPol2 := (file)->cnazPol2

  if at( '?', cucet ) <> 0
    do case
    case nazPol2 <= "399"  ;  ctyp := "1"
    case nazPol2 <= "699"  ;  ctyp := "2"
    case nazPol2 <= "799"  ;  ctyp := "3"
    case nazPol2 <= "849"  ;  ctyp := "4"
    case nazPol2 <= "899"  ;  ctyp := "5"
    case nazPol2 <= "929"  ;  ctyp := "6"
    case nazPol2 <= "959"  ;  ctyp := "7"
    case nazPol2 <= "964"  ;  ctyp := "9"
    case nazPol2 <= "969"  ;  ctyp := "8"
    case nazPol2 <= "973"  ;  ctyp := "9"
    case nazPol2 <= "999"  ;  ctyp := "8"
    endcase

    cfak := if( (file)->nextFaktur = 1, "2", ;
            if( (file)->cKmenStrPr <> (file)->cNazPol1, "1", "0"))

    if SubStr( cucet, 4, 1) = "?"
      cucet := stuff( cucet, 4, 1, cfak )
    endif

    if Left( cucet, 1) = "5" .and. SubStr( cucet, 5, 1) = "?"
      cucet := stuff( cucet, 5, 1, ctyp )
    endif
  endif
return cucet


**  doplníme pro likvidaci vntropodnikové sazby
function VNU_mzddavitw( file)
  local  nbeg, nend, cx, cxx
  *
  local  nsazba, nmnoz, nvyp
  local  it_sazbaVNU := 'nsazbaVNU'
  local  it_typVypoc := 'ntypVypoc'

  default file to 'mzdDavItw'

  c_vnMzUc->( dbseek(       (file)->nucetMzdy,,'C_VNMZUC01'))
  c_vnSaSt->( dbseek( upper((file)->cnazPol5),,'C_VNSAST01'))

  (file)->nsazbaVNU1 := (file)->nmnozsVNU1 := ;
  (file)->nsazbaVNU2 := (file)->nmnozsVNU2 := 0

  if (file)->nucetMzdy <> 0
    nend := if( c_vnMzUc ->ctypVnUcto = "VNU1_KOM" .or. ;
                c_vnMzUc ->ctypVnUcto = "VNU4_OST" .or. ;
                (file)->nextFaktur = 1, 1, 2         )

    for nbeg := 1 to nend step 1
          cx := str(nbeg,1)
      nsazba := 0

      if nbeg = 1 .or. c_vnMzUc->ctypVnUcto =  "VNU2_PST"
        nsazba := DBGetVal( 'c_vnMzUc->nsazbaVNU' +cx )
        nvyp   := DBGetVal( 'c_vnMzUc->ntypVypoc' +cx )
      else
        if .not. c_vnSaSt->( eof())
          cxx    := if( (file)->ncisPrace >= 6500 .and.    ;
                        (file)->nCisPrace <= 6510, '2', '1')

          nsazba := DBGetVal( 'c_vnSaSt->nsazbaVNU' +cxx )
          nvyp   := DBGetVal( 'c_vnSaSt->ntypVypoc' +cxx )
        endif
      endif

      if nsazba <> 0
        nmnoz := if( nvyp = 1, (file)->nhodDoklad , ;
                  if( nvyp = 2, (file)->nmnPDoklad, ;
                   if( nvyp = 3, (file)->nmzda, 0   )))

        DBPutVal(file+'->nsazbaVNU' +cx, nsazba)
        DBPutVal(file+'->nmnozsVNU' +cx, nmnoz )
      endif
    next
  endif
return nil


function fRezVazba( lSPRAV, file)
  local cRET := ""

  default lSPRAV to .F.
  default file  to 'mzddavit'

  drgDBMS:open('c_naklst',,,,,'c_naklstr')

  if lSPRAV
    c_naklstr->( dbseek( '1',,'C_NAKLST10'))
    cRET := c_naklstr->cNazPol1
  else
    if c_naklstr->( dbseek( (file)->ckmenStrPr +'1',,'C_NAKLST9'))
      cRET := c_naklstr->cNazPol1
    else
      drgDBMS:open('msprc_mo',,,,,'msprc_mor')
      if msprc_mor ->( dbSeek( (file)->croobcpppv,,'MSPRMO17'))
        if c_naklstr->( dbseek( msprc_mor->cnazpol1 +'1',,'C_NAKLST9'))
          cRET := c_naklstr->cNazPol1
        endif
      endif
    endif
  endif

return( cRET)

function MzdVARsym( filein )
  local cSYMBOL := ""
  local nTYPsym := SysConfig( "Mzdy:nSymUctMZD")

  if .not. Empty( filein)
    do case
    case nTYPsym = 1
      cSYMBOL := AllTrim( Str( (filein)->nOsCisPrac))
    case nTYPsym = 2
      cSYMBOL := AllTrim( Str( 5000000 +( (filein)->nRok *100) +(filein)->nObdobi))
    case nTYPsym = 3
      cSYMBOL := (filein)->cVarSym
    endcase
  endif

return( cSYMBOL)


function BaMzVARsym( filein )
  local cSYMBOL := ""
  local nTYPsym := SysConfig( "Mzdy:nSymUctMZD")

  if .not. Empty( filein)
    do case
    case nTYPsym = 1 .or. nTYPsym = 3
      cSYMBOL := (filein)->cVarSym
    case nTYPsym = 2
      if mzdzavhdu ->( dbSeek( (filein)->ncisfak,,'MZDZAVHD09'))
        cSYMBOL := AllTrim( Str( 5000000 + mzdzavhdu ->nRokObd))
      endif
    endcase
  endif

return( cSYMBOL)