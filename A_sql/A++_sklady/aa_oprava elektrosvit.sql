delete from pvphead where ndoklad=15020122 or ndoklad=15020123 or ndoklad=15020124 or ndoklad=15020125  ;
delete from pvpitem where ndoklad=15020122 or ndoklad=15020123 or ndoklad=15020124 or ndoklad=15020125  ;
delete from ucetpol where (ndoklad=15020122 or ndoklad=15020123 or ndoklad=15020124 or ndoklad=15020125) and cdenik = 'S' ;
update pvphead set ntyppoh=4,ntyppvp=4,ntyppohyb=1 where ctyppohybu='17'
  