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
 where ndruhmzdy = 409 or ndruhmzdy = 420  ;

update druhymzd set mdefNap = ''   ;
update druhymzd set mdefNap = 'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnydoklad' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->ndnyodprpd := mzdyhd->ndnyodprpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhoddoklad' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhoddoklad' +char(13) +char(10) +            
                              'mzdyhd->nhododprac := mzdyhd->nhododprac +mzdyit->nhoddoklad' 
                where ndruhmzdy = 109 
;

update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) + 
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnydoklad' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->ndnyodprpd := mzdyhd->ndnyodprpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhoddoklad' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhoddoklad' +char(13) +char(10) +            
                              'mzdyhd->nhododprac := mzdyhd->nhododprac +mzdyit->nhoddoklad' 
                where (ndruhmzdy >= 110 and ndruhmzdy <= 129) or (ndruhmzdy >= 170 and ndruhmzdy <= 179)  or (ndruhmzdy >= 210 and ndruhmzdy <= 299)
;

update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->nmzdpripl  := mzdyhd->nmzdpripl  +mzdyit->nmzda' +char(13) +char(10) +                  
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' +char(13) +char(10) +              
                              'mzdyhd->nhodpripl  := mzdyhd->nhodpripl  +mzdyit->nhoddoklad'
                where ndruhmzdy >= 130 and ndruhmzdy <= 149  
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
                where ndruhmzdy >= 150 and ndruhmzdy <= 169  
;

update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) + 
                              'mzdyhd->nmzdnahrad := mzdyhd->nmzdnahrad +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnydoklad' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhoddoklad' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhoddoklad' +char(13) +char(10) +            
                              'mzdyhd->ndnydovbpd := mzdyhd->ndnydovbpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->ndnynahrpd := mzdyhd->ndnynahrpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->nhodnahrad := mzdyhd->nhodnahrad +mzdyit->nhoddoklad'    
                where (ndruhmzdy >= 183 and ndruhmzdy <= 189)
;

update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) + 
                              'mzdyhd->nmzdnahrad := mzdyhd->nmzdnahrad +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnydoklad' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhoddoklad' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhoddoklad' +char(13) +char(10) +            
                              'mzdyhd->ndnydovbpd := mzdyhd->ndnydovbpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->ndnynahrpd := mzdyhd->ndnynahrpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->nhodnahrad := mzdyhd->nhodnahrad +mzdyit->nhoddoklad'    
                where ndruhmzdy = 180 
;


update druhymzd set mdefNap = 'mzdyhd->nhrubamzda := mzdyhd->nhrubamzda +mzdyit->nmzda' +char(13) +char(10) +          
                              'mzdyhd->ndanzaklmz := mzdyhd->ndanzaklmz +mzdyit->nmzda' +char(13) +char(10) +
                              'mzdyhd->nnapminmzd := mzdyhd->nnapminmzd +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklsocpo := mzdyhd->nzaklsocpo +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nzaklzdrpo := mzdyhd->nzaklzdrpo +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->nmzdzaklad := mzdyhd->nmzdzaklad +mzdyit->nmzda' +char(13) +char(10) + 
                              'mzdyhd->nmzdnahrad := mzdyhd->nmzdnahrad +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ncistprije := mzdyhd->ncistprije +mzdyit->nmzda' +char(13) +char(10) +        
                              'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->nsuphmmz   := mzdyhd->nsuphmmz   +mzdyit->nmzda' +char(13) +char(10) +         
                              'mzdyhd->ndnyfondkd := mzdyhd->ndnyfondkd +mzdyit->ndnydoklad' +char(13) +char(10) +             
                              'mzdyhd->ndnyfondpd := mzdyhd->ndnyfondpd +mzdyit->ndnydoklad' +char(13) +char(10) +            
                              'mzdyhd->nhodfondkd := mzdyhd->nhodfondkd +mzdyit->nhoddoklad' +char(13) +char(10) +             
                              'mzdyhd->nhodfondpd := mzdyhd->nhodfondpd +mzdyit->nhoddoklad' +char(13) +char(10) +            
                              'mzdyhd->ndnydovmpd := mzdyhd->ndnydovmpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->ndnynahrpd := mzdyhd->ndnynahrpd +mzdyit->ndnydoklad' +char(13) +char(10) +    
                              'mzdyhd->nhodnahrad := mzdyhd->nhodnahrad +mzdyit->nhoddoklad'    
                where ndruhmzdy = 181 
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


update druhymzd set mdefNap = 'mzdyhd->ncastkvypl := mzdyhd->ncastkvypl -mzdyit->nmzda' 
                where ndruhmzdy >= 500 and ndruhmzdy <= 599
;

