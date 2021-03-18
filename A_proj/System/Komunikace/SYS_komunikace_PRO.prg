#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "dmlb.ch"
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"
#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"

#include "..\A_main\WinApi_.ch"

#include "activex.ch"
#include "excel.ch"

#include "XbZ_Zip.ch"


#DEFINE  DBGETVAL(c)     Eval( &("{||" + c + "}"))

#pragma Library( "ASINet10.lib" )

static oExcel
static sName, sNameExt


*** objednávky pøijaté export
function DIST000008( oxbp ) // oxbp = drgDialog
  local afile_e
  local recNo
  local filtr

//  in_Dir := retDir(odata_datKom:PathExport)
//  file := selFILE( cX,cext,in_Dir,'Výbìr souboru pro export',{{cext+ " - soubory", tm}})

  afile_e := { {'objhead_e','objheadw'}, {'objitem_e','objitemw'}}
  recNo   := objhead->(recNo())

  drgDBMS:open( 'objhead',,,,, 'objhead_e' )
  drgDBMS:open( 'objitem',,,,, 'objitem_e' )
  drgDBMS:open( 'objheadw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'objitemw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  do while .not. objhead ->(Eof())
    mh_COPYFLD('objhead','objheadw', .t., .t.)
    filtr     := format( "ndoklad = %%", { objhead->ndoklad})
    objitem_e->( ads_setAof(filtr),dbgoTop())

    do while .not. objitem_e->(Eof())
      mh_COPYFLD('objitem_e','objitemw',.t., .t.)
      objitem_e->( dbSkip())
    enddo

    objitem_e->(ads_clearAof())
    objhead ->( dbSkip())
  enddo

  objhead ->(dbgoTo( recNo ))

  clsFileCom( afile_e)

  * picnem to ven
  zipCom( afile_e, 'DIST000008_'+AllTrim(Str(usrIdDB)))
  delFileCom( afile_e)
  drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)


*** objednávky pøijaté import
function DIST000009( oxbp ) // oxbp = drgDialog
  local afile_i
  local recNo
  local filtr

  afile_i := { {'objhead_i','objheadw'}, {'objitem_i','objitemw'}}
  unzipCom( 'DIST000008_'+ SubStr(AllTrim(Str(usrIdDB)),1,4)+'??')

  recNo   := objhead->(recNo())
  afile_i := { 'objhead_i', 'objitem_i'}

  drgDBMS:open( 'objhead',,,,, 'objhead_i' )
  drgDBMS:open( 'objitem',,,,, 'objitem_i' )

  drgDBMS:open('objheadw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
  drgDBMS:open('objitemw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

  do while .not. objheadw ->(Eof())
    filtr := format( "ndoklad = %%", { objheadw->ndoklad})
    objitemw->(ads_setAof(filtr),dbgoTop())

    if objhead_i->( dbSeek( objheadw->ndoklad,,'OBJHEAD7'))
/*
        if drgIsYESNO(drgNLS:msg('Pøepsat existující objednávku èíslo ' + AllTrim( Str(objheadw->ndoklad))+ '  ?'))
          if objhead_i->( dbRlock())
             mh_COPYFLD('objheadw','objhead_i', .f., .t.)
             do while .not. objitemw ->(Eof())
               if objhead_i->( dbSeek( strZero(objheadw->nDoklad,10) +strZero(objheadw->nCislPolOb,5),,'OBJHEAD25'))
                 mh_COPYFLD('objitemw','objitem_i', .f., .t.)
               else
                 mh_COPYFLD('objitemw','objitem_i', .t., .t.)
               endif
             enddo
          endif
        endif
*/
    else
      mh_COPYFLD('objheadw','objhead_i', .t., .t.)
      dbeval( { || mh_copyFld( objitemw, 'objitem_i', .t. ) } )
    endif
    objhead_i->( dbUnLock())
    objheadw->( dbSkip())
  enddo

  clsFileCom( afile_i)
  delFileCom( afile_i)
  drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)

*** export prodejních ceníkù
function DIST000010( oxbp ) // oxbp = drgDialog
  local afile_e
  local recNo
  local filtr
  *
  local m_oDBro, m_File, arSelect

  m_oDBro  := oxbp:parent:odBrowse[1]
  m_File   := lower(m_oDBro:cFile)
  arSelect := aclone(m_oDBro:arSelect)

//  in_Dir := retDir(odata_datKom:PathExport)
//  file := selFILE( cX,cext,in_Dir,'Výbìr souboru pro export',{{cext+ " - soubory", tm}})


  afile_e := { {'cenzboz_e','cenzbozw'},   {'cenprodc_e','cenprodcw'} ;
              ,{'procenhd_e','procenhdw'}, {'procenit_e','procenitw'} ;
              ,{'procenho_e','procenhow'} }
  recNo   := procenhd->(recNo())

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_e' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_e' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_e' )
  drgDBMS:open( 'procenit',,,,, 'procenit_e' )
  drgDBMS:open( 'procenho',,,,, 'procenho_e' )

  drgDBMS:open('cenzbozw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('cenprodcw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  filtr     := format( "ccissklad = '%%'", { '2'})
  cenzboz_e->( ads_setAof(filtr),dbgoTop())

  do while .not. cenzboz_e->(Eof())
    mh_COPYFLD('cenzboz_e','cenzbozw',.t., .t.)
    if cenprodc_e->( dbSeek( Upper( cenzboz_e->ccissklad)+ Upper(cenzboz_e->csklpol),,'CENPROD1'))
      if .not. cenprodcw->( dbSeek( Upper( cenzboz_e->ccissklad)+ Upper(cenzboz_e->csklpol),,'CENPROD1'))
        mh_COPYFLD('cenprodc_e','cenprodcw',.t., .t.)
      endif
    endif
    cenzboz_e->(dbSkip())
  enddo

  proCenhd->( dbgoTop())

  do while .not. procenhd ->(Eof())

    do case
    case m_oDBro:is_selAllRec
      lok := ( ascan( arSelect, proCenhd->( recNo()) )  = 0 )
    case len( arSelect ) <> 0
      lok := ( ascan( arSelect, proCenhd->( recNo()) ) <> 0 )
    otherwise
      lok := ( recNo = proCenhd->( recNo()) )
    endcase

    if lok
      mh_COPYFLD('procenhd','procenhdw', .t., .t.)
      filtr     := format( "ncisprocen = %%", { procenhd->ncisprocen})
      procenit_e->( ads_setAof(filtr),dbgoTop())

      do while .not. procenit_e ->(Eof())
        mh_COPYFLD('procenit_e','procenitw',.t., .t.)

        procenit_e ->( dbSkip())
      enddo
      procenit_e->(ads_clearAof())

      procenho_e->( ads_setAof(filtr),dbgoTop())

      do while .not. procenho_e->(Eof())
        mh_COPYFLD('procenho_e','procenhow',.t., .t.)
        procenho_e->( dbSkip())
      enddo
      procenho_e->(ads_clearAof())
    endif

    procenhd->( dbSkip())
  enddo

  procenhd->(dbgoTo( recNo ))

  clsFileCom( afile_e)

  * picnem to ven
  zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))
  delFileCom( afile_e)
  drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)


