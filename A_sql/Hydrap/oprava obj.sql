update objitem set objitem.ctypdoklad = objhead.ctypdoklad, objitem.ctyppohybu = objhead.ctyppohybu from objhead where objitem.ndoklad = objhead.ndoklad  ;
update fakvysit set fakvysit.ncisloobjp = objitem.ndoklad from objitem where fakvysit.ccislobint=objitem.ccislobint  ;
update pvpitem set pvpitem.ncisloobjp = fakvysit.ncisloobjp,pvpitem.ncislpolob = fakvysit.ncislpolob from fakvysit where pvpitem.ncisfak=fakvysit.ndoklad and 
                                                                                                                         pvpitem.nintcount=fakvysit.nintcount  