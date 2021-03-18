//////////////////////////////////////////////////////////////////////
//
//  APPEVENT.CH
//
//  Copyright:
//      Alaska Software, (c) 1998-2009. All rights reserved.         
//  
//  Contents:
//      #define constants for AppEvent() return value
//   
//////////////////////////////////////////////////////////////////////

// AppEvent.ch is not included
#ifndef  _APPEVENT_CH         

#define xbe_None                       0

#ifdef __OS2__

// *****************************************************************************
// Keyboard event codes for OS/2
// *****************************************************************************

#define xbeK_UP                        65558
#define xbeK_DOWN                      65560
#define xbeK_LEFT                      65557
#define xbeK_RIGHT                     65559
#define xbeK_HOME                      65556
#define xbeK_END                       65555
#define xbeK_PGUP                      65553
#define xbeK_PGDN                      65554
#define xbeK_CTRL_UP                   589846
#define xbeK_CTRL_DOWN                 589848
#define xbeK_CTRL_LEFT                 589845
#define xbeK_CTRL_RIGHT                589847
#define xbeK_CTRL_HOME                 589844
#define xbeK_CTRL_END                  589843
#define xbeK_CTRL_PGUP                 589841
#define xbeK_CTRL_PGDN                 589842
#define xbeK_ALT_UP                    327702
#define xbeK_ALT_DOWN                  327704
#define xbeK_ALT_LEFT                  327701
#define xbeK_ALT_RIGHT                 327703
#define xbeK_ALT_HOME                  327700
#define xbeK_ALT_END                   327699
#define xbeK_ALT_PGUP                  327697
#define xbeK_ALT_PGDN                  327698
#define xbeK_SH_UP                     196630
#define xbeK_SH_DOWN                   196632
#define xbeK_SH_LEFT                   196629
#define xbeK_SH_RIGHT                  196631
#define xbeK_SH_HOME                   196628
#define xbeK_SH_END                    196627
#define xbeK_SH_PGUP                   196625
#define xbeK_SH_PGDN                   196626
#define xbeK_SH_CTRL_UP                720918
#define xbeK_SH_CTRL_DOWN              720920
#define xbeK_SH_CTRL_LEFT              720917
#define xbeK_SH_CTRL_RIGHT             720919
#define xbeK_SH_CTRL_HOME              720916
#define xbeK_SH_CTRL_END               720915
#define xbeK_SH_CTRL_PGUP              720913
#define xbeK_SH_CTRL_PGDN              720914
#define xbeK_ENTER                     65566
#define xbeK_RETURN                    13
#define xbeK_SPACE                     32
#define xbeK_ESC                       65551
#define xbeK_CTRL_ENTER                589854
#define xbeK_CTRL_RETURN               589832
#define xbeK_CTRL_RET                  589832
#define xbeK_CTRL_PRTSCR               589849
#define xbeK_ALT_ENTER                 327710
#define xbeK_ALT_RETURN                327688
#define xbeK_ALT_EQUALS                393277
#define xbeK_P_ALT_ENTER               327710
#define xbeK_P_CTRL_5                  -28928
#define xbeK_P_CTRL_SLASH              524335
#define xbeK_P_CTRL_ASTERISK           524330
#define xbeK_P_CTRL_MINUS              524333
#define xbeK_P_CTRL_PLUS               524331
#define xbeK_P_ALT_5                   281600
#define xbeK_P_ALT_SLASH               262191
#define xbeK_P_ALT_ASTERISK            262186
#define xbeK_P_ALT_MINUS               262189
#define xbeK_P_ALT_PLUS                262187
#define xbeK_INS                       65562
#define xbeK_DEL                       65563
#define xbeK_BS                        8
#define xbeK_TAB                       9
#define xbeK_SH_TAB                    196615
#define xbeK_CTRL_INS                  589850
#define xbeK_CTRL_DEL                  589851
#define xbeK_CTRL_BS                   589829
#define xbeK_CTRL_TAB                  589830
#define xbeK_ALT_INS                   327706
#define xbeK_ALT_DEL                   327707
#define xbeK_ALT_BS                    327685
#define xbeK_SH_INS                    196634
#define xbeK_SH_DEL                    196635
#define xbeK_SH_BS                     131080
#define xbeK_CTRL_A                    1
#define xbeK_CTRL_B                    2
#define xbeK_CTRL_C                    3
#define xbeK_CTRL_D                    4
#define xbeK_CTRL_E                    5
#define xbeK_CTRL_F                    6
#define xbeK_CTRL_G                    7
#define xbeK_CTRL_H                    8
#define xbeK_CTRL_I                    9
#define xbeK_CTRL_J                    10
#define xbeK_CTRL_K                    11
#define xbeK_CTRL_L                    12
#define xbeK_CTRL_M                    13
#define xbeK_CTRL_N                    14
#define xbeK_CTRL_O                    15
#define xbeK_CTRL_P                    16
#define xbeK_CTRL_Q                    17
#define xbeK_CTRL_R                    18
#define xbeK_CTRL_S                    19
#define xbeK_CTRL_T                    20
#define xbeK_CTRL_U                    21
#define xbeK_CTRL_V                    22
#define xbeK_CTRL_W                    23
#define xbeK_CTRL_X                    24
#define xbeK_CTRL_Y                    25
#define xbeK_CTRL_Z                    26
#define xbeK_ALT_A                     262241
#define xbeK_ALT_B                     262242
#define xbeK_ALT_C                     262243
#define xbeK_ALT_D                     262244
#define xbeK_ALT_E                     262245
#define xbeK_ALT_F                     262246
#define xbeK_ALT_G                     262247
#define xbeK_ALT_H                     262248
#define xbeK_ALT_I                     262249
#define xbeK_ALT_J                     262250
#define xbeK_ALT_K                     262251
#define xbeK_ALT_L                     262252
#define xbeK_ALT_M                     262253
#define xbeK_ALT_N                     262254
#define xbeK_ALT_O                     262255
#define xbeK_ALT_P                     262256
#define xbeK_ALT_Q                     262257
#define xbeK_ALT_R                     262258
#define xbeK_ALT_S                     262259
#define xbeK_ALT_T                     262260
#define xbeK_ALT_U                     262261
#define xbeK_ALT_V                     262262
#define xbeK_ALT_W                     262263
#define xbeK_ALT_X                     262264
#define xbeK_ALT_Y                     262265
#define xbeK_ALT_Z                     262266
#define xbeK_ALT_1                     262193
#define xbeK_ALT_2                     262194
#define xbeK_ALT_3                     262195
#define xbeK_ALT_4                     262196
#define xbeK_ALT_5                     262197
#define xbeK_ALT_6                     262198
#define xbeK_ALT_7                     262199
#define xbeK_ALT_8                     262200
#define xbeK_ALT_9                     262201
#define xbeK_ALT_0                     262192
#define xbeK_F1                        65568
#define xbeK_F2                        65569
#define xbeK_F3                        65570
#define xbeK_F4                        65571
#define xbeK_F5                        65572
#define xbeK_F6                        65573
#define xbeK_F7                        65574
#define xbeK_F8                        65575
#define xbeK_F9                        65576
#define xbeK_F10                       65577
#define xbeK_F11                       65578
#define xbeK_F12                       65579
#define xbeK_CTRL_F1                   589856
#define xbeK_CTRL_F2                   589857
#define xbeK_CTRL_F3                   589858
#define xbeK_CTRL_F4                   589859
#define xbeK_CTRL_F5                   589860
#define xbeK_CTRL_F6                   589861
#define xbeK_CTRL_F7                   589862
#define xbeK_CTRL_F8                   589863
#define xbeK_CTRL_F9                   589864
#define xbeK_CTRL_F10                  589865
#define xbeK_CTRL_F11                  589866
#define xbeK_CTRL_F12                  589867
#define xbeK_ALT_F1                    327712
#define xbeK_ALT_F2                    327713
#define xbeK_ALT_F3                    327714
#define xbeK_ALT_F4                    327715
#define xbeK_ALT_F5                    327716
#define xbeK_ALT_F6                    327717
#define xbeK_ALT_F7                    327718
#define xbeK_ALT_F8                    327719
#define xbeK_ALT_F9                    327720
#define xbeK_ALT_F10                   327721
#define xbeK_ALT_F11                   327722
#define xbeK_ALT_F12                   327723
#define xbeK_SH_F1                     196640
#define xbeK_SH_F2                     196641
#define xbeK_SH_F3                     196642
#define xbeK_SH_F4                     196643
#define xbeK_SH_F5                     196644
#define xbeK_SH_F6                     196645
#define xbeK_SH_F7                     196646
#define xbeK_SH_F8                     196647
#define xbeK_SH_F9                     196648
#define xbeK_SH_F10                    196649
#define xbeK_SH_F11                    196650
#define xbeK_SH_F12                    196651
#define xbeK_ALT_AE                    262276
#define xbeK_ALT_OE                    262292
#define xbeK_ALT_UE                    262273
#define xbeK_ALT_SZ                    262369

