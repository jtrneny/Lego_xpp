//////////////////////////////////////////////////////////////////////
//
//  drgPrint.CH
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      Transformation for my old print routines
//
//////////////////////////////////////////////////////////////////////

// drgPrint.ch is not included
#ifndef  _DRGPRINT_CH

// Printer text command codes
#define DRG_PRINT_NORMAL      0
#define DRG_PRINT_BOLD        1
#define DRG_PRINT_ITALIC      2
#define DRG_PRINT_ULINE       4

#translate Print(<clauses,...>);
           => oPrint:_print(<clauses>)

#translate PrintLine(<clauses,...>);
           => oPrint:_printLine(<clauses>)

#translate PrintSkip(<clauses,...>);
           => oPrint:_printSkip(<clauses>)

#translate PrintNum(<clauses,...>);
           => oPrint:_printNum(<clauses>)

#translate EndPrinter();
           => oPrint:destroy(); oPrint := NIL; HEAD := NIL

// drgPrint.ch is included
#define  _DRGPRINT_CH

#endif                    // #ifndef _DRGPRINT_CH

