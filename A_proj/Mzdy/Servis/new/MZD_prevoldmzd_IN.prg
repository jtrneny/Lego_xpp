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

//          dbUseArea( .T.,oSession,AllTrim(::cNewADR) +AllTrim(prevodmz->cNewFile),'New',.F.)

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

/*

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
*/

          IF lPreved
            IF( !Empty( prevodmz->mBeginBlok), DBGetVal( blok_mem(prevodmz->mBeginBlok)), NIL)
            Old->( dbGoTop())
            drgServiceThread:progressStart( drgNLS:msg('Pøevádím soubor - ' + AllTrim(prevodmz->cOldFile)), OLD->( LASTREC()))
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

              IF( !Empty( prevodmz->mBlok), DBGetVal( blok_mem(prevodmz->mBlok)), NIL)

              drgServiceThread:progressInc()
              Old->( dbSkip())
            ENDDO

            IF( !Empty( prevodmz->mEndBlok), DBGetVal( blok_mem(prevodmz->mEndBlok)), NIL)

          ENDIF
          drgServiceThread:progressEnd()
          Old->( dbCloseArea())
          New->( dbCloseArea())
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


STATIC FUNCTION blok_mem(memStr)
  LOCAL cStr := MemoTran(memStr, ', ', '')
**  LOCAL cStr := MemoTran(memStr, , '')

  DO WHILE At(',', cStr, Len(cStr)) <> 0
    cStr := SubStr(cStr,1,Len(cStr) -1)
  ENDDO

RETURN Upper( AllTrim( cStr))


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
  local key

  drgServiceThread:progressStart( drgNLS:msg('Pøevádím mzdy - generuji MZDDAVHD'), Old->( LastRec()))

  drgDBMS:open('mzddavhd',.t.)
  mzddavhd->(dbzap())
  old->( dbGoTop())

  key := StrZero(old->nrok,4) +StrZero(old->nobdobi,2) +StrZero(old->noscisprac,5)+ ;
         strZero(old->nporPraVzt,3) +StrZero(old->ndoklad,10)

  do while .not. old->(eof())
    if .not. mzdDavHd->(dbseek( key,, 'MZDDAVHD01'))
      mh_COPYFLD('Old', 'mzddavhd', .T.)
      mzddavhd->nRokObd := (Old->nRok*100)+Old->nObdobi

    else

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
    endif

    drgServiceThread:progressInc()
    old->(dbskip())
    key := StrZero(old->nrok,4) +StrZero(old->nobdobi,2) +StrZero(old->noscisprac,5)+ ;
           strZero(old->nporPraVzt,3) +StrZero(old->ndoklad,10)

  enddo

  mzddavhd->( dbCloseArea())
  drgServiceThread:progressEnd()
return nil


FUNCTION GenMdavHD_JT()
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


FUNCTION GenMsrzHD()
  local lgen := .t.
  local key


  drgServiceThread:progressStart( drgNLS:msg('Pøevádím srážky ze mzdy - generuji MZDDAVHD'), Old->( LastRec()))

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


STATIC FUNCTION AktStav(cTEXT)
  prevodmz->mProtokol += cTEXT +Chr(13) +Chr(10)
RETURN(NIL)