#endif

#ifdef __WIN32__

// *****************************************************************************
// Keyboard Codes for WIN32
// *****************************************************************************

#define xbeK_UP                         65574
#define xbeK_DOWN                       65576
#define xbeK_LEFT                       65573
#define xbeK_RIGHT                      65575
#define xbeK_HOME                       65572
#define xbeK_END                        65571
#define xbeK_PGUP                       65569
#define xbeK_PGDN                       65570
#define xbeK_CTRL_UP                    589862
#define xbeK_CTRL_DOWN                  589864
#define xbeK_CTRL_LEFT                  589861
#define xbeK_CTRL_RIGHT                 589863
#define xbeK_CTRL_HOME                  589860
#define xbeK_CTRL_END                   589859
#define xbeK_CTRL_PGUP                  589857
#define xbeK_CTRL_PGDN                  589858
#define xbeK_ALT_UP                     327718
#define xbeK_ALT_DOWN                   327720
#define xbeK_ALT_LEFT                   327717
#define xbeK_ALT_RIGHT                  327719
#define xbeK_ALT_HOME                   327716
#define xbeK_ALT_END                    327715
#define xbeK_ALT_PGUP                   327713
#define xbeK_ALT_PGDN                   327714
#define xbeK_ALT_SPACE                  327712
#define xbeK_ALT_SHIFT                  458752  
#define xbeK_SH_UP                      196646
#define xbeK_SH_DOWN                    196648
#define xbeK_SH_LEFT                    196645
#define xbeK_SH_RIGHT                   196647
#define xbeK_SH_HOME                    196644
#define xbeK_SH_END                     196643
#define xbeK_SH_PGUP                    196641
#define xbeK_SH_PGDN                    196642
#define xbeK_SH_CTRL_UP                 720934
#define xbeK_SH_CTRL_DOWN               720936
#define xbeK_SH_CTRL_LEFT               720933
#define xbeK_SH_CTRL_RIGHT              720935
#define xbeK_SH_CTRL_HOME               720932
#define xbeK_SH_CTRL_END                720931
#define xbeK_SH_CTRL_PGUP               720929
#define xbeK_SH_CTRL_PGDN               720930
#define xbeK_ENTER                      13
#define xbeK_RETURN                     13
#define xbeK_SPACE                      32
#define xbeK_ESC                        27
#define xbeK_CTRL_ENTER                 10
#define xbeK_CTRL_RETURN                10
#define xbeK_CTRL_RET                   10
#define xbeK_ALT_ENTER                  327693
#define xbeK_ALT_RETURN                 327693
#define xbeK_ALT_EQUALS                 458800
#define xbeK_P_ALT_ENTER                327693
#define xbeK_P_CTRL_5                   589836
#define xbeK_P_CTRL_SLASH               589935
#define xbeK_P_CTRL_ASTERISK            589930
#define xbeK_P_CTRL_MINUS               589933
#define xbeK_P_CTRL_PLUS                589931
#define xbeK_P_ALT_5                    327692
#define xbeK_P_ALT_SLASH                327791
#define xbeK_P_ALT_ASTERISK             327786
#define xbeK_P_ALT_MINUS                327789
#define xbeK_P_ALT_PLUS                 327787
#define xbeK_NUM_LOCK                   65680  
#define xbeK_SCROLL_LOCK                65681  
#define xbeK_CAPS_LOCK                  65556
#define xbeK_SH_CAPS_LOCK               196628
#define xbeK_ALT_CAPS_LOCK              327700
#define xbeK_CTRL_CAPS_LOCK             589844
#define xbeK_INS                        65581
#define xbeK_DEL                        65582
#define xbeK_BS                         8
#define xbeK_TAB                        9
#define xbeK_CTRL_INS                   589869
#define xbeK_CTRL_DEL                   589870
#define xbeK_CTRL_BS                    524415
#define xbeK_CTRL_ESC                   589899
#define xbeK_CTRL_TAB                   589833
#define xbeK_ALT_INS                    327725
#define xbeK_ALT_DEL                    327726
#define xbeK_ALT_BS                     327688
#define xbeK_SH_INS                     196653
#define xbeK_SH_DEL                     196654
#define xbeK_SH_BS                      131080
#define xbeK_SH_ESC                     131099
#define xbeK_SH_TAB                     131081
#define xbeK_SH_CTRL_INS                720941 
#define xbeK_SH_CTRL_DEL                720942 
#define xbeK_SH_CTRL_BS                 720904
#define xbeK_SH_CTRL_ESC                720923
#define xbeK_SH_CTRL_TAB                720905 
#define xbeK_CTRL_A                     1
#define xbeK_CTRL_B                     2
#define xbeK_CTRL_C                     3
#define xbeK_CTRL_D                     4
#define xbeK_CTRL_E                     5
#define xbeK_CTRL_F                     6
#define xbeK_CTRL_G                     7
#define xbeK_CTRL_H                     8
#define xbeK_CTRL_I                     9
#define xbeK_CTRL_J                     10
#define xbeK_CTRL_K                     11
#define xbeK_CTRL_L                     12
#define xbeK_CTRL_M                     13
#define xbeK_CTRL_N                     14
#define xbeK_CTRL_O                     15
#define xbeK_CTRL_P                     16
#define xbeK_CTRL_Q                     17
#define xbeK_CTRL_R                     18
#define xbeK_CTRL_S                     19
#define xbeK_CTRL_T                     20
#define xbeK_CTRL_U                     21
#define xbeK_CTRL_V                     22
#define xbeK_CTRL_W                     23
#define xbeK_CTRL_X                     24
#define xbeK_CTRL_Y                     25
#define xbeK_CTRL_Z                     26
#define xbeK_ALT_A                      327745
#define xbeK_ALT_B                      327746
#define xbeK_ALT_C                      327747
#define xbeK_ALT_D                      327748
#define xbeK_ALT_E                      327749
#define xbeK_ALT_F                      327750
#define xbeK_ALT_G                      327751
#define xbeK_ALT_H                      327752
#define xbeK_ALT_I                      327753
#define xbeK_ALT_J                      327754
#define xbeK_ALT_K                      327755
#define xbeK_ALT_L                      327756
#define xbeK_ALT_M                      327757
#define xbeK_ALT_N                      327758
#define xbeK_ALT_O                      327759
#define xbeK_ALT_P                      327760
#define xbeK_ALT_Q                      327761
#define xbeK_ALT_R                      327762
#define xbeK_ALT_S                      327763
#define xbeK_ALT_T                      327764
#define xbeK_ALT_U                      327765
#define xbeK_ALT_V                      327766
#define xbeK_ALT_W                      327767
#define xbeK_ALT_X                      327768
#define xbeK_ALT_Y                      327769
#define xbeK_ALT_Z                      327770
#define xbeK_ALT_1                      327729
#define xbeK_ALT_2                      327730
#define xbeK_ALT_3                      327731
#define xbeK_ALT_4                      327732
#define xbeK_ALT_5                      327733
#define xbeK_ALT_6                      327734
#define xbeK_ALT_7                      327735
#define xbeK_ALT_8                      327736
#define xbeK_ALT_9                      327737
#define xbeK_ALT_0                      327728
#define xbeK_F1                         65648
#define xbeK_F2                         65649
#define xbeK_F3                         65650
#define xbeK_F4                         65651
#define xbeK_F5                         65652
#define xbeK_F6                         65653
#define xbeK_F7                         65654
#define xbeK_F8                         65655
#define xbeK_F9                         65656
#define xbeK_F10                        65657
#define xbeK_F11                        65658
#define xbeK_F12                        65659
#define xbeK_CTRL_F1                    589936
#define xbeK_CTRL_F2                    589937
#define xbeK_CTRL_F3                    589938
#define xbeK_CTRL_F4                    589939
#define xbeK_CTRL_F5                    589940
#define xbeK_CTRL_F6                    589941
#define xbeK_CTRL_F7                    589942
#define xbeK_CTRL_F8                    589943
#define xbeK_CTRL_F9                    589944
#define xbeK_CTRL_F10                   589945
#define xbeK_CTRL_F11                   589946
#define xbeK_CTRL_F12                   589947
#define xbeK_ALT_F1                     327792
#define xbeK_ALT_F2                     327793
#define xbeK_ALT_F3                     327794
#define xbeK_ALT_F4                     327795
#define xbeK_ALT_F5                     327796
#define xbeK_ALT_F6                     327797
#define xbeK_ALT_F7                     327798
#define xbeK_ALT_F8                     327799
#define xbeK_ALT_F9                     327800
#define xbeK_ALT_F10                    327801
#define xbeK_ALT_F11                    327802
#define xbeK_ALT_F12                    327803
#define xbeK_SH_F1                      196720
#define xbeK_SH_F2                      196721
#define xbeK_SH_F3                      196722
#define xbeK_SH_F4                      196723
#define xbeK_SH_F5                      196724
#define xbeK_SH_F6                      196725
#define xbeK_SH_F7                      196726
#define xbeK_SH_F8                      196727
#define xbeK_SH_F9                      196728
#define xbeK_SH_F10                     196729
#define xbeK_SH_F11                     196730
#define xbeK_SH_F12                     196731
#define xbeK_ALT_MINUS                  327869
#define xbeK_ALT_AE                     327902
#define xbeK_ALT_OE                     327872
#define xbeK_ALT_UE                     327866
#define xbeK_ALT_SZ                     327899
#define xbeK_CMENU                      65629

