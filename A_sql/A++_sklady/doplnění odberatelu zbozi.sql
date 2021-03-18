insert into odbzboz (cCisSklad,cSklPol,CNAZZBO,cKatcZBO,nCisFirmy,cNazFirmy,nCenaPzbo,
                      nCenaMzbo,
					  cZkratMENY,cZkratJEDN,CZKRCARKOD,cCarKod,dDatumOd, 
                      nCENZBOZ,nFIRMY)
		select  
		              cCisSklad,cSklPol,CNAZZBO,cKatcZBO,297,'',nCenaPzbo,
                      nCenaMzbo,
					  cZkratMENY,cZkratJEDN,CZKRCARKOD,cCarKod,CURRENT_DATE(), 
                      sid,294
		from cenzboz			   			  
        where (POSITION( 'Ventilkolben' IN cnazzbo ) > 0  or
		      POSITION( 'Druckpilz' IN cnazzbo ) > 0  or
			  POSITION( 'Scheibe' IN cnazzbo ) > 0  or
			  POSITION( 'Magnethaltr' IN cnazzbo ) > 0) and ccissklad='500'  
			  //cnazzbo = 'Ventilkolben' or cnazzbo = 'Druckpilz' or cnazzbo = 'Scheibe' or cnazzbo = 'Magnethaltr' 
		      