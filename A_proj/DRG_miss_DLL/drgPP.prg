//////////////////////////////////////////////////////////////////////
//
//  drgPP.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgPP class holds default presentation parameters for drg objects
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Font.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"


#define FONT_BASE                           "7.Arial"

#define COLOR_BG_ROWTABLA   GraMakeRGBcolor( { 249, 234, 181 } )
#define COLOR_BG_TABLA      GraMakeRGBcolor( { 255, 255, 239 } )
#define COLOR_BG_CABTABLA   GraMakeRGBcolor( {   0,   0, 160 } )
#define COLOR_FG_CABTABLA   GraMakeRGBcolor( { 255, 255, 198 } )
#define COLOR_BG_SELECTOR   GraMakeRGBcolor( { 207, 220, 236 } )
#define COLOR_FG_SELECTOR   GRA_CLR_BLACK
#define COLOR_BG_GETFIND    GraMakeRGBcolor( { 220, 235, 223 } )

#define COLOR_BG_DISABLED   GraMakeRGBcolor( { 128, 128, 128 } )

***********************************************************************
* Class declaration
***********************************************************************
CLASS drgPP

EXPORTED:

  VAR     fonts
  VAR     PP
  VAR     defFontFamily
  VAR     defFontCP
  VAR     usrFontCP

  VAR     colors

  METHOD  init                  // initialization
  METHOD  destroy               // clean up
  METHOD  getFont               // returns font object to requester
  METHOD  getPP                 // returns PP parameter to requester
  METHOD  setDefault            // sets default defined PP
  METHOD  setDisplayFonts       // sets usr defined display fonts

HIDDEN:
  METHOD  destroyFonts          // destroys all font objects before change
  METHOD  getFontObj            // returns font object for requested font
  METHOD  setFont_HL            // sets internal drgINI:fontH and drgINI:fontW vars
ENDCLASS

*************************************************************************
* drgPP object initialization. Also sets default values.
*************************************************************************
METHOD drgPP:init()
LOCAL oFont, ops, family, cp

* Get default font family and codepage
*********************************
  oPS   := AppDesktop():lockPS()
  oFont := oPS:setFont()
  AppDesktop():unlockPS()
  ::defFontFamily := oFont:familyName
  ::defFontCP     := oFont:codePage
*  drgDump(::defFontCP,'::defFontCP')
  IF drgINI:nlsCP_DATA  = 0; drgINI:nlsCP_DATA  := ::defFontCP; ENDIF
  IF drgINI:nlsCP_APP   = 0; drgINI:nlsCP_APP   := ::defFontCP; ENDIF
  IF drgINI:nlsCP_PRINT = 0; drgINI:nlsCP_PRINT := ::defFontCP; ENDIF
  oFont:destroy()
*********************************
  ::fonts   := ARRAY(9)
  ::PP      := ARRAY(drgPP_SIZE)
  ::colors  := {}
  ::usrFontCP   := ::defFontCP

  ::setDisplayFonts(drgINI:defFontFamily)
  ::setDefault()
RETURN self

*************************************************************************
* Returns requested font from internal font array.
*************************************************************************
METHOD drgPP:getFont(fontReq)
  DEFAULT fontReq TO 1
  IF fontReq = 5; fontReq++; ENDIF
/*
  DEFAULT fontReq TO 0
  IF VALTYPE(fontReq) = 'C'

  ELSEIF fontReq = 0
    fontReq := ::defFontSize
  ELSEIF fontReq = 5
    fontReq += ::defFontSize
  ELSEIF fontReq > 9
    fontReq := 1
  ENDIF
*/
RETURN ::fonts[fontReq]

*************************************************************************
* Returns requested presentation parameter from PP array.
*************************************************************************
METHOD drgPP:getPP(ppReq)
RETURN ::PP[ppReq]