*** import prodejních ceníkù
function DIST000011( oxbp ) // oxbp = drgDialog
  local afile_i
  local recNo
  local filtr

    unzipCom( 'DIST000010_'+ SubStr(AllTrim(Str(usrIdDB)),1,4)+'??')

    afile_i := { {'cenzboz_i','cenzbozw'},   {'cenprodc_i','cenprodcw'} ;
                ,{'procenhd_i','procenhdw'}, {'procenit_i','procenitw'} ;
                ,{'procenho_i','procenhow'} }

    recNo   := procenhd->(recNo())

    drgDBMS:open( 'cenzboz',,,,,  'cenzboz_i' )
    drgDBMS:open( 'cenprodc',,,,, 'cenprodc_i' )
    drgDBMS:open( 'procenhd',,,,, 'procenhd_i' )
    drgDBMS:open( 'procenit',,,,, 'procenit_i' )
    drgDBMS:open( 'procenho',,,,, 'procenho_i' )

    drgDBMS:open('cenzbozw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('cenprodcw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('procenhdw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('procenitw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
    drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

    do while .not. procenhdw->(Eof())
      if procenhd_i->( dbSeek( strzero(procenhdw->nTypProCen,5)+strzero(procenhdw->nCisProCen,10),,'PROCENHD02'))
        if( procenhd_i->( dbRlock()), (mh_COPYFLD('procenhdw','procenhd_i', .f., .t.),procenhd_i->( dbUnLock())), nil)
      else
        mh_COPYFLD('procenhdw','procenhd_i', .t., .t.)
      endif

      filtr     := format( "ncisprocen = %%", { procenhdw->ncisprocen})

      procenit_i->( ads_setAof(filtr),dbgoTop())
      do while .not. procenit_i->(Eof())
        if( procenit_i->( dbRlock()), (procenit_i ->( dbDelete()),procenit_i ->(dbUnlock())), nil)
        procenit_i ->(dbSkip())
      enddo

      procenho_i->( ads_setAof(filtr),dbgoTop())
      do while .not. procenho_i->(Eof())
        if( procenho_i->( dbRlock()), (procenho_i ->( dbDelete()), procenho_i ->(dbUnlock())), nil)
        procenho_i ->(dbSkip())
      enddo

      procenhdw->( dbSkip())
    enddo

    procenit_i->( ads_clearaof())
    procenitw ->(dbGoTop())
    do while .not. procenitw ->(Eof())
      mh_COPYFLD('procenitw','procenit_i', .t., .t.)
      procenit_i->(dbUnlock())
      procenitw->( dbSkip())
    enddo

    procenho_i->( ads_clearaof())
    procenhow ->(dbGoTop())
    do while .not. procenhow ->(Eof())
      mh_COPYFLD('procenhow','procenho_i', .t., .t.)
      procenho_i->( dbUnlock())
      procenhow->( dbSkip())
    enddo

    cenzbozw->( dbGoTop())
    do while .not. cenzbozw->(Eof())
      if cenzboz_i->( dbSeek( Upper( cenzbozw->ccissklad)+ Upper(cenzbozw->csklpol),,'CENIK12'))
        if cenzboz_i->( dbRLock())
          mh_COPYFLD('cenzbozw','cenzboz_i', .f., .t.)
          cenzboz_i->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenzbozw','cenzboz_i', .t., .t.)
        cenzboz_i->( dbUnLock())
      endif
      cenzbozw->( dbSkip())
    enddo

    cenprodcw->( dbGoTop())
    do while .not. cenprodcw->(Eof())
      if cenprodc_i->( dbSeek( Upper( cenprodcw->ccissklad)+ Upper(cenprodcw->csklpol),,'CENPROD1'))
        if cenprodc_i->( dbRLock())
          mh_COPYFLD('cenprodcw','cenprodc_i', .f., .t.)
          cenprodc_i->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenprodcw','cenprodc_i', .t., .t.)
        cenprodc_i->( dbUnLock())
      endif
      cenprodcw->( dbSkip())
    enddo

    procenhd->(dbgoTo( recNo ))

    clsFileCom( afile_i)
    delFileCom( afile_i)
    drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)


*** export prodejních ceníkù pro konkrétní firmy
function DIST000012( oxbp ) // oxbp = drgDialog
  local afile_e
  local recNo
  local filtr

  afile_e := { {'cenzboz_e','cenzbozw'},   {'procenhd_e','procenhdw'}   ;
                ,{'procenit_e','procenitw'}, {'procenho_e','procenhow'} }
  recNo   := firmy->(recNo())

  drgDBMS:open( 'firmy',,,,,    'firmy_e' )
  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_e' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_e' )
  drgDBMS:open( 'procenit',,,,, 'procenit_e' )
  drgDBMS:open( 'procenho',,,,, 'procenho_e' )

  drgDBMS:open('firmy',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('cenzbozw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenitw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm); ZAP


  do while .not. firmy ->(Eof())
    filtr     := format( "ncisprocen = %%", { procenhd->ncisprocen})
    procenit_e->( ads_setAof(filtr),dbgoTop())

    do while .not. procenhd ->(Eof())
      mh_COPYFLD('procenhd','procenhdw', .t., .t.)

      filtr     := format( "ncisprocen = %%", { procenhd->ncisprocen})
      procenit_e->( ads_setAof(filtr),dbgoTop())
      do while .not. procenit_e ->(Eof())
        mh_COPYFLD('procenit_e','procenitw',.t., .t.)

        if cenzboz_e->( dbSeek( Upper( procenit_e->ccissklad)+ Upper(procenit_e->csklpol),,'CENIK12'))
          if .not. cenzbozw->( dbSeek( Upper( procenit_e->ccissklad)+ Upper(procenit_e->csklpol),,'CENIK12'))
            mh_COPYFLD('cenzboz_e','cenzbozw',.t., .t.)
          endif
        endif
        procenit_e ->( dbSkip())
      enddo
      procenit_e->(ads_clearAof())

      procenho_e->( ads_setAof(filtr),dbgoTop())
      do while .not. procenho_e->(Eof())
        mh_COPYFLD('procenho_e','procenhow',.t., .t.)
        procenho_e->( dbSkip())
      enddo
      procenho_e->(ads_clearAof())

      procenhd->( dbSkip())
    enddo
  enddo
  firmy->(dbgoTo( recNo ))

  clsFileCom( afile_e)

  * picnem to ven
  zipCom( afile_e, 'DIST000010_'+AllTrim(Str(usrIdDB)))
  delFileCom( afile_e)
  drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)


*** import prodejních ceníkù pro konkrétní firmy
function DIST000013( oxbp ) // oxbp = drgDialog
  local afile_i
  local recNo
  local filtr

  unzipCom( 'DIST000010_'+ SubStr(AllTrim(Str(usrIdDB)),1,4)+'??')

  afile_i := { {'cenzboz_i','cenzbozw'},   {'procenhd_i','procenhdw'}   ;
              ,{'procenit_i','procenitw'}, {'procenho_i','procenhow'} }

  recNo   := procenhd->(recNo())

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_i' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_i' )
  drgDBMS:open( 'procenit',,,,, 'procenit_i' )
  drgDBMS:open( 'procenho',,,,, 'procenho_i' )

  drgDBMS:open('cenzbozw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
  drgDBMS:open('procenhdw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
  drgDBMS:open('procenitw',.T.,.T.,drgINI:dir_USERfitm,,,.t.)
  drgDBMS:open('procenhow',.T.,.T.,drgINI:dir_USERfitm,,,.t.)

  do while .not. procenhdw->(Eof())
    if procenhd_i->( dbSeek( strzero(procenhdw->nTypProCen,5)+strzero(procenhdw->nCisProCen,10),,'PROCENHD02'))
      if( procenhd_i->( dbRlock()), mh_COPYFLD('procenhdw','procenhd_i', .f., .t.), nil)
    else
      mh_COPYFLD('procenhdw','procenhd_i', .t., .t.)
    endif

    filtr     := format( "ncisprocen = %%", { procenhd->ncisprocen})

    procenit_i->( ads_setAof(filtr),dbgoTop())
    do while .not. procenit_i->(Eof())
      if( procenit_i->( dbRlock()), procenit_i ->( dbDelete()), nil)
      procenit_i ->(dbSkip())
    enddo
    procenit_i ->(dbUnlock())

    procenho_i->( ads_setAof(filtr),dbgoTop())
    do while .not. procenho_i->(Eof())
      if( procenho_i->( dbRlock()), procenho_i ->( dbDelete()), nil)
      procenho_i ->(dbSkip())
    enddo
    procenho_i ->(dbUnlock())

    procenhd_i->( dbUnLock())
    procenhdw->( dbSkip())
  enddo

  procenit_i->( ads_clearaof())
  procenitw ->(dbGoTop())
  do while .not. procenitw ->(Eof())
    mh_COPYFLD('procenitw','procenit_i', .t., .t.)
    procenitw->( dbSkip())
  enddo

  procenho_i->( ads_clearaof())
  procenhow ->(dbGoTop())
  do while .not. procenhow ->(Eof())
    mh_COPYFLD('procenhow','procenho_i', .t., .t.)
    procenhow->( dbSkip())
  enddo

  cenzbozw->( dbGoTop())
  do while .not. cenzbozw->(Eof())
    if cenzboz_i->( dbSeek( Upper( cenzbozw->ccissklad)+ Upper(cenzbozw->csklpol),,'CENIK12'))
      if cenzboz_i->( dbRLock())
        mh_COPYFLD('cenzbozw','cenzboz_i', .f., .t.)
        cenzboz_i->( dbUnLock())
      endif
    else
      mh_COPYFLD('cenzbozw','cenzboz_i', .t., .t.)
    endif
    cenzbozw->( dbSkip())
  enddo

  procenhd->(dbgoTo( recNo ))

  clsFileCom( afile_i)
  delFileCom( afile_i)
  drgMsgBox(drgNLS:msg('pøenos tabulek byl dokonèen'), XBPMB_INFORMATION)

return( nil)


// Export PROCENHO do txt formátu i služba
function DIST000065( oxbp ) // oxbp = drgDialog
  local  file, in_Dir, filtr, nHandle, cx
  local  oThread, lview := .not. Empty(oxbp)

  if lview
    in_Dir := retDir(odata_datKom:PathExport)
    file   := selFILE('proSlevy','Txt', in_Dir,'Výbìr souboru pro export',{{"TXT soubory", "*.TXT"}})

    if empty(file)
      return 0
    endif

  else
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathExport)
    file   := in_Dir + odata_datKom:FileExport
  endif

  drgDBMS:open('procenho',,,,, 'procenho_e' )
  filtr     := format( "ntypprocen = 1 .and. empty(dplatnyod) .or. (dplatnyod <= '%%' .and. dplatnydo >= '%%')", { Date(),Date()})
  procenho_e->( ads_setAof(filtr),dbgoTop())

  if .not. Empty(file)
    nHandle := FCreate( file )

    do while .not. procenho_e->(Eof())
      cx := AllTrim(Str( procenho_e->ntypprocen,5,0))+ ";"+             ;
             AllTrim(Str( procenho_e->ncisfirmy,5,0))+ ";"+             ;
              AllTrim(Str( procenho_e->nzbozikat,4,0))+ ";"+            ;
               "'" + AllTrim(procenho_e->ccissklad)+"'" + ";"+          ;
                "'" + AllTrim(procenho_e->csklpol)+"'"  + ";"+          ;
                 "'" + AllTrim(procenho_e->czkratmeny)+"'"  + ";"+      ;
                  AllTrim(Str( procenho_e->ntyphodn,4,0)) + ";"+        ;
                   AllTrim(Str( procenho_e->nhodnota,16,4)) + ";"+      ;
                    AllTrim(Str( procenho_e->nprocento,10,4)) + ";"+    ;
                     "'" + dtoc( procenho_e->dplatnyod)+"'"  + ";"+     ;
                      "'" + dtoc( procenho_e->dplatnydo)+"'" +CRLF

      FWrite( nHandle, cx)
      procenho_e->( dbSkip())
    enddo

    procenho_e->( dbCloseArea() )

    FWrite( nHandle, Chr( 26), 1)
    FClose( nHandle)
  endif

  if lview
    drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
  endif
return( nil)


// Export slev za kategorie PROCENHO do txt formátu
function DIST000066( oxbp ) // oxbp = drgDialog
  local  file, in_Dir, filtr, nHandle, cx
  local  oThread, lview := .not. Empty(oxbp)
  *
  local  npoc := 1
  local  count
  local  lok := .f.

  if  lview
    in_Dir  := retDir(odata_datKom:PathExport)
    file    := selFILE('categories_update','csv', in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})
