#include "Appevent.ch"
#include "Common.ch"
#include "class.ch"
#include "Xbp.ch"

#include "drg.ch"
#include "..\Asystem++\Asystem++.ch"



class drgScrPos
exported:
  var    apos
  method init, getPos, savePos, destroy
  method getTre_Layout
  method getPos_forSel

  inline method get_mainFile_for_getBroFields(drgDialog)
    return ::get_mainFile(drgDialog)

hidden:
  var    m_dialog, m_deskTop, a_deskTop
  method desktop, scrpos, browse

  *   1          2         3        4              5
  **  fielName : caption : length : dtataPicture : colType
  inline method colWidth(ocol)
    local  clen := str(ocol:currentSize()[1]/drgINI:fontW,5,2)
    local  pa   := listAsArray(ocol:frmColum,':')
    *
    local  cc   := pa[1], nIn := len(pa)

    do case
    case     (nIn = 1)  ;  cc += '::'             +clen
    otherwise           ;  cc += ':'  +pa[2] +':' +clen
      aeval(pa,{|x| cc += ':' +x }, 4)
    endcase
  return cc

  inline method get_mainFile(drgDialog)
    local  cfile := '', amembers, x

    if drgDialog:helpName <> 'drgMenu'
      do case
      case drgDialog:dbName <> 'M'
        cfile := drgDialog:dbName

      otherwise
        amembers := drgDialog:oForm:aMembers

        begin sequence
          for x := 1 to len(amembers) step 1
            if amembers[x]:isEdit
              do case
              case ismemberVar(amembers[x], 'cfile')
                cfile := amembers[x]:cfile
        break

              case isObject(amembers[x]:ovar)
                 cfile := drgparse(amembers[x]:ovar:name,'-')
        break

              endcase
            endif
          next
        end sequence
      endcase

    endif
  return cfile
endclass

method drgScrPos:init()
  ::m_deskTop := appDesktop():currentSize()
return self



method drgScrPos:getTre_Layout(cname,odialog,m_file)
  local  cparent := if(isNull(odialog:parent), '',odialog:parent:formName)
  local  ky      := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(cname,50))
  local  m_cfile, ok := .f.
  *
  local  sel_Item   := space(22)
  local  tre_Layout := ''

  m_cfile := lower( m_file)

  if isobject(odialog)
    if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

    if asysini->(dbseek( ky +upper(m_file) +sel_Item,, 'ASYSINI03'))
      ok := .t.
    elseif asysini->(dbseek( ky +upper(m_cfile),, 'ASYSINI02'))
      ok := .t.
*    else
*      ok := asysini->(dbseek(ky,,'ASYSINI02'))
    endif
  endif
return if( ok, asysini->tre_layout, '' )


method drgScrPos:getPos_forSel(cname,odialog,m_file)
  local  cparent := if(isNull(odialog:parent), '',odialog:parent:formName)
  local  ky      := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(cname,50))
  local  buffer    , n, m_name
  local  bro_buffer, n_bro, xname, pos, item, value, pa
  local  m_cfile, ok := .f.
  *
  local  sel_Item  := space(22)
  local  pa_retVal := { , , 0 }

  m_cfile := lower( m_file)

  if isobject(odialog)
    if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

    if asysini->(dbseek( ky +upper(m_file) +sel_Item,, 'ASYSINI03'))
      ok := .t.
    elseif asysini->(dbseek( ky +upper(m_cfile),, 'ASYSINI02'))
      ok := .t.
