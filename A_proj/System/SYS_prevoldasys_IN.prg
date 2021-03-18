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


** CLASS for MZD_prevoldmzd_in ************** *************************************
CLASS SYS_prevoldasys_IN FROM drgUsrClass
EXPORTED:
  VAR     aitw


  METHOD  init, drgDialogStart, itemMarked, preValidate, postValidate
   *
  method  ebro_saveEditRow
  method  prevoldAsys
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


METHOD SYS_prevoldasys_IN:init(parent)
  local cparm

  ::drgUsrClass:init(parent)

   cParm    := drgParseSecond(::drgDialog:initParam)

  ::prevFile := ''
  ::lnewrec  := .F.
  ::key    := cParm

  drgDBMS:open('prevdat')
  prevdat->(OrdSetFocus('PREVDAT04'))

//  ASYSACT->(DbSetRelation( 'ASYSTEM',{|| ASYSACT->cIDobject },'ASYSACT->cIDobject','ASYSTEM04'))

RETURN self



METHOD SYS_prevoldasys_IN:drgDialogStart(drgDialog)
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

*  drgDBMS:open('firmy',.t.)

  ::dctrl:oBrowse[1]:refresh(.t.)
RETURN self



METHOD SYS_prevoldasys_IN:itemMarked()
  LOCAL  buffer

  if ::dctrl:oaBrowse = ::dctrl:oBrowse[1]

  end
RETURN NIL


METHOD SYS_prevoldasys_IN:preValidate(drgVar)
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


METHOD SYS_prevoldasys_IN:postValidate(drgVar)
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
** pøevod mezd z pùvodního systému ***************************************
METHOD SYS_prevoldasys_IN:PrevOldAsys(parent)
  LOCAL oDialog, nExit
  local old, new

  LOCAL i,j,k,l,m,n
  LOCAL cProtokol
  LOCAL aStruNEW, aDesc
  LOCAL aStruOLD
  LOCAL values
  LOCAL lOK
  local ncommit
  LOCAL lPreved
  LOCAL cName, nPos
  LOCAL cFile, cX
  LOCAL lPREV
  LOCAL nTyp

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
      prevdat->( dbGoTop())
      do while .not. prevdat->( eof())
        PrevDat->( dbRlock())
        PrevDat->cKonPrev := ''
        PrevDat->( dbUnlock())
        PrevDat->( dbSkip())
      enddo
      nTyp := 0
    else
      nTyp := 1
    endif

    prevdat->( dbGoTop())
    do while .not. prevdat->( eof())
      PrevDat->( dbRlock())
      if nTyp == 0
        lPREV := (PrevDat->nTypPrevod == 0)
      else
        lPREV := (PrevDat->nTypPrevod == 0 .and. Empty( PrevDat->cKonPrev))
      endif

      cFile   := PrevDat->cNewFile
      lOK     := .T.
      lPreved := .T.

      if lPREV
        PrevDat->nStavPrev := 0
        PrevDat->mProtokol := ''
        PrevDat->cZacPrev  := DtoC( Date()) +"  "+ Time()

        if !File( AllTrim(cPath) +AllTrim(PrevDat->cOldPath) +AllTrim(PrevDat->cOldFile) +'.dbf')
          AktStav('Chybí starý soubor !!!')
          PrevDat->nStavPrev := 11
          lOK := .F.
        endif

        if .not. IsObject(odbd := drgDBMS:dbd:getByKey(AllTrim(PrevDat->cNewFile)))
          AktStav('Chybí nová tabulka !!!')
          PrevDat->nStavPrev := 12
          lOK := .F.
        endif

        if lOK
          drgNLS:msg('Pøipravuji pro pøevod soubor - ' + AllTrim(PREVDAT->cOldFile))
          cX := AllTrim(cPath) +AllTrim(PrevDat->cOldPath) +AllTrim(PrevDat->cOldFile)
          FErase( cX +'.cdx')
          dbUseArea( .T.,'FOXCDX',cX,'Old',.F.)

          drgDBMS:open(AllTrim(prevdat->cnewfile),.t.,,,,'New')

//          dbUseArea( .T.,oSession,AllTrim(::cNewADR) +AllTrim(PrevDat->cNewFile),'New',.F.)

          New->( dbZAP())
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
                PrevDat->nStavPrev := 20
                lPreved := .F.
              ELSE
                IF aStruNEW[i,3] <> aStruOLD[n,3]
                  AktStav('Pozor neodpovídá délka promìnných NEW: '+ Str(aStruNEW[i,3],6)+'OLD: '+Str(aStruOLD[n,3],6))
                  PrevDat->nStavPrev := 21
                ENDIF
                IF aStruNEW[i,4] <> aStruOLD[n,4]
                  AktStav('Pozor neodpovídá dec promìnné NEW: ' + Str(aStruNEW[i,3],6) + 'OLD: ' +Str(aStruOLD[n,3],6))
                  PrevDat->nStavPrev := 22
                ENDIF
              ENDIF
              ADel( aStruNEW, i)
              ASize( aStruNEW, Len( aStruNEW)-1)
            ELSE
              PrevDat->nStavPrev := 30
              AktStav('Promìnná >' + aStruOLD[n,1] +'< neexistuje v novém souboru ')
            ENDIF
          NEXT

          FOR n := 1 TO Len( aStruNEW)
            IF 'CUSRZMENYR' <> aStruNEW[n,1] .AND. 'DDATZMENYR' <> aStruNEW[n,1] .AND. ;
               'CCASZMENYR' <> aStruNEW[n,1] .AND. 'CUSRVZNIKR' <> aStruNEW[n,1] .AND. ;
               'DDATVZNIKR' <> aStruNEW[n,1] .AND. 'CCASVZNIKR' <> aStruNEW[n,1]
              PrevDat->nStavPrev := 30
              AktStav('Promìnná >' + aStruNEW[n,1] +'< neexistuje ve starém souboru ')
            ENDIF
          NEXT

          IF lPreved

            b_mblock := if( .not. empty( PrevDat->mBlok ), COMPILE( blok_mem(PrevDat->mBlok, .f.) ), { || .t. } )
            IF( !Empty( PrevDat->mBeginBlok), DBGetVal( blok_mem(PrevDat->mBeginBlok)), NIL)

            Old->( dbGoTop())
            ncommit := 0
            if .not. IsNil( OLD->( LASTREC()))
              drgServiceThread:progressStart( drgNLS:msg('Pøevádím soubor - ' + AllTrim(PrevDat->cOldFile)), OLD->( LASTREC()))
            else
              ncommit := 0
            endif

