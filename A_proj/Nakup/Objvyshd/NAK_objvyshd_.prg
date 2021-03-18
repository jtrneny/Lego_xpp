#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
*
#include "..\Asystem++\Asystem++.ch"
#include "..\FINANCE\FIN_finance.ch"


function nak_objvyshd_cpy(oDialog)
  local  file_name, doklad, ky
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)
  *
  local  cf := "nOSOBY = %%", filtrs, ncisOsoby, l_setTE := l_setEM := .f.
  local  inScope
  local  lok_append2 := .f.

  * objedn�vky p�ijat�
  drgDBMS:open('OBJVYSHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('OBJVYSITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VZTAHOBJw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  file_name := objvysitw ->( DBInfo(DBO_FILENAME))
               objvysitw ->( DbCloseArea())
  DbUseArea(.t., oSession_free, file_name,'objvysitw',.t.,.f.) ; objvysitw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name,'objvy_itw',.t.,.t.) ; objvy_itw->(AdsSetOrder(1))
  *
  file_name := vztahobjw ->( DBInfo(DBO_FILENAME))
               vztahobjw ->( DbCloseArea())
  DbUseArea(.t., oSession_free, file_name,'vztahobjw',.t.,.f.) ; vztahobjw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name,'vztahob_w',.t.,.t.) ; vztahob_w->(AdsSetOrder(1))


  if .not. lNEWrec
    mh_COPYFLD('objvyshd','objvyshdw', .t., .t.)

    if .not. (inScope := objVysit->(dbscope()))
      fordRec( { 'objVysit' } )
      objVysit->(ordSetFocus('OBJVYSI8'),dbsetscope(SCOPE_BOTH, objVyshd->ndoklad), DbGoTop() )
    endif

    objvysit ->(DbGoTop())
    do while .not. objvysit ->(Eof())
      mh_COPYFLD('objvysit','objvysitw',.t., .t.)
      objvysit->(DbSkip())
    enddo
    objvysit->(dbgotop())

    if .not. inSCope
      objVysit->(dbclearscope())
      fordRec()
    endif

    vztahobj->(AdsSetOrder('VZTAHOB3')                         , ;
               dbsetScope(SCOPE_BOTH, upper(objvyshd->ccisOBJ)), ;
               dbgotop()                                         )

    do while .not. vztahobj->(eof())
      ky := strzero(vztahobj->ncisFirmy,5) +upper(vztahobj->ccislOBint) + ;
                                            upper(vztahobj->ccisSklad ) + ;
                                            upper(vztahobj->csklPol   )
      mh_copyfld('vztahobj','vztahobjw', .t., .t.)

      vztahobjw->nmnozOBorg := vztahobj->nmnozOBdod
      if( objitem->(dbseek(ky,,'OBJITE16')), vztahobjw->_nrecobjit := objitem->(recNo()), nil)
      vztahobj->(dbskip())
    enddo
    vztahobj->(dbClearScope())

  else
    objvyshdw ->(dbappend())
    doklad := FIN_RANGE_KEY('OBJVYSHD')[2]

    if isobject(oDialog)                          .and. ;
       oDialog:drgDialog:cargo = drgEVENT_APPEND2 .and. ;
       .not. objVyshd->(eof())

       oDialog:lok_append2 := lok_append2 := .t.
       mh_copyFld( 'objVyshd', 'objVyshdw', .f., .f. )

       ( objvyshdw->ndoklad    := doklad                      , ;
         objvyshdw->ddatobj    := date()                      , ;
         objvyshdw->cintpracov := sysconfig('system:cusernam'), ;
         objvyshdw->cnazOsoVyr := sysconfig('system:cusernam'), ;
         objvyshdw->cnazpracov := logOsoba                    , ;
         objvyshdw->cnazOsoZpr := logOsoba                    , ;
         objvyshdw->ddatTisk   := ctod('  .  .  ')            , ;
         objvyshdw->ddatEmail  := ctod('  .  .  ')              )

       if .not. (inScope := objVysit->(dbscope()))
         fordRec( { 'objVysit' } )
         objVysit->(ordSetFocus('OBJVYSI8'),dbsetscope(SCOPE_BOTH, objVyshd->ndoklad), DbGoTop() )
       endif

       do while .not. objvysit->( eof())
         mh_COPYFLD('objvysit','objvysitw',.t., .t.)
         objvysit->(DbSkip())
       enddo
       objvysit->(dbgotop())

       if .not. inSCope
         objVysit->(dbclearscope())
         fordRec()
       endif

    else
      ( objvyshdw->ndoklad    := doklad                        , ;
        objvyshdw->ddatobj    := date()                        , ;
        objvyshdw->czkratmeny := sysconfig('finance:czaklmena'), ;
        objvyshdw->czkratmenz := sysconfig('finance:czaklmena'), ;
        objvyshdw->nkurzahmen := 1                             , ;
        objvyshdw->nmnozprep  := 1                             , ;
        objvyshdw->cintpracov := sysconfig('system:cusernam')  , ;
        objvyshdw->cnazOsoVyr := sysconfig('system:cusernam')  , ;
        objvyshdw->cnazpracov := logOsoba                      , ;
        objvyshdw->cnazOsoZpr := logOsoba                        )
    endif

    osoby->( dbseek( logCisOsoby,,'OSOBY01'))

    objvyshdw->ncisOsoZpr := osoby->ncisOsoby
    objvyshdw->cnazpracov := osoby->cosoba
    objvyshdw->cnazOsoZpr := osoby->cosoba

    filtrs := format( cf, { isNull( osoby->sID, 0) })
    vazSpoje->( ads_setAof( filtrs ), dbgoTop())

    do while .not. vazSpoje->(eof())
      if spojeni->(dbseek( vazSpoje->spojeni,,'SPOJENI01'))
        do case
        case allTrim( spojeni->czkrSpoj) = 'TEL_ZAM'   .and. .not. l_setTe
          objvyshdw->nsspoTeZpr := isNull( spojeni->sID, 0)
          l_setTE := .t.

        case allTrim(spojeni->czkrSpoj) = 'EMAIL_ZAM' .and. .not. l_setEM
          objvyshdw->nsspoEmZpr := isNull( spojeni->sID, 0)
          l_setEM := .t.
        endcase
      endif
      vazSpoje->(dbskip())
    enddo

    vazSpoje->(ads_clearAof())
    c_staty->(dbSeek(objvyshdw->czkratstat))
  endif
