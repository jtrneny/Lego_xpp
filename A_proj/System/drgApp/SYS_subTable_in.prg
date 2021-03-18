#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
#include "..\Asystem++\Asystem++.ch"


STATIC  pa_inSections, pa_Function, pa_subTable


*
** CLASS for sys_subTable_in *****************************************************
CLASS sys_subTable_in FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  getForm

  * bro col for c_bankuc
  inline access assign method stav_pripominky() var stav_pripominky
    return c_staPri->nBitMap

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case (nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE)
      return .t.

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := c_stapri->nstaPripom
        return .t.
      endif

    case(nevent = drgEVENT_MSG)
      if mp2 = DRG_MSG_ERROR
         _clearEventLoop()
         SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
         return .t.
      endif
      return .f.

    endcase
  return .f.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch
ENDCLASS


method sys_subTable_in:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

  ::lsearch := (::drgGet <> NIL)
  ::drgUsrClass:init(parent)
return self


method sys_subTable_in:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += if( ::lsearch, ' - VÝBÌR ...', '' )
return self


method sys_subTable_in:getForm()
 local  oDrg, drgFC


  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 70,15.2 DTYPE '10' TITLE 'Seznam stavu pøiponínek _ výbìr' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 110,13 FILE 'c_stapri'     ;
             FIELDS 'M->stav_pripominky::2.7::2,'                + ;
                    'nStaPripom:stav,'                           + ;
                    'cNazStaPri:název typu pøipomínky:63'          ;
             SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

return drgFC



method sys_subTable_in:drgDialogStart(drgDialog)
  local aPP  := drgPP:getPP(2), oColumn, x

  ::brow    := drgDialog:dialogCtrl:oBrowse[1]
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form
  if isobject(drgDialog:oActionBar)
    ::ab      := drgDialog:oActionBar:members    // actionBar
  endif

  if ::lsearch
    for x := 1 TO ::brow:oXbp:colcount
      ocolumn := ::brow:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    next

    if .not. c_stapri->(dbseek(::drgGet:ovar:value,,'C_STAPRI01'))
      c_stapri->(dbgoTop())
    endif
    ::brow:oXbp:refreshAll()
  endif

  read_Desing()
return


method sys_subTable_in:postLastField(drgVar)
return .t.


** pro subTable **
procedure read_Desing()
  local  buffer := strTran( MemoTran( memoRead('c:\A_work\LL23\Report_Container_My\subTable.txt' ), chr(0)), ' ', '' )
  local  n, cname

  pa_subTable := {}

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) = '['
      cname := lower(substr(buffer,2,n -3))

      do case
      case cname = 'subtables'
        subTable(substr(buffer, n +1))
      endcase

    endif
    buffer := substr(buffer, n +1)
  end
return


procedure subTable(buffer)
   local  n
   local  nstep, pa
   local         pb, cvyraz, citem
   local  npos,  parent
   local         pc, x, cc, nlen, cfield_1, crel, cfield_2
   local  caof := ""
   *
   local  pa_it
   * pro test
   local  odbd, odesc_1, odesc_2

   while(asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0)
     if Left(buffer,1) = '['
       cname := lower(substr(buffer,2,n -3))
       if cname = 'endsubtables'
         buffer := substr(buffer, n +1)
         return
       endif
     endif
*               subTable
*                   order
*                       mainTable
*                           aof
*                               forAof
*
     pa_it := { '', '', '', '', {} }
     pa    := ListAsArray(lower(substr(buffer,1,n -1)),')')

     for nstep := 1 to len(pa)-1 step 1
       pb := listAsArray(pa[nstep], '(' )

       isOk   := .t.
       cvyraz := pb[1]
       citem  := pb[2]

       do case
       case cvyraz = 'select'                    // soubor musí existovat drgDBMS:getDBD(cfile)
         odbd     := drgDBMS:getDBD(citem)
         pa_it[1] := citem

       case cvyraz = 'orderby'                   // zkusíme najít TAG, ale pokud neexistuje asi tøídit, na to bacha, položky musí existovat dbgDBMS:getFieldDesc(alias->cfield)
         pa_it[2] := citem

       case cvyraz = 'restricton'                // soubor a za ním : (dvojTeèka) urèuje master pro omezení, lze použít klauzuli >, <, >=, <=, <>, = a spojení or nebo and
         caof     := ""
         npos     := at(':', citem )
         parent   := substr(citem, 1, npos-1)    // souobot musí existovat drgDBMS:getDBD(cfile)
         odbd     := drgDBMS:getDBD(citem)
         pa_it[3] := parent

         clist := substr(citem,    npos+1)       // ndoklad=ndoklad.and.cobdobi=cobdobi
            pc := listAsArray( clist, '.' )

         for x := 1 to len(pc) step(1)
           cc := pc[x]

           if( cc = 'or' .or. cc = 'and' )
             caof += ' ' +cc +' '
           else

            nlen := 1
            do case
            case( npos := at( '=' , cc)) <> 0
            case( npos := at( '>' , cc)) <> 0
            case( npos := at( '<' , cc)) <> 0
            case( npos := at( '>=', cc)) <> 0 ; nlen := 2
            case( npos := at( '>=', cc)) <> 0 ; nlen := 2
            case( npos := at( '<>', cc)) <> 0 ; nlen := 2
            endcase

*           cfield_1-cfield_2 musí existovat, shodný typ, cfield_2 se pøesetuje na %%(N) nebo '%%'(C)
            cfield_1 := subStr(cc,    1, npos-1)
            crel     := subStr(cc, npos, nlen  )
            cfield_2 := subStr(cc, npos+nlen   )

            odesc_1 := drgDBMS:getFieldDesc(parent,cfield_1)
            odesc_2 := drgDBMS:getFieldDesc(parent,cfield_2)

            if isObject(odesc_1) .and. isObject(odesc_2)
              if odesc_1:type = odesc_2:type
                cc := if(odesc_1:type = 'N', '%%', "'%%'" )
              endif
            endif

            caof  += cfield_1 +' '+crel+' ' +cc    //  cfield_2 pro format
            aadd( pa_it[5], parent +'->' +cfield_2 )
           endif
         next

         pa_it[4] := caof
       endcase
     next

     aadd( pa_subTable, pa_it )
     buffer := substr(buffer, n +1)
   enddo
return