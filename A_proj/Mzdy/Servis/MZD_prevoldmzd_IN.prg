#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "class.ch"
#include "dbstruct.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"

//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"

#include "..\A_main\WinApi_.ch"


** CLASS for MZD_prevoldmzd_in ***************************************************
CLASS MZD_prevoldmzd_IN FROM drgUsrClass
EXPORTED:
  VAR     aitw


  METHOD  init, drgDialogStart, itemMarked, preValidate, postValidate
   *
  method  ebro_saveEditRow
  method  prevoldmzd
  method  zrusPrevod
   *
  METHOD  destroy

  VAR     cOLDfrmName
  *
  INLINE METHOD isOk()
    LOCAL isOk := .not. Empty(::aitw)
    AEval(::aitw, {|s| if( Empty(s), isOk := .F., NIL )})
    if( isOk, ::pushOk:enable(), ::pushOk:disable())
  RETURN isOk
  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc     := ::drgDialog:dialogCtrl
    LOCAL  dbArea := ALIAS(SELECT(dc:dbArea))

    DO CASE
    CASE nEvent = drgEVENT_DELETE
      if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]
         if drgIsYESNO(drgNLS:msg( 'Zrušit nastavení oprávnìní <&> ?' , asysact ->cidobject))
          oXbp:cargo:refresh()
        endif
      endif
      RETURN .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  var     msg, dm, bro, dctrl, pushOk, key
  var     prevForm, prevBro, prevFile, lnewrec
ENDCLASS


METHOD MZD_prevoldmzd_IN:init(parent)
  local cparm

  ::drgUsrClass:init(parent)

   cParm    := drgParseSecond(::drgDialog:initParam)

  ::prevFile := ''
  ::lnewrec  := .F.
  ::key    := cParm

  drgDBMS:open('prevodmz')
  prevodmz->(OrdSetFocus('PREVODMZ04'))

//  ASYSACT->(DbSetRelation( 'ASYSTEM',{|| ASYSACT->cIDobject },'ASYSACT->cIDobject','ASYSTEM04'))

RETURN self





METHOD MZD_prevoldmzd_IN:drgDialogStart(drgDialog)
  LOCAL broPos, members, x
  local filtr

  *
  ::prevForm := drgDialog:parent
  ::prevFile := ''
  members    := ::prevForm:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if 'browse' $ lower(members[x]:className())
        ::prevBro  := members[x]
        ::prevFile := ::prevBro:cFile
  BREAK
      endif
    next
  END SEQUENCE

  *
  ::msg      := drgDialog:oMessageBar
  ::dm       := drgDialog:dataManager
  ::dctrl    := drgDialog:dialogCtrl
  ::prevForm := drgDialog:parent

  *
  members  := drgDialog:oForm:aMembers
  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if members[x]:ClassName() = 'drgBrowse'
        drgDialog:oForm:nextFocus := x
  BREAK
      endif
    next
  END SEQUENCE

/*
  if ::key == 'USER'
    filtr := Format("cUser = '%%'", {users->cuser})
  else
    filtr := Format("cGroup = '%%'", {usersgrp->cgroup})
  endif

  asysact->( ads_setaof(filtr))
  asysact->(dbGoTop())
*/

  ::dctrl:oBrowse[1]:refresh(.t.)
RETURN self



METHOD MZD_prevoldmzd_IN:itemMarked()
  LOCAL  buffer

  if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]

  end
RETURN NIL


METHOD MZD_prevoldmzd_IN:preValidate(drgVar)
  local  lOk := .T., odesc, picture

*-  drgVar:oDrg:oXbp:enable()
/*
  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    lOk   := (at('->',filtritw ->cvyraz_2) = 0)
    odesc := drgDBMS:getFieldDesc(strtran(filtritw->cvyraz_1,' ',''))


    if lOK .and. IsObject(odesc)
      do case
      case odesc:type = 'D'
        drgVar:odrg:oxbp:picture := '@D'
      otherwise
        picture := if(odesc:name = 'COBDOBI','99/99',odesc:picture)
        drgVar:oDrg:oXbp:picture := picture
      endcase

    else
*-      drgVar:oDrg:oXbp:disable()
      lOk := .f.
    endif
  endif
*/
RETURN lOk


METHOD MZD_prevoldmzd_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.

/*
  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
      filtritw ->cvyraz_2         := value
      ::aitw[filtritw->(RecNo())] := value
    endif

    ::isOk()
  endif
*/

RETURN lOk


*
*
METHOD MZD_prevoldmzd_IN:zrusPrevod(drgDialog)
  local  lOk := .T.
  local  ccc := ''
//  local  value := drgVar:get(), lOk := .T.


  dbUseArea( .T.,'FOXCDX','c:\ALASKA\XPPW32\Projects\Prevod_Rovina\stav.dbf','stav',.F.)

  do while .not. stav->(Eof())

    ccc := stav->nazevpol

    stav->( dbSkip())
  enddo

/*
  if drgIsYESNO(drgNLS:msg('ZAKÁZAT pøevod dat od zaèátku ?'))
    prevodmz->( dbGoTop())
    do while .not. prevodmz->( eof())
      prevodmz->( dbRlock())
      prevodmz->nTypPrevod := 3
      prevodmz->( dbUnlock())
      prevodmz->( dbSkip())
    enddo
    prevodmz->( dbGoTop())
    drgDialog:dialogCtrl:oBrowse[1]:refresh(.t.)
  endif
*/

RETURN lOk


