// update objHead set objHead.nmnozOBodb = 
//  ( select sum(nmnozOBodb) from objitem where objHead.ccislOBint = objitem.ccislOBint ),
//  objHead.nmnozPLodb = 
//  ( select sum(nmnozPLodb) from objitem where objHead.ccislOBint = objitem.ccislOBint )    ;

// update objHead set objHead.ndoklad    = (((YEAR(objHead.ddatObj) * 100000) + 70000) + objhead.sid), 
//                    objHead.culoha     = 'V',
//                    objHead.ctask      = 'VYR', 
//                    objHead.ctypdoklad = 'VYR_ZADMAT',
//                    objHead.ctyppohybu = 'ZADANMAT'
//                 where ndoklad = 0 and ncisfirmy = 1        ;
              
 update objItem set objItem.ndoklad    = objHead.ndoklad, 
                    objItem.culoha     = objHead.culoha,
					objItem.ctask      = objHead.ctask,
                    objItem.ctypdoklad = objHead.ctypdoklad,
                    objItem.ctyppohybu = objHead.ctyppohybu
                 from objHead
                 where objItem.ccislObInt = objHead.ccislObInt
