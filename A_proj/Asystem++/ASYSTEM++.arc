//////////////////////////////////////////////////////////////////////
//
//  ASYSTEM++.ARC
//
//////////////////////////////////////////////////////////////////////

#include "drgRes.ch"
#include "drgRes.arc"
#include "ASystem++.ch"

#define MANIFEST_RESID 1
#define MANIFEST 24

USERDEF MANIFEST
  MANIFEST_RESID = FILE "Asystem++.exe.manifest"

*VERSION
*   "CompanyName"      = "M.I.S.S., spol. s r.o."
*   "FileDescription"  = "Asystem++"
*   "ProductName"      = "Asystem++"
*   "LegalCopyright"   = "Copyright (c) 2005-2009"
*   "OriginalFilename" = "Asystem++.exe"


ICON
      1                     = "C:\LEGO_xpp\A_rsrc\images\Asystem++.ICO"
      MIS_ICON_MODULE       = "C:\LEGO_xpp\A_rsrc\images\xppPMT.ICO"
      MIS_ICON_APPEND       = "C:\LEGO_xpp\A_rsrc\images\gappend.ico"
      MIS_ICON_QUIT         = "C:\LEGO_xpp\A_rsrc\images\gquit.ico"
      MIS_ICON_PAY          = "C:\LEGO_xpp\A_rsrc\images\cPay.ico"
      MIS_ICON_OPENFOLDER   = "C:\LEGO_xpp\A_rsrc\images\cFOpen.ico"
      MIS_ICON_CLOSEDFOLDER = "C:\LEGO_xpp\A_rsrc\images\cFClose.ico"
      MIS_DARGDROP_PUNTERO  = "C:\LEGO_xpp\A_rsrc\images\puntero.ico"
      MIS_LEFT_LIGHTBLUE    = "C:\LEGO_xpp\A_rsrc\images\carleft_lb.ico"
      MIS_RIGHT_LIGHTBLUE   = "C:\LEGO_xpp\A_rsrc\images\carright_lb.ico"

      MIS_SORT_UP   = "C:\LEGO_xpp\A_rsrc\images\arUp.ico"
      MIS_SORT_DOWN = "C:\LEGO_xpp\A_rsrc\images\arDown.ico"

      MIS_ICON_FILTER       = "C:\LEGO_xpp\A_rsrc\images\c_Filter.ICO"
      gMIS_ICON_FILTER      = "C:\LEGO_xpp\A_rsrc\images\g_Filter.ICO"


      FILTER_OPT_FULL       = "C:\LEGO_xpp\A_rsrc\images\filter_OPT_FULL.ICO"
      FILTER_OPT_PART       = "C:\LEGO_xpp\A_rsrc\images\filter_OPT_PART.ICO"
      FILTER_OPT_NONE       = "C:\LEGO_xpp\A_rsrc\images\filter_OPT_NONE.ICO"

      MIS_ICON_KILLFILTER   = "C:\LEGO_xpp\A_rsrc\images\c_killFilter.ICO"
      gMIS_ICON_KILLFILTER  = "C:\LEGO_xpp\A_rsrc\images\g_killFilter.ICO"

      MIS_ICON_ATTENTION    = "C:\LEGO_xpp\A_rsrc\images\msgAttention.ico"

       MIS_ICON_CHECK       = "C:\LEGO_xpp\A_rsrc\images\c_check.ICO"
      gMIS_ICON_CHECK       = "C:\LEGO_xpp\A_rsrc\images\g_check.ICO"

       MIS_ICON_SAVE_AS     = "C:\LEGO_xpp\A_rsrc\images\c_save_as.ICO"
      gMIS_ICON_SAVE_AS     = "C:\LEGO_xpp\A_rsrc\images\g_save_as.ICO"

       MIS_ICON_DATCOM1     = "C:\LEGO_xpp\A_rsrc\images\c_datkom1.ico"
      gMIS_ICON_DATCOM1     = "C:\LEGO_xpp\A_rsrc\images\g_datkom1.ico"

       MIS_ICON_SWHELP      = "C:\LEGO_xpp\A_rsrc\images\c_swhelp.ico"
      gMIS_ICON_SWHELP      = "C:\LEGO_xpp\A_rsrc\images\g_swhelp.ico"

       MIS_ICON_SORT        = "C:\LEGO_xpp\A_rsrc\images\c_sort.ico"
      gMIS_ICON_SORT        = "C:\LEGO_xpp\A_rsrc\images\g_sort.ico"
      
