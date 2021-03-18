//////////////////////////////////////////////////////////////////////
//
//  drgMemManager.PRG
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgDataManager class manages variables inside single thread.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"

* Class declaration
***********************************************************************
CLASS drgDataManager
EXPORTED:

  VAR     drgDialog
  VAR     prevManager
  VAR     vars, ain_files

  METHOD  init
  METHOD  destroy

  METHOD  has
  METHOD  add
  METHOD  set
  METHOD  get
  METHOD  save
  METHOD  refresh, refreshAndSetEmpty
  METHOD  markChanged                 // mark specified vars as changed
  METHOD  changed
  METHOD  reSort

*  HIDDEN:

ENDCLASS

**********************************************************************
* Initialize this class set pointer to prevManager if it exists.
**********************************************************************
METHOD drgDataManager:init(oDrgDialog, oPreviousMM)
  ::drgDialog   := oDrgDialog
  ::prevManager := oPreviousMM
  ::vars        := drgArray():new(100)
  ::ain_files   := {}
RETURN self

**********************************************************************
* Add new variable to this memory manager
**********************************************************************
METHOD drgDataManager:add(cFile, cName, lRonly)
LOCAL aVar, al, oPrev := NIL
*  drgDump(cFile, cName)

* ADD cFile to cName
  IF !EMPTY(cFile) .AND. AT('->', cName) = 0
    cName := cFile + '->' + cName
  ENDIF

* This is dummies check realy
  IF AT('->', cName) = 0
    cFile := ''
  ELSE
    cFile := drgParse(cName,'-')
    cName := drgParseSecond(cName,'>')
  ENDIF

* Check if field is member of current active database cFile
  IF EMPTY(cFile)
    al := ALIAS()
    IF !EMPTY(al)
      IF FIELDPOS(cName) > 0
        cName := al + '->' + cName
      ENDIF
    ENDIF
  ELSE
    cName := cFile + '->' + cName
  ENDIF

* check if variable is already defined in this manager
  IF (aVar := ::has(cName) ) != NIL
**    RETURN aVar
  ELSE
* check if variable is already defined in previous manager
    IF ::prevManager != NIL
      oPrev := ::prevManager:has(cName)
    ENDIF
  ENDIF

* create new variable
  IF oPrev = NIL
    aVar := drgVAR():new(::drgDialog)
    aVar:create(cName, lRonly)
* Variable defined on previous dialog
  ELSE
    aVar := drgVAR():new(::drgDialog)
    aVar:create(oPrev, lRonly)
  ENDIF
* add to internal array
*  drgDump(aVar:name)
  ::vars:add(aVar, aVar:name)
*  drgDump(aVar:value, aVar:name)
RETURN aVar

**********************************************************************
* Checks if variable is a member of this menager.
*
* \bParameters:b\
* \b< cName >b\  : String :  cName of the variable
*
* \bReturns:b\  : object of drgVar  : returns object associated with this cName or NIL if not found.
**********************************************************************
METHOD drgDataManager:has(cName)
RETURN ::vars:getByKey(cName)

**********************************************************************
* Returns value or drgVar object of requested variable.
*
* \bParameters:b\
* \b<cName>b\   : String  :  cName of the variable
* \b<lValue>b\  : Logical :  When set to true method will return value. \
* If parameter is false than object of drgVar containing value is returned.
*
* \bReturns:b\  :  xValue or oDrgVar : Value or object containing requested var.
**********************************************************************
METHOD drgDataManager:get(cName, lValue)
LOCAL oVar
  DEFAULT lValue TO .T.
  cName := ALLTRIM(cName)
* ADD M-> if qualifier is not specified. All variable names must be qualified.
  cName := IIF(AT('-',cName) = 0,'M->' + cName, cName)
* Search for var
  IF (oVar := ::has(cName)) != NIL
    RETURN IIF(lValue, oVar:get(), oVar)
  ELSE
* POST ERROR ??
  ENDIF
RETURN NIL

