update druhymzd set mdefNap = ''   ;
update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) + 
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' 
                where ndruhmzdy < 190   
;
update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' 
                where ndruhmzdy > 209 and ndruhmzdy < 300  
;
update druhymzd set mdefNap = 'mzdyhd->ncistprije := mzdyhd->ncistprije -mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl -mzdyit->nmzda' 
                where ndruhmzdy > 399 and ndruhmzdy < 599
;