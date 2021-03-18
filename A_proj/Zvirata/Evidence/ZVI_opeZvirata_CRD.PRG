/*==============================================================================
  ZVI_opeZvirata_crd.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

*****************************************************************
*
*****************************************************************
CLASS ZVI_opeZvirata_CRD FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  PostValidate, comboBoxInit
  METHOD  OnSave

HIDDEN:
  VAR     dc, dm, lNewREC
ENDCLASS

********************************************************************************
METHOD ZVI_opeZvirata_CRD:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  *
  drgDBMS:open('C_NaklSt' )
  drgDBMS:open('C_FarmyV' )
  drgDBMS:open('ZVIRATAw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('ZVIRATA' ,,,,, 'ZVIRATAa'  )
  drgDBMS:open('KategZVI',,,,, 'KategZVIa' )
  /*
  drgDBMS:open('ZvKARTYww' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KategZVI',,,,, 'KategZVIa' )
  */
  IF ::lNewREC
     ZVIRATAw->( dbAppend())
*     mh_COPYFLD('ZvKARTYw', 'ZvKARTYww', .T.)
     *
     ZVIRATAw->nPohlavi  := 1      // 1 = On, 2 = Ona
     ZVIRATAw->nKusy     := 1
  ELSE
     mh_COPYFLD('ZVIRATA' , 'ZVIRATAw' , .T.)
*     mh_COPYFLD('ZvKARTYw', 'ZvKARTYww', .T.)
  ENDIF
  */
RETURN self

********************************************************************************
*
********************************************************************************
METHOD ZVI_opeZvirata_CRD:destroy()

  ::drgUsrClass:destroy()
  *
  ZVIRATAw ->( dbCloseArea())
*  ZVIRATAww->( dbCloseArea())
  ::lNewREC := ;
                 Nil
*/
RETURN self

********************************************************************************
*
********************************************************************************
METHOD ZVI_opeZvirata_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE  nEvent = drgEVENT_SAVE
      IF ::drgDialog:parent:formName <> 'ZVI_opeZvirata_SCR'
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

*
********************************************************************************
METHOD ZVI_opeZvirata_CRD:drgDialogStart(drgDialog)
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
  *
  IsEditGET( {'ZVIRATAw->dDatPorKar',;
              'ZVIRATAw->dDatPZV'    }, ::drgDialog, .F.)
RETURN self

********************************************************************************
method ZVI_opeZvirata_CRD:comboBoxInit(drgComboBox)
*  Local aCombo, nTask, cTask, cNazTask, n
  *
  IF !::lNewREC
    drgComboBox:value :=  Zvirata->nPohlavi
  ENDIF
RETURN self

