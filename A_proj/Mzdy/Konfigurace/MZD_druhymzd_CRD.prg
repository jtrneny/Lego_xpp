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
                 'nHrubaMzda', 'nNapMinMzd',                                           ;
                 'nZaklSocPo', 'nZakSocZaD', 'nZakSocPrD', 'nZakSocStO',               ;
                 'nOdvoSocPC',                                                         ;
                 'nOdvoSocPO', 'nOdvSocStZ', 'nOdvSocStO', 'nOdvoSocPZ', 'nSlevSocPO', ;
                 'nPocZamSlO',                                                         ;
                 'nZaklZdrPo', 'nZakZdrZaD', 'nZakZdrPrD',                             ;
                 'nOdvoZdrPC', 'nOdvoZdrPO', 'nOdvoZdrPZ',                             ;
                 'nDanZaklMz', 'nDanZaklSP', 'nDanCelVyp', 'nDanRocVyu', 'nNezdCasZD', ;
                 'nSlevaDanC', 'nSlevaDanU', 'nDanUlevaC', 'nDanBonusC', 'nZdanMzdaP', ;
                 'nSupHmMz'  , 'nSupHmMzZa', 'nSrazkoDan', 'nZalohoDan', 'nDanCelkem', ;
                 'nCistPrije', 'nNemocCelk', 'nNahradyPN', 'nNahr1_2PN', 'nZakOdCelk', ;
                 'nSrazkCelk', 'nCastKVypl', 'nZaklSrazk', 'nZaklOdbor'           } }, ;
             { 'nZaklSocPo', ;
               { 'nZaklSocPo', 'nZakSocZaD', 'nZakSocPrD', 'nZakSocStO',               ;
                 'nZakSocOpr'                                                     } }, ;
             { 'nZaklZdrPo', ;
               { 'nZaklZdrPo', 'nZakZdrZaD', 'nZakZdrPrD', 'nZakZdrOpr'           } }, ;
             { 'nDnyDoklad', ;
               { 'nFondKDDn' , 'nFondPDDn' , 'nFondPDSDn', 'nDnyFondKD', 'nDnyFondPD', ;
                 'nDnyOdprPD', 'nDnyNahrPD', 'nDnySvatPD', 'nDnyNeodPD', 'nDnyVoSoNe', ;
                 'nDnyDovBPD', 'nDnyDovMPD', 'nDnyNV',     'nDnyABS',                  ;
                 'nDnyVNSoNe', 'nDnyNemoKD', 'nDnyNemoPD',                             ;
                 'nDnyVylocD', 'nDnyVylDOD', 'nDnyNahrPN'                         } }, ;
             { 'nHodDoklad', ;
               { 'nHodFondKD', 'nHodFondPD', 'nHodFondUP', 'nHodOdprac', 'nHodNahrad', ;
                 'nHodSvatky', 'nHodNeodpr', 'nHodNeodZa', 'nHodVoSoNe', 'nHodVNSoNe', ;
                 'nHodNemoc' , 'nHodNemZak', 'nHodNahrPN', 'nHodPresc' , 'nHodPrescS', ;
                 'nHodPripl' , 'nHodDovBPD', 'nHodDovMPD'                         } }, ;
             { 'nHodFondPD', ;
               { 'nHodFondPD', 'nHodFondUP', 'nHodOdprac', 'nHodNahrad', ;
                 'nHodSvatky', 'nHodNahrPN', ;
                 'nHodPripl'                                                      } }, ;
             { 'nDnyFondPD', ;
               { 'nFondPDDn' , 'nFondPDSDn', 'nDnyFondPD',                             ;
                 'nDnyOdprPD', 'nDnyNahrPD', 'nDnySvatPD', 'nDnyNeodPD', 'nDnyNeKrPD', ;
                 'nDnyVoSoNe', ;
                 'nDnyDovBPD', 'nDnyDovMPD', 'nDnyNV',     'nDnyABS',                  ;
                 'nDnyNemoPD', 'nDnyNahrPN'                                       } }, ;
             { 'nDnyFondKD', ;
               { 'ndnyFondKD', 'nDnyNemoKD'                                       } }, ;
             { 'nDnyVylocD', ;
               { 'nDnyVylocD'                                                     } }, ;
             { 'nDnyVylDOD', ;
               { 'nDnyVylDOD'                                                     } }, ;
             { 'nDnyVylDZN', ;
               { 'nDnyVylocD','nDnyVylDOD'                                        } } }


