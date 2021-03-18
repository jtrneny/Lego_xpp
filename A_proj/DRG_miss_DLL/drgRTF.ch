* Command Identifiers

#define CMD_2D-Position              '2D-Position'              // Allows absolutely positioned elements to be moved by dragging.
#define CMD_AbsolutePosition         'AbsolutePosition'         // Sets an element's position property to "absolute."
#define CMD_BackColor                'BackColor'                // Sets or retrieves the background color of the current selection.
#define CMD_BlockDirLTR              'BlockDirLTR'              // Not currently supported.
#define CMD_BlockDirRTL              'BlockDirRTL'              // Not currently supported.
#define CMD_Bold                     'Bold'                     // Toggles the current selection between bold and nonbold.
#define CMD_BrowseMode               'BrowseMode'               // Not currently supported.
#define CMD_ClearAuthenticationCache 'ClearAuthenticationCache' // Clears all authentication credentials from the cache. Applies only to execCommand.
#define CMD_Copy                     'Copy'                     // Copies the current selection to the clipboard.
#define CMD_CreateBookmark           'CreateBookmark'           // Creates a bookmark anchor or retrieves the name of a bookmark anchor for
                                                                // the current selection or insertion point.
#define CMD_CreateLink               'CreateLink'               // Inserts a hyperlink on the current selection, or displays a dialog box enabling
                                                                // the user to specify a URL to insert as a hyperlink on the current selection.
#define CMD_Cut                      'Cut'                      // Copies the current selection to the clipboard and then deletes it.
#define CMD_Delete                   'Delete'                   // Deletes the current selection.
#define CMD_DirLTR                   'DirLTR'                   // Not currently supported.
#define CMD_DirRTL                   'DirRTL'                   // Not currently supported.
#define CMD_EditMode                 'EditMode'                 // Not currently supported.
#define CMD_FontName                 'FontName'                 // Sets or retrieves the font for the current selection.
#define CMD_FontSize                 'FontSize'                 // Sets or retrieves the font size for the current selection.
#define CMD_ForeColor                'ForeColor'                // Sets or retrieves the foreground (text) color of the current selection.
#define CMD_FormatBlock              'FormatBlock'              // Sets the current block format tag.
#define CMD_Indent                   'Indent'                   // Increases the indent of the selected text by one indentation increment.
#define CMD_InlineDirLTR             'InlineDirLTR'             // Not currently supported.
#define CMD_InlineDirRTL             'InlineDirRTL'             // Not currently supported.
#define CMD_InsertButton             'InsertButton'             // Overwrites a button control on the text selection.
#define CMD_InsertFieldset           'InsertFieldset'           // Overwrites a box on the text selection.
#define CMD_InsertHorizontalRule     'InsertHorizontalRule'     // Overwrites a horizontal line on the text selection.
#define CMD_InsertIFrame             'InsertIFrame'             // Overwrites an inline frame on the text selection.
#define CMD_InsertImage              'InsertImage'              // Overwrites an image on the text selection.
#define CMD_InsertInputButton        'InsertInputButton'        // Overwrites a button control on the text selection.
#define CMD_InsertInputCheckbox      'InsertInputCheckbox'      // Overwrites a check box control on the text selection.
#define CMD_InsertInputFileUpload    'InsertInputFileUpload'    // Overwrites a file upload control on the text selection.
#define CMD_InsertInputHidden        'InsertInputHidden'        // Inserts a hidden control on the text selection.
#define CMD_InsertInputImage         'InsertInputImage'         // Overwrites an image control on the text selection.
#define CMD_InsertInputPassword      'InsertInputPassword'      // Overwrites a password control on the text selection.
#define CMD_InsertInputRadio         'InsertInputRadio'         // Overwrites a radio control on the text selection.
#define CMD_InsertInputReset         'InsertInputReset'         // Overwrites a reset control on the text selection.
#define CMD_InsertInputSubmit        'InsertInputSubmit'        // Overwrites a submit control on the text selection.
#define CMD_InsertInputText          'InsertInputText'          // Overwrites a text control on the text selection.
#define CMD_InsertMarquee            'InsertMarquee'            // Overwrites an empty marquee on the text selection.
#define CMD_InsertOrderedList        'InsertOrderedList'        // Toggles the text selection between an ordered list and a normal format block.
#define CMD_InsertParagraph          'InsertParagraph'          // Overwrites a line break on the text selection.
#define CMD_InsertSelectDropdown     'InsertSelectDropdown'     // Overwrites a drop-down selection control on the text selection.
#define CMD_InsertSelectListbox      'InsertSelectListbox'      // Overwrites a list box selection control on the text selection.
#define CMD_InsertTextArea           'InsertTextArea'           // Overwrites a multiline text input control on the text selection.
#define CMD_InsertUnorderedList      'InsertUnorderedList'      // Converts the text selection into an ordered list.
#define CMD_Italic                   'Italic'                   // Toggles the current selection between italic and nonitalic.
#define CMD_JustifyCenter            'JustifyCenter'            // Centers the format block in which the current selection is located.
#define CMD_JustifyFull              'JustifyFull'              // Not currently supported.
#define CMD_JustifyLeft              'JustifyLeft'              // Left-justifies the format block in which the current selection is located.
#define CMD_JustifyNone              'JustifyNone'              // Not currently supported.
#define CMD_JustifyRight             'JustifyRight'             // Right-justifies the format block in which the current selection is located.
#define CMD_LiveResize               'LiveResize'               // Causes the MSHTML Editor to update an element's appearance continuously during
                                                                // a resizing or moving operation, rather than updating only at the completion of
                                                                // the move or resize.