#define xbeK_SHIFT                      65552
#define xbeK_CTRL                       65553
#define xbeK_ALT                        65554
#endif


// *****************************************************************************
// Defines for AppKeystate
// *****************************************************************************

// Return of AppKeystate()
//
#define APPKEY_IDLE    0
#define APPKEY_DOWN    1
#define APPKEY_TOGGLED 2


// *****************************************************************************
// Message defines
// *****************************************************************************

// Base Event (all XBP event codes are > xbeB_Event)
//
#define xbeB_Event                     1048576

// Generic messages
#define xbeP_None                      (001 + xbeB_Event)

// Mouse messages (for VIO and PM mode)
//
#define xbeM_Enter                     (005 + xbeB_Event)
#define xbeM_Leave                     (006 + xbeB_Event)
#define xbeM_LbDown                    (007 + xbeB_Event)
#define xbeM_MbDown                    (008 + xbeB_Event)
#define xbeM_RbDown                    (009 + xbeB_Event)
#define xbeM_LbUp                      (010 + xbeB_Event)
#define xbeM_MbUp                      (011 + xbeB_Event)
#define xbeM_RbUp                      (012 + xbeB_Event)
#define xbeM_LbClick                   (013 + xbeB_Event)
#define xbeM_MbClick                   (014 + xbeB_Event)
#define xbeM_RbClick                   (015 + xbeB_Event)
#define xbeM_LbDblClick                (016 + xbeB_Event)
#define xbeM_MbDblClick                (017 + xbeB_Event)
#define xbeM_RbDblClick                (018 + xbeB_Event)
#define xbeM_LbMotion                  (019 + xbeB_Event)
#define xbeM_MbMotion                  (020 + xbeB_Event)
#define xbeM_RbMotion                  (021 + xbeB_Event)
#define xbeM_Motion                    (022 + xbeB_Event)
#define xbeM_Wheel                     (023 + xbeB_Event)