* pro instalaci a reinstalaci
      451                   = "C:\LEGO_xpp\A_rsrc\images\Drive.ico"
      452                   = "C:\LEGO_xpp\A_rsrc\images\FldOpen.ico"
      453                   = "C:\LEGO_xpp\A_rsrc\images\FldClose.ico"
      454                   = "C:\LEGO_xpp\A_rsrc\images\bmp.ico"
      455                   = "C:\LEGO_xpp\A_rsrc\images\jpg.ico"
      456                   = "C:\LEGO_xpp\A_rsrc\images\gif.ico"
      457                   = "C:\LEGO_xpp\A_rsrc\images\html.ico"
      458                   = "C:\LEGO_xpp\A_rsrc\images\file.ico"

* pro RTF
      459                  = "C:\LEGO_xpp\A_rsrc\images\RTF.ico"
      460                  = "C:\LEGO_xpp\A_rsrc\images\c_refresh.ico"

* souètový sloupec BRow
      461                  =  "C:\LEGO_xpp\A_rsrc\images\c_sumColumn.ico"

* indikace vybraného záznamu ve visální stylu
      462                  =  "C:\LEGO_xpp\A_rsrc\images\c_selArrow_right.ico"


POINTER
      MIS_HAND          = "C:\LEGO_xpp\A_rsrc\pointer\Hand.cur"


BITMAP
      2                 = "C:\LEGO_xpp\A_rsrc\bitmap\Asystem++.bmp"
      MIS_ICON_OK       = "C:\LEGO_xpp\A_rsrc\bitmap\OK.bmp"
      MIS_ICON_ERR      = "C:\LEGO_xpp\A_rsrc\bitmap\ERR.bmp"
      MIS_BOOK          = "C:\LEGO_xpp\A_rsrc\bitmap\BOOK.bmp"
      MIS_BOOKOPEN      = "C:\LEGO_xpp\A_rsrc\bitmap\BOOKOPEN.bmp"
      MIS_PLUS          = "C:\LEGO_xpp\A_rsrc\bitmap\APPEND.bmp"
      MIS_MINUS         = "C:\LEGO_xpp\A_rsrc\bitmap\DELETE.bmp"
      MIS_EQUAL         = "C:\LEGO_xpp\A_rsrc\bitmap\EQUAL.bmp"
      MIS_EDIT          = "C:\LEGO_xpp\A_rsrc\bitmap\EDIT.bmp"
      MIS_NO_RUN        = "C:\LEGO_xpp\A_rsrc\bitmap\NO_RUN.bmp"
      MIS_HELP          = "C:\LEGO_xpp\A_rsrc\bitmap\HELP.bmp"
      MIS_UNDO          = "C:\LEGO_xpp\A_rsrc\bitmap\UNDO.bmp"
      MIS_LIGHT         = "C:\LEGO_xpp\A_rsrc\bitmap\LIGHT.bmp"
      MIS_PRINTER       = "C:\LEGO_xpp\A_rsrc\bitmap\PRINTER.bmp"
      MIS_FIND          = "C:\LEGO_xpp\A_rsrc\bitmap\FIND.bmp"
      MIS_RUN           = "C:\LEGO_xpp\A_rsrc\bitmap\RUN.bmp"
      MIS_WIZARD        = "C:\LEGO_xpp\A_rsrc\bitmap\WIZARD.bmp"
      MIS_CHECK_BMP     = "C:\LEGO_xpp\A_rsrc\bitmap\CHECK.bmp"


      BANVYPIT_1        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_1.bmp"
      BANVYPIT_2        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_2.bmp"
      BANVYPIT_3        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_3.bmp"
      BANVYPIT_4        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_4.bmp"
      BANVYPIT_5        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_5.bmp"
      BANVYPIT_6        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_6.bmp"
      BANVYPIT_7        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_7.bmp"
      BANVYPIT_8        = "C:\LEGO_xpp\A_rsrc\bitmap\BANVYPIT_8.bmp"

      H_big             = "C:\LEGO_xpp\A_rsrc\bitmap\H_big.bmp"
      H_low             = "C:\LEGO_xpp\A_rsrc\bitmap\H_low.bmp"
      P_big             = "C:\LEGO_xpp\A_rsrc\bitmap\P_big.bmp"
      P_low             = "C:\LEGO_xpp\A_rsrc\bitmap\P_low.bmp"
      D_big             = "C:\LEGO_xpp\A_rsrc\bitmap\D_big.bmp"
      L_big             = "C:\LEGO_xpp\A_rsrc\bitmap\L_big.bmp"
      L_low             = "C:\LEGO_xpp\A_rsrc\bitmap\L_low.bmp"
      U_big             = "C:\LEGO_xpp\A_rsrc\bitmap\U_big.bmp"
      U_low             = "C:\LEGO_xpp\A_rsrc\bitmap\U_low.bmp"
      T_big             = "C:\LEGO_xpp\A_rsrc\bitmap\T_big.bmp"

      1015 =   "C:\LEGO_xpp\A_rsrc\bitmap\GrayMottle.bmp"
      1016 =   "C:\LEGO_xpp\A_rsrc\bitmap\greenBackground.bmp"
      1017 =   "C:\LEGO_xpp\A_rsrc\bitmap\wrinklebackground.BMP"
      1018 =   "C:\LEGO_xpp\A_rsrc\bitmap\podklad_1.BMP"
      1019 =   "C:\LEGO_xpp\A_rsrc\bitmap\podklad_2.BMP"
      1020 =   "C:\LEGO_xpp\A_rsrc\bitmap\sel_background.bmp"

      5001 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver Today.bmp"
      5002 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x12 Silver Close.bmp"
      5003 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver Select.bmp"
      5004 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver Reset.bmp"
      5005 =   "C:\LEGO_xpp\A_rsrc\bitmap\12x17 Silver Left.bmp"
      5006 =   "C:\LEGO_xpp\A_rsrc\bitmap\12x17 Silver Right.bmp"
      5007 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver Prev.bmp"
      5008 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver Next.bmp"
      5009 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x12 Silver Minim.bmp"
      5010 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver HelpO.bmp"
      5011 =   "C:\LEGO_xpp\A_rsrc\bitmap\24x17 Silver HelpC.bmp"
      6000 =   "C:\LEGO_xpp\A_rsrc\bitmap\28x28 Silver CalT.bmp"

      6001 =   "C:\LEGO_xpp\A_rsrc\bitmap\GoOut.bmp"
      6006 =   "C:\LEGO_xpp\A_rsrc\bitmap\GoOut_W.bmp"
      6002 =   "C:\LEGO_xpp\A_rsrc\bitmap\msgAttention.bmp"

      6003 = "C:\LEGO_xpp\A_rsrc\bitmap\filter_OPT_FULL.bmp"
      6004 = "C:\LEGO_xpp\A_rsrc\bitmap\filter_OPT_PART.bmp"
      6005 = "C:\LEGO_xpp\A_rsrc\bitmap\filter_OPT_NONE.bmp"

* pro RTF editor
      6100 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_bold.bmp"
      6101 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_italic.bmp"
      6102 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_underline.bmp"
      6103 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_left.bmp"
      6104 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_center.bmp"
      6105 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_right.bmp"
* 106
      6107 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_bullet.bmp"
* 108..111
      6112 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_FgColor.bmp"
* 113..114
      6115 = "C:\LEGO_xpp\A_rsrc\bitmap\RTF_InsertImage.bmp"
