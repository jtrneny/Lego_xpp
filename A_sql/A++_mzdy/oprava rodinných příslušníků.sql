//select msodppol.cpracovnik,msodppol.crodcisrp,vazosoby.crodcisosb from msodppol, vazosoby where msodppol.crodcisrp= vazosoby.crodcisosb and
//            msodppol.nrok>2012 and msodppol.crodcisRP <> ' '    ;
update msodppol set msodppol.nvazosoby =vazosoby.sid from vazosoby where msodppol.crodcisrp= vazosoby.crodcisosb and
            msodppol.nrok>2012 and msodppol.crodcisRP <> ' '	;
update vazosoby set vazosoby.osoby = msodppol.noscisprac from msodppol where vazosoby.sid = msodppol.nvazosoby   ; 
update vazosoby set vazosoby.osoby = osoby.sid from osoby where vazosoby.osoby = osoby.noscisprac
