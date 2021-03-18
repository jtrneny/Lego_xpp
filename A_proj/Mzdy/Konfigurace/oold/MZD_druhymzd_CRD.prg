#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"


* MZDYIT ... první rozmìr nMzda, mDnyDoklad, nHodDoklad
* MZDYHD ... prvky
# define   pa_allItems       ;
           { { 'nMzda'     , ;
               { 'nMzdZaklad', 'nMzdPripl' , 'nMzdOdmeny', 'nMzdNahrad', 'nMzdOstatn', ;
                 'nHrubaMzda', 'nNapMinMzd', 'nZaklSocPo', 'nZakSocStO', 'nOdvoSocPC', ;
                 'nOdvoSocPO', 'nOdvSocStZ', 'nOdvSocStO', 'nOdvoSocPZ', 'nSlevSocPO', ;
                 'nPocZamSlO', 'nZaklZdrPo', 'nOdvoZdrPC', 'nOdvoZdrPO', 'nOdvoZdrPZ', ;
                 'nDanZaklMz', 'nDanZaklSP', 'nDanCelVyp', 'nNezdCasZD', 'nSlevaDanC', ;
                 'nSlevaDanU', 'nDanUlevaC', 'nDanBonusC', 'nZdanMzdaP', 'nSupHmMz'  , ;
                 'nSupHmMzZa', 'nSrazkoDan', 'nZalohoDan', 'nDanCelkem', 'nCistPrije', ;
                 'nNemocCelk', 'nNahradyPN', 'nNahr1_2PN', 'nZakOdCelk', 'nSrazkCelk', ;
                 'nCastKVypl', 'nzaklSrazk'                                            } }, ;
             { 'nDnyDoklad', ;
               { 'nFondKDDn' , 'nFondPDDn' , 'nFondPDSDn', 'nDnyFondKD', 'nDnyFondPD', ;
                 'nDnyOdprPD', 'nDnyNahrPD', 'nDnySvatPD', 'nDnyNeodPD', 'nDnyVoSoNe', ;
                 'nDnyVNSoNe', 'nDnyNemoKD', 'nDnyVylocD', 'nDnyVylDOD', 'nDnyNahrPN'  } }, ;
             { 'nHodDoklad', ;
               { 'nHodFondKD', 'nHodFondPD', 'nHodFondUP', 'nHodOdprac', 'nHodNahrad', ;
                 'nHodSvatky', 'nHodNeodpr', 'nHodNeodZa', 'nHodVoSoNe', 'nHodVNSoNe', ;
                 'nHodNemoc' , 'nHodNemZak', 'nHodNahrPN', 'nHodPresc' , 'nHodPrescS', ;
                 'nHodPripl'                                                           } }  }


