/*==============================================================================
  ZVI_zsbZvKarty_crd.PRG
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

* # Define   VSTUPNI     4
* # Define   BEZNY       5
* # Define   VYSTUPNI    6

********************************************************************************
*
********************************************************************************
CLASS ZVI_zsbZvKarty_CRD FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  PreValidate, PostValidate
  METHOD  OnSave

HIDDEN:
  VAR     dc, dm, lNewREC
  METHOD  ZvKartyZ
ENDCLASS

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  drgDBMS:open('ZvKARTY',,,,, 'ZvKARTYa' )
  drgDBMS:open('ZvKARTYw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('ZvKARTYww' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KategZVI',,,,, 'KategZVIa' )
  drgDBMS:open('C_NaklSt'   )
  drgDBMS:open('ZvKarty_ps' )
  *
  IF ::lNewREC
     ZvKARTYw->( dbAppend())
     mh_COPYFLD('ZvKARTYw', 'ZvKARTYww', .T.)
     *
     ZvKARTYw->cTypVypCen := 'PRU'    // Upper( SysCONFIG('Sklady:cTypCeny'))
     ZvKARTYw->nKlicDph   := 1        // VAL( SysCONFIG('Finance:cZaklDph'))
     ZvKARTYw->cZkratJedn := SysConfig( 'Sklady:cZaklJedn')
     ZvKARTYw->cZkratMeny := SysConfig( 'Finance:cZaklMena')
  ELSE
     mh_COPYFLD('ZvKARTY' , 'ZvKARTYw' , .T.)
     mh_COPYFLD('ZvKARTYw', 'ZvKARTYww', .T.)
  ENDIF

RETURN self

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:destroy()

  ::drgUsrClass:destroy()
  ZvKartyw ->( dbCloseArea())
  ZvKartyww->( dbCloseArea())
  ::lNewREC := Nil
RETURN self

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE  nEvent = drgEVENT_SAVE
      IF ::drgDialog:parent:formName <> 'ZVI_zsbZvKarty_SCR'
        ::onSave()
      ENDIF
      PostAppEvent(xbeP_Close, nEvent,, ::drgDialog:dialog)

    CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
      PostAppEvent(xbeP_Close,nEvent,,oXbp)

    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)

        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:drgDialogStart(drgDialog)
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )

RETURN self

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:PreValidate(oVar)
  LOCAL lOK := .T.
  LOCAL cName := oVar:Name, Filter

RETURN lOK

********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:PostValidate(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lFound, lRet := .T.
  LOCAL cName := oVar:Name, cKey
  Local aValues := ::dm:vars:values
  Local cNazPol1, cNazPol4, nZvirKat

  If ::lNewREC .or. lChanged
    cNazPol1 := ::dm:get( 'ZvKARTYw->cNazPol1')
    cNazPol4 := ::dm:get( 'ZvKARTYw->cNazPol4')
    nZvirKat := ::dm:get( 'ZvKARTYw->nZvirKat')

    DO CASE
    CASE cName = 'ZvKARTYw->cNazPol1' .or. cName = 'ZvKARTYw->cNazPol4' .or. cName = 'ZvKARTYw->nZvirKat'
       IF  cName = 'ZvKARTYw->nZvirKat'
         IF KategZVIa->( dbSEEK( xVar,, 'KATEGZVI_1'))
           ::dm:set( 'ZvKARTYw->cNazev'    , KategZVIa->cNazevKat  )
           ::dm:set( 'ZvKARTYw->cTypEvid'  , KategZVIa->cTypEvid   )
           ::dm:set( 'ZvKARTYw->nUcetSkup' , KategZVIa->nUcetSkup  )
           ::dm:set( 'ZvKARTYw->cDanPZBO'  , KategZVIa->cDanPZBO   )
           ::dm:set( 'ZvKARTYw->cTypSKP'   , KategZVIa->cTypSKP    )
           ::dm:set( 'ZvKARTYw->cNazPol2'  , KategZVIa->cNazPol2   )
           ::dm:set( 'ZvKARTYw->nZvirKatPr', KategZVIa->nZvirKatPr )
           ::dm:set( 'ZvKARTYw->cNazPol2Pr', KategZVIa->cNazPol2Pr )
         ENDIF
       ENDIF
       *
       cKey := Upper( cNazPol1) + Upper( cNazPol4) + StrZero( nZvirKat, 6)
       IF ZvKARTYa->( dbSEEK( cKey,, 'ZVKARTY_01'))
         lRet := .F.
         drgMsgBox(drgNLS:msg('DUPLICITNÍ POLOŽKA;;' + ;
                              'Støedisko [ & ], stáj [ & ], kategorie [ & ] již existuje !',;
                               cNazPol1, cNazPol4, nZvirKat ))
       ENDIF
     ENDCASE
  ENDIF

RETURN lRet

* Realizace èinností pøi uložení karty ZvKarty
********************************************************************************
METHOD ZVI_zsbZvKarty_CRD:OnSave(isBefore, isAppend)
  LOCAL lOkWrt, cKey

  IF ! ::dc:isReadOnly
    ::dm:save()
    lOkWrt := If( ::lNewRec, AddREC('ZvKARTY') , ReplREC('ZvKARTY' ))
    IF lOkwRT
      mh_COPYFLD( 'ZvKARTYw' , 'ZvKARTY')
      ZvKARTY->cUcetSkup := ALLTRIM(STR( ZvKARTY->nUcetSkup))
      mh_WRTzmena( 'ZvKARTY' , ::lNewREC)
      *
      * Kontrola nákl.struktury
      cKey := Upper( ZvKarty->cNazPol1) + Upper( ZvKarty->cNazPol2) + ;
              Space(8) + Upper( ZvKarty->cNazPol4)
      IF !( lOK := C_NaklSt->( dbSeek( cKey,, 'C_NAKLST1' )))
         IF drgIsYesNO(drgNLS:msg('Vazba  STØEDISKO + VÝKON + STÁJ není v èíselníku nákladové struktury.;;' + ;
                                  'Požadujete ji založit ?') )
            IF C_NaklSt->( dbAppend(), dbRLock())
              C_NaklSt->cNazPol1 := ZvKarty->cNazPol1
              C_NaklSt->cNazPol2 := ZvKarty->cNazPol2
              C_NaklSt->cNazPol4 := ZvKarty->cNazPol4
              C_NaklSt->nKlicNS  := C_NaklSt->( RecNO())
              C_NaklSt->( dbUnlock())
            ENDIF
         ENDIF
      ENDIF
      *
      IF ::lNewRec
        ZvKarty->dDatPorKar := Date()
        ZvKarty->dDatpZV    := Date()
        ZvKarty->nCenaV1ZV  := KategZvi->nCenaV1ZV
        ZvKarty->nCenaV2ZV  := KategZvi->nCenaV2ZV
        *
        mh_COPYFLD( 'ZvKARTY' , 'ZvKARTY_ps', .T.)
        ZvKARTY_ps->nROK   := uctOBDOBI:ZVI:nRok
      ENDIF
      *
      ::ZvKartyZ()
      *
      ZvKARTY->( dbCommit(), dbUnLock())
      *
    ELSE
      drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
    ENDIF
  ENDIF
RETURN .T.

* Generuje neúèetní zmìny
*HIDDEN*************************************************************************
METHOD ZVI_zsbZvKarty_CRD:ZvKartyZ()
  Local  nTypPohyb := 4
  Local  cPopisZme, n, oVar, cFld, xOrg, xNew
  Local  cUserAbb := SYSCONFIG( 'SYSTEM:cUSERABB' ), aStru := ZvKartyW->( dbStruct())

  nTypPohyb := 4
  cPopisZme := IIf( nTypPohyb = VSTUPNI , 'Vstupní ... ' ,;
               IIF( nTypPohyb = BEZNY   , 'Oprava ...'   ,;
               IIF( nTypPohyb = VYSTUPNI, 'Výstupní ...' , '' ) ) )

  For n := 1 TO LEN( aStru)
    xOrg := ZvKartyWW->( FieldGet( n))
    xNew := ZvKartyW->( FieldGet( n))
    IF xOrg <> xNew
      IF AddREC( 'ZvKartyZ' )
        cFld := 'ZvKartyW->' + aStru[ n, 1]
        oVar := ::dm:has( cFld )
        ZvKartyZ->cNazPol1   := ZvKartyW->cNazPol1
        ZvKartyZ->cNazPol4   := ZvKartyW->cNazPol4
        ZvKartyZ->nZvirKat   := ZvKartyW->nZvirKat
        ZvKartyZ->cPopisZme  := cPopisZme
        ZvKartyZ->cPoleZme   := aStru[ n, 1]    //  ZvKarty->( FieldName( n))
*        ZvKartyZ->cNazPolZme := IF( IsNIL( oVar:ref), aStru[ n, 1] , oVar:ref:caption )  //
        ZvKartyZ->cNazPolZme := IF( IsNIL( oVar)            , aStru[ n, 1],;
                                IF( IsNIL( oVar:ref)        , aStru[ n, 1],;
                                IF( IsNIL( oVar:ref:caption), aStru[ n, 1], oVar:ref:caption )))
        ZvKartyZ->cOldHodn   := drg2String( xOrg)  // Transform( xOrg, "@K")
        ZvKartyZ->cNewHodn   := drg2String( xNew)  // Transform( xNew, "@K")
        ZvKartyZ->dDatZmeny  := Date()
        ZvKartyZ->cCasZmeny  := Time()
        ZvKartyZ->cUserAbb   := cUserAbb
        ZvKartyZ->( dbUnlock())
      EndIF
    EndIF
  Next

RETURN NIL