**********************************************************************
* Sets value of a specified variable.
*
* \bParameters:b\
* \b< cName >b\   : String :  cName of the variable
* \b< xValue >b\  : any    :  new value to be set
*
* \bReturns:b\    :  Logical : lSet. True if value could be set.
**********************************************************************
METHOD drgDataManager:set(cName, xValue)
LOCAL oVar
* ADD M-> if qualifier is not specified. All variable names are qualified.
  IF ( oVar := ::get(cName, .F.) ) != NIL
    oVar:set(xValue)
    RETURN .T.
  ENDIF
* POST ERROR
RETURN .F.

**********************************************************************
* Initialize this class set pointer to prevManager if it exist.
**********************************************************************
METHOD drgDataManager:reSort()
  ::vars:reSort()
RETURN

**********************************************************************
* Saves (stores) all variable values to memory or cFile. Called when dialog is ended.
*
* \bReturns:b\  : boolean : True if save was succesfull.
**********************************************************************
METHOD drgDataManager:save()
LOCAL x
  FOR x := 1 TO ::vars:size()
    ::vars:getNth(x):save()
  NEXT
RETURN .T.


*
** po INS nastaví prázdné hodnoty pro vstup uživatele
method drgDataManager:refreshAndSetEmpty( cfile )
  local  x, ovar, lok, value, type, xvalue
  local  in_file
  *
  local  nfirst_Ok := 0

  default cfile to ''

  for x := 1 to ::vars:size() step 1
    lok  := .t.
    ovar := ::vars:getNth(x)

    if valtype( ovar:block ) = 'B'
      in_file    := lower( left( ovar:name, at( '-', ovar:name)  -1))
      in_file    := if( lower( left( ovar:name, 3)) = 'm->', 'm->', in_file )

      if .not. empty(cfile)
        lOk := (in_file $ lower( cfile ))
        *
        ** m-> tam musíme zahrnout
        if ( .not. lok .and. nfirst_ok <> 0 .and. in_file = 'm->')
          lok   := .t.
          cfile += ',m'
        endif
      endif

      if lok
        nfirst_ok := x
        value     := ovar:value
        type      := valType( value )

        xvalue := if( type = 'C' .or. type = 'M', space( len( ovar:value)), ;
                   if( type = 'D', ctod('')                               , ;
                    if( type = 'L', .f.                                   , ;
                     if( type = 'N', 0, nil                                 ))))

        if type = 'N'
           if (npos := at('.', value := str( value ))) <> 0
             xValue := val( '0.' +replicate( '0', len(value) - npos))
           endif
        endif

        // JS 9.5.2011 - u m-> je možné pro INS pøednastavit/ pøevzít hodnotu
**        if in_file = 'm' .and. isBlock( ovar:block ) .and. lset_mValue
**          xvalue := eval( ovar:block )
**        endif

        ovar:prevValue := ovar:initValue := ovar:value := xvalue

        if ovar:oDrg != NIL
          ovar:oDrg:refresh( xValue )

          if ovar:oDrg:className() = 'drgGet'
            if isArray( ovar:oDrg:arRelate )
* ERR
              cfile += ',' +lower( ovar:oDrg:arRelate[1,4] )
            endif
          endif
        endif
      endif
    endif
  next
return .t.



**********************************************************************
*  Refreshes all variable values with new values.
*
* \bParameters:b\
* \b< lOnlyROnly >b\  : Logical : True if only readonly fields are to be refreshed
* \b< lOnlyROnly >b\  : character : Single field name can also be specified
*
* \bReturns:b\  : self : Self
**********************************************************************
METHOD drgDataManager:refresh(lOnlyROnly, lresetValidation)
  LOCAL x, oVar

  DEFAULT lOnlyROnly       TO .F. , ;
          lresetValidation to .f.

* First refresh data field if specified
  IF VALTYPE(lOnlyROnly) = 'C'
    RETURN ::get(lOnlyROnly, .F.):refresh()
  ENDIF

  for x := 1 to ::vars:size() step 1
    ::drgdialog:oform:olastDrg
    ovar := ::vars:getNth(x)

    if lonlyROnly
      if ::drgdialog:oform:olastDrg:ovar <> ovar
        ovar:refresh()
      endif
    else
      ovar:refresh()
    endif

    if lresetValidation
      if( ovar:odrg:isDerivedFrom( 'drgObject' ), ovar:odrg:postValidOK := nil, nil )
    endif
  next
