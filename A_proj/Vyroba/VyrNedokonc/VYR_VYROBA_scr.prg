
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* VYR_VYROBA_SCR
********************************************************************************
CLASS VYR_VYROBA_SCR FROM drgUsrClass

EXPORTED:
  VAR     cFILE
  METHOD  Init, getForm, itemMarked
ENDCLASS

********************************************************************************
METHOD VYR_VYROBA_SCR:init(parent )

  ::cFILE := ALLTRIM( drgParseSecond( parent:initParam, ',' ))
  drgDBMS:open( ::cFILE  )
  drgDBMS:open( 'VyrZAK' )

RETURN self

********************************************************************************
METHOD VYR_VYROBA_SCR:getForm()
  LOCAL oDrg, drgFC
  LOCAL cTitle := IF( ::cFILE = 'ROZPRAC', 'P�EHLED nedokon�en� v�roby',;
                  IF( ::cFILE = 'DOKONC' , 'P�EHLED dokon�en� v�roby',;
                  IF( ::cFILE = 'KALKZAK', 'P�EHLED v�ech zak�zek', '' )))

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100, 25 DTYPE '10' TITLE cTitle             ;
                                             FILE ::cFILE             ;
                                             GUILOOK 'Message:y,Action:y,IconBar:y:drgStdBrowseIconBar'
  odrg:tskObdobi := 'VYR'


  DRGACTION INTO drgFC CAPTION 'info ~Zak�zka'  EVENT 'VYR_VYRZAK_INFO' TIPTEXT 'Informa�n� karta vyrobn� zak�zky '
  DRGACTION INTO drgFC CAPTION 'kontr ~MZDn�kl'  EVENT 'VYR_ROZPRAC_CTRL_MZ_SCR' TIPTEXT 'Kontrola mzdov�ch n�klad� '

  DRGDBROWSE INTO drgFC SIZE 100,24.9 ;
                        FIELDS 'nRok, nObdobi, cCisZakaz, nSkPrMatZ, nSkPrMzdZ, nSkPrKooZ, nSkRezieZ' ;
                        INDEXORD 1 SCROLL 'ny' CURSORMODE 3 PP 7  POPUPMENU 'y'  ;
                        ITEMMARKED 'ItemMarked'
RETURN drgFC

********************************************************************************
METHOD VYR_VYROBA_SCR:itemMarked()
  VyrZAK->( dbSEEK( Upper( (::cFILE)->cCisZakaz),, 'VYRZAK1'))
RETURN self