//    file    := selFILE('pokus1','csv', in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})
  else
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathExport)
    file   := in_Dir + 'categories_update.csv'
//    file   := in_Dir + 'pokus1.csv'

  endif

  drgDBMS:open('procenho',,,,, 'procenho_e' )
  filtr     := format( "ntypprocen = 1 .and. nzbozikat <> 0 .and. empty(dplatnyod) .or. (dplatnyod <= '%%' .and. dplatnydo >= '%%')", {'2       ',Date(),Date()})
  procenho_e->( ads_setAof(filtr),dbgoTop())
  count     := procenho_e->( Ads_GetKeyCount())

  if .not. Empty(file)

    nHandle := FCreate( file )

    do while .not. procenho_e->(Eof())

      cx :=  AllTrim(Str( procenho_e->ncisfirmy,5,0))+ ";"+             ;
              AllTrim(Str( procenho_e->nzbozikat,4,0))+ ";"+            ;
                AllTrim(Str( procenho_e->nprocento,10,4))+ if( npoc < count, CRLF, '')
      npoc++

      FWrite( nHandle, cx)
      procenho_e->( dbSkip())
    enddo

    procenho_e->( ads_clearAof())
    procenho_e->( dbCloseArea() )
    FClose( nHandle)

    lok := ftpComSend( file,, lview, odata_datKom)
    fErase( file)

  endif

  if lview
    if lok
       drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
    else
       drgMsgBox(drgNLS:msg('pøenos údajù byl neúspìšný'), XBPMB_WARNING)
    endif
  endif

