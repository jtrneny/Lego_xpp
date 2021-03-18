//////////////////////////////////////////////////////////////////////
//
//  drgDirSelector.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Parts by:
//   by James W. Loughner, jwrl@worldnet.att.net
//   Placed in public domain 04/29/2000
//
//  Contents:
//       drgDirSelector object is implementation of directory select dialog
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "gra.ch"
#include "Directry.ch"

// #include "drgRes.ch"
// #include "drgApp.ch"

#include "drg.ch"

#define  ICON_DRIVE        100
#define  ICON_CLOSEDFOLDER 101
#define  ICON_OPENFOLDER   102



CLASS drgDirSelector FROM drgUsrClass

PROTECTED:
   VAR aDrives
   VAR oItem    // current item

EXPORTED:
   VAR     diskDrive

   VAR startDir
   VAR dirTree
   VAR driveList
   VAR dirMethod
   VAR FileMethod
   VAR Root
   VAR SepChr
   VAR ShowDrive
   VAR ShowFiles
   VAR First_Time

  METHOD  destroy

  METHOD  getForm
  METHOD  doSelect
  METHOD  treeViewInit
  METHOD  comboItemSelected

  METHOD  fillTree, curDir ,LocalDir,LocalFiles,LoadDir,ParsePath


*HIDDEN:

ENDCLASS

*********************************************************************
* Returns form definition for drgMenu
*********************************************************************
METHOD drgDirSelector:getForm()
LOCAL oFC, oDrg
LOCAL cVals := ''
  oFC := drgFormContainer():new()
  ::aDrives := AvailDrives()
  AEVAL( ::aDrives, {|c| cVals += c+","  } )

  ::diskDrive := CurDrive()
  ::startDir  := CurDrive() + ":\" + CurDir()
  ::ShowDrive := .T.
  ::SepChr    := "\"
  ::ShowFiles := .F.
  ::First_Time := .T.
*
  DRGFORM INTO oFC SIZE 32,20 TITLE 'Directory selector' GUILOOK 'All:N,Border:Y'
  DRGSTATIC INTO oFC STYPE 12 FPOS 0,19 SIZE 32,1 RESIZE 'yx'
  DRGCOMBOBOX diskDrive INTO oFC FPOS 6,0 FLEN 6 VALUES cVALS ;
    FCAPTION 'Drive:' CPOS 0,0 CLEN 6 ITEMSELECTED 'ComboItemSelected'
  DRGPushButton INTO oFC POS 12,0 SIZE 10,1 CAPTION '~Select' EVENT 'doSelect' PRE '0' ;
    ICON1 101 ICON2 201 ATYPE 3
  DRGPushButton INTO oFC POS 22,0 SIZE 10,1 CAPTION 'Cancle' EVENT 140000002 ;
    ICON1 102 ICON2 202 ATYPE 3
  DRGEND INTO oFC
  DRGTREEVIEW INTO oFC FPOS 0,0 SIZE 32,19 TIPTEXT 'Directory tree' HASLINES HASBUTTONS
RETURN oFC

*********************************************************************
* Initialize treeView object containing menus.
*********************************************************************
METHOD drgDirSelector:treeViewInit(drgObj)
  ::dirTree := drgObj:oXbp
  drgObj:oXbp:itemSelected := {|oItem| ::fillTree( oItem ) }
  ::fillTree( ::dirTree:rootItem )
RETURN

/*
 * Rebuild the tree view with data from the selected directory. Each
 * XbpTreeViewItem contains a character string of the directory
 * which is displayed by the item
 */
