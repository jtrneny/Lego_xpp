////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  mh_.PRG                                                                   //
//                                                                            //
//  Copyright:                                                                //
//                                                                            //
//                                                                            //
//  Contents:                                                                 //
//  Implementation of (DOS - METHODS)                                         //
//                                                                            //
//  Remarks:                                                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "dbstruct.ch"
#include "dll.ch"
#include "DBFDBE.CH"
#include "DMLB.CH"

#include "..\Asystem++\Asystem++.ch"

#include "ot4xb.ch"

#pragma Library( "XppUI2.LIB"  )
#pragma Library( "ASINet10.lib")
#pragma Library( "XbZlib.lib"  )
#pragma Library( "ot4xb.lib"  )


**
*************FUNKCE  mh_GetAbdPos vypoète asolutní pozici prvku*****************
FUNCTION mh_GetAbsPos(o)
   LOCAL nLeft       := 0
   LOCAL nTop        := 0
   LOCAL nRight      := 0
   LOCAL nBottom     := 0
   LOCAL cBuffer     := Space(16)
   LOCAL aObjPosXY   := {nil,nil}

   DllCall("User32.DLL", DLL_STDCALL,"GetWindowRect", o:GetHwnd(), @cBuffer)

   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))

   aObjPosXY[1]  := nLeft
   aObjPosXY[2]  := AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)


** oDATEfield -- objekt na FM
** aSize      -- size      FM
*************FUNKCE  mh_GetAbsPosDlg vypoète asolutní pozici dialogu************
FUNCTION mh_GetAbsPosDlg(oDateField,aSize)
  LOCAL  aPos      := {NIL,NIL}
  local  aAbsPosXY := mh_GetAbsPos(oDateField)

  *** GetX + width < HorizResolution
  IF aAbsPosXY[1] +aSize[1] < appDeskTop():currentSize()[1]
    aPos[1]:=   aAbsPosXY[1]
  ELSEIF aAbsPosXY[1] > 2000   // Offscreen Left Side
    aPos[1]:=    0
  ELSE
    aPos[1]:=    aAbsPosXY[1]+oDateField:currentSize()[1]-aSize[1]
  ENDIF

  *** Check X Co-ord for fields moved partially offscreen to right
  IF aPos[1] +aSize[1] > appDeskTop():currentSize()[1]
    aPos[1] := appDeskTop():currentSize()[1]-aSize[1]
  ENDIF

  IF aAbsPosXY[2]-aSize[2] > 5
    aPos[2]:=   aAbsPosXY[2]-aSize[2] -10
  ELSE
    aPos[2]:=   aAbsPosXY[2]+20
  ENDIF
RETURN(aPos)


*
*************FUNKCE  mh_WRTzmena aktualizuje soubor o provedené zmìnì***********
FUNCTION mh_WRTzmena( cALIAS, lNEW, lLOCK, cext_info)
  local ctext

  default lNEW  to .f., lLOCK to .f., cext_info to ''

  if substr(upper(cALIAS), len(cALIAS), 1) <> 'W'
    if( lLOCK, ( cALIAS)->( Sx_RLock()), nil)

    ctext :=         'Users: ' + logOsoba + CRLF
    ctext := cText + 'Time : ' + CDow(Date()) + ' - ' + DToC(Date()) +' - ' +Time() + CRLF
    if ( cALIAS)->( FieldPos('mUserZmenR')) > 0
      if lNEW
        if( ( cALIAS)->( FieldPos('dVznikZazn'))> 0,(cALIAS)->dVznikZazn := Date(), nil)
      else
        if( ( cALIAS)->( FieldPos('dZmenaZazn'))> 0,(cALIAS)->dZmenaZazn := Date(), nil)
      endif
      if( .not. empty(cext_info), ctext += cext_info +CRLF, nil )
      ctext := ctext + '-----------------------------------------------------------------' + CRLF
      ctext += (cALIAS)->mUserZmenR
      ( cALIAS)->mUserZmenR := ctext
    endif

    if( lLOCK, ( cALIAS)->( dbUnLock()), nil)
  endif

RETURN( NIL)


*
*************FUNKCE  mh_OBD_MM_YY vrátí z datum období ve tvaru MM/RR***********
FUNCTION mh_OBD_MM_YY( dDATE)
  LOCAL cOBD

  cOBD := StrZero( Month( dDATE), 2)+ "/"+ Right( Str( Year( dDATE),4), 2)
RETURN( cOBD)


*
*************FUNKCE  mh_DDMMYY vrátí datum ve tvaru DDMMRR***********
FUNCTION mh_DDMMYY( dDATE)
  LOCAL cDATE

  cDATE := DtoS(dDATE)
  cDATE := SubStr(cDate,7,2) +SubStr(cDate,5,2) +SubStr(cDate,3,2)
