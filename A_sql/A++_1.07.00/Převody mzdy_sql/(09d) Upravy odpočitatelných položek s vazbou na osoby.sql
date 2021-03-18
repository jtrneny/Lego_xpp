update msodppol set msodppol.ncisosorp = osoby.ncisosoby from osoby where (msodppol.ctypodppol='DITE' or msodppol.ctypodppol='MANZ')
                                                                              and msodppol.crodcisrp = osoby.crodcisosb    ;  
update msodppol set nvazosoby = vazosoby.sid from vazosoby where (msodppol.ctypodppol='DITE' or msodppol.ctypodppol='MANZ')
                                                                         and msodppol.crodcisrp = vazosoby.crodcisosb  
