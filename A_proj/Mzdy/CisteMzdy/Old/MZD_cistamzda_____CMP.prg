#include "class.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "dmlb.ch"


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
  method  zmaju

  method  ucetpol_wrt, ucetpol_del

HIDDEN:
  var     inEdit, inLikv, stepBy

  method  ucetpol_tac, ucetpol_tst, ucetpolw_wrt, ucetsys_ks
ENDCLASS


METHOD UCT_likvidace:init(mainKey,inEdit,inLikv,stepBy)
  LOCAL  condUcto
  LOCAL  x, nIn, cC, pA, oClass

  ::inEdit  := IsNull(inEdit ,.f.)
  ::inLikv  := isnull(inLikv ,.f.)
  ::stepBy  := isnull(stepBy ,'' )
  ::klikvid := 0
  ::zlikvid := 0

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
    nRET_val := (FAKPRIHDw ->nOSVodDAN +FAKPRIHDw ->nZAKLdan_1 +FAKPRIHDw ->nZAKLdan_2)
  EndCase
Return(nRET_val)

*
** pro vykdph_i
Function UcPOL_ORD(nORD)
  Local nORD_dph := (VYKDPH_Iw ->nPORADI +100) * (-1)
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


*-  ok := if ((file)->(FieldPos("CUCETSKUP"))>0                                ;
*-             , (file)->CUCETSKUP == ucetprit ->CUCETSKUP, .T.)

  podminka := CoalesceEmpty(likvidace_mem(UCETPRIT ->mPODMINKA), '.T.')

  if GetDBVal(podminka)  // .and. ok
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

/*
method uct_likvidace:ucetsys_ks(obdDokl)
  local  anUc := {}

  fordRec({'UCETSYS,3'})
  ucetsys->( AdsSetOrder('UCETSYS3'), DbSetScope( SCOPE_BOTH, 'U'), dbGoTop())

  if ucetsys->( dbSeek('U' +obdDokl,,'UCETSYS3'))
    do while .not. ucetsys->(eof())
      if( ucetsys->nAKTUc_KS = 2 .and. .not. ucetsys->lzavren, AAdd(anUc, ucetsys->(recNo())), nil)
      ucetsys->(dbSkip())
    enddo

    if ucetsys->(sx_rlock(anUc))
      AEval(anUc, {|x| ( ucetsys->(dbGoTo(x))          , ;
                         ucetsys->nAKTUc_KS := 1       , ;
                         ucetsys->cuctKdo   := logOsoba, ;
                         ucetsys->ductDat   := date()  , ;
                         ucetsys->cuctCas   := time()    ) })
    endif
  endif

  ucetsys->(dbCommit(), dbUnlock(), dbClearScope())
  fordRec()
return
*/