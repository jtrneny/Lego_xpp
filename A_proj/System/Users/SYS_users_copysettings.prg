#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\Asystem++\Asystem++.ch"

********************************************************************************
CLASS SYS_users_copysettings FROM drgUsrClass
EXPORTED:
  VAR     cUserTO, cOsobaTO, cUserFROM, cOsobaFROM
  VAR     isMenu, isConfig, isOpravneni, isForms, isFilters, isKomunik
  VAR     cMenu , cConfig , cOpravneni , cForms , cFilters , cKomunik

  METHOD  init, drgDialogStart, postValidate, destroy, checkitemselected
  METHOD  users_sel, Start_copy, Refresh_dlg

HIDDEN:
  VAR  dm, nRecUsers

ENDCLASS

********************************************************************************
METHOD SYS_users_copysettings:init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('Users',,,,,'UsersW')
  drgDBMS:open('CONFIGUS' )
  drgDBMS:open('CONFIGUSw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('ASYSACT'  )
  drgDBMS:open('ASYSACTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FRMUSERS' )
  drgDBMS:open('FRMUSERSw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FLTUSERS' )
  drgDBMS:open('FLTUSERSw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KOMUSERS' )
  drgDBMS:open('KOMUSERSw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  ::cOsobaFROM := SPACE(50)
  ::cUserFROM  := SPACE(10)
  ::cOsobaTO   := Users->cOsoba
  ::cUserTO    := Users->cUser
  *
  ::nRecUsers  := Users->( RecNo())
RETURN self

********************************************************************************
METHOD SYS_users_copysettings:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::Refresh_dlg()
  *
RETURN self

********************************************************************************
METHOD SYS_users_copysettings:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  lOK  := .T.

  do case
  case name = 'm->cosobafrom'
    lOk := ::users_sel()
  endcase

RETURN lOk

********************************************************************************
METHOD SYS_users_copysettings:Start_copy()
  Local mMenuUser, x, lOK
  Local                    isOK,      cFile,         cTag,     cFilew
  Local aF := { { ::isConfig   , 'Configus', 'CONFIGUS04', 'Configusw'  },;
                { ::isOpravneni, 'Asysact' , 'ASYSACT02' , 'Asysactw'   },;
                { ::isForms    , 'FrmUsers', 'FRMUSERS01', 'FrmUsersw'  },;
                { ::isFilters  , 'FltUsers', 'FLTUSERS01', 'FltUsersw'  },;
                { ::isKomunik  , 'KomUsers', 'KOMUSERS01', 'KomUsersw'  } }

  IF empty( ::cUserFROM)
    drgMsgBox(drgNLS:msg( 'Nebyla vybrána osoba, z níž se budou vybrané položky kopírovat ...'))
    RETURN .T.
  ENDIF
  *
  lOK := ::isMenu .or. ::isConfig .or. ::isOpravneni .or. ::isForms .or. ::isFilters .or. ::isKomunik
  IF !lOK
    drgMsgBox(drgNLS:msg( 'Nejsou nastaveny žádné položky ke kopírování ...'))
    return .t.
  ENDIF

  IF drgIsYesNo(drgNLS:msg( 'Požadujete spustit kopírování ?' ))
    * MENU
    if ::isMenu .and. UsersW->( dbSeek( Upper(::cUserFROM),, 'USERS01'))
      mMenuUser := UsersW->mMenuUser
      Users->( dbGoTO(::nRecUsers))
      if Users->( dbRLock())
        Users->mMenuUser := mMenuUser
        Users->( dbUnlock())
      endif
    endif
    *
    FOR x := 1 TO LEN( aF)
      isOK   := aF[ x, 1]
      cFile  := aF[ x, 2]
      cTag   := aF[ x, 3]
      cFilew := aF[ x, 4]
      if isOK
        (cFilew)->( dbZap())
        * zruší pùvodní nastavení
        (cFile)->( AdsSetOrder( cTag),;
                   mh_SetScope( Upper( ::cUserTO)) ,;
                   dbEval({|| ( dbRLock(), dbDelete(), dbRUnlock() ) }) ,;
                   mh_ClrScope() )
        * nastaví nové nastavení
        (cFile)->( AdsSetOrder( cTag),;
                   mh_SetScope( Upper( ::cUserFROM)) ,;
                   dbEval({|| mh_copyFld( cFile, cFilew, .t., .t.) }) ,;
                   mh_ClrScope() )
        *
        (cFilew)->( dbGoTOP())
        do while .not. (cFilew)->(eof())
          mh_copyFld( cFilew, cFile, .t., .t.)
          (cFile)->cUser := ::cUserTO
          (cFilew)->(dbskip())
        enddo
      endif

    NEXT
    *
    ::Refresh_dlg()
    *
    drgMsgBox(drgNLS:msg( 'Kopírování UKONÈENO ...'))
  ENDIF

RETURN .T.

********************************************************************************
METHOD SYS_users_copysettings:users_sel(drgDialog)
  Local oDialog , nExit := drgEVENT_QUIT
  Local drgVar := ::dm:get('M->cOsobaFrom', .F.)
  Local value  := Upper( drgVar:get())
  Local lOk    := ( !Empty(value) .and. Users->(dbseek(value,,'USERS04')))

  IF IsObject( drgDialog) .or. ! lOk
    DRGDIALOG FORM 'SYS_users_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ENDIF
  *
  if ( nExit != drgEVENT_QUIT .or. lOk )
    lOK := .T.
    ::dm:set("m->cOsobaFrom", Users->cOsoba)
    ::cUserFrom  := Users->cUser
  endif
  Users->( dbGoTO(::nRecUsers))
RETURN lOK

********************************************************************************
METHOD SYS_users_copysettings:destroy()
  ::drgUsrClass:destroy()
  *
  ::cUserTO := ::cOsobaTO := ::cUserFROM := ::cOsobaFROM := ;
  ::isMenu := ::isConfig := ::isOpravneni := ::isForms := ::isFilters := ::isKomunik := ;
  ::cMenu := ::cConfig := ::cOpravneni := ::cForms := ::cFilters := ::cKomunik  := ;
  NIL
RETURN NIL

********************************************************************************
METHOD SYS_users_copysettings:Refresh_dlg()
  Local oVar

  * MENU
  ::isMenu := empty(users->mmenuuser)
  ::cMenu  := if( ::isMenu, '', 'Menu již existuje ...')
  ::dm:set('M->cMenu' , ::cMenu )

  oVar := ::dm:get('M->isMenu', .f.)
*  ovar:odrg:isEdit := ::isMenu
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isMenu, 'T', 'F')
*  if(::isMenu, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()

  * KONFIGURACE
  CONFIGUS->( AdsSetOrder('CONFIGUS04'), mh_SetScope( Upper( ::cUserTO)) )
  ::isConfig := empty(CONFIGUS->cUser)
  ::cConfig  := if( ::isConfig, '', 'Konfigurace již existuje ...')
  ::dm:set('M->cConfig' , ::cConfig )

  oVar := ::dm:get('M->isConfig', .f.)
*  ovar:odrg:isEdit := ::isConfig
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isConfig, 'T', 'F')
*  if(::isConfig, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()

  * OPRAVNENI
  ASYSACT->( AdsSetOrder('ASYSACT02'), mh_SetScope( Upper( ::cUserTO)) )
  ::isOpravneni := empty(ASYSACT->cUser)
  ::cOpravneni  := if( ::isOpravneni, '', 'Oprávnìní již existuje ...')
  ::dm:set('M->cOpravneni' , ::cOpravneni )

  oVar := ::dm:get('M->isOpravneni', .f.)
*  ovar:odrg:isEdit := ::isOpravneni
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isOpravneni, 'T', 'F')
*  if(::isOpravneni, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()

  * FORMS
  FRMUSERS->( AdsSetOrder('FRMUSERS01'), mh_SetScope( Upper( ::cUserTO)) )
  ::isForms := empty(FRMUSERS->cUser)
  ::cForms  := if( ::isForms, '', 'Formuláøe již existují ...')
  ::dm:set('M->cForms' , ::cForms )

  oVar := ::dm:get('M->isForms', .f.)
*  ovar:odrg:isEdit := ::isForms
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isForms, 'T', 'F')
*  if(::isForms, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()

  * FILTERS
  FLTUSERS->( AdsSetOrder('FLTUSERS01'), mh_SetScope( Upper( ::cUserTO)) )
  ::isFilters := empty(FLTUSERS->cUser)
  ::cFilters  := if( ::isFilters, '', 'Filtry již existují ...')
  ::dm:set('M->cFilters' , ::cFilters )

  oVar := ::dm:get('M->isFilters', .f.)
*  ovar:odrg:isEdit := ::isFilters
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isFilters, 'T', 'F')
*  if(::isFilters, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()

  * KOMUNIK
  KOMUSERS->( AdsSetOrder('KOMUSERS01'), mh_SetScope( Upper( ::cUserTO)) )
  ::isKomunik := empty(KOMUSERS->cUser)
  ::cKomunik  := if( ::isKomunik, '', 'Komunikace již existuje ...')
  ::dm:set('M->cKomunik' , ::cKomunik )

  oVar := ::dm:get('M->isKomunik', .f.)
*  ovar:odrg:isEdit := ::isKomunik
  oVar:initvalue := oVar:prevvalue := oVar:value := oVar:odrg:value := if( ::isKomunik, 'T', 'F')
*  if(::isKomunik, ovar:odrg:oxbp:enable(), ovar:odrg:oxbp:disable())
  ovar:odrg:refresh()
  *
  ::dm:save()
  ::dm:refresh()

RETURN self

********************************************************************************
METHOD SYS_users_copysettings:CheckItemSelected( CheckBox)
  Local Name := drgParseSecond( CheckBox:oVar:Name,'>')

  self:&Name := IF( CheckBox:Value = "T", .T., .F. )
RETURN self