*    else
*      ok := asysini->(dbseek(ky,,'ASYSINI02'))
    endif

    if ok
      buffer := strtran(MemoTran(asysini->mbrowse,chr(0)), ' ', '')

      while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
        if left(buffer,1) = '['
          m_name := lower(substr(buffer,2,n -3))

          * sekce browse je doplnìna o -název souboru
          if m_name = 'browse-' +m_cfile
            bro_buffer := substr(buffer, n +1)

            while( asc(bro_buffer) <> 0 .and. (n_bro := at(chr(0), bro_buffer)) > 0 )
              if Left(bro_buffer,1) <> '['
                xname := lower( substr(bro_buffer,1,n_bro -1))
                *
                pos   := at('=',xname)
                item  := substr(xname, 1, pos-1)
                value := substr(xname, pos+1)

                do case
                case item = 'ordname'
                  pa_retVal[1] := value

                case item = 'orddata'
                  pa           := listAsarray(allTrim(value))
                  ordType      := pa[1]
                  ordData      := pa[2]
                  pa_retVal[2] := if( ordType = 'n', val(ordData), upper(strTran(ordData, ' ', ' ')) )

                case item = 'sid'
                  pa_retVal[3] := val(value)

                endcase
              endif

              bro_buffer := substr(bro_buffer, n_bro +1)
            end
          endif
        endif
        buffer := substr(buffer, n +1)
      end
    endif
  endif
return pa_retVal


* ASYSINI01  ---  UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT)
* ASYSINI02  ---  UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT) +UPPER(CFILE)
* ASYSINI03  ---  UPPER(CUSER)+UPPER(CPARENT)+UPPER(CZKROBJECT) +UPPER(CFILE) +UPPER(sel_Item)

method drgScrPos:getPos(cname,odialog)
  local  cparent := if(isNull(odialog:cargo:parent), '',odialog:cargo:parent:formName)
  local  ky      := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(cname,50))
  local  buffer, n, m_name
  *
  local  m_cfile, ok := .f.
  *
  local  sel_Item := space(22), sel_Filtrs := {}, isQuick := .f.

  ::apos      := nil
  ::a_deskTop := {0,0}
  ::m_dialog  := odialog

  if isobject(odialog)

    if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

    m_cfile := upper( padr( ::get_mainFile(odialog:cargo), 10))
    *
    ** quickFilter na SEL dialogu
    if isObject(odialog:cargo:udcp)
      if IsMemberVar( odialog:cargo:udcp, 'sel_Item'  ) .and. ;
         IsMemberVar( odialog:cargo:udcp, 'sel_Filtrs')

        sel_Item   := upper( padr( odialog:cargo:udcp:sel_Item, 22))
        sel_Filtrs := odialog:cargo:udcp:sel_Filtrs
        isQuick    := .t.
      endif
    endif

    if asysini->(dbseek( ky +m_cfile +sel_Item,, 'ASYSINI03'))
      ok := .t.
    elseif asysini->(dbseek( ky +m_cfile,, 'ASYSINI02'))
      ok := .t.
*    else
*      ok := asysini->(dbseek(ky,,'ASYSINI02'))
    endif


    if ok
      buffer := strtran(MemoTran(asysini->mbrowse,chr(0)), ' ', '')

      while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
        if left(buffer,1) = '['
          m_name := lower(substr(buffer,2,n -3))

          * sekce browse je doplnìna o -název souboru
          m_name := if('browse' $ m_name, 'browse', m_name)

          do case
          case IsMethod(self, m_name, CLASS_HIDDEN)
            self:&m_name(substr(buffer, n +1))
          endcase
        endif
        buffer := substr(buffer, n +1)
      end

      *
      ** quickFilter na SEL dialogu
      if isQuick
        if .not. empty( asysini->sel_Filtrs)
          sel_Filtrs:= bin2Var( asysini->sel_Filtrs )
        endif
        odialog:cargo:udcp:sel_Filtrs := sel_Filtrs
      endif

    endif
  endif

  if(::m_deskTop[1]<>::a_deskTop[1] .or. ::m_deskTop[2]<>::a_deskTop[2], ::apos := nil, nil)
return ::apos


