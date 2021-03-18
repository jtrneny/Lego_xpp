CREATE TRIGGER Kontrola_PVP_after_insert
   ON pvpitem
   AFTER 
   INSERT 
   BEGIN 
       
      insert into pvp_item(ccisSklad, csklPol, ctypDoklad, ntypPoh, ndoklad, norditem, nmnozPrD_N, nmnozSZbo, ntypZmeny)
       select ccisSklad ,
              csklPol   , 
              ctypDoklad, 
              nTypPoh   , 
              ndoklad   ,
              norditem  , 
              nmnozPrDod, 
              nmnozSZbo,
              1              
        from __new WHERE sID = (SELECT sID FROM __new)   ;
   
   END 
   PRIORITY 1;

CREATE TRIGGER Kontrola_PVP_after_update
   ON pvpitem
   AFTER 
   UPDATE 
   BEGIN 
       
      insert into pvp_item(ccisSklad, csklPol, ctypDoklad, ntypPoh, ndoklad, norditem, nmnozPrD_N, nmnozSZbo, ntypZmeny, nmnozPrD_O)
       select ccisSklad ,
              csklPol   , 
              ctypDoklad, 
              nTypPoh   , 
              ndoklad   ,
              norditem  , 
              nmnozPrDod, 
              nmnozSZbo,
              0        ,
              (select nmnozPrDod from __old)       
        from __new WHERE sID = (SELECT sID FROM __new)   
          
                    ;
   
   END 
   PRIORITY 1;

CREATE TRIGGER Kontrola_PVP_after_delete
   ON pvpitem
   AFTER 
   DELETE 
   BEGIN 
       
      insert into pvp_item(ccisSklad, csklPol, ctypDoklad, ntypPoh, ndoklad, norditem, nmnozPrD_N, nmnozSZbo, ntypZmeny)
       select ccisSklad ,
              csklPol   , 
              ctypDoklad, 
              nTypPoh   , 
              ndoklad   ,
              norditem  ,  
              nmnozPrDod, 
              nmnozSZbo,
              -1              
        from __old WHERE sID = (SELECT sID FROM __old)   ;
   
   END 
   PRIORITY 1;
