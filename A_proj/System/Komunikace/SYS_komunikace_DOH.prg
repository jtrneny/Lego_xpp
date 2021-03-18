#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"

#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )
#pragma Library( "HrfClass.lib" )

#define BUFFER_SIZE  2^16

static oExcel


// Export dat do docházkového terminálu SAFESCAN
function DIST000121( oxbp ) // oxbp = drgDialog
  local  oThread, lview := .not. Empty(oxbp)
  local  cAdrTerm, cUser, cPassw
  local  ccnbHost
  local  cString
  local  curl_UTF8, curl_ANSI, pa, x
  local  nTarget, cBuffer, nBytes
  local  cdirW, cTargetFile
  local  oDocument, oListElement
  local  i, j, n
  local  dbegin, dend
  local  auser := {}
  local  otmp
  local  ckey
  local  newID
  local  cx

*
*  local  cpath, in_Dir, cc := 'Umístnìní importovaných dat - kusovníkù...'
*  local  odialog, nexit := drgEVENT_QUIT

  if .not. lview
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif
  endif

  cAdrTerm := "http://"+ AllTrim(odata_datKom:AdrTerm)
  cUser    := AllTrim(odata_datKom:User)
  cPassw   := AllTrim(odata_datKom:Passw)

  if .not. lview
    cx     := 'Administrátor\' + dataADRfi + '\TMP'
    cdirW  := StrTran(drgINI:dir_USERfitm, 'TMP',cx)
  else
    drgMsgBox(drgNLS:msg('Probíhá export dat do snímaèe.'), XBPMB_INFORMATION)
    cdirW  := drgINI:dir_USERfitm +userWorkDir()
  endif

  ctargetfile := cdirW +"tm_safescan.html"

  drgDBMS:open('osoby',,,,,'osobya')
  drgDBMS:open('d_safescan')

  newID := 1

  ccnbHost := cAdrTerm + "/csl/user"
  curl_UTF8 := loadFromUrl(ccnbHost)

  if ( nTarget := FCreate( cTargetFile, FC_NORMAL ) ) == -1
    drgDump( 'Jsem uvnitø DIST000121 - nejde založit '+cTargetFile + CRLF)
    RETURN 0
  endif

  cBuffer := curl_UTF8
  nBytes  := Len( cBuffer)
  FWrite( nTarget, Left(cBuffer, nBytes) )
  FClose( nTarget )

  oDocument    := HTMLDocument():loadFile( ctargetfile )
  oListElement := oDocument:getElementById( "cc" )
  otmp := oListElement:aochildlist[1]

  if .not. Empty( otmp:rows)
    for i := 1 to Len( otmp:rows)
      AAdd( auser, { otmp:rows[i]:cells[1]:Value,otmp:rows[i]:cells[2]:Value, ;
                     otmp:rows[i]:cells[3]:Value,otmp:rows[i]:cells[4]:Value, ;
                     otmp:rows[i]:cells[5]:Value,otmp:rows[i]:cells[6]:Value, ;
                     otmp:rows[i]:cells[7]:Value,otmp:rows[i]:cells[8]:Value  })

      newId := if( newId < Val(auser[i,1]), Val( auser[i,1]), newId)
    next
  endif

  fErase( ctargetfile)

//  filtr  := format( "cIdOsKarty = %%", { 3 })
//  osobya->( ads_setAof("cIdOsKarty <> '' and nis_doh = 1"), dbgoTop())
  osobya->( ads_setAof("nis_doh = 1"), dbgoTop())
   do while .not. osobya->( eof())
     if ( n := aScan( auser, { |X| AllTrim(X[5]) == AllTrim(osobya->cIdOsKarty)})) = 0
     // pøidání nového záznamu
       newId++
       ccnbHost := cAdrTerm + "/csl/user?action=save&id=add"
       cvar     := "upin2="+ Str(newId)+"&uname="+Left(osobya->czkrosob,8)+"&udpm=''"+  ;
                    "&uprivilege=User&upvd=0&ucard="+AllTrim(osobya->cIdOsKarty)
       loadFromUrl(ccnbHost,,,,,"POST", cvar)
