update msprc_mo set msprc_mo.cprijosob = osoby.cprijosob,
                    msprc_mo.cjmenoosob = osoby.cjmenoosob,
					msprc_mo.cosoba = osoby.cosoba,
					msprc_mo.ctitulpred = osoby.ctitulpred,
					msprc_mo.ctitulza = osoby.ctitulza,
					msprc_mo.cjmenorozl = osoby.cjmenorozl,
					msprc_mo.nosoby = osoby.sid from osoby where msprc_mo.noscisprac=osoby.noscisprac  