*
** CLASS MZD_druhyMzd_CRD ******************************************************
CLASS MZD_druhymzd_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, postValidate
  method  Destroy
  METHOD  OnSave
  method  mzd_druhyMzd_sel

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

/*
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
*/

  inline method comboBoxInit(drgComboBox)
    local  acombo_val := {}, ky, block := { || .t. }, onSort := 2

    do case
    case( 'selmzdyit'  $ lower(drgComboBox:name) )
      acombo_val := { {'nmzda'     , 'Hrubá mzda'               }, ;
                      {'nZaklSocPo', 'Základ pro sociální poj.' }, ;
                      {'nZaklZdrPo', 'Základ pro zdravotní poj.'}, ;
                      {'nDnyDoklad', 'Dny dokladu'              }, ;
                      {'nHodDoklad', 'Hodiny dokladu'           }, ;
                      {'nHodFondPD', 'Hodiny fondu PracDoby'    }, ;
                      {'nDnyFondPD', 'Dny fondu PracDoby'       }, ;
                      {'nDnyFondKD', 'Dny fondu KalDoby'        }, ;
                      {'nDnyVylocD', 'Dny vylouèDoby'           }, ;
                      {'nDnyVylDOD', 'Dny vylouèDoby-ochrDoba'  }, ;
                      {'nDnyVylDZN', 'Dny vylouèDoby-žádostNem' }  }

      drgComboBox:oXbp:clear()
      drgComboBox:values := acombo_val
      AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    case( 'ctyppohzav' $ lower(drgComboBox:name) )
      acombo_val := { { '', '' } }
              ky := M_ZAVAZKY

      c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
      do while .not. c_typpoh ->(eof())
        if eval(block)
          typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
          aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                              c_typpoh ->cnaztyppoh         } )

*                              c_typpoh ->ctypdoklad       , ;
*                              alltrim(typdokl  ->ctypcrd) , ;
*                              c_typpoh->ctask             , ;
*                              c_typpoh->csubtask          , ;
*                              c_typpoh->craddph091          } )
        endif
        c_typpoh->(dbskip())
      endDo
      c_typpoh ->(dbclearscope())

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[onSort] < aY[onSort] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value
    endcase
  return self


  inline method comboItemSelected(drgComboBox)
    local value := drgComboBox:Value

    do case
    case 'ntypvyppre' $ lower(drgComboBox:name)
      if value = 0
        ( druhyMzdw->ndruhMzPre  := 0  , ::druhMzPre:set( 0 )            )
        (::druhMzPre:odrg:isEdit := .F., ::druhMzPre:odrg:oxbp:disable() )
      else
        (::druhMzPre:odrg:isEdit := .T., ::druhMzPre:odrg:oxbp:enable()  )
      endif
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgComboBox:oxbp)

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
    return .f.


HIDDEN:
 VAR   lNEWrec
 VAR   msg, dm, dc, df, ab
 var   typVypPre           , druhMzPre
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
       citem := strTran( pa_def[x], ' ' , ''   )
       citem := strTran( citem    , '->', '...')

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
           coperand := '='
         endCase

         cvyraz_1 := strTran( cvyraz_1, '...', '->' )
         cvyraz_2 := strTran( cvyraz_2, '...', '->' )
         cfield_m := upper ( listAsarray( cvyraz_2, '->')[2])

         s_Fieldsw->(dbAppend())
         s_Fieldsw->cvyraz_1 := cvyraz_1
         s_Fieldsw->cvyraz_2 := cvyraz_2
         s_Fieldsw->coperand := coperand
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

   inline method refresh(drgVar,nextFocus,vars_)
     local  nin, ovar, vars, new_val, dbArea

     default nextFocus to .f.

     if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                             vars   := drgVar:drgDialog:dataManager:vars
     else                 ;  dbarea := lower(drgVar)
                             vars   := vars_
     endif

     for nIn := 1 TO vars:size() step 1
       oVar := vars:getNth(nIn)

       if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
         if(new_val := eval(ovar:block)) <> ovar:value
           ovar:set(new_val)
         endif
         ovar:initValue := ovar:prevValue := ovar:value
       endif
     next

     if nextFocus
       PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
     endif
     return .t.