//       drgDump( "nový - " + cvar + CRLF)
     else
       // modifikace záznamu
       if auser[n,3] <> Left(osobya->czkrosob,8) .or.   ;
           auser[n,4] <> osobya->ckmenstrpr
         ccnbHost := cAdrTerm + "/csl/user?action=save&id=modify"
         cvar     := "upin=" + auser[n,1] +"&upin2=" +auser[n,1] +"&uname=" +          ;
                      Left(osobya->czkrosob,8) + "&udpm=''" +"&uprivilege=User" +"&upvd=2&ucard=" + ;
                      AllTrim(osobya->cIdOsKarty)
         loadFromUrl(ccnbHost,,,,,"POST", cvar)
       endif
     endif

     osobya->( dbSkip())
   enddo

   for i := 2 to Len( auser)
     if .not. osobya->( dbSeek( auser[i,5],,'Osoby22'))
       //  zrušení záznamu
       ccnbHost := cAdrTerm + "/csl/user?action=del&uid=" + AllTrim(auser[i,1])
       loadFromUrl(ccnbHost)
     endif
   next

  osobya->(ads_clearAof())

  if lview
    drgMsgBox(drgNLS:msg('Export dat do snímaèe skonèil!!!'), XBPMB_INFORMATION)
  endif

return(NIL)


// Import dat z docházkovýcho terminálù SAFESCAN
function DIST000122( oxbp ) // oxbp = drgDialog
  local  oThread, lview := .not. Empty(oxbp)
  local  cAdrTerm, cUser, cPassw
  local  ccnbHost
  local  cString
  local  curl_UTF8, curl_ANSI, pa, x
  local  nTarget, cBuffer, nBytes
  local  cdirW, cTargetFile
  local  oDocument, oListElement
  local  i, j, q
  local  dbegin, dend
  local  auser := {}
  local  otmp
  local  ckey
  local  dTmBegin, dDnes
  local  cx
  local  nrok, nobdobi
  local  nlenit
*
  nrok    := uctOBDOBI:DOH:NROK
  nobdobi := uctOBDOBI:DOH:NOBDOBI

  if .not. lview
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      drgMsgBox(drgNLS:msg('Probíhá import dat ze snímaèe za celé období.'), XBPMB_INFORMATION)
      odata_datKom := oThread:odata_datKom
    endif
  endif

  cAdrTerm := "http://"+ AllTrim(odata_datKom:AdrTerm)
  cUser    := AllTrim(odata_datKom:User)
  cPassw   := AllTrim(odata_datKom:Passw)

  if .not. lview
    cx     := 'Administrátor\' + dataADRfi + '\TMP'
    cdirW  := StrTran(drgINI:dir_USERfitm, 'TMP',cx)
