#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_c_bankuc ******************************************************
CLASS FIN_agrikolexp_IN FROM drgUsrClass
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  expfakt
  method  dir

  var    obdobi, fileexp

/*
  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    endcase
  return .f.
*/

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method FIN_agrikolexp_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)

 ::obdobi := '  /  '
 ::fileexp := Padr( AllTrim(SysCONFIG('System:cPathExp'))+'\FakVysH.DBf', 100)

  drgDBMS:open('FakVysHD')

  drgDBMS:open('FakVysHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP

return self


method FIN_agrikolexp_IN:drgDialogInit(drgDialog)

return self


method FIN_agrikolexp_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method FIN_agrikolexp_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method FIN_agrikolexp_IN:postLastField(drgVar)
return .t.


method FIN_agrikolexp_IN:expfakt(drgVar)
  local  lok, cx
  local  cdirW := subStr( ::fileExp, 1, rat( '\', ::fileExp ) -1 )

//  ::dataManager:save()

  drgServiceThread:progressStart(drgNLS:msg('Export vystavených faktur ... ', 'FAKVYSHD'), ;
                                               fakvyshd->(lastRec())  )

  FakVysHD ->(dbGoTop())

  do while !FakVysHD->(Eof())
    if FakVysHD->cObdobi = ::obdobi
      mh_COPYFLD('FakVysHD', 'FakVysHDw', .T.)
    endif
    drgServiceThread:progressInc()
    FakVysHd->( dbSkip())
  enddo

  dbSelectArea('FakVysHDw')
  cx := AllTrim(::fileexp)

  myCreateDir( cdirW )
  COPY TO (cX) VIA 'FOXCDX'
//  COPY FILE  drgINI:dir_USERfitm+'FakVysHDw.fpt' TO StrTran( AllTrim(::fileexp),'.dbf','.fpt')

  drgServiceThread:progressEnd()

return .t.


method FIN_agrikolexp_IN:dir()
  local  path, n
  local  cfile := AllTrim(drgINI:dir_DATA)

  n     := Rat('\Data\', cfile)
  cfile := SubStr( cfile, 1, n)

  ::fileexp := selFILE('FakVysH','DBF', '' )

RETURN .t.
