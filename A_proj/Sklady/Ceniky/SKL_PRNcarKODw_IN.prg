#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS FOR SKL_PRNcarKODw_IN ************************************************
CLASS SKL_PRNcarKODw_IN FROM drgUsrClass
EXPORTED:
  var     cidForms, cPrinter

  inline method init(parent)
    local recNo := cenZboz->( recNo()), rec_m_File
    local arSelect, cky, ok

    ::drgUsrClass:init(parent)

    ::oPrinter      := XbpPrinter():new()
    if( ::oPrinter:list() = nil, nil, ::oPrinter:create() )

    drgDBMS:open( 'FORMS' )
    drgDBMS:open( 'PRNcarKODw',.T.,.T.,drgINI:dir_USERfitm ) ; ZAP

    ::m_oDBro  := parent:parent:odBrowse[1]
    ::m_File   := lower(::m_oDBro:cFile)

    arSelect   := aclone(::m_oDBro:arSelect)
    rec_m_File := (::m_File)->( recNo())

    do case
    case ::m_oDBro:is_selAllRec
      (::m_File)->( dbgoTop())

      do while .not. (::m_File)->(eof())
        if ::m_File = 'cenzboz'
          ::add_cenZboz_to_PRNcarKODw()
        else
          cky := upper((::m_File)->ccisSklad) +upper((::m_File)->csklPol)
          ok  := cenZboz->( dbseek( cky,, 'CENIK12'))
          if( ok, ::add_cenZboz_to_PRNcarKODw(), nil )
        endif
        (::m_File)->( dbSkip())
      enddo

    otherwise
      if( len(arSelect) = 0, aadd( arSelect, (::m_File)->( recNo()) ), nil )

      for x := 1 to len( arSelect) step 1
        if ::m_File = 'cenzboz'
          cenZboz->( dbgoTo( arSelect[x]))
          ::add_cenZboz_to_PRNcarKODw()
        else
          (::m_File)->( dbgoTo( arSelect[x]))
          cky := upper((::m_File)->ccisSklad) +upper((::m_File)->csklPol)
          ok  := cenZboz->( dbseek( cky,, 'CENIK12'))
          if( ok, ::add_cenZboz_to_PRNcarKODw(), nil )
        endif
      next
    endcase