//            IF( !Empty( PrevDat->mBeginBlok), DBGetVal( blok_mem(PrevDat->mBeginBlok)), NIL)
//            Old->( dbGoTop())
//            drgServiceThread:progressStart( drgNLS:msg('Pøevádím soubor - ' + AllTrim(PREVDAT->cOldFile)), OLD->( LASTREC()))
            DO WHILE .not. Old->( Eof())
              New ->( dbAppend())

/*
              if New->( FieldPos("cUniqIdRec")) > 0
                New->cUniqIdRec := StrZero(usrIdDB,6) +PadR(fileName,10)+ StrZero(New->(Recno()),10)
              endif
*/

              PrevDat->nPrevRec := Old->( Recno())
              PrevDat->nLastRec := New->( Recno())
              FOR n := 1 TO Old->(FCount())
                IF ( nPos := New->( FieldPos( Old->( FieldName( n))))) > 0
                  DO CASE
                  CASE ValType( Old->( FieldGet( n))) == 'U'
                    IF Empty( Old->( FieldGet( n)))
                      AktStav('Pozor nepodporovaný typ (asi pole) ' +Old->( FieldName( n)) )
                      PrevDat->nStavPrev := 50
                    ELSE
                      cX := Old->( FieldGet( n))
                    ENDIF
                  OTHERWISE
                    New->( FieldPut( nPos, Old->( FieldGet( n))))
                  ENDCASE
                ENDIF
              NEXT

//              IF( !Empty( PrevDat->mBlok), DBGetVal( blok_mem(PrevDat->mBlok)), NIL)
              eval( b_mblock )

              drgServiceThread:progressInc()
              Old->( dbSkip())

              ncommit++
              if ncommit =50
                new->( dbCommit())
                ncommit := 0
              endif

            ENDDO

            IF( !Empty( PrevDat->mEndBlok), DBGetVal( blok_mem(PrevDat->mEndBlok)), NIL)

          ENDIF
          drgServiceThread:progressEnd()
          Old->( dbCloseArea())
          New->( dbCloseArea())
        ENDIF
      ENDIF

      PrevDat->cKonPrev := DtoC( Date()) +"  "+ Time()
      PrevDat->( dbUnlock())

      PrevDat->( dbSkip())
    enddo


/*
    do while .not. prevdat->( eof())
      if prevdat->ntypprevod = 0

        prevdat->( dbRLock())
        prevdat->czacprev := DtoC(Date())+' '+Time()

        drgDBMS:open(AllTrim(prevdat->cnewfile),.t.,,,,'New')

        if prevdat->nzpusmaz = 1
          new->(dbzap())
        endif

        cfile := cPath + AllTrim(prevdat->coldpath) + AllTrim(prevdat->coldfile)

        dbUseArea( .t.,'FOXCDX', cFile,'Old',.T.)
  *      uctold->(DbSetIndex(cindex))

  *      UctOld->( AdsSetOrder(6))
        Old->( AdsSetOrder(0))
  *      UctOld->( dbSetScope( SCOPE_BOTH, key), dbgoTop())
        drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy - '+AllTrim(prevdat->coldfile)), Old->( LastRec()))
        Old->( dbGoTop())
        IF( !Empty( prevdat->mBeginBlok), DBGetVal( blok_mem(prevdat->mBeginBlok)), NIL)
        prevdat->nprevrec := 0
        do while .not. Old->( Eof())
          mh_COPYFLD('Old', 'New', .T.)
          IF( !Empty( prevdat->mBlok), DBGetVal( blok_mem(prevdat->mBlok)), NIL)

          New->( dbUnlock())
          prevdat->nprevrec++
          prevdat->nlastrec := Old->(Recno())
          drgServiceThread:progressInc()
          Old->( dbSkip())
        enddo

        IF( !Empty( prevdat->mEndBlok), DBGetVal( blok_mem(prevdat->mEndBlok)), NIL)

        Old->( dbCloseArea())
        New->( dbCloseArea())

        prevdat->ckonprev := DtoC(Date())+' '+Time()
        prevdat->( dbUnlock())

        drgServiceThread:progressEnd()

      endif

      prevdat->( dbSkip())
    enddo

*/


//    else
//      MsgBox( 'Chybí vstupní soubory'+' '+ cPath +' !!!', 'CHYBA...' )
//    endif
  endif


//  DRGDIALOG FORM 'SYS_asystem_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

//  if nExit != drgEVENT_QUIT
//    ::dm:set("asysact->cidobject", asystem->cidobject)
//  endif



  ::lnewrec := .F.
RETURN self


method SYS_prevoldasys_in:ebro_saveEditRow(parent)
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
METHOD SYS_prevoldasys_IN:destroy()
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


STATIC FUNCTION AktStav(cTEXT)
  PrevDat->mProtokol += cTEXT +Chr(13) +Chr(10)
RETURN(NIL)


STATIC FUNCTION blok_mem(memStr)
  LOCAL cStr := MemoTran(memStr, ', ', '')
