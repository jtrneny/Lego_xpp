update druhymzd set
 mblock = '[GENIT]
            bFor       ="nPremMzd <> 0"
            dbFrom     ="mzdDavItw"
            ndruhMzdy  = 150
            nMzda      = nPremMzd  
            nhrubaMzda = nPremMzd' 
 where ndruhmzpre = 150    ;

update druhymzd set
 mblock = '[GENIT]
            bFor       = "nPremMzd <> 0"
            dbFrom     = "mzdDavItw"
            ndruhMzdy  = 151
            nMzda      = nPremMzd 
            nhrubaMzda = nPremMzd'
 where ndruhmzpre = 151 ;

update druhymzd set
 mblock = '[GENIT]
            bFor       = "nNemocCelk<> 0"
            dbFrom     = "mzdDavItw"
            cdenik     = "MH"
            ndruhMzdy  = 309
            nMzda      = nNemocCelk'
 where ndruhmzdy = 409 or ndruhmzdy = 420