// *****************************************************************************
// The following messages are only valid for Xbase Parts
// *****************************************************************************

// Generic messages
//
#define xbeP_Keyboard                  (004 + xbeB_Event)

#define xbeP_HelpRequest               (032 + xbeB_Event)
#define xbeP_Activate                  (033 + xbeB_Event)
#define xbeP_ItemSelected              (034 + xbeB_Event)

// Compatibility
#define xbeP_ActivateItem              xbeP_ItemSelected

#define xbeP_Move                      (048 + xbeB_Event)
#define xbeP_Resize                    (049 + xbeB_Event)
#define xbeP_Paint                     (050 + xbeB_Event)

#define xbeP_PresParamChanged          (051 + xbeB_Event)

#define xbeP_SetInputFocus             (052 + xbeB_Event)
#define xbeP_KillInputFocus            (053 + xbeB_Event)
#define xbeP_SetDisplayFocus           (054 + xbeB_Event)
#define xbeP_KillDisplayFocus          (055 + xbeB_Event)

#define xbeP_Close                     (056 + xbeB_Event)
#define xbeP_Quit                      (057 + xbeB_Event)

#define xbeP_ItemMarked                (070 + xbeB_Event)

#define xbeP_ClipboardChange           (071 + xbeB_Event)

#define xbeP_MeasureItem               (072 + xbeB_Event)
#define xbeP_DrawItem                  (073 + xbeB_Event)
#define xbeP_CustomDrawCell            xbeP_DrawItem

