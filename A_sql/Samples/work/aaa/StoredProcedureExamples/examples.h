#include "ace.h"

// the constant DATA_DIRECTORY must end in a backslash
//#define  DATA_DIRECTORY    "\\\\brettd\\d\\"
#define DATA_DIRECTORY "\\\\potemkin\\aep\\"
#define  SERVER_TYPE       ADS_LOCAL_SERVER
//#define  SERVER_TYPE       ADS_REMOTE_SERVER

#define ACECHECK( ulRet )                  \
   if ( ulRet != AE_SUCCESS )              \
      AdsShowError( "Error" );


void MakeFiles( ADSHANDLE *phConnect, ADSHANDLE *phStmt );



// this message box option is from Microsoft's header files.  It allows an
// NT service to interact with the desktop
#define MB_SERVICE_NOTIFICATION          0x00200000L
