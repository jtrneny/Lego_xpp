//update ucetpol set norditem=-106, npoluctpr=2 where cdenik='D' and norditem=-202  ;
//update ucetpol set npoluctpr=1 where cdenik='D' and norditem=1  ;
//update ucetpol set npoluctpr=4 where cdenik='D' and norditem>=1000  ;
//update ucetpol set norditem=-3,npoluctpr=3,ctypuct='FP_HALVYR' where cdenik = 'D' and (cucetmd='568000' or cucetdal='568000')
//update ucetpol set norditem=-107, npoluctpr=2,ctypuct='FP_DPH' where cdenik='D' and norditem=-101  ;
//update ucetpol set norditem=1100, ctypuct='FP_ZALOHY' where cdenik='D' and norditem=1000 and (left(cucetmd,3)='314' or left(cucetmd,3)='314') and cdenik='D'  ;
//update ucetpol set norditem=1200, ctypuct='FP_ZALOHY' where cdenik='D' and norditem=1001 and (left(cucetmd,3)='314' or left(cucetmd,3)='314') and cdenik='D'  ;
//update ucetpol set norditem=1300, ctypuct='FP_ZALOHY' where cdenik='D' and norditem=1002 and (left(cucetmd,3)='314' or left(cucetmd,3)='314') and cdenik='D'  ;
//update ucetpol set norditem=1400, ctypuct='FP_ZALOHY' where cdenik='D' and norditem=1003 and (left(cucetmd,3)='314' or left(cucetmd,3)='314') and cdenik='D'  ;
//update ucetpol set ctypuct='FP_DPH' where cdenik='D' and (left(cucetmd,3)='343' or left(cucetmd,3)='343') and cdenik='D'  ;
update ucetpol set ctypuct='FP_NAKLAD' where cdenik='D' and norditem=1  ;