#define CMD_MultipleSelection        'MultipleSelection'        // Allows for the selection of more than one site selectable element at a time
                                                                // when the user holds down the SHIFT or CTRL keys.
#define CMD_Open                     'Open'                     // Not currently supported.
#define CMD_Outdent                  'Outdent'                  // Decreases by one increment the indentation of the format block in which
                                                                // the current selection is located.
#define CMD_OverWrite                'OverWrite'                // Toggles the text-entry mode between insert and overwrite.
#define CMD_Paste                    'Paste'                    // Overwrites the contents of the clipboard on the current selection.
#define CMD_PlayImage                'PlayImage'                // Not currently supported.
#define CMD_Print                    'Print'                    // Opens the print dialog box so the user can print the current page.
#define CMD_Redo                     'Redo'                     // Not currently supported.
#define CMD_Refresh                  'Refresh'                  // Refreshes the current document.
#define CMD_RemoveFormat             'RemoveFormat'             // Removes the formatting tags from the current selection.
#define CMD_RemoveParaFormat         'RemoveParaFormat'         // Not currently supported
#define CMD_SaveAs                   'SaveAs'                   // Saves the current Web page to a file.
#define CMD_SelectAll                'SelectAll'                // Selects the entire document.
#define CMD_SizeToControl            'SizeToControl'            // Not currently supported.
#define CMD_SizeToControlHeight      'SizeToControlHeight'      // Not currently supported.
#define CMD_SizeToControlWidth       'SizeToControlWidth'       // Not currently supported.
#define CMD_Stop                     'Stop'                     // Not currently supported.
#define CMD_StopImage                'StopImage'                // Not currently supported.
#define CMD_StrikeThrough            'StrikeThrough'            // Not currently supported.
#define CMD_Subscript                'Subscript'                // Not currently supported.
#define CMD_Superscript              'Superscript'              // Not currently supported.
#define CMD_UnBookmark               'UnBookmark'               // Removes any bookmark from the current selection.
#define CMD_Underline                'Underline'                // Toggles the current selection between underlined and not underlined.
#define CMD_Undo                     'Undo'                     // Undo the previous command.
#define CMD_Unlink                   'Unlink'                   // Removes any hyperlink from the current selection.
#define CMD_Unselect                 'Unselect'                 // Clears the current selection.

#define OLECMDID_OPEN                 1
#define OLECMDID_SAVE                 3
#define OLECMDID_SAVEAS               4
#define OLECMDID_UNDO                 15
#define OLECMDID_REDO                 16
#define OLECMDID_PRINT                6
#define OLECMDID_PRINTPREVIEW         7
#define OLECMDID_CUT                  11
#define OLECMDID_COPY                 12
#define OLECMDID_PASTE                13
#define OLECMDID_SELECTALL            17
#define OLECMDEXECOPT_PROMPTUSER      1
#define OLECMDEXECOPT_DONTPROMPTUSER  2
#define OLECMDID_ZOOM                 19
#define FONTSIZEMEDIUM                2

#define DISPID_ONCONTEXTMENU          1023
#define DISPID_ONSELECTIONCHANGE      1037

#define READYSTATE_INTERACTIVE        3