**  LOCAL cStr := MemoTran(memStr, , '')

  DO WHILE At(',', cStr, Len(cStr)) <> 0
    cStr := SubStr(cStr,1,Len(cStr) -1)
  ENDDO

RETURN Upper( AllTrim( cStr))


STATIC FUNCTION UprTYP( cTYP)
  LOCAL cRET

  cRET := cTYP

  DO CASE
  CASE cTYP = "I" .OR. cTYP = "F"
    cRET := "N"

  ENDCASE

RETURN( cRET)


STATIC FUNCTION UprLEN( cTYP, nLEN)
  LOCAL nRET

  nRET := nLEN

  DO CASE
  CASE cTYP = "I"
    nRET := nLEN
  CASE cTYP = "F"
    nRET := nLEN
  CASE cTYP = "D"
    nRET := 8

  ENDCASE

RETURN( nRET)

FUNCTION DoplnDoOsob()
  LOCAL lOK
  LOCAL nCis := 1
  LOCAL cTyp,cAdr,cNaz
  LOCAL nPor := 1

  if .not. Osoby->(dbSeek(Upper(new->crodcispra),,'Osoby08'))
    //  drgDBMS:open('Osoby')
    mh_COPYFLD('New', 'OSOBY', .T.)
    OSOBY->nCISOSOBY  := OSOBY->(Recno())
    New->nCISOSOBY    := OSOBY->nCISOSOBY
    OSOBY->cRodCisOsb := New->cRodCisPra

    OSOBY->cTelefon   := IF( !Empty(New->cTelMobil), New->cTelMobil             ;
                          , IF( !Empty(New->cTelPriv), New->cTelPriv            ;
                           , IF( !Empty(New->cTelZames), New->cTelZames, "" )))

    OSOBY->cEmail     := New->cEmail

  endif

  IF( !Empty(New->cMisto),    DoplnElSpoj( nCis++,"ADR","ADR_DOR",,  "Adresa pro doruèení poštovních zásilek", nPOR++), NIL)
  IF( !Empty(New->cTelPriv),  DoplnElSpoj( nCis++,"TEL","TEL_PRI",   New->cTelPriv,  "Telefon - privát", nPOR++), NIL)
  IF( !Empty(New->cTelMobil), DoplnElSpoj( nCis++,"TEL","TEL_ZAM",   New->cTelZames, "Telefon - zamìstnání",nPOR++), NIL)
  IF( !Empty(New->cTelZames), DoplnElSpoj( nCis++,"GSM","TEL_MOB",   New->cTelMobil, "Telefon - mobil",nPOR++), NIL)
  IF( !Empty(New->cEmail),    DoplnElSpoj( nCis++,"EMAIL","EMAIL_OSB", New->cEmail,    "E-mail - osobní",nPOR++), NIL)

  OSOBY->cPrijOsob  := New->cPrijPrac
  OSOBY->cJmenoOsob := New->cJmenoPrac
  OSOBY->cOsoba     := New->cPracovnik
  OSOBY->cJmenoRozl := AllTrim(New->cPrijPrac) +' '+AllTrim(New->cJmenoPrac)
  OSOBY->cTitulPred := New->cTitulPrac
  OSOBY->nOsCisPrac := New->nOsCisPrac
  OSOBY->nis_ZAM    := if( New->nOsCisPrac > 0, 1, 0)
  OSOBY->nis_PER    := 1

  OSOBY->cPreUlice  := New->cPreUlice
  OSOBY->cPreCisPop := New->cPreCisPop
  OSOBY->cPreUliCPo := New->cPreUliCPo
  OSOBY->cPreMisto  := New->cPreMisto
  OSOBY->cPrePsc    := New->cPrePsc
  OSOBY->cZkrStatPr := New->cZkrStatPr
  OSOBY->cRodCisOsb := New->cRodCisPra
  OSOBY->dDatNaroz  := New->dDatNaroz
  OSOBY->cMistoNar  := New->cMistoNar
  OSOBY->cZkrStatNa := New->cZkrStatNa
  OSOBY->cZkratNar  := New->cZkratNar
  OSOBY->cZkrStaPri := New->cZkrStaPri
  OSOBY->cPohlavi   := New->cPohlavi
  OSOBY->nMuz       := New->nMuz
  OSOBY->nZena      := New->nZena
  OSOBY->cZkrRodStv := New->cZkrRodStv
  OSOBY->cZkrManStv := New->cZkrManStv
  OSOBY->cZkrVzdel  := New->cZkrVzdel
  OSOBY->cCisloOP   := New->cCisloOP
  OSOBY->cCisloPasu := New->cCisloPasu

  OSOBY->cIdOsKarty := New->cIdOsKarty
  if .not. empty(OSOBY->cIdOsKarty)
    OSOBY->nis_DOH  := 1
  endif

  OSOBY->nPocLPraxe := New->nPocLPraxe
  OSOBY->nKlasZam   := New->nKlasZam
  OSOBY->lEvidDIM   := New->lEvidDIM
  OSOBY->lVedPrac   := New->lVedPrac
//  OSOBY->lPRI_zal   := New->lPRI_zal
  OSOBY->lStavem    := New->lStavem
  OSOBY->lOdborar   := New->lOdborar
  OSOBY->lPrukazZPS := New->lPrukazZPS
  OSOBY->cPrukazZPS := New->cPrukazZPS
  OSOBY->nVEvidenci := New->nVEvidenci
  OSOBY->lExistSkol := New->lExistSkol
  OSOBY->lExistVzde := New->lExistVzde
  OSOBY->lExistLePr := New->lExistLePr

  if OSOBY->lpri_zal
     OSOBY->nis_ZAL    := if( OSOBY->lpri_zal, 1, 0)
  endif

  if OSOBY->nis_zam <> 0 .or. OSOBY->nis_per  <> 0 .or. OSOBY->nis_doh <> 0  ;
        .or. OSOBY->nis_zal <> 0
    if OSOBY->nis_zam <> 0
      mh_COPYFLD('Osoby', 'OsobySk', .T.)
      OsobySk->cZkr_Skup := 'ZAM'
    endif
    if OSOBY->nis_per  <> 0
      mh_COPYFLD('Osoby', 'OsobySk', .T.)
      OsobySk->cZkr_Skup := 'PER'
    endif
    if OSOBY->nis_doh <> 0
      mh_COPYFLD('Osoby', 'OsobySk', .T.)
      OsobySk->cZkr_Skup := 'DOH'
    endif
    if OSOBY->nis_zal <> 0
      mh_COPYFLD('Osoby', 'OsobySk', .T.)
      OsobySk->cZkr_Skup := 'ZAL'
    endif
  endif