*
** CLASS MZD_druhyMzd_CRD ******************************************************
CLASS MZD_druhymzd_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, postValidate
  method  Destroy
  METHOD  OnSave

  var     selMzdyit

  inline access assign method c_fields() var c_fields
    return drgParseSecond(s_Fieldsw->cvyraz_1, '>')

  inline access assign method c_Operand() var c_Operand
    local  retVal   := 0
    local  coperand := allTrim(s_Fieldsw->coperand)

    retVal := if( coperand = '+', MIS_PLUS, ;
               if( coperand = '-', MIS_MINUS, ;
                if( coperand = '=', MIS_EQUAL, 0 )))
    return retVal


  inline method comboBoxInit(drgComboBox)
    local  acombo_val := {}

    do case
    case( 'selmzdyit' $ lower(drgComboBox:name) )
      acombo_val := { {'nmzda'     , 'Hrubá mzda'     }, ;
                      {'nDnyDoklad', 'Dny dokladu'    }, ;
                      {'nHodDoklad', 'Hodiny dokladu' } }


      drgComboBox:oXbp:clear()
      drgComboBox:values := acombo_val
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
    endcase
    return self

  inline method comboItemSelected(drgComboBox)
    do case
    case( 'selmzdyit' $ lower(drgComboBox:name) )
      ::setFilter()
    endcase
    return .t.

  inline method addTo_s_Fieldsw()
    s_Fieldsw->(dbappend())

    s_Fieldsw->cvyraz_1  := d_Fieldsw->cvyraz
    s_Fieldsw->ctype_1   := d_Fieldsw->ctype
    s_Fieldsw->nlen_1    := d_Fieldsw->nlen
    s_Fieldsw->ndec_1    := d_Fieldsw->ndec
    s_Fieldsw->cvyraz_1u := d_Fieldsw->cvyraz_u
    s_Fieldsw->cvyraz_2  := d_Fieldsw->cvyraz_m
    s_Fieldsw->coperand  := '+'
    s_Fieldsw->cfield_m  := d_Fieldsw->cfield_m

    if( ::oBro_s_Fieldsw:rowPos = 1, ::oBro_s_Fieldsw:goTop(), nil )
    ::oBro_s_Fieldsw:refreshAll()

    d_Fieldsw->_delRec   := '9'
    ::oBro_d_Fieldsw:panHome():refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::oBro_d_Fieldsw )
    SetAppFocus(::oBro_d_Fieldsw)
  return self

  inline method delFrom_s_Fieldsw()
    local  cvyraz := s_Fieldsw->cvyraz_1

    fordRec( {'d_Fieldsw,0'} )
    if d_Fieldsw->( dblocate( { || allTrim(d_Fieldsw->cvyraz) = allTrim(s_Fieldsw->cvyraz_1) }))
      d_Fieldsw->_delRec   := ''
    endif
    fordRec()

    s_Fieldsw->(dbdelete())

    if( ::oBro_s_Fieldsw:rowPos = 1, ::oBro_s_Fieldsw:goTop(), nil )
    ::oBro_s_Fieldsw:refreshAll()
    ::oBro_d_Fieldsw:panHome():refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::oBro_s_Fieldsw )
    SetAppFocus(::oBro_s_Fieldsw)
  return self


 INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  obj := lastXbp := ::drgDialog:lastXbpInFocus
    local  lok := .t., nEvent_x := mp1_x := mp2_x := oxbp_x := nil

    if( d_Fieldsw->(eof()), ::oBtn_addTo_s_Fieldsw:disable()  , ::oBtn_addTo_s_Fieldsw:enable()   )
    if( s_Fieldsw->(eof()), ::oBtn_delFrom_s_Fieldsw:disable(), ::oBtn_delFrom_s_Fieldsw:enable() )

    do case
    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      ::setOperand()
      return .t.

    case (nEvent = xbeP_Keyboard)
      if mp1 = xbeK_ALT_ENTER
        ::setOperand()
        return .t.
      endif
    endcase


/****
    if isObject( lastXbp )
      if lastXbp:className() = 'xbpBrowse'
        if nEvent = xbeM_LbDown

          nEvent_x := nEvent
          mp1_x    := mp1
          mp2_x    := mp2

          do while lok
            obj:handleEvent( nEvent_x, mp1_x, mp2_x )

            if nEvent_x = xbeM_Motion
              obj:setPointer(,MIS_HAND, XBPWINDOW_POINTERTYPE_POINTER)
              obj:parent:parent:setPointer(,MIS_HAND, XBPWINDOW_POINTERTYPE_POINTER)
            endif

            nEvent_x := AppEvent(@mp1_x, @mp2_x, @oXbp_x)
            if nEvent_x = xbeM_LbUp
               lok := .f.
            endif
          enddo
        endif
      endif
    endif
*/

/*
    if nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT .or.         ;
        nEvent = drgEVENT_DELETE
      if lastXbp:ClassName() = 'XbpBrowse'
         ::cALIASw := Upper(lastXbp:cargo:cfile)
         ::cALIASa := Left( ::cALIASw,Len(::cALIASw)-1) +"A"
      endif
    endif

    do case
     case nEvent = xbeBRW_ItemMarked
*        ::restColor()
        ::state := 0
        ::setFocus_onTab()
        ::relForText()
        ::dm:refresh()
      RETURN .F.

    case (nEvent = drgEVENT_EXIT)
      ::msgSave := .F.
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      RETURN .T.

    case (nEvent = drgEVENT_DELETE)
     if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        cfile := lower( ::df:oLastDrg:cfile )
        if( .not. (cfile) ->(eof()), ::all_broDelete(cfile, ::df:oLastDrg), nil )
        return .t.
      endif

    case (nEvent = xbeP_Keyboard)
      do case
      case mp1 = xbeK_ESC
        ::msgSave := .T.
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      otherwise
        RETURN .F.
      endcase

    case (nevent = drgEVENT_EXIT .or. nevent = drgEVENT_SAVE)
      if ::postSave()
         PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      endif
      return .t.

   case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if( ::tabNum = 6, ::osobySk_set(), nil)
      return .t.

    otherwise
      RETURN .F.
    endcase
*/
  return .f.