method drgScrPos:savePos(cname,odialog,lord)
  local  odbrowse := odialog:cargo:odbrowse
  local  cparent  := if(isNull(odialog:cargo:parent), '',odialog:cargo:parent:formName)
  local  ky       := upper(padr(usrName,10)) +upper(padr(cparent,50)) +upper(padr(cname,50)), x, obro, cfile
  local  mbrowse  := '', apos, asize, ordKey, ordData, x_ordData, d_ordData
  *
  local  frmColum, ocol, ncol, hWnd := odialog:getHwnd(), zoomed
  local  m_cfile, ok := .f., pa_ordList
  *
  local  sel_Item := space(22), sel_Filtrs := {}, isQuick := .f.
  local  cidForms := ''       , cPrinter   := ''
  *
  local  tre_Layout := ''
  *
  local  cky, strExpression
  local  bErrBlock, oError := NIL

  default lord to .f.

  if(select('asysini') = 0, drgDBMS:open('asysini'), nil)

  m_cfile := upper( padr( ::get_mainFile(odialog:cargo), 10))
  *
  ** quickFilter na SEL dialogu
  if isObject(odialog:cargo:udcp)
    if IsMemberVar( odialog:cargo:udcp, 'sel_Item'  ) .and. ;
       IsMemberVar( odialog:cargo:udcp, 'sel_Filtrs')

      sel_Item   := upper( padr( odialog:cargo:udcp:sel_Item, 22))
      sel_Filtrs := odialog:cargo:udcp:sel_Filtrs
      isQuick    := .t.
    endif

    if IsMemberVar( odialog:cargo:udcp, 'cidForms' ) .and. ;
       IsMemberVar( odialog:cargo:udcp, 'cPrinter' )

       cidForms := odialog:cargo:udcp:cidForms
       cPrinter := odialog:cargo:udcp:cPrinter
    endif
  endif

  *
  ** ExTree na  dialogu
  if isObject(odialog:cargo:udcp)
    if IsMemberVar( odialog:cargo:udcp, 'tre_Layout' )
      tre_Layout := odialog:cargo:udcp:tre_Layout
    endif
  endif

  *
  ** na dbseek se objevuje chyba - Operating system error - 40
  ** nedá se to nasimulovat, nìjak to souvisí s TAGEm, pøehodíme to na ads_Locate
  cky := "cuser = '%%' and cparent = '%%' and czkrObject = '%%' and cfile = '%%' and sel_Item = '%%'"
  strExpression := format( cky, { usrName, cparent, cname, m_cfile, sel_Item } )


