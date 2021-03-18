update majz set majz.nuctodpmes=majz_.nuctodpmes,
                majz.nuctodprok=majz_.nuctodprok,
				majz.nprocmesUO=majz_.nprocmesuo,
                majz.codpisskd=majz_.codpisskd,				
                majz.nodpisskd=majz_.nodpisskd,				
                majz.nodpissk=majz_.nodpissk,
				majz.nopruct=majz_.nopruct,
				majz.nopructps=majz_.noopructps,
				majz.nznakt=majz_.nznakt						
from majz_ where majz.cnazpol6='1' and majz.ninvcis=majz_.ninvcis 