RETURN(NIL)


FUNCTION DoplnElSpoj( nCis,cTyp,cZkr,cAdr,cNaz, nPor)

    mh_COPYFLD('OSOBY', 'SPOJENI', .T.)
    SPOJENI->nCisSpoj   := isNull( SPOJENI->sid, 0)
    SPOJENI->cTypSpoj   := cTyp
    SPOJENI->cZkrSpoj   := cZkr
    SPOJENI->cAdrElSpoj := cAdr
    SPOJENI->cNazSpoj   := cNaz

    if SPOJENI->cZkrSpoj <> 'ADR_DOR'
      SPOJENI->cUlice     := ''
      SPOJENI->cCisPopis  := ''
      SPOJENI->cUlicCiPop := ''
      SPOJENI->cMisto     := ''
      SPOJENI->cPsc       := ''
      SPOJENI->cZkratStat := ''
    else
      SPOJENI->mAdrPoSpoj := SPOJENI->cUlicCiPop + CRLF + SPOJENI->cPsc + ' ' +SPOJENI->cMisto
    endif

    VazSpoje->(dbAppend())

// pozor upravit pro sID

    VazSpoje->nOSOBY  := isNull( Osoby->sID, 0)
    VazSpoje->SPOJENI := isNull( Spojeni->sID, 0)
    VazSpoje->nItem   := nPOR

RETURN(NIL)


FUNCTION DoplnSkoleni( nCis,cTyp,cZkr,cAdr,cNaz, nPor)

    mh_COPYFLD('OSOBY', 'SKOLENI', .T.)

    VazSkolen->(dbAppend())

// pozor upravit pro sID

    VazSkol->nOSOBY  := isNull( Osoby->sID, 0)
    VazSkol->SPOJENI := isNull( Skoleni->sID, 0)
    VazSkol->nItem   := nPOR

RETURN(NIL)



FUNCTION PrevedSlevy()

   DO CASE
   CASE SlevyCen->cTypSlevy = "   "

   CASE SlevyCen->cTypSlevy = "001"

   CASE SlevyCen->cTypSlevy = "010"

   CASE SlevyCen->cTypSlevy = "100"

   CASE SlevyCen->cTypSlevy = "110"

   CASE SlevyCen->cTypSlevy = "101"

   ENDCASE

RETURN(NIL)


FUNCTION UpravCZK( cVAR)
   LOCAL  cMena
   LOCAL  aMena :={'kc','kè','Kc','Kè','KC','KÈ' }

   DEFAULT cVAR TO 'cZkratMeny'

   cMena := AllTrim(New->&cVAR)
   aEval( aMena, {|x| if( At( x, cMena)<> 0, New->&cVAR := 'CZK', NIL) })

RETURN(NIL)


