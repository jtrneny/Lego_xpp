delete from cenprodc   ;
insert into cenprodc (nkliccenzb,ccissklad,csklpol,nzbozikat,cnazzbo,ncencnzbo,ncenapzbo,ncenamzbo,nprocmarz,ncenap1zbo,nprocmarz1,ncenap2zbo,nprocmarz2,ncenap3zbo,nprocmarz3,ncenap4zbo,nprocmarz4,ddatakt)
   select sid,ccissklad,csklpol,nzbozikat,cnazzbo,ncencnzbo,ncenapzbo,ncenamzbo,0,0,0,0,0,0,0,0,0,curdate()
     from cenzboz where ncenapzbo <> 0 or ncenamzbo <> 0 