HIDDEN:
 VAR   lNEWrec
 VAR   msg, dm, dc, df, ab
 var   oDBD_mzdyit         , oDBD_mzdyhd
 var   oBro_d_Fieldsw      , oBro_s_Fieldsw
 var   oBtn_addTo_s_Fieldsw, oBtn_delFrom_s_Fieldsw


 inline method create_TmpW()
   local file, ofile, tmdesc
   local j,n
   *
   local  pa := pa_allItems
   local  odrgRF, pa_hd
   local  cfile_m, cfield_m

   for i := 1 to len(pa) step 1
     odrgRF    := ::oDBD_mzdyit:getFieldDesc( pa[i,1] )
     cfile_m   := allTrim(pa[i,1])
     cfield_m  := allTrim(odrgRF:name)

     pa_hd  := pa[i,2]
     for j := 1 to len(pa_hd) step 1
       odrgRF := ::oDBD_mzdyhd:getFieldDesc( pa_hd[j] )

       d_Fieldsw->(dbappend())
       d_Fieldsw->cfile    := ''
       d_Fieldsw->cvyraz   := lower('mzdyhd->' +odrgRF:name)
       d_Fieldsw->cvyraz_u := right(odrgRF:desc,32)
       d_Fieldsw->cfield   := lower(odrgRF:name)
       d_Fieldsw->ctype    := odrgRF:type
       d_Fieldsw->nlen     := odrgRF:len
       d_Fieldsw->ndec     := odrgRF:dec
       *
       d_Fieldsw->cfield_m := cfield_m
       d_Fieldsw->cvyraz_m := lower('mzdyit->' +cfield_m)
     next
   next
   return

   inline method create_defNap()
     local  cdefNap := druhyMzdw->mdefNap
     local  pa_def, x, npos, npos_operand
     local  cc, cvyraz_1, cvyraz_2, coperand, cfield_m, cfield

     pa_def := listAsArray( cdefNap, CRLF )

     for x := 1 to len( pa_def) step 1
       citem := strTran( pa_def[x], ' ', '')
       if( npos := at( '=', citem )) <> 0
         cvyraz_1 := left  ( citem, npos -2)

         do case
         case( npos_op := at( '+', citem)) <> 0
           cvyraz_2 := subStr( citem, npos_op +1)
           coperand := '+'

         case( npos_op := at( '-', citem)) <> 0
           cvyraz_2 := subStr( citem, npos_op +1)
           coperand := '-'

         otherWise
           cvyraz_2 := subStr( citem, npos +1)
           coperand := substr( citem, npos -1, 1)
         endCase

         cfield_m := upper ( listAsarray( cvyraz_2, '->')[2])

         s_Fieldsw->(dbAppend())
         s_Fieldsw->cvyraz_1 := cvyraz_1
         s_Fieldsw->cvyraz_2 := cvyraz_2
         s_Fieldsw->coperand := if( coperand = ':', '=', coperand )
         s_Fieldsw->cfield_m := cfield_m

         cfield := allTrim( upper ( listAsarray( cvyraz_1, '->')[2]))
         if d_Fieldsw->(dbseek( cfield,, 'FIELDSW02'))
           s_Fieldsw->ctype_1   := d_Fieldsw->ctype
           s_Fieldsw->nlen_1    := d_Fieldsw->nlen
           s_Fieldsw->ndec_1    := d_Fieldsw->ndec
           s_Fieldsw->cvyraz_1u := d_Fieldsw->cvyraz_u

           d_Fieldsw->_delRec   := '9'
         endif
       endif
     next
     return


   inline method setFilter()
     local  m_filter := "cfield_m = '%%'", filter
     local  selMzdyit := ::dm:get( 'm->selMzdyit' )

     filter := format( m_filter, { upper( selMzdyit) })

     d_Fieldsw->(ads_setAof( filter), dbgoTop())
     s_Fieldsw->(ads_setAof( filter), dbgoTop())

     ::oBro_d_Fieldsw:refreshAll()
     ::oBro_s_Fieldsw:refreshAll()