ENDCLASS


METHOD MZD_druhymzd_CRD:init(parent)

  ::drgUsrClass:init(parent)

  ::lNEWrec := (parent:cargo = drgEVENT_APPEND)
  if( druhyMzd->(eof()), ::lNewRec := .t., nil )

  drgDBMS:open('druhyMzd',,,,,'druhyMz_S')
  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))
  drgDBMS:open('c_zaokr',,,,,'c_zaokrA')
  drgDBMS:open('c_zaokr',,,,,'c_zaokrB')
  drgDBMS:open('c_zaokr',,,,,'c_zaokrC')
  drgDBMS:open('c_zaokr',,,,,'c_zaokrD')
  drgDBMS:open('c_zaokr',,,,,'c_zaokrE')


  // TMP soubory //
  drgDBMS:open('druhymzdw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('d_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('s_Fieldsw' ,.T., .T.,drgINI:dir_USERfitm); ZAP

  IF ::lNEWrec
    druhyMzdW->(dbAppend())
  ELSE
    mh_COPYFLD('druhymzd', 'druhymzdw', .T.)
  ENDIF

  c_zaokrA->( dbSeek(druhymzdw->nKodZaokr,,'C_ZAOKR1'))
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

  * premie
  ::typVypPre  := ::dm:get( 'druhyMzdw->ntypVypPre', .F. )
  ::druhMzPre  := ::dm:get( 'druhyMzdw->ndruhMzPre', .F. )

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

  if druhyMzd->ntypVypPre = 0
    (::druhMzPre:odrg:isEdit := .F., ::druhMzPre:odrg:oxbp:disable() )
  endif

  ::setFilter()
return self


method MZD_druhyMzd_crd:postValidate(drgVar)
  local  value    := drgVar:get()
  local  name     := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))

  local  lOk := .t.


  if(lOk, eval(drgVar:block,drgVar:value), nil)

  do case
  case( name = 'druhymzdw->ndruhmzpre' )
    lok := ::mzd_druhyMzd_sel()

  case( name = 'druhymzdw->nKodZaokr' )
    lok := c_zaokrA->( dbSeek(druhymzdw->nKodZaokr,,'C_ZAOKR1'))

  case( name = 'druhymzdw->nprnapnaho' )
    if lOk .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
      ::onSave()
    endif
  endcase
return lOk


method MZD_druhymzd_CRD:mzd_druhyMzd_sel(drgDialog)
  local  oDialog, nExit
  local  cfiltr, nrok := uctOBDOBI:MZD:NROK, nobdobi := uctOBDOBI:MZD:NOBDOBI
  *
  local drgVar := ::dataManager:get('druhymzdw->ndruhMzPre', .F.)
  local value  := drgVar:get()
  local ok

  cfiltr := Format("nROK = %% .and. nOBDOBI = %% .and. ctypDMZ = 'PREM'", {nrok,nobdobi})
  druhyMz_S->(ads_setAof( cfiltr ))
  ok     := (.not. Empty(value) .and. druhyMz_S->(dbseek(value,,'DRUHYMZD01')))

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'MZD_druhyMzd_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                      EXITSTATE nExit

    if nexit != drgEVENT_QUIT .or. ok
      druhymzdw->ndruhMzPre := druhyMz_S->ndruhMzdy
      ::refresh(drgVar,.t.)
    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)


METHOD MZD_druhymzd_CRD:onSave(lIsCheck,lIsAppend)
  local  cdefNap := '', coperand, cmpOper
  *
  local  lsocPojis := .f.
  local  lzdrPojis := .f.

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

    if( 'nzaklsocpo' $ s_Fieldsw->cvyraz_1, lsocPojis := .t., nil )
    if( 'nzaklzdrpo' $ s_Fieldsw->cvyraz_1, lzdrPojis := .t., nil )

    s_Fieldsw->(dbskip())
  enddo

  druhyMzdw->lsocPojis := lsocPojis
  druhyMzdw->lzdrPojis := lzdrPojis
  druhyMzdw->mdefNap   := cdefNap

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