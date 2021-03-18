
@SET PATH=C:\Public
@SET PATH=%path%;c:\alaska\xppw3219_sl1\bin
@SET PATH=%path%;c:\alaska\xppw3219_sl1\lib
@SET PATH=%path%;c:\alaska\xbtw3219\lib
@SET PATH=%path%;c:\alaska\adsw3219\lib
@SET PATH=%path%;c:\WINDOWS;c:\WINDOWS\system32;c:\WINDOWS\command;c:\WINDOWS\system32\wbem

@SET INCLUDE=c:\alaska\xppw3219_sl1\include
@SET INCLUDE=%include%;c:\alaska\adsw3219\include
@SET INCLUDE=%include%;c:\alaska\xbtw3219\include

@SET LIB=c:\alaska\xppw3219_sl1\lib
@SET LIB=%lib%;c:\alaska\xbtw3219\lib
@SET LIB=%lib%;c:\alaska\adsw3219\lib

@SET TEMP=c:\temp
@SET TMP=c:\temp

@SET OBJ=

@CALL DOSKEY DIR=DIR /o-d /p $1 $2
