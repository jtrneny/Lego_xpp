#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"



*
** CLASS for c_naklsto_sel ****************************************************
CLASS c_naklst_sel FROM drgUsrClass
exported:
  method  init, getForm, drgDialogInit, drgDialogStart

  *
  **
  inline access assign method cnazPol1 var cnazPol1
    return if( len(::aval) = 0, c_naklst->cnazPol1, ::aval[1])

  inline access assign method cnazPol2 var cnazPol2
    return if( len(::aval) = 0, c_naklst->cnazPol2, ::aval[2])

  inline access assign method cnazPol3 var cnazPol3
    return if( len(::aval) = 0, c_naklst->cnazPol3, ::aval[3])

  inline access assign method cnazPol4 var cnazPol4
    return if( len(::aval) = 0, c_naklst->cnazPol4, ::aval[4])

  inline access assign method cnazPol5 var cnazPol5
    return if( len(::aval) = 0, c_naklst->cnazPol5, ::aval[5])

  inline access assign method cnazPol6 var cnazPol6
    return if( len(::aval) = 0, c_naklst->cnazPol6, ::aval[6])
  *

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local dc := ::drgDialog:dialogCtrl

    do case
    case(nevent = xbeBRW_ItemMarked)
      ::showColumnValue()
      return .f.

    case nEvent = drgEVENT_EXIT   ;  ::recordSelected()
    case nEvent = drgEVENT_EDIT   ;  ::recordSelected()
    case nEvent = drgEVENT_APPEND
**      ::recordEdit()
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.

  inline method recordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self


  inline method add_toNazpol()
    if len(::aval) <> 0
      c_naklst->(dbappend())

      c_naklst->cnazPol1 := ::aval[1]
      c_naklst->cnazPol2 := ::aval[2]
      c_naklst->cnazPol3 := ::aval[3]
      c_naklst->cnazPol4 := ::aval[4]
      c_naklst->cnazPol5 := ::aval[5]
      c_naklst->cnazPol6 := ::aval[6]

      c_naklst->(dbunlock(), dbcommit())

      ::brow:oxbp:refreshAll()
    endif
  return .t.

hidden:
  var  drgGet, brow, aval

  inline method showColumnValue()
    local xbro := ::brow:oxbp
    local colCount := xbro:colCount, x, ocol


    for x := 1 to colCount step 1
      ocol := xbro:getColumn(x)
       val := ocol:getRow(xbro:rowPos)

      ocol:lockUpdate(.t.)
        ocol:footing:hide()
        ocol:footing:setCell(1,val)
      ocol:lockUpdate(.f.)

      ocol:footing:show()
    next
  return

ENDCLASS


method c_naklst_sel:init(parent)
  local  x, p_udcp, dm, it_file, name
  *
  ::aval := {}

  if isObject(parent:cargo)
    if parent:cargo:className() = 'drgVar'
      ::drgGet  := parent:cargo:oDrg
        p_udcp  := parent:parent:udcp
            dm  := p_udcp:dataManager

        name    := lower(::drgGet:name)
        it_file := drgParse(name,'-')

        *
        ** pvpTerm nemá cnazPol1 ... 6 ale cStredisko, cVyrobek ...
        if it_file = 'pvpterm' .and. isArray(parent:cargo_usr)
          for x := 1 to 6 step 1
            aadd( ::aval, dm:get( parent:cargo_usr[x] ) )
          next
        else

          for x := 1 to 6 step 1
            aadd( ::aval, dm:get( it_file +'->cnazPol' +str(x,1) ))
          next
        endif
    endif
  endif

  parent:cargo := 0
  ::drgUsrClass:init(parent)

  drgDBMS:open('c_naklst')
return self


method c_naklst_sel:getForm()
  local  oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 88,15.5 DTYPE '10' TITLE 'Èíselník nákladové struktury ...' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGSTATIC INTO drgFC FPOS .3,1.4 SIZE 87.4,2.6 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION 'VýrStøedisko'  CPOS  3, .1 CLEN 10
    DRGTEXT INTO drgFC NAME M->cnazPol1        CPOS  3,1.1 CLEN 10 BGND 11

    DRGTEXT INTO drgFC CAPTION 'Výrobek'       CPOS 17, .1 CLEN  8
    DRGTEXT INTO drgFC NAME M->cnazPol2        CPOS 17,1.1 CLEN 10 BGND 11

    DRGTEXT INTO drgFC CAPTION 'Zakázka'       CPOS 31, .1 CLEN  8
    DRGTEXT INTO drgFC NAME M->cnazPol3        CPOS 31,1.1 CLEN 10 BGND 11

    DRGTEXT INTO drgFC CAPTION 'VýrMísto'      CPOS 45, .1 CLEN  8
    DRGTEXT INTO drgFC NAME M->cnazPol4        CPOS 45,1.1 CLEN 10 BGND 11

    DRGTEXT INTO drgFC CAPTION 'Stroj'         CPOS 59, .1 CLEN  8
    DRGTEXT INTO drgFC NAME M->cnazPol5        CPOS 59,1.1 CLEN 10 BGND 11

    DRGTEXT INTO drgFC CAPTION 'VýrOperace'    CPOS 73, .1 CLEN 10
    DRGTEXT INTO drgFC NAME M->cnazPol6        CPOS 73,1.1 CLEN 10 BGND 11

    DRGSTATIC INTO drgFC FPOS .4, .5 SIZE 86.5, .2 STYPE XBPSTATIC_TYPE_RAISEDBOX
    DRGEND  INTO drgFC
  DRGEND  INTO drgFC

  DRGDBROWSE INTO drgFC FPOS 0,4 SIZE 88,11.56 FILE 'C_NAKLST'         ;
    FIELDS 'cnazPol1:VýrStøedisko:14,'                               + ;
           'cnazPol2:Výrobek:14,'                                    + ;
           'cnazPol3:Zakázka:14,'                                    + ;
           'cnazPol4:VýrMísto:14,'                                   + ;
           'cnazPol5:Stroj:14,'                                      + ;
           'cnazPol6:VýrOperace:14.5'                                  ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y' GUILOOK 'sizecols:n,headmove:n'
  odrg:footer = 'y'

  DRGSTATIC INTO drgFC FPOS .3,0 SIZE 87.4,1.2 STYPE 13  // XBPSTATIC_TYPE_RAISEDBOX
    DRGTEXT INTO drgFC CAPTION 'Promiòte porosím ale, zadaná vazba neexistuje v èíselníku nákladové struktury ...' CPOS .5,.1 FONT 5 CLEN 83
    DRGPUSHBUTTON INTO drgFC ;
                       POS 84,.05 SIZE 3,1 ATYPE 1 ICON1 107 ICON2 207 ;
                       EVENT 'add_toNazpol' TIPTEXT 'Pøidat požadovanou vazbu ...'
  DRGEND  INTO drgFC
return drgFC


method c_naklst_sel:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*-  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  endif
return


method c_naklst_sel:drgDialogStart(drgDialog)
  local  x, odrg, members := drgDialog:oForm:aMembers

  ::brow := drgDialog:dialogCtrl:oBrowse[1]

  for x := 1 to len(members) step 1
    odrg := members[x]

    if((odrg:className() = 'drgStatic') .or. ;
       (odrg:className() = 'drgText' .and. odrg:obord:type <> 1), ;
       odrg:oxbp:setcolorbg(GraMakeRGBColor( {0, 255, 0} )), nil)
  next
return