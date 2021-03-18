#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
#include "dll.ch"
*
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


*
** CLASS for FIN_prepkurroz_IN *************************************************
CLASS FIN_prepkurroz_IN FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, postLastField
  method  postValidate
  method  prepocet
  method  c_meny

  var    rok, mena, kurz, rokzpet

  inline method drgDialogStart(drgDialog)
    local members := drgDialog:oActionBar:members, x

    ::msg     := drgDialog:oMessageBar             // messageBar
    ::dm      := drgDialog:dataManager             // dataManager
    ::dc      := drgDialog:dialogCtrl              // dataCtrl
    ::df      := drgDialog:oForm                   // form

    for x := 1 to len(members) step 1
      if  members[x]:ClassName() = 'drgPushButton'
        if( ischaracter(members[x]:event) .and. ;
                        members[x]:event = 'prepocet', ::pb_prepocet := members[x], nil )
      endif
    next

    ::pb_prepocet:disable()
  return self


HIDDEN:
  var    msg, dm, dc, df
  var    pb_prepocet
  *
ENDCLASS


method FIN_prepkurroz_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
  ::drgUsrClass:init(parent)

  ::rok     := 0
  ::mena    := "EUR"
  ::kurz    := 0.0000
  ::rokzpet := 0

  drgDBMS:open('FakPriHD')
  drgDBMS:open('FakVysHD')
  drgDBMS:open('c_meny')
return self


method FIN_prepkurroz_IN:drgDialogInit(drgDialog)
return self


method FIN_prepkurroz_IN:postValidate(drgVar)
  local  name := Lower(drgVar:name)
  local  changed := drgVAR:Changed()
  local  value := drgVar:get()
  local  lok := .t.

  do case
  case( name = 'm->rok')
    if value = 0
      drgMsgBox(drgNLS:msg('Rok je povinný údaj !!!'))
      lok := .f.
    endif

  case( name = 'm->mena')
    if Empty(value)
      drgMsgBox(drgNLS:msg('Zkratka mìny je povinný údaj !!!'))
      lok := .f.
    endif

  case( name = 'm->kurz')
    if value = 0
      drgMsgBox(drgNLS:msg('Kurz je povinný údaj !!!'))
      lok := .f.
    endif

    if lok
      apos_pb  := getWindowPos( ::pb_prepocet:oxbp )
      asize_pb := ::pb_prepocet:oxbp:currentSize()

      apos     := { apos_pb[1] +asize_pb[1]/2, apos_pb[2] +asize_pb[2]/2 }

      setCursorPos( apos[1], apos[2] )
      setAppFocus( ::pb_prepocet:oxbp )
    endif
  endCase

  ::dataManager:save()

  if ::rok <> 0 .and. .not. empty(::mena) .and. ::kurz <> 0
    ::pb_prepocet:enable()
  endif
return lok


method FIN_prepkurroz_IN:postLastField(drgVar)
return .t.


