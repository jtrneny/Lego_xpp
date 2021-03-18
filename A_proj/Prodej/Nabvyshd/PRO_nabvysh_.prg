#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"

*
** uložení nabídky vystavené v transakci ***************************************
function pro_nabvyshd_wrt_inTrans(oDialog)
  local  lDone := .t.

  oSession_data:beginTransaction()

  BEGIN SEQUENCE
    lDone := pro_nabvyshd_wrt(odialog)
    oSession_data:commitTransaction()

  RECOVER USING oError
    lDone := .f.
    oSession_data:rollbackTransaction()

  END SEQUENCE
return lDone


function PRO_nabvyshd_cpy(oDialog)
  local  file_name, ky
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  * nabídky vystavené
  drgDBMS:open('NABVYSHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('NABVYSITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  file_name := nabvysitw ->( DBInfo(DBO_FILENAME))
               nabvysitw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'nabvysitw', .t., .f.) ; nabvysitw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'nabit_iw' , .t., .t.) ; nabit_iw ->(AdsSetOrder(1))
  *
  if .not. lNEWrec
    mh_COPYFLD('NABVYSHD','NABVYSHDw', .t., .t.)

    NABVYSIT ->(DbGoTop())
    do while .not. NABVYSIT ->(Eof())
*      ky := upper(nabvysit->ccissklad) +upper(nabvysit->csklpol)
*      cenzboz->(dbseek(ky,,'CENIK03'))

      mh_COPYFLD('NABVYSIT','NABVYSITw',.t., .t.)
      nabvysitw->cfile_iv   := ''
      nabvysitw->nrecs_iv   := 0

      * vazba na vyrpol
      ky := upper(nabvysit->ccisZakaz) +upper(nabvysit->cvyrPol) +strZero(nabvysit->nvarCis,3)
      if vyrpol->(dbseek( ky,, 'VYRPOL1'))
        nabvysitw->cfile_iv   := 'vyrpol'
        nabvysitw->nrecs_iv   := vyrpol->(recNo())
      endif

      * originál
*      nabvysitw->cfile_iv   := 'cenzboz'
*      nabvysitw->nrecs_iv   := cenzboz->(recNo())
*      VyrPOL_cpy()
      NABVYSIT ->(DbSkip())
    enddo

    NABVYSIT->(dbgotop())
  else
    nabvyshdw ->(dbappend())

    doklad := fin_range_key('NABVYSHD')[2]

    ( nabvyshdw->ndoklad    := doklad                        , ;
      nabvyshdw->ddatodes   := date()                        , ;
      nabvyshdw->ddatdoodb  := date()                        , ;
      nabvyshdw->czkratmeny := sysconfig('finance:czaklmena'), ;
      nabvyshdw->czkratmenz := sysconfig('finance:czaklmena'), ;
      nabvyshdw->nkurZahMen := 1                             , ;
      nabvyshdw->nmnozPrep  := 1                             , ;
      nabvyshdw->cintpracov := logOsoba                        )
  endif

  c_staty->(dbseek(upper(nabvyshdw->czkratStat),,'C_STATY1'))
return nil


*
** uložení nabídky vystavené **************************************************
static function pro_nabvyshd_wrt(odialog)
  local  mainOk   := .t., nrecor, ky
  local  anNabi   := {}

  nabvysitw ->(AdsSetOrder(0),dbgotop())

  do while .not. nabvysitw->(eof())
    aadd(anNabi, nabvysitw->_nrecor )

    nabvysitw->(dbskip())
  enddo

  if .not. odialog:lnewRec
    nabvyshd ->(dbgoto(nabvyshdw->_nrecor))

    mainOk := nabvyshd ->(sx_rlock()) .and. ;
              nabvysit ->(sx_rlock(anNabi))
  else
*    odialog:int_cislObint(.t.)
*    objitemw->(dbgotop(), dbeval( { || objitemw->ccislObint := objheadw->ccislObint } ))
  endif


  if mainOk
    if(nabvyshdw->_delrec <> '9', mh_copyfld('nabvyshdw','nabvyshd', odialog:lnewRec, .f.), nil)
    nabvysitw ->(dbgotop())

    do while .not. nabvysitw ->(eof())

      if((nrecor := nabvysitw ->_nrecor) = 0, nil, nabvysit ->(dbgoto(nrecor)))

      if   nabvysitw ->_delrec = '9'
        if nrecor <> 0
          nabvysit ->(dbdelete())
        endif
      else
        nabvysitw ->ndoklad := nabvyshd->ndoklad

        mh_copyfld('nabvysitw','nabvysit',(nrecor=0), .f.)
*        VyrPol_wrt( nrecor=0)
      endif

      nabvysitw ->(dbskip())
    enddo

    if(nabvyshdw ->_delrec = '9', nabvyshd->(dbdelete()), nil )

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat NABÍDKU ODESLANOU, blokováno uživatelem ...'))
  endif

  nabvyshd ->(dbunlock(),dbcommit())
   nabvysit ->(dbunlock(),dbcommit())
return mainOk


*
** zrušení objednávky pøijaté **
function pro_nabvyshd_del(odialog)
  local  mainOk := .t.

  nabvyshdw->_delrec := '9'
  nabvysitw->(nabvysitw->(AdsSetOrder(0),dbgotop()), dbeval({|| nabvysitw->_delrec := '9'}))

  nabvyshdw->(dbcommit())
  nabvysitw->(dbcommit())

  mainOk := pro_nabvyshd_wrt_inTrans(odialog)
return mainOk


function pro_nabvyshd_cmp()

  nabvyshdw ->ncenZakCel := ;
   nabvyshdw ->ncenDanCel := ;
    nabvyshdw ->nhodnSlev  := ;
     nabvyshdw ->nhmotnost  := ;
      nabvyshdw ->nobjem     := 0


  nabit_iw ->( dbgotop())

  do while .not. nabit_iw ->(eof())
    if nabit_iw -> _delrec <> '9'

      nabvyshdw ->ncenZakCel += nabit_iw ->ncenZakCel
      nabvyshdw ->ncenDanCel += nabit_iw ->ncenZakCeD
      nabvyshdw ->nhodnslev  += nabit_iw ->ncelkSlev
      nabvyshdw ->nhmotnost  += nabit_iw->nhmotnost
      nabvyshdw ->nobjem     += nabit_iw->nobjem
    endif

    nabit_iw ->( dbskip())
  enddo
return nil


function VyrPOL_cpy()
  LOCAL cKey

  IF LEFT(nabvysitw->cCisZakaz,3) = 'NAV'
    drgDBMS:open('VyrPOL' )
    cKey := STRZERO( NabVysITw->nDoklad,10) + STRZERO( NabVysITw->nIntCount,5)
    IF VyrPOL->( dbSEEK( cKey,,'VYRPOL10'))
*      mh_CopyFld( 'VYRPOL', 'VYRPOLw', .t.)
      NabVysITw->nRec_VPol := VyrPOL->( RecNO())
    ENDIF
  ENDIF
return nil