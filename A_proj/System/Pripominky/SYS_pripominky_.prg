#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"



function sys_pripominky_cpy(oDialog, value)
  local  nKy := asysprhd->cIDpripom
  *
  local  lNEWrec := If( IsNull(oDialog), .F., oDialog:lNEWrec)

  ** tmp **
  drgDBMS:open('asysprhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('asyspritw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('dokumentw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if .not. lNEWrec
    mh_copyfld('asysprhd', 'asysprhdw', .t., .t.)

    asysprit->(dbgotop(), dbeval({|| mh_copyfld('asysprit','asyspritw', .t., .t.)}))
  else
    asysprhdw->(dbappend())

   ( asysprhdw ->nIDpripom  := newIDpripom()                                          , ;
     asysprhdw ->cIDpripom  := StrZero(usrIdDB,6 )+StrZero(asysprhdw ->nIDpripom,10)  , ;
     asysprhdw ->dVznikZazn := Date()                                                 , ;
     asysprhdw ->dZacPripom := Date()                                                 , ;
     asysprhdw ->cuser      := usrName                                                , ;
     asysprhdw ->cosoba     := logOsoba                                               , ;
     asysprhdw ->cverze     := verzeAsys[3,2]                                         , ;
     asysprhdw ->cverzedb   := SpecialBuild                                         , ;
     asysprhdw ->niduzivsw  := Val( Left(Str(usrIdDB,6),4)+'00')                      , ;
     asysprhdw ->nusriddb   := usrIdDB                                                , ;
     asysprhdw ->cnazfirmy  := myCompanyName                                          , ;
     asysprhdw ->nRecFiltrs := 2                                                      , ;
     asysprhdw ->nStapripom := 0                                          )

    if .not. IsNil( value)
      asysprhdw ->ctyppripom := 'PRIPOM_PRG'
      asysprhdw ->ctask      := value[1]
      asysprhdw ->cpripomink := value[2]

    endif
  endif
return nil


function sys_pripominky_wrt(odialog)
  local  mainOk := .t., nrecor, ky
  local  anExi := {}, anCen := {}, anDoi := {}, anObi := {}, anVyi := {}

  asyspritw->(AdsSetOrder(0),dbgotop())

  do while .not. asyspritw->(eof())
    sys_pripominky_rlo(anExi,anVyi)
    asyspritw->(dbskip())
  enddo

  if .not. odialog:lnewRec
    asysprhd->(dbgoto(asysprhdw->_nrecor))
    mainOk := mainOk                      .and. ;
              asysprhd->(sx_rlock())      .and. ;
              asysprit->(sx_rlock(anExi))
  endif

  if mainOk
    if(asysprhdw->_delrec <> '9', mh_copyfld('asysprhdw','asysprhd',odialog:lnewRec, .f.,,.t.), nil)

    do case
    case asysprhd->nStaKomuni = 1 .or. asysprhd->nStaKomuni = 2
      asysprhd->nStaKomuni := 3
    endcase

    asyspritw->(dbgotop())

    do while .not. asyspritw->(eof())

      if((nrecor := asyspritw->_nrecor) = 0, nil, asysprit->(dbgoto(nrecor)))
      if   asyspritw->_delrec = '9'  ;  asysprit->(dbdelete())
      else                           ;  mh_copyfld('asyspritw','asysprit',(nrecor=0),.f.,,.t.)
      endif

*      sys_pripominky_mod(asyspritw->_delrec = '9')
      asyspritw->(dbskip())
    enddo

    if(asysprhdw->_delrec = '9')   ;  asysprhd->(dbdelete())
    else
    endif
  else
    drgMsg(drgNLS:msg('Nelze modifikovat PØIPOMÍNKU, blokováno uživatelem ...'),,odialog:drgDialog)
  endif

  asysprhd->(dbunlock(),dbcommit())
   asysprit->(dbunlock(),dbcommit())
return mainOk


*
** zrušení expedièního listu **
function sys_pripominky_del(odialog)
  local  mainOk

  asysprhdw->_delrec := '9'
  asyspritw->(AdsSetOrder(0),dbgotop(),dbeval({|| asyspritw->_delrec := '9'}))
  mainOk := sys_pripominky_wrt(odialog)
return mainOk


static function sys_pripominky_rlo(anExi,anVyi)

  aadd(anExi,asyspritw->_nrecor)

return nil

function newIDpripom(typ)
  local newID
  local filtr

  drgDBMS:open('ASYSPRHD',,,,,'ASYSPRHDa')
  ASYSPRHDa->(ads_setaof( format("nusriddb = %%",{usrIdDB})))
  ASYSPRHDa->( AdsSetOrder(1), DBGoBotTom())
  newID := ASYSPRHDa->nIDpripom +1
  ASYSPRHDa->(ads_clearaof(),dbgotop())

RETURN(newID)


/*
static function sys_pripominky_mod(isDel)
  local  ciszakazI  := explstitw->cciszakazI

  if .not. empty(ciszakazI)
    vyrzakit->(dbgoTo(explstitw->nrecs_iv))
    vyrzakit->ncisloEL := if(isDel, 0, explsthdw->ndoklad)
  endif
return nil
*/