*************************************************************************
* Set default defined fonts
*************************************************************************
METHOD drgPP:setDefault()
LOCAL oFont, ops, family, cp
LOCAL nColor   := GraMakeRGBColor({255 , 255 , 236})
//LOCAL nColor   := GraMakeRGBColor({255 , 200 , 236})
Local nLightYellow  := GraMakeRGBColor( {255, 255, 200} )
Local nLightBlue    := GraMakeRGBColor( {220, 220, 250} )
Local nLightBlue1   := GraMakeRGBColor( {201, 222, 245} )
Local nLightBlue2   := GraMakeRGBColor( {201, 210, 245} )
Local nGrey_NoEdit  := GraMakeRGBColor( {201, 201, 201} )
local nGreen_NoEdit := GraMakeRGBColor( {  0,  64,  64} )
local nclr          := GraMakeRGBColor( {  0, 128, 128} )

  ::PP[drgPP_PP_BROWSE1] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                 }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT } , ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_3DFACE } , ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , GRA_CLR_WHITE } , ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , GRA_CLR_DARKGRAY } , ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECT }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                 }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_NONE                }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE             }  }

  ::PP[drgPP_PP_BROWSE2] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                 }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_DA_BGCLR          , nColor             }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , GRA_CLR_BLACK                }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_NONE              }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                 }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_NONE                }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE             }  }

  ::PP[drgPP_PP_BROWSE3] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                 }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWTEXT         }, ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_WINDOW             }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_HILITEFOREGROUND   }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , XBPSYSCLR_HILITEBACKGROUND   }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_NONE }, ; //XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECT }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                 }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_NONE                }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE             }  }

  ::PP[drgPP_PP_BROWSE4] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                 }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT } , ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_3DFACE } , ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_WINDOWSTATICTEXT } , ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , XBPSYSCLR_3DFACE } , ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_NONE  }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                 }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_NONE                }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE             }  }

  ::PP[drgPP_PP_BROWSE5] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT   }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                 }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWTEXT         }, ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_WINDOW             }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_WINDOWTEXT         }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , XBPSYSCLR_WINDOW             }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECT }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE             }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE             }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_NONE               }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT  }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE            }  }

  ::PP[drgPP_PP_BROWSE6] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT    }, ;
    {XBP_PP_COL_HA_BGCLR          , XBPSYSCLR_3DFACE              }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                  }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , XBPSYSCLR_WINDOWTEXT          }, ;
    {XBP_PP_COL_DA_BGCLR          , nColor                        }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_HILITEFOREGROUND    }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , XBPSYSCLR_HILITEBACKGROUND    }, ;
    {XBP_PP_COL_DA_CHARWIDTH      , 1                }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED             }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_BOX                  }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE               }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE               }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPFRAME_RAISED               }, ;
    {XBP_PP_COL_FA_FGCLR          , XBPSYSCLR_WINDOWSTATICTEXT    }, ;
    {XBP_PP_COL_FA_BGCLR          , XBPSYSCLR_3DFACE              }  }

// miss
  ::PP[drgPP_PP_BROWSE7] :=  { ;
    {XBP_PP_COL_HA_FGCLR            , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_HA_BGCLR            , nLightBlue2      }, ;
    {XBP_PP_COL_HA_HEIGHT           , XBP_AUTOSIZE                  }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT      , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    { XBP_PP_COL_DA_FGCLR           , GRA_CLR_BLACK              }, ;
    { XBP_PP_COL_DA_BGCLR           , GRA_CLR_WHITE              }, ;
    { XBP_PP_COL_DA_HILITE_FGCLR    , GRA_CLR_WHITE              }, ;
    { XBP_PP_COL_DA_HILITE_BGCLR    , nclr                       }, ;
    {XBP_PP_COL_DA_CHARWIDTH        , 1                }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX +XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT  , XBPFRAME_DOTTED + XBPFRAME_BOX +XBPFRAME_RAISED }, ;
    { XBP_PP_COL_DA_ROWSEPARATOR    , XBPCOL_SEP_LINE+XBPCOL_SEP_DOTTED               }, ;
    { XBP_PP_COL_DA_COLSEPARATOR    , XBPCOL_SEP_LINE+XBPCOL_SEP_DOTTED               }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT      , XBPSTATIC_TYPE_FGNDRECT                         }, ;
    {XBP_PP_COL_FA_FGCLR            , GRA_CLR_BLACK                                   }, ;
    {XBP_PP_COL_FA_BGCLR            , nLightBlue                                      }  }

/*
  original
  ::PP[drgPP_PP_BROWSE7] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_HA_BGCLR          , nLightBlue2             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                  }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , GRA_CLR_BLACK         }, ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_3DFACE                        }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , GRA_CLR_WHITE    }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , GRA_CLR_DARKGRAY    }, ;
    {XBP_PP_COL_DA_CHARWIDTH      , 1                }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE             }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPSTATIC_TYPE_FGNDRECT            }, ;
    {XBP_PP_COL_FA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_FA_BGCLR          , nLightBlue           }  }
*/


// miss
  ::PP[drgPP_PP_BROWSE8] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_HA_BGCLR          , nLightBlue2             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                  }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , nLightBlue         }, ;
    {XBP_PP_COL_DA_BGCLR          , XBPSYSCLR_3DFACE                        }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_HILITEFOREGROUND    }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , GRA_CLR_DARKGRAY    }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE             }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPSTATIC_TYPE_FGNDRECT            }, ;
    {XBP_PP_COL_FA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_FA_BGCLR          , nLightBlue           }  }

