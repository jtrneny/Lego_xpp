update defvykit set ntypzaokr = 1 where ( mvyraz = '' or mvyraz is null ) and 
                                          ( mvyber <> '' ) and cidvykazu = 'DIST000079'   ;
update defvykit set nkodzaokr = 0 where ( mvyraz <> ''  ) and 
                                          ( mvyber = '' or mvyber is null ) and cidvykazu = 'DIST000079'    
										      
//select * from defvykit where mvyraz = '' or mvyraz is null  