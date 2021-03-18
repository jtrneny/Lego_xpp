#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  AVALHRHD
** CLASS AKC_avalhrhd_IN ******************************************************
CLASS AKC_avalhrhd_IN FROM drgUsrClass
exported:
  var     lnewRec
  method  init, drgDialogStart
  method  postValidate

  method  LeftACTION, RightACTION


  inline method onSave(lOk,isAppend,oDialog)
    local  cStatement, oStatement
    local  stmt    := "delete from AVALHRIT where nporVALhro = %ppp"
    local  isok     := .t.

    if .not. ::lnewRec
      avalhrhd->( dbgoTo( avalhrhdW->_nrecOr))

      if avalhrhd->( sx_rLock())

        cStatement := strTran( stmt, '%ppp', str(avalhrhdW->nporVALhro, 6))
        oStatement := AdsStatement():New(cStatement, oSession_data)

        if oStatement:LastError > 0
          *  return .f.
          isOk := .f.
        else
          oStatement:Execute( 'test', .f. )
          oStatement:Close()
        endif

        mh_copyFld('avalhrhdW', 'avalhrhd' )
      endif
    else
      mh_copyFld('avalhrhdW', 'avalhrhd', .t. )
    endif

    if isOk
      avalhritW->( dbgoTop(), ;
                   dbeval( { || mh_copyFld( 'avalhritW', 'avalhrit', .t. ) } ) )
    endif

    avalhrhd->( dbcommit(), dbunlock() )
    avalhrit->( dbcommit(), dbunlock() )

    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return .t.

hidden:
* sys
  var     msg, dm, dc, df, brow

  var     oBtn_LeftAction, oBtn_RightAction
  var     oDBro_Left     , oDBro_Right
ENDCLASS


METHOD AKC_avalhrhd_IN:init(parent)

  ::drgUsrClass:init(parent)
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)

  drgDBMS:open('c_typAr' )                    // typ akcionáøe
  drgDBMS:open('avalhrhd',,,,,'avalhrhd_p')   // pro poøadí valné hromady
  avalhrhd_p->( ordSetFocus( 'Avakhrhd01'), dbgoBottom() )


  akc_avalhrhd_cpy(self)
RETURN self


method AKC_avalhrhd_IN:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  obro_2, xbp_bro_2

  ::msg           := drgDialog:oMessageBar             // messageBar
  ::dm            := drgDialog:dataManager             // dataManager
  ::dc            := drgDialog:dialogCtrl              // dataCtrl
  ::df            := drgDialog:oForm                   // form

  ::oDBro_Left  := ::dc:obrowse[1]
  ::oDBro_Right := ::dc:obrowse[2]

      obro_2  := ::dc:obrowse[2]
  xbp_obro_2  := ::dc:obrowse[2]:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }


  for x := 1 TO Len(members) step 1
    if members[x]:ClassName() = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case members[x]:event = 'LeftACTION'  ;  ::obtn_leftACTION  := members[x]
        case members[x]:event = 'RightACTION' ;  ::obtn_rightACTION := members[x]
        endcase
      endif
    endif
  next

  if( ::lnewRec, nil, ::df:setNextFocus( ::oDBro_Left ) )
return self


method AKC_avalhrhd_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  * na valhrhdW ukládme vždy
  if('avalhrhdw' $ name .and. ok, drgVAR:save(),nil)
return ok


method AKC_avalhrhd_IN:LeftACTION()
  local  nrun_Sp, arSelect
  local  nrec_count := akcionarSW->( ads_getRecordCount()), nrec_work  := 1
  local  pa_delRecs := {}

  do case
  case ( ::oDBro_Left:is_selAllRec .and. len(::oDBro_Left:arSelect) =  0 )
    nrun_Sp  := 1   // vše co je v seznamu
    arSelect := {}

  case ( ::oDBro_Left:is_selAllRec .and. len(::oDBro_Left:arSelect) <> 0 )
    nrun_Sp  := 1 // vylouèit odznaèené záznamy
    arSelect := ::oDBro_Left:arSelect

  case                                 len(::oDBro_Left:arSelect) <> 0
    nrun_Sp  := 3 // zpracovat je oznaèené záznamy
    arSelect := ::oDBro_Left:arSelect

  otherWise
    nrun_Sp  := 4 // zpracovat jen záznam na kterém stojí
    arSelect := {}
  endcase


  if nrun_Sp = 4
    nrec_count := 1
  else
    akcionarSW->( dbgoTop())
    ::oDBro_Left:oxbp:goTop():refreshAll()
    ::oDBro_Right:oxbp:goTop():refreshAll()

    * refresh items
    ::oDBro_Left:oxbp:lockUpdate(.t.)
  endif


  do while ( nrec_count >= nrec_work )

    nrecNo    := akcionarSW->( recNo())
    lis_recOk := if( nrun_Sp = 1, .t., ;
                   if( nrun_Sp = 2 .and. ascan( arSelect, nrecNo) = 0, .t., ;
                     if( nrun_Sp = 3 .and. ascan( arSelect, nrecNo) <> 0, .t., ;
                       if( nrun_Sp = 4, .t., .f. ) ) ) )

    if lis_recOk
      mh_copyFld( 'akcionarSW', 'avalhritW', .t. )
      avalhritW->nporVALhro := avalhrhdW->nporVALhro

      avalhrhdW->npocetAkci += akcionarSW->npocetAkci // poèet akcií
      avalhrhdW->npocetHlas += akcionarSW->npocetHlas // poèet hlasù

      aadd( pa_delRecs, akcionarSW->( recNo()) )
    endif

    nrec_work++
    ::oDBro_Left:oxbp:down():refreshAll()
  enddo

  ::dm:set('avalhrhdW->npocetAkci', avalhrhdW->npocetAkci )
  ::dm:set('avalhrhdW->npocetHlas', avalhrhdW->npocetHlas )

  aeval( pa_delRecs, { |x| ( akcionarSW->(dbgoTo(x)), akcionarSW->_delRec := '9' ) } )
  ::oDBro_Left:is_selAllRec := .f.
  ::oDBro_Left:arSelect     := {}

  ::oDBro_Left:oxbp:lockUpdate(.f.)
  ::oDBro_Left:oxbp:refreshAll()

  ::oDBro_Right:oxbp:goTop():refreshAll()
