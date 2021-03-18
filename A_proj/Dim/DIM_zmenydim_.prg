////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  DIM_zmenydim_.PRG                                                         //
//                                                                            //
//  Copyright:                                                                //
//                                                                            //
//                                                                            //
//  Contents:                                                                 //
//  Implementation of (DOS - DIMEVID)                                         //
//                                                                            //
//  Remarks:                                                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"


Static  nCISZMDIM


**                      ULOŽENÍ zmen do ZMENYDIM
************** 1_ZAØAZENÍ, 2_OPRAVA, 3_PØEVOD, 4_VYØAZENÍ *********************
FUNCTION ZMENYDIM(oDialog, nLEVLs, lInZMEn)
  local  klicSkMis := '', klicOdMis := '', invCisDim := 0, pocKusDim := 0
  local  ncisZmDim, ninvCisDim
**
  Local  N
  Local  cFIELD
  Local  cUSERabb := SYSCONFIG( 'SYSTEM:cUSERABB' )
  Local  dm, drgVars, drgVar
  Local  axTEXTs  := { { 'ZAØAZENÍ', 10 }, { 'OPRAVA'  ,  0 }, ;
                       { 'PØEVOD'  , 80 }, { 'VYØAZENÍ', 53 }  }
  *
  local ky := upper(uctObdobi:DIM:culoha) +strZero(uctObdobi:DIM:nrok,4) +strZero(uctObdobi:DIM:nobdobi,2)

  ucetsys->(dbseek(ky,,'UCETSYS3'))

  DEFAULT lInZMEn TO .F.
  dm      := oDialog:dataManager
  drgVars := oDialog:dataManager:vars:values

  if isObject(dm:has('m->klicSkMis'))                                           // ZMENYDIM
    klicSkMis := dm:get( 'm->klicSkMis' )
    klicOdMis := dm:get( 'm->klicOdMis' )
    invCisDim := dm:get( 'm->invCisDim' )
    pocKusDim := dm:get( 'm->pocKusDim' )
  else                                                                          // MSDIM
    klicSkMis := dm:get( 'msdim->cklicSkMis' )
    klicOdMis := dm:get( 'msdim->cklicOdMis' )
    invCisDim := dm:get( 'msdim->ninvCisDim' )
    pocKusDim := dm:get( 'msdim->npocKusDim' )
  EndIf

  fordRec( {'ZMENYDIM,5'} )
  zmenydim ->( dbGoBottom())
  ncisZmDim := zmenydim->ncisZmDim +1
  fordRec()

  ninvCisDim := if(nLEVLs = 1 .and. !lInZMEn, invCisDim, msdim->ninvCisDIm )

  if(( nLEVLs = 1 .or. nLEVLs = 3 .or. nLEVLs = 4 ) .and. addRec('ZMENYDIM') )
    mh_copyFld('ucetsys', 'zmenydim',, .f.)
    zmenydim->ninvCisDim := ninvCisDim

    do case
    case( nLEVLs = 1 )                                                          // zaøazení _ 10/40
      zmenydim->cklicSkMis := klicSkMis
      zmenydim->cklicOdMis := klicOdMis
      zmenydim->cbroPolDim := if( lInZMEn, 'ZAØAZENO pøe_DIM', '' )
      if lInZMEn
        zmenydim->cnewVal  := strTran(msdimw->cklicSkMis +' /' +msdimw->cklicOdMis +' /' +str(msdimw->ninvCisDim), ' ', '' )
      endif
      zmenydim->npocKusDim := pocKusDim
      zmenydim->npoh_Sign  := +1

    case( nLEVLs = 3 )                                                          // pøevod   _ 80
       zmenydim->cklicSkMis := msdim->cklicSkMis
       zmenydiM->cklicOdMis := msdim->cklicOdMis
       zmenydiM->cbroPolDim := 'SK_m /OD_m /MNOž'
       zmenydim->coldVal    := strTran(msdim->cklicSkMis + '/' + ;
                                       msdim->cklicOdMis + '/' + ;
                                       str(msdim->npocKusDim), ' ', '')
       zmenydim->cnewVal    := strTran(if(empty(klicSkMis), msdim->cklicSkMis, klicSkMis) + '/' + ;
                                       if(empty(klicOdMis), msdim->cklicOdMis, klicOdMis) + '/' + ;
                                       str(pocKusDim), ' ', '' )
        zmenydim->npocKusDim := pocKusDim
       zmenydim->npoh_Sign  := -1

    case( nLEVLs = 4 )                                                          // vyøazení  _ 53
      zmenydim->cklicSkMis := msdim->cklicSkMis
      zmenydim->cklicOdMis := msdim->cklicOdMis
      zmenydim->coldVal    := str(msdim->npocKusDim)
      zmenydim->cnewVal    := str(pocKusDim)
      zmenydim->npocKusDim := pocKusDim
      zmenydim->npoh_Sign  := -1
    endcase

    zmenydim->cpopZmDim   := axTEXTs[nLEVLs,1]
    zmenydim->ncisZmDim   := ncisZmDim
    zmenydim->ddatZmDim   := date()
    zmenydim->ccasZmDim   := time()

    ZMENYDIM ->cUSERABB   := cUSERabb
    ZMENYDIM ->nPOH_DIM   := If( nLEVLs == 1 .and. lInZMEn, 40, axTEXTs[ nLEVLs, 2] )
    ZMENYDIM ->lPOH_DIM   := .T.
    ZMENYDIM ->cZKRATjedn := If(lInZMEn, MSDIM ->cZKRATjedn, dm:get('MSDIM->cZKRATJEDN'))
    ZMENYDIM ->nCENjedDIM := If(lInZMEn, MSDIM ->nCENJEDDIM, dm:get('MSDIM->nCENJEDDIM'))
    ZMENYDIM ->nCENCELDIM := ZMENYDIM ->nPOCKUSDIM * ZMENYDIM ->nCENJEDDIM

    ZMENYDIM ->( dbUnlock())
    nCISZMDIM++
  Else
    For N := 1 To dm:vars:size() STEP 1
      drgVar := drgVars[N,2]
      cFIELD := Upper(drgParseSecond(drgVar:name,'>'))

      IF drgVar:changed()
        If( cFIELD <> 'NPOCKUSDIM' .and. cFIELD <> 'NCENJEDDIM' .and. cFIELD <> 'NCENCELDIM')
           ADDrec( 'ZMENYDIM' )
