update pvphead   set ctask = 'SKL'                          ;
update pvphead   set csubtask = 'FIN' where ctyppohybu='150'   ;
update pvphead   set csubtask = 'PRO' where ctyppohybu='151'   ;
update pvpitem   set ctask = 'SKL'                          ;
update pvpitem   set csubtask = 'FIN' where ctyppohybu='150'   ;
update pvpitem   set csubtask = 'PRO' where ctyppohybu='151'   ;
update c_typpoh  set csubtask = 'FIN' where ctyppohybu='150'  ;
update c_typpoh  set csubtask = 'PRO' where ctyppohybu='151'