return nil

*
** ulo�en� objedn�vky vystaven� ************************************************
function nak_objvyshd_wrt_inTrans(odialog)
  local lDone

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := nak_objvyshd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()
/*
    objvyshd->(dbunlock())
     objvysit->(dbunlock())
      vztahobj->(dbunlock())
       objitem ->(dbunlock())
        cenzboz ->(dbunlock())
         int_Pozad->(dbunlock())
*/
  END SEQUENC

  _clearEventLoop(.t.)
return lDone


*
** ulo�en� objedn�vky vystaven� ************************************************
static function nak_objvyshd_wrt(odialog)
  local  mainOk   := .t., nrecor, filter
  local  anObv_i  := {}, anCen := {}, anPoz := {}, anVzt := {}, anObp_i := {}
  local  cfile_iv

  objvysitw->(AdsSetOrder(0),dbgotop())
  *
  do while .not. objvysitw->(eof())
    aadd(anObv_i, objvysitw->_nrecor )

    cfile_iv := lower( objVysitw->cfile_iv)

    if( cfile_iv = 'cenzboz', aadd(anCen, objvysitw->nrecs_iv), ;
      if( cfile_iv = 'intpozad', aadd(anPoz, objvysitw->nrecs_iv), nil ))

    objvysitw->(dbskip())
  enddo

  vztahobjw->(AdsSetOrder(0),dbgotop())
  *
  do while .not. vztahobjw->(eof())
    aadd(anVzt  , vztahobjw->_nrecor   )
    aadd(anObp_i, vztahobjw->_nrecobjit)

    vztahobjw->(dbSkip())
  enddo

  mainOk := cenzboz->(sx_rlock(anCen)) .and. objitem->(sx_rlock(anObp_i))

  if .not. odialog:lnewRec
    objvyshd->(dbgoto(objvyshdw->_nrecor))

    mainOk := objvyshd->(sx_rlock())        .and. ;
              objvysit->(sx_rlock(anObv_i)) .and. ;
              vztahobj->(sx_rlock(anVzt))
  else
    odialog:int_cisObj()
    objvysitw->( Flock(), dbgotop(), dbeval( { || objvysitw->ccisObj := objvyshdw->ccisObj } ))
  endif

  if mainOk
    if(objvyshdw->_delrec <> '9', mh_copyfld('objvyshdw','objvyshd',odialog:lnewRec, .f.), nil)
    objvysitw->( FLock(), dbgotop())

    do while .not. objvysitw->(eof())

      if((nrecor := objvysitw->_nrecor) = 0, nil, objvysit->(dbgoto(nrecor)))
      if   objvysitw->_delrec = '9'
       if( nrecor = 0, nil, objvysit->(dbdelete()) )
      else
        objvysitw->ndoklad   := objvyshd->ndoklad
        objvysitw->ncisFirmy := objvyshd->ncisFirmy
        objvysitw->ccisObj   := objvyshd->ccisObj

        mh_copyfld('objvysitw','objvysit',(nrecor=0), .f.)
      endif

      * polo�ka je z intPozad
      * nen� vyjasn�no ru�en�, polo�ky objedn�vky s touto vazbou
      * intPozad->nOBJVYSIT := objVysit->sID
      * intPozad->cstavDokl := 'O '
      nak_ap_intPozad()
      *
      ** p�ipojen vztahobj **
      nak_ap_vztahobj(nrecor)
      *
      ** vazba na dodZboz
      if( objvysitw->_delrec = '9', nil, nak_ap_dodZboz() )

      objvysitw->(dbskip())
    enddo

    if(objvyshdw->_delrec = '9', objvyshd->(dbdelete()), nil)
  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat OBJEDN�VKU VYSTAVENOU, blokov�no u�ivatelem ...'))
  endif

  objvyshd->(dbunlock(),dbcommit())
   objvysit->(dbunlock(),dbcommit())
    vztahobj->(dbunlock(),dbcommit())
     objitem ->(dbunlock(),dbcommit())
      cenzboz ->(dbunlock(),dbcommit())
       int_Pozad->(dbunlock(),dbcommit())