FUNCTION UpravUcetpol()
  local  path, n

  drgDBMS:open('FAKPRIHD')
  drgDBMS:open('FAKVYSHD')
  drgDBMS:open('POKLADHD')
  drgDBMS:open('BANVYPHD')
  drgDBMS:open('UCETDOHD')
  drgDBMS:open('PVPHEAD')

  New->(OrdSetFocus(0))
  New->(dbGoTop())

  do while .not. New->(Eof())
    do case
    case New->cdenik == "S " .and. Empty(New->ctypdoklad)
        if pvphead->( dbSeek(STRZERO(New->nROK,4) +STRZERO(New->nDoklad,10),,14))
          New->ctypdoklad := pvphead->ctypdoklad
          New->ctyppohybu := pvphead->ctyppohybu
          do case
          case New->ctypuct = "10" .or. New->ctypuct = "11"
            New->ctypuct := 'SK_PRIJww'
          case New->ctypuct = "50" .or. New->ctypuct = "51"
            New->ctypuct := 'SK_VYDEJww'
          endcase
        endif

    case New->cdenik == "O " .and. Empty(New->ctypdoklad)
        if fakvyshd->( dbSeek(STRZERO(New->nROK,4) +STRZERO(New->nDoklad,10),,'FODBHD22'))
          New->ctypdoklad := fakvyshd->ctypdoklad
          New->ctyppohybu := fakvyshd->ctyppohybu
          do case
          case New->norditem = -1
            New->ctypuct := 'FV_DPH'
            New->npoluctpr := 2
            New->norditem = -103
          case New->norditem = -2
            New->ctypuct := 'FV_DPH'
            New->npoluctpr := 2
            New->norditem = -102
          case New->norditem = -3
            New->ctypuct := 'FV_HALVYR'
            New->npoluctpr := 3
          otherwise
            New->ctypuct := 'FV_TRZBY'
            New->npoluctpr := 1
          endcase
        endif

    case New->cdenik == "P " .and. Empty(New->ctypdoklad)
        if pokladhd->( dbSeek(STRZERO(New->nROK,4) +STRZERO(New->nDoklad,10),,11))
          New->ctypdoklad := pokladhd->ctypdoklad
          New->ctyppohybu := pokladhd->ctyppohybu
          do case
          case New->norditem = -101 .and. pokladhd->ctyppohybu = 'POKLPRIJ'
            New->ctypuct := 'PO_DPH'
            New->npoluctpr := 4
            New->norditem = -104
          case New->norditem = -101 .and. pokladhd->ctyppohybu = 'POKLVYDEJ'
            New->ctypuct := 'PO_DPH'
            New->npoluctpr := 4
            New->norditem = -111
          case New->norditem = -202 .and. pokladhd->ctyppohybu = 'POKLPRIJ'
            New->ctypuct := 'PO_DPH'
            New->npoluctpr := 4
            New->norditem = -103
          case New->norditem = -202 .and. pokladhd->ctyppohybu = 'POKLVYDEJ'
            New->ctypuct := 'PO_DPH'
            New->npoluctpr := 4
            New->norditem = -110
          case New->norditem > 10
            New->ctypuct := 'PO_POLOZKY'
            New->npoluctpr := 3
            New->norditem = -102
          case New->norditem = 2
            New->ctypuct := 'PO_HALVYR'
            New->npoluctpr := 2
          otherwise
            New->ctypuct := 'PO_HLAV'
            New->npoluctpr := 1
          endcase
        endif
    case New->cdenik == "D " .and. Empty(New->ctypdoklad)
        if fakprihd->( dbSeek(STRZERO(New->nROK,4) +STRZERO(New->nDoklad,10),,19))
          New->ctypdoklad := fakprihd->ctypdoklad
          New->ctyppohybu := fakprihd->ctyppohybu
          do case
          case Val(New->ctypuct) = 3
            New->ctypuct := 'FP_NAKLAD'
            New->npoluctpr := 1
          case Val(New->ctypuct) = 4
            New->ctypuct := 'FP_HALVYR'
            New->npoluctpr := 3
          case Val(New->ctypuct) = 6
            New->ctypuct := 'FP_ZALOHY'
            New->npoluctpr := 4
          case Val(New->ctypuct) = 11
            New->ctypuct := 'FP_DPH'
            New->npoluctpr := 2
          case Val(New->ctypuct) = 12
            New->npoluctpr := 2
            New->ctypuct := 'FP_DPH'
          case Val(New->ctypuct) = 13
            New->ctypuct := 'FP_DPH'
            New->npoluctpr := 2
          endcase
        endif
    case New->cdenik == "B " .and. Empty(New->ctypdoklad)
        if banvyphd->( dbSeek(STRZERO(New->nROK,4) +STRZERO(New->nDoklad,10),,13))
          New->ctypdoklad := banvyphd->ctypdoklad
          New->ctyppohybu := banvyphd->ctyppohybu
          do case
          case Val(New->ctypuct) = 1
            New->ctypuct := 'BA_POLOZKY'
            New->npoluctpr := 1
          case Val(New->ctypuct) = 2
            New->ctypuct := 'BA_POLOZKY'
            New->npoluctpr := 1
          case Val(New->ctypuct) = 3
            New->ctypuct := 'BA_POLOZKY'
            New->npoluctpr := 1
          case Val(New->ctypuct) = 4
            New->ctypuct := 'BA_BKURROZ'
            New->npoluctpr := 2
          endcase
        endif
    endcase

    New->( dbSkip())
  enddo

RETURN .t.


FUNCTION UPRAV_DP_I()
  local cx

  del_c_TypPoh('I')

  Old->( dbGoTop())
  DO WHILE !Old->( Eof())
    C_TYPPOH->( dbAppend())
    C_TYPPOH->cULOHA     := "I"
    C_TYPPOH->cPODULOHA  := "DOKLADY"
    DO CASE
    CASE Old->nDrPohyb = 80
      C_TYPPOH->cTYPDOKLAD := "HIM_PRE" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb = 99
      C_TYPPOH->cTYPDOKLAD :="HIM_GEN" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb >= 10 .AND. Old->nDrPohyb <= 31
      C_TYPPOH->cTYPDOKLAD :="HIM_PRI" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb >= 32 .AND. Old->nDrPohyb <= 99
      C_TYPPOH->cTYPDOKLAD :="HIM_VYD" +StrZero(Old->nKarta,3)
    ENDCASE
    C_TYPPOH->cTYPPOHYBU := AllTrim( Str( Old->nDrPohyb))
    C_TYPPOH->cNAZTYPPOH := Old->cNazevPoh
    C_TYPPOH->dPLATNYOD  := CtoD("01.01.2005")
    C_TYPPOH->cTASK      := 'HIM'

    Old->( dbSkip())
  ENDDO

  C_TYPPOH->( dbPack())
  C_TYPPOH->( dbCloseArea())

RETURN(nil)


FUNCTION UPRAV_DP_S()
  local cx

  del_c_TypPoh('S')

  Old->( dbGoTop())
  DO WHILE !Old->( Eof())
    C_TYPPOH->( dbAppend())
    C_TYPPOH->cULOHA     := "S"
    C_TYPPOH->cPODULOHA  := "DOKLADY"
    DO CASE
    CASE Old->nKarta = 400
      C_TYPPOH->cTYPDOKLAD :="SKL_CEN"+ StrZero(Old->nKarta,3)
    CASE Old->nCislPoh = 40  .OR. Old->nCislPoh = 80
      C_TYPPOH->cTYPDOKLAD :="SKL_PRE"+ StrZero(Old->nKarta,3)
    CASE Old->nCislPoh >= 0  .AND. Old->nCislPoh <= 49
      C_TYPPOH->cTYPDOKLAD :="SKL_PRI"+ StrZero(Old->nKarta,3)
    CASE Old->nCislPoh >= 50 .AND. Old->nCislPoh <= 99
      C_TYPPOH->cTYPDOKLAD :="SKL_VYD"+ StrZero(Old->nKarta,3)
    ENDCASE
    C_TYPPOH->cTYPPOHYBU := AllTrim( Str( Old->nCislPoh))
    C_TYPPOH->cNAZTYPPOH := Old->cNazevPoh
    C_TYPPOH->dPLATNYOD  := CtoD("01.01.2005")
    C_TYPPOH->cTASK      := 'SKL'
    Old->( dbSkip())
  ENDDO

  C_TYPPOH->( dbPack())
  C_TYPPOH->( dbCloseArea())

