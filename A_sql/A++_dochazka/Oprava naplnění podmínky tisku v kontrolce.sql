update c_prerus set nsayprn = 1 where c_prerus.nkodprer <= 5 or
                                      c_prerus.nkodprer =  9 or
									  c_prerus.nkodprer = 14 or
									  c_prerus.nkodprer = 18 or
									  c_prerus.nkodprer = 19 or
									  c_prerus.nkodprer = 20 or
									  c_prerus.nkodprer = 22 or
									  c_prerus.nkodprer = 23      ;
update dspohyby set dspohyby.nsayprn = c_prerus.nsayprn from c_prerus where dspohyby.ckodprer = c_prerus.ckodprer and dspohyby.cobdobi >= '08/16' ;
 
