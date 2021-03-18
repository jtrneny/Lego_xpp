#include "appevent.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#define  _VSECHNY     1
#define  _VYKRYTE     2
#define  _NEVYKRYTE   3

********************************************************************************
* Objednávky pøijaté - sumace objednaných položek - nevykrytých
********************************************************************************
CLASS VYR_ObjItemw_Tmp_scr FROM drgUsrClass
EXPORTED
  VAR     lDataFilter
  METHOD  Init, drgDialogStart, drgDialogEnd, ItemMarked, ComboItemSelected


  inline access assign method ObjCenDis() var ObjCenDis
    return if( cenzbozA->( dbSeek( Upper(ObjITEMw->cCisSklad)+Upper(ObjITEMw->cSklPol),,'CENIK12')), cenzbozA->nmnozdzbo, 0.00)


  inline access assign method ObjFirma() var ObjFirma
    return if( objheadA->( dbSeek( ObjITEM->nDoklad,,'OBJHEAD7')), objheadA->cNazev,'')


  inline access assign method ObjVykryta() var ObjVykryta
    return if(ObjITEMw->nMnozVpInt > 0, MIS_ICON_OK, 0)



HIDDEN
  VAR     mainBro
ENDCLASS

********************************************************************************
METHOD VYR_ObjItemw_Tmp_scr:Init(parent)
  local  cdirW := drgINI:dir_USERfitm +userWorkDir() +'\'

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open( 'cenzboz',,,,, 'cenzbozA')
  drgDBMS:open( 'objhead',,,,, 'objheadA')
  drgDBMS:open( 'objitem',,,,, 'objitemA')
  drgDBMS:open( 'objitem',,,,, 'objitemN')
  drgDBMS:open( 'VYRZAK' )
  drgDBMS:open( 'objitemW', .T., .T., drgINI:dir_USERfitm, , , .t. )  ; ZAP

//  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)

  // SEZNAM DLUŽNÍKÚ
  if( select('objitemx') <> 0, objitemx->(dbCloseArea()), nil)
  FErase(cdirW +'objitemx.adi')
  FErase(cdirW +'objitemx.adm')
  FErase(cdirW +'objitemx.adt')

  objitemN ->( Ads_SetAOF('( (cPolCen = "C") and (nExtObj = 1) and (nStav_FAKV <> 2))') )

  DbSelectARea('objitemN')
  objitemN ->( AdsSetOrder('OBJITEM4'))
  TOTAL ON (Upper(cCisSklad)+Upper(cSklPol)) FIELDS nMnozObODB TO (cdirW +'objitemx')
  objitemN ->(Ads_ClearAOF())

//  file_name := mzdyhdW ->( DBInfo(DBO_FILENAME))
//               mzdyhdW ->( DbCloseArea())

  DbUseArea(.t., oSession_free, cdirW +'objitemx', 'objitemx', .t., .f.)  ; objitemx->( Flock())

  do while .not. objitemx->( Eof())
    Mh_CopyFLD( 'objitemx', 'objitemw', .t.)

    objitemx->( dbSkip())
  enddo

  objitemw->( dbGoTop())

  ::lDataFilter := _VSECHNY
RETURN self

********************************************************************************
METHOD VYR_ObjItemw_Tmp_scr:drgDialogStart(drgDialog)

*   ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   *
   ::mainBro := drgDialog:odBrowse[1]
   OBJZAK->( DbSetRelation( 'VyrZAK', {|| Upper(OBJZAK->cCisZakaz)  },'Upper(OBJZAK->cCisZakaz)'))
RETURN self

********************************************************************************
METHOD VYR_ObjItemw_Tmp_scr:drgDialogEnd( drgDialog)
  OBJZAK->( dbClearRelation())
RETURN

********************************************************************************
METHOD VYR_ObjItemw_Tmp_scr:ItemMarked()
  Local cScope := Upper( ObjITEMw->cCislObInt) + StrZero( ObjITEMw->nCislPolOb, 5)
  Local cFiltr

  OBJZAK->( mh_SetScope( cScope))
//  objitemA ->( Ads_SetAOF('( (nExtObj = 1) and (nStav_FAKV <> 2))') )
  cFiltr := FORMAT( "cSklPol = '%%' and (nExtObj = 1) and (nStav_FAKV <> 2)",{ ObjITEMw->cSklPol } )
  objitem ->( Ads_SetAOF(cFiltr))
*    VyrZakIT->( mh_SetFilter( Filter))

RETURN SELF

********************************************************************************
METHOD VYR_ObjItemw_Tmp_scr:comboItemSelected( Combo)
  Local Filter

  ::lDataFilter := Combo:value
  Do Case
  Case ::lDataFilter = _VSECHNY
    IF( EMPTY(ObjITEMw->(ads_getAof())), NIL, ObjITEMw->(ads_clearAof(),dbGoTop()) )

  Case ::lDataFilter = _VYKRYTE
    Filter := "nMnozVpInt > 0"
    ObjITEMw->( mh_SetFilter( Filter))

  Case ::lDataFilter = _NEVYKRYTE
    Filter := "nMnozVpInt = 0"
    ObjITEMw->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.