*
********************************************************************************
METHOD ZVI_opeZvirata_CRD:PostValidate(oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lFound, lRet := .T., lOK
  LOCAL cName := oVar:Name, cKey
  Local aValues := ::dm:vars:values
  Local cNazPol1, cNazPol4, nZvirKat, nInvCis
 *
  If ::lNewREC .or. lChanged
    cNazPol1 := Upper( ::dm:get( 'ZVIRATAw->cNazPol1'))
    cNazPol4 := Upper( ::dm:get( 'ZVIRATAw->cNazPol4'))
    nZvirKat := StrZERO( ::dm:get( 'ZVIRATAw->nZvirKat'), 6)
    nInvCis  := StrZERO( ::dm:get( 'ZVIRATAw->nInvCis'), 15)

    DO CASE
    CASE cName = 'ZVIRATAw->cNazPol1' .or. cName = 'ZVIRATAw->cNazPol4' .or. cName = 'ZVIRATAw->nZvirKat' .or. ;
         cName = 'ZVIRATAw->nInvCis'
       *
       IF cName = 'ZVIRATAw->cNazPol4'
          C_FarmyV->( dbSEEK( Upper( xVar),, 'FARMYV_1'))
          ::dm:set( 'ZVIRATAw->nFarma', C_FarmyV->nFARMA )
       ENDIF
       *
       IF  cName = 'ZVIRATAw->nZvirKat'
         IF KategZVIa->( dbSEEK( xVar,, 'KATEGZVI_1'))
           ::dm:set( 'ZVIRATAw->nUcetSkup' , KategZVIa->nUcetSkup  )
           ::dm:set( 'ZVIRATAw->cDanPZBO'  , KategZVIa->cDanPZBO   )
           ::dm:set( 'ZVIRATAw->cTypSKP'   , KategZVIa->cTypSKP    )
           ::dm:set( 'ZVIRATAw->cNazPol2'  , KategZVIa->cNazPol2   )
         ENDIF
       ENDIF
       *
       IF cName = 'ZVIRATAw->nInvCis'
         IF .not.( lOK := ControlDUE( oVar))
           RETURN .F.
         ENDIF
       ELSEIF Empty( xVar)
         PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
       ENDIF
       *
       cKey := cNazPol1 + cNazPol4 + nZvirKat + nInvCis
       IF ZVIRATAa->( dbSEEK( cKey,, 'ZVIRATA01'))
         lRet := .F.
         drgMsgBox(drgNLS:msg('DUPLICITNÍ POLOŽKA;;' + ;
                              'Støedisko [ & ], stáj [ & ], kategorie [ & ], inventární èíslo [ & ] !',;
                               cNazPol1, cNazPol4, nZvirKat, nInvCis ))
       ENDIF
     ENDCASE
  ENDIF
*/
RETURN lRet


* Realizace èinností pøi uložení karty ZvKarty
********************************************************************************
METHOD ZVI_opeZvirata_CRD:OnSave(isBefore, isAppend)
  LOCAL lOkWrt, cKey
  *
  IF ! ::dc:isReadOnly
    ::dm:save()
    lOkWrt := If( ::lNewRec, AddREC('ZVIRATA') , ReplREC('ZVIRATA' ))
    IF lOkwRT
      mh_COPYFLD( 'ZVIRATAw' , 'ZVIRATA')
      ZVIRATA->cUcetSkup := ALLTRIM(STR( ZVIRATA->nUcetSkup))
      ZVIRATA->cTypEvid   := 'I'
      ZVIRATA->cPohlavi   := IF( Zvirata->nPohlavi = 1, 'B', 'J')
      ZVIRATA->dDatPorKar := IF( ::lNewREC, Date(), ZVIRATA->dDatPorKar )
      ZVIRATA->dDatpZV    := IF( ::lNewREC, Date(), ZVIRATA->dDatpZV    )

      mh_WRTzmena( 'ZVIRATA' , ::lNewREC)
      *
      * Kontrola nákl.struktury
      cKey := Upper( ZVIRATA->cNazPol1) + Upper( ZVIRATA->cNazPol2) + ;
              Space(8) + Upper( ZVIRATA->cNazPol4)
      IF !( lOK := C_NaklSt->( dbSeek( cKey,, 'C_NAKLST1' )))
         IF drgIsYesNO(drgNLS:msg('Vazba  STØEDISKO + VÝKON + STÁJ není v èíselníku nákladové struktury.;;' + ;
                                  'Požadujete ji založit ?') )
            IF C_NaklSt->( dbAppend(), dbRLock())
              C_NaklSt->cNazPol1 := ZVIRATA->cNazPol1
              C_NaklSt->cNazPol2 := ZVIRATA->cNazPol2
              C_NaklSt->cNazPol4 := ZVIRATA->cNazPol4
              C_NaklSt->nKlicNS  := C_NaklSt->( RecNO())
              C_NaklSt->( dbUnlock())
            ENDIF
         ENDIF
      ENDIF
      *
      ZVIRATA->( dbCommit(), dbUnLock())
      *
    ELSE
      drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
    ENDIF
  ENDIF
  */
RETURN .T.