#define INPUT_MOUSE                   0
#define INPUT_KEYBOARD                1
#define INPUT_HARDWARE                2
#define KEYEVENTF_KEYUP               0x02
#define VK_CONTROL                    0x11
#define VK_V                          0x56    // Paste
#define VK_C                          0x43    // Copy
#define VK_X                          0x58    // Cut

* musíme nadefinovat hotKeys pro xbpToolBarButton, taky by to mohl umìt sám
#define HOT_keys { { xbeK_CTRL_O, KEY_OPEN      }, ;
                   { xbeK_CTRL_S, KEY_SAVE      }, ;
                   { xbeK_CTRL_P, KEY_PRINT     }, ;
                   { xbeK_CTRL_B, KEY_BOLD      }, ;
                   { xbeK_CTRL_I, KEY_ITALIC    }, ;
                   { xbeK_CTRL_U, KEY_UNDERLINE }, ;
                   { xbeK_CTRL_L, KEY_LEFT      }, ;
                   { xbeK_CTRL_E, KEY_CENTER    }, ;
                   { xbeK_CTRL_R, KEY_RIGHT     }  }

#define TIP_OPEN                     'Otevøít (CTRL + O)'                       // 'Open'
#define TIP_SAVE                     'Uložit (CTRL + S)'                        // 'Save'
#define TIP_PRINT                    'Tisk (CTRL + P)'                          // 'Print'
#define TIP_PRINTPRE                 'Preview'
#define TIP_BOLD                     'Tuèné (CTRL + B)'                         // 'Bold'
#define TIP_ITALIC                   'Kurzíva (CTRL + I)'                       // 'Italic'
#define TIP_UNDERLINE                'Podtržení CTRL + U)'                      // 'Underline'
#define TIP_LEFT                     'Zarovnat text vlevo (CTRL + L)'           // 'Left Justify'
#define TIP_CENTER                   'Zarovnat na støed (CTRL + E)'             // 'Center Justify'
#define TIP_RIGHT                    'Zarovant text vpravo (CTRL + R)'          // 'Right Justify'
#define TIP_FULL                     'Block Justify'
#define TIP_BULLET                   'Odrážky Vloží/ Zruší Odrážkový seznam'    // 'Insert/Remove Bulleted List'
#define TIP_NUMBEREDLIST             'Insert/Remove Numbered List'
#define TIP_LEFTINDENT               'Decrease Indent'
#define TIP_RIGHTINDENT              'Increase Indent'
#define TIP_UNDO                     'Zpìt Psaní ( CTRL + Z)'                   // 'Undo'
#define TIP_REDO                     'Opakovat Psaní (CTRL + Y)'                // 'Redo'
#define TIP_CHECKSPELL               'Check Spelling'
#define TIP_FGCLR                    'Barva písma'                              // 'Text Color'
#define TIP_BGCLR                    'Background Color'
#define TIP_INSERTLINE               'Insert Horizontal Line'
#define TIP_INSERTIMAGE              'Vložit obrázek ze souboru'                // 'Insert Image From File'
#define TIP_INSERTLINK               'Insert/Edit Hyperlink'

#define KEY_OPEN                     'Open'
#define KEY_SAVE                     'Save'
#define KEY_SAVEAS                   'SaveAs'
#define KEY_PRINT                    'Print'
#define KEY_PRINTPRE                 'Print preview'
#define KEY_BOLD                     'Bold'
#define KEY_ITALIC                   'Italic'
#define KEY_UNDERLINE                'Underline'
#define KEY_LEFT                     'Left'
#define KEY_CENTER                   'Center'
#define KEY_RIGHT                    'Right'
#define KEY_FULL                     'Full'
#define KEY_BULLET                   'Bullet'
#define KEY_NUMBEREDLIST             'NumberedList'
#define KEY_LEFTINDENT               'LeftIndent'
#define KEY_RIGHTINDENT              'RightIndent'
#define KEY_UNDO                     'Undo'
#define KEY_REDO                     'Redo'
#define KEY_CHECKSPELL               'Spell'
#define KEY_FGCLR                    'FgClr'
#define KEY_BGCLR                    'BgClr'
#define KEY_INSERTLINE               'Line'
#define KEY_FONTNAME                 'FontName'
#define KEY_FONTSIZE                 'FontSize'
#define KEY_INSERTIMAGE              'InsertImage'
#define KEY_INSERTLINK               'InsertLink'

