update msprc_mo set lstavrok = .f., nstavrok = 0                         ; 
update msosb_mo set lstavrok = .f., nstavrok = 0                         ; 

update msprc_mo set lstavrok = .t., nstavrok = 1 
   			    where empty(ddatvyst) or year(ddatvyst) >= nrok         ;     

update msprc_mo set msprc_mo.nmsosb_mo = msosb_mo.sid from msosb_mo where 
                            msprc_mo.nrokobd = msosb_mo.nrokobd and  
							  msprc_mo.noscisprac = msosb_mo.noscisprac   ;
							  
update msosb_mo set msosb_mo.lstavrok = msprc_mo.lstavrok,
                    msosb_mo.nstavrok = msprc_mo.nstavrok
                       from msprc_mo where 
                            msosb_mo.nrokobd = msprc_mo.nrokobd and  
							  msosb_mo.noscisprac = msprc_mo.noscisprac and
							   msprc_mo.lstavrok							    