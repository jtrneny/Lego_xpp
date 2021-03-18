#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004' , ;
                   'uctdokhd','uctdokit','ucetkum'                           }


*
** CLASS for UCT_uctdokhd_SCR **************************************************
CLASS UCT_rozphnojhd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec, oinf
  method  init, drgDialogStart, tabSelect, itemMarked, drgDialogEnd, postDelete
  method  rozphnoj

  *
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow, dm
ENDCLASS

method UCT_rozphnojhd_SCR:init(parent)
*-  LOCAL filter := FORMAT("upper(cdenik) = '%%'", {SYSCONFIG('FINANCE:cDENIKFIDO')})

  ::drgUsrClass:init(parent)
  ::lnewRec  := .f.
  ::tabnum   := 1

  * z�kladn� soubory
  ::openfiles(m_files)

  ** likvidace ��etn� doklad se nelikviduje, typ_lik je pou�it pro RV_dph **
  ::FIN_finance_in:typ_lik := 'ucd'
  ::oinf  := fin_datainfo():new('UCTDOKHD')

*-  uctdokhd->(ads_setAof(filter))
return self


method UCT_rozphnojhd_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  ::dm   := drgDialog:dataManager
return


method UCT_rozphnojhd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method UCT_rozphnojhd_SCR:itemMarked()
  local  cky := Upper(UCTDOKHD ->cDENIK) +StrZero(UCTDOKHD ->nDOKLAD,10)

  do case
  case ::tabnum = 1
    UCTDOKIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
    ::brow[2]:refresh(.T.)
    ::dm:refresh()
  case ::tabnum = 2
    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  endcase
return self


method UCT_rozphnojhd_SCR:rozphnoj()
  local nrozp_VYK, arozpus
  local nzaklCel, nzbyvaROZ
  local filtr
  local aparam
  local ntm

  aparam    := mh_Token(SysConfig( "Ucto:cparRozHno"))
  nzaklCel  := 0
  nrozp_VYK := 0
  arozpus   := {}

//   objhead->( dbseek( strZero(MyFIRMA,5) +upper(vyrZak->ccisZakaz),, 'OBJHEAD1') )
//  Filter := FORMAT("(ObjITEM->cCisZakaz = '%%')",{ VyrZAK->cCisZakaz } )
//  ObjITEM->( mh_SetFilter( Filter))

  if drgIsYESNO(drgNLS:msg('Spustit rozpu�t�n� hnojen� na plodiny ?'))
    Filter := FORMAT("(nrok = %% and cnazpol2 = '%%' )",{uctOBDOBI:UCT:NROK,aparam[1]} )
    ucetpol->( ads_setaof(Filter), dbGoTop())
    ucetpol->( dbeval( { ||(nzaklCel += ucetpol->nkcmd) } ))
    ucetpol->( ads_clearaof())

    if drgIsYESNO(drgNLS:msg('Rozpustit n�klady na hnojen� ve vy�i ' + Str(nzaklCel,13,2)+ ' na zadan� plodiny ?'))
      Filter := FORMAT("(nrok = %% and cucetmd = '%%' )",{uctOBDOBI:UCT:NROK,aparam[3]} )
      ucetpol->( ads_setaof(Filter), dbGoTop())
//      ucetpol->( dbeval( { ||(nzaklCel += (ucetpol->nkcmd*ucetpol->nmnoznat))}))
      do while .not. ucetpol->(Eof())
        ntm      := (ucetpol->nkcmd*ucetpol->nmnoznat)
        nzaklCel += ntm
        if .not. Empty( arozpus)
          if Ascan( arozpus,{|X| X[1]=ucetpol->cnazpol1 .and. X[2]=ucetpol->cnazpol2} ) = 0
            AAdd( arozpus, {ucetpol->cnazpol1,ucetpol->cnazpol2,ucetpol->nkcmd,ucetpol->nmnoznat, ntm})
          else
            arozpus[n,4] += ntm
          endif
        else
          AAdd( arozpus, {ucetpol->cnazpol1,ucetpol->cnazpol2,ucetpol->nkcmd,ucetpol->nmnoznat, ntm})
        endif
        ucetpol->(dbSkip())
      enddo


// generov�n� dokldu
   
      for n := 1 to len( arozpus)


      next


    endif
  endif


return



method UCT_rozphnojhd_SCR:drgDialogEnd()
return


method UCT_rozphnojhd_SCR:postDelete()
  local  oinf := fin_datainfo():new('UCTDOKHD'), nsel, nodel := .f.

  if oinf:ucuzav() = 0
    nsel := ConfirmBox( ,'Po�adujete zru�it ��etn� doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_', ;
                         'Zru�en� ��etn�ho dokladu ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      uct_uctdokhd_cpy(self)
      nodel := .not. uct_uctdokhd_del()
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'��etn� doklad _' +alltrim(str(uctdokhd->ndoklad)) +'_' +' nelze zru�it ...', ;
                 'Zru�en� ��etn�ho dokladu ...' , ;
                 XBPMB_CANCEL                  , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel