/*==============================================================================
* Zvíøata - Základní stádo - HIM
==============================================================================*/

********************************************************************************
* ZVI_MAJ_SCR ...
********************************************************************************
CLASS ZVI_MAJ_SCR FROM HIM_MAJ_SCR

EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_MAJ_SCR:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_SUMMAJ_SCR ... Stavy za období
********************************************************************************
CLASS ZVI_SUMMAJ_SCR FROM HIM_SUMMAJ_SCR
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_SUMMAJ_SCR:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_MAJOBD_SCR ... Karty zvíøat v obdobích
********************************************************************************
CLASS ZVI_MAJOBD_SCR FROM HIM_MAJOBD_SCR
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_MAJOBD_SCR:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_POHYBY_SCR ... Pohybové doklady ... dle dokladù
********************************************************************************
CLASS ZVI_POHYBY_SCR FROM HIM_POHYBY_SCR

EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_POHYBY_SCR:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_POHYBY_CRD ... Tvorba pohybových dokladù
********************************************************************************
CLASS ZVI_POHYBY_crd FROM HIM_POHYBY_crd
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_POHYBY_crd:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_LikvDOK_SCR ... Likvidace dle dokladù
********************************************************************************
CLASS ZVI_LikvDOK_scr FROM HIM_LikvDOK_scr
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_LikvDOK_scr:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_LikvMAJ_SCR ... Likvidace dle majetku
********************************************************************************
CLASS ZVI_LikvMAJ_scr FROM HIM_LikvMAJ_scr
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_LikvMAJ_scr:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_LikvUCT_SCR ... Likvidace dle úèetních pøedpisù
********************************************************************************
CLASS ZVI_LikvUCT_scr FROM HIM_LikvUCT_scr
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_LikvUCT_scr:init( parent, 'ZVI' )
  RETURN self
ENDCLASS

********************************************************************************
* ZVI_Zaverka_GEN ... Roèní úèetní a daòová závìrka
********************************************************************************
CLASS ZVI_Zaverka_GEN FROM HIM_Zaverka_GEN
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_Zaverka_GEN:init( parent, 'ZVI' )
  RETURN self
ENDCLASS