#include "Common.ch"
#include "drg.ch"

#DEFINE CRLF  CHR(13)+CHR(10)

PROCEDURE DBESYS()
RETURN

PROCEDURE Main(cParmWhat, cParmWith, cDir)
LOCAL aD
PUBLIC cWhat := LOWER(cParmWhat)
PUBLIC cWith := cParmWith
  DEFAULT cDir TO '*.PRG'
  aD := DIRECTORY(cDir)
  AEVAL(aD, {|e| enFile(e[1]) } )
RETURN

PROCEDURE enFile(cFile)
LOCAL FI, FO, cExt, cName
LOCAL c, n
  cName := parseFileName(cFile,1)
  cExt  := parseFileName(cFile,2)

  drgFRename(cFile, cName + '.BAK')
  FI := FOPEN(cName + '.BAK')
  FO := FCREATE(cFile)
  WHILE FReadLn(FI,@c)
    WHILE (n := AT(cWhat, LOWER(c))) > 0
      c := STUFF(c, n, LEN(cWhat), cWith )
    ENDDO
    FWRITE(FO, c + CRLF)
  ENDDO
  FCLOSE(FO)
  FCLOSE(FI)
RETURN



