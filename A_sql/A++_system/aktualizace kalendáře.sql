update c_svatky set lSvatStat  = true, lSvatOstat = true, dplatnyOD='01.01.1951', lAktivni=true where nden=1 and nmesic=1  ;   
update c_svatky set lSvatOstat = true, dplatnyOD='01.01.1951', lAktivni=true where nmesic=3 or nmesic=4   ; 
update c_svatky set lSvatOstat = true, dplatnyOD='01.01.1951', lAktivni=true where ( nden=1 and nmesic=5)  ;
update c_svatky set lSvatStat = true,  dplatnyOD='01.01.1992',  lAktivni=true where ( nden=8 and nmesic=5)  ;
update c_svatky set lSvatStat = true, dplatnyOD='01.01.1990',  lAktivni=true where ( nden=5 and nmesic=7)  ;
update c_svatky set lSvatStat = true, dplatnyOD='01.01.2000',  lAktivni=true where ( nden=28 and nmesic=9) ;
update c_svatky set lSvatStat = true, dplatnyOD='01.01.1988',  lAktivni=true where ( nden=28 and nmesic=10);
update c_svatky set lSvatStat = true, dplatnyOD='01.01.2000',  lAktivni=true where ( nden=17 and nmesic=11);
update c_svatky set lSvatOstat = true, dplatnyOD='01.01.1990', lAktivni=true where ( nden=24 and nmesic=12); 
update c_svatky set lSvatOstat = true, dplatnyOD='01.01.1951', lAktivni=true where ( nden=25 and nmesic=12);  
update c_svatky set lSvatOstat = true, dplatnyOD='01.01.1951', lAktivni=true where ( nden=26 and nmesic=12);   

update kalendar set kalendar.lSvatStat = c_svatky.lSvatStat,
                    kalendar.lSvatOstat = c_svatky.lSvatOstat
                from c_svatky where kalendar.ddatum = c_svatky.ddatum ;

update kalendar set ctypdne='SV', ndensvatek = 1  where lSvatStat or lSvatOstat 
