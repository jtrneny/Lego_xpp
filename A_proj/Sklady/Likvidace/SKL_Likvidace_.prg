***************************************************************************
*
* SKL_Likvidace_SCR.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\SKLADY\SKL_Sklady.ch"

*****************************************************************
* SKL_LikvPOL_SCR ... Likvidace dle položek dokladù
*****************************************************************
CLASS SKL_zauctuj_ FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  Uctuj
  METHOD  Destroy

HIDDEN:
  VAR     cDenik
ENDCLASS

*
*****************************************************************
METHOD SKL_zauctuj_:init(parent)

  ::drgUsrClass:init(parent)

RETURN self


METHOD SKL_zauctuj_:uctuj(parent)

return

*
*****************************************************************
METHOD SKL_zauctuj_:destroy()
  ::drgUsrClass:destroy()
RETURN self



FUNCTION SklPreuctuj()
  local  chdw, citw, key, aIt := {}, lContinue := .t.
  local  isPrevod := alltrim( pvphead->cTypPohybu) = '80', nPocetDokl, x, nRec

  * pøecenìní
  if 'CEN400' $ pvphead->ctypdoklad
    drgDBMS:open( 'TYPDOKL')
    TYPDOKL->(dbSeek( upper(pvphead->ctypdoklad),, 'TYPDOKL06'))
    * hromadné pøecenìní
    if TYPDOKL->cmainfile = 'PVPHEAD'
*      PVPITEM->( ads_setaof(Format("nRok = %% .and. nDoklad = %%", {PVPHEAD->nRok,PVPHEAD->nDoklad})))
      PVPHEAD->( sx_RLock())
      PVPITEM->( dbGoTOP(), dbEVAL( {|| AADD( aIt, PVPITEM->( RecNo())) } ), dbGoTop() )
      PVPITEM->( sx_RLock( aIt))
      *
      uctLikv := UCT_likvidace():New(Upper(PVPHead->cUloha) + Upper( PVPHead->cTypDoklad),.T.)
*      PVPITEM->(ads_clearaof())
      pvphead->(dbunlock(), dbcommit())
      pvpitem->(dbunlock(), dbcommit())

      lContinue := .f.
    else
      lContinue := .t.
    endif
  endif

if lContinue

  nPocetDokl := 1 // iif( alltrim( pvphead->cTypPohybu) = '80', 2,;
                  // iif( alltrim( pvphead->cTypPohybu) = '40', 0, 1  ))

  drgDBMS:open('C_SKLADY')

  chdw := 'pvpheadw'
  citw := if( pvphead->ctypdoklad=='SKL_VYD255', 'pvpitemw', 'pvpitemww')

  For x := 1 TO nPocetDokl
    drgDBMS:open( chdw, .T.,.T.,drgINI:dir_USERfitm); ZAP
    drgDBMS:open( citw, .T.,.T.,drgINI:dir_USERfitm); ZAP
/*
    if isPrevod
      if x = 1
        nRec := pvphead->( recno())
        mh_COPYFLD('pvphead', chdw, .T.,,, .F.)
        pvpitem->( dbGoTop(),  ;
                   dbeval( {|| if( alltrim( pvpitem->cTypPohybu) = '80', mh_copyfld('pvpitem', citw, .t., .t.), nil) }))
      else
        key := StrZero( pvphead->nrok,4) + padr('40', 10) +  StrZero( pvphead->ndoklad,10)
        pvphead->( dbseek( Key,,'PVPHEAD18'))
        mh_COPYFLD('pvphead', chdw, .T.,,, .F.)
        PVPITEM->( mh_SetScope( PVPHEAD->nDoklad))
        pvpitem->( dbGoTop(),  ;
                   dbeval( {|| if( alltrim( pvpitem->cTypPohybu) = '40', mh_copyfld('pvpitem', citw, .t., .t.), nil) }))
      endif

    else
      mh_COPYFLD('pvphead', chdw, .T.,,, .F.)
      pvpitem->( dbGoTop(),  ;
                 dbeval( {||mh_copyfld('pvpitem', citw, .t., .t.) }))
    endif
*/

    c_sklady->( dbSeek( Upper(pvphead->ccissklad),,'C_SKLAD1'))
    mh_COPYFLD('pvphead', chdw, .T.,,, .F.)
    pvpitem->( dbGoTop(),  ;
               dbeval( {|| ( mh_copyfld('pvpitem', citw, .t., .t.), ;
                             (citw)->nKlikvid := 0                , ;
                             (citw)->nZlikvid := 0                  ) } ))

    (chdw)->(dbcommit(),dbgotop())
    (citw)->(dbcommit(),dbgotop())
    *
    uctLikv  := UCT_likvidace():New(upper((chdw)->cUloha) +upper((chdw)->ctypdoklad),.t.)  //  ,,chdw)
    ucetpolw->(dbcommit(),dbgotop())
    if( isPrevod .and. x = 2, uctLikv:ucetpol_rlo := {}, nil )
    uctLikv:ucetpol_wrt()

     pvphead->(dbunlock(), dbcommit())
       pvpitem->(dbunlock(), dbcommit())
        ucetpol ->(dbunlock(), dbcommit())

    key := StrZero((chdw)->nrok,4) + Upper((chdw)->ctyppohybu) +  StrZero((chdw)->ndoklad,10)

    if pvphead->(dbSeek(key,,'PVPHEAD18'))
      pvphead->(dbRlock())
      pvphead->nKlikvid := (chdw)->nKlikvid
      pvphead->nZlikvid := (chdw)->nZlikvid
    endif

    (citw)->(dbGoTop())
    do while .not. (citw)->(Eof())
      key := StrZero((citw)->nrok,4) + Upper((citw)->ctyppohybu)    ;
              + StrZero((citw)->ndoklad,10) + StrZero((citw)->norditem,5)
      if pvpitem->(dbSeek(key,,'PVPITEM29'))
        pvpitem->(dbRlock())
        pvpitem->nKlikvid := (citw)->nKlikvid
        pvpitem->nZlikvid := (citw)->nZlikvid
      endif
      (citw)->(dbSkip())
    enddo
     pvphead->(dbunlock(), dbcommit())
       pvpitem->(dbunlock(), dbcommit())
  next

**  if( isPrevod, pvphead->( dbgoto(nrec)), nil )
endif

Return nil