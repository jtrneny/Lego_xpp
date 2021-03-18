INSERT INTO TYPDOKL(ctask,cpoduloha,ctypdoklad,cnaztypdok,ctypcrd,cfiledruhy,cmainfile,
                      czustuct,dplatnyod,dplatnydo,mmacro,mconducto,mpopisdokl,mmetodika,
					  dvznikzazn,dzmenazazn,mpoznamka,cuniqidrec,muserzmenr)
       SELECT ctask,cpoduloha,ctypdoklad,cnaztypdok,ctypcrd,cfiledruhy,cmainfile,
                      czustuct,dplatnyod,dplatnydo,mmacro,mconducto,mpopisdokl,mmetodika,
					  dvznikzazn,dzmenazazn,mpoznamka,cuniqidrec,muserzmenr			
	   FROM TYPDOKL WHERE cTask = 'SKL';

//UPDATE UCETPRHD	SET cTypDoklad = (SubString(cTypDoklad,1,3)+'-'+SubString(cTypDoklad,5,6)), culoha='S' WHERE culoha = ''  ;    