return( nil)



// Export slev za skladové položky PROCENHO do txt formátu
function DIST000067( oxbp ) // oxbp = drgDialog * prodejní ceníky
  local  file, in_Dir, filtr, nHandle, cx
  local  oThread, lview := .not. Empty(oxbp)
*
  local  npoc := 1
  local  count
  local  lok := .f.

  if lview
    in_Dir := retDir(odata_datKom:PathExport)
    file   := selFILE('products_update','csv', in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})
//    file   := selFILE('pokus2','csv', in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})

  else
    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathExport)
    file  := in_Dir +'products_update.csv'
//    file  := in_Dir +'pokus2.csv'
  endif

  drgDBMS:open( 'procenho',,,,, 'procenho_e' )
  filtr     := format( "ntypprocen = 1 .and. ccissklad = '%%' .and. csklpol <> ' ' .and. empty(dplatnyod) .or. (dplatnyod <= '%%' .and. dplatnydo >= '%%')", {'2       ',Date(),Date()})
  procenho_e->( ads_setAof(filtr),dbgoTop())
  count     := procenho_e->( Ads_GetKeyCount())

  if .not. Empty(file)
    nHandle := FCreate( file )

    do while .not. procenho_e->(Eof())
      cx :=  AllTrim( Str( procenho_e->ncisfirmy,5,0))+ ";"+         ;
               AllTrim( cAnsiToUtf8( procenho_e->csklpol))+ ";"+        ;
                 AllTrim( Str( procenho_e->nprocento,10,4)) +if( npoc < count, CRLF, '')
      npoc++

      FWrite( nHandle, cx)
      procenho_e->( dbSkip())
    enddo

    procenho_e->(ads_clearAof())
    procenho_e->( dbCloseArea() )
    FClose( nHandle)

    lok := ftpComSend( file,, lview, odata_datKom)
    fErase( file)
  endif

  if lview
    if lok
       drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
    else
       drgMsgBox(drgNLS:msg('pøenos údajù byl neúspìšný'), XBPMB_WARNING)
    endif
  endif
return( nil)



