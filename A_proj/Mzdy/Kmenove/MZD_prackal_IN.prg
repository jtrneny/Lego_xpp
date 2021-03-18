#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


//-----+ MZD_kemnove_IN +-------------------------------------------------------
CLASS MZD_prackal_IN FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  method  Init
//  method  ItemMarked
//  METHOD  ItemSelected
  method  InFocus
  method  drgDialogStart, drgDialogEnd
  method  itemSelected
  method  stableBlock

  method  generujNew

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .t.
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase

  return .f.

hidden:
  var  brow, table

endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_prackal_IN:Init(parent)
  LOCAL nROKOBDt, nOsPrac, nPorVzt
  LOCAL cFiltr
  LOCAL cX
  local table

  ::drgUsrClass:init(parent)

  ::table := parent:parent:formheader:file

  drgDBMS:open('MzPrKaHd')
  drgDBMS:open('MzPrKaIt')
  drgDBMS:open('MSPRC_MO',,,,,'MsPrc_MOa')

  ::generujNew()

  cfiltr := Format("nROKOBD = %% .and. nOsCisPrac = %% .and. nPorPraVzt = %%",     ;
                   {(::table)->nrokobd, (::table)->noscisprac, (::table)->nporpravzt})

*  mzdprkal->( ads_setaof(cfiltr), dbGoTop())
  ::drgDialog:set_prg_filter(cfiltr, 'MzPrKaHd')


return self


method MZD_prackal_IN:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
return .T.

**
method MZD_prackal_IN:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse

return self


method MZD_prackal_IN:drgDialogEnd(drgDialog)
//  ::msg   := ;
//  ::dm    := ;
//  ::dc    := ;
//  ::df    := ;
  ::table := ;
  ::brow  := NIL

  mzprkahd->(ads_clearaof())
return self


/*
method MZD_prackal_IN:ItemMarked()
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
return self
*/

method MZD_prackal_IN:stableBlock(oxbp)
  local m_file, cfiltr

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzprkahd' )
       cfiltr := Format("nROKOBD = %% .and. nOsCisPrac = %% .and. nPorPraVzt = %% .and. Dtos(ddatum)='%%'", {mzprkahd->nrokobd, mzprkahd->noscisprac, mzprkahd->nporpravzt,DTos(mzprkahd->ddatum)})
       mzprkait ->(ads_setaof(cfiltr), dbGoTop())

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) }, 2 )
     endcase
  endif
return self


method MZD_prackal_IN:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

return self


method MZD_prackal_IN:generujNew()
  local  ky
  local  datum
  local  n
  local  atribut

  ky := StrZero((::table)->nrokobd,6)+ StrZero((::table)->noscisprac,5)  ;
         +StrZero((::table)->nporpravzt,3)

    if .not. MzPrKaHd->( dbSeek(ky,,'MzPrKaHd04'))
      if MsPrc_MOa->( dbSeek(ky,,'MSPRMO01'))
        drgDBMS:open('kalendar')
        drgDBMS:open('c_pracka')
        drgDBMS:open('c_pracsm')

        c_pracka->( dbSeek( Upper(MsPrc_MOa->cTypPraKal),, 'C_PRACKA01'))

        datum  := RozDATvOB(msprc_moa->dDatNast,msprc_moa->dDatVyst,msprc_moa->nrok,msprc_moa->nobdobi)
        cfiltr := Format( "Dtos(ddatum)>='%%' .and. DTos(dDatum)<='%%'",{DTos(datum[1]),Dtos(datum[2])})
        kalendar->( ads_setaof(cfiltr), dbGoTop())
        do while .not. kalendar->( Eof())
          mh_copyfld( 'kalendar', 'MzPrKaHd',.t.,,,.t.)
          MzPrKaHd->culoha     := 'M'
          MzPrKaHd->ctask      := 'MZD'
          MzPrKaHd->noscisprac := MsPrc_MOa->noscisprac
          MzPrKaHd->nporpravzt := MsPrc_MOa->nporpravzt
          MzPrKaHd->nobdobi    := MsPrc_MOa->nobdobi
          MzPrKaHd->nrokobd    := MsPrc_MOa->nrokobd
          MzPrKaHd->ctypprakal := MsPrc_MOa->ctypprakal
          MzPrKaHd->nmsprc_mo  := isNull( MsPrc_MOa->sid, 0)

            MzPrKaHd->nFondPDHo  := fPracDOBA( MSPRC_MOa->cDelkPrDob)[3]

            MzPrKaHd->nFondKDDn  := 1
            MzPrKaHd->nFondPDDn  := if( MzPrKaHd->nDenSvatek=1,0,MzPrKaHd->nDenPracov)
            MzPrKaHd->nFondPDSDn := MzPrKaHd->nDenPracov

//           nDnyFondKD
//           nDnyFondPD
//           nDnyOdprPD

            MzPrKaHd->nFondKDHo  := MzPrKaHd->nFondKDDn  * MzPrKaHd->nFondPDHo
            MzPrKaHd->nFondPDHo  := MzPrKaHd->nFondPDDn  * MzPrKaHd->nFondPDHo
            MzPrKaHd->nFondPDSHo := MzPrKaHd->nFondPDSDn * MzPrKaHd->nFondPDHo

            for n := 1 to 6
              atribut := 'cTypSmeny' + Str( n,1)
              if .not. Empty(c_pracka->&atribut)
                if c_pracsm->( dbSeek( Upper(c_pracka->&atribut),, 'C_PRACSM01'))
                  if .not. Empty(c_pracsm->cRanSmeZac)
                    mh_copyfld( 'MzPrKaHd', 'MzPrKaIt',.t.,,,.t.)
                    MzPrKaIt->ctypsmeny := c_pracsm->cTypSmeny
                    MzPrKaIt->czacatek  := c_pracsm->cRanSmeZac
                    MzPrKaIt->ckonec    := c_pracsm->cRanSmeKon
                    MzPrKaIt->cdelka    := c_pracsm->cRanSmeDel
                    MzPrKaIt->nFondPDHo := TimeToSec(MzPrKaIt->cdelka)/3600
                  endif
                  if .not. Empty(c_pracsm->cOdpSmeZac)
                    mh_copyfld( 'MzPrKaHd', 'MzPrKaIt',.t.,,,.t.)
                    MzPrKaIt->czacatek := c_pracsm->cOdpSmeZac
                    MzPrKaIt->ckonec   := c_pracsm->cOdpSmeKon
                    MzPrKaIt->cdelka   := c_pracsm->cOdpSmeDel
                    MzPrKaIt->nFondPDHo := TimeToSec(MzPrKaIt->cdelka)/3600
                  endif
                  if .not. Empty(c_pracsm->cNocSmeZac)
                    mh_copyfld( 'MzPrKaHd', 'MzPrKaIt',.t.,,,.t.)
                    MzPrKaIt->czacatek := c_pracsm->cNocSmeZac
                    MzPrKaIt->ckonec   := c_pracsm->cNocSmeKon
                    MzPrKaIt->cdelka   := c_pracsm->cNocSmeDel
                    MzPrKaIt->nFondPDHo := TimeToSec(MzPrKaIt->cdelka)/3600
                  endif
                endif
              endif
            next

          kalendar->( dbSkip())
        enddo

        kalendar->( ads_clearaof())
      endif
    endif

    MzPrKaHd->( dbCommit())
return self