RETURN(nil)


FUNCTION UPRAV_DP_Z()
  local cx

  del_c_TypPoh('Z')

  Old->( dbGoTop())
  DO WHILE !Old->( Eof())
    C_TYPPOH->( dbAppend())
    C_TYPPOH->cULOHA     := "Z"
    C_TYPPOH->cPODULOHA  := "DOKLADY"
    DO CASE
    CASE Old->nDrPohyb = 90 .OR. Old->nDrPohyb = 91
      C_TYPPOH->cTYPDOKLAD :="ZVI_OST" +StrZero(Old->nKarta,3)
    CASE (Old->nDrPohyb >= 40.AND. Old->nDrPohyb <= 43) .OR.;
          (Old->nDrPohyb >= 80.AND. Old->nDrPohyb <= 83)
      C_TYPPOH->cTYPDOKLAD :="ZVI_PRE" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb = 94 .OR. Old->nDrPohyb = 95
      C_TYPPOH->cTYPDOKLAD :="ZVI_GEN" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb = 3 .OR.                               ;
          (Old->nDrPohyb >= 9 .AND. Old->nDrPohyb <= 49) .OR.;
          (Old->nDrPohyb >= 92.AND. Old->nDrPohyb <= 96)
      C_TYPPOH->cTYPDOKLAD :="ZVI_PRI" +StrZero(Old->nKarta,3)
    CASE (Old->nDrPohyb >= 4 .AND. Old->nDrPohyb <= 8).OR.;
           (Old->nDrPohyb >= 50 .AND. Old->nDrPohyb <= 89)
      C_TYPPOH->cTYPDOKLAD :="ZVI_VYD" +StrZero(Old->nKarta,3)
    CASE Old->nDrPohyb = 183
      C_TYPPOH->cTYPDOKLAD :="ZKS_PRE" +StrZero(Old->nKarta,3)
    CASE (Old->nDrPohyb >= 110 .AND. Old->nDrPohyb <= 131).OR.;
           (Old->nDrPohyb >= 140 .AND. Old->nDrPohyb <= 149)
      C_TYPPOH->cTYPDOKLAD :="ZKS_PRI" +StrZero(Old->nKarta,3)
    CASE (Old->nDrPohyb >= 132 .AND. Old->nDrPohyb <= 139).OR.;
           (Old->nDrPohyb >= 150 .AND. Old->nDrPohyb <= 199)
      C_TYPPOH->cTYPDOKLAD :="ZKS_VYD" +StrZero(Old->nKarta,3)
    ENDCASE

    C_TYPPOH->cTYPPOHYBU := AllTrim( Str( Old->nDrPohyb))
    C_TYPPOH->cNAZTYPPOH := Old->cNazevPoh
    C_TYPPOH->dPLATNYOD  := CtoD("01.01.2005")
    C_TYPPOH->cTASK      := 'ZVI'
    Old->( dbSkip())
  ENDDO

  C_TYPPOH->( dbPack())
  C_TYPPOH->( dbCloseArea())

RETURN(nil)



FUNCTION UPRAV_DP_M()
  local cx

  del_c_TypPoh('M')

  Old->( dbGoTop())
  DO WHILE !Old->( Eof())
    C_TYPPOH->( dbAppend())
    C_TYPPOH->cULOHA     := "M"
    C_TYPPOH->cPODULOHA  := "DOKLADY"
    DO CASE
    CASE (Old->nDruhMzdy >= 100 .AND. Old->nDruhMzdy <= 399)
      C_TYPPOH->cTypDoklad :="MZD_PRIJEM"
    CASE (Old->nDruhMzdy >= 400 .AND. Old->nDruhMzdy <= 499)
      C_TYPPOH->cTypDoklad :="MZD_NEMOC"
    CASE (Old->nDruhMzdy >= 500 .AND. Old->nDruhMzdy <= 599)
      C_TYPPOH->cTypDoklad :="MZD_SRAZKY"
    CASE (Old->nDruhMzdy >= 600 .AND. Old->nDruhMzdy <= 999)
      C_TYPPOH->cTypDoklad :="MZD_GENER"
    ENDCASE
    C_TYPPOH->cTYPPOHYBU := AllTrim( Str( Old->nDruhMzdy))
    C_TYPPOH->cNAZTYPPOH := Old->cNazevDMZ
    C_TYPPOH->dPLATNYOD  := CtoD("01.01.2005")
    C_TYPPOH->cTASK      := 'MZD'
    Old->( dbSkip())
  ENDDO

  C_TYPPOH->( dbPack())
  C_TYPPOH->( dbCloseArea())

RETURN(nil)


function Uprav_UcPr()

  drgDBMS:open('C_TypPoh',.T.)
  drgDBMS:open('C_TypMaj',.T.)
  drgDBMS:open('C_UctSkZ',.T.)
  drgDBMS:open('C_UctSkp',.T.)
  drgDBMS:open('UcetPrHD',.T.)
  drgDBMS:open('UcetPrIT',.T.)
  UcetPrHD->( OrdSetFocus(2))
  UcetPrIT->( OrdSetFocus(4))

  UcetPrHD->( dbGoTop())
  do while !UcetPrHD->( Eof())
    if UcetPrHD->cULOHA = "I" .or. UcetPrHD->cULOHA = "S" .or.  ;
        UcetPrHD->cULOHA = "Z" .or. UcetPrHD->cULOHA = "M"
      if UcetPrHD->( dbRLock())
        UcetPrHD->( dbDelete())
      endif
    endif
    UcetPrHD->( dbSkip())
  enddo

  UcetPrIT->( dbGoTop())
  do while !UcetPrIT->( Eof())
    if UcetPrIT->cULOHA = "I" .or. UcetPrIT->cULOHA = "S"  .or. ;
        UcetPrIT->cULOHA = "Z" .or. UcetPrIT->cULOHA = "M"
      if UcetPrIT->( dbRLock())
        UcetPrIT->( dbDelete())
      endif
    endif
    UcetPrIT->( dbSkip())
  enddo

  Old->( dbGoTop())
  DO WHILE !Old->( Eof())
    j := 0
    ok := .F.
    if Upper(Old->cUloha) == "S"
      gg := 1
    endif

    FOR n := Old->nOd TO Old->nDo
      j++
      lDopln := .F.
      xKEYhd := Upper(Old->cUloha) + Upper( Alltrim( Str( Old->nDrPohyb)))

      IF UCETPRHD->( dbSeek( xKEYhd,,2))
        ok := .T.
      ELSE
        IF C_TypPoh->( dbLOCATE({||(C_TypPoh->cUloha=Old->cUloha.and.;
               AllTrim(C_TypPoh->cTypPohybu) = AllTrim(Str(Old->nDrPohyb)))}))
          Mh_CopyFld( "C_TypPoh", "UCETPRHD", .T.)
          UcetPrHD->cNazUcPred := C_TypPoh->cNazTypPoh
          ok := .T.
          lDopln := .T.
        endif
      ENDIF

      IF lDopln
        UcetPrHD->dPlatnyOD  := CtoD("01.01.2005")
      endif

      do case
      case Old->cUloha == "S"
        okucsk := C_UctSkp->( dbLOCATE({|| C_UctSkp->nUcetSkup = n}))
      case Old->cUloha == "I"
        okucsk := C_TypMaj->( dbLOCATE({|| C_TypMaj->nTypMaj = n}))
      case Old->cUloha == "Z"
        okucsk := C_UctSkZ->( dbLOCATE({|| C_UctSkZ->nUcetSkup = n}))
        if Old->cTypUctMD = "52"
          okucsk := .F.
        endif
      otherwise
        okucsk := .T.
      endcase

      if okucsk
        lDopln := .F.
        xKEYit := Upper( Old->cUloha) +Upper( Padr( AllTrim( Str( Old->nDrPohyb)),6," ")) +Upper( PadR( AllTrim(Str( n)),10," "))
        IF UcetPrIT->( dbSeek( xKEYit,,4))
        ELSE
          if ok
            Mh_CopyFld( "UCETPRHD", "UCETPRIT", .T.)
            lDopln := .T.
          endif
        ENDIF

        IF lDopln
          UcetPrIT->cUcetSkup  := AllTrim( Str( n))
          UcetPrIT->nPolUctPr  := j
          UcetPrIT->nSubPolUc  := 1
          UcetPrIT->cUcetMD    := Old->cUcetMD
          UcetPrIT->cUcetDAL   := Old->cUcetDAL

          do case
          case Old->cUloha == "S"
            if C_UctSkp->( dbLOCATE({|| C_UctSkp->nUcetSkup = n}))
              UcetPrIT->cNazUcPred := C_UctSkp->cNazUctSk
            endif

            do case
            case Old->cTypUctMD = "10"
              UcetPrIT->cMainFile := "PVPITEMww"
              UcetPrIT->cTypUct := "SK_PRIJww"
            case Old->cTypUctMD = "12"
              UcetPrIT->cMainFile := "PVPHEADw"
              UcetPrIT->cTypUct := "SK_CENROZw"
            case Old->cTypUctMD = "20" .or. Old->cTypUctMD = "22"
              UcetPrIT->cMainFile := "PVPITEMww"
              UcetPrIT->cTypUct := "SK_NATURww"
            case Old->cTypUctMD = "50"
              UcetPrIT->cMainFile := "PVPITEMww"
              UcetPrIT->cTypUct := "SK_VYDEJww"
            case Old->cTypUctMD = "91"
              UcetPrIT->(dbDelete())
            endcase

          case Old->cUloha == "I"
            if C_TypMaj->( dbLOCATE({|| C_TypMaj->nTypMaj = n}))
              UcetPrIT->cNazUcPred := C_TypMaj->cNazTypu
            endif

            do case
            case Old->cTypUctMD = "10" .or. Old->cTypUctMD = "11" .or. Old->cTypUctMD = "41"
              UcetPrIT->cMainFile := "ZMAJU"
              UcetPrIT->cTypUct := "IM_VSTCEUC"
            case Old->cTypUctMD = "21" .or. Old->cTypUctMD = "23"
              UcetPrIT->cMainFile := "ZMAJU"
              UcetPrIT->cTypUct := "IM_ZMVSTCE"
            case Old->cTypUctMD = "25" .or. Old->cTypUctMD = "27"
              UcetPrIT->cMainFile := "ZMAJU"
              UcetPrIT->cTypUct := "IM_ZMUCOPR"
            case Old->cTypUctMD = "31"
              UcetPrIT->cMainFile := "ZMAJUw"
              UcetPrIT->cTypUct := "IM_UCODPIS"
            case Old->cTypUctMD = "43"
              UcetPrIT->cMainFile := "ZMAJUw"
              UcetPrIT->cTypUct := "IM_ZUSTCUC"
            endcase

          CASE Old->cUloha == "Z"
            C_UctSkZ->(dbGoTop())
            IF C_UctSkZ->( dbLOCATE({|| C_UctSkZ->nUcetSkup = n}))
              UcetPrIT->cNazUcPred := C_UctSkZ->cNazUctSk
            ENDIF

            do case
            case Old->cTypUctMD = "10" .or. Old->cTypUctMD = "11" .or. Old->cTypUctMD = "41"
              UcetPrIT->cMainFile := "ZMAJUZw"
              UcetPrIT->cTypUct := "ZS_VSTCEUC"
            case Old->cTypUctMD = "21" .or. Old->cTypUctMD = "23"
              UcetPrIT->cMainFile := "ZMAJUZw"
              UcetPrIT->cTypUct := "ZS_ZMVSTCE"
            case Old->cTypUctMD = "25" .or. Old->cTypUctMD = "27"
              UcetPrIT->cMainFile := "ZMAJUZw"
              UcetPrIT->cTypUct := "ZS_ZMUCOPR"
            case Old->cTypUctMD = "31"
              UcetPrIT->cMainFile := "ZMAJUZ"
              UcetPrIT->cTypUct := "ZS_UCODPIS"
            case Old->cTypUctMD = "43"
              UcetPrIT->cMainFile := "ZMAJUZw"
              UcetPrIT->cTypUct := "ZS_ZUSTCUC"

            case Old->cTypUctMD = "15"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_PRIJEM"
            case Old->cTypUctMD = "17"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_PRIJVP"
            case Old->cTypUctMD = "50"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_VYDEJ"
            case Old->cTypUctMD = "71"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_NATKG"
            case Old->cTypUctMD = "73"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_NATKS"
            case Old->cTypUctMD = "75"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_NATKD"
            case Old->cTypUctMD = "77"
              UcetPrIT->cMainFile := "ZVZMENHD"
              UcetPrIT->cTypUct := "ZV_NATKDO"
            endcase


          ENDCASE

          if .not. Empty(Old->mPodUct)
            UcetPrIT->mPodminka := Old->mPodUct
          endif
        ENDIF
      endif
    NEXT
    Old->( dbSkip())
  ENDDO

  if( Select('C_TypPoh') > 0, C_TypPoh->( dbCloseArea()), nil)
  if( Select('C_TypMaj') > 0, C_TypMaj->( dbCloseArea()), nil)
  if( Select('C_UctSkZ') > 0, C_UctSkZ->( dbCloseArea()), nil)
  if( Select('C_UctSkp') > 0, C_UctSkp->( dbCloseArea()), nil)

  UcetPrHD->( dbPack())
  UcetPrHD->( dbCloseArea())
  UcetPrIT->( dbPack())
  UcetPrIT->( dbCloseArea())

