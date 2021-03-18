// #pragma Library( "XppUI2.LIB" )
#pragma Library( "ADAC20B.LIB" )

#include "Appevent.ch"
#include "Common.ch"
#include "Directry.ch"
#include "Gra.ch"
#include "Font.ch"
#include "Xbp.ch"
#include "ads.ch"
#include "adsdbe.ch"

#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


CLASS drgDBrowse FROM deBrowse
  EXPORTED:

    inline method eventHandled(nEvent, mp1, mp2, oxbp)
      return ::deBrowse:handleEvent(nEvent, mp1, mp2, oxbp)
ENDCLASS