RETURN .T.

**********************************************************************
* Mark variables which cName is started by aName parameter as changed. \
* This is neccesary when append with copy is performed and fields must be \
* marked as changed, if they are to be saved with the ::save method.
*
* \bParameters:b\
* \b[aName]b\       : String : Only fields which cName begins with aName are to be \
* marked as changed. Deafult value is '' so all vars will be marked as changed. \
* Empty string should be used with caution.
*
* \bReturns:b\  : self
**********************************************************************
METHOD drgDataManager:markChanged(cName)
LOCAL x, nLen, oVar
  DEFAULT cName TO ''
*  cName := ALLTRIM( UPPER(cName) )
  cName := ALLTRIM(cName)
  nLen  := LEN(cName)
* For all members of dataManager
  FOR x := 1 TO ::vars:size()
    oVar := ::vars:getNth(x)
    IF LEFT(oVar:name, nLen) == cName
      oVar:initValue := NIL                    // set init value to NIL
    ENDIF
  NEXT
RETURN .T.

**********************************************************************
* Checks if any of variables containing in this object is changed
*
* \bReturns:b\  : boolean : True if any variable is changed.
**********************************************************************
METHOD drgDataManager:changed()
LOCAL x
  FOR x := 1 TO ::vars:size()
    IF ::vars:getNth(x):changed()
      RETURN .T.
    ENDIF
  NEXT
RETURN .F.

**********************************************************************
* Clean UP
**********************************************************************
METHOD drgDataManager:destroy()
  ::vars:destroy()
  ::vars        := ;
  ::drgDialog   := ;
  ::ain_files   := ;
  ::prevManager := NIL

RETURN self

// drgVar class
//
**************************************************************************
* The purpose of drgVar class is to hold all variables which are used in \
* forms belonging to current dialog thread.
**************************************************************************
CLASS drgVAR
HIDDEN:

EXPORTED:
  VAR     drgDialog
  VAR     name                        // cName of the variable
  VAR     rOnly                       // Is this variable read only
  VAR     initValue                   // initial value of the variable
  VAR     prevValue
  VAR     block                       // get set block for this variable
  VAR     oDrg                        // oDrg object showing value of this var
  VAR     ref                         // reference description for this field if exists
  VAR     value                       // current value of the variable

  METHOD  init                        // initialization
  METHOD  create                      // create variable
  METHOD  get                         // get value
  METHOD  set                         // set value
  METHOD  getSet                      // get/set method for accesing value
  METHOD  refresh                     // refreshes value, evaluetes initial codeblock
  METHOD  save                        // save value of variable to memory or cFile
  METHOD  recall                      // recalls initial value
  METHOD  changed                     // checks if changed
  method  itemChanged
  METHOD  destroy                     // clean behind

  inline method inBrow
  return (SetAppFocus():className() = 'XbpBrowse')
ENDCLASS


METHOD drgVAR:init(drgDialog)
  ::drgDialog := drgDialog
RETURN self

**************************************************************************
* Initialization of drgVAR
*
* \bParameters:b\
* < cName >    : string  : cName of the variable. cFile->cName if variable is a \
*                         field from cFile.
**************************************************************************
METHOD drgVAR:create(cName, rOnly)
  local  ain_files := ::drgDialog:dataManager:ain_files, in_file

  DEFAULT rOnly TO .F.

  ::rOnly := rOnly
  ::ref   := NIL

  * Already defined in previous dataManager
  IF ValType(cName) = 'O'
    ::name  := cName:name
    ::block := { |aVal| cName:getSet(aVal) }
  ELSE
    if .not. ::ronly
      in_file := lower(drgParse(cname,'-'))
      if( ascan(ain_files, {|x| x = in_file}) = 0, aadd(ain_files,in_file), nil)
    endif

    ::name  := cName
    ::block := ::drgDialog:getVarBlock(cName, self)
  ENDIF

  * Set initial value
  IF ::block != NIL
    ::initValue := EVAL(::block)
  ENDIF
  ::prevValue := ::value := ::initValue