/*
  if asysini->( ads_locate( strExpression ))
    ok := .t.
  elseif asysini->(dbseek( ky +m_cfile,, 'ASYSINI02'))
    ok := .t.
  endif
*/

  *
  ** na ads_locate se objevuje chyba - 68 - No table available/no database open
  ** nìjak to souvisí s ADS
  ** 6610:  The Advantage Database Server did not respond to a database request in a timely manner.
  *
  bErrBlock  := ErrorBlock( {|e| Break(e)} )
  BEGIN SEQUENCE
    if asysini->( ads_locate( strExpression ))
      ok := .t.
    elseif asysini->(dbseek( ky +m_cfile,, 'ASYSINI02'))
      ok := .t.
    endif

  RECOVER USING oError
    ErrorBlock( bErrBlock )
    return self

  ENDSEQUENCE
  ErrorBlock( bErrBlock )

  if( .not. ok, asysini->(dbappend()), asysini->(dbrlock()))

  aSize := appDesktop():currentSize()
  mbrowse  += '[desktop]' +CRLF
  mbrowse  += alltrim(str(aSize[1]) +':' +str(aSize[2])) +CRLF

  iconic := IsIconic(hwnd)

  apos   := odialog:currentPos()
  asize  := odialog:currentSize()
  zoomed := IsZoomed(hwnd)
  mbrowse += '[scrpos]' +CRLF

  if IsIconic(hwnd) = 1
    apos    := odialog:cargo:oForm:a_scrpos_ok
    mbrowse += alltrim(str(apos[1])  +':' + ;
                       str(apos[2])  +':' + ;
                       str(apos[3])  +':' + ;
                       str(apos[4])  +':' + ;
                       str(apos[5])) +CRLF
  else
    mbrowse += alltrim(str(apos[1])  +':' + ;
                       str(apos[2])  +':' + ;
                       str(asize[1]) +':' + ;
                       str(asize[2]) +':' + ;
                       str(zoomed))  +CRLF
  endif

  for x := 1 to len(odbrowse) step 1
    obro  := odbrowse[x]
    cfile := obro:cfile

    mbrowse += '[browse-' +upper(cfile) +']' +CRLF
    mbrowse += 'fileName = ' +cfile          +CRLF

    if isblock(obro:oxbp:ItemRbDown)
      mbrowse += 'ordName = ' +(cfile)->(AdsSetOrder()) +CRLF
      mbrowse += 'recNo   = ' +str((cfile)->(recNo()))  +CRLF
      *
      ordKey  := (cfile)->(indexKey())
      dbselectArea(cfile)
      *
      ** u TMP souborù se pøi ukládání vypíná TAG na 0, ani nic z pozicování se neobnovuje
      ordData   := if( empty(ordKey), '', &(ordKey) )
      x_ordData := if(valType(ordData) = 'N', str(ordData), strTran(ordData, ' ', ' '))
      d_ordData := if( dbdescend(), '1', '0' )

      mbrowse   += 'ordData = ' +valType(ordData) +',' +x_ordData +',' +d_ordData +CRLF

      if isMemberVar(obro,'toRecNo')
        mbrowse += 'toRecNo = ' +if(obro:toRecNo,'1','0') +CRLF

        pa_ordList := (cfile)->(ordList())
        if ((cfile)->(fieldPos('sID')) <> 0 .and. ascan( pa_ordList, 'ID') <> 0 )
          mbrowse += 'sID = ' +if( (cfile)->(eof()), '0', str( (cfile)->sID) ) +CRLF
        else
          mbrowse += 'sID = 0' +CRLF
        endif
      endif
    endif

    if obro:className() = 'drgDBrowse'
      frmColum := ''
      for ncol := 1 to obro:oxbp:colCount step 1
        ocol     := obro:oxbp:getColumn(ncol)

        if ocol:defColum[2] = "M->deBrowse_indicateRow"
        else
          frmColum += ::colWidth(ocol) +','
        endif

      next
    endif

    if obro:className() = 'drgEBrowse'
      frmColum := ''
      for ncol := 1 to obro:oxbp:colCount step 1
        ocol     := obro:oxbp:getColumn(ncol)

        if ocol:defColum[2] = "M->deBrowse_indicateRow"
        else
          frmColum += ::colWidth(ocol) +','
        endif

       next
    endif

    if( .not. empty(frmColum), mbrowse += 'frmColum = ' +left(frmColum,len(frmColum)-1) +CRLF, nil)
  next

  mbrowse += '[end]' +CRLF

  if asysini->(dbrlock())
    asysini->cuser      := usrName
    asysini->cparent    := cparent
    asysini->czkrObject := cname
    asysini->cfile      := m_cfile
    asysini->mbrowse    := mbrowse
    *
    asysini->cidForms   := cidForms
    asysini->cPrinter   := cPrinter
    *
    ** quickFiltr na SEl dialogu
    asysini->sel_Item   := sel_Item
    if isQuick
      asysini->sel_Filtrs := var2Bin( sel_Filtrs )
    endif
    *
    ** ExTree na  dialogu
    asysini->tre_Layout := tre_Layout
  endif

  asysini->(dbcommit(), dbunlock())
return self


method drgScrPos:destroy()
  ::apos := nil
return self

*
** hidden
method drgScrPos:desktop(buffer)
  local pa, n := at(chr(0), buffer)

  if (n > 0)
    pa := ListAsArray(substr(buffer,1,n -1),':')
    *
    ::a_deskTop[1] := val(pa[1])
    ::a_deskTop[2] := val(pa[2])
  endif
return self


method drgScrPos:scrpos(buffer)
  local pa, n := at(chr(0), buffer)

  if (n > 0)
    pa := ListAsArray(substr(buffer,1,n -1),':')
    *
    ::apos := aPos := {0,0,0,0,0}
    ::apos[1] := val(pa[1])
    ::apos[2] := val(pa[2])
    ::apos[3] := val(pa[3])
    ::apos[4] := val(pa[4])
    ::apos[5] := if(len(pa) = 5, val(pa[5]), 0)
  endif
