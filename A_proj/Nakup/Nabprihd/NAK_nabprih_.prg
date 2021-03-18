#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"
//
#include "..\FINANCE\FIN_finance.ch"


function NAK_nabprihd_cpy(oDialog)
  local  file_name, ky
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  * nabídky vystavené
  drgDBMS:open('NABPRIHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('NABPRIITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  file_name := nabpriitw ->( DBInfo(DBO_FILENAME))
               nabpriitw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'nabpriitw', .t., .f.) ; nabpriitw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'nabit_iw' , .t., .t.) ; nabit_iw ->(AdsSetOrder(1))
  *
  if .not. lNEWrec
    mh_COPYFLD('NABPRIHD','NABPRIHDw', .t., .t.)

    NABPRIIT ->(DbGoTop())
    do while .not. NABPRIIT ->(Eof())
      ky := upper(nabpriit->ccissklad) +upper(nabpriit->csklpol)
      cenzboz->(dbseek(ky,,'CENIK03'))

      mh_COPYFLD('NABPRIIT','NABPRIITw',.t., .t.)

      * originál
      nabpriitw->cfile_iv   := 'cenzboz'
      nabpriitw->nrecs_iv   := cenzboz->(recNo())

      nabpriit ->(DbSkip())
    enddo

    nabpriit->(dbgotop())
  else
    nabprihdw ->(dbappend())

    doklad := fin_range_key('NABPRIHD')[2]

    ( nabprihdw->ndoklad    := doklad                        , ;
      nabprihdw->ddatprij   := date()                        , ;
      nabprihdw->ddatdoDod  := date()                        , ;
      nabprihdw->czkratmeny := sysconfig('finance:czaklmena'), ;
      nabprihdw->czkratmenz := sysconfig('finance:czaklmena'), ;
      nabprihdw->nkurZahMen := 1                             , ;
      nabprihdw->nmnozPrep  := 1                             , ;
      nabprihdw->cintpracov := logOsoba                        )
  endif

  c_staty->(dbseek(upper(nabprihdw->czkratStat),,'C_STATY1'))
return nil


*
** uložení nabídky pøijaté **************************************************
function nak_nabprihd_wrt(odialog)
  local  mainOk   := .t., nrecor, ky
  local  anNabi   := {}

  nabpriitw ->(AdsSetOrder(0),dbgotop())

  do while .not. nabpriitw->(eof())
    aadd(anNabi, nabpriitw->_nrecor )

    nabpriitw->(dbskip())
  enddo

  if .not. odialog:lnewRec
    nabprihd ->(dbgoto(nabprihdw->_nrecor))

    mainOk := nabprihd ->(sx_rlock()) .and. ;
              nabpriit ->(sx_rlock(anNabi))
  else
*    odialog:int_cislObint(.t.)
*    objitemw->(dbgotop(), dbeval( { || objitemw->ccislObint := objheadw->ccislObint } ))
  endif


  if mainOk
    if(nabprihdw->_delrec <> '9', mh_copyfld('nabprihdw','nabprihd', odialog:lnewRec, .f.), nil)
    nabpriitw ->(dbgotop())

    do while .not. nabpriitw ->(eof())

      if((nrecor := nabpriitw ->_nrecor) = 0, nil, nabpriit ->(dbgoto(nrecor)))

      if   nabpriitw ->_delrec = '9'
        if nrecor <> 0
          nabpriit ->(dbdelete())
        endif
      else
        nabpriitw ->ndoklad := nabprihd->ndoklad

        mh_copyfld('nabpriitw','nabpriit',(nrecor=0), .f.)
*        VyrPol_wrt( nrecor=0)
      endif

      nabpriitw ->(dbskip())
    enddo

    if(nabprihdw ->_delrec = '9', nabprihd->(dbdelete()), nil )

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat NABÍDKU PØIJATOU, blokováno uživatelem ...'))
  endif

  nabprihd ->(dbunlock(),dbcommit())
   nabpriit ->(dbunlock(),dbcommit())
return mainOk


*
** zrušení nabídky pøijaté **
function nak_nabprihd_del(odialog)
  local  mainOk := .t.

  nabprihdw->_delrec := '9'
  nabpriitw->( nabpriitw->(AdsSetOrder(0),dbgotop()), dbeval({|| nabpriitw->_delrec := '9'}))

  nabprihdw->(dbcommit())
  nabpriitw->(dbcommit())

  mainOk := nak_nabprihd_wrt(odialog)
return mainOk


function nak_nabprihd_cmp()

  nabprihdw ->ncenZakCel := ;
   nabprihdw ->ncenDanCel := ;
    nabprihdw ->nhodnSlev  := ;
     nabprihdw ->nhmotnost  := ;
      nabprihdw ->nobjem     := 0


  nabit_iw ->( dbgotop())

  do while .not. nabit_iw ->(eof())
    if nabit_iw -> _delrec <> '9'

      nabprihdw ->ncenZakCel += nabit_iw ->ncenZakCel
      nabprihdw ->ncenDanCel += nabit_iw ->ncenZakCeD
      nabprihdw ->nhodnslev  += nabit_iw ->ncelkSlev
      nabprihdw ->nhmotnost  += nabit_iw->nhmotnost
      nabprihdw ->nobjem     += nabit_iw->nobjem
    endif

    nabit_iw ->( dbskip())
  enddo
return nil