RETURN( cDATE)


*
*************FUNKCE  mh_DDMMYYYY vrátí datum v rùzném tvaru DDMMRRRR***********
FUNCTION mh_DDMMYYYY( dDATE, typ)
  LOCAL cDATE

  default typ to 0

  cDATE := DtoS(dDATE)
  do case
  case typ = 0   //DDMMRRRR
    cDATE := SubStr(cDate,7,2) +SubStr(cDate,5,2) +SubStr(cDate,1,4)
  case typ = 1   //DD-MM-RRRR
    cDATE := SubStr(cDate,7,2) +'-'+SubStr(cDate,5,2) +'-'+SubStr(cDate,1,4)
  case typ = 2   //DD/MM/RRRR
    cDATE := SubStr(cDate,7,2) +'/'+SubStr(cDate,5,2) +'/'+SubStr(cDate,1,4)
  case typ = 3   //DD.MM.RRRR
    cDATE := SubStr(cDate,7,2) +'.'+SubStr(cDate,5,2) +'.'+SubStr(cDate,1,4)

  case typ = 10   //RRRRMMDD
    cDATE := SubStr(cDate,1,4)+SubStr(cDate,5,2)+SubStr(cDate,7,2)
  case typ = 11   //RRRR-MM-DD
    cDATE := SubStr(cDate,1,4) +'-'+SubStr(cDate,5,2) +'-'+ SubStr(cDate,7,2)
  case typ = 12   //RRRR/MM/DD
    cDATE := SubStr(cDate,1,4) +'/'+SubStr(cDate,5,2) +'/'+ SubStr(cDate,7,2)
  case typ = 13   //RRRR.MM.DD
    cDATE := SubStr(cDate,1,4) +'.'+SubStr(cDate,5,2) +'.'+ SubStr(cDate,7,2)

  endcase

RETURN( cDATE)


*
*************FUNKCE  mh_FirstODate vrátí datum prvního dne v mìsíci*************
FUNCTION mh_FirstODate( nROK, nOBDOBI)
  LOCAL dDATE

  dDATE := cToD("1/" +Str( nOBDOBI) + "/" +Str( nROK))
RETURN( dDATE)


*
*************FUNKCE  mh_LastODate vrátí datum posledního dne v mìsíci***********
FUNCTION mh_LastODate( nROK, nOBDOBI)
  LOCAL dDATE
  LOCAL nN

  if nrok <> 0 .and. nobdobi <> 0
    nN    := mh_LastDayOM(CTOD( "01/"+ Str( nOBDOBI) +"/" + Str( nROK)))
    dDATE := cToD( Str(nN) +"/" +Str( nOBDOBI) + "/" +Str( nROK))
  else
    MsgBox( 'Chybnì zadaný rok nebo období !!!', 'CHYBA...' )
    dDATE := Date()
  endif

RETURN( dDATE)

*
*************FUNKCE  mh_DayODate vrátí datum dne v mìsíci***********
FUNCTION mh_DyaODate( nROK, nOBDOBI, nDEN)
  LOCAL dDATE
  LOCAL nN

  if nrok <> 0 .and. nobdobi <> 0 .and. nden <> 0
    dDATE := cToD( Str(nDEN) +"/" +Str( nOBDOBI) + "/" +Str( nROK))
  else
    MsgBox( 'Chybnì zadaný rok nebo období !!!', 'CHYBA...' )
    dDATE := Date()
  endif

RETURN( dDATE)


*
*************FUNKCE  CTVRTzOBDn vrátí ètvrtletí v numerickém formátu************
FUNCTION mh_CTVRTzOBDn( nOBDOBI)
  LOCAL anCtvrt := { 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4}
RETURN( IF( nOBDOBI >= 1 .AND. nOBDOBI <= 12, anCtvrt[ nOBDOBI], 0))


*
*************FUNKCE CTVRTzOBDc vrátí ètvrtletí v øímském formátu****************
FUNCTION mh_CTVRTzOBDc( nOBDOBI)
  LOCAL anCtvrt := { 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4}
  LOCAL nX, cRET

  nX   := IF( nOBDOBI >= 1 .AND. nOBDOBI <= 12, anCtvrt[ nOBDOBI], 0)
  cRET := IF( nX == 1, "I", IF( nX == 2, "II", IF( nX == 3, "III", "IV")))

RETURN( cRET)


*
*************FUNKCE LastDayOM vrátí poslední den v mìsíci***********************
FUNCTION mh_LastDayOM( dDATE)
  LOCAL nRET
  LOCAL aDAY := {31,28,31,30,31,30,31,31,30,31,30,31,29}

  nRET := IF(Month(dDATE)<>2,Month(dDATE),if(IsLeapYear(YEAR(dDate)),13,2))

