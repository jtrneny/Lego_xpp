//////////////////////////////////////////////////////////////////////
//
//  ZVI.CH
//
//////////////////////////////////////////////////////////////////////

#include "ASystem++.ch"

**  ZÁKLADNÍ STÁDO
* Typy pohybu u
# Define   VSTUPNI          1
# Define   BEZNY            2
# Define   VYSTUPNI         3

**  ZÁSOBY
* Typ zmìny
# Define   zm_ZAKLADNI         1     // zmìna základní
# Define   zm_ZAKLADNI_VZRUST  2     // vzrùstový pøírùstek k základní zmìnì
# Define   zm_PREVOD_PRIJEM    3     // pøíjmový pohyb pøi pøevodu
# Define   zm_PREVOD_VZRUST    4     // vzrùstový pøírùstek pro pøíjmový pohyb pøi pøevodu