#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Appevent.ch"
#include "Font.ch"

#include "adsdbe.ch"
#include "ads.ch"
#include "inkey.ch"
#include "common.ch"
#include "asxml.ch"

#include "drg.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


#pragma library("asxml10.lib")
#pragma library("ot4xb.lib"  )


*
** CLASS for FRM FIR_firmy_ARES_scr ********************************************
CLASS FIR_firmy_ARES_scr FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart // , eventHandled
  *
  method  treeViewInit, XmlTreeAddItem
  *
  ** firmyW - errAres
  inline access assign method firmy_infoAres() var firmy_infoAres
    local  codp_Ares  := c_aresW->cares_Odp
    local  cval_Firmy := c_aresW->cfirmy_Dat
    *
    local  ninfo := 0

    do case
    case        Empty(codp_Ares) .and. Empty(cval_Firmy)
      ninfo := 0
    case  .not. Empty(codp_Ares) .and. Empty(cval_Firmy)
      ninfo := 350  // waring  DRG_ICON_MSGWARN
    case       Equal(codp_Ares, cval_Firmy)
      ninfo := 300  // ok      DRG_ICON_SAVE
    case .not. Equal(codp_Ares, cval_Firmy)
      ninfo := 351  // err     DRG_ICON_MSGERR
    endcase
  return ninfo
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  ctag_Name := allTrim(c_aresW->ctag_Name), ini

    DO CASE
    CASE (nEvent = xbeBRW_ItemMarked)
      if .not. ::isStart
        if (nin := ascan( ::pao_items, { |o| o:cargo = ctag_Name })) <> 0
          ::oxbpTree:setData(::pao_items[nin])
        endif
      endif
      ::isStart := .f.
      return .f.

     OTHERWISE
      RETURN .F.
    ENDCASE
  return .T.


HIDDEN:
  VAR    members, msg

  var    pa_slovnik_zkratek, pao_items, isStart
  var    oxbpTree, otree_Root, otree_Ares_odpovedi, otree_Odpoved
  var    tmp_Dir, cxml_File
ENDCLASS