/*
    if( len(arSelect) = 0, aadd( arSelect, (::m_File)->( recNo()) ), nil )

    for x := 1 to len( arSelect) step 1
      if ::m_File = 'cenzboz'
        cenZboz->( dbgoTo( arSelect[x]))
        ok := .t.
      else
        (::m_File)->( dbgoTo( arSelect[x]))
        cky := upper((::m_File)->ccisSklad) +upper((::m_File)->csklPol)
        ok  := cenZboz->( dbseek( cky,, 'CENIK12'))
      endif

      if ok
        PRNcarKODw->( dbappend())
        PRNcarKODw->ccisSklad  := cenZboz->ccisSklad
        PRNcarKODw->csklPol    := cenZboz->csklPol
        PRNcarKODw->cnazZbo    := cenZboz->cnazZbo
        PRNcarKODw->ccarKod    := cenZboz->ccarKod
        PRNcarKODw->npocVytisk := 1
        PRNcarKODw->nCENZBOZ   := cenZboz->sID
      endif
    next
*/

    PRNcarKODw->( dbCommit(), dbgoTop())
    cenZboz   ->( dbgoTo( recNo      ))
    (::m_File)->( dbgoTo( rec_m_File ))
  return self


  inline method drgDialogInit(drgDialog)
    local  dialogName := upper(drgDialog:formName)
    local  cparent    := if(isNull(drgDialog:parent), '', drgDialog:parent:formName)
    local  ky         := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(dialogName,50))

    if asysini->(dbseek( ky +'PRNCARKODW',, 'ASYSINI02'))
      ::cidForms := asysini->cidForms
      ::cPrinter := allTrim(asysini->cPrinter)
    endif
  return self

  inline method drgDialogStart(drgDialog)
    local  x, asize
    local  pa
    local  members := drgDialog:oForm:aMembers
    *
    ::dm     := drgDialog:dataManager             // dataManager
    ::dc     := drgDialog:dialogCtrl              // dataCtrl
    ::df     := drgDialog:oForm                   // form
    ::ib     := drgDialog:oIconBar                // iconBar
    ::oEBro  := drgDialog:dialogCtrl:oBrowse[1]

    for x := 1 to len(members) step 1
      do case
      case(members[x]:ClassName() = 'drgPushButton') ; ::drgPush := members[x]
      endcase
    next

    if isobject(::drgPush)
      asize := ::drgPush:oxbp:parent:currentSize()
      ::drgPush:oXbp:setSize({ asize[1] -6, asize[2] -2 })

      ::drgPush:oXbp:setFont(drgPP:getFont(9))
      ::drgPush:oxbp:SetGradientColors( {0,6,210} ) // {0,6}

      ::drgPush:isEdit    := .f.
      ::drgPush:canResize := .t.
    endif
  return self


  inline method comboBoxInit( drgComboBox )
    local  cname         := lower(drgComboBox:name)
    local  aCOMBO_val    := { { '          ', space(50) } }
    local  aprinterNames, cdevName

    do case
    case ( 'cidforms' $ cname )
      forms->( ordSetFocus('FORMS05')            , ;
               dbsetScope(SCOPE_BOTH, 'CENZBOZ' ), ;
               dbgoTop()                         , ;
               dbeval( { || aadd( aCOMBO_val, { forms->cidForms, forms->cformName } ) }, ;
                       { || forms->ntypProj_L = 1                                 }   ), ;
               dbclearScope()                      )

      if( len(aCOMBO_val) > 1, aRemove(aCOMBO_val, 1), nil )

    case ( 'cprinter' $ cname )
      if isArray( aprinterNames := ::oPrinter:list() )
        aeval( aprinterNames, { |x| aadd( aCOMBO_val, { x, x } ) } )

        cdevName := ::oPrinter:devName
      endif

      if( len(aCOMBO_val) > 1, aRemove(aCOMBO_val, 1), nil )
    endcase

    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[1] < aY[1] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

    * musíme nastavit startovací hodnotu *
    if isNull( cdevName)
      if empty(::cidForms)
        ::cidForms := drgComboBox:value := drgComboBox:ovar:value := acombo_val[1,1]
      else
        drgComboBox:value := drgComboBox:ovar:value := ::cidForms
      endif
    else
      if empty(::cPrinter)
        ::cPrinter := drgComboBox:value := drgComboBox:ovar:value := cdevName
      else
        drgComboBox:value := drgComboBox:ovar:value := ::cPrinter
      endif
    endif

    drgComboBox:refresh( drgComboBox:value )
  return self


  inline method comboItemSelected( drgComboBox )
    local  cname, value

    if isObject( drgComboBox)
      cname := lower(drgComboBox:name)
      value := drgComboBox:value

      do case
      case ( 'cidforms' $ cname )  ;  ::cidForms := value
      case ( 'cprinter' $ cname )  ;  ::cPrinter := value
      endcase
    endif
  return self


  inline method pushButtonClick()
    local  recNo  := PRNcarKODw->(recNo())
    local  recCen := cenZboz->( recNo())
    local  cflt   := "sid = %%", cfiltr
    *
    local  cidForms := ::dm:get('M->cidForms' )
    local  cPrinter := ::dm:get('M->cPrinter' )

    forms  ->( dbseek( cidForms,, 'FORMS01'))

    PRNcarKODw->( dbgoTop())

    do while .not. PRNcarKODw->( eof())
      if PRNcarKODw->npocVytisk <> 0
        cfiltr := format( cflt, { PRNcarKODw->ncenZboz })

        cenZboz->( ads_setAof( cfiltr ), dbgoTop() )

        LL_PrintDesign( ,'PRN',,, cPrinter, PRNcarKODw->npocVytisk)

        cenZboz->( ads_clearAof(), dbgoTo( recCen) )
      endif
      PRNcarKODw->(dbskip())
    enddo

    PRNcarKODw->( dbgoTo( recNo))
    ::oEBro:oxbp:refreshAll()
  return self

HIDDEN:
  VAR     dm, dc, df, ib, drgPush, m_oDBro, m_File
  var     oPrinter, oEBro

  inline method add_cenZboz_to_PRNcarKODw()
    PRNcarKODw->( dbappend())
    PRNcarKODw->ccisSklad  := cenZboz->ccisSklad
    PRNcarKODw->csklPol    := cenZboz->csklPol
    PRNcarKODw->cnazZbo    := cenZboz->cnazZbo
    PRNcarKODw->ccarKod    := cenZboz->ccarKod
    PRNcarKODw->npocVytisk := 1
    PRNcarKODw->nCENZBOZ   := cenZboz->sID
  return .t.


  inline method setBroFocus()
    local  members := ::df:aMembers, brow := ::oEBro, pos

    pos  := ascan(members,{|X| (x = brow)})
    ::df:olastdrg   := brow
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()
    *
    ::dc:oabrowse := brow
    PostAppEvent(xbeBRW_ItemMarked ,,,brow:oxbp)
  return .t.


ENDCLASS