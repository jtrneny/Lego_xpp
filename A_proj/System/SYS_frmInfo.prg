#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include '..\DRG_miss_DLL\drgRTF.ch'
#include 'ot4xb.ch'

#include "..\Asystem++\Asystem++.ch"

#pragma library( "ot4xb.lib"   )


*
*******************************************************************************
CLASS SYS_frmInfo from drgUsrClass
EXPORTED:
  method init, getForm, drgDialogStart
  var    odBrowse, m_deBrowse

  *
  ** bro column_1 - aktivní soubor
  inline access assign method dataArea_isMain() var dataArea_isMain
    local  cfile := alltrim( upper(B_Fieldsw->cfile))

    if isObject(::m_deBrowse)
      if cfile = upper(::m_deBrowse:cfile)
        return MIS_ICON_OK
      endif
    endif
  return 0

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

HIDDEN:
  var  m_parent

  inline method create_BX_FieldsW()
    local  nBro
    local  obro, cfile, odbd

    for nBro := 1 to len( ::odBrowse) step 1
      oBro  := ::odBrowse[ nBro ]:oxbp
      cfile := ::odBrowse[ nBro ]:cfile
      odbd  := drgDBMS:getDBD(cfile)

      B_Fieldsw->(dbappend())
      B_Fieldsw->cfile    := cfile
      B_Fieldsw->cvyraz_u := odbd:description
      B_Fieldsw->cfield   := (cfile)->(ordSetFocus())
    next

    B_Fieldsw->( dbgotop())
  return self
ENDCLASS


method sys_frminfo:init( parent )
  ::drgUsrClass:init(parent)

  drgDBMS:open('B_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP

  ::m_parent   := parent:parent
  ::odBrowse   := parent:parent:odBrowse
  ::m_deBrowse := parent:cargo_usr
return self


method sys_frminfo:getForm()
  local  drgFC, oDrg
  local  cHead := ::m_parent:formName

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 60,10.2 DTYPE '10' TITLE 'Základní informace o dialogu...' ;
                                  GUILOOK 'All:N,Border:Y' BORDER 4

  DRGDBROWSE INTO drgFC FPOS 0,1.3 SIZE 60,9 FILE 'B_Fieldsw'    ;
             FIELDS 'M->dataArea_isMain::3::2,'                + ;
                    'cfile:soubor:11,'                         + ;
                    'cvyraz_u:Název souboru:30,'               + ;
                    'cfield:tag:11'                              ;
             ITEMMARKED 'itemMarked' SCROLL 'ny' CURSORMODE 3 PP 9  POPUPMENU 'nn' RESIZE 'ny'

  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 59.6,1.2 STYPE 1 RESIZE 'nn'
    DRGTEXT       INTO drgFC CAPTION cHead CPOS 0,0 CLEN 57 FONT 5 BGND 12 CTYPE 1

    DRGPUSHBUTTON INTO drgFC POS 56.7,0 SIZE 3,1.1 ATYPE 1      ;
                  EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'   ;
                  ICON1 119 ICON2 220

  DRGEND INTO drgFC
return drgFC


method sys_frminfo:drgDialogStart( drgDialog )
  local  x, members := drgDialog:oForm:aMembers, odrg

   for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case  odrg:ClassName() = 'drgPushButton'
*      do case
*      case odrg:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
*      case odrg:event = 'save_marked'    ;  ::pb_save_marked := members[x]
*      endcase

    case odrg:ClassName() = 'drgText'
      odrg:oxbp:setcolorbg( GraMakeRGBColor( {196, 196, 255} ))

    endcase
  next

  ::create_BX_FieldsW()
return self