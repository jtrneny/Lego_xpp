update msprc_mo set lGenerELDP = false where cobdobi = '12/13'   ;
update msprc_mo set lGenerELDP = true from mzdyhd where msprc_mo.cobdobi = '12/13' and 
                 msprc_mo.nrok=mzdyhd.nrok and msprc_mo.noscisprac=mzdyhd.noscisprac and
				  msprc_mo.nporpravzt=mzdyhd.nporpravzt  