 // fakvysHD cdenik = O
 select vykdph_i.cdenik , vykdph_i.ndoklad,
        vykdph_i.ntyp_Dph  , vykdph_i.nradek_Dph, 
        vykdph_i.nzakld_Dph, vykdph_i.nsazba_Dph,
        fakvyshd.ndoklad, 
	    fakvyshd.nzaklDan_1, fakvyshd.nsazDan_1,  
        fakvyshd.nzaklDan_2, fakvyshd.nsazDan_2  	   
        from vykdph_i 
        left join fakvyshd on vykdph_i.cdenik  = fakvyshd.cdenik and
	                           vykdph_i.ndoklad = fakvyshd.ndoklad
        where vykdph_i.nrok = 2014 and vykdph_i.nobdobi = 9 	   
	    order by vykdph_i.cdenik, vykdph_i.ndoklad			

// ucetDoHD	 cdenik = V, VD  
select vykdph_i.cdenik , vykdph_i.ndoklad, 
       vykdph_i.ntyp_Dph  , vykdph_i.nradek_Dph,
       vykdph_i.nzakld_Dph, vykdph_i.nsazba_Dph,
       ucetdohd.ndoklad, 
       ucetdohd.nzaklDan_1, ucetdohd.nsazDan_1,  
       ucetdohd.nzaklDan_2, ucetdohd.nsazDan_2  	   
       from vykdph_i 
       left join ucetdohd on vykdph_i.cdenik  = ucetdohd.cdenik and
	                         vykdph_i.ndoklad = ucetdohd.ndoklad
       where vykdph_i.nrok = 2014 and vykdph_i.nobdobi = 9 	   
	   order by vykdph_i.cdenik, vykdph_i.ndoklad			   
	   
// pokladHD	cdenik = P   
select vykdph_i.cdenik , vykdph_i.ndoklad, 
       vykdph_i.ntyp_Dph  , vykdph_i.nradek_Dph,
       vykdph_i.nzakld_Dph, vykdph_i.nsazba_Dph,
       pokladhd.ndoklad, 
	   pokladhd.nzaklDan_1, pokladhd.nsazDan_1,  
       pokladhd.nzaklDan_2, pokladhd.nsazDan_2  	   
       from vykdph_i 
       left join pokladhd on vykdph_i.cdenik  = pokladhd.cdenik and
	                         vykdph_i.ndoklad = pokladhd.ndoklad
       where vykdph_i.nrok = 2014 and vykdph_i.nobdobi = 9 	   
	   order by vykdph_i.cdenik, vykdph_i.ndoklad			   

// fakpriHD cdenik = D
select vykdph_i.cdenik   , vykdph_i.ndoklad, 
       vykdph_i.ntyp_Dph, vykdph_i.nradek_Dph, vykdph_i.nzakld_Dph, vykdph_i.nsazba_Dph,
       fakprihd.ndoklad, 
       fakprihd.nzaklDan_1, fakprihd.nsazDan_1,  
       fakprihd.nzaklDan_2, fakprihd.nsazDan_2  	   
       from vykdph_i 
       left join fakprihd on vykdph_i.cdenik  = fakprihd.cdenik and
	                         vykdph_i.ndoklad = fakprihd.ndoklad
       where vykdph_i.nrok = 2014 and vykdph_i.nobdobi = 9 	   
	   order by vykdph_i.cdenik, vykdph_i.ndoklad		
		
	   
	   
