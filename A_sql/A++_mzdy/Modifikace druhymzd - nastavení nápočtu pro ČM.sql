update druhymzd set mdefNap = ''   ;
update druhymzd set mdefNap = 'mzdyhd->nhrubamzda    += mzdyit->nmzda          
mzdyhd->ndanzaklmz    += mzdyit->nmzda          
mzdyhd->nzaklsocpo    += mzdyit->nmzda          
mzdyhd->nzaklzdrpo    += mzdyit->nmzda          
mzdyhd->nmzdzaklad    += mzdyit->nmzda
mzdyhd->ncistprije    += mzdyit->nmzda          
mzdyhd->ncastkvypl    += mzdyit->nmzda          
mzdyhd->nsuphmmz      += mzdyit->nmzda' where ndruhmzdy < 190   ; 
update druhymzd set mdefNap = 'mzdyhd->nhrubamzda    += mzdyit->nmzda          
mzdyhd->ndanzaklmz    += mzdyit->nmzda          
mzdyhd->nzaklsocpo    += mzdyit->nmzda          
mzdyhd->nzaklzdrpo    += mzdyit->nmzda          
mzdyhd->nmzdzaklad    += mzdyit->nmzda
mzdyhd->ncistprije    += mzdyit->nmzda          
mzdyhd->ncastkvypl    += mzdyit->nmzda          
mzdyhd->nsuphmmz      += mzdyit->nmzda' where ndruhmzdy > 209 and ndruhmzdy < 300  ;            
update druhymzd set mdefNap = 'mzdyhd->ncistprije    -= mzdyit->nmzda          
mzdyhd->ncastkvypl    -= mzdyit->nmzda' where ndruhmzdy > 399 and ndruhmzdy < 599              
         