// miss
/*
  ::PP[drgPP_PP_BROWSE9] :=  { ;
    {XBP_PP_COL_HA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_HA_BGCLR          , nLightBlue2             }, ;
    {XBP_PP_COL_HA_HEIGHT         , XBP_AUTOSIZE                  }, ;
    {XBP_PP_COL_HA_FRAMELAYOUT    , XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED}, ;
    {XBP_PP_COL_DA_FGCLR          , nLightBlue        }, ;
    {XBP_PP_COL_DA_BGCLR          , nGrey_NoEdit                        }, ;
    {XBP_PP_COL_DA_HILITE_FGCLR   , XBPSYSCLR_HILITEFOREGROUND    }, ;
    {XBP_PP_COL_DA_HILITE_BGCLR   , GRA_CLR_DARKGRAY    }, ;
    {XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED }, ;
    {XBP_PP_COL_DA_CELLFRAMELAYOUT, XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED },;
    {XBP_PP_COL_DA_ROWSEPARATOR   , XBPCOL_SEP_NONE              }, ;
    {XBP_PP_COL_DA_COLSEPARATOR   , XBPCOL_SEP_NONE             }, ;
    {XBP_PP_COL_DA_FRAMELAYOUT    , XBPSTATIC_TYPE_FGNDRECT            }, ;
    {XBP_PP_COL_FA_FGCLR          , GRA_CLR_BLACK    }, ;
    {XBP_PP_COL_FA_BGCLR          , nLightBlue           }  }
*/

// test na 9
  ::PP[drgPP_PP_BROWSE9] :=  { ;
         { XBP_PP_COL_DA_FGCLR            , GRA_CLR_BLACK                   }, ;
         { XBP_PP_COL_DA_BGCLR            , COLOR_BG_TABLA                  }, ;
         { XBP_PP_COL_DA_COMPOUNDNAME     , FONT_BASE                       }, ;
         { XBP_PP_COL_DA_ROWSEPARATOR     , XBPLINE_NONE                    }, ;
         { XBP_PP_COL_DA_COLSEPARATOR     , XBPLINE_NONE                    }, ;
         { XBP_PP_COL_DA_FRAMELAYOUT      , XBPFRAME_NONE                   }, ;
         { XBP_PP_COL_DA_CELLFRAMELAYOUT  , XBPFRAME_BOX + XBPFRAME_RAISED  }, ;
         { XBP_PP_COL_DA_HILITEFRAMELAYOUT, XBPFRAME_NONE                   }, ;
         { XBP_PP_COL_DA_HILITE_FGCLR     , GRA_CLR_BLACK                   }, ;
         { XBP_PP_COL_DA_HILITE_BGCLR     , COLOR_BG_ROWTABLA               }, ;
         { XBP_PP_COL_HA_COMPOUNDNAME     , '7.Arial Bold'                  }, ;
         { XBP_PP_COL_HA_FGCLR            , COLOR_FG_CABTABLA               }, ;
         { XBP_PP_COL_HA_BGCLR            , COLOR_BG_CABTABLA               }  }


//  ::PP[drgPP_PP_BROWSE7] :=  ACLONE(::PP[drgPP_PP_BROWSE6])
//  ::PP[drgPP_PP_BROWSE8] :=  ACLONE(::PP[drgPP_PP_BROWSE6])
//  ::PP[drgPP_PP_BROWSE9] :=  ACLONE(::PP[drgPP_PP_BROWSE6])

* PP's FOR GET object
  ::PP[drgPP_PP_EDIT1] :=  { ;
                             { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWTEXT  } , ;
                             { XBP_PP_BGCLR        , XBPSYSCLR_WINDOW      } , ;
                             { XBP_PP_DISABLED_FGCLR, nGreen_NoEdit        } , ;
                             { XBP_PP_DISABLED_BGCLR, nGrey_NoEdit         }   }
  // Povinná editaèní položka ... modrá
  ::PP[drgPP_PP_EDIT2] :=  { ;
                             { XBP_PP_FGCLR         , XBPSYSCLR_WINDOWTEXT } , ;
                             { XBP_PP_BGCLR         , nLightBlue           } , ;
                             { XBP_PP_DISABLED_FGCLR, nGreen_NoEdit        } , ;
                             { XBP_PP_DISABLED_BGCLR, nGrey_NoEdit         }   }

*                              { XBP_PP_DISABLED_FGCLR, GRA_CLR_DARKGRAY     } , ;

  // Needitovatelná položka ... šedá
  ::PP[drgPP_PP_EDIT3] :=  { ;
                             { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWTEXT } , ;
                             { XBP_PP_BGCLR        , nLightYellow         } , ;
                             { XBP_PP_DISABLED_FGCLR, nGreen_NoEdit       } , ;
                             { XBP_PP_DISABLED_BGCLR, nGrey_NoEdit        }   }
