//////////////////////////////////////////////////////////////////////
//
//  Him.CH
//
//////////////////////////////////////////////////////////////////////

#include "ASystem++.ch"

* Stav majetku
# Define   AKTIVNI          0
# Define   NEAKTIVNI        1
# Define   ODEPSAN          2
# Define   UCETNE_ODEPSAN   2
# Define   VYRAZEN          9

* Typy daòového odpisu
# Define DO_ROVNOMERNY      1
# Define DO_ZRYCHLENY       2

* Typy úèetního odpisu
# Define UO_ROVNOMERNY      1
# Define UO_ROVENDANOVEMU   3

* Typy výpoètu úèetního odpisu
# Define UO_VYPOCET_PLNY      1
# Define UO_VYPOCET_ZKRACENY  2

* Typy pohybu
# Define   VSTUPNI          1
# Define   BEZNY            2
# Define   VYSTUPNI         3

* Specifické druhy pohybu
* HIM
# Define   UCETNI_ODPIS_HIM         '99'
# Define   DOUCTOVANI_ODPISU_HIM    '97'
* ZVI - základní stádo
# Define   UCETNI_ODPIS_ZS         '199'
# Define   DOUCTOVANI_ODPISU_ZS    '197'

*
# Define CRD_201_202    { ::fiZMAJUw + '->cTypPohybu' ,;
                          ::fiZMAJUw + '->nDoklad'    ,;
                          ::fiZMAJUw + '->dDatZmeny'  ,;
                          ::fiZMAJUw + '->nZmenVstCU' ,;
                          ::fiZMAJUw + '->nZmenVstCD'  }

# Define CRD_203    { ::fiZMAJUw + '->cTypPohybu' ,;
                      ::fiZMAJUw + '->nDoklad'    ,;
                      ::fiZMAJUw + '->dDatZmeny'  ,;
                      ::fiZMAJUw + '->nZmenVstCU' ,;
                      ::fiZMAJUw + '->nZmenVstCD' ,;
                      ::fiZMAJUw + '->nZmenOprU'  ,;
                      ::fiZMAJUw + '->nZmenOprD'   }

# Define CRD_204    { ::fiZMAJUw + '->cTypPohybu'  ,;
                      ::fiZMAJUw + '->nDoklad'   ,;
                      ::fiZMAJUw + '->dDatZmeny'  }

# Define CRD_301    { ::fiZMAJUw + '->cTypPohybu'  ,;
                      ::fiZMAJUw + '->nDoklad'   ,;
                      ::fiZMAJUw + '->dDatZmeny' ,;
                      ::fiZMAJUw + '->cVarSym'   }