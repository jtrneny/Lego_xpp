update msprc_mo set msprc_mo.nmsosb_mo = msosb_mo.sid from msosb_mo
                                 where msprc_mo.nrok = msosb_mo.nrok and
								        msprc_mo.nobdobi = msosb_mo.nobdobi and 
										  msprc_mo.noscisprac = msosb_mo.noscisprac  
										  