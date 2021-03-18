SELECT ccisSklad, cSklpol 
       FROM cenzboz WHERE cenzboz.ccissklad='51' and
	    cenzboz.csklpol NOT IN 
       (SELECT c_prepmj.csklPol 
            FROM cenzboz,c_prepmj WHERE ( cenzboz.ccisSklad = c_prepmj.ccisSklad and
                            cenzboz.csklPol   = c_prepmj.csklPol )    )
