delete from defvykit where CIDvykazu = 'DIST000060'    ;

INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,1,'1','Leden','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Leden','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,1,'1','Leden','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Leden','','MZ_DNY_OBPV01','DIST000137','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,1,'1','Leden','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Leden','','MZ_HOD_OBPV01','DIST000138','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,1,'1','Leden','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Leden','','MZ_MZD_OBPV01','DIST000139','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'     ;

// únor
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,2,'2','Únor','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Únor','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,2,'2','Únor','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Únor','','MZ_DNY_OBPV02','DIST000140','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,2,'2','Únor','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Únor','','MZ_HOD_OBPV02','DIST000141','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,2,'2','Únor','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Únor','','MZ_MZD_OBPV02','DIST000142','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'       ;

//brezen
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,3,'3','Brezen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Brezen','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,3,'3','Brezen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Brezen','','MZ_DNY_OBPV03','DIST000143','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,3,'3','Brezen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Brezen','','MZ_HOD_OBPV03','DIST000144','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,3,'3','Brezen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Brezen','','MZ_MZD_OBPV03','DIST000145','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'           ;

// duben
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,4,'4','Duben','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Duben','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,4,'4','Duben','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Duben','','MZ_DNY_OBPV04','DIST000146','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,4,'4','Duben','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Duben','','MZ_HOD_OBPV04','DIST000147','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,4,'4','Duben','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Duben','','MZ_MZD_OBPV04','DIST000148','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'          ;
			
//květen
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,5,'5','Kveten','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Kveten','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,5,'5','Kveten','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Kveten','','MZ_DNY_OBPV05','DIST000149','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,5,'5','Kveten','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Kveten','','MZ_HOD_OBPV05','DIST000150','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,5,'5','Kveten','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Kveten','','MZ_MZD_OBPV05','DIST000151','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'          ;
		
//červen
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,6,'6','Cerven','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cerven','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,6,'6','Cerven','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cerven','','MZ_DNY_OBPV06','DIST000152','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,6,'6','Cerven','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cerven','','MZ_HOD_OBPV06','DIST000153','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,6,'6','Cerven','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cerven','','MZ_MZD_OBPV06','DIST000154','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'          ;

//cervenec
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,7,'7','Cervenec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cervenec','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,7,'7','Cervenec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cervenec','','MZ_DNY_OBPV07','DIST000155','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,7,'7','Cervenec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cervenec','','MZ_HOD_OBPV07','DIST000156','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,7,'7','Cervenec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Cervenec','','MZ_MZD_OBPV07','DIST000157','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'     ;

// srpen
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,8,'8','Srpen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Srpen','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,8,'8','Srpen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Srpen','','MZ_DNY_OBPV08','DIST000158','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,8,'8','Srpen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Srpen','','MZ_HOD_OBPV08','DIST000159','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,8,'8','Srpen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Srpen','','MZ_MZD_OBPV08','DIST000160','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'       ;

//zari
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,9,'9','Zari','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Zari','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,9,'9','Zari','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Zari','','MZ_DNY_OBPV09','DIST000161','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,9,'9','Zari','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Zari','','MZ_HOD_OBPV09','DIST000162','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,9,'9','Zari','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Zari','','MZ_MZD_OBPV09','DIST000163','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'           ;

// rijen
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,10,'10','Rijen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Rijen','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,10,'10','Rijen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Rijen','','MZ_DNY_OBPV10','DIST000164','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,10,'10','Rijen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Rijen','','MZ_HOD_OBPV10','DIST000165','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,10,'10','Rijen','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Rijen','','MZ_MZD_OBPV10','DIST000166','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'          ;
			
//listopad
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,11,'11','Listopad','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Listopad','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,11,'11','Listopad','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Listopad','','MZ_DNY_OBPV11','DIST000167','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,11,'11','Listopad','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Listopad','','MZ_HOD_OBPV11','DIST000168','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,11,'11','Listopad','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Listopad','','MZ_MZD_OBPV11','DIST000169','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'          ;
		
//prosinec
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,12,'12','Prosinec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Prosinec','','','','V0','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'N'      					;


INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,12,'12','Prosinec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Prosinec','','MZ_DNY_OBPV12','DIST000170','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'D'      					;
					   
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,12,'12','Prosinec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Prosinec','','MZ_HOD_OBPV12','DIST000171','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'H'	                    ;
					  
INSERT INTO DEFVYKIT( CIDvykazu,cTask,cUloha,cTypVykazu,nRadekVyk,cSkuRadVyk,cNazRadVyk,nSloupVyk,cSloupVyk,cNazSloVyk,cNazBunVyk,cSkupina1,cSkupina2,cSkupina3,
                      mVyber,mVyraz,cTextRadek,cTextSloup,cTextBunky,cTypNapVyk,cIDSysVykN,cTypKumVyk,cTypNapVyB,cIDSysVykB,cTypNapVyE,cIDSysVykE,
				 	  nKodZaokr,nTypTisku,cTextTm1,cTextTm2,cTextTm3,
                      nDistrib,mMetodika,dVznikZazn)
 SELECT               'DIST000060','MZD','M','MZD_MzdList_1',nRadMzdLis,Convert(nRadMzdLis,SQL_CHAR),cNazRadMzl,12,'12','Prosinec','',Left(Convert(nTypRadMzl,SQL_CHAR),3),'','',
                      mVyber,'',cNazRadMzl,'Prosinec','','MZ_MZD_OBPV12','DIST000171','K5','','','','',
 					  32,0,'','','',
                      1,'',curdate() FROM c_nazrml where ctypvaluer = 'K'
		  					  				   