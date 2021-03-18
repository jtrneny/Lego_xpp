//////////////////////////////////////////////////////////////////////
//
//  VYROBA.CH
//
//////////////////////////////////////////////////////////////////////

#include "ASystem++.ch"

*
# DEFINE   EMPTY_ZAKAZ       SPACE(30)
# DEFINE   EMPTY_VYRPOL      SPACE(15)

* pro ukl�d�n� do ( zobrazov�n� z ) POLOPER
# DEFINE   to_MIN   1   // P�evod na MINUTY ( v souboru jsou v�dy ulo�eny minuty)
# DEFINE   to_CFG   2   // P�evod na MJ nastavenou v CFG

* Typ kontroln�ho rozpadu
# Define   ROZPAD_NENI        0     // Bez rozpadu
# Define   ROZPAD_KONS        1     // Konstruk�n� rozpad
# Define   ROZPAD_TECH        2     // Technologick� rozpad
  ** rozpady p�i zapou�t�n� zak�zky
# Define   ROZPAD_DILCI       3     // D�l�� rozpad v RV
# Define   ROZPAD_POPOL       4     // Rozpad po Vyr. polo�k�ch - St�i�n� pl�ny
# Define   ROZPAD_POSKU       5     // Rozpad pro slu�ov�n� do skupin (= pracovi�� )� STS Prun��ov
# Define   ROZPAD_DILPR       6     // Rozpad dle d�len a pracovi��

* Zp�soby zapu�t�n� zak�zky
# Define   zpuZAP_MAT         1     // Pouze materi�l
# Define   zpuZAP_LIS         2     // Pouze mzdov� l�stky
# Define   zpuZAP_MATLIS      3     // Materi�l i mzdov� l�stky

* Typy zapu�t�n� zak�zky
# Define   typZAP_KOMPL       1     // Kompletn�
# Define   typZAP_DILCI       2     // D�l��
# Define   typZAP_POPOL       3     // Po polo�k�ch
# Define   typZAP_POSKU       4     // Po skupin�ch
# Define   typZAP_DILPR       5     // Dle d�len a pracovi��

* Kalkulace
# Define   MATERIAL_TPV       1     // Kalkulace materi�lu  - dle MJ v Tpv
# Define   MATERIAL_SKL       2     // Kalkulace materi�lu  - dle MJ ve skladu
# Define   MZDY_POLOZKY       3     // Kalkulace mezd - dle vyr�b�n�ch polo�ek
# Define   MZDY_PRACOV        4     // Kalkulace mezd - dle pracovi��
# Define   MZDY_OPERACE       5     // Kalkulace mezd - dle operac�
# Define   KALKUL_PLAN        6     // Pl�nov� kalkulace
# Define   KALKUL_VYSL        7     // V�sledn� kalkulace

* Zp�sob rozbalen� strukt. kusovn�ku
# Define   Tree_FULL          0     // rozbal� pln� kusovn�k
# Define   Tree_FIRST         1     // rozbal� prvn� v�robn� stupe�

* Hodnoty cfg. parametru Vyroba:nOperML
# DEFINE   OPERML_STD      1       // Standartni
# DEFINE   OPERML_MOPAS    2       // Varianta pro MOPAS
