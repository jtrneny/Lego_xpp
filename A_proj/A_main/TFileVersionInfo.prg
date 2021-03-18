#include "ot4xb.ch"
// ---------------------------------------------------------------------------
CLASS TFileVersionInfo
   EXPORTED:
   CLASS VAR hVersion // version.dll
   CLASS VAR fp_GetFileVersionInfo        // GetFileVersionInfoA     
   CLASS VAR fp_GetFileVersionInfoSize    // GetFileVersionInfoSizeA 
   CLASS VAR fp_VerQueryValue             // VerQueryValueA          
   VAR pInfo
   VAR cFile
   VAR nSignature         
   VAR nStrucVersion      
   VAR nFileVersionMS     
   VAR nFileVersionLS     
   VAR nProductVersionMS  
   VAR nProductVersionLS  
   VAR nFileFlagsMask     
   VAR nFileFlags         
   VAR nFileOS            
   VAR nFileType          
   VAR nFileSubtype       
   VAR nFileDateMS        
   VAR nFileDateLS        

       // --------------------------------------------------------------------
INLINE CLASS METHOD initClass()
       ::hVersion := DllLoad("version.dll")
       ::fp_GetFileVersionInfo     := nGetProcAddress(::hVersion,"GetFileVersionInfoA"  )
       ::fp_GetFileVersionInfoSize := nGetProcAddress(::hVersion,"GetFileVersionInfoSizeA")
       ::fp_VerQueryValue          := nGetProcAddress(::hVersion,"VerQueryValueA")
       return Self
       // --------------------------------------------------------------------
INLINE METHOD init(cFile)
       local nHandle := 0
       local nLen
       local aInfo
       if( ::pInfo != NIL ) ; ::Destroy() ; end
       if ( cFile == NIL ) ; return NIL ; end
       ::cFile := cFile
       nLen := nFpCall( ::fp_GetFileVersionInfoSize,cFile , @nHandle )
       if ( nLen < 1 ) ; return NIL ; end
       ::pInfo := _xgrab(nLen)
       if nFpCall( ::fp_GetFileVersionInfo,cFile,0,nLen,::pInfo) == 0
          ::Destroy()
          return NIL
       end
       aInfo := ::QueryValue(0)
       ::nSignature         := aInfo[ 1]
       ::nStrucVersion      := aInfo[ 2]
       ::nFileVersionMS     := aInfo[ 3]
       ::nFileVersionLS     := aInfo[ 4]
       ::nProductVersionMS  := aInfo[ 5]
       ::nProductVersionLS  := aInfo[ 6]
       ::nFileFlagsMask     := aInfo[ 7]
       ::nFileFlags         := aInfo[ 8]
       ::nFileOS            := aInfo[ 9]
       ::nFileType          := aInfo[10]
       ::nFileSubtype       := aInfo[11]
       ::nFileDateMS        := aInfo[12]
       ::nFileDateLS        := aInfo[13]
       return Self
       // --------------------------------------------------------------------
INLINE METHOD Destroy()
       ::cFile := NIL
       if( ::pInfo != NIL ) ; _xfree(::pInfo) ; end
       ::pInfo := NIL
       return NIL
       // --------------------------------------------------------------------
INLINE METHOD GetDefaultLanguageString()
       local pdw    := 0
       local nSize  := 0
       local cRet   := "000004E4"
       local sh     := 0 
       if ( ::pInfo != NIL )
          if nFpCall( ::fp_VerQueryValue,::pInfo,"\VarFileInfo\Translation",@pdw,@nSize ) != 0
             if nSize >= 4
                cRet := cW2Hex(PeekWord(pdw,@sh)) + cW2Hex(PeekWord(pdw,@sh))
             end
          end
       end
       return cRet
       // --------------------------------------------------------------------
INLINE METHOD QueryValue(nKeyType,cKName,cHexLang) //  -> uValue | NIL
       local nLen  := 0
       local uRet  := NIL
       local cKey
       local p := 0 
       local nItems,n
       local sh     := 0             
       if( ::pInfo == NIL) 
          return NIL
       end
       
       if ( nKeyType == 0 ) // VS_FIXEDFILEINFO value as ARRAY
          if nFpCall( ::fp_VerQueryValue,::pInfo,"\",@p,@nLen ) != 0
             if( nLen >= 52 ) // 13 * 4
                uRet := PeekDWord( p ,0,13)
             end
          end
       elseif ( nKeyType == 1 ) //  StringFileInfo [ with language string ]
          cKey := "\StringFileInfo\"
          if( cHexLang == NIL ) 
             cKey += ::GetDefaultLanguageString()
          else
             cKey += cHexLang
          end
          cKey += "\" + cKName      
          p := 0
          if nFpCall( ::fp_VerQueryValue,::pInfo,cKey,@p,@nLen ) != 0
             uRet := PeekStr( p,, nLen)
          end
       else  // nKeyType == 2 // Get All Language Hex Strings in your version info
          if nFpCall( ::fp_VerQueryValue,::pInfo,"\VarFileInfo\Translation",@p,@nLen ) != 0
             nItems := Int( nLen / 4 )
             uRet := Array(nItems)
             for n := 1 to nItems
                uRet[n] := cW2Hex(PeekWord(p,@sh))+cW2Hex(PeekWord(p,@sh))
             next
          end
       end
       return uRet
       // --------------------------------------------------------------------

ENDCLASS
// ---------------------------------------------------------------------------