*                           { XBP_PP_BGCLR        , nGrey_NoEdit         } }
* PP's for STATIC TEXT
  ::PP[drgPP_PP_TEXT1] :=  { ;
                           { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWSTATICTEXT } , ;
                           { XBP_PP_BGCLR        , XBPSYSCLR_TRANSPARENT} }
//                           { XBP_PP_BGCLR        , XBPSYSCLR_3DFACE} }

  ::PP[drgPP_PP_TEXT2] :=  { ;
                           { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWSTATICTEXT } , ;
                           { XBP_PP_BGCLR        , XBPSYSCLR_3DFACE} }

/*
  ::PP[drgPP_PP_TEXT2] :=  { ;
                           { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWSTATICTEXT } , ;
                           { XBP_PP_BGCLR        , nGrey_NoEdit} }
*/

/*
  ::PP[drgPP_PP_TEXT3] :=  { ;
                           { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWSTATICTEXT } , ;
                           { XBP_PP_BGCLR        , XBPSYSCLR_BUTTONMIDDLE} }
*/
  ::PP[drgPP_PP_TEXT3] :=  { ;
                           { XBP_PP_FGCLR        , XBPSYSCLR_WINDOWSTATICTEXT } , ;
                           { XBP_PP_BGCLR        , XBPSYSCLR_TRANSPARENT} }


RETURN self

*************************************************************************
* Sets default fonts objects for displaying on a screen.
*
*
*************************************************************************
METHOD drgPP:setDisplayFonts(fFamily, fCP)
LOCAL nSize := drgINI:defFontSize
  DEFAULT fCP TO ::defFontCP
  IF EMPTY(fFamily); fFamily := ::defFontFamily; ENDIF
  ::destroyFonts()
*  drgDump(fFamily)

  ::fonts[1] := ::getFontObj(fFamily, nSize    , XBPFONT_WEIGHT_NORMAL, fCP)
  ::fonts[2] := ::getFontObj(fFamily, nSize + 2, XBPFONT_WEIGHT_NORMAL, fCP)
  ::fonts[3] := ::getFontObj(fFamily, nSize + 4, XBPFONT_WEIGHT_NORMAL, fCP)
  ::fonts[4] := ::getFontObj(fFamily, nSize + 8, XBPFONT_WEIGHT_NORMAL, fCP)

  ::fonts[6] := ::getFontObj(fFamily, nSize    , XBPFONT_WEIGHT_BOLD, fCP)
  ::fonts[7] := ::getFontObj(fFamily, nSize + 2, XBPFONT_WEIGHT_BOLD, fCP)
  ::fonts[8] := ::getFontObj(fFamily, nSize + 4, XBPFONT_WEIGHT_BOLD, fCP)
  ::fonts[9] := ::getFontObj(fFamily, nSize + 8, XBPFONT_WEIGHT_BOLD, fCP)
  ::setFont_HL()
RETURN self

*************************************************************************
* Release memory holded by default fount definitions.
*************************************************************************
METHOD drgPP:destroyFonts()
LOCAL x
  FOR x := 1 TO 9
    IF ::fonts[x] != NIL
      ::fonts[x]:destroy()
    ENDIF
  NEXT x
RETURN self

*************************************************************************
* Returns custom defined font.
*************************************************************************
METHOD drgPP:getFontObj(fontFamily, pointSize, weight, fontCodePage)
LOCAL oFnt

  oFnt := XbpFont():new( AppDesktop():lockPS() )
  oFnt:familyName       := fontFamily
  oFnt:nominalPointSize := pointSize
  oFnt:generic          := .T.
  oFnt:codePage         := fontCodePage
  oFnt:weightClass      := weight
  oFnt:create()
  AppDesktop():unlockPS()

RETURN oFnt

*************************************************************************
* Detect default font height and width
*************************************************************************
METHOD drgPP:setFont_HL()
LOCAL oPS, aBox
  oPS      := AppDesktop():lockPS()
  graSetFont(oPS,::fonts[1])
  aBox     := GraQueryTextBox(oPS,'O')

  drgINI:fontW := aBox[3,1] - aBox[2,1] - 1
  drgINI:fontH := aBox[1,2] - aBox[2,2] + 8
*  drgDump(drgINI:fontW,'FONTW')
*  drgDump(drgINI:fontH,'FONTH')
RETURN self

*************************************************************************
* Clean UP
*************************************************************************
METHOD drgPP:destroy()
  ::destroyFonts()

  ::fonts           := ;
  ::PP              := ;
  ::usrFontCP       := ;
  ::defFontFamily   := ;
  ::defFontCP       := ;
  ::colors          := ;
                       NIL

RETURN self