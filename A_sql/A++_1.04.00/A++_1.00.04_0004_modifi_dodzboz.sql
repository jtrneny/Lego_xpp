UPDATE dodzboz SET tVznikZazn = now(), tZmenaZazn = now() ;

CREATE TRIGGER zmena_tzmenazazn
   ON dodzboz
   AFTER 
   UPDATE 
   BEGIN 
      UPDATE dodzboz SET tZmenaZazn = now() WHERE nCisFirmy = ( SELECT nCisFirmy FROM __new) and cCisSklad = ( SELECT cCisSklad FROM __new) and cSklPol = ( SELECT cSklPol FROM __new);
   END 
   PRIORITY 2;

CREATE TRIGGER zmena_tvznikzazn
   ON dodzboz
   AFTER 
   INSERT 
   BEGIN 
      UPDATE dodzboz SET tZmenaZazn = now() WHERE nCisFirmy = ( SELECT nCisFirmy FROM __new) and cCisSklad = ( SELECT cCisSklad FROM __new) and cSklPol = ( SELECT cSklPol FROM __new);
   END 
   PRIORITY 1;

CREATE TRIGGER [zrušení záznamu]
   ON dodzboz
   AFTER 
   DELETE 
   BEGIN 
      INSERT INTO D_dodzboz( nCisFirmy, cCisSklad, cSklPol, mUserZmenR, tVznikZazn) SELECT nCisFirmy, cCisSklad, cSklPol, mUserZmenR, Now() as tVznikZazn FROM __old;
   END 
   PRIORITY 1;

