update cenzboz set ncenavni = 0  ;
update cenzboz set cenzboz.ncenavni = 1 from dodzboz where cenzboz.ccissklad=dodzboz.ccissklad and
                                                            cenzboz.csklpol=dodzboz.csklpol and 
															 cenzboz.ccissklad='2'   ;
															 
insert into dodzboz (nKlicNAZ,cCisSklad,cSklPol,CNAZZBO,cKatcZBO,nCisFirmy,cNazev,nCenanZBO,nCenaoZBO,
                     nCenPol,dDatPNak,nMinObMnoz,nMinExMnoz,cNazDod1,cNazDod2,nCenNakZM,cZkratMENY,
					 nDodlhuta,mPozDOD,lHlavniDOD,cZkratJEDN,CZKRCARKOD,cCarKod,dDatumOd,dDatumDo,
					 mPOZNAMKA,nCENZBOZ)
			select   nKlicNAZ,cCisSklad,cSklPol,CNAZZBO,cKatcZBO,0,'bez vazby na doddavtele',nCenanZBO,nCenaoZBO,
                     nCenPol,'',0,0,'','',nCenNakZM,cZkratMENY,
					 0,'',true,cZkratJEDN,CZKRCARKOD,cCarKod,'','',
					 '',sid
		    from cenzboz where ncenavni = 0 and ccissklad='2'    		;
			
update cenzboz set ncenavni = 0  ;
			
				 		 