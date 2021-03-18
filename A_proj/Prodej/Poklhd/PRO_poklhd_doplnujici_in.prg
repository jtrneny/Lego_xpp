#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
#include "dll.ch"
//
#include "..\Asystem++\Asystem++.ch"


static function setCursorPos( nX, nY)
  DllCall( "user32.dll", DLL_STDCALL, "SetCursorPos", nX, nY)
return nil


static function getWindowPos(o)
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
   aObjPosXY[2]  := nTop  //AppDeskTop():currentSize()[2] - nBottom
RETURN(aObjPosXY)


static function pro_doplnujiciContext(obj, ix, nMENU)
  return {|| obj:fromContext_dop( ix, nMENU) }


*
** prg je urèen pro doplòující nabídku na stranì jen kasy - poklhd
*
** class for pro_poklhd_doplnujici_in ******************************************
class PRO_poklhd_doplnujici_in
exported:
  var     m_File

  var     hd_file, it_file
*  method  poklhd_to_pokladhd_in


  inline method init(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::m_Dialog := drgDialog
    ::m_DBrow  := drgDialog:dialogCtrl:oBrowse[1]
    ::m_File   := ::m_DBrow:cfile
    ::a_poPup  := { { 'Zmìna data vystavení', 'pro_dvystfak_in' } }

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( members[x]:event = 'createContext', ::pb_context := members[x], nil )
      endif
    next
  return self


  inline method createContext()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::m_Dialog:dialog )
    opopup:barText := 'Pohledávky'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                       , ;
                       de_BrowseContext(self,x,pA[x]), ;
                                                     , ;
                       XBPMENUBAR_MIA_OWNERDRAW        }, ;
                       500                                )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -120, apos[2] } )
  return self

  inline method fromContext(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::m_Dialog)
    odialog:create(,,.T.)

    odialog:destroy()
    odialog := nil

    setAppFocus( ::m_DBrow:oxbp )
    ::m_DBrow:oxbp:refreshAll()
    PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
  return self

hidden:
  var     m_Dialog, m_DBrow, pb_context, a_poPup

endclass


*
** class for pro_dvystfak_in *** zmìna data vystavení, splatnosti, ... ********
class pro_dvystfak_in from drgUsrClass
exported:
  var dok_dvystFak, dok_cobdobi, new_cobdobi

  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::m_file       := parent:parent:udcp:m_File
    ::hrazeno      := parent:parent:udcp:oinf:hrazeno()

    ::dok_dvystFak := (::m_File)->dvystFak
    ::dok_cobdobi  := strZero((::m_File)->nobdobi,2) +'/' +strZero((::m_File)->nrok,4)
    ::new_cobdobi  := ''
  return self

  inline method drgDialogInit(drgDialog)
    local members := drgDialog:formObject:members, x

    drgDialog:cargo   := drgEVENT_EDIT
    ::o_PRO_poklhd_in := PRO_poklhd_IN():new(drgDialog)

    BEGIN SEQUENCE
      for x := 1 to len(members) step 1
        if  members[x]:ClassName() = '_drgDrgForm'
          members[x]:file = ::m_file
    BREAK
        endif
      next
    END SEQUENCE
  return self

  inline method drgDialogStart(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::msg := drgDialog:oMessageBar             // messageBar
    ::dm  := drgDialog:dataManager             // dataManager
    ::df  := drgDialog:oForm                   // form

    isEditGet( { 'M->dok_dvystFak', 'M->dok_cobdobi', 'M->new_cobdobi' }, drgDialog, .f. )

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_dvystFak', ::pb_save_dvystFak := members[x], nil )
      endif
    next

    ::it_vystFak     := ::dm:has( ::m_File +'->dvystfak' )
    ::it_new_cobdobi := ::dm:has( 'M->new_cobdobi'       )
    ::it_vystFak:set( date() )
    ::it_new_cobdobi:set( StrZero( Month(date()), 2) +'/' +StrZero( Year(date()), 4) )

*    if ::hrazeno = H_big
*      ::msg:writeMessage( 'Faktura již byla uhrazena, zmìna data splatnosti nic neovlivní ...', DRG_MSG_WARNING )
*    endif
  return self

  inline method postValidate(drgVar)
    Local  value  := drgVar:get()
    Local  name   := lower(drgVar:name)
    Local  file   := drgParse(name,'-')
    local  cobdobi, lok := .f.
    *
    local  apos_pb, asize_pb, apos

    if name = lower( ::m_File +'->dvystfak' )
      cobdobi := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)
      if ucetsys->( dbseek( 'F' +cobdobi,,'UCETSYS2'))
        ::it_new_cobdobi:set( StrZero( Month(value), 2) +'/' +StrZero( Year(value), 4) )
        lok := .t.
      endif
    endif

    if lok
      apos_pb  := getWindowPos( ::pb_save_dvystFak:oxbp )
      asize_pb := ::pb_save_dvystFak:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_save_dvystFak:oxbp )
    endif
  return lok


  inline method save_dvystFak()
    local  dat_vystFak := (::m_File)->dvystFak
    local  ctext        := 'old_vystFak = ' +dtoc(dat_vystFak) + ;
                           ' -> new_vystFak = ' +dtoc(::it_vystFak:value)

    if .not. ::postValidate( ::it_vystFak )
      ::df:setNextFocus( ::m_File +'->dvystfak' ,, .t.)
*      ::msg:writeMessage('Množství k fakturaci bylo již použito ...', DRG_MSG_ERROR)
      return self
    endif


    if dat_vystFak <> ::it_vystFak:value
      ( poklhdW->cobdobi    := ucetsys->cobdobi                                   , ;
        poklhdw->nrok       := ucetsys->nrok                                      , ;
        poklhdw->nobdobi    := ucetsys->nobdobi                                   , ;
        poklhdw->cobdobiDan := ucetsys->cobdobiDan                                , ;
        poklhdW->dsplatFak := ::it_vystFak:value +SYSCONFIG( 'FINANCE:nSPLATNOST'), ;
        poklhdW->dvystFak  := ::it_vystFak:value                                  , ;
        poklhdW->dpovinFak := ::it_vystFak:value                                    )

      pro_poklhd_wrt()

      if (::m_File)->(sx_rLock())
        mh_wrtZmena( ::m_File,,, ctext )
        (::m_File)->( dbunlock(), dbcommit())
      endif
    endif

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

  inline method drgDialogEnd(drgDialog)
    ::o_PRO_poklhd_in := nil
  return self

hidden:
  var     o_PRO_poklhd_in
  var     m_File, hrazeno, msg, dm, df
  var     it_vystFak, it_new_cobdobi, pb_save_splatFak
  var     pb_save_dvystFak

endclass