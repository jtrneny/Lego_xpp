select ucetpol.csymbol,ucetpol.cobdobi,ucetpol.cucetmd,fakprihd.ncisfak
  from ucetpol,fakprihd
       where ucetpol.cobdobi='10/10' and ucetpol.cdenik='D' and ucetpol.cobdobi=fakprihd.cobdobi and ucetpol.ndoklad=fakprihd.ndoklad
	         and ucetpol.norducto=2
	 and ucetpol.csymbol <> CAST(fakprihd.ncisfak as SQL_CHAR) and substring(cucetmd,1,3)='321'
	           