RETURN( aDAY[nRET])


*
*************FUNKCE LastDayOBD vrátí poslední den v mìsíci***********************
FUNCTION mh_LastDayOBD( nROK, nOBDOBI)
  local nret

  nret := mh_LastDayOM( mh_FirstODate( nROK, nOBDOBI))

RETURN( nret)

* Spoèítá, do kterého týdne spadá dané datum
*===============================================================================
FUNCTION mh_WeekOfYear( dDate)
  Local nWeek := 0, nDAYs := 0, nHlp, x
  LOCAL aDAYs := {31,28,31,30,31,30,31,31,30,31,30,31}
  Local cFirstDay := '01/01/' + STR( YEAR ( dDate))
  Local nPos := DOW( CTOD( cFirstDay))

  * je-li pøestupný rok
  IF IsLeapYear( YEAR(dDate))
    aDAYs[ 2] := 29
  ENDIF
  * kterým dnem zaèíná rok
  nPos := IF( nPos = 1, 7, nPos - 1)
  nHlp := 7 - nPos + 1
  * Spoèítáme dny k danému datu
  FOR x := 1 TO MONTH( dDate) - 1
    nDAYs += aDAYs[ x]
  NEXT
  nDAYs += DAY( dDate)
  * spoèítáme týden
  nWEEK += IF( nHlp > 0, 1, 0)
  nWeek += INT( (nDAYs - nHlp) / 7 )
  IF (nDAYs - nHlp) > 0
    nWeek += IF( (nDAYs - nHlp) % 7  = 0, 0, 1 )
  ENDIF

RETURN nWeek


*
*************FUNKCE PØEVEDE DATUM a ÈAS na JULIANDATE ****************
************* bez parametrù pøevede aktuální datum a èas *************
FUNCTION mh_TOJULIANDATE( dDATE, cTIME)
  local a,b,c,e,f
  local nHod, nMin, nSec
  local njdn, njd

  DEFAULT dDATE TO Date()
  DEFAULT cTIME TO Time()

  rok := year( dDate )
  obd := month( dDate )
  den := day( dDate )

  nHod := Val( SubStr( ctime,1,2))
  nMin := Val( SubStr( ctime,4,2))
  nSec := Val( SubStr( ctime,7,2))

  a := Int(rok/100)
  b := A/4
  c := 2-a+b
  e := Int(365.25 * (rok+4716))
  f := Int(30.6001* (obd+1))

  njdn := c +den +e +f -1524.5
  njd  := njdn + ( Round((nHod-12/24),6) + Round( nMin/1440, 6)  + Round( nSec/86400,6))


RETURN( njd)


*
*************FUNKCE PØEVEDE JULIANDATE na DATUM a ÈAS  ****************
************* bez parametrù pøevede aktuální datum a èas *************
FUNCTION mh_FROMJULIANDATE( nJD )
  local rok, obd, den
  local hod, min, sec
  local nJDN
  local nJDtm
  local nCas
  local nZby, nTmCas, nKorekce
  local nrokbeg, nrokJDNbeg, nrokJDNend
  local lok := .t.
  local ckey
  local aRET[5]

  drgDBMS:open('kalendar',,,,,'kalendarq')

  njdn    := Int( nJD)
  nCas    := nJD - nJDN
  nrokTst := 2016

  if nCas > 0.5
    nKorekce := -12
    nJDtm    := njdn + 0.5
  else
    nKorekce :=  12
    nJDtm    := ( njdn -1) + 0.5
  endif

  do while lok
    cX         :=  '01.01.'+ Str(nRokTst,4)
    nrokJDNbeg :=  mh_TOJULIANDATE( CtoD(cX), '00:00:00')
    cX         :=  '01.01.'+ Str(nRokTst+1,4)
    nrokJDNend :=  mh_TOJULIANDATE( CtoD(cX), '00:00:00')

    do case
    case nJDtm = nrokJDNbeg
      rok := nrokTst
      den := 1
      lok := .f.

    case nJDtm > nrokJDNbeg .and. nJDtm < nrokJDNend
      rok := nrokTst
      den := ( nJDtm - nrokJDNbeg) - 1
      lok := .f.

    case nJDtm > nrokJDNend
      nrokTst++

    case nJDtm < nrokJDNbeg
      nrokTst--
    endcase

    if nrokTst < 1900 .or. nrokTst > 3000
      lok := .f.
    endif
  enddo

  ckey :=  StrZero( rok, 4, 0) + StrZero( den, 3, 0)

  if den > 0
    if kalendarq->( dbSeek( ckey,,'KALENDAR09'))
      aRET[1] := kalendarq->ddatum
      aRET[2] := DtoC( kalendarq->ddatum)
    endif
   endif

  if nCas > 0
    nCas   := nCas * 24
     hod   := Int( nCas) + nKorekce
    nCas   := ( nCas - Int(nCas)) * 60
     min   := Int( nCas)
    nCas   := ( nCas - Int(nCas)) * 60
     sec   := round( nCas, 0)

    aRET[3] := StrZero( hod, 2) + ':' + StrZero( min, 2) + ':' +StrZero( sec, 2)
  endif

  if den > 0 .and. nCas > 0
    aRET[4] := aRET[2] + ' ' + aRET[3]
    aRET[5] := mh_DaTi24_AMPM(aRET[2])
  endif

