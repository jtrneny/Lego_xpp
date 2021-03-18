CREATE TRIGGER t_PRO_vyrzakit_afterUpdate
   ON vyrzakit
   AFTER 
   UPDATE 
BEGIN 
update vyrzakpl set vyrzakpl.cstavZakaz = __new.cstavzakaz 
       from __new 
       where vyrzakpl.cciszakazi = __new.cciszakazi;

//                     vyrzakpl.lzavren    = (__new.cstavzakaz = 'U' or __new.cstavzakaz = 'R' or __new.cstavzakaz = '0' )

update cnazPol3 set cnazPol3.cstavZakaz = __new.cstavzakaz,
                    cnazPol3.lzavren    = (__new.cstavzakaz = 'U' or __new.cstavzakaz = 'R' or __new.cstavzakaz = '0' ) 
       from __new 
       where cnazPol3.cnazPol3 = __new.cciszakazi;








END 
   PRIORITY 1;

CREATE TRIGGER t_PRO_vyrzakit_afterInsert
   ON vyrzakit
   AFTER 
   INSERT 
BEGIN 
insert into vyrzakpl ( cCisZakazI, nCisFirmy , cNazFirmy, nCisFirDOA, cNazevDOA, 
                       cSidloDOA , cCisloObj , cStavZakaz, nCisOsOdp, cJmeOsOdp , dZapis   , 
                       dOdvedZaka, dMozOdvZak, dSkuOdvZak )
            select     cCisZakazI, nCisFirmy , cNazFirmy, nCisFirDOA, cNazevDOA, 
                       cSidloDOA , cCisloObj , cStavZakaz, nCisOsOdp, cJmeOsOdp , dZapis   , 
                       dOdvedZaka, dMozOdvZak, dSkuOdvZak
            from __new;

insert into cnazpol3 ( cnazpol3  , cnazev    , ccisZakaz )
            select     ccisZakazI, cnazevZak1, ccisZakaz
            from __new;




END 
   PRIORITY 1;