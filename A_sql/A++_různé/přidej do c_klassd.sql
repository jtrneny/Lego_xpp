delete from c_KLASSD  ;
insert into c_KLASSD ( CKODKLAS,CNAZEVKLAS,cpolodpsk,ndistrib)
         select ctypczcpa,cnazczcpa,cpolodpsk,1
		 from c_czcpa_  