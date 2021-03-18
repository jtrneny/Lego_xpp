update pvpitem set dpohpvp = ddatpvp      ;
update pvpitem set pvpitem.ddatpvp = pvphead.ddatpvp from pvphead where pvpitem.nrok = pvphead.nrok and 
                                                                         pvpitem.ndoklad = pvphead.ndoklad