**           mh_COPYFLD('UCETSYS', 'ZMENYDIM',, .f.)
           mh_COPYFLD('MSDIM'  , 'ZMENYDIM',, .f.)

           ZMENYDIM ->cPOPZMDIM  := 'OPRAVA'
           ZMENYDIM ->cFLDPOLDIM := cFIELD
           ZMENYDIM ->cBROPOLDIM := drgVar:ref:desc
           ZMENYDIM ->cOLDVAL    := ALLtoc( drgVar:initValue)
           ZMENYDIM ->cNEWVAL    := ALLtoc( drgVar:value    )
           ZMENYDIM ->dDATZMDIM  := DATE()
           ZMENYDIM ->cCASZMDIM  := TIME()
           ZMENYDIM ->cUSERABB   := cUSERABB
           ZMENYDIM ->nCISZMDIM  := nCISZMDIM
           ( nCISzmDIM += 1, ZMENYDIM ->( dbUnlock()) )
         EndIf
      EndIf
    Next
  EndIf

  If( !lInZMEn, nCISZMDIM := NIL, NIL )
RETURN(NIL)


STATIC FUNCTION ALLtoc( xVal)
  Local  cTyp := ValType( xVal)
  Local  cVal

  cVal := If( cTyp == 'L', If( xVal, '.T.', '.F.' ) , ;
            If( cTyp == 'D', DToC( xVal)            , ;
              If( cTyp == 'N', Str( xVal), xVal   ) ) )
Return(cVal)