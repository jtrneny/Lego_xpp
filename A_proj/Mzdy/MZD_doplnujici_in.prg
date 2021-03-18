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


static function mzd_doplnujiciContext(obj, ix, nMENU)
  return {|| obj:fromContext_dop( ix, nMENU) }




*
** prg je urèen pro doplòující nabídku na stranì mezd
*
** class for mzd_doplnujici_in ************************************************
class MZD_doplnujici_in
exported:
  var  m_File


  inline method init(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::m_Dialog := drgDialog
    ::m_DBrow  := drgDialog:dialogCtrl:oBrowse[1]
    ::m_File   := ::m_DBrow:cfile
    ::a_poPup  := { { 'Roèní zúètování danì    ', 'mzd_ldanvypoc_in'   }, ;
                    { 'Zmìny v uzavøeném období', 'mzd_kmenove_zme_in' }  }

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( members[x]:event = 'createContext_dop', ::pb_context := members[x], nil )
      endif
    next
  return self


  inline method createContext_dop()
    local  pa    := ::a_popUp
    local  aPos  := ::pb_context:oXbp:currentPos()
    local  aSize := ::pb_context:oXbp:currentSize()

    opopup         := XbpImageMenu():new( ::m_Dialog:dialog )
    opopup:barText := 'Mzdy'
    opopup:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                            , ;
                       mzd_doplnujiciContext(self,x,pA[x]), ;
                                                          , ;
                       XBPMENUBAR_MIA_OWNERDRAW          }, ;
                       500                                  )
    next

    opopup:popup( ::pb_context:oxbp:parent, { apos[1] -120, apos[2] } )
  return self

  inline method fromContext_dop(aorder,p_popUp)
    local cformName := p_poPup[2]
    local odialog

    odialog := drgDialog():new( cformName, ::m_Dialog)
    odialog:create(,,.T.)
    odialog:destroy()
    odialog := nil

    if isMethod( ::m_Dialog:udcp, 'stableBlock')
      ::m_Dialog:udcp:stableBlock( ::m_DBrow:oxbp )
    endif

    setAppFocus( ::m_DBrow:oxbp )
    PostAppEvent(xbeBRW_ItemMarked,,,::m_DBrow:oxbp)
  return self

hidden:
  var     m_Dialog, m_DBrow, pb_context, a_poPup

endclass


*
** class for mzd_ldanVypoc_in *** zmìna roèního zùètování danì *****************
class mzd_ldanVypoc_in from drgUsrClass
exported:

  * hodnota z dokladu
  inline access assign method org_ldanVypoc() var org_ldanVypoc
    return if( (::m_File)->ldanVypoc, 'Ano', 'Ne' )

  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::m_file  := parent:parent:udcp:m_File
  return self

  inline method drgDialogInit(drgDialog)
    local members := drgDialog:formObject:members, x

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
    ::dm  := drgDialog:dataManager             // dataMabanager

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_zuctDane', ::pb_save_zuctDane := members[x], nil )
      endif
    next

    ::it_ldanVypoc := ::dm:has( ::m_File +'->ldanVypoc' )
  return self

  inline method postValidate(drgVar)
    Local  value  := drgVar:get()
    Local  name   := lower(drgVar:name)
    Local  file   := drgParse(name,'-')
    *
    local  apos_pb, asize_pb, apos

    if name = lower( ::m_File +'->ldanVypoc' )
      apos_pb  := getWindowPos( ::pb_save_zuctDane:oxbp )
      asize_pb := ::pb_save_zuctDane:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_save_zuctDane:oxbp )
    endif
  return .t.


  inline method save_zuctDane()
    local  org_ldanVypoc := (::m_File)->ldanVypoc
    local  ctext         := 'old_ldanVypoc = ' +if(org_ldanVypoc, 'Ano', 'Ne') + ;
                           ' -> new_ldanVypoc = ' +if( ::it_ldanVypoc:value, 'Ano', 'Ne' )
    *
    local cStatement, oStatement
    local stmt_1 := 'update msprc_mo set ldanVypoc = FALSE ' + ;
                    'where (nrok = %% and nobdobi = %% and noscisPrac = %% and nporPraVzt <> %%)'

    if org_ldanVypoc <> ::it_ldanVypoc:value
      if (::m_File)->(sx_rLock())
        (::m_File)->ldanVypoc := ::it_ldanVypoc:value

        mh_wrtZmena( ::m_File,,, ctext )
        (::m_File)->( dbunlock(), dbcommit())

        * Výpoèet roèní danì - musí být nastaveno jen na jednom záznamu msprc_mo
        if msprc_mo->ldanVypoc
          cStatement := format( stmt_1, { msprc_mo->nrok, msprc_mo->nobdobi, msprc_mo->noscisPrac, msPrc_mo->nporPraVzt })
          oStatement := AdsStatement():New(cStatement,oSession_data)

          if oStatement:LastError > 0