return self


method AKC_avalhrhd_IN:RightACTION()
  local  nrun_Sp, arSelect
  local  nrec_count := avalhritW->( ads_getRecordCount()), nrec_work  := 1
  local  pa_delRecs := {}

  do case
  case ( ::oDBro_Right:is_selAllRec .and. len(::oDBro_Right:arSelect) =  0 )
    nrun_Sp  := 1   // vše co je v seznamu
    arSelect := {}

  case ( ::oDBro_Right:is_selAllRec .and. len(::oDBro_Right:arSelect) <> 0 )
    nrun_Sp  := 1 // vylouèit odznaèené záznamy
    arSelect := ::oDBro_Right:arSelect

  case                                 len(::oDBro_Right:arSelect) <> 0
    nrun_Sp  := 3 // zpracovat je oznaèené záznamy
    arSelect := ::oDBro_Right:arSelect

  otherWise
    nrun_Sp  := 4 // zpracovat jen záznam na kterém stojí
    arSelect := {}
  endcase


  if nrun_Sp = 4
    nrec_count := 1
  else
    avalhritW->( dbgoTop())
    ::oDBro_Left:oxbp:goTop():refreshAll()
    ::oDBro_Right:oxbp:goTop():refreshAll()

    * refresh items
    ::oDBro_Right:oxbp:lockUpdate(.t.)
  endif


  do while ( nrec_count >= nrec_work )

    nrecNo    := avalhritW->( recNo())
    lis_recOk := if( nrun_Sp = 1, .t., ;
                   if( nrun_Sp = 2 .and. ascan( arSelect, nrecNo) = 0, .t., ;
                     if( nrun_Sp = 3 .and. ascan( arSelect, nrecNo) <> 0, .t., ;
                       if( nrun_Sp = 4, .t., .f. ) ) ) )

    if lis_recOk
      if akcionarSW->( dbseek( avalhritW->nAKCIONAR,,'AKCIONAR'))
        akcionarSW->_delRec := ''

        avalhrhdW->npocetAkci -= akcionarSW->npocetAkci // poèet akcií
        avalhrhdW->npocetHlas -= akcionarSW->npocetHlas // poèet hlasù
      endif
      avalhritW->( dbdelete())
    endif

    nrec_work++
    ::oDBro_Right:oxbp:down():refreshAll()
  enddo

  ::dm:set('avalhrhdW->npocetAkci', avalhrhdW->npocetAkci )
  ::dm:set('avalhrhdW->npocetHlas', avalhrhdW->npocetHlas )

  ::oDBro_Right:is_selAllRec := .f.
  ::oDBro_Right:arSelect     := {}

  ::oDBro_Right:oxbp:lockUpdate(.f.)
  ::oDBro_Right:oxbp:refreshAll()

  ::oDBro_Left:oxbp:goTop():refreshAll()
return self


*
********************************************************************************
static function akc_avalhrhd_cpy(oDialog)
  local  lnewRec := if( isNull(oDialog), .f., oDialog:lnewRec )

  ** tmp soubory **
  drgDBMS:open('AVALHRHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('AVALHRITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  * pomocný soubor akcionari pro pøebírání do valhrit
  drgDBMS:open('AKCIONARsw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  if lnewRec
    AVALHRHDw->( dbappend())
    avalhrhdW->nporVALhro := avalhrhd_p->nporVALhro +1
  else
    mh_copyFld( 'AVALHRHD', 'AVALHRHDw', .t., .t. )
    avalhrit->( dbeval( { || mh_copyFld( 'AVALHRIT', 'AVALHRITw', .t., .t. ) } ))
  endif

  * pomocný seznam akcionáøù pro výbìr do valné hromady
  akcionar->( dbgoTop())
  do while .not. akcionar->( eof())
    c_typAr->( dbseek( akcionar->cZkrTypAr,,'C_TYPAR01'))
    if c_typAr->lucastNaVH
      mh_copyFld( 'akcionar', 'AKCIONARsw', .t. )
      AKCIONARsw->nAKCIONAR := akcionar->sID

      if avalhritW->( dbseek( akcionar->sID,,'AKCIONAR'))
        AKCIONARsw->_delRec := '9'
      endif
    endif
    akcionar->( dbskip())
  enddo
return nil