// aRET[1]   -  datum  (d) DD.MM.RRRR
// aRET[2]   -  datum  (c) DD.MM.RRRR
// aRET[3]   -  èas    (c) 00:00:00
// aRET[4]   -  datum a èas 24 hod (c) DD.MM.RRRR hh:mm:ss
// aRET[5]   -  datum a èas 12 hod (c) DD.MM.RRRR hh:mm:ss


RETURN( aRET)



// pøevede èas (HH:MM:SS) na sekundy
Function mh_timeSec( ctime)
  local  nsec

  nsec := ( Val( SubStr( ctime,1,2)) * 3600 ) +   ;
            ( Val( SubStr( ctime,4,2)) * 60 ) +   ;
              ( Val( SubStr( ctime,7,2)))

return( nsec)


// pøevede sekundy na èas (HH:MM:SS)
Function mh_secTime( nsec)
  local  ctime
  local  hod,min
  local  n,m

  hod := min := 0

  if ( n := Int(nsec/3600))  >=  0
    hod  := n
    nsec := nsec - ( n * 3600 )
  endif

  if ( n := Int(nsec/60)) >= 0
    min := n
    nsec := nsec - ( n * 60 )
  endif

  ctime := StrZero(hod,2) +':' +StrZero(min,2) +':' +StrZero(nsec,2)
return( ctime)


// vrátí datum a èas vetvaru rrrr-mm-ddThh:mm:ss+01:00 èas pro ÈR
Function mh_DateTime()
  local cx
  local oFilTime
  local ctime

//  oFilTime := FileTime:GetTimeStamp19()

//  cx := oFilTime:GetTimeStamp19()
//  cx := Ads_SetTimeStamp()
  ctime := AllTrim(Str(Day( Date()))) +'.'+ AllTrim(Str( Month( Date()))) + '.' + AllTrim(Str(Year( Date()))) + ' '
  ctime += Time()

return( ctime )


// pøevede datetime (t) z 12 hodinového cyklu (AM-PM) na 24 hodinový
Function mh_DaTiAMPM_24(tdatetime)
  local tdattim24
  local cTm

  tdatetime := isNull(tdatetime, '')
  if tdatetime <> ''
    cTm       := substr( tdatetime,12, 2)
    cTm       := if( Upper( Right( tdatetime, 2)) = 'PM', Str( Val(cTm) + 12, 2, 0), cTm)
    tdattim24 := substr( tdatetime, 1,10) + ' ' + cTm + substr( tdatetime,14, 6)
  endif

return( tdattim24)


// pøevede datetime (t) z 12 hodinového cyklu (AM-PM) na 24 hodinový
Function mh_DaTi24_AMPM(tdatetime)
  local tdattim12
  local cTm

  tdatetime := isNull(tdatetime, '')
  if tdatetime <> ''
    cTm       := substr( tdatetime, 12, 2)

    cTm       := if( Val( cTm) >= 12, 'AM' +  Str( Val(cTm)- 12, 2, 0), 'PM'+cTm )
    tdattim12 := substr( tdatetime, 1,10) + ' ' + cTm + substr( tdatetime, 14, 6)
  endif

return( tdattim12)


// vrátí datum a èas vetvaru rrrr-mm-ddThh:mm:ss+01:00 èas pro ÈR
Function mh_DateTimeXML()
  local cx
  local oFilTime
  local ctime

//  oFilTime := FileTime:GetTimeStamp19()

//  cx := oFilTime:GetTimeStamp19()
//  cx := Ads_SetTimeStamp()
  ctime := AllTrim(Str(Year( Date()))) + '-' +AllTrim(Str( Month( Date()))) + '-' +AllTrim(Str(Day( Date()))) + 'T'
  ctime += Time() + '+'+'01:00'

return( ctime )

