update c_typpoh  set c_typpoh.csubtask = 'FIN'                                    where c_typpoh.culoha='E' and c_typpoh.ctyppohybu='DLSKLVYDEJ'     ;
update dodlsthd   set dodlsthd.ctask = 'PRO', dodlsthd.csubtask = 'FIN'  where dodlsthd.culoha='E'  and dodlsthd.ctyppohybu='DLSKLVYDEJ'      ;
update dodlstit     set dodlstit.ctask = 'PRO', dodlstit.csubtask = 'FIN'     where dodlstit.culoha='E'    and dodlstit.ctyppohybu='DLSKLVYDEJ'        ;
update pvphead   set pvphead.csubtask  = 'FIN'                                    where culoha='S' and ctyppohybu='150'     ;
update pvpitem    set pvpitem.csubtask  = 'FIN'                                    where culoha='S' and ctyppohybu='150'     ;
update pvphead   set pvphead.csubtask  = 'PRO'                                   where culoha='S' and ctyppohybu='151'     ;
update pvpitem    set pvpitem.csubtask  = 'PRO'                                   where culoha='S' and ctyppohybu='151'     ;
