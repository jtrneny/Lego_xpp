INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'3',1,'l',3.00
          FROM cenzboz where NKOEFMN = 3   ;

INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'1',1,'l',1.00
          FROM cenzboz where NKOEFMN = 1  ;

INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'.75',1,'l',0.75
          FROM cenzboz where NKOEFMN = 0.75  ;

INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'.5',1,'l',0.5
          FROM cenzboz where NKOEFMN = 0.5  ;

INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'.38',1,'l',0.38
          FROM cenzboz where NKOEFMN = 0.38  ;


INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'.37',1,'l',0.37
          FROM cenzboz where NKOEFMN = 0.37  ;

INSERT INTO c_prepmj ( cCisSklad, csklpol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
        SELECT cCisSklad, csklpol,1,'.2',1,'l',0.2
          FROM cenzboz where NKOEFMN = 0.2  ;