return(nil)


function del_c_TypPoh(cUlohy)

  drgDBMS:open('C_TypPoh',.T.)

  C_TYPPOH->( dbGoTop())
  do while !C_TYPPOH->( Eof())
    if C_TYPPOH->cULOHA = cUlohy
      C_TYPPOH->( dbDelete())
    endif
    C_TYPPOH->( dbSkip())
  enddo

return( nil)


FUNCTION NaplnLikvid()
  local n := 0
  local key
  local tag

//  drgDBMS:open('UCETPOL')
  tag := ucetpol->(OrdSetFocus(9))
  key := STRZERO(new->nRok,4) +STRZERO(new->nObdobi,2) ;
            +UPPER(new->cDenik) +STRZERO(new->nDoklad,10)
  ucetpol ->( dbSetScope(SCOPE_BOTH, key))
  ucetpol->(dbGoTop())

  do while .not. ucetpol->(Eof())
    n += ucetpol->nkcmd
    ucetpol->( dbSkip())
  enddo

  ucetpol->( dbClearScope())
  ucetpol->( OrdSetFOCUS( tag))

  New->nklikvid := n
  New->nzlikvid := n

RETURN(nil)

/*

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


FUNCTION GenMdavHD()
  local lgen := .t.
  local key


  drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy - generuji MZDDAVHD'), Old->( LastRec()))

  dbselectarea('old')
  dbCreateIndex( drgINI:dir_USERfitm+'old','StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10)';
                   , {|| StrZero(nrok,4)+StrZero(nobdobi,2)+StrZero(noscisprac,5)+StrZero(ndoklad,10) })

  drgDBMS:open('mzddavhd',.t.)
  mzddavhd->(dbzap())
  old->( dbGoTop())
  key := StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+StrZero(old->noscisprac,5)+StrZero(old->ndoklad,10)

  do while .not. old->( Eof())
    if lgen
      mh_COPYFLD('Old', 'mzddavhd', .T.)
      mzddavhd->nRokObd := (Old->nRok*100)+Old->nObdobi
      lgen := .f.
    endif

    mzddavhd->nHrubaMZD  += old->nHrubaMZD
    mzddavhd->nMzda      += old->nMzda
    mzddavhd->nZaklSocPo += old->nZaklSocPo
    mzddavhd->nZaklZdrPo += old->nZaklZdrPo
    mzddavhd->nDnyFondKD += old->nDnyFondKD
    mzddavhd->nDnyFondPD += old->nDnyFondPD
    mzddavhd->nDnyDovol  += old->nDnyDovol
    mzddavhd->nHodFondKD += old->nHodFondKD
    mzddavhd->nHodFondPD += old->nHodFondPD
    mzddavhd->nHodPresc  += old->nHodPresc
    mzddavhd->nHodPrescS += old->nHodPrescS
    mzddavhd->nHodPripl  += old->nHodPripl
//    mzddavhd->nKLikvid   += old->nKLikvid
//    mzddavhd->nZLikvid   += old->nZLikvid

    drgServiceThread:progressInc()
    old->( dbSkip())

    if key = StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+StrZero(old->noscisprac,5)+StrZero(old->ndoklad,10)

    else
      lgen := .t.
      key  := StrZero(old->nrok,4)+StrZero(old->nobdobi,2)+StrZero(old->noscisprac,5)+StrZero(old->ndoklad,10)
    endif

  enddo

  mzddavhd->( dbCloseArea())
  drgServiceThread:progressEnd()

RETURN NIL

*/