update druhymzd  set crzn1_vyhm = Replace( crzn1_vyhm, 'MsPrc_Mz', 'msprc_mo'),crzn2_vyhm = Replace( crzn2_vyhm, 'MsPrc_Mz', 'msprc_mo')  ;  
update druhymzd  set crzn3_vyhm = Replace( crzn3_vyhm, 'MsPrc_Mz', 'msprc_mo'),crzn4_vyhm = Replace( crzn4_vyhm, 'MsPrc_Mz', 'msprc_mo')  ;

update druhymzd set CRZN1_VYHM = 'fSazPRM('+'"'+'nHodPrumPP'+'"'+ ')' where Replace(CRZN1_VYHM,' ','') = 'msprc_mo->nHodPrumPP'  ;
update druhymzd set CRZN1_VYHM = 'fSazPRM('+'"'+'nDenPrumPP'+'"'+ ')' where Replace(CRZN1_VYHM,' ','') = 'msprc_mo->nDenPrumPP'  ; 

update druhymzd set CRZN2_VYHM = 'fSazPRM('+'"'+'nHodPrumPP'+'"'+ ')' where Replace(CRZN2_VYHM,' ','') = 'msprc_mo->nHodPrumPP'  ;
update druhymzd set CRZN2_VYHM = 'fSazPRM('+'"'+'nDenPrumPP'+'"'+ ')' where Replace(CRZN2_VYHM,' ','') = 'msprc_mo->nDenPrumPP'  ;


update druhymzd  set cdenik = 'MH' where ndruhmzdy >=   0 and ndruhmzdy <= 399   ;
update druhymzd  set cdenik = 'MN' where ndruhmzdy >= 400 and ndruhmzdy <= 499   ;
update druhymzd  set cdenik = 'MS' where ndruhmzdy >= 500 and ndruhmzdy <= 599   ;
update druhymzd  set cdenik = 'MC' where ndruhmzdy >= 600;
update druhymzd  set lAutoVypHM = true where ndruhmzdy = 120 or ndruhmzdy = 122 or ndruhmzdy = 127 or ndruhmzdy = 150 or ndruhmzdy = 156 or ndruhmzdy = 199;

update druhymzd  set  nPrNapPpMz = P_KCSPRACP    ;
update druhymzd  set  nPrNapPpHo = P_HODPRPRA    ;
update druhymzd  set  nPrNapPpDn = P_KCSPRESC    ;

update druhymzd  set  cucetskup  = Convert(ndruhmzdy,SQL_CHAR)    ;

update druhymzd set ctyppohzav='GENODVSOC'  where czkrtrvpla = 'SocPo'      ;
update druhymzd set ctyppohzav='GENODVZDR'  where czkrtrvpla = 'ZdrPo'      ;
update druhymzd set ctyppohzav='GENODVDANZ' where czkrtrvpla = 'ZaDan'      ;
update druhymzd set ctyppohzav='GENODVDANS' where czkrtrvpla = 'SrDan'      ;
//update druhymzd set ctyppohzav='GENODVZAPO' where czkrtrvpla =        ;

update druhymzd set nNapocFPD = 1 where
     ndruhmzdy = 109 or
     ndruhmzdy = 110 or
     ndruhmzdy = 111 or
     ndruhmzdy = 112 or
     ndruhmzdy = 113 or
     ndruhmzdy = 114 or
     ndruhmzdy = 119 or
     ndruhmzdy = 120 or
     ndruhmzdy = 121 or
     ndruhmzdy = 122 or
     ndruhmzdy = 123 or
     ndruhmzdy = 124 or
     ndruhmzdy = 170 or
     ndruhmzdy = 171 or
     ndruhmzdy = 172 or
     ndruhmzdy = 173 or
     ndruhmzdy = 174 or
     ndruhmzdy = 180 or
     ndruhmzdy = 181 or
     ndruhmzdy = 182 or
     ndruhmzdy = 183 or
     ndruhmzdy = 184 or
     ndruhmzdy = 185 or
     ndruhmzdy = 186 or
     ndruhmzdy = 187 or
     ndruhmzdy = 188 or
     ndruhmzdy = 184 or
     ndruhmzdy = 205 or
     ndruhmzdy = 209 or
     ndruhmzdy = 210 or
     ndruhmzdy = 211 or
     ndruhmzdy = 212 or
     ndruhmzdy = 213 or
     ndruhmzdy = 214 or
     ndruhmzdy = 215 or
     ndruhmzdy = 269 or
     ndruhmzdy = 270 or
     ndruhmzdy = 290 or
     ndruhmzdy = 400 or
     ndruhmzdy = 409 or
     ndruhmzdy = 410 or
     ndruhmzdy = 411 or
     ndruhmzdy = 419 or
     ndruhmzdy = 420 or
     ndruhmzdy = 421              ;


