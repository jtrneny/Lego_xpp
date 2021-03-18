select ucetpocs.cucetmd,ucetpocs.cnazpol1,ucetpocs.cnazpol2,ucetpocs.cnazpol3,ucetpocs.nkcmdpsr,ucetpocs_.nkcmdpsr,ucetpocs.nkcdalpsr,ucetpocs_.nkcdalpsr
  from ucetpocs,ucetpocs_ where ucetpocs.cucetmd=ucetpocs_.cucetmd and ucetpocs.cnazpol1=ucetpocs_.cnazpol1 and
  ucetpocs.cnazpol2=ucetpocs_.cnazpol2 and ucetpocs.cnazpol3=ucetpocs_.cnazpol3 and
 ( ucetpocs.nkcmdpsr<>ucetpocs_.nkcmdpsr or ucetpocs.nkcdalpsr<>ucetpocs_.nkcdalpsr) and
  ucetpocs.nrok=2011 and ucetpocs.cdenik='WX' and ucetpocs.cnazpol3 <> '   ' 
