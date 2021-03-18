#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
*
** CLASS DOH_dochazkadny_IN *******************************************************
CLASS DOH_dochhromadne_CRD FROM drgUsrClass
EXPORTED:
  var     obdobi
  var     rok
  var     rokobdobi
  var     stavem
  var     firstatrr

  method   Init, drgDialogStart
  *
  method   postValidate
  method   generuj_doklady
//  method   c_prerus


  inline access assign method infoZpr() var infoZpr
    local  cc := '', ncount

    if isObject(::oDBro_main)
      do case
      case ::oDBro_main:is_selAllRec
        ncount := (::cfile_main)->(Ads_GetRecordCount())
        cc     := '... všechny vybrané pracovníky ... [ ' +str(ncount, 10) +' ]'

      case len( ::oDBro_main:arSelect) > 1
        cc := '... vybrané pracovníky ... [ ' +str( len( ::oDBro_main:arSelect), 10) +' ]'

      otherwise
        // 65 + 6 +5
        cc += left( allTrim( osoby->cjmenorozl), 40) +' ... [ ' +str(osoby->ncisosoby,6) +' / ' +str(osoby->noscisprac,5) +' ]'
        ::lfirst := .t.

      endcase
    endif
  return cc

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
*       ::setSysFilter()
       ::obdobi := uctOBDOBI:DOH:NOBDOBI
       return .t.
    otherwise
      return .f.
    endcase
  return .f.

*    do case
*    case nEvent = drgEVENT_EDIT   ;   ::CardOfKmenMzd()
*    case nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
*        RETURN .F.
*      EndCase
*    OTHERWISE
*      RETURN .F.
*    ENDCASE
*  return .T.

hidden:
  * sys
  var     msg, dm, dc, df
  var     oDBro_main, cfile_main
  var     oBtn_generuj, xbp_therm
  var     lfirst

endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD DOH_dochhromadne_CRD:Init(parent)
  LOCAL  nROK, nOBDOBI
  LOCAL  cFiltr, cTag
  LOCAL  cX
  local  atrr

  ::drgUsrClass:init(parent)

  ::rok       := uctOBDOBI:DOH:NROK
  ::obdobi    := uctOBDOBI:DOH:NOBDOBI
  ::rokobdobi := uctOBDOBI:DOH:NROKOBD
  ::stavem    := '1'
  ::lfirst    := .f.

  drgDBMS:open('CNAZPOL4')
  drgDBMS:open('MSPRC_MO')
  drgDBMS:open('OSOBY')
  drgDBMS:open('C_PRACDO')
  drgDBMS:open('C_PRACSM')
  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('kalendar')
  drgDBMS:open('c_svatky')
  drgDBMS:open('c_prerus',,,,,'c_preruse')
  drgDBMS:open('c_prerva',,,,,'c_prervaa')
  drgDBMS:open('dspohyby',,,,,'dspohybya')

  * TMP soubory *
  drgDBMS:open('mesicw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('tmcelsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('dspohybyw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP


//  kalendarq->(ads_setaof(filtr), OrdSetFocus('KALENDAR01'), dbGoTop())
  filtr := Format("nrok = %% and nobdobi = %% and ndenpracov = 1", { ::rok, ::obdobi })
  kalendar->(ads_setaof(filtr))
  ctag := kalendar->( ADSSetOrder('KALENDAR01'))
  kalendar->( dbGoTop())

  dsPohybyW->( dbappend())
//  dsPohybyW->ddatum_od := Kal_FirstPD(::rok,::obdobi)
  dsPohybyW->ddatum_od := kalendar->ddatum

  kalendar->( DbGoBottom())
  dsPohybyW->ddatum_do := kalendar->ddatum

  kalendar->( ADS_ClearAof())
  kalendar->( ADSSetOrder( cTag))

  cfiltr := Format("nRokObd= %%", {::rokobdobi})
  kalendar->(ads_setaof(cfiltr), dbGoTop())
  kalendar->( dbGoTop())

RETURN self


method DOH_dochhromadne_CRD:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, prevForm, asize, asize_G

  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMananager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form

  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {128, 255, 128 } ) )
      asize_G      := odrg:oxbp:currentSize()
    endif

    if odrg:className() = 'drgPushButton'
      if( odrg:event = 'generuj_doklady', ::obtn_generuj := odrg, nil )
    endif
  next

  *
  prevForm := drgDialog:parent
  members  := prevForm:oForm:aMembers

  BEGIN SEQUENCE
    for x := 1 TO len(members)
      if 'browse' $ lower(members[x]:className())
        ::oDBro_main := members[x]
        ::cfile_main := ::oDBro_main:cFile
  BREAK
      endif
    next
  END SEQUENCE

  * modifikace tlaèítka generuj_doklady
  asize := ::obtn_generuj:oxbp:currentSize()
  ::obtn_generuj:oxbp:setSize({asize_G[1], asize[2]})
  ::xbp_therm  := drgDialog:oMessageBar:msgStatus

  ::dm:refresh()
