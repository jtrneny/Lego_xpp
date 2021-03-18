//////////////////////////////////////////////////////////////////////
//
//  MEMVAR.CH
//
//  Copyright:
//       Alaska Software, (c) 1998-2009. All rights reserved.         
//  
//  Contents:
//       #command directives for memory variables (PRIVATE and PUBLIC)
//       #define constants for isMemvar() and isFunction()
//   
//  Remarks:
//       Functions starting with an underscore are reserved.
//       They may be version dependent and should not be called directly!
//   
//////////////////////////////////////////////////////////////////////

// Memvar.ch is not included
#ifndef  _MEMVAR_CH      
#ifdef __XPP__

#command  CLEAR MEMORY ;
      =>  _symClear()

#command  RELEASE <vars,...> ;
      =>  _symRelease( .T. , <"vars"> )

#command  RELEASE EXCEPT <#mask> ;
      =>  _symRelease( .F. , <"mask"> )

#command  RELEASE ALL ;
      =>  _symNilPrivates( .T. , "*")

#command  RELEASE ALL LIKE <#mask> ;
      =>  _symNilPrivates( .T. , <"mask">)

#command  RELEASE ALL EXCEPT <#mask> ;
      =>  _symNilPrivates( .F. , <"mask">)

#command  RESTORE [FROM <(file)>] [<add: ADDITIVE>] ;
      =>  _symLoad( <(file)>, <.add.> )

#command  SAVE ALL LIKE <#mask> TO <(file)> ;
      =>  _symSave( <(file)>, .T., <"mask"> )

#command  SAVE TO <(file)> ALL LIKE <#mask> ;
      =>  _symSave( <(file)>, .T., <(mask)> )

#command  SAVE ALL EXCEPT <#mask> TO <(file)> ;
      =>  _symSave( <(file)>, .F., <(mask)> )

#command  SAVE TO <(file)> ALL EXCEPT <#mask> ;
      =>  _symSave( <(file)>, .F., <(mask)> )

#command  SAVE TO <(file)> [ALL] ;
      =>  _symSave( <(file)>, .T., "*" )

#endif    // #ifdef __XPP__



// constants for isMemvar() and SymbolInfo() 
#define MEMVAR_PUBLIC     1
#define MEMVAR_PRIVATE    2

// constants for isFunction() and SymbolInfo() 
#define SYMBOL_FUNCTION        0x46
#define SYMBOL_CLASSFUNC       0x43
#define SYMBOL_BUILTIN_FUNCTION  SYMBOL_FUNCTION  + 0x1000
#define SYMBOL_BUILTIN_CLASSFUNC SYMBOL_CLASSFUNC + 0x1000

// old define
#define FUNC_CLASS             SYMBOL_CLASSFUNC  

// Memvar.ch is included
#define  _MEMVAR_CH       

#endif  // #ifndef _MEMVAR_CH

// * EOF *