// Export prodejních cen za skladové položky CENPRODC do txt formátu
function DIST000068( oxbp ) // oxbp = drgDialog * prodejní ceníky
  local  file, in_Dir, filtr, nHandle, cx
  local  oThread, lview := .not. Empty(oxbp)
*
  local  npoc := 1
  local  count
  local  lok := .f.

  if lview
    in_Dir := retDir(odata_datKom:PathExport)
    file   := selFILE('pricelist','csv',in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})
//    file   := selFILE('pokus3','csv',in_Dir,'Výbìr souboru pro export',{{"CSV soubory", "*.CSV"}})
  else

    oThread := ThreadObject()
    if .not. isMemberVar( oThread, 'odata_datKom')
      return 0
    else
      odata_datKom := oThread:odata_datKom
    endif

    in_Dir := retDir(odata_datKom:PathExport)
    file  := in_Dir +'pricelist.csv'
//    file  := in_Dir +'pokus3.csv'
  endif

  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_e' )
  filtr     := format( "ccissklad = '%%'", {'2       '})
  cenprodc_e->( ads_setAof(filtr),dbgoTop())
  count     := cenprodc_e->( Ads_GetKeyCount())

  if .not. Empty(file)
    nHandle := FCreate( file )

    do while .not. cenprodc_e->(Eof())
      cx :=  AllTrim( cAnsiToUtf8( cenprodc_e->csklpol))+ ";"+             ;
                AllTrim( Str(cenprodc_e->ncenapzbo,10,4)) +if( npoc < count, CRLF, '')

      npoc++
      FWrite( nHandle, cx)
      cenprodc_e->( dbSkip())
    enddo

    cenprodc_e->( ads_clearAof())
    cenprodc_e->( dbCloseArea())
    FClose( nHandle)

    lok := ftpComSend( file,, lview, odata_datKom)
    fErase( file)
  endif

  if lview
    if lok
       drgMsgBox(drgNLS:msg('pøenos údajù byl dokonèen'), XBPMB_INFORMATION)
    else
       drgMsgBox(drgNLS:msg('pøenos údajù byl neúspìšný'), XBPMB_WARNING)
    endif
  endif

return( nil)