**

      MIS_PHASE1 = "C:\LEGO_xpp\A_rsrc\bitmap\phase1.bmp"
      MIS_PHASE2 = "C:\LEGO_xpp\A_rsrc\bitmap\phase2.bmp"
      MIS_PHASE3 = "C:\LEGO_xpp\A_rsrc\bitmap\phase3.bmp"

      MIS_SORT_UP   = "C:\LEGO_xpp\A_rsrc\bitmap\Sort_up.bmp"
      MIS_SORT_DOWN = "C:\LEGO_xpp\A_rsrc\bitmap\Sort_down.bmp"

      MIS_WORM_PHASE1 = "C:\LEGO_xpp\A_rsrc\bitmap\worm_phase1.bmp"
      MIS_WORM_PHASE2 = "C:\LEGO_xpp\A_rsrc\bitmap\worm_phase2.bmp"
      MIS_WORM_PHASE3 = "C:\LEGO_xpp\A_rsrc\bitmap\worm_phase3.bmp"
      MIS_WORM_PHASE4 = "C:\LEGO_xpp\A_rsrc\bitmap\worm_phase4.bmp"

      MIS_EXCL_HELP = "C:\LEGO_xpp\A_rsrc\bitmap\_ExlHelp.bmp"
      MIS_EXCL_INFO = "C:\LEGO_xpp\A_rsrc\bitmap\_ExlInfo.bmp"
      MIS_EXCL_WARN = "C:\LEGO_xpp\A_rsrc\bitmap\_ExlWarn.bmp"
      MIS_EXCL_ERR  = "C:\LEGO_xpp\A_rsrc\bitmap\_ExlErr.bmp"

* tohle by mìlo pøijít ven
      MIS_LGATE     = "C:\LEGO_xpp\A_rsrc\bitmap\L_gate.bmp"
      MIS_RGATE     = "C:\LEGO_xpp\A_rsrc\bitmap\R_gate.bmp"


* menu
* dialog
        500   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_save.bmp"
        501   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_exit.bmp"
        502   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_printer.bmp"
        503   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_quit.bmp"
        504   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_errlog.bmp"
        504   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_errlog.bmp"
        505   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_dialist.bmp"

* editace
        510   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_edit.bmp"
        511   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_append2.bmp"
        512   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_append.bmp"
        513   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_delete.bmp"
        514   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_artop.bmp"
        515   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_arright.bmp"
        516   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_arleft.bmp"
        517   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_arbot.bmp"

* nástroje
        520   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_sort.bmp"
        521   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_find.bmp"
        522   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_filter.bmp"
        523   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_killfilter.bmp"
        524   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_docnew.bmp"
        525   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_datKom1.bmp"
        526   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_swhelp.bmp"

* nápovìda
        530   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_help.bmp"
        531   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_asystem++.bmp"


* splash
        532    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\tile7.bmp"
        533    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\Asystem++_start.bmp"

* mzdy
        534    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\H_mzdy_big.bmp"
        535    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\N_mzdy_big.bmp"
        536    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\S_mzdy_big.bmp"

* PRO_aktproceny_SCR
        537    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\Fir_SklPol.bmp"
        538    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\_SklPol.bmp"
        539    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\Fir_KatZbo.bmp"
        540    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\_KatZbo.bmp"


* bitmap_new
        561    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\A_big_new.bmp"
        562    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\B_big_new.bmp"
        563    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\C_big_new.bmp"
        550    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\D_big_new.bmp"
        559    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\E_big_new.bmp"
        551    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\F_big_new.bmp"
        557    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\K_big_new.bmp"
        552    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\M_big_new.bmp"
        560    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\P_big_new.bmp"
        553    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\T_big_new.bmp"
        554    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\V_big_new.bmp"
        565    = FILE "C:\LEGO_xpp\A_rsrc\bitmap_new\Vn_big_new.bmp"


* indikace vybraného záznamu ve visuální stylu
        564    = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_selArrow_right.bmp"

* stav položky
        555   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_Zluta.bmp"
        556   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_Zelena.bmp"
        558   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\m_Cervena.bmp"

* stav položky pro úhradu   pùvodní stav byl  559,560,561,562
        566   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\H_big_zelena.bmp"
        567   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\H_low_zelena.bmp"
        568   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\H_big_zluta.bmp"
        569   = FILE "C:\LEGO_xpp\A_rsrc\bitmap\H_low_zluta.bmp"