RETURN self

**************************************************************************
* Default getSet method for accesing this variable value. If parameter value \
* is passed than variable changes its value otherwise current value of variable \
* is returned.
**************************************************************************
METHOD drgVAR:getSet(value)
  IF value = NIL
    RETURN ::get()
  ENDIF
RETURN ::set(value)

**************************************************************************
* Returns current value of variable.
**************************************************************************
METHOD drgVAR:get()
  IF ::rOnly .AND. ::block != NIL
    if ::inBrow()
      ::initValue := ::value := EVAL(::block)
    endif
  ENDIF
RETURN ::value

**************************************************************************
* Refreshes internal variable value. Call original codeblock and updates internal \
* value of variable.
**************************************************************************
METHOD drgVAR:refresh()
  local  ain_files := ::drgDialog:dataManager:ain_files, in_file
  local  value

  IF ::block != NIL
    value := EVAL(::block)

    if ::inBrow()
      ::prevValue := ::initValue := ::value := value
    else
      if ::rOnly
        in_file := lower(drgParse(::name,'-'))
** ERR
        if ascan(ain_files, {|x| x = in_file}) = 0
           ::prevValue := ::initValue := ::value := value
        endif
      else
        if Empty(::initValue) .and. .not. Empty(::value)
**          ::initValue := ::value
        endif

        if ((::value <> ::prevValue) .or. (::value <> ::initValue))
          ::prevValue := ::value
        endif
      endif
    endif
  ENDIF

  IF( ::oDrg != NIL, ::oDrg:refresh(::value), Nil)

RETURN


**************************************************************************
* Sets new value to this memory variable. If memory variable is displayed on \
* a dialog its dialog presentation is also updated.
*
**************************************************************************
METHOD drgVAR:set(value)
  IF !( value == ::value)
    ::value := value
    IF ::oDrg != NIL
      ::oDrg:refresh(::value)
    ENDIF
  ENDIF
RETURN ::value

**************************************************************************
* Executes default variable code block and thus saves its new value to cFile or \
* updates its value in memory.
**************************************************************************
METHOD drgVAR:save()
*  drgDump(::Initvalue,::name)
*  drgDump(::value,::name)

  IF !( ::value == ::initValue)
    IF !(::block = NIL .OR. ::rOnly)
      EVAL(::block, ::value)
    ENDIF
    ::initValue := ::value
  ENDIF
RETURN self

**************************************************************************
* Recalls initial value of the object.
**************************************************************************
METHOD drgVAR:recall()
  ::value := ::initValue
  IF ::oDrg != NIL
    ::oDrg:refresh(::value)
  ENDIF
RETURN self

**************************************************************************
* Returns true if value of variable has changed.
**************************************************************************
METHOD drgVAR:changed()
  local changed := .f.

  if valType(::value) = 'N'
    changed := !(round(::value,10) == round(::initValue,10)) .or. ;
               !(round(::value,10) == round(::prevValue,10))
  else
    changed := !(::value == ::initValue) .or. !(::value == ::prevValue)
  endif
return changed
// ** return !( ::value == ::initValue) .or. !(::value == ::prevValue)

method drgVAR:itemChanged()
  local changed := .f.

  if valType(::value) = 'N'
    changed := !(round(::value,12) == round(::prevValue,12))
  else
    changed := !(::value == ::prevValue)
  endif
return changed
// ** return !(::value == ::prevValue)

**************************************************************************
* Clean up.
**************************************************************************
METHOD drgVAR:destroy()
  ::drgDialog := ;
  ::name      := ;
  ::rOnly     := ;
  ::initValue := ;
  ::value     := ;
  ::block     := ;
  ::oDrg      := ;
  ::ref       := ;
                 NIL
RETURN