#define xbeP_DragEnter                 (074 + xbeB_Event)
#define xbeP_DragMotion                (075 + xbeB_Event)
#define xbeP_DragLeave                 (076 + xbeB_Event)
#define xbeP_DragDrop                  (077 + xbeB_Event)
#define xbeP_DragFeedback              (080 + xbeB_Event)
#define xbeP_DragQueryContinue         (081 + xbeB_Event)
#define xbeP_DragBegin                 (082 + xbeB_Event)
#define xbeP_DragEnd                   (083 + xbeB_Event)

#define xbeP_Measure                   (078 + xbeB_Event)
#define xbeP_Draw                      (079 + xbeB_Event)

#define xbeP_InputLangChangeRequest    (084 + xbeB_Event)
#define xbeP_InputLangChanged          (085 + xbeB_Event)

#define xbe_SystemPowerStatus          (086 + xbeB_Event)
#define xbeP_SystemPowerStatus         xbe_SystemPowerStatus
#define xbeP_SystemPropertyChanged     (087 + xbeB_Event)

#define xbeP_ThemeChanged              (088 + xbeB_Event)


// *****************************************************************************
// Xbase Part specific messages
// *****************************************************************************

// Defines for XbpHelp
#define xbeHelp_Inform                 (256 + xbeB_Event)

