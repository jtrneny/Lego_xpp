update msmzdyhd set laktivni=true, nautogen=4  where nkeyMatr = 10 and cTypMasky='GENDO';
update msmzdyit set laktivni=true, cTypMasky='GENDO', nautogen=4 where nkeyMatr = 10 ;
update msmzdyit set msmzdyit.nmsmzdyhd = msmzdyhd.sid from msmzdyhd 
                 where msmzdyit.noscisprac = msmzdyhd.noscisprac and
				        msmzdyit.nporpravzt = msmzdyhd.nporpravzt and 
						  msmzdyit.nkeyMatr = 10