//    cdirW       := drgINI:dir_USERfitm +userWorkDir()
  else
    cdirW       := drgINI:dir_USERfitm +userWorkDir()
  endif

  ctargetfile := cdirW +"tm_safescan.html"

  drgDBMS:open('d_safescan')

  ccnbHost := cAdrTerm + "/csl/user"
  curl_UTF8 := loadFromUrl(ccnbHost)

  if ( nTarget := FCreate( cTargetFile, FC_NORMAL ) ) == -1
    RETURN 0
  endif

  cBuffer := curl_UTF8
  nBytes  := Len( cBuffer)
  FWrite( nTarget, Left(cBuffer, nBytes) )
  FClose( nTarget )

  oDocument    := HTMLDocument():loadFile( ctargetfile )
  oListElement := oDocument:getElementById( "cc" )
  otmp := oListElement:aochildlist[1]
  if .not. Empty( otmp:rows)
    for i := 1 to Len( otmp:rows)
      AAdd( auser, { otmp:rows[i]:cells[1]:Value,otmp:rows[i]:cells[2]:Value, ;
                     otmp:rows[i]:cells[3]:Value,otmp:rows[i]:cells[4]:Value, ;
                     otmp:rows[i]:cells[5]:Value,otmp:rows[i]:cells[6]:Value, ;
                     otmp:rows[i]:cells[7]:Value,otmp:rows[i]:cells[8]:Value  })
    next
  endif

  fErase( ctargetfile)

  nlenit := if( lview, mh_LastDayOBD( nROK, nOBDOBI), 1)

  for q := 1 to nlenit
    if lview
      dDnes := CTOD(StrZero(q,2)+ '.' + StrZero(nobdobi,2) + '.' + StrZero(nrok,4))
    else
      dDnes := Date()
    endif

    if Month(dDnes) = 1
      dTmBegin := mh_LastODate( Year(dDnes)-1, 12)
    else
      dTmBegin := mh_LastODate( Year(dDnes), Month(dDnes)-1)
    endif

    ccnbHost := cAdrTerm + "/csl/query?action=run&"
    dbegin   := mh_DDMMYYYY( dTmBegin, 11)
    dend     := mh_DDMMYYYY( dDnes,    11)

    for i := 1 to Len( auser)
      cTm := "uid="+ auser[i,1] +"&sdate=" + dbegin + "&edate=" + dend
      curl_UTF8 := loadFromUrl(ccnbHost + cTm)

      if ( nTarget := FCreate( cTargetFile, FC_NORMAL ) ) == -1
        RETURN 0
      endif

      cBuffer := curl_UTF8
      nBytes  := Len( cBuffer)
      FWrite( nTarget, Left(cBuffer, nBytes) )
      FClose( nTarget )

      oDocument := HTMLDocument():loadFile( ctargetfile )

      otmp := oDocument:aochildlist[1]:aochildlist[2]:aochildlist[1]

  //    drgDump( otmp + CRLF)

      for j := 2 to Len( otmp:rows)
        ckey := Padr(AllTrim(otmp:rows[j]:cells[1]:value),10)    +  ;
                 StrZero( Val(otmp:rows[j]:cells[2]:value),10)   +  ;
                 Padr(AllTrim(otmp:rows[j]:cells[4]:value), 8)   +  ;
                  Padr(AllTrim(otmp:rows[j]:cells[5]:value),10)  +  ;
                   Padr(AllTrim(otmp:rows[j]:cells[6]:value),10)

  //    drgDump( 'Naèítám data: ' + ckey + CRLF)
        if .not. d_safescan->( dbSeek( ckey,,'safescan05'))
          d_safescan->( dbAppend())

          d_safescan->date       := otmp:rows[j]:cells[1]:value
          d_safescan->id_number  := Val(otmp:rows[j]:cells[2]:value)
  //        d_safescan->name       := otmp:rows[j]:cells[3]:value
          d_safescan->time       := otmp:rows[j]:cells[4]:value
          d_safescan->status     := otmp:rows[j]:cells[5]:value
          d_safescan->verific    := otmp:rows[j]:cells[6]:value
    *
          d_safescan->userid     := auser[i,5]

          x := otmp:rows[j]:cells[1]:value
          d_safescan->timeentry  := SubStr(x,9,2) +'.' + SubStr(x,6,2) +'.' +  ;
                                     SubStr(x,1,4) +' ' + otmp:rows[j]:cells[4]:value
          d_safescan->eventid    := otmp:rows[j]:cells[5]:value
          d_safescan->terminalsn := '0252513030115'     // pozor je to tvrdost pro AGRONET

          d_safescan->(dbCommit())
        endif
      next
      fErase( ctargetfile)
    next
  next

  if lview
    drgMsgBox(drgNLS:msg('Import dat ze snímaèe skonèil !!!'), XBPMB_INFORMATION)
  endif

return(NIL)