// Defines for XbpListbox
#define xbeLB_ItemMarked               (272 + xbeB_Event)
#define xbeLB_ItemSelected             (274 + xbeB_Event)
#define xbeLB_VScroll                  (273 + xbeB_Event)
#define xbeLB_HScroll                  (275 + xbeB_Event)

// Defines for XbpMle
#define xbeMLE_HScroll                 (288 + xbeB_Event)
#define xbeMLE_VScroll                 (289 + xbeB_Event)

// Defines for XbpSle
#define xbeSLE_Scroll                  (304 + xbeB_Event)
#define xbeSLE_Overflow                (305 + xbeB_Event)

// Defines for XbpTabpage
#define xbeTab_TabActivate             (320 + xbeB_Event)

// Defines for XbpSetting
#define xbeP_Selected                  (336 + xbeB_Event)

// Defines for XbpSpinbutton
#define xbeSpin_Up                     (352 + xbeB_Event)
#define xbeSpin_Down                   (353 + xbeB_Event)
#define xbeSpin_EndSpin                (354 + xbeB_Event)

// Defines for XbpScrollbar
#define xbeSB_Scroll                   (368 + xbeB_Event)

// Defines for XbpMenubar
#define xbeMENB_BeginMenu              (386 + xbeB_Event)
#define xbeMENB_EndMenu                (387 + xbeB_Event)
#define xbeMENB_OnMenuKey              (388 + xbeB_Event)