*
*************FUNKCE TOKEN vrátí pole z øetìzce ********************************
FUNCTION mh_TOKEN(cStr, cSep, nStart)
  LOCAL  aRET := {}
  LOCAL  nSEP
  LOCAL  nLen := Len(cStr)
  LOCAL  inc  := 0
  LOCAL  nLenSep

  DEFAULT nStart TO 0
  DEFAULT cSep TO ','

  nLenSep := Len(cSep)

  if nLen > 0
    do while ( nSEP := At( cSep, cStr, nStart)) <> 0
      inc := if( nStart = 0, 1, 0)
      AAdd( aRET, SubStr( cStr, nStart, nSEP-nStart-inc))
      nStart := nSEP +nLenSep
    enddo
    if nSEP = 0 .and. nLen > 0
      inc := if( nStart = 0, 0, 1)
      AAdd( aRET, SubStr( cStr, nStart, nLen-nStart+inc))
    endif
  endif
RETURN( aRET)



*
*************FUNKCE LIKE bude až ve verzi 1.9***********************************
FUNCTION mh_LIKE(cWld,cStr)
  LOCAL  cC, cF, cL
  LOCAL  lOk

  cC := STRTRAN(cWld,'*','')
  cF := LEFT(cC,1)
  cL := RIGHT(cC,1)

  lOk := ( (AT(cF,cStr) <> 0) .and. (RAT(cL,cStr) <> 0) )
RETURN(lOk)


*
*************KOPIE POLOZEK DB -> DB********************************************
function mh_COPYFLD(cDBFrom,cDBTo, lDBApp, IsMain, aLock, Uniq)
  Local  nPOs, nUni, azamky, xVal, cItem
  Local  aFrom := (cDBFrom) ->( dbStruct())
  *
  local  x, a_noCpy := {'cuniqidrec', 'muserzmenr', 'sid' }

  Default lDBApp To .F., IsMain TO .F., Uniq  TO .T.

  if ldbapp
    if .not. (cdbto)->(DbLocked())
      azamky := (cdbto)->(DbRLockList())

      (cdbto)->(DbAppend())
      aadd(azamky, (cdbto)->(recno()))
      (cdbto)->(sx_rlock(azamky))
    else
      (cdbto)->(DbAppend())
    endif
  endif

  * pøi kopii záznamu  W -> W se nesmí naplnit _nrecor z cDBFrom
***  if( Ismain, nil, aadd( a_noCpy, '_nrecor' ) )

  for x := 1 to len(aFrom) step 1
    cItem := aFrom[x,DBS_NAME]
    if AScan(a_noCpy,lower(cItem)) = 0
      if(nPos := (cDBTo)->( FieldPos( aFrom[x,DBS_NAME]))) <> 0
        if .not. isNull(xVal := (cDBFrom) ->( FieldGet(x)))
          (cDBTo) ->( FieldPut( nPos, xVal))
        endif
      endif
    endif
  next
  *
  ** zavedena konvence u TMP položka _nrecor pro zámky pøi ukládání //
  IF IsMain .and. (nPOs := (cDBTo) ->(FieldPos('_nrecor'))) <> 0 .and. !(cDBFrom) ->(EOF())
    (cDBTo) ->(FieldPut(nPOs, (cDBFrom) ->(RecNo())))
    IF(IsARRAY(aLock), AAdd(aLock,(cDBFrom) ->(RecNo())),NIL)
  ENDIF
  *
  ** zavenena konvence u TMP položka _nsidor - vazba na sID u základního souboru
  if ( npos := (cDBTo)->( FieldPos( '_nsidor'))) <> 0 .and. !(cDBFrom) ->(EOF())
    if (cDBFrom)->( FieldPos( 'sid' )) <> 0
      (cDBTo) ->( FieldPut( npos, isNull( (cDBFrom)->sID, 0) ))
    endif
  endif

  mh_WRTzmena( cDBTo, lDBApp)
Return( Nil)


*
**************VYPRÁZDNÌNÍ ZÁZNAMU**********************************************
Function mh_BLANKREC(cALIAs,nPOs,setUloha,delRec)
  Local  nFLD, nFLDc := ( cALIAs) ->( FCOUNT())
  Local  xVAL, aSTRU := ( cALIAs) ->( dbSTRUCT())

  DEFAULT nPOs TO 1, setUloha TO .F., delRec TO .F.

  For nFLD := nPOs TO nFLDc STEP 1
    Do Case
    Case aSTRU[ nFLD, DBS_TYPE ] == 'C' .OR. ;
         aSTRU[ nFLD, DBS_TYPE ] == 'M' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] >= 6 )
      xVAL := ''
    Case aSTRU[ nFLD, DBS_TYPE ] == 'N' .OR. ;
         aSTRU[ nFLD, DBS_TYPE ] == 'F' .OR. ;
         aSTRU[ nFLD, DBS_TYPE ] == 'I' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] == 4 )
      xVAL := 0
    Case aSTRU[ nFLD, DBS_TYPE ] == 'D' .OR. ;
         ( aSTRU[ nFLD, DBS_TYPE ] == 'V' .AND. aSTRU[ nFLD, DBS_LEN ] == 3 )
      xVAL := CTOD( '')
    Case aSTRU[ nFLD, DBS_TYPE ] == 'L'
      xVAL := .F.
    EndCase
      ( cALIAs) ->( FieldPUT( nFLD, xVAL))
  Next

  IF(setUloha, (cALIAs) ->cULOHA := '!', NIL)
  IF(delRec  , (cALIAs) ->(DbDelete()) , NIL)
