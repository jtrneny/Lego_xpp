update msprc_mo set ltiskmzdli = false where cobdobi = '12/17'  ;
update msprc_mo set ltiskmzdli = true from mzdyhd where msprc_mo.cobdobi = '12/17' and 
                 msprc_mo.nrok=mzdyhd.nrok and msprc_mo.noscisprac=mzdyhd.noscisprac and
				  msprc_mo.nporpravzt=mzdyhd.nporpravzt  