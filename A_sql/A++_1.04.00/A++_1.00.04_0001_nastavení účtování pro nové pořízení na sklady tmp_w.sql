INSERT INTO UCETPRHD(ctask,ctypdoklad,ctyppohybu,cucetskup,cnazucpred,
                      dplatnyod,mpodminka,mklikvid,mzlikvid,mpopisucpr,dvznikzazn,
					  dzmenazazn,mpoznamka,cuniqidrec,muserzmenr)
       SELECT ctask,ctypdoklad,ctyppohybu,cucetskup,cnazucpred,
              dplatnyod,mpodminka,mklikvid,mzlikvid,mpopisucpr,dvznikzazn,
			  dzmenazazn,mpoznamka,cuniqidrec,muserzmenr			
	   FROM UCETPRHD WHERE (cTask = 'SKL' and ctypdoklad <> 'SKL_VYD255');
UPDATE UCETPRHD	SET cTypDoklad = (SubString(cTypDoklad,1,3)+'-'+SubString(cTypDoklad,5,6)), culoha='S' WHERE culoha = ''  ;    

INSERT INTO UCETPRIT(ctask,ctypdoklad,cmainfile,ctyppohybu,cucetskup,cnazucpred,
                      dplatnyod,npoluctpr,nsubpoluc,ctypuct,cucetmd,cucetdal,
					  cnazpol1,cnazpol2,cnazpol3,cnazpol4,cnazpol5,cnazpol6,
					  mpodminka,mklikvid,mzlikvid,lwrtrechd,mpopisucpr,dvznikzazn,
					  dzmenazazn,mpoznamka,cuniqidrec,muserzmenr)
       SELECT ctask,ctypdoklad,cmainfile,ctyppohybu,cucetskup,cnazucpred,
                      dplatnyod,npoluctpr,nsubpoluc,ctypuct,cucetmd,cucetdal,
					  cnazpol1,cnazpol2,cnazpol3,cnazpol4,cnazpol5,cnazpol6,
					  mpodminka,mklikvid,mzlikvid,lwrtrechd,mpopisucpr,dvznikzazn,
					  dzmenazazn,mpoznamka,cuniqidrec,muserzmenr			
	   FROM UCETPRIT WHERE cTask = 'SKL' and cmainfile <> 'PVPITEMw';
	   
UPDATE UCETPRIT	SET cTypDoklad = (SubString(cTypDoklad,1,3)+'-'+SubString(cTypDoklad,5,6)) WHERE culoha = 'S' and cmainfile <> 'PVPITEMw';
    
update ucetprit set cmainfile = 'PVPITEMww' where ctypuct = 'SK_PRIJ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set ctypuct = 'SK_PRIJww'   where ctypuct = 'SK_PRIJ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set cmainfile = 'PVPITEMww' where ctypuct = 'SK_VYDEJ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set ctypuct = 'SK_VYDEJww'  where ctypuct = 'SK_VYDEJ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set cmainfile = 'PVPHEADw'  where ctypuct = 'SK_CENROZ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set ctypuct = 'SK_CENROZw'  where ctypuct = 'SK_CENROZ' and (culoha = ' ' or culoha IS NULL);
update ucetprit set culoha='S' where (culoha = ' ' or culoha IS NULL);
