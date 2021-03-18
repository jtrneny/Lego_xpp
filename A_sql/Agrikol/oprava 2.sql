update BANVYPIT set CUCET_UCT = '321200' where czkratmenf = 'EUR' and CUCET_UCT = '321000'   ;
update BANVYPIT set CUCET_UCT = '314200' where czkratmenf = 'EUR' and CUCET_UCT = '314000'   ;

delete from ucetpol where culoha = 'S'  ;

update pokladhd set CUCET_UCT = '211100' where  CUCET_UCT = '211000'   ;
update ucetpol set cucetmd = '211100' where  cdenik = 'P' and cucetmd = '211000'   ;
update ucetpol set cucetdal = '211100' where  cdenik = 'P' and cucetdal = '211000'   ;

update banvyphd set CUCET_UCT = '221100' where  CUCET_UCT = '221000' and ndoklad >= 16000001 and ndoklad <= 16000159 ;
update ucetpol set cucetmd = '221100' where  cdenik = 'B' and cucetmd = '221000' and ndoklad >= 16000001 and ndoklad <= 16000159   ;
update ucetpol set cucetdal = '221100' where  cdenik = 'B' and cucetdal = '221000' and ndoklad >= 16000001 and ndoklad <= 16000159  ;

update banvyphd set CUCET_UCT = '221200' where  CUCET_UCT = '221000' and ndoklad >= 16400001 and ndoklad <= 16400159 ;
update ucetpol set cucetmd = '221200' where  cdenik = 'B' and cucetmd = '221000' and ndoklad >= 16400001 and ndoklad <= 16400159   ;
update ucetpol set cucetdal = '221200' where  cdenik = 'B' and cucetdal = '221000' and ndoklad >= 16400001 and ndoklad <= 16400159  ;

update banvyphd set CUCET_UCT = '221300' where  CUCET_UCT = '221000' and ndoklad >= 16500001 and ndoklad <= 16500159 ;
update ucetpol set cucetmd = '221300' where  cdenik = 'B' and cucetmd = '221000' and ndoklad >= 16500001 and ndoklad <= 16500159   ;
update ucetpol set cucetdal = '221300' where  cdenik = 'B' and cucetdal = '221000' and ndoklad >= 16500001 and ndoklad <= 16500159  ;

update banvypit set CUCET_UCT = '261100' where  CUCET_UCT = '261000'  ;
update ucetpol set cucetmd = '261100' where  cdenik = 'B' and cucetmd = '261000'    ;
update ucetpol set cucetdal = '261100' where  cdenik = 'B' and cucetdal = '261000'  ;

update banvypit set CUCET_UCT = '314100' where  CUCET_UCT = '314000'  ;
update ucetpol set cucetmd = '314100' where  cdenik = 'B' and cucetmd = '314000'    ;
update ucetpol set cucetdal = '314100' where  cdenik = 'B' and cucetdal = '314000'  ;

update ucetpol set cucetmd = '321100' where  cucetmd = '321110'    ;
update ucetpol set cucetdal = '321100' where  cucetdal = '321110'  ;

update ucetpol set cucetmd = '668000' where  cucetmd = '668220'    ;
update ucetpol set cucetdal = '668000' where  cucetdal = '668220'  ;


