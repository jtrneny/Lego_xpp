CREATE TRIGGER Kontrola_CEN_after_update
   ON cenzboz
   AFTER 
   UPDATE 
   BEGIN 
       
      insert into pvp_item(ccisSklad, csklPol, nmnozSZbo,nmnozDZbo,nmnozprd_O,ntypZmeny)
       select ccisSklad ,
              csklPol   , 
              nmnozSZbo ,
              nmnozDZbo ,          
              (select nmnozSZbo from __old),
              0       
        from __new WHERE sID = (SELECT sID FROM __new);
   
   END 
   PRIORITY 1;