METHOD FIR_firmy_ARES_scr:init(parent)
  local  cdir_Rsrc := drgINI:dir_RSRC
  local  c_slovnik_zkratek, nmaxLines, aLines, i, xval, nlen
  local  npos, ctext, czkr
  *
  local  odbd := drgDBMS:dbd:getByKey('firmy'), odrgRF
  local  ccnbHost, cares_UTF8, nTarget, cBuffer, nBytes

  ::drgUsrClass:init(parent)

  ::tmp_Dir   := drgINI:dir_USERfitm +userWorkDir() +'\'
  ::cxml_File := ::tmp_Dir +"odpoved_ares_bas.xml"
  *
  ** pokud neexistuje musíme ho založit a naèíst odpovìï pokut to jde
  myCreateDir( ::tmp_Dir )
  ccnbHost   := "http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_bas.cgi?ico=" +allTrim(str(firmy->nico))
  cares_UTF8 := loadFromUrl(ccnbHost)

  // sránka nenalezena, není pøipojení k internetu
  if isCharacter(cares_UTF8) .and. left(cares_UTF8,13) <> '<?xml version'
    // chyba asi hlášku a ven ???
  else
    nTarget := FCreate(::cxml_File )
    cBuffer := cares_UTF8
    nBytes  := Len(cBuffer)
    FWrite( nTarget, Left(cBuffer, nBytes) )
    FClose( nTarget )
  endif

  c_slovnik_Zkratek    := strTran( memoRead(cdir_Rsrc +'ares_slovnik_zkratek'), '"', '' )
  nmaxLines            := MlCount( c_slovnik_Zkratek, 80 )
  ::pa_slovnik_zkratek := {}
  ::pao_items          := {}
  ::isStart            := .t.

  for i := 1 TO nmaxLines
    cline := Trim( MemoLine( c_slovnik_Zkratek, 80, i ) )
    if( npos  := at('/', cline )) <> 0
      ctext := substr(cline, 1, npos-1)
      czkr  := substr(cline,    npos+1)

      aadd( ::pa_slovnik_zkratek, { czkr, ctext } )
    endif
  next

  drgDBMS:open('c_ares' )
  if( select('c_aresW') <> 0, c_aresw->(dbcloseArea()), nil)
  drgDBMS:open('c_aresW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  c_ares->(dbgoTop())
  do while .not. c_ares->( eof())
    mh_copyFld( 'c_ares', 'c_aresW', .t. )
    if isObject( odrgRF := odbd:getFieldDesc(allTrim(c_ares->cfield)))
      c_aresW->cfieldName := odrgRF:desc
      c_aresW->nflen_Dat  := odrgRF:len
    endif

    if(i := firmy->( FieldPos( allTrim(c_aresW->cfield)))) <> 0
      xVal := firmy->( FieldGet(i))
      nlen := c_aresW->nflen_Dat
      c_aresW->cfirmy_Dat := SYS_ares_allToC(xVal, nlen)
    endif

    c_ares->( dbskip())
  enddo
RETURN self


method FIR_firmy_ARES_scr:treeViewInit(odrg)
  local  nXMLDoc   := XMLDocOpenFile(::cxml_File)
  local  nTag      := XMLDocGetRootTag(nXMLDoc)
  local  oxbpTree  := odrg:oxbp

  ::oxbpTree := oxbpTree

  oxbpTree:setColorBG(GraMakeRGBColor( {220, 220, 250} ))
  oxbpTree:SetFontCompoundName("10.Helvetica")

// in XML, there can only be one root item...
   ::XmlTreeAddItem( oxbpTree:rootItem, nTag )

   ::otree_Root:expand(.t.)
   ::otree_Ares_odpovedi:expand(.t.)
   ::otree_Odpoved:expand(.t.)

   XMLDocClose(nXMLDoc)
return self


method FIR_firmy_ARES_scr:XmlTreeAddItem( o, nTag )
   local i
   local aChild
   local oChild
   local cCaption, ctag_Name, npos, nin, cares_Miss
   local oAttr
   local aMember
   *
   if XMLGetTag( nTag, @aMember )

      // ignore PCDATA and CDDATA items.  Firstly because they are erroneous within the structure
      // of the XML heirarchy, and also because they are undocumented and we are left to guess
      // what they might be...

      if !(aMember[XMLTAG_NAME] == '#PCDATA' .or. aMember[XMLTAG_NAME] == '#CDDATA')

         ctag_Name := aMember[XMLTAG_NAME]
         if( npos := at( ':', ctag_Name ) ) <> 0
           ctag_Name  := substr( ctag_Name, npos+1 )
         endif

         if( nin := ascan( ::pa_slovnik_zkratek, { |x| x[1] = ctag_Name } )) <> 0
           ctag_Name := ::pa_slovnik_zkratek[nin,2]
         endif

         cCaption := '<'+ctag_Name+'>'

         if !Empty(aMember[XMLTAG_CONTENT])
            cCaption += ' '+CUTF8TOANSI( aMember[XMLTAG_CONTENT] )
         endif
         o:addItem( cCaption,,,,,CUTF8TOANSI( aMember[XMLTAG_CONTENT] ) )
         aChild := o:getChildItems()
         oChild := aChild[Len(aChild)]

         if c_aresW->( dbSeek( padr(aMember[XMLTAG_NAME],10),,'C_ARESw02')) // D:N je tam 2x
           if .not. empty(c_aresW->mares_Miss)
             cares_Miss := SYS_ares_Miss( CUTF8TOANSI( aMember[XMLTAG_CONTENT] ), c_aresW->mares_Miss )
             oChild:setCaption(cCaption +' [ ' +cares_Miss +' ]')
             c_aresW->cares_Odp := cares_Miss
           else
             c_aresW->cares_Odp := CUTF8TOANSI( aMember[XMLTAG_CONTENT] )
           endif

           oChild:cargo := aMember[XMLTAG_NAME]
           aadd(::pao_items, oChild)
         endif

         if( aMember[XMLTAG_NAME] = '#ROOT'            , ::otree_Root          := oChild, nil )
         if( aMember[XMLTAG_NAME] = 'are:Ares_odpovedi', ::otree_Ares_odpovedi := oChild, nil )
         if( aMember[XMLTAG_NAME] = 'are:Odpoved'      , ::otree_Odpoved       := oChild, nil )

         if !aMember[XMLTAG_ATTRIB] == NIL
            if len(aMember[XMLTAG_ATTRIB]) > 0
               oChild:addItem('attr',,,,,'attr')
               oAttr := oChild:getChildItems()[1]
               for i := 1 to len(aMember[XMLTAG_ATTRIB])
                  oAttr:addItem('['+aMember[XMLTAG_ATTRIB][i][1]+'] '+aMember[XMLTAG_ATTRIB][i][2],,,,,aMember[XMLTAG_ATTRIB][i][2])
               next
            endif
         endif

         if !(aMember[XMLTAG_CHILD] == NIL)
            for i := 1 to len(aMember[XMLTAG_CHILD])
               ::XmlTreeAddItem( oChild, aMember[XMLTAG_CHILD][i] )
            next
         endif
      endif
   endif
return self
**
*
*****
METHOD FIR_firmy_ARES_scr:drgDialogStart(drgDialog)
  ::members  := drgDialog:oForm:aMembers
  ::msg      := drgDialog:oMessageBar             // messageBar

RETURN self