update dodzboz set dodzboz.ckatczbo=objvysit.ckatczbo from objvysit 
   where dodzboz.ckatczbo = '' and objvysit.ckatczbo <> ''
         and dodzboz.ncisfirmy = objvysit.ncisfirmy 
          and dodzboz.ccissklad = objvysit.ccissklad
		   and dodzboz.csklpol = objvysit.csklpol
		     