#define BMP_BOLD                      6100
#define BMP_ITALIC                    6101
#define BMP_UNDERLINE                 6102
#define BMP_LEFT                      6103
#define BMP_CENTER                    6104
#define BMP_RIGHT                     6105
#define BMP_FULL                       106
#define BMP_BULLET                    6107
#define BMP_NUMBEREDLIST               108
#define BMP_LEFTINDENT                 109
#define BMP_RIGHTINDENT                110
#define BMP_CHECKSPELL                 111
#define BMP_FGCLR                     6112
#define BMP_BGCLR                      113
#define BMP_INSERTLINE                 114
#define BMP_INSERTIMAGE               6115
#define BMP_INSERTLINK                 116

#define xCC_RGBINIT                   0x1
#define xCC_FULLOPEN                  0x2
#define xCC_PREVENTFULLOPEN           0x4
#define xCC_COLORSHOWHELP             0x8
#define xCC_ENABLEHOOK                0x10
#define xCC_ENABLETEMPLATE            0x20
#define xCC_ENABLETEMPLATEHANDLE      0X40
// Win9x Only
#define xCC_SOLIDCOLOR                0x80
#define xCC_ANYCOLOR                  0x100
// End Win9x Only

#define MNU_CUT                      'Cut'
#define MNU_COPY                     'Copy'
#define MNU_PASTE                    'Paste'
#define MNU_SELECTALL                'Select All'
#define MNU_IMG_PROPERTIES           'Image Properties'
#define MNU_LNK_MODIFY               'Edit Hyperlink'
#define MNU_LNK_REMOVE               'Remove Hyperlink'

#define URL_ABOUT                    'about:blank'

#define FONT_BASE                    '8.Arial'
#define TXT_TITLE_MAIN               'Xbase++ HTML Editor'
#define TXT_PANEL                    'Panel'
#define TXT_DEF_DOCU_NAME            'Document'
#define TXT_CONFIR_QUIT              'Are you sure you want to quit?'
#define TXT_CONFIR_CHANGES           'Text has been modified. Save changes before closing?'
#define TXT_ERR_CREATION1            'Error creating ActiveX Control. Please make sure' + CRLF + ;
                                     'MS-Explorer is installed on your computer.'
#define TXT_ERR_CREATION2            'Error creating ActiveX Control. (Subcode: '
#define TXT_ERR_CREATION3            'Error creating Microsoft CDO ActiveX Control.'
#define TXT_TITLE_OPEN               'Open'
#define TXT_ERR_NO_FILE              'File does not exist'
#define TXT_HTML_FILES               'HTML files'
#define TXT_INSERT_IMAGE             'Insert image from file'
#define TXT_IMAGE_FILES              'Image files'
#define TXT_CONF_OVERWRITE           'File already exists, overwrite it?'
#define TXT_NO_VALID_FILE            'It is not a valid file'
#define TXT_TITLE_SAVE               'Save as'
#define TXT_MHT_FILES                'Web Archive, single file (*.mht)'
#define TXT_HTM_FILES                'Web Page, HTML only (*.htm, *.html)'
#define TXT_TITLE_SPELL              'Spell Check'
#define TXT_END1_SPELL               'To check spelling first enter some text'
#define TXT_END2_SPELL               'Spellcheck is complete'
#define TXT_ERR_CREATION4            'Unable to load MS-Word Spell Checker'
#define TXT_PADDING                  '    '
#define TXT_LOADING                   TXT_PADDING + 'Loading MS-Word Spell Checker...'
#define TXT_CHECKING                  TXT_PADDING + 'Checking spelling...'
#define TXT_BUTTON_CANCEL            'Cancel'
#define TXT_BUTTON_OK                'Ok'

#define TXT_UNKNOWN                  'It is not in the dictionary:'
#define TXT_CHANGE                   'Change to:'
#define TXT_BUTTON_SUGGES            'Suggestions:'
#define TXT_BUTTON_IGNORE            'Ignore'
#define TXT_BUTTON_REPLACE           'Replace'

#define CR                            Chr( 13 )
#define LF                            Chr( 10 )
// #define TAB                           Chr( 9 )
#define SPACE                         Chr( 32 )
#define COMMA                         ','
#define SEMICOLON                     ';'
#define FULLSTOP                      '.'
#define DOUBLEPOINT                   ':'

#define NEXT_WORD                     .T.
#define FIRST_WORD                    .F.
#define SAME_WORD                     .F.


#define SM_REMOTESESSION               0x1000

#define adSaveCreateOverWrite          2
#define wdDoNotSaveChanges             0
#define wdAlertsNone                   0