RETURN self


METHOD DOH_dochhromadne_CRD:postValidate(drgVar)
  local  name := Lower(drgVar:name)
  local  file := drgParse(name,'-')
  local  item := drgParseSecond( name, '>' )
  local  value := drgVar:get(), changed := drgVAR:changed()
  *
  local  lok := .t., pa, xval, dTm, nval
  local  cky, cinfo
  ** new


  do case
  case( name = 'dspohybyw->ckodprer')
    if changed
      c_prerus->( dbSeek( 'DOH'+Upper( value),,'C_PRERUS05'))
      cky := 'DOH' + value + '1'
      if c_prervaa->( dbSeek( cky,,'C_PRERVA10'))
        ::dm:set( 'dspohybyw->ckodprere', c_prervaa->ckodprere)
        dspohybyw->ckodprere := c_prervaa->ckodprere

        c_preruse->( dbSeek( 'DOH'+Upper( c_prervaa->ckodprere),,'C_PRERUS05'))
      endif

      if ::lfirst    //.and. c_prerus->
        if c_pracsm->( dbSeek( osoby->ctypsmeny,,'C_PRACSM01'))
          ::dm:set( 'dspohybyw->ccasbeg', c_pracsm->cransmezac)
          ::dm:set( 'dspohybyw->ccasend', c_pracsm->cransmekon)
          dspohybyw->ccasbeg := c_pracsm->cransmezac
          dspohybyw->ccasend := c_pracsm->cransmekon
        endif
      endif
    endif

  case( name = 'dspohybyw->ckodprere')
    if changed
      c_preruse->( dbSeek( 'DOH'+Upper( value),,'C_PRERUS05'))
    endif

  endcase

  if(lok,eval(drgVar:block,value),nil)
RETURN lok



method DOH_dochhromadne_CRD:generuj_doklady()
  local lnem, lNOgen, lGENsv
  local n, m, nI
  local m_File
  local cKEYnem, xKEY
  local dFS_DATE, cFS_day
  local aCasCel

  ::drgDialog:pushArea()                  // Save work area

  m_File   := lower(::oDBro_main:cFile)
  arSelect := aclone(::oDBro_main:arSelect)
  nI       := 0

  do case
  case ::oDBro_main:is_selAllRec
    (m_File)->( dbGoTop())
    do while .not.(m_File)->(Eof())
      AAdd( arSelect, (m_File)->( recNo()))
      (m_File)->( dbSkip())
    enddo
  case len( arSelect ) <> 0
  otherwise
    AAdd( arSelect, (m_File)->( recNo()))
  endcase

  if drgIsYESNO(drgNLS:msg('Spustit hromadné generování docházky' + ' ?'))

    drgDBMS:open('osoby',.f.,,,,'osobyr')
    drgDBMS:open('dspohyby',.f.,,,,'dspohybyr')
    drgDBMS:open('c_svatky',.f.,,,,'c_svatkys')
    drgDBMS:open('c_prerus',.f.,,,,'c_preruss')

    for m := 1 to len( arSelect )
      osobyr ->( dbGoto(arSelect[m]))
      for n := Day( dsPohybyW->ddatum_od) TO Day( dsPohybyW->ddatum_do)
        lNOgen := .f.
        lNEM   := .f.
        lGENsv := .f.

        if n = Day( dsPohybyW->ddatum_od)
          cKEYnem := osobyr ->cIdOsKarty +DtoS( dsPohybyW->ddatum_od -1)
          if .not. (lNEM := dspohybyr ->( dbSeek( cKEYnem +Upper("NEM"),,'DSPOHY22')))
            lNEM := dspohybyr->( dbSeek( cKEYnem +Upper( "OSE"),,'DSPOHY22'))
          endif
        endif
        dFS_DATE := mh_DyaODate( Year( dsPohybyW->ddatum_od), Month( dsPohybyW->ddatum_od), n)
        cFS_day  := Left( CdoW( dFS_DATE), 2)

        xKEY   := osobyr ->cIdOsKarty +DtoS( dsPohybyW->ddatum_od +nI)
        if dsPohybyW->ckodprer = "SVA"
          lNOgen := cFS_day = 'So' .or. cFS_day = 'Ne' .or. lNEM
          lNOgen := lNOgen .or. dspohybyr->( dbSeek( xKEY +"1",,'DSPOHY23'))
          lNOgen := lNOgen .or. (.not. c_svatkys->( dbSeek(DtoS(dFS_DATE),,'C_SVATKY01')))
          lGENsv := ( c_svatkys->( dbSeek( DtoS(dFS_DATE),,'C_SVATKY01')))
        else
//          lNOgen := cFS_day = 'So' .or. cFS_day = 'Ne' .or. lNEM
          lNOgen := cFS_day = 'So' .or. cFS_day = 'Ne'

          if c_svatkys->( dbSeek( DtoS(dFS_DATE),,'C_SVATKY01'))
            lGENsv := .not.(dsPohybyW->ckodprer = "NEM")
          endif

