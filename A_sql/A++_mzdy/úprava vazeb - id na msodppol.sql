update msodppol set msodppol.nvazosoby =vazosoby.sid from vazosoby where msodppol.crodcisrp = vazosoby.crodcisosb and
            msodppol.nrok>=2017 and msodppol.crodcisRP <> ' ' and msodppol.nvazosoby = 0	;
