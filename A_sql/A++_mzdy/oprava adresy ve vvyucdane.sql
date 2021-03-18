update vyucdane set vyucdane.culice=osoby.culice, 
                    vyucdane.ccispopis=osoby.ccispopis,
					vyucdane.culiccipop=osoby.culiccipop,
					vyucdane.cmisto=osoby.cmisto,
					vyucdane.czkratstat=osoby.czkratstat
			from osoby where nrok=2013 and vyucdane.nosoby=osoby.sid		