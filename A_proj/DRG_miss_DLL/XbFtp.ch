
#define DLL_INTERNETOPEN         1
#define DLL_INTERNETCONNECT      2
#define DLL_INTERNETCLOSEHANDLE  3

#define DLL_INTERNET_MAX      3

#define CONN_INET 1
#define CONN_FTP  2

#define CONN_MAX  2


#define INTERNET_SERVICE_FTP  1
#define INTERNET_FLAG_PASSIVE 0x8000000

#define XBFTP_ERR_ICONN_FAIL     1     // failed to establish inet connection
#define XBFTP_ERR_FTPCONN_FAIL   2     // failed to establish ftp connection
#define MAX_PATH 260


// these are the transfer modes
#define FTP_TRANSFER_TYPE_UNKNOWN   0  // default (automaticaly decides)
#define FTP_TRANSFER_TYPE_ASCII     1  // plain text files (causes CRLF/LF translation suitable for taget OS)
#define FTP_TRANSFER_TYPE_BINARY    2  // all non-ascii files

// directory listing array element
#define FTP_FSTRU_NAME     1           // file name
#define FTP_FSTRU_SIZE     2           // file size
#define FTP_FSTRU_ATTR     3           // attributes
#define FTP_FSTRU_CRDATE   4           // creation date
#define FTP_FSTRU_CRTIME   5           // creation time
#define FTP_FSTRU_LADATE   6           // last accessed date
#define FTP_FSTRU_LATIME   7           // last accesd time
#define FTP_FSTRU_LWDATE   8           // last written (modified) date
#define FTP_FSTRU_LWTIME   9           // last written (modified) time
#define FTP_FSTRU_MAX      9

#define FTP_CBS_STATUS        1
#define FTP_CBS_PSENT         2
#define FTP_CBS_TSENT         3
#define FTP_CBS_PCENT         4
#define FTP_CBS_CTR           5
#define FTP_CBS_OCTR          6
#define FTP_CBS_CETA          7
#define FTP_CBS_TETA          8
#define FTP_CBS_RETRY         9
#define FTP_CBS_FINISH       10

#define CALLBACK_STRUCT_SIZE 10

#xtranslate STRUCTURE <x> <y> => local <y> := <x>

#xtranslate _StructCallBack => Array(CALLBACK_STRUCT_SIZE)

#xtranslate .Status       => \[FTP_CBS_STATUS\]
#xtranslate .PacketSent   => \[FTP_CBS_PSENT \]
#xtranslate .TotalSent    => \[FTP_CBS_TSENT \]
#xtranslate .Percent      => \[FTP_CBS_PCENT \]
#xtranslate .CurTransRate => \[FTP_CBS_CTR   \]
#xtranslate .OvrTransRate => \[FTP_CBS_OCTR  \]
#xtranslate .CurETA       => \[FTP_CBS_CETA  \]
#xtranslate .TotETA       => \[FTP_CBS_TETA  \]
#xtranslate .ReTry        => \[FTP_CBS_RETRY \]
#xtranslate .Finished     => \[FTP_CBS_FINISH\]

// File Transfer Status Flags
#define FTRANS_FILE_LOCAL        0x00
#define FTRANS_FILE_REMOTE       0x10

#define FTRANS_FILE_FAIL_GENERIC 0x00
#define FTRANS_FILE_FAIL_CREATE  0x01
#define FTRANS_FILE_FAIL_OPEN    0x02
#define FTRANS_FILE_FAIL_READ    0x04
#define FTRANS_FILE_FAIL_WRITE   0x08

#define FTRANS_FILE_FAIL_NONE    0xFF
#define FTRANS_FILE_FAIL_ABORT   0xF0

#define FTRANS_COMPLETE          0x01

#define GENERIC_READ             0x80000000
#define GENERIC_WRITE            0x40000000
#define GENERIC_EXECUTE          0x20000000
#define GENERIC_ALL              0x10000000

#xtranslate FetchFileSize(<n>) => Eval( {|n,i| i := FSeek(n,0,FS_END), FSeek(n,0,FS_SET),i},<n>)
#xtranslate FilePos(<n>)       => FSeek(<n>,0,FS_RELATIVE)

#xcommand CALLBACK <b> WITH <a> => Eval(<b>,<a>)

#define FTRANS_BUFF_SIZE 1024

#xtranslate IsLocalFile(<a>)  => (<a>\[5\])
#xtranslate IsRemoteFile(<a>) => !(<a>\[5\])

#define xbeP_XbFtp xbeP_User+501

