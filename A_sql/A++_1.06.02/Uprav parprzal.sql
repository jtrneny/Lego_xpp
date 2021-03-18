
select parPrzal.ncisZalFak, 
       sum(parPrzal.nparZahFak) as parZahFak, 
	   sum(parPrzal.nparZahFak) as parZalFak
       into #parPrzal_w 
       from parPrzal
       group by parPrzal.ncisZalFak
	   order by parPrzal.ncisZalFak
	   ;

select fakprihd.ncisFak as faktura,
       fakPrihd.nparZahFak,
	   fakpriHd.nparZalFak,
       parPrzal_w.ncisZalFak, 
       parPrzal_w.parZahFak as parZahFak, 
	   parPrzal_w.parZahFak as parZalFak
	   from #parPrzal_w
       right join fakprihd on (parPrzal_w.ncisZalFak = fakprihd.ncisfak)	
	   ;
update fakPrihd 
       set fakPrihd.nparZahFak = parPrzal_w.parZahFak,
	       fakpriHd.nparZalFak = parPrzal_w.parZahFak
 	   from #parPrzal_w	   				
	   where(parPrzal_w.ncisZalFak = fakprihd.ncisfak) 
           ;
drop table #parPrzal_w 