*     ::dm:refresh()

     PostAppEvent(xbeBRW_ItemMarked,,,::oBro_s_Fieldsw )
     SetAppFocus(::oBro_s_Fieldsw)
     return self

   inline method setOperand()
     local  coperand := allTrim(s_Fieldsw->coperand)

     if( ::dc:oaBrowse:oxbp = ::oBro_s_Fieldsw .and. .not. s_Fieldsw->(eof()))
       s_Fieldsw->coperand := if( coperand = '+', '-' , ;
                               if( coperand = '-', '=' , ;
                                if( coperand = '=', '+', coperand )))

       ::oBro_s_Fieldsw:refreshCurrent()
     endif
     return self

ENDCLASS


METHOD MZD_druhymzd_CRD:init(parent)

  ::drgUsrClass:init(parent)

  ::lNEWrec := (parent:cargo = drgEVENT_APPEND)
  if( druhyMzd->(eof()), ::lNewRec := .t., nil )

  // TMP soubory //
  drgDBMS:open('druhymzdw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('d_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('s_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP

  IF ::lNEWrec
    druhyMzdW->(dbAppend())
  ELSE
    mh_COPYFLD('druhymzd', 'druhymzdw', .T.)
  ENDIF

  ::oDBD_mzdyit := drgDBMS:dbd:getByKey('mzdyit')
  ::oDBD_mzdyhd := drgDBMS:dbd:getByKey('mzdyhd')

  ::create_TmpW()
  ::create_defNap()
RETURN self


method MZD_druhyMzd_crd:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers, x
  local  className, groups
  *
  local  acolors := MIS_COLORS, pa_Groups, nIn

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()
    groups    := isNull( members[x]:groups, '' )

    do case
    case className = 'drgDBrowse'
      do case
      case lower(members[x]:cfile) = 'd_fieldsw' ;  ::oBro_d_Fieldsw := members[x]:oxbp
      case lower(members[x]:cfile) = 's_fieldsw' ;  ::oBro_s_Fieldsw := members[x]:oxbp
      endcase

    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'addto_s_fieldsw'   ;  ::oBtn_addTo_s_Fieldsw   := members[x]
        case lower(members[x]:event) = 'delfrom_s_fieldsw' ;  ::oBtn_delFrom_s_Fieldsw := members[x]
        endcase
      endif

    case className = 'drgText'
      if 'SETFONT' $ groups
        pa_Groups := ListAsArray(groups)
        nIn       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_Groups[nIn+1])

        if 'GRA_CLR' $ atail(pa_Groups)
          if (nIn := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endCase
  next

  ::setFilter()
return self


method MZD_druhyMzd_crd:postValidate(drgVar)
  local  value    := drgVar:get()
  local  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.


  if(lOk, eval(drgVar:block,drgVar:value), nil)

  do case
  case( name = 'druhymzdw->nprnapnaho' )
    if lOk .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
      ::onSave()
    endif
  endcase
return lOk


METHOD MZD_druhymzd_CRD:onSave(lIsCheck,lIsAppend)
  local  cdefNap := '', coperand, cmpOper

  s_Fieldsw->(ads_clearAof(), dbgoTop())

  do while .not. s_Fieldsw->(eof())
    coperand  := left(s_Fieldsw->coperand,1)
    cmpOper   := if( coperand = '+', '+= ' , ;
                  if( coperand = '-', '-= ' , ':= ' ))

    cdefNap += left(s_Fieldsw->cvyraz_1,30)

    if cmpOper = ':='
      cdefNap += cmpOper +left(s_Fieldsw->cvyraz_2,30) +CRLF
    else
      cdefNap += ' := ' +left(s_Fieldsw->cvyraz_1,30) +coperand +left(s_Fieldsw->cvyraz_2,30) +CRLF
    endif

*    cdefNap += left(s_Fieldsw->cvyraz_1,30) +cmpOper +left(s_Fieldsw->cvyraz_2,30) +CRLF
    s_Fieldsw->(dbskip())
  enddo

  druhyMzdw->mdefNap := cdefNap

  if ::lNEWrec
    mh_copyFld( 'druhyMzdW', 'druhyMzd', .t.)

  else
    if druhyMzd->( sx_Rlock())
      mh_copyFld( 'druhyMzdW', 'druhyMzd')

      druhyMzd->(dbUnlock())
    endif
  endif


  druhyMzd->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .t.


METHOD MZD_druhymzd_CRD:destroy()
  ::drgUsrClass:destroy()

  druhymzdw->(DbCloseArea())
   d_Fieldsw->( dbcloseArea())
    s_Fieldsw->( dbcloseArea())
RETURN SELF