//          lGENsv := ( c_svatkys->( dbSeek( DtoS(dFS_DATE),,'C_SVATKY01'))) .and. !lNOgen
        endif

        lNOgen := lNOgen .or. dspohybyr->( dbSeek( xKEY +Upper(dsPohybyW->ckodprer),,'DSPOHY22'))

         if .not.lNOgen .or. lGENsv
           if lGENsv
             c_Preruss->( dbSeek( Upper("DOH"+"SVA"),,'C_PRERUS05'))
           endif

           mh_CopyFLD( 'osobyr', 'dspohybyr', .t.)

           dspohybyr->nROK      := uctOBDOBI:DOH:NROK
           dspohybyr->nOBDOBI   := uctOBDOBI:DOH:NOBDOBI
           dspohybyr->nMESIC    := uctOBDOBI:DOH:NOBDOBI
           dspohybyr->nDEN      := n
           dspohybyr->cOBDOBI   := uctOBDOBI:DOH:COBDOBI
           dspohybyr->dDATUM    := dFS_DATE
           dspohybyr->cZKRDNE   := cFS_day
           dspohybyr->nGENREC   := 3
           dspohybyr->lIsManual := .t.

           dspohybyr->cRodCisPra := osobyr->cRodCisOsb

           if dspohybyr->nporpravzt <> 0
             dspohybyr->croobcpppv := StrZero(dspohybyr->nrok,4) +           ;
                                       StrZero(dspohybyr->nobdobi,2) +       ;
                                        StrZero(dspohybyr->noscisprac,5) +   ;
                                         StrZero(dspohybyr->nporpravzt,3)
           endif

           dspohybyr->nNAPpreR   := c_prerus->nNAPpreR
           dspohybyr->nNapPrer   := c_prerus->nNapPrer
           dspohybyr->nSaySCR    := c_prerus->nSaySCR
           dspohybyr->nSayCRD    := c_prerus->nSayCRD
           dspohybyr->nSayPRN    := c_prerus->nSayPRN
           dspohybyr->nPritPrac  := c_prerus->nPritPrac

           c_prerus->( dbSeek( 'DOH'+Upper( dspohybyw->cKodPreR),,'C_PRERUS05'))
           dspohybyr ->cKodPreR  := dspohybyw->cKodPreR
           dspohybyr ->nKodPreR  := c_prerus->nKodPreR

           dspohybyr ->cKodPreRE := dspohybyw->cKodPreRE
           dspohybyr ->nKodPreRE := c_preruse->nKodPreR

           dspohybyr ->cCasBeg   := dspohybyw->cCasBeg
           dspohybyr ->cCasEnd   := dspohybyw->cCasEnd

           dspohybyr ->nCasBeg   := TimeToSec(dspohybyr->cCasBeg)/3600
           dspohybyr ->nCasEnd   := TimeToSec(dspohybyr->cCasEnd)/3600

           if lGENsv
             dspohybyr ->cKodPreR  := c_preruss ->cKodPreR
             dspohybyr ->nKodPreR  := c_preruss ->nKodPreR
             dspohybyr ->cKodPreRE := c_preruss ->cKodPreR
             dspohybyr ->nKodPreRE := c_preruss ->nKodPreR
           endif

           cKEYs := Padr( Upper( dspohybyr->cIdOsKarty), 25) + ;
                     StrZero( dspohybyr->nRok, 4)            + ;
                      StrZero( dspohybyr->nMesic, 2)         + ;
                       StrZero( dspohybyr->nDen, 2 )
           c_pracsm->( dbSeek( Upper( osobyr->cTYPsmeny)))

           dspohybyr->nCasBegPD := mh_RoundNumb( dspohybyr->nCasBeg, c_prerus->nKODzaokr)
           dspohybyr->nCasEndPD := mh_RoundNumb( dspohybyr->nCasEnd, c_preruse->nKODzaokr)

           aCAScel := DOCH_cas( dspohybyr->nCasBeg, dspohybyr->nCasEnd, dspohybyr ->cCasBeg, dspohybyr ->cCasEnd, 'dspohybyr')
           dspohybyr->nCasCel   := aCAScel[2]
           dspohybyr->cCasCel   := aCAScel[1]
           dspohybyr->( dbUnlock())

           MODICasy( cKEYs, 3, 'dspohybyr')                             // IMP_TERM.prg
           mh_WRTzmena( 'dspohybyr', .T., .T.)

         endif
         nI++
       next
     next

    dspohybyr->( dbUnlock())
    dspohybyr->( dbCommit())
    dspohybyr->( dbCloseArea())

    osobyr->( dbCloseArea())

    drgMsgBox(drgNLS:msg('Hromadné generování docházky skonèilo...'), XBPMB_INFORMATION)
  endif


  _clearEventLoop(.t.)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

return .t.