*          return .f.
          else
            oStatement:Execute( 'test', .f. )
            oStatement:Close()
          endif
        endif
      endif
    endif

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

hidden:
  var     m_File, msg, dm
  var     it_ldanVypoc, pb_save_zuctDane

endclass



*
** class for mzd_kmenove_zme_in *** zmeny v uzavreném období ******************
class mzd_kmenove_zme_in from drgUsrClass
exported:

  * hodnota z dokladu
  inline access assign method org_lgenerELDP() var org_lgenerELDP
    return if( (::m_File)->lgenerELDP, 'Ano', 'Ne' )

  inline access assign method org_ltiskMzdLi() var org_ltiskMzdLi
    return if( (::m_File)->ltiskMzdLi, 'Ano', 'Ne' )


  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::m_file  := parent:parent:udcp:m_File
  return self

  inline method drgDialogInit(drgDialog)
    local members := drgDialog:formObject:members, x

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
    ::dm  := drgDialog:dataManager             // dataMabanager

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'save_Zmeny', ::pb_save_Zmeny := members[x], nil )
      endif
    next

    ::it_lgenerELDP := ::dm:has( ::m_File +'->lgenerELDP' )
    ::it_ltiskMzdLi := ::dm:has( ::m_File +'->ltiskMzdLi' )
  return self

  inline method postValidate(drgVar)
    Local  value  := drgVar:get()
    Local  name   := lower(drgVar:name)
    Local  file   := drgParse(name,'-')
    *
    local  apos_pb, asize_pb, apos

    if name = lower( ::m_File +'->ltiskMzdLi' )
      apos_pb  := getWindowPos( ::pb_save_Zmeny:oxbp )
      asize_pb := ::pb_save_Zmeny:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_save_Zmeny:oxbp )
    endif
  return .t.


  inline method save_Zmeny()
    local  org_lgenerELDP := (::m_File)->lgenerELDP
    local  org_ltiskMzdLi := (::m_File)->ltiskMzdLi
    local  ctext         := 'old_lgenerELDP = ' +if(org_lgenerELDP, 'Ano', 'Ne') + ;
                           ' -> new_lgenerELDP = ' +if( ::it_lgenerELDP:value, 'Ano', 'Ne' ) + CRLF + ;
                            'old_ltiskMzdLi = ' +if(org_ltiskMzdLi, 'Ano', 'Ne') + ;
                           ' -> new_ltiskMzdLi = ' +if( ::it_ltiskMzdLi:value, 'Ano', 'Ne' )
    *
    if( org_lgenerELDP <> ::it_lgenerELDP:value .or. org_ltiskMzdLi <> ::it_ltiskMzdLi:value )
      if (::m_File)->(sx_rLock())
        (::m_File)->lgenerELDP := ::it_lgenerELDP:value
        (::m_File)->ltiskMzdLi := ::it_ltiskMzdLi:value

        mh_wrtZmena( ::m_File,,, ctext )
        (::m_File)->( dbunlock(), dbcommit())

      endif
    endif

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

hidden:
  var     m_File, msg, dm
  var     it_lgenerELDP, it_ltiskMzdLi, pb_save_Zmeny

endclass