//update pozemky_ set pozemky_.expr = pozemky.npozemek from pozemky
//         where  pozemky_.cku_kod = pozemky.cku_kod and  
//		         pozemky_.nlistvlast = pozemky.nlistvlast and
//				  pozemky_.cparccis = pozemky.cparccis 
				  
update pozemkit set pozemkit.npozemek = pozemky.npozemek,
                     pozemkit.npozemky = pozemky.sid 
					  from pozemky
         where  pozemkit.cku_kod = pozemky.cku_kod and  
		         pozemkit.nlistvlast = pozemky.nlistvlast and
				  pozemkit.cparccis = pozemky.cparccis				  