Return( Nil)


*
**************SEEK S POZADAVKEM TAG ********************************************
Function mh_SEEK(xExpKEY,nOrdNO,lOrORD,lLastKEY,lCS_UP)
  Local  nOrdOLD
  Local  xSeaKEY
  Local  lDONE, lDELETED := SET( _SET_DELETED, .T.)

  Default nOrdNO To 1, lOrORD To .F., lLastKEY To .F., lCS_UP To .T.
  xSeaKEY := If( IsCHARACTER( xExpKEY) .and. lCS_UP, UPPER( xExpKEY), xExpKEY )

  nOrdOld   := AdsSetOrder( nOrdNo)
*-  lDone     := If( lLastKEY, SX_SeekLAST( xSeaKEY), dbSeek( xSeaKey))
  lDone     := If( lLastKEY, mhx_SeekLast(xSeaKEY), dbSeek( xSeaKey))

  If( lOrOrd, AdsSetOrder( nOrdOld), Nil )
  SET( _SET_DELETED, lDELETED)
Return( lDone)


static function mhx_SeekLast(xValue)
  dbSetScope(SCOPE_BOTH, xValue)
  dbGoBottom()

  dbClearScope()
return .t.


*           FAKPRIDH + FAKPRIHD specialitka pro nKURzahMEN <> nKURzahMED
*********************** specialitka pro PÁROVÁNÍ záloh *************************
Function mh_FAKPRI(cFILE_M)
  Local  nPOs, nSUMAdan := 0
  Local  nKOe, nPARZALFAK

  If( nPOs := (cFILE_M) ->( FIELDPOS( 'nSUMAdan'))) <> 0
    nSUMAdan := (cFILE_M) ->(FIELDGET(nPOs))
  EndIf

  If (cFILE_M) ->( FIELDPOS('nSAZdaz_1')) <> 0
    nSUMAdan += ((cFILE_M) ->nSAZdaz_1 +(cFILE_M) ->nSAZdaz_2)
  EndIf


  IF UPPER(cFILE_M) = 'FAKPRIHD'
    IF (cFILE_M) ->nFINTYP == 6     // EU zatím //
      nKOe       := (cFILE_M) ->nKURzahMEN/ (cFILE_M) ->nMNOZprep
      nPARZALFAK := (cFILE_M) ->nPARZAHFAK * nKOe

      nSUMAdan   += ( nPARZALFAK -(cFILE_M) ->nPARZALFAK )
    ENDIF
  ENDIF
Return(nSUMAdan)