method FIN_prepkurroz_IN:prepocet(drgVar)
  local  lok, cx
  local  nsel

  nsel := confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                      ;
                       'opravdu požadujete provést pøepoèet pohledávek a závazkù ...' +CRLF + ;
                       '     pro rok  ...   ' +str(::rok,4)                           +CRLF + ;
                       '     mìnu     ...   ' +::mena                                 +CRLF + ;
                       '     kurzem  ... '    +str(::kurz)                                  , ;
                       'Pøepoèet pohledávek a závazkù kurzem ...'                           , ;
                       XBPMB_YESNO                                                          , ;
                       XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
  _clearEventLoop(.t.)


  if nsel = XBPMB_RET_YES

    drgServiceThread:progressStart(drgNLS:msg('Pøepoèet kurzovních rozdílù u faktur pøijatých ! ... ', 'FAKPRIHD'), ;
                                               fakprihd->(lastRec())  )
    FakPriHD->(dbGoTop())
    do while .not. FakPriHD->(Eof())

      lok := FakPriHD->nRok <= ::rok                             ;
             .and. FakPriHD->nCenZakCel <> FakPriHD->nUhrCelFak  ;
             .and. FakPriHD->nCisUzv    <> ::rok                 ;
             .and. FakPriHD->cZkratMenZ =  ::mena

      if lok
        if FakPriHD ->( dbRlock())
          cx := Chr(13) +Chr(10)
          cx := cx + "Pøepoèet kurzù za rok " + Str(::rok,4) +Chr(13) +Chr(10)
          cx := cx + " - pùvodní kurz             (nKurZahMen): "  +Str(FakPriHD ->nKurZahMen) +Chr(13) +Chr(10)
          cx := cx + " - pùvodní základní cena    (nCenZakCel): "  +Str(FakPriHD ->nCenZakCel) +Chr(13) +Chr(10)
          cx := cx + " - pùvodní fakturovaná cena (nCenFakCel): "  +Str(FakPriHD ->nCenFakCel) +Chr(13) +Chr(10)
          cx := cx + " - pùvodní uhrazená èástka  (nUhrCelFaZ): "  +Str(FakPriHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
          FakPriHD ->mPopisFak  := FakPriHD ->mPopisFak +cx

          FakPriHD ->nKurZahMen := ::kurz
          FakPriHD ->nCenZakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
          FakPriHD ->nCenFakCel := FakPriHD ->nCenZahCel *FakPriHD ->nKurZahMen
          FakPriHD ->nUhrCelFak := FakPriHD ->nUhrCelFaZ *FakPriHD ->nKurZahMen
          FakPriHD ->nCisUzv    := ::rok

          FakPriHD ->( dbUnlock())
        endif
      endif
      drgServiceThread:progressInc()
      FakPriHd->( dbSkip())
    enddo
    drgServiceThread:progressEnd()


    drgServiceThread:progressStart(drgNLS:msg('Pøepoèet kurzovních rozdílù u faktur vystavených ! ... ', 'FAKVYSHD'), ;
                                               fakvyshd->(lastRec()) )
    FakVysHD ->(dbGoTop())

    do while !FakVysHD->(Eof())

      lOK := FakVysHD->nRok <= ::rok                           ;
            .and. FakVysHD->nCenZakCel <> FakVysHD->nUhrCelFak ;
            .and. FakVysHD->nCisUzv    <> ::rok                ;
            .and. FakVysHD->cZkratMenZ =  ::mena

      if lOK
        if ReplREC( "FakVysHD")
          cX := Chr(13) +Chr(10)
          cX := cX + "Pøepoèet kurzù za rok " + Str(::rok,4) +Chr(13) +Chr(10)
          cX := cX + " - pùvodní kurz             (nKurZahMen): "  +Str(FakVysHD ->nKurZahMen) +Chr(13) +Chr(10)
          cX := cX + " - pùvodní základní cena    (nCenZakCel): "  +Str(FakVysHD ->nCenZakCel) +Chr(13) +Chr(10)
          cX := cX + " - pùvodní fakturovaná cena (nCenFakCel): "  +Str(FakVysHD ->nCenFakCel) +Chr(13) +Chr(10)
          cX := cX + " - pùvodní uhrazená èástka  (nUhrCelFaZ): "  +Str(FakVysHD ->nUhrCelFaZ) +Chr(13) +Chr(10)
          FakVysHD ->mDolFakCis := FakVysHD ->mDolFakCis +cX

          FakVysHD ->nKurZahMen := ::kurz
          FakVysHD ->nCenZakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
          FakVysHD ->nCenFakCel := FakVysHD ->nCenZahCel *FakVysHD ->nKurZahMen
          FakVysHD ->nUhrCelFak := FakVysHD ->nUhrCelFaZ *FakVysHD ->nKurZahMen
          FakVysHD ->nCisUzv    := ::rok

          FakVysHD ->( dbUnlock())
        endif
      endif

      drgServiceThread:progressInc()
      FakVysHd->( dbSkip())
    enddo
    drgServiceThread:progressEnd()
  endif

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

return .t.


method FIN_prepkurroz_IN:c_meny(drgVar)
  local lok, cx

  DRGDIALOG FORM 'C_MENY' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit

//  IF ( nExit != drgEVENT_QUIT )
    ::mena := c_meny ->czkratmeny
    ::dm:set( 'M->mena', c_meny ->czkratmeny )
//    ::dm:refresh
    lOK := .T.
//  ENDIF


return .t.