METHOD drgDirSelector:fillTree( oItem )
LOCAL cDrive,oParent,aDir,cCurDir,aItems,aTemp,oTemp,cTemp,I,K,tt
   IF EMPTY(::Root) .OR. oItem == NIL
      cDrive := ALLTRIM(::dataManager:get('m->diskDrive') ) + ':'
   ELSE
      cDrive := ::Root
   ENDIF
   IF oItem == ::dirTree:rootItem .OR. oItem == NIL
     /*
      * The tree view begins with the drive letter
      */
      IF oItem == NIL     //::dirTree:rootItem
         ::dirTree:rootItem:Expand(.F.)
      ENDIF
      aItems := ::dirTree:rootItem:getChildItems()
      AEval( aItems, {|obj| ::dirTree:rootItem:delItem(obj) } )
      oParent := ::dirTree:rootItem:addItem( cDrive, ICON_DRIVE, ICON_DRIVE, ICON_DRIVE,, cDrive )

      cCurDir := cDrive+::SepChr
      ::Root := cCurDir
      oItem  := oParent
      ::LoadDir(oItem, cCurdir)
      oParent:Expand(.T.)
      SetAppFocus(oParent)
      tt := ::Startdir
      IF ::First_Time
         IF oItem!=NIL .AND.!EMPTY(::Startdir) .AND. ALLTRIM(UPPER(cCurDir)) != ALLTRIM(UPPER(::Startdir))
            oTemp := oItem
            aTemp := ::ParsePath(::Startdir)

            FOR I=1 TO Len(aTemp)
               aItems := oTemp:getChildItems()

               FOR J=1 TO LEN(aItems)
                  IF aTemp[I] = aItems[J]:GetData()
                     oTemp := aItems[J]
                     ::LoadDir(oTemp,aTemp[I])
                     EXIT
                  ENDIF
               NEXT

             NEXT I
         ENDIF
         ::First_Time := .F.
      ENDIF
   ELSE
      cCurDir := oItem:GetData()
      IF EMPTY(cCurDir)
         cCurDir := ::Root
      ENDIF
      ::LoadDir(oItem,cCurdir)
   ENDIF
RETURN self

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:ParsePath(cDir)
LOCAL aRtn :={},nPtr:= 1
   IF Substr(cDir,LEN(cDir),1)!= ::SepChr
      cDir := cDir+::SepChr
   ENDIF
   DO WHILE nPtr>0
      nPtr:=AT(::SepChr,cDir,nPtr)+1
      AADD(aRtn,left(cDir,nPtr-1))
      IF nPtr >= LEN(cDir)
         EXIT
      ENDIF
   ENDDO
RETURN aRtn

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:LoadDir(oItem,cCurDir)
LOCAL oTemp,aDir,Dispbmp
   IF EMPTY(oItem:GetChildItems())
      IF EMPTY(::DirMethod)
         aDir := ::Localdir(cCurDir)
      ELSE
         aDir := Eval(::DirMethod,cCurDir)
      ENDIF
      FOR I:= 1 TO LEN(aDir)
          oTemp := oItem:addItem( aDir[I]   , ;
                                  ICON_CLOSEDFOLDER, ;
                                  ICON_CLOSEDFOLDER, ;
                                  ICON_OPENFOLDER  , ;
                                  NIL              , ;
                                  cCurDir +IF(Substr(cCurDir,LEN(cCurDir),1)=::SepChr,"" ,::SepChr)+ aDir[I] )

      NEXT
      IF ::ShowFiles
         IF EMPTY(::FileMethod)
            aDir := ::LocalFiles(cCurDir)
         ELSE
            aDir := Eval(::FileMethod,cCurDir)
         ENDIF
         FOR I:= 1 TO LEN(aDir)
/*
             DO CASE
                CASE ".BMP"$UPPER(aDir[I])
                   Dispbmp := ICON_BMP
                CASE ".JPG"$UPPER(aDir[I])
                   Dispbmp := ICON_JPG
                CASE ".GIF"$UPPER(aDir[I])
                   Dispbmp := ICON_GIF
                CASE ".HTM"$UPPER(aDir[I])
                   Dispbmp := ICON_HTML

             OTHERWISE
                Dispbmp := ICON_FILE
             ENDCASE
*/
             Dispbmp := ICON_FILE
             oTemp := oItem:addItem( aDir[I]   , ;
                                     Dispbmp, ;
                                     Dispbmp, ;
                                     Dispbmp, ;
                                     NIL              , ;
                                     cCurDir + IF(Substr(cCurDir,LEN(cCurDir),1)=::SepChr,"" ,::SepChr) + aDir[I] )

         NEXT
      ENDIF
      oItem:Expand(.T.)
   ENDIF