return mainOk


static function nak_ap_intPozad()

  if .not. (objvysitw->_delrec = '9') .and. objVysitw->nINTPOZAD <> 0

    if int_Pozad->(dbseek( objVysitw->nINTPOZAD,, 'ID'))
      if int_Pozad->( sx_RLock())
       int_Pozad->nOBJVYSIT := isNull( objVysit->sID, 0)
       int_Pozad->cstavDokl := 'O '
      endif
    endif
  endif
return .t.


static function nak_ap_vztahobj(nrecor)
  local recvzt, recobj
  local filter := format("ccisOBJ = '%%' .and. nintCount = %%",{objvyshdw->ccisOBJ,objvysitw->nintCount})

  vztahobjw->(dbSetFilter(COMPILE(filter)),dbGoTop())

  do while .not. vztahobjw->(eof())
    recvzt := vztahobjw->_nrecor
    recobj := vztahobjw->_nrecobjit

    vztahobj->(dbgoto(recvzt))
    objitem ->(dbgoto(recobj))

    if objvysitw->_delrec = '9' .and. nrecor <> 0
      objitem->nmnozOBdod -= vztahobj->nmnozOBdod
      if(objitem->nmnozOBdod < 0, objitem->nmnozOBdod := 0, nil)
      vztahobj->(dbDelete())
    else
      mh_copyfld('vztahobjw','vztahobj',(recvzt=0), .f.)
*-    objitem->nmnozKOdod -= (vztahobj->nmnozOBdod -vztahobjw->nmnozOBdod)
      objitem->nmnozOBdod += (vztahobj->nmnozOBdod -vztahobjw->nmnozOBdod)
    endif

    vztahobjw->(dbSkip())
  enddo
return nil


static function nak_ap_dodZboz()
  local cisFirmy := strZero(objVyshd->ncisFirmy,5)
  local cisSklad := upper(objVysit->ccisSklad)
  local sklPol   := upper(objVysit->csklPol)

  if .not. empty(cisFirmy) .and. .not. empty(cisSklad) .and. .not. empty(sklPol)
    if cenZboz->( dbseek( cisSklad +sklPol,,'CENIK03' ))
      if .not. dodZboz->( dbseek( cisFirmy +cisSklad +sklPol,,'DODAV6'))
        mh_copyFld( 'cenZboz', 'dodZboz', .t.)
        dodZboz->ckatcZbo   := objVysit->ckatcZbo
        dodZboz->ncisFirmy  := objVyshd->ncisFirmy
        dodZboz->cnazev     := objVyshd->cnazev
        dodZboz->ncenaOZbo  := objVysit->ncenNaoDod
        dodZboz->czkratMeny := objVyshd->czkratMenZ 
      else
        if dodZboz->( sx_RLock())
          if( dodZboz->ncenaOZbo = 0, dodZboz->ncenaOZbo := objVysit->ncenNaoDod, nil )
          if( dodZboz->ckatcZbo  <> objVysit->ckatcZbo )
            dodZboz->ckatcZbo := objVysit->ckatcZbo
          endif
        endif
      endif
    endif

    dodZboz->( dbunlock(),dbcommit())
  endif
return nil


*
** zru�en� objedn�vky vystaven� **
function nak_objvyshd_del(odialog)
  local  mainOk := .t.

  objvyshdw->_delrec := '9'
  objvysitw->(objvysitw->(AdsSetOrder(0),dbgotop()), dbeval({|| objvysitw->_delrec := '9'}))
  mainOk := nak_objvyshd_wrt(odialog)
return mainOk


function nak_objvyshd_cmp()

  objvyshdw->nkcBdObj  := ;
   objvyshdw->nkcZdObj  := ;
    objvyshdw->nmnozObDod := ;
     objvyshdw->nmnozPoDod := ;
      objvyshdw->npocPolObj := objvyshdw->nhmotnost := objvyshdw->nobjem := 0

  objvy_itw->(dbgotop())

  do while .not. objvy_itw->(eof())
    if (objvy_itw->_delrec <> '9')
      objvyshdw->nkcBdObj   += objvy_itw->nkcBdObj
      objvyshdw->nkcZdObj   += objvy_itw->nkcZdObj

      objvyshdw->nmnozObDod += objvy_itw->nmnozObDod
      objvyshdw->nmnozPoDod += objvy_itw->nmnozPoDod
      objvyshdw->nhmotnost  += objvy_itw->nhmotnost
      objvyshdw->nobjem     += objvy_itw->nobjem

      objvyshdw->npocPolObj ++
    endif

    objvy_itw->(dbskip())
  enddo

  c_typuhr ->( dbseek(objvyshdw->czkrtypuhr))
  objvyshdw->nkcZdObjz := mh_roundnumb(objvyshdw->nkcZdObj, c_typuhr->nkodzaokr)
return nil