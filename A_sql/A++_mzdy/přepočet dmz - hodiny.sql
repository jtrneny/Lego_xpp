update mzdyit set mzdyit.nhoddoklad = mzdyit.ndnydoklad * c_pracdo.nhodden
               from mzdyit,msprc_mo,c_pracdo where mzdyit.nrok = 2014 and mzdyit.ndruhmzdy = 183 and
                    mzdyit.nmsprc_mo = msprc_mo.sid and msprc_mo.cdelkprdob = c_pracdo.cdelkprdob