update pvpitem set pvpitem.nCisloOBJV = objvyshd.ndoklad
			    from objvyshd 
                 where pvpitem.ccisobj = objvyshd.ccisobj      ;
update objvyshd set nMnozPlDod = nMnozObDod		;		 
update objvysit set nMnozPlDod = nMnozObDod				 
   