*
*
** pøevod mezd z pùvodního systému ***************************************
METHOD MZD_prevoldmzd_IN:PrevOldMzd(parent)
  LOCAL i,j,k,l,m,n
  LOCAL cProtokol
  LOCAL aStruNEW, aDesc
  LOCAL aStruOLD
  LOCAL values
  LOCAL lOK
  LOCAL lPreved
  LOCAL cName, nPos
  LOCAL cFile, cX
  LOCAL lPREV
  LOCAL nTyp
  LOCAL oDialog, nExit
  local old, new
  local ncommit
  local npocet, ncelk
  local time1, time2
  *
  local  b_mblock

  local in_Dir, cc := 'Kde jsou data starého systému - DOS ?'

  cPath := AllTrim( SysConfig( "System:cPathArch"))
  IF( Right( cPath, 1) <> "\", cPath := cPath +"\", NIL)

  in_Dir := BrowseForFolder( , cc, BIF_USENEWUI )

  if .not. empty(in_Dir)
    cpath := in_Dir +if( right( in_Dir, 1) <> '\', '\', '' )
  else
    return .f.
  endif


//  cPath := selDir(,cPath,,,,.t.)
//  cPath := AllTrim(cPath)
//  cPath := Left( cPath, RAt('\', cPath))

//  if isNil(cPath)
//    RETURN
//  endif

  if drgIsYESNO(drgNLS:msg('Zpracovat pøevod dat'))
*    drgNLS:msg('Pozor pøi pokraèování v pøevodu dojde ke smazání stávajících dat')
    if .not. drgIsYESNO(drgNLS:msg('Pozor pøi pokraèování v pøevodu dojde ke smazání stávajících dat. Opravdu pokraèovat v pøevodu'))
      return
    endif
    if drgIsYESNO(drgNLS:msg('Provádìt pøevod dat od zaèátku'))
      prevodmz->( dbGoTop())
      do while .not. prevodmz->( eof())
        prevodmz->( dbRlock())
        prevodmz->cKonPrev := ''
        prevodmz->( dbUnlock())
        prevodmz->( dbSkip())
      enddo
      nTyp := 0
    else
      nTyp := 1
    endif

    prevodmz->( dbGoTop())
    do while .not. prevodmz->( eof())
      prevodmz->( dbRlock())
      if nTyp == 0
        lPREV := (prevodmz->nTypPrevod == 0)
      else
        lPREV := (prevodmz->nTypPrevod == 0 .and. Empty( prevodmz->cKonPrev))
      endif

      prevodmz->nStavPrev := 0
      prevodmz->mProtokol := ''
      prevodmz->cZacPrev  := DtoC( Date()) +"  "+ Time()
      cFile   := prevodmz->cNewFile
      lOK     := .T.
      lPreved := .T.

      if lPREV
        if !File( AllTrim(cPath) +AllTrim(prevodmz->cOldPath) +AllTrim(prevodmz->cOldFile) +'.dbf')
          AktStav('Chybí starý soubor !!!')
          prevodmz->nStavPrev := 11
          lOK := .F.
        endif

        if .not. IsObject(odbd := drgDBMS:dbd:getByKey(AllTrim(prevodmz->cNewFile)))
          AktStav('Chybí nová tabulka !!!')
          prevodmz->nStavPrev := 12
          lOK := .F.
        endif

        if lOK
          drgNLS:msg('Pøipravuji pro pøevod soubor - ' + AllTrim(prevodmz->cOldFile))
          cX := AllTrim(cPath) +AllTrim(prevodmz->cOldPath) +AllTrim(prevodmz->cOldFile)
          FErase( cX +'.cdx')
          dbUseArea( .T.,'FOXCDX',cX,'Old',.F.)

          drgDBMS:open(AllTrim(prevodmz->cnewfile),.t.,,,,'New')
          new->( OrdSetFocus(0))

//          dbUseArea( .T.,oSession,AllTrim(::cNewADR) +AllTrim(prevodmz->cNewFile),'New',.F.)

          if( prevodmz->nZpusMaz = 1, New->( dbZAP()), nil)
          Old->( dbPack())
          Old->( dbGoTop())

          values := drgDBMS:dbd:values

          FOR x := 1 to LEN(values) STEP 1
            obj  := values[x,2]
            fileName := obj:fileName
            aDesc    := obj:desc
            IF fileName = AllTrim(cFile)
              IF VALTYPE(aDesc[1]) = 'O'
                aStruNEW := {}
                AEVAL(aDesc, {|o| AADD(aStruNEW, { o:name, o:type, o:len, o:dec} ) } )
              ELSE
  * New description is supplied as array[name, type, len, dec]
               aNewDesc := ACLONE(aDesc)
              ENDIF
              EXIT
            ENDIF
          NEXT
  //        aStruNEW[1] :=
  //        aStruNEW := New->( dbStruct())
          aStruOLD := Old->( dbStruct())


          FOR n:= 1 TO Len( aStruOLD)
            IF ( i := AScan( aStruNEW,{|X| X[1] = aStruOLD[n,1]})) > 0
              IF aStruNEW[i,2] <> aStruOLD[n,2]
                AktStav('Promìnné sobì neodpovídají NEW: ' + aStruNEW[i,2] + 'OLD:' +aStruOLD[n,2])
                AktStav('Pøevod souboru byl odmítnut!!!!')
                prevodmz->nStavPrev := 20
                lPreved := .F.
              ELSE
                IF aStruNEW[i,3] <> aStruOLD[n,3]
                  AktStav('Pozor neodpovídá délka promìnných NEW: '+ Str(aStruNEW[i,3],6)+'OLD: '+Str(aStruOLD[n,3],6))
                  prevodmz->nStavPrev := 21
                ENDIF
                IF aStruNEW[i,4] <> aStruOLD[n,4]
                  AktStav('Pozor neodpovídá dec promìnné NEW: ' + Str(aStruNEW[i,3],6) + 'OLD: ' +Str(aStruOLD[n,3],6))
                  prevodmz->nStavPrev := 22
                ENDIF
              ENDIF
              ADel( aStruNEW, i)
              ASize( aStruNEW, Len( aStruNEW)-1)
            ELSE
              prevodmz->nStavPrev := 30
              AktStav('Promìnná >' + aStruOLD[n,1] +'< neexistuje v novém souboru ')
            ENDIF
          NEXT

          FOR n := 1 TO Len( aStruNEW)
            IF 'CUSRZMENYR' <> aStruNEW[n,1] .AND. 'DDATZMENYR' <> aStruNEW[n,1] .AND. ;
               'CCASZMENYR' <> aStruNEW[n,1] .AND. 'CUSRVZNIKR' <> aStruNEW[n,1] .AND. ;
               'DDATVZNIKR' <> aStruNEW[n,1] .AND. 'CCASVZNIKR' <> aStruNEW[n,1]
              prevodmz->nStavPrev := 30
              AktStav('Promìnná >' + aStruNEW[n,1] +'< neexistuje ve starém souboru ')
            ENDIF
          NEXT

          IF lPreved
            b_mblock := if( .not. empty( prevodmz->mBlok ), COMPILE( blok_mem(prevodmz->mBlok, .f.) ), { || .t. } )

            IF( !Empty( prevodmz->mBeginBlok), DBGetVal( blok_mem(prevodmz->mBeginBlok)), NIL)
            Old->( dbGoTop())
            ncommit := 0
            if .not. IsNil( OLD->( LASTREC()))
              drgServiceThread:progressStart( drgNLS:msg('Pøevádím soubor - ' + AllTrim(prevodmz->cOldFile)), OLD->( LASTREC()))
            else
              ncommit := 0
            endif

            DO WHILE .not. Old->( Eof())
              New ->( dbAppend())

              if New->( FieldPos("cUniqIdRec")) > 0
                New->cUniqIdRec := StrZero(usrIdDB,6) +PadR(fileName,10)+ StrZero(New->(Recno()),10)
              endif

              prevodmz->nPrevRec := Old->( Recno())
              prevodmz->nLastRec := New->( Recno())
              FOR n := 1 TO Old->(FCount())
                IF ( nPos := New->( FieldPos( Old->( FieldName( n))))) > 0
                  DO CASE
                  CASE ValType( Old->( FieldGet( n))) == 'U'
                    IF Empty( Old->( FieldGet( n)))
                      AktStav('Pozor nepodporovaný typ (asi pole) ' +Old->( FieldName( n)) )
                      prevodmz->nStavPrev := 50
                    ELSE
                      cX := Old->( FieldGet( n))
                    ENDIF
                  OTHERWISE
                    New->( FieldPut( nPos, Old->( FieldGet( n))))
                  ENDCASE
                ENDIF
              NEXT

              eval( b_mblock )

//              IF( !Empty( prevodmz->mBlok), DBGetVal( blok_mem(prevodmz->mBlok)), NIL)

              drgServiceThread:progressInc()
              Old->( dbSkip())

              ncommit++
              if ncommit =50
                new->( dbCommit())
                ncommit := 0
              endif

            ENDDO

            if AllTrim(prevodmz->cnewfile) = 'm_nem' .or. AllTrim(prevodmz->cnewfile) = 'm_srz'
              New->( dbCloseArea())
            endif

            b_mblock := if( .not. empty( prevodmz->mEndBlok ), COMPILE( blok_mem(prevodmz->mEndBlok, .f.) ), { || .t. } )
            eval( b_mblock )

//            IF( !Empty( prevodmz->mBeginBlok), DBGetVal( blok_mem(prevodmz->mBeginBlok)), NIL)


//            IF( !Empty( prevodmz->mEndBlok), DBGetVal( blok_mem(prevodmz->mEndBlok)), NIL)

          ENDIF
          drgServiceThread:progressEnd()
          if( select('Old') <> 0, Old->( dbCloseArea()), nil )
          if( select('New') <> 0, New->( dbCloseArea()), nil )
        ENDIF
      ENDIF

      prevodmz->cKonPrev := DtoC( Date()) +"  "+ Time()
      prevodmz->( dbUnlock())

      prevodmz->( dbSkip())
    enddo
  endif

  ::lnewrec := .F.
RETURN self


method MZD_prevoldmzd_in:ebro_saveEditRow(parent)
  local  cfile := lower(parent:cfile)

/*
  if ::key == 'USER'
    asysact->cuser  := users->cuser
  else
    asysact->cgroup := usersgrp->cGroup
  endif
*/


return


*
** END of CLASS ****************************************************************
METHOD MZD_prevoldmzd_IN:destroy()
  ::drgUsrClass:destroy()

  ::aitw     := ;
  ::msg      := ;
  ::dm       := ;
  ::bro      := ;
  ::dctrl    := ;
  ::pushOk   := ;
  ::prevForm := NIL

//  asysact->(ads_clearaof())

RETURN NIL



FUNCTION Akt_OdpMis()

  drgDBMS:open('c_odpmis')
  new->( dbGoTop())

  do while .not. new->( Eof())
    if new->lStavem
      if .not. c_odpmis->( dbSeek( new->noscisprac,,'C_3'))
        mh_COPYFLD('New', 'c_odpmis', .T.)
        c_odpmis->cklicodmis := AllTrim(Str(new->noscisprac))
        c_odpmis->cnazodpmis := new->cpracovnik
      endif
    endif
    new->( dbSkip())
  enddo

  c_odpmis->( dbCloseArea())

RETURN NIL


FUNCTION Gen_Tarif()
  local key

  drgDBMS:open('msprc_mz')
  msprc_mz->( dbGoTop())

  do while .not. msprc_mz->( Eof())
    if msprc_mz->ctyptarpou = "NEPOUZIV"
      key := STRZERO(msprc_mz->nOsCisPrac,5) +STRZERO(msprc_mz->nPorPraVzt,3) +;
              UPPER(msprc_mz->cTypTarPou) +UPPER(msprc_mz->cTarifTrid) +       ;
               UPPER(msprc_mz->cTarifStup) +UPPER(msprc_mz->cDelkPrDob) +      ;
               if(empty(msprc_mz->dPlatTarOd) ,'        ' , DTOS(msprc_mz->dPlatTarOd))
      if .not. new->( dbSeek( key,,'C_TARIN6'))
        mh_COPYFLD('msprc_mz','New', .T.)
        new->ctask     := "MZD"
        new->culoha    := "M"
        new->lAktTarif := .t.
      endif
    endif
    msprc_mz->( dbSkip())
  enddo

  msprc_mz->( dbCloseArea())

RETURN NIL


FUNCTION Gen_SazZMS()
  local key

  drgDBMS:open('mssazzam')

  if new->nSazPrePr <> 0
    mh_COPYFLD('New','mssazzam', .T.)
    mssazzam->ctask     := "MZD"
    mssazzam->culoha    := "M"
    mssazzam->cTypSazby :='PRCPREHLCI'
    mssazzam->nSazba    := old->nSazPrePr
    mssazzam->lAktSazba := .t.
  endif

  if new->nSazOsoOh <> 0
    mh_COPYFLD('New','mssazzam', .T.)
    mssazzam->ctask     := "MZD"
    mssazzam->culoha    := "M"
    mssazzam->cTypSazby := 'SAZOSOOHOD'
    mssazzam->nSazba    := old->nSazOsoOh
    mssazzam->lAktSazba := .t.
  endif

  if new->nSazPodHVP <> 0
    mh_COPYFLD('New','mssazzam', .T.)
    mssazzam->ctask     := "MZD"
    mssazzam->culoha    := "M"
    mssazzam->cTypSazby := 'PRCPODNAHV'
    mssazzam->nSazba    := old->nSazPodHVP
    mssazzam->lAktSazba := .t.
  endif

  if new->nHodPovPre <> 0
    mh_COPYFLD('New','mssazzam', .T.)
    mssazzam->ctask     := "MZD"
    mssazzam->culoha    := "M"
    mssazzam->cTypSazby := 'HODPOVPRES'
    mssazzam->nSazba    := old->nHodPovPre
    mssazzam->lAktSazba := .t.
  endif

  mssazzam->( dbCloseArea())

RETURN NIL


FUNCTION Gen_Sazby()
  local key
  local lgen := .f.

  if old->nSazPrePr <> 0
    if( lgen, mh_COPYFLD('Old','New', .T.), nil)
    new->ctask     := "MZD"
    new->culoha    := "M"
    new->cTypSazby :='PRCPREHLCI'
    new->nSazba    := old->nSazPrePr
    new->lAktSazba := .t.
    lgen := .t.
  endif

  if old->nSazOsoOh <> 0
    if( lgen, mh_COPYFLD('Old','New', .T.), nil)
    new->ctask     := "MZD"
    new->culoha    := "M"
    new->cTypSazby := 'SAZOSOOHOD'
    new->nSazba    := old->nSazOsoOh
    new->lAktSazba := .t.
    lgen := .t.
  endif

  if old->nSazPodHVP <> 0
    if( lgen, mh_COPYFLD('Old','New', .T.), nil)
    new->ctask     := "MZD"
    new->culoha    := "M"
    new->cTypSazby := 'PRCPODNAHV'
    new->nSazba    := old->nSazPodHVP
    new->lAktSazba := .t.
    lgen := .t.
  endif

  if old->nHodPovPre <> 0
    if( lgen, mh_COPYFLD('Old','New', .T.), nil)
    new->ctask     := "MZD"
    new->culoha    := "M"
    new->cTypSazby := 'HODPOVPRES'
    new->nSazba    := old->nHodPovPre
    new->lAktSazba := .t.
    lgen := .t.
  endif

RETURN NIL


FUNCTION GenDavOst()

  if( select('mzdDavHd') <> 0, mzdDavHd->(dbcommit()), nil )
  new->(dbcommit())
  GenMdavHD()


  if( select('mzdDavHd') <> 0, mzdDavHd->(dbcommit()), nil )
  GenMnemHD()

  if( select('mzdDavHd') <> 0, mzdDavHd->(dbcommit()), nil )
  GenMsrzHD()

// ( GenMsrzHD(), GenMnemHD() )
// ( GenMnemHD() )
// ( GenMdavHD(), GenMsrzHD(), GenMnemHD() )
return nil


FUNCTION GenMdavHD()
  local lgen := .t., lAdd := .t.
  local key, astruct
  local ncommit := 0
  local ctmpdav


  drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy - generuji MZDDAVHD'), new->( LastRec()))

///  dbselectarea('new')
///  dbCreateIndex( drgINI:dir_USERfitm+'new','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(nporpravzt,3)+StrZero(ndoklad,10)';
///                   , {|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(nporpravzt,3)+StrZero(ndoklad,10) })

  new->(ordSetFocus( 'MZDDAVIT01' ), dbgoTop())

  drgDBMS:open('mzddavhd',.t.)
  astruct := new->( dbstruct())

//  mzddavhd->(dbzap())
  new->( dbGoTop())
  key := StrZero(new->nrok,4)+StrZero(new->nobdobi,2)+StrZero(new->noscisprac,5)+StrZero(new->nporpravzt,3)+StrZero(new->ndoklad,10)

  drgDBMS:open('mzddavitw',.t.,.t.,drgINI:dir_USERfitm,,,.t.)
  mzddavitw->( dbCloseArea())

  ctmpDav  := drgINI:dir_USERfitm +userWorkDir() +'\mzddavitw.adt'

  new ->( dbTotal(  ctmpdav,  ;
                      { || STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3) +STRZERO(nDoklad,10)}, ;
                      {  'nHrubaMzd','nMzda','nZaklSocPo','nZaklZdrPo','nDnyFondKD','nDnyFondPD',     ;
                         'nDnyDovol','nHodFondKD','nHodFondPD','nDnyDovol','nHodFondKD','nHodFondPD', ;
                         'nHodPresc','nHodPrescS','nHodPripl'  },{ || cdenik = 'MH'},,,,,.f.))

  drgServiceThread:progressEnd()


  drgDBMS:open('mzddavitw',.t.,.t.,drgINI:dir_USERfitm,,,.t.)
//    dbUseArea(.t.,,ctmpdav)
  drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy - generuji MZDDAVHD'), mzddavitw->( LastRec()))
  mzddavitw->( dbGoTop())

  do while .not. mzddavitw->(Eof())
//    copyfldto_w( 'mzddavitw', 'mzddavhd', .T., astruct)

    mzddavhd->( dbAppend())

    mzddavhd->ctask      := mzddavitw->ctask
    mzddavhd->cUloha     := mzddavitw->cUloha
    mzddavhd->cDenik     := mzddavitw->cDenik
    mzddavhd->nRok       := mzddavitw->nRok
    mzddavhd->nObdobi    := mzddavitw->nObdobi
    mzddavhd->cObdobi    := mzddavitw->cObdobi
    mzddavhd->nRokObd    := mzddavitw->nRokObd
    mzddavhd->CTYPDOKLAD := mzddavitw->CTYPDOKLAD
    mzddavhd->CTYPPOHYBU := mzddavitw->CTYPPOHYBU
    mzddavhd->nDoklad    := mzddavitw->nDoklad
    mzddavhd->dDatPoriz  := mzddavitw->dDatPoriz
    mzddavhd->cKmenStrSt := mzddavitw->cKmenStrSt
    mzddavhd->cKmenStrPr := mzddavitw->cKmenStrPr
    mzddavhd->nOsCisPrac := mzddavitw->nOsCisPrac
    mzddavhd->cPracovnik := mzddavitw->cPracovnik
    mzddavhd->cJmenoRozl := mzddavitw->cJmenoRozl
    mzddavhd->nPorPraVzt := mzddavitw->nPorPraVzt
    mzddavhd->nTypPraVzt := mzddavitw->nTypPraVzt
    mzddavhd->nTypZamVzt := mzddavitw->nTypZamVzt
    mzddavhd->nClenSpol  := mzddavitw->nClenSpol
    mzddavhd->cMzdKatPra := mzddavitw->cMzdKatPra
    mzddavhd->cPracZar   := mzddavitw->cPracZar
    mzddavhd->cPracZarDo := mzddavitw->cPracZarDo
    mzddavhd->nExtFaktur := mzddavitw->nExtFaktur
    mzddavhd->nHrubaMZD  := mzddavitw->nHrubaMZD
    mzddavhd->nMzda      := mzddavitw->nMzda
    mzddavhd->nZaklSocPo := mzddavitw->nZaklSocPo
    mzddavhd->nZaklZdrPo := mzddavitw->nZaklZdrPo
    mzddavhd->nDnyFondKD := mzddavitw->nDnyFondKD
    mzddavhd->nDnyFondPD := mzddavitw->nDnyFondPD
    mzddavhd->nDnyDovol  := mzddavitw->nDnyDovol
    mzddavhd->nHodFondKD := mzddavitw->nHodFondKD
    mzddavhd->nHodFondPD := mzddavitw->nHodFondPD
    mzddavhd->nHodPresc  := mzddavitw->nHodPresc
    mzddavhd->nHodPrescS := mzddavitw->nHodPrescS
    mzddavhd->nHodPripl  := mzddavitw->nHodPripl
    mzddavhd->nPoradi    := mzddavitw->nPoradi
    mzddavhd->dDatumOD   := mzddavitw->dDatumOD
    mzddavhd->dDatumDO   := mzddavitw->dDatumDO
//    mzddavhd->nVykazN_Ho := mzddavitw->nVykazN_Ho
//    mzddavhd->nVykazN_KD := mzddavitw->nVykazN_KD
//    mzddavhd->nVykazN_PD := mzddavitw->nVykazN_PD
//    mzddavhd->nVykazN_VD := mzddavitw->nVykazN_VD
//    mzddavhd->nNemocCelk := mzddavitw->nNemocCelk
//    mzddavhd->cStavOtevN := mzddavitw->cStavOtevN
//    mzddavhd->nDVZNemoc  := mzddavitw->nDVZNemoc
//    mzddavhd->nDnyNizSaz := mzddavitw->nDnyNizSaz
//    mzddavhd->nDnyKraSaz := mzddavitw->nDnyKraSaz
//    mzddavhd->nDenVZhruN := mzddavitw->nDenVZhruN
//    mzddavhd->nDenVZcisN := mzddavitw->nDenVZcisN
//    mzddavhd->nDenVZciKN := mzddavitw->nDenVZciKN
//    mzddavhd->nSazDenNiN := mzddavitw->nSazDenNiN
//    mzddavhd->nSazDenVyN := mzddavitw->nSazDenVyN
//    mzddavhd->nSazDenVKN := mzddavitw->nSazDenVKN
    mzddavhd->cTmKmStrPr := mzddavitw->cTmKmStrPr
//    mzddavhd->nTmPorSort := mzddavitw->nTmPorSort
//    mzddavhd->nTmRokZpra := mzddavitw->nTmRokZpra
//    mzddavhd->nDnyVylocD := mzddavitw->nDnyVylocD
//    mzddavhd->nDnyVylDOD := mzddavitw->nDnyVylDOD
    mzddavhd->nZdrPojis  := mzddavitw->nZdrPojis
    mzddavhd->lRucPoriz  := mzddavitw->lRucPoriz
    mzddavhd->nKLikvid   := mzddavitw->nKLikvid
    mzddavhd->nZLikvid   := mzddavitw->nZLikvid
    mzddavhd->cRoObCpPPv := mzddavitw->cRoObCpPPv
    mzddavhd->cRoCpPPv   := mzddavitw->cRoCpPPv

    if mzddavhd->ndoklad >=600000 .and. mzddavhd->ndoklad <=699999
      mzddavhd->lAutoVypHM := .not. mzddavitw->lRucPoriz
    endif

    ncommit++
    if ncommit =150
      mzddavhd->( dbCommit())
      ncommit := 0
    endif
    mzddavitw->( dbSkip())
    drgServiceThread:progressInc()
  enddo


/*

  do while .not. new->( Eof())
    lAdd := .t.

    if lgen
      lAdd := .f.

      copyfldto_w( 'new', 'mzddavhd', .T., astruct)

///      mh_COPYFLD('new', 'mzddavhd', .T.)
      lgen := .f.
    endif

    if lAdd
      mzddavhd->nHrubaMZD  += new->nHrubaMZD
      mzddavhd->nMzda      += new->nMzda
      mzddavhd->nZaklSocPo += new->nZaklSocPo
      mzddavhd->nZaklZdrPo += new->nZaklZdrPo
      mzddavhd->nDnyFondKD += new->nDnyFondKD
      mzddavhd->nDnyFondPD += new->nDnyFondPD
      mzddavhd->nDnyDovol  += new->nDnyDovol
      mzddavhd->nHodFondKD += new->nHodFondKD
      mzddavhd->nHodFondPD += new->nHodFondPD
      mzddavhd->nHodPresc  += new->nHodPresc
      mzddavhd->nHodPrescS += new->nHodPrescS
      mzddavhd->nHodPripl  += new->nHodPripl
//    mzddavhd->nKLikvid   += old->nKLikvid
//    mzddavhd->nZLikvid   += old->nZLikvid
    endif
    ncommit++
    if ncommit =50
      mzddavhd->( dbCommit())
      ncommit := 0
    endif

    drgServiceThread:progressInc()
    new->( dbSkip())

    if key = StrZero(new->nrok,4)+StrZero(new->nobdobi,2)+StrZero(new->noscisprac,5)+StrZero(new->nporpravzt,3)+StrZero(new->ndoklad,10)

    else
      lgen := .t.
      key  := StrZero(new->nrok,4)+StrZero(new->nobdobi,2)+StrZero(new->noscisprac,5)+StrZero(new->nporpravzt,3)+StrZero(new->ndoklad,10)
    endif

  enddo
*/

  mzddavitw->( dbCloseArea())
  mzddavhd->( dbCloseArea())
  new->( dbCloseArea())
  old->( dbCloseArea())
  drgServiceThread:progressEnd()

RETURN NIL


FUNCTION GenMsrzHD()
  local lgen := .t.
  local key, astruct
  local ncommit := 0


  drgDBMS:open('mzddavit',.t.,,,,'new')
  drgDBMS:open('m_srz',.t.)
  astruct := m_srz->( dbstruct())
  ncommit := 0


  drgServiceThread:progressStart( drgNLS:msg('Pøevádím srážky - generuji MZDDAVIT'), m_srz->( LastRec()))

//  dbselectarea('old')
//  dbCreateIndex( drgINI:dir_USERfitm+'old','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10)';
//                   , {|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10) })

  m_srz->( dbGoTop())

  do while .not. m_srz->( Eof())
    copyfldto_w( 'm_srz', 'new', .T., astruct )

///    mh_COPYFLD('m_srz', 'new', .T.)
    New->cTask := 'MZD'
    New->cUloha := 'M'
    New->cDenik := 'MS'
    New->cTypDoklad := 'MZD_SRAZKY'
    New->cTypPohybu := 'SRAZKA'
    New->nRokObd := (m_srz->nRok*100)+m_srz->nObdobi

    drgServiceThread:progressInc()

     ncommit++
     if ncommit =50
       new->( dbCommit())
       ncommit := 0
     endif

    m_srz->( dbSkip())
  enddo

  drgServiceThread:progressEnd()

  drgServiceThread:progressStart( drgNLS:msg('Pøevádím srážky ze mzdy - generuji MZDDAVHD'), Old->( LastRec()))

//  dbselectarea('m_srz')
//  dbCreateIndex( drgINI:dir_USERfitm+'m_srz','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10)';
//                   ,{|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10) })

  m_srz->( OrdSetFocus('M_SRZ_01'))
  drgDBMS:open('mzddavhd',.t.)
  m_srz->( dbGoTop())
  key := StrZero(m_srz->nrok,4)+StrZero(m_srz->nobdobi,2)+StrZero(m_srz->noscisprac,5)+StrZero(m_srz->nporpravzt,3)+StrZero(m_srz->ndoklad,10)

  do while .not. m_srz->( Eof())
    if lgen
      copyfldto_w( 'm_srz', 'mzddavhd', .T., astruct )

///      mh_CopyFLD('m_srz', 'mzddavhd', .t.)
      mzddavhd->nRokObd    := (m_srz->nRok*100)+m_srz->nObdobi
      mzddavhd->cTask      := 'MZD'
      mzddavhd->cDenik     := 'MS'
      mzddavhd->cTypDoklad := 'MZD_SRAZKY'
      mzddavhd->cTypPohybu := 'SRAZKA'
      mzddavhd->nDoklad    := m_srz->ndoklad
      lgen := .f.
    endif

*    mzddavhd->nHrubaMZD  += old->nHrubaMZD
*    mzddavhd->nMzda      += old->nMzda
*    mzddavhd->nZaklSocPo += old->nZaklSocPo
*    mzddavhd->nZaklZdrPo += old->nZaklZdrPo
*    mzddavhd->nDnyFondKD += old->nDnyFondKD
*    mzddavhd->nDnyFondPD += old->nDnyFondPD
*    mzddavhd->nDnyDovol  += old->nDnyDovol
*    mzddavhd->nHodFondKD += old->nHodFondKD
*    mzddavhd->nHodFondPD += old->nHodFondPD
*    mzddavhd->nHodPresc  += old->nHodPresc
*    mzddavhd->nHodPrescS += old->nHodPrescS
*    mzddavhd->nHodPripl  += old->nHodPripl
//    mzddavhd->nKLikvid   += old->nKLikvid
//    mzddavhd->nZLikvid   += old->nZLikvid

    ncommit++
    if ncommit =50
      mzddavhd->( dbCommit())
      ncommit := 0
    endif

    drgServiceThread:progressInc()
    m_srz->( dbSkip())

    if key = StrZero(m_srz->nrok,4)+StrZero(m_srz->nobdobi,2)+StrZero(m_srz->noscisprac,5)+StrZero(m_srz->nporpravzt,3)+StrZero(m_srz->ndoklad,10)

    else
      lgen := .t.
      key  := StrZero(m_srz->nrok,4)+StrZero(m_srz->nobdobi,2)+StrZero(m_srz->noscisprac,5)+StrZero(m_srz->nporpravzt,3)+StrZero(m_srz->ndoklad,10)
    endif
  enddo

  drgServiceThread:progressEnd()

  m_srz->( dbCloseArea())
  mzddavhd->( dbCloseArea())

RETURN NIL


function GenMnemHD()
  local lgen := .t.
  local key, cfiltr
  local ncommit := 0
  local ccc


  drgDBMS:open('mzdyit',.t.)
  drgDBMS:open('m_nem',.t.)
  drgDBMS:open('mzddavhd',.t.)
  drgDBMS:open('mzddavit',.t.,,,,'new')
  ncommit := 0

  mzddavhd ->(dbZap())
  new ->( dbZap())

  drgServiceThread:progressStart( drgNLS:msg('Pøevádím nemocenky - generuji MZDDAVIT'), m_nem->( LastRec()))

//  dbselectarea('old')
//  dbCreateIndex( drgINI:dir_USERfitm+'old','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10)';
//                   , {|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10) })

  m_nem->( dbGoTop())

  do while .not. m_nem->( Eof())
    if m_nem->ndmznenisa <> 0
      copyfldto_w( 'm_nem', 'new', .T.)

///      mh_COPYFLD('m_nem', 'new', .T.)

      new->cTask      := 'MZD'
      new->cDenik     := 'MN'
      new->cTypDoklad := 'MZD_NEMOC'
      new->cTypPohybu := UpravNemPo()

      new->nRok       := m_nem->nRok
      new->nObdobi    := m_nem->nobdobi
      new->cObdobi    := m_nem->cobdobi
      new->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      new->nDoklad    := m_nem->nDoklad

      new->dvykazn_od := m_nem->dproplnsod
      new->dvykazn_do := m_nem->dproplnsdo
      new->nvykazn_ho := m_nem->nproplnsho
      new->nvykazn_kd := m_nem->nproplnskd
      new->nvykazn_pd := m_nem->nproplnspd
      new->nvykazn_vd := m_nem->nproplnsvd

      new->dpropln_od := m_nem->dproplnsod
      new->dpropln_do := m_nem->dproplnsdo
      new->npropln_ho := m_nem->nproplnsho
      new->npropln_kd := m_nem->nproplnskd
      new->npropln_pd := m_nem->nproplnspd
      new->npropln_vd := m_nem->nproplnsvd
      new->nsazdennem := m_nem->nsazdennin
      new->nnemoccelk := m_nem->nnemocnisa
      new->ndruhmzdy  := m_nem->ndmznenisa

      new->dDatumOD := new->dvykazn_od
      new->dDatumDO := new->dvykazn_do
      new->nsazbadokl := new->nsazdennem
      new->nmzda      := new->nnemoccelk

      new->nhodfondpd := 0

    endif

    if m_nem->ndmznevksa <> 0
      copyfldto_w( 'm_nem', 'new', .T.)

///      mh_COPYFLD('m_nem', 'new', .T.)

      new->cTask      := 'MZD'
      new->cDenik     := 'MN'
      new->cTypDoklad := 'MZD_NEMOC'
      new->cTypPohybu := UpravNemPo()

      new->nRok       := m_nem->nRok
      new->nObdobi    := m_nem->nobdobi
      new->cObdobi    := m_nem->cobdobi
      new->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      new->nDoklad    := m_nem->nDoklad

      new->dvykazn_od := m_nem->dproplvkod
      new->dvykazn_do := m_nem->dproplvkdo
      new->nvykazn_kd := m_nem->nproplvkkd
      new->nvykazn_pd := m_nem->nproplvkpd
      new->nvykazn_vd := m_nem->nproplvkvd

      new->dpropln_od := m_nem->dproplvkod
      new->dpropln_do := m_nem->dproplvkdo
      new->npropln_kd := m_nem->nproplvkkd
      new->npropln_pd := m_nem->nproplvkpd
      new->npropln_vd := m_nem->nproplvkvd
      new->nsazdennem := m_nem->nsazdenvkn
      new->nnemoccelk := m_nem->nnemocvksa
      new->ndruhmzdy  := m_nem->ndmznevksa

      new->dDatumOD := new->dvykazn_od
      new->dDatumDO := new->dvykazn_do
      new->nsazbadokl := new->nsazdennem
      new->nmzda      := new->nnemoccelk

      new->nhodfondpd := 0
    endif

    if m_nem->ndmznevysa <> 0
      copyfldto_w( 'm_nem', 'new', .T.)

///      mh_COPYFLD('m_nem', 'new', .T.)

      new->cTask      := 'MZD'
      new->cDenik     := 'MN'
      new->cTypDoklad := 'MZD_NEMOC'
      new->cTypPohybu := UpravNemPo()

      new->nRok       := m_nem->nRok
      new->nObdobi    := m_nem->nobdobi
      new->cObdobi    := m_nem->cobdobi
      new->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      new->nDoklad    := m_nem->nDoklad
///      mh_COPYFLD('m_nem', 'new', .T.)

      new->dvykazn_od := m_nem->dproplvsod
      new->dvykazn_do := m_nem->dproplvsdo
      new->nvykazn_kd := m_nem->nproplvskd
      new->nvykazn_pd := m_nem->nproplvspd
      new->nvykazn_vd := m_nem->nproplvsvd

      new->dpropln_od := m_nem->dproplvsod
      new->dpropln_do := m_nem->dproplvsdo
      new->npropln_kd := m_nem->nproplvskd
      new->npropln_pd := m_nem->nproplvspd
      new->npropln_vd := m_nem->nproplvsvd
      new->nsazdennem := m_nem->nsazdenvyn
      new->nnemoccelk := m_nem->nnemocvysa
      new->ndruhmzdy  := m_nem->ndmznevysa

      new->dDatumOD := new->dvykazn_od
      new->dDatumDO := new->dvykazn_do
      new->nsazbadokl := new->nsazdennem
      new->nmzda      := new->nnemoccelk

      new->nhodfondpd := 0
    endif

    if m_nem->ndmznevvsa <> 0
      copyfldto_w( 'm_nem', 'new', .T.)

///      mh_COPYFLD('m_nem', 'new', .T.)

      new->cTask      := 'MZD'
      new->cDenik     := 'MN'
      new->cTypDoklad := 'MZD_NEMOC'
      new->cTypPohybu := UpravNemPo()

      new->nRok       := m_nem->nRok
      new->nObdobi    := m_nem->nobdobi
      new->cObdobi    := m_nem->cobdobi
      new->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      new->nDoklad    := m_nem->nDoklad
///      mh_COPYFLD('m_nem', 'new', .T.)

      new->dvykazn_od := m_nem->dproplvvod
      new->dvykazn_do := m_nem->dproplvvdo
      new->nvykazn_kd := m_nem->nproplvvkd
      new->nvykazn_pd := m_nem->nproplvvpd
      new->nvykazn_vd := m_nem->nproplvvvd

      new->dpropln_od := m_nem->dproplvvod
      new->dpropln_do := m_nem->dproplvvdo
      new->npropln_kd := m_nem->nproplvvkd
      new->npropln_pd := m_nem->nproplvvpd
      new->npropln_vd := m_nem->nproplvvvd
      new->nsazdennem := m_nem->nsazdenvvn
      new->nnemoccelk := m_nem->nnemocvvsa
      new->ndruhmzdy  := m_nem->ndmznevvsa

      new->dDatumOD := new->dvykazn_od
      new->dDatumDO := new->dvykazn_do
      new->nsazbadokl := new->nsazdennem
      new->nmzda      := new->nnemoccelk

      new->nhodfondpd := 0
    endif


    if m_nem->ndmznevnsa <> 0
      copyfldto_w( 'm_nem', 'new', .T.)

///      mh_COPYFLD('m_nem', 'new', .T.)

      new->cTask      := 'MZD'
      new->cDenik     := 'MN'
      new->cTypDoklad := 'MZD_NEMOC'
      new->cTypPohybu := UpravNemPo()

      new->nRok       := m_nem->nRok
      new->nObdobi    := m_nem->nobdobi
      new->cObdobi    := m_nem->cobdobi
      new->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      new->nDoklad    := m_nem->nDoklad
///      mh_COPYFLD('m_nem', 'new', .T.)

      new->dvykazn_od := m_nem->dproplvnod
      new->dvykazn_do := m_nem->dproplvndo
      new->nvykazn_kd := m_nem->nproplvnkd
      new->nvykazn_pd := m_nem->nproplvnpd
      new->nvykazn_vd := m_nem->nproplvnvd

      new->dpropln_od := m_nem->dproplvnod
      new->dpropln_do := m_nem->dproplvndo
      new->npropln_kd := m_nem->nproplvnkd
      new->npropln_pd := m_nem->nproplvnpd
      new->npropln_vd := m_nem->nproplvnvd
      new->nsazdennem := m_nem->nsazdenvnn
      new->nnemoccelk := m_nem->nnemocvnsa
      new->ndruhmzdy  := m_nem->ndmznevnsa

      new->dDatumOD := new->dvykazn_od
      new->dDatumDO := new->dvykazn_do
      new->nsazbadokl := new->nsazdennem
      new->nmzda      := new->nnemoccelk

      new->nhodfondpd := 0
    endif


//    if mzdyit->ndruhmzdy > 0

      ccc := StrZero(nRok,4)+StrZero(nObdobi,2)+StrZero(nOsCisPrac,5)+StrZero(nPorPraVzt,3)

      cfiltr := Format("croobcpppv = '%%'.and.cdenik = '%%'.and.ndruhmzdy < %%", ;
                        {ccc, 'MN', 400})
//      cfiltr := Format("croobcpppv = %% .and. nobdobi = %% .and. noscisprac = %% .and. nporpravzt = %% .and. cdenik = '%%'",   ;
//                        {nrok,nobdobi,noscisprac,nporpravzt,'MN'})

//      cfiltr := Format("nporadi = %% .and. noscisprac = %% .and. nporpravzt = %% .and. ndruhmzdy < %%",   ;
//                        {nporadi,noscisprac,nporpravzt,400})


      mzdyit->( ads_setaof(cfiltr), dbGoTop())

  //    mzdyit->( Ads_SetAOF( "nporadi = m_nem->nporadi .and. noscisprac = m_nem->noscisprac .and. nporpravzt = m_nem->nporpravzt .and. ndruhmzdy < 400" ))
//      mzdyit->( dbGoTop())

       if mzdyit->ndruhmzdy <> 0
         do while .not. mzdyit->( Eof())
//         if mzdyit->ndruhmzdy < 400 .and. mzdyit->cdenik = "MH"
           copyfldto_w( 'mzdyit', 'new', .T.)
           mzdyit->( dbSkip())
//         endif
         enddo
       endif
      mzdyit->( ads_clearaof())



//     endif
     drgServiceThread:progressInc()

     ncommit++
     if ncommit =50
       new->( dbCommit())
       ncommit := 0
     endif

    m_nem->( dbSkip())
  enddo

  drgServiceThread:progressEnd()



//  dbse lectarea('old')
//  dbCreateIndex( drgINI:dir_USERfitm+'old','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10)';
//                   , {|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10) })

  drgDBMS:open('m_nemoc',.t.)

  ncommit := 0

  drgServiceThread:progressStart( drgNLS:msg('Pøevádím nemocenky - generuji MZDDAVHD'), m_nemoc->( LastRec()))
  m_nemoc->( dbGoTop())
//  key := StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+Str Zero(old->noscisprac,5)+StrZero(old->ndoklad,10)

  do while .not. m_nemoc->( Eof())

//    m_nem->( dbSetFilter( {|| nporadi = m_nemoc->nporadi .and. noscisprac = m_nemoc->noscisprac .and. nporpravzt = m_nemoc->nporpravzt},  ;
//                             'nporadi = m_nemoc->nporadi .and. noscisprac = m_nemoc->noscisprac .and. nporpravzt = m_nemoc->nporpravzt'))
//    m_nem->(dbGoTop())


    cfiltr := Format("nPoradi = %% .and. noscisprac = %% .and. nporpravzt = %%", {m_nemoc->nporadi,m_nemoc->noscisprac,m_nemoc->nporpravzt})
    m_nem->( ads_setaof(cfiltr), dbGoTop())

    do while .not. m_nem->( Eof())
      copyfldto_w( 'm_nemoc', 'mzddavhd', .T. )

///      mh_COPYFLD('m_nemoc', 'mzddavhd', .T.)
      mzddavhd->cTask      := 'MZD'
      mzddavhd->cDenik     := 'MN'
      mzddavhd->cTypDoklad := 'MZD_NEMOC'
      mzddavhd->cTypPohybu := 'NEMOC'

      mzddavhd->nRok       := m_nem->nRok
      mzddavhd->nObdobi    := m_nem->nobdobi
      mzddavhd->cObdobi    := m_nem->cobdobi
      mzddavhd->nRokObd    := (m_nem->nRok*100)+m_nem->nObdobi
      mzddavhd->nDoklad    := m_nem->nDoklad

      m_nem->(dbSkip())
    enddo

    m_nem->( dbClearFilter())

     ncommit++
     if ncommit =50
       mzddavhd->( dbCommit())
       ncommit := 0
     endif

    drgServiceThread:progressInc()
    m_nemoc->( dbSkip())

//    if key = StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+StrZero(old->noscisprac,5)+StrZero(old->ndoklad,10)

//    else
//      lgen := .t.
//      key  := StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+StrZero(old->noscisprac,5)+StrZero(old->ndoklad,10)
//    endif
  enddo

  m_nem->( dbCloseArea())
  m_nemoc->( dbCloseArea())
  mzddavhd->( dbCloseArea())
  mzdyit->( dbCloseArea())
  drgServiceThread:progressEnd()

RETURN NIL


function UpravDMZ()

  do case
  case new->ndruhmzdy <= 399
    new->ctypdoklad := "MZD_PRIJEM"
  case new->ndruhmzdy <= 499
    new->ctypdoklad := "MZD_NEMOC"
  case new->ndruhmzdy <= 599
    new->ctypdoklad := "MZD_SRAZKA"
  case new->ndruhmzdy <= 999
    new->ctypdoklad := "MZD_GENER"
  endcase

return nil


function UpravDMZpo()

  do case
  case ( new->ndruhmzdy >= 400 .and. new->ndruhmzdy <= 409) .or.    ;
          new->ndruhmzdy = 430 .or.new->ndruhmzdy = 431 .or.        ;
           new->ndruhmzdy = 434 .or.new->ndruhmzdy = 436
    new->ctyppohybu := "NEMOC"
  case new->ndruhmzdy >= 410 .and. new->ndruhmzdy <= 413
    new->ctyppohybu := "NEMOC_PU"
  case ( new->ndruhmzdy >= 417 .and. new->ndruhmzdy <= 420) .or. ;
          new->ndruhmzdy = 432 .or.new->ndruhmzdy = 433 .or.     ;
           new->ndruhmzdy = 435 .or.new->ndruhmzdy = 437
    new->ctyppohybu := "NEMOC_MPU"
  case new->ndruhmzdy >= 414 .and. new->ndruhmzdy <= 416
    new->ctyppohybu := "NEMOCR"
  case new->ndruhmzdy >= 421 .and. new->ndruhmzdy <= 421
    new->ctyppohybu := "NEMPPM"
  case new->ndruhmzdy >= 425 .and. new->ndruhmzdy <= 425
    new->ctyppohybu := "NEMVPTM"
  case new->ndruhmzdy >= 426 .and. new->ndruhmzdy <= 426
    new->ctyppohybu := "RODDOV"
  case new->ndruhmzdy >= 428 .and. new->ndruhmzdy <= 428
    new->ctyppohybu := "NEMOC_NEP"
  endcase

return nil



function UpravNemPo()
  local cret

  do case
  case m_nem->ndruhmzdy = 400
    cret := "NEMOC"
  case m_nem->ndruhmzdy = 410
    cret := "NEMOC_PU"
  case m_nem->ndruhmzdy = 419
    cret := "NEMOC_MPU"
  case m_nem->ndruhmzdy = 421
    cret := "NEMPPM"
  case m_nem->ndruhmzdy = 415
    cret := "NEMOCR"
  case m_nem->ndruhmzdy = 425
    cret := "NEMVPTM"
  endcase

return cret



Function GenerDMZob()
  local n, r, rr
  local ncommit

  new->( dbCloseArea())

  drgDBMS:open('druhymzd',,,,,'new')
  drgDBMS:open('druhymzd',,,,,'druhymzda')
  ncommit := 0

  del_c_TypPoh('M')

  new->(dbGoTop())
  new->(ads_setaof( format("nrokobd = %%",{new->nRokObd})),dbgotop())

  do while .not. new->(eof())
      for n := 2 to 12
        mh_COPYFLD('new', 'druhymzda', .T.)
        druhymzda->nrok    := 2012
        druhymzda->nobdobi := n
        druhymzda->cobdobi := StrZero(n,2) + '/12'
        druhymzda->nrokobd := (druhymzda->nrok *100) + n
        ncommit++
        if ncommit = 50
          druhymzda->( dbUnlock())
          druhymzda->( dbCommit())
          ncommit := 0
        endif
      next

/*
    for n := 1 to new->nObdobi-1
      mh_COPYFLD('new', 'druhymzda', .T.)
      druhymzda->nobdobi := n
      druhymzda->cobdobi := StrZero(n,2) +SubStr(new->cobdobi,3)
      druhymzda->nrokobd := (new->nrok *100) + n
      ncommit++
      if ncommit = 50
        druhymzda->( dbUnlock())
        druhymzda->( dbCommit())
        ncommit := 0
      endif
    next
*/
    ncommit++
    if ncommit = 50
      druhymzda->( dbUnlock())
      druhymzda->( dbCommit())
      ncommit := 0
    endif

    new->( dbSkip())
  enddo

  new->(ads_clearaof(),dbgotop())


return nil


STATIC FUNCTION AktStav(cTEXT)
  prevodmz->mProtokol += cTEXT +Chr(13) +Chr(10)
RETURN(NIL)



static function copyfldto_w(from_db,to_db,app_db, afrom)
**  local npos, xval, afrom := (from_db)->(dbstruct()), x
  local npos, xval, x

  default afrom to (from_db)->(dbstruct())

  if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
  for x := 1 to len(afrom) step 1
    if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec,nfaktm_org')
      xval := (from_db)->(fieldget(x))
      npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

      if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
    endif
  next
return nil

// doplní do osob z rodinných pøíslušníkù
FUNCTION DoOsobZRP()
  LOCAL lOK
  LOCAL nCis := 0
  LOCAL cTyp,cAdr,cNaz
  LOCAL nPor := 1


  do case
  case old->crodcisrp = '--/'
    mh_COPYFLD('Old', 'OSOBY', .T.)
    OSOBY->nOsCisPrac := 0
    OSOBY->nCISOSOBY  := OSOBY->(Recno())
    New->nCISOSOBY    := OSOBY->nCISOSOBY
    OSOBY->cPrijOsob  := Old->cPriJmenRP
    OSOBY->cJmenoOsob := Old->cJmenoRP
    OSOBY->cOsoba     := Old->cRodPrisl
    OSOBY->nis_RPR    := 1
    mh_COPYFLD('Osoby', 'OsobySk', .T.)
    OsobySk->cZkr_Skup := 'RPR'

  case .not. Osoby->(dbSeek(Upper(old->crodcisrp),,'Osoby08'))
    mh_COPYFLD('Old', 'OSOBY', .T.)
    OSOBY->nOsCisPrac := 0
    OSOBY->nCISOSOBY  := OSOBY->(Recno())
    New->nCISOSOBY    := OSOBY->nCISOSOBY
    OSOBY->cPrijOsob  := Old->cPriJmenRP
    OSOBY->cJmenoOsob := Old->cJmenoRP
    OSOBY->cOsoba     := Old->cRodPrisl
    OSOBY->cRodCisOsb := Old->cRodCisRP
    OSOBY->nis_RPR    := 1
    mh_COPYFLD('Osoby', 'OsobySk', .T.)
    OsobySk->cZkr_Skup := 'RPR'
  endcase

   vazosoby->(dbAppend())
   new->nCisOsobRP  := Osoby->nCisOsoby
//   new->nOsCisPrRP  := Osoby->nOsCisPrac
   vazosoby->nOSOBY := isNull( Osoby->sID, 0)
   Osoby->nis_RPR   := 1

   if msprc_mo->(dbSeek(old->noscisprac,,'MSPRMO09'))
     if osoby->(dbSeek(msprc_mo->ncisosoby,,'Osoby01'))
       new->nCisOsoby  := Osoby->nCisOsoby
       vazosoby->OSOBY := isNull( Osoby->sID, 0)
       vazosoby->nitem := new->nrodprisl
     endif
   endif

   do case
   case new->ctyprodpri = 'DITE' .and. old->nmuz  = 1
      vazosoby->ctyprodpri  := 'syn'
   case new->ctyprodpri = 'DITE' .and. old->nzena = 1
      vazosoby->ctyprodpri  := 'dcera'
   case new->ctyprodpri = 'MANZ' .and. old->nmuz = 1
      vazosoby->ctyprodpri  := 'manzel'
   case new->ctyprodpri = 'MANZ' .and. old->nzena = 1
      vazosoby->ctyprodpri  := 'manzelka'
   endcase

   if new->ctyprodpri = 'DITE' .or. new->ctyprodpri = 'MANZ'
     if msodppol->( dbSeek(Upper(Old->cRodCisRP)+StrZero(2012),,'MSODPP05'))
       msodppol->ncisosorp  := new->nCisOsobRP
       msodppol->nvazosoby  := isNull( vazosoby->sid, 0)
       vazosoby->lsleodpdan := msodppol->laktiv
     endif
     if msodppol->( dbSeek(Upper(Old->cRodCisRP)+StrZero(2013),,'MSODPP05'))
       msodppol->ncisosorp  := new->nCisOsobRP
       msodppol->nvazosoby  := isNull( vazosoby->sid, 0)
       vazosoby->lsleodpdan := msodppol->laktiv
     endif
   endif

RETURN(NIL)

// doplní do osob z rodinných pøíslušníkù
FUNCTION DoplnVzdel()
  LOCAL lOK
  LOCAL nCis := 0
  LOCAL cTyp,cAdr,cNaz
  LOCAL nPor := 1

//  drgDBMS:open('Osoby')

  Osoby->( dbGoTop())
  do while .not. Osoby->( Eof())
    if .not. Empty( Osoby->czkrvzdel)
      New->(dbAppend())

      New->nCISOSOBY  := OSOBY->nCISOSOBY
      New->nOsCisPrac := OSOBY->nOsCisPrac
      New->cRodCisPra := OSOBY->cRodCisOsb
      New->cZkrVzdel  := OSOBY->cZkrVzdel
      New->nPoradi    := 1
      New->nOSOBY     := isNull( OSOBY->sID, 0)
    endif
    Osoby->(dbSkip())
  enddo

RETURN(NIL)

FUNCTION IndexPrSml()
  local area

  area := Alias()
  dbSelectArea('old')
  index on strzero(noscisprac,5)+StrZero(nPorPraVzt,3) to indexold DESCENDING UNIQUE
  dbSelectArea(area)

RETURN(nil)