// Synchronizace objednávek pøijatých - jednosmìrná
function DIST000091( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir
  local j, n := 0
  local line, aline
  local afiles := {}
  local cDBafir, cUSRafir, cPASWafir
  local cConnect
  local oSession_dbfi
  local lExc := Set(_SET_EXCLUSIVE), lReadOnly := .f.
  local obox

  m_oDBro   := oxbp:parent:odBrowse[1]
  m_File    := lower(m_oDBro:cFile)
  arSelect  := aclone(m_oDBro:arSelect)

  if Empty(arSelect)
    drgMsgBox(drgNLS:msg('Nejsou vybrány žádné objednávky k synchronizaci !!!'))
    return nil
  endif

  drgDBMS:open( 'objhead',,,,, 'objhead_e' )
  drgDBMS:open( 'objitem',,,,, 'objitem_e' )

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
//  cDBasys         := '77.95.194.215'
//  cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
//  cUSRasys        := ";UID=UsrPodpora;PWD=BarUhvezdY;"
//  cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRasys

// Agrikol
  cDBafir         := AllTrim(odata_datKom:SynAdresDBfi)
  cDBafir         := "\\"+ cDBafir + AllTrim( retDir( odata_datKom:SynPathDBfi)) + AllTrim(odata_datKom:SynNameDBfi)
  cPASWafir       := AllTrim(odata_datKom:SynPasswDBfi)
  cPASWafir       := if( cPASWafir = "*" .and. Len( cPASWafir) = 1, '', cPASWafir)
  cUSRafir        := ";UID=" + AllTrim(odata_datKom:SynUserDBfi) + ";PWD=" + cPASWafir + ";"
  cConnect        := "DBE=ADSDBE;SERVER=" +cDBafir +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRafir

***

  osession_dbfi  := dacSession():New( cConnect)
  if .not. ( osession_dbfi:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na firemní databázi >>' + AllTrim(odata_datKom:SynNameDBfi)+ '<<   !!!'))
    return nil
  endif

  obox := sys_moment( 'probíhá pøenos dat')

  DBUseArea(.T., osession_dbfi, 'objhead', 'objhead_o' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'objitem', 'objitem_o' ,!lExc, lReadOnly)

  osession_dbfi:beginTransaction()

  BEGIN SEQUENCE

    for n := 1 to len(arSelect) step 1
      objHead_e->( dbgoTo( arSelect[n]))

      if objHead_e->nStav_KOMU = 5
        if objhead_o ->( dbSeek( objhead_e->ndoklad,,'OBJHEAD7'))
          if objHead_o->( RLock())
            objHead_o->( dbDelete())
            objHead_o->( DbUnlock())

            objitem_o->( AdsSetOrder('OBJITE21'), dbsetscope(SCOPE_BOTH, objhead_e->ndoklad), dbgotop() )
            do while .not. objitem_o->( eof())
              if objitem_o->( RLock())
                objitem_o->( dbDelete())
              endif
              objitem_o->( dbSkip())
            enddo
          endif
        endif
      endif

      if .not. objhead_o ->( dbSeek( objhead_e->ndoklad,,'OBJHEAD7'))
        mh_copyFld( 'objhead_e', 'objhead_o', .t. )
        objHead_o->nStav_KOMU := 2
        objHead_o->nStav_OBJP := 4

        if objHead_e->( RLock())
          objHead_e->nStav_KOMU := 1
          objHead_e->( DbUnlock())
        endif
        objitem_e->( AdsSetOrder('OBJITE21'), dbsetscope(SCOPE_BOTH, objhead_e->ndoklad), dbgotop() )

        do while .not. objitem_e->( eof())
          mh_copyFld( 'objitem_e', 'objitem_o', .t. )
          objitem_o->nStav_KOMU := 2
          objitem_o->nStav_OBJP := 4
          if objitem_e->( RLock())
            objitem_e->nStav_KOMU := 1
            objitem_e->( DbUnlock())
          endif
          objitem_e->( dbskip())
        enddo
        objitem_e->( dbclearScope())
      endif
    next

    objhead_o->( dbUnlock(), dbCommit())
    objitem_o->( dbUnlock(), dbCommit())

    osession_dbfi:commitTransaction()

  RECOVER USING oError
    osession_dbfi:rollbackTransaction()

  END SEQUENCE


  if( isObject(osession_dbfi), osession_dbfi:disconnect(), nil )
  obox:destroy()
  drgMsgBox(drgNLS:msg('synchronizace byla dokonèena'), XBPMB_INFORMATION)
return( nil)



// Synchronizace prodejních cen - jednosmìrná
function DIST000095( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir
  local j, n := 0
  local line, aline
  local afiles := {}
  local cDBafir, cUSRafir, cPASWafir, cDBmat
  local cConnect
  local oSession_dbfi
  local lExc := Set(_SET_EXCLUSIVE), lReadOnly := .f.
  local obox

  m_oDBro   := oxbp:parent:odBrowse[1]
  m_File    := lower(m_oDBro:cFile)
  arSelect  := aclone(m_oDBro:arSelect)

  if Empty(arSelect)
    drgMsgBox(drgNLS:msg('Nejsou vybrány žádné objednávky k synchronizaci !!!'))
    return nil
  endif

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_e' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_e' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_e' )
  drgDBMS:open( 'procenit',,,,, 'procenit_e' )
  drgDBMS:open( 'procenho',,,,, 'procenho_e' )

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
//  cDBasys         := '77.95.194.215'
//  cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
//  cUSRasys        := ";UID=UsrPodpora;PWD=BarUhvezdY;"
//  cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRasys

// Agrikol
  cDBmat          := AllTrim( odata_datKom:SynNameDBfi)
  cDBmat          := Substr( cDBmat, 1, At('.',cDBmat)-1)
  cDBafir         := AllTrim(odata_datKom:SynAdresDBfi)
  cDBafir         := "\\"+ cDBafir + AllTrim( retDir( odata_datKom:SynPathDBfi)) + AllTrim(odata_datKom:SynNameDBfi)
  cPASWafir       := AllTrim(odata_datKom:SynPasswDBfi)
  cPASWafir       := if( cPASWafir = "*" .and. Len( cPASWafir) = 1, '', cPASWafir)
  cUSRafir        := ";UID=" + AllTrim(odata_datKom:SynUserDBfi) + ";PWD=" + cPASWafir + ";"
  cConnect        := "DBE=ADSDBE;SERVER=" +cDBafir +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRafir

***

  osession_dbfi  := dacSession():New( cConnect)
  if .not. ( osession_dbfi:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na firemní databázi >>' + AllTrim(odata_datKom:SynNameDBfi)+ '<<   !!!'))
    return nil
  endif

  obox := sys_moment( 'probíhá pøenos dat')

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_a' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_a' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_a' )
  drgDBMS:open( 'procenit',,,,, 'procenit_a' )
  drgDBMS:open( 'procenho',,,,, 'procenho_a' )

  DBUseArea(.T., osession_dbfi, 'cenzboz',  'cenzboz_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'cenprodc', 'cenprodc_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenhd', 'procenhd_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenit', 'procenit_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenho', 'procenho_m' ,!lExc, lReadOnly)

  osession_dbfi:beginTransaction()

  BEGIN SEQUENCE

//  doèasnì pro verzi 1.07.03 jinak vymazat nulování stávajících pøenosù

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenhd_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenhd_a->(Eof())
      if( procenhd_a->( dbRlock()), (procenhd_a ->( dbDelete()), procenhd_a ->(dbUnlock())), nil)
      procenhd_a ->(dbSkip())
    enddo
    procenhd_a->( ads_ClearAof())

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenit_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenit_a->(Eof())
      if( procenit_a->( dbRlock()), (procenit_a ->( dbDelete()), procenit_a ->(dbUnlock())), nil)
      procenit_a ->(dbSkip())
    enddo
    procenit_a->( ads_ClearAof())

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenho_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenho_a->(Eof())
      if( procenho_a->( dbRlock()), (procenho_a ->( dbDelete()), procenho_a ->(dbUnlock())), nil)
      procenho_a ->(dbSkip())
    enddo
    procenho_a->( ads_ClearAof())


///  vlastní synchronizace
    do while .not. procenhd_m->(Eof())
      if procenhd_a->( dbSeek( procenhd_m->cDBID_imp,,'DBID_imp'))
        if procenhd_a->( dbRlock())
          mh_COPYFLD('procenhd_m','procenhd_a', .f., .t.)
          procenhd_a->cDBID_imp := cDBmat +StrZero(isNull( procenhd_m->sID, 0),10)
          procenhd_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenhd_m','procenhd_a', .t., .t.)
          procenhd_a->cDBID_imp := cDBmat +StrZero(isNull( procenhd_m->sID, 0),10)
      endif
      procenhd_m ->(dbSkip())
    enddo

    do while .not. procenit_m->(Eof())
      if procenit_a->( dbSeek( procenit_m->cDBID_imp,,'DBID_imp'))
        if procenit_a->( dbRlock())
          mh_COPYFLD('procenit_m','procenit_a', .f., .t.)
          procenit_a->cDBID_imp := cDBmat +StrZero(isNull( procenit_m->sID, 0),10)
          procenit_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenit_m','procenit_a', .t., .t.)
          procenit_a->cDBID_imp := cDBmat +StrZero(isNull( procenit_m->sID, 0),10)
      endif
      procenit_m ->(dbSkip())
    enddo

    do while .not. procenho_m->(Eof())
      if procenho_a->( dbSeek( procenho_m->cDBID_imp,,'DBID_imp'))
        if procenho_a->( dbRlock())
          mh_COPYFLD('procenho_m','procenho_a', .f., .t.)
          procenho_a->cDBID_imp := cDBmat +StrZero(isNull( procenho_m->sID, 0),10)
          procenho_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenho_m','procenho_a', .t., .t.)
          procenho_a->cDBID_imp := cDBmat +StrZero(isNull( procenho_m->sID, 0),10)
      endif
      procenho_m ->(dbSkip())
    enddo

    cenzboz_m->( dbGoTop())
    do while .not. cenzboz_m->(Eof())
      if cenzboz_a->( dbSeek( Upper( cenzboz_m->ccissklad)+ Upper(cenzboz_m->csklpol),,'CENIK12'))
        if cenzboz_a->( dbRLock())
          mh_COPYFLD('cenzboz_m','cenzboz_a', .f., .t.)
          cenzboz_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenzboz_m','cenzboz_a', .t., .t.)
        cenzboz_a->( dbUnLock())
      endif
      cenzboz_m->( dbSkip())
    enddo

    cenprodc_m->( dbGoTop())
    do while .not. cenprodc_m->(Eof())
      if cenprodc_a->( dbSeek( Upper( cenprodc_m->ccissklad)+ Upper(cenprodc_m->csklpol),,'CENPROD1'))
        if cenprodc_a->( dbRLock())
          mh_COPYFLD('cenprodc_m','cenprodc_a', .f., .t.)
          cenprodc_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenprodc_m','cenprodc_a', .t., .t.)
        cenprodc_a->( dbUnLock())
      endif
      cenprodc_m->( dbSkip())
    enddo

    osession_dbfi:commitTransaction()

  RECOVER USING oError
    osession_dbfi:rollbackTransaction()

  END SEQUENCE

  if( isObject(osession_dbfi), osession_dbfi:disconnect(), nil )
  obox:destroy()
  drgMsgBox(drgNLS:msg('synchronizace byla dokonèena'), XBPMB_INFORMATION)

return( nil)


// // Aktualizace DB MySQL pro web - prodej
function DIST000124( oxbp ) // oxbp = drgDialog
  local m_oDBro, m_File
  local filtr,key
  local cx
  local nhandle, cbuffer
  local file, in_Dir
  local j, n := 0
  local line, aline
  local afiles := {}
  local cDBafir, cUSRafir, cPASWafir, cDBmat
  local cConnect
  local oSession_dbfi
  local lExc := Set(_SET_EXCLUSIVE), lReadOnly := .f.
  local obox

  local  lok, xx
  local  recFlt
  local  cFiltr
  local  rok

  LOCAL aStruct
  LOCAL i, pos
  LOCAL oMySQL
  LOCAL oADS
  local cTable, cTableName
  local cTargetName := ''
  local aTABLE := {'firmy','cenzboz','cenprodc','procenhd','procenit','procenho' }

  m_oDBro   := oxbp:parent:odBrowse[1]
  m_File    := lower(m_oDBro:cFile)
  arSelect  := aclone(m_oDBro:arSelect)

  cConnect := "DBE=ODBCDBE"
  cConnect += ";DRIVER=MySQL ODBC 8.0 ANSI Driver"
//      cConnect += ";DRIVER=MySQL ODBC 8.0 Unicode Driver"
  cConnect += ";SERVER=localhost"
  cConnect += ";UID=asystem"
  cConnect += ";PWD=asys-249AGR"
  cConnect += ";DATABASE=asystemeshop"
//      cConnect += ";WSID=WorkStationID"
//      cConnect += ";Trusted_Connection=Yes"

  oMySQL := dacSession():New(cConnect)

  if (!oMySQL:isConnected())
    QUIT
  endif

  for j := 1 to len( aTABLE)
    ctable     := aTABLE[j]
    ctableName := aTABLE[j]

    drgDBMS:open(ctable,,,,,'srctbl')

  //  USE (cTable) ALIAS srctbl SHARED VIA (oADS)
    aStruct := srctbl-> (DbStruct())

    cTargetName := cTableName

    cTargetName := MakeSqlTableName(cTargetName)
    aStruct := MakeSqlStruct(aStruct, oMySQL)

    DbCreate(cTargetName, aStruct, oMySQL)
    USE (cTargetName) SHARED VIA (oMySQL) ALIAS OUTTAB NEW
    DO WHILE !srctbl->(eof())
       outtab->(DbAppend())
       FOR i:= 1 TO outtab->(Fcount())
         if srctbl->( FieldName(i)) <> 'SID'
           xx := outtab->( FieldName(i))
           outtab->(FieldPut(i, srctbl->(FieldGet(i))))
         else
           outtab->sid:= StrZero( srctbl->sid,10)
         endif
       NEXT
       srctbl->(dbSkip())
    ENDDO

    outtab->(DbCommit())
    CLOSE srctbl
    CLOSE outtab
  next

  oMySQL:disconnect()
  oADS:disconnect()


  if Empty(arSelect)
    drgMsgBox(drgNLS:msg('Nejsou vybrány žádné objednávky k synchronizaci !!!'))
    return nil
  endif

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_e' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_e' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_e' )
  drgDBMS:open( 'procenit',,,,, 'procenit_e' )
  drgDBMS:open( 'procenho',,,,, 'procenho_e' )

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
//  cDBasys         := '77.95.194.215'
//  cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
//  cUSRasys        := ";UID=UsrPodpora;PWD=BarUhvezdY;"
//  cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRasys

// Agrikol
  cDBmat          := AllTrim( odata_datKom:SynNameDBfi)
  cDBmat          := Substr( cDBmat, 1, At('.',cDBmat)-1)
  cDBafir         := AllTrim(odata_datKom:SynAdresDBfi)
  cDBafir         := "\\"+ cDBafir + AllTrim( retDir( odata_datKom:SynPathDBfi)) + AllTrim(odata_datKom:SynNameDBfi)
  cPASWafir       := AllTrim(odata_datKom:SynPasswDBfi)
  cPASWafir       := if( cPASWafir = "*" .and. Len( cPASWafir) = 1, '', cPASWafir)
  cUSRafir        := ";UID=" + AllTrim(odata_datKom:SynUserDBfi) + ";PWD=" + cPASWafir + ";"
  cConnect        := "DBE=ADSDBE;SERVER=" +cDBafir +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET" +cUSRafir

***

  osession_dbfi  := dacSession():New( cConnect)
  if .not. ( osession_dbfi:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na firemní databázi >>' + AllTrim(odata_datKom:SynNameDBfi)+ '<<   !!!'))
    return nil
  endif

  obox := sys_moment( 'probíhá pøenos dat')

  drgDBMS:open( 'cenzboz',,,,,  'cenzboz_a' )
  drgDBMS:open( 'cenprodc',,,,, 'cenprodc_a' )
  drgDBMS:open( 'procenhd',,,,, 'procenhd_a' )
  drgDBMS:open( 'procenit',,,,, 'procenit_a' )
  drgDBMS:open( 'procenho',,,,, 'procenho_a' )

  DBUseArea(.T., osession_dbfi, 'cenzboz',  'cenzboz_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'cenprodc', 'cenprodc_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenhd', 'procenhd_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenit', 'procenit_m' ,!lExc, lReadOnly)
  DBUseArea(.T., osession_dbfi, 'procenho', 'procenho_m' ,!lExc, lReadOnly)

  osession_dbfi:beginTransaction()

  BEGIN SEQUENCE

//  doèasnì pro verzi 1.07.03 jinak vymazat nulování stávajících pøenosù

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenhd_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenhd_a->(Eof())
      if( procenhd_a->( dbRlock()), (procenhd_a ->( dbDelete()), procenhd_a ->(dbUnlock())), nil)
      procenhd_a ->(dbSkip())
    enddo
    procenhd_a->( ads_ClearAof())

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenit_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenit_a->(Eof())
      if( procenit_a->( dbRlock()), (procenit_a ->( dbDelete()), procenit_a ->(dbUnlock())), nil)
      procenit_a ->(dbSkip())
    enddo
    procenit_a->( ads_ClearAof())

    filtr     := format( "cDBID_imp = '%%'", { ''})
    procenho_a->( ads_setAof(filtr),dbgoTop())
    do while .not. procenho_a->(Eof())
      if( procenho_a->( dbRlock()), (procenho_a ->( dbDelete()), procenho_a ->(dbUnlock())), nil)
      procenho_a ->(dbSkip())
    enddo
    procenho_a->( ads_ClearAof())


///  vlastní synchronizace
    do while .not. procenhd_m->(Eof())
      if procenhd_a->( dbSeek( procenhd_m->cDBID_imp,,'DBID_imp'))
        if procenhd_a->( dbRlock())
          mh_COPYFLD('procenhd_m','procenhd_a', .f., .t.)
          procenhd_a->cDBID_imp := cDBmat +StrZero(isNull( procenhd_m->sID, 0),10)
          procenhd_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenhd_m','procenhd_a', .t., .t.)
          procenhd_a->cDBID_imp := cDBmat +StrZero(isNull( procenhd_m->sID, 0),10)
      endif
      procenhd_m ->(dbSkip())
    enddo

    do while .not. procenit_m->(Eof())
      if procenit_a->( dbSeek( procenit_m->cDBID_imp,,'DBID_imp'))
        if procenit_a->( dbRlock())
          mh_COPYFLD('procenit_m','procenit_a', .f., .t.)
          procenit_a->cDBID_imp := cDBmat +StrZero(isNull( procenit_m->sID, 0),10)
          procenit_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenit_m','procenit_a', .t., .t.)
          procenit_a->cDBID_imp := cDBmat +StrZero(isNull( procenit_m->sID, 0),10)
      endif
      procenit_m ->(dbSkip())
    enddo

    do while .not. procenho_m->(Eof())
      if procenho_a->( dbSeek( procenho_m->cDBID_imp,,'DBID_imp'))
        if procenho_a->( dbRlock())
          mh_COPYFLD('procenho_m','procenho_a', .f., .t.)
          procenho_a->cDBID_imp := cDBmat +StrZero(isNull( procenho_m->sID, 0),10)
          procenho_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('procenho_m','procenho_a', .t., .t.)
          procenho_a->cDBID_imp := cDBmat +StrZero(isNull( procenho_m->sID, 0),10)
      endif
      procenho_m ->(dbSkip())
    enddo

    cenzboz_m->( dbGoTop())
    do while .not. cenzboz_m->(Eof())
      if cenzboz_a->( dbSeek( Upper( cenzboz_m->ccissklad)+ Upper(cenzboz_m->csklpol),,'CENIK12'))
        if cenzboz_a->( dbRLock())
          mh_COPYFLD('cenzboz_m','cenzboz_a', .f., .t.)
          cenzboz_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenzboz_m','cenzboz_a', .t., .t.)
        cenzboz_a->( dbUnLock())
      endif
      cenzboz_m->( dbSkip())
    enddo

    cenprodc_m->( dbGoTop())
    do while .not. cenprodc_m->(Eof())
      if cenprodc_a->( dbSeek( Upper( cenprodc_m->ccissklad)+ Upper(cenprodc_m->csklpol),,'CENPROD1'))
        if cenprodc_a->( dbRLock())
          mh_COPYFLD('cenprodc_m','cenprodc_a', .f., .t.)
          cenprodc_a->( dbUnLock())
        endif
      else
        mh_COPYFLD('cenprodc_m','cenprodc_a', .t., .t.)
        cenprodc_a->( dbUnLock())
      endif
      cenprodc_m->( dbSkip())
    enddo

    osession_dbfi:commitTransaction()

  RECOVER USING oError
    osession_dbfi:rollbackTransaction()

  END SEQUENCE

  if( isObject(osession_dbfi), osession_dbfi:disconnect(), nil )
  obox:destroy()
  drgMsgBox(drgNLS:msg('synchronizace byla dokonèena'), XBPMB_INFORMATION)

return( nil)