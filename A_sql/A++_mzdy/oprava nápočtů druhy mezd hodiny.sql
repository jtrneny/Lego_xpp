update druhymzd set mdefNap = 'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnyfondpd' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnyfondpd' +char(13) +char(10) +            
                              'mzdyhd->ndnyodprpd := mzdyhd->ndnyodprpd +mzdyit->ndnyfondpd' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhodfondpd' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhodfondpd' +char(13) +char(10) +            
                              'mzdyhd->nhododprac := mzdyhd->nhododprac +mzdyit->nhodfondpd' 
                where ndruhmzdy = 109 
;

update druhymzd set mdefNap = mdefNap +         
                              'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnyfondpd' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnyfondpd' +char(13) +char(10) +            
                              'mzdyhd->ndnyodprpd := mzdyhd->ndnyodprpd +mzdyit->ndnyfondpd' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhodfondpd' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhodfondpd' +char(13) +char(10) +            
                              'mzdyhd->nhododprac := mzdyhd->nhododprac +mzdyit->nhodfondpd' 
                where (ndruhmzdy >= 110 and ndruhmzdy <= 129) or (ndruhmzdy >= 170 and ndruhmzdy <= 179)  or (ndruhmzdy >= 210 and ndruhmzdy <= 299)
;