*              ALGORITMY ZAOKROUHLOVÁNÍ
********************************************************************************
Function mh_ROUNDNUMB(nNumber, nAlgor)
  LOCAL nX, nY
  LOCAL nPos, nRoundNumb, nSIGN := If( nNumber >= 0, 1, -1)
  LOCAL anAlgor := ;
     { {  0, 0, 0 } ,;
       { 11, 2,  0.0049 }, { 12, 2, 0.00 }, { 13, 2,  -0.0050 }, { 14, 0,     0.10 },  ;
       { 21, 1,  0.0499 }, { 22, 1, 0.00 }, { 23, 1,  -0.050  }, { 24, 0,     1.00 },  ;
       { 31, 0,  0.49   }, { 32, 0, 0.00 }, { 33, 0,  -0.50   }, { 34, 0,    10.00 },  ;
       { 41,-1,  4.99   }, { 42,-1, 0.00 }, { 43,-1,  -5.00   }, { 44, 0,   100.00 },  ;
       { 51,-2, 49.99   }, { 52,-2, 0.00 }, { 53,-2, -50.00   }, { 54, 0,  1000.00 },  ;
       { 61,-3,499.99   }, { 62,-3, 0.00 }, { 63,-3,-500.00   }, { 64, 0, 10000.00 } }
  LOCAL anAlgor21 := { 0.1, 1, 10, 100, 1000, 10000 }
  LOCAL n1, n2, n3
  LOCAL ndelnull := 0


  If( nAlgor = 91, nAlgor := 222, NIL )

  IF nAlgor < 100
    do case
    case nAlgor >= 45 .and. nAlgor <= 47
      ndelnull := 10
    case nAlgor >= 55 .and. nAlgor <= 57
      ndelnull := 100
    case nAlgor >= 65 .and. nAlgor <= 67
      ndelnull := 1000
    endcase

    if nNumber <> 0
      nAlgor -= if(ndelnull > 0, 4, 0)
      aEval( anAlgor, { |x, n | nPos := If( x[ 1] == nAlgor, n, nPos) } )
      nRoundNumb := If ( nPos == 1 , nNumber ,;
                       Round( ABS( nNumber) + anAlgor[ nPos, 3], anAlgor[ nPos, 2] ) * nSIGN)
      if ndelnull > 0
        nRoundNumb := nRoundNumb/ndelnull
      endif
    else
      nRoundNumb := 0
    endif
  ELSE
    n1 := Val(  SubStr( Str( nAlgor, 3), 1, 1))
    n2 := Val(  SubStr( Str( nAlgor, 3), 2, 1))
    n3 := Val(  SubStr( Str( nAlgor, 3), 3, 1))

    nX         := ABS(nNumber / anAlgor21[ n1])
    nRoundNumb := ABS( Int( nX))
    nY         := nX - nRoundNumb

    DO CASE
    CASE n2 = 1  // nahoru
      DO CASE
      CASE n3 = 1   // na èvrtiny
        DO CASE
        CASE nY == 0.00  ;  nRoundNumb := nRoundNumb
        CASE nY <= 0.25  ;  nRoundNumb := nRoundNumb + 0.25
        CASE nY <= 0.5   ;  nRoundNumb := nRoundNumb + 0.5
        CASE nY <= 0.75  ;  nRoundNumb := nRoundNumb + 0.75
        OTHERWISE        ;  nRoundNumb := nRoundNumb + 1
        ENDCASE

      CASE n3 = 2   // na poloviny
        DO CASE
        CASE nY == 0.00  ;  nRoundNumb := nRoundNumb
        CASE nY <= 0.5   ;  nRoundNumb := nRoundNumb + 0.5
        OTHERWISE        ;  nRoundNumb := nRoundNumb + 1
        ENDCASE
      ENDCASE

    CASE n2 = 2  // dolú
      DO CASE
      CASE n3 = 1   // na ètvrtiny
        DO CASE
        CASE nY >= 0.125 .AND. nY < 0.375  ;  nRoundNumb := nRoundNumb + 0.25
        CASE nY >= 0.375 .AND. nY < 0.625  ;  nRoundNumb := nRoundNumb + 0.5
        CASE nY >= 0.625 .AND. nY < 0.875  ;  nRoundNumb := nRoundNumb + 0.75
        CASE nY >= 0.875                   ;  nRoundNumb := nRoundNumb + 1
        ENDCASE

      CASE n3 = 2   // na poloviny
        DO CASE
        CASE nY >= 0.25 .AND. nY < 0.75    ;  nRoundNumb := nRoundNumb + 0.5
        CASE nY >= 0.75                    ;  nRoundNumb := nRoundNumb + 1
        ENDCASE
      ENDCASE

    CASE n2 = 3
      DO CASE
      CASE n3 = 1
        DO CASE
        CASE nY >= 0.75  ;  nRoundNumb := nRoundNumb + 0.75
        CASE nY >= 0.5   ;  nRoundNumb := nRoundNumb + 0.5
        CASE nY >= 0.25  ;  nRoundNumb := nRoundNumb + 0.25
        ENDCASE

      CASE n3 = 2
        IF nY >= 0.5     ;  nRoundNumb := nRoundNumb + 0.5
        ENDIF
      ENDCASE
    ENDCASE

    nRoundNumb := (nRoundNumb * anAlgor21[ n1]) * nSIGN
  ENDIF
RETURN( nRoundNumb)


*           FAKPRIDH + FAKPRIHD specialitka pro nKURzahMEN <> nKURzahMED
*********************** specialitka pro PÁROVÁNÍ záloh *************************
Function mh_JOINUPSTR(str1,sep1,str2,sep2,str3,sep3,str4,sep4,str5)
  Local  cRET

  DEFAULT sep1 TO "" ; DEFAULT sep2 TO ""; DEFAULT sep3 TO ""; DEFAULT sep4 TO ""
  DEFAULT str1 TO "" ; DEFAULT str2 TO ""; DEFAULT str3 TO ""
  DEFAULT str4 TO "" ; DEFAULT str5 TO ""

  cRET := AllTrim(str1) +if( !Empty(str2),sep1 +AllTrim(str2)              ;
                          +if( !Empty(str3),sep2 +AllTrim(str3)            ;
                           +if( !Empty(str4),sep3 +AllTrim(str4)           ;
                            +if( !Empty(str5),sep4 +AllTrim(str5)          ;
                                 ,""),""),""),"")

RETURN( cRET)

