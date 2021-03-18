***************************************************************************
* HIM_Support_1.PRG
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\HIM\HIM_HIM.ch"

*****************************************************************
* HIM_Support_1 ...
*****************************************************************
CLASS HIM_Support_1 FROM HIM_Main, drgUsrClass

EXPORTED:
  METHOD  Init, Destroy

HIDDEN:
  VAR     cDenik, aFILES
  METHOD  ModiFILES
ENDCLASS

*****************************************************************
METHOD HIM_Support_1:init(parent, cTASK)
  Local oMoment

  DEFAULT cTASK TO 'HIM'
  ::drgUsrClass:init(parent)
  *
  ::HIM_Main:Init( parent, cTASK = 'HIM')
  ::aFILES := { 'maj','majz','umaj','umajz','dmaj','dmajz','majobd','majzobd','c_danskp','c_typskp',;
                'zmaju','zmajuz' }
  *
  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést aktualizaci souborù ?' ) )
    oMoment := SYS_MOMENT( 'Probíhá aktualizace souborù ...')
    *
    ::ModiFILES()
    *
    oMoment:destroy()
  ENDIF
  *
RETURN self

*****************************************************************
METHOD HIM_Support_1:ModiFiles()
  Local cFILE, isLock, cKey

  FOR n := 1 TO LEN( ::aFILES)
    cFILE := lower( ::aFILES[ n])
    drgDBMS:open( cFILE )
    IF ( isLock := (cFILE)->( FLOCK()))
       ( cFile)->( dbGoTOP())
       *
       Do Case
       Case cFile $ 'maj,majz'
         DO WHILE !( cFile)->( EOF())
           *
           (cFile)->nOdpiskD   := (cFile)->nOdpisk
           (cFile)->cOdpiskD   := (cFile)->cOdpisk
*           (cFile)->nOdpisk    :=
*           (cFile)->cOdpisk    :=
           (cFile)->nCenaPorU  := (cFile)->nCenaVstU // - (cFile)->nDotaceUCT
           (cFile)->nCenaPorD  := (cFile)->nCenaVstD // - (cFile)->nDotaceDAN
           *
           (cFile)->nTypVypUO  := 2    //  ( 1 = plný, 2 = zkrácený )
           *
           (cFile)->cTypPohybu := AllTrim(Str((cFile)->nDrPohyb))
           (cFile)->lHmotnyIM  := .T.
           *
           (cFile)->( dbSKIP())
         ENDDO

       Case cFile $ 'zmaju,zmajuz'
         drgDBMS:open( 'c_TypPoh')
         DO WHILE !( cFile)->( EOF())
           (cFile)->cTypPohybu := AllTrim(Str((cFile)->nDrPohyb))

           cKEY := IF( cfile = 'zmaju', 'I', 'Z') + 'DOKLADY        ' + (cFile)->cTypPohybu
           C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
           (cFile)->cTypDoklad := c_TypPoh->cTypDoklad
           (cFile)->( dbSKIP())
         ENDDO

       *
       Case cFile $ 'umaj,umajz,dmaj,dmajz,majobd,majzobd'
         DO WHILE !( cFile)->( EOF())
           (cFile)->nOdpiskD   := (cFile)->nOdpisk
           (cFile)->cOdpiskD   := (cFile)->cOdpisk
           (cFile)->( dbSKIP())
         ENDDO

       Case cFile $ 'c_danskp'
         DO WHILE !( cFile)->( EOF())
           (cFile)->nOdpiskD   := (cFile)->nOdpisk
           (cFile)->cOdpiskD   := (cFile)->cOdpisk
           (cFile)->lHmotnyIM  := .T.
*           (cFile)->nMesOdpiD  := ??? mìsíèní daò. odpis pro nehm. IM
           (cFile)->( dbSKIP())
         ENDDO

       Case cFile $ 'c_typskp'
         DO WHILE !( cFile)->( EOF())
           (cFile)->nOdpiskD   := (cFile)->nOdpisk
           (cFile)->cOdpiskD   := (cFile)->cOdpisk
           (cFile)->( dbSKIP())
         ENDDO
       *
       EndCase
       *
       (cFILE)->( dbUnlock())
    ENDIF
  NEXT

RETURN Nil

*****************************************************************
METHOD HIM_Support_1:destroy()
  ::drgUsrClass:destroy()
RETURN self