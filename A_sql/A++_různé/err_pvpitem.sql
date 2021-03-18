select a.ndoklad, a.ccissklad, a.csklpol, a.cucetskup, b.cucetskup from pvpitem as a, cenzboz as b 
where a.ccissklad  = b.ccissklad and 
      a.csklpol    = b.csklpol   and 
	  a.cucetskup <> b.cucetskup and a.nrok = 2007 