return self

method drgScrPos:browse(buffer)
  local n, cname, pos, item, value, pa, obro, adbd, order, cc, seaKey
  *
  local fileName := '', ordName := '' , recNo   := 0, sid := 0, toRecNo := .f.
  local ordType := nil, ordData := nil, ordDire := 0, ordKey
  *
  local ctagName, indexDef

  while( asc(buffer) <> 0 .and. (n := at(chr(0), buffer)) > 0 )
    if Left(buffer,1) <> '['
      cname := lower(substr(buffer,1,n -1))
      *
      pos   := at('=',cname)
      item  := substr(cname, 1, pos-1)
      value := substr(cname, pos+1)

      do case
      case item = 'filename'  ;  fileName := value
      case item = 'ordname'   ;  ordName  := value
      case item = 'recno'     ;  recNo    := val(value)
      case item = 'toRecNo'   ;  toRecNo  := (value = '1')
      case item = 'sid'       ;  sid      := val(value)
      case item = 'ordData'   ;  pa       := listAsarray(allTrim(value))
                                 ordType  := pa[1]
                                 ordData  := pa[2]
                                 if(len(pa) = 3, ordDire := val(pa[3]), nil)
      endcase

      buffer := substr(buffer, n +1)
    else
      if isobject(::m_dialog)
        pa  := ::m_dialog:cargo:odbrowse
        if(pos := ascan(pa, {|x| lower(x:cfile) = fileName})) <> 0
          obro := pa[pos]

          if isblock(obro:oxbp:ItemRbDown)
            adbd := drgDBMS:getDBD(fileName)

            if( .not. empty(ordName), (fileName)->(AdsSetOrder(ordName)), nil)
            *
            if toRecNo
              do case
              case sid <> 0
                (fileName)->(dbseek( sid, .t., 'ID'))

              case( .not. empty(ordName) .and. .not. empty(ordData))
                seaKey := if( ordType = 'n', val(ordData), ;
                           if( ordType = 'c', upper(strTran(ordData, ' ', ' ')), ;
                            if( ordType = 'd', upper(ordData), upper(ordData))))

                (fileName)->(dbSeek(seaKey,.t.))
                obro:atStart = ''
              otherwise

                if (fileName)->(Ads_isRecordInAOF( recNo ))
                  (fileName)->(dbgoto(recNo))
                  if((fileName)->(eof()), (fileName)->(dbgotop()), nil)
                  obro:atStart = ''
                else
                  (fileName)->(dbgotop())
                  obro:atStart = ''
                endif
              endcase
            else
              * koliduje z požadavkem na FRM
              if obro:atStart = 'last'
                (fileName) ->( dbgoBottom())
                for x := 1 to 5 ; (fileName) ->( dbskip(-1)) ; next
                for x := 1 to 5 ; obro:oxbp:down() ; next
              endif
            endif
            *
            if obro:className() = 'drgDBrowse' .or. ;
               ( obro:className() = 'drgEBrowse' .and. isblock(obro:oxbp:ItemRbDown) )

              ctagName := lower( (fileName)->(ordSetFocus()) )
              indexDef := adbd:indexDef
              order    := ascan( indexDef, {|o| lower(o:cname) = ctagName } )
              if( order = 0, order := 1, nil )

              obro:order:setCaption(adbd:indexDef[order]:ccaption)
              obro:ordType := valtype((fileName)->(sx_keydata()))
              obro:toRecNo := toRecNo

              ordKey := (fileName)->(ordKey())
              if lower( left(ordKey, 5)) <> 'upper'
                obro:scope_Button:disable()
              else
                obro:scope_Button:enable()
              endif

//              if ordDire = 1
//                (fileName)->( dbSetDescend(.t.))
//                obro:sort_direction:SetCaption( MIS_SORT_DOWN )
//              endif

            endif
            obro:oxbp:refreshAll(.f.)
          endif
        endif
      endif

      EXIT
    endif
  end
return self