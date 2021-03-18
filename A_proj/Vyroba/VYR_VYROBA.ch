//////////////////////////////////////////////////////////////////////
//
//  VYROBA.CH
//
//////////////////////////////////////////////////////////////////////

#include "ASystem++.ch"

*
# DEFINE   EMPTY_ZAKAZ       SPACE(30)
# DEFINE   EMPTY_VYRPOL      SPACE(15)

* pro ukládání do ( zobrazování z ) POLOPER
# DEFINE   to_MIN   1   // Pøevod na MINUTY ( v souboru jsou vdy uloeny minuty)
# DEFINE   to_CFG   2   // Pøevod na MJ nastavenou v CFG

* Typ kontrolního rozpadu
# Define   ROZPAD_NENI        0     // Bez rozpadu
# Define   ROZPAD_KONS        1     // Konstrukèní rozpad
# Define   ROZPAD_TECH        2     // Technologickı rozpad
  ** rozpady pøi zapouštìní zakázky
# Define   ROZPAD_DILCI       3     // Dílèí rozpad v RV
# Define   ROZPAD_POPOL       4     // Rozpad po Vyr. polokách - Støiné plány
# Define   ROZPAD_POSKU       5     // Rozpad pro sluèování do skupin (= pracoviš )¦ STS Prunéøov
# Define   ROZPAD_DILPR       6     // Rozpad dle dílen a pracoviš

* Zpùsoby zapuštìní zakázky
# Define   zpuZAP_MAT         1     // Pouze materiál
# Define   zpuZAP_LIS         2     // Pouze mzdové lístky
# Define   zpuZAP_MATLIS      3     // Materiál i mzdové lístky

* Typy zapuštìní zakázky
# Define   typZAP_KOMPL       1     // Kompletní
# Define   typZAP_DILCI       2     // Dílèí
# Define   typZAP_POPOL       3     // Po polokách
# Define   typZAP_POSKU       4     // Po skupinách
# Define   typZAP_DILPR       5     // Dle dílen a pracoviš

* Kalkulace
# Define   MATERIAL_TPV       1     // Kalkulace materiálu  - dle MJ v Tpv
# Define   MATERIAL_SKL       2     // Kalkulace materiálu  - dle MJ ve skladu
# Define   MZDY_POLOZKY       3     // Kalkulace mezd - dle vyrábìnıch poloek
# Define   MZDY_PRACOV        4     // Kalkulace mezd - dle pracoviš
# Define   MZDY_OPERACE       5     // Kalkulace mezd - dle operací
# Define   KALKUL_PLAN        6     // Plánové kalkulace
# Define   KALKUL_VYSL        7     // Vısledné kalkulace

* Zpùsob rozbalení strukt. kusovníku
# Define   Tree_FULL          0     // rozbalí plnı kusovník
# Define   Tree_FIRST         1     // rozbalí první vırobní stupeò

* Hodnoty cfg. parametru Vyroba:nOperML
# DEFINE   OPERML_STD      1       // Standartni
# DEFINE   OPERML_MOPAS    2       // Varianta pro MOPAS
