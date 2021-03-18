UPDATE c_sklady SET tVznikZazn = now(), tZmenaZazn = now()  ;

CREATE TRIGGER zmena_tzmenazazn
   ON c_sklady
   AFTER 
   UPDATE 
   BEGIN 
      UPDATE C_Sklady SET tZmenaZazn = now() WHERE cCisSklad = ( SELECT cCisSklad FROM __new);
   END 
   PRIORITY 2;

CREATE TRIGGER zmena_tvznikzazn
   ON c_sklady
   AFTER 
   INSERT 
   BEGIN 
      UPDATE C_Sklady SET tVznikZazn = now() WHERE cCisSklad = ( SELECT cCisSklad FROM __new);
   END 
   PRIORITY 1;

CREATE TRIGGER [zrušení záznamu]
   ON c_sklady
   AFTER 
   DELETE 
   BEGIN 
      INSERT INTO D_C_Sklady( cCisSklad, mUserZmenR, tVznikZazn) SELECT cCisSklad, mUserZmenR, Now() as tVznikZazn FROM __old;
 
   END 
   PRIORITY 1;