/*
Function mh_GetLastUniqID()
  LOCAL cRET, cTAG, nREC, FILE := Alias()


  if (FILE)->(FieldPos('cUniqIdRec')) > 0
    ( nREC := (FILE)->(Recno()), cTAG := (FILE)->(AdsSetOrder( 'UniqeIdRec')) ;
      , (FILE)->(DbGoBottom()))
    cRET := drgParse((FILE)->(DbInfo( DBO_FILENAME)),'.')
    cRET := UPPER( SubStr(cRET, Rat("\",cRET)+1))
    cRET := StrZero(usrIdDB,6) +Padr(cRET,10)+ StrZero( Val(Right((FILE)->cUniqIdRec,10))+1, 10)
    ((FILE)->(AdsSetOrder( cTAG)), (FILE)->(dbGoTo( nREC)))
    (FILE)->cUniqIdRec := cRET
  endif


RETURN(NIL)


Function mh_COPYRLV(cDBFrom,cDBTo)
  Local  nPOs, nUni, n
  Local  xVAL
  Local  aFrom := ( cDBFrom) ->( dbStruct())

  nUni := ( cDBTo) ->( FieldPos('cRlUniqId'))

  if nUni <> 0
    if !( cDBTo)->( dbSeek( Upper((cDBFrom)->cUniqIdRec ),, 'RlUniqId'))
      (cDBTo)->( ADDrec(), mh_GETLASTuniqID())
      (cDBTo)->CRLUNIQID   := (cDBFrom)->cUniqIdRec
      (cDBFrom)->CRLUNIQID := (cDBTo)->cUniqIdRec
    else
      (cDBTo) ->( dbRLock())
    endif

    nUni := ( cDBTo) ->( FieldPos('cUniqIdRec'))
    for n := 1 to Len(aFrom)
      xVal := ( cDBFrom)->( FieldGet( n))
      nPos := ( cDBTo  )->( FieldPos( aFrom[n,DBS_NAME]))
      do case
      case Upper(aFrom[n,DBS_NAME]) == 'COUUNIQID'
        ( cDBTo  )->CINUNIQID := ( cDBFrom)->COUUNIQID
      case Upper(aFrom[n,DBS_NAME]) == 'CINUNIQID'
        ( cDBTo  )->COUUNIQID := ( cDBFrom)->CINUNIQID
      case Upper(aFrom[n,DBS_NAME]) == 'CRLUNIQID' .or.                       ;
            Upper(aFrom[n,DBS_NAME]) == 'CUNIQIDREC'
      otherwise
        if( npos > 0, ( cDBTo)->( FieldPut( nPos, xVal)), NIL)
      endcase
    next

    (cDBTo) ->( dbUnLock())
  endif

Return( Nil)


//   zrušení vzájemné vazby
Function mh_DELRLV()
  LOCAL cRET, nREC, FILE := Alias()
  LOCAL FILErel

  if (FILE)->(FieldPos('cRlUniqId')) > 0
    FILErel :=AllTrim(Substr((FILE)->cRlUniqId,7,10))
    drgDBMS:open(FILErel)
    if (FILErel)->(dbSeek((FILE)->cRlUniqId,, 'RlUniqId' ))
      (FILErel)->( DElRec())
    endif
  endif

RETURN(NIL)

*/

//   vrátí poèet záznamù uvnitø filtru
Function mh_COUNTREC()
  LOCAL nREC, nRET := 0

  ( nREC := Recno(), dbGoTop(), dbEval({|| nRET++}), dbGoTo(nREC))

RETURN(nRET)

*
*===============================================================================
FUNCTION mh_RyoFILTER( aRECs, cAlias )
  LOCAL cFILTER := '', cTAG

  DEFAULT cALIAS TO ALIAS( Select())

  AEval( aRECs, {|X| cFILTER += 'RECNO() = ' + STR(X) + ' .or. ' })
  cFILTER := LEFT( cFILTER, LEN(cFILTER) -6)
  cFILTER := IF( EMPTY( cFILTER), 'RECNO() = 0', cFILTER )
  cTAG := ( cALIAS)->( AdsSetOrder(0))
  ( cALIAS)->( Ads_SetAOF( cFILTER ))
  ( cALIAS)->( AdsSetOrder( cTAG), dbGoTOP() )
RETURN NIL


Function mh_Append()
  LOCAL cRET, nREC, file := Alias()

  (file)->( DbAppend( ))
Return( Nil)


*
** náhrada seqence AdsSetOrder -> dbSetScoope SCOPE_BOTH -> dbGoTop
function mh_ordSetScope(xScope, xIndexOrder, lgoTop)

  default lgoTop to .t.

  if( isNull(xIndexOrder), nil, AdsSetOrder(xIndexOrder))
  dbSetScope(SCOPE_BOTH, xScope)

  if( lgoTop, dbGoTop()    , nil)
return .t.