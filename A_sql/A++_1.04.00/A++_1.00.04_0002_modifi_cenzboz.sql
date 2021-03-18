UPDATE cenzboz SET tVznikZazn = now(), tZmenaZazn = now() ;

CREATE TRIGGER zmena_tzmenazazn
   ON cenzboz
   AFTER 
   UPDATE 
   BEGIN 
      UPDATE  CenZboz SET tZmenaZazn = now() WHERE cCisSklad = ( SELECT cCisSklad FROM __new) and cSklPol = ( SELECT cSklPol FROM __new);
   END 
   PRIORITY 2;

CREATE TRIGGER zmena_tvznikzazn
   ON cenzboz
   AFTER 
   INSERT 
   BEGIN 
      UPDATE  CenZboz SET tVznikZazn = now() WHERE cCisSklad = ( SELECT cCisSklad FROM __new) and cSklPol = ( SELECT cSklPol FROM __new)
;
   END 
   PRIORITY 1;

CREATE TRIGGER [zrušení záznamu]
   ON cenzboz
   AFTER 
   DELETE 
   BEGIN 
      INSERT INTO D_CenZboz( cCisSklad, cSklPol, mUserZmenR, tVznikZazn) SELECT cCisSklad, cSklPol, mUserZmenR, Now() as tVznikZazn FROM __old;
   END 
   PRIORITY 1;

UPDATE cenzboz SET tVznikZazn = now(), tZmenaZazn = now() 