RETURN self

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:LocalDir(cDir)
LOCAL aRtn:={},aDir,I,cSep
   IF Substr(cDir,LEN(cDir),1)=::SepChr
     cSep := ""
   ELSE
     cSep := ::SepChr
   ENDIF
   aDir := DIRECTORY(cDir+cSep,"D")
   FOR I = 1 TO LEN(aDir)
      IF "D" $ aDir[I,F_ATTR]        .AND. ;
         .NOT. aDir[I,F_NAME] == "." .AND. ;
         .NOT. aDir[I,F_NAME] == ".."

         AADD(aRtn,ALLTRIM(aDir[I,F_NAME]))
      ENDIF
   NEXT
   aRtn := ASORT(aRtn)
RETURN aRtn

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:LocalFiles(cDir)
LOCAL aRtn:={},aDir,I,cSep
   IF Substr(cDir,LEN(cDir),1)=::SepChr
     cSep := ""
   ELSE
     cSep := ::SepChr
   ENDIF
   aDir := DIRECTORY(cDir+cSep+"*.*")
   FOR I = 1 TO LEN(aDir)
      AADD(aRtn,ALLTRIM(aDir[I,F_NAME]))
   NEXT
   aRtn := ASORT(aRtn)
RETURN aRtn

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:curDir()
RETURN ::oItem:getData()

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:comboItemSelected()
RETURN ::fillTree()

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:doSelect()
  ::drgDialog:cargo := ::dirTree:getData():getData()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self

******************************************************************************
*
******************************************************************************
METHOD drgDirSelector:destroy()
  ::drgUsrClass:destroy()

  ::aDrives   := ;
  ::oItem     := ;
  ::diskDrive := ;
                 NIL
RETURN self


#define DRIVE_NOT_READY  21
******************************************************************************
*
******************************************************************************
FUNCTION AvailDrives()
   LOCAL cDrive := CurDrive()
   LOCAL aDrives:= { cDrive }
   LOCAL cCurdir:= Curdir()
   LOCAL bError := ErrorBlock( {|oErr| DriveError( oErr, aDrives ) } )


   FOR i:=3 TO 26
      BEGIN SEQUENCE
        Curdrive( Chr(64+i) )
        CurDir()
        IF AScan( aDrives, CurDrive() ) == 0
           AAdd( aDrives, Curdrive() )
        ENDIF
      ENDSEQUENCE
   NEXT

   CurDrive( cDrive )
   Curdir(cdrive+":\"+cCurdir)
   ErrorBlock( bError )
RETURN ASort( aDrives )

************************************************************************
* Handle runtime error when a drive is not ready
************************************************************************
STATIC PROCEDURE DriveError( oError, aDrives )
   IF oError:osCode == DRIVE_NOT_READY
      AAdd( aDrives, oError:args[1] )
   ENDIF
   BREAK
RETURN

************************************************************************
* Call drgDirSelector dialog
*************************************************************************
FUNCTION _DirDialog(cCaption, oParent)
LOCAL oDialog, cRet := NIL
  DEFAULT cCaption TO 'Select directory'

  DRGDIALOG FORM 'drgDirSelector' PARENT oParent MODAL EXITSTATE nExit
  IF nExit != drgEVENT_QUIT
    cRet := oDialog:cargo
  ENDIF
  oDialog:destroy()
RETURN cRet

************************************************************************
* Call default file dialog
*************************************************************************
FUNCTION _FileDialog(cCaption, cStart, oParent)
LOCAL oDlg, cName, oFocus
  DEFAULT cStart TO '*.*'
  DEFAULT oParent TO AppDesktop(oParent)
  oFocus := SetAppFocus()

  oDlg := XbpFileDialog():new()
  oDlg:create()
  oDlg:title := drgNLS:msg(cCaption)
*
  cName := oDlg:open(cStart,.T.)
  oDlg:destroy()
  SetAppFocus(oFocus)
RETURN cName