// Defines for XbpBrowse
#define xbeBRW_ItemMarked              (400 + xbeB_Event)
#define xbeBRW_ItemSelected            (401 + xbeB_Event)
#define xbeBRW_ItemRbDown              (402 + xbeB_Event)
#define xbeBRW_HeaderRbDown            (403 + xbeB_Event)
#define xbeBRW_FooterRbDown            (404 + xbeB_Event)
#define xbeBRW_Navigate                (405 + xbeB_Event)
#define xbeBRW_Pan                     (406 + xbeB_Event)
#define xbeBRW_ForceStable             (408 + xbeB_Event)


// Defines for XbpTreeView
#define xbeTV_ItemMarked               (512 + xbeB_Event)
#define xbeTV_ItemSelected             (513 + xbeB_Event)
#define xbeTV_ItemExpanded             (514 + xbeB_Event)
#define xbeTV_ItemCollapsed            (515 + xbeB_Event)

// Defines for XbpRtf
#define xbeRTF_Change                  (600 + xbeB_Event)
#define xbeRTF_SelChange               (601 + xbeB_Event)

// Defines for XbpToolbar
#define xbeTBAR_Change                 (650 + xbeB_Event)
#define xbeTBAR_ButtonClick            (651 + xbeB_Event)
#define xbeTBAR_ButtonMenuClick        (652 + xbeB_Event)
#define xbeTBAR_ButtonDropDown         (653 + xbeB_Event)

// Defines for XbpStatusbar
#define xbeSBAR_PanelClick             (700 + xbeB_Event)
#define xbeSBAR_PanelDblClick          (701 + xbeB_Event)
#define xbeSBAR_AsyncRefresh           (702 + xbeB_Event)

// Defines for XbpHTMLViewer
#define xbeHTML_BeforeNavigate         (750 + xbeB_Event)
#define xbeHTML_NavigateComplete       (751 + xbeB_Event)
#define xbeHTML_DocumentComplete       (752 + xbeB_Event)
#define xbeHTML_LoadError              (753 + xbeB_Event)
#define xbeHTML_StatusTextChange       (754 + xbeB_Event)
#define xbeHTML_ProgressChange         (755 + xbeB_Event)
#define xbeHTML_DownloadBegin          (756 + xbeB_Event)
#define xbeHTML_DownloadComplete       (757 + xbeB_Event)
#define xbeHTML_TitleChange            (758 + xbeB_Event)
#define xbeHTML_FrameBeforeNavigate    (759 + xbeB_Event)
#define xbeHTML_FrameNavigateComplete  (760 + xbeB_Event)


// *****************************************************************************
// Database object (DBO) specific -> Notify
// *****************************************************************************

#define xbeDBO_Notify                  (1024 + xbeB_Event)


// *****************************************************************************
// User defined event codes must be > xbeP_User 
// *****************************************************************************

#define xbeP_User                      134217728


// Compatibility
#define xbeLB_Scroll  xbeLB_VScroll


// AppEvent.ch is included
#define  _APPEVENT_CH                  

#endif                          // #ifndef _APPEVENT_CH

// * EOF *
