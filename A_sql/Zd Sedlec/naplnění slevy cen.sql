delete from procenhd   ;
delete from procenit   ;
delete from procenho   ;

INSERT INTO procenho (ntypprocen,ncisprocen,nPolProCen,lhlaprocen,ncisfirmy,nzbozikat,ccissklad,csklpol,ncenapzbo,czkrtypuhr,czkratmeny,ntyphodn,nhodnota,nprocento,dplatnyod,dplatnydo,dvznikzazn)
        SELECT 7,0,1,false,ncisfirmy,0,'','',0,'Cash','CZK',0,0,nproczakl,'00.00.0000','00.00.0000',curdate()
          FROM slevycen   ;

update procenho set ncisprocen = sid  ;

INSERT INTO procenit (ntypprocen,ncisprocen,nPolProCen,ncisfirmy,coznprocen,nzbozikat,ccissklad,csklpol,cnazzbo,czkrtypuhr,ntyphodn,dvznikzazn)
        SELECT ntypprocen,ncisprocen,nPolProCen,ncisfirmy,'MOC_ZAK',nzbozikat,ccissklad,csklpol,'',czkrtypuhr,ntyphodn,curdate()
          FROM procenho   ;


INSERT INTO procenhd (ntypprocen,ncisprocen,ncisfirmy,coznprocen,cnazprocen,lhlaprocen,lprocenzbo,czkratmeny,czkrtypuhr,ntyphodn,dplatnyod,dplatnydo,dvznikzazn)
        SELECT ntypprocen,ncisprocen,ncisfirmy,'MOC_ZAK','Základní maloobchodní',false,false,'CZK',czkrtypuhr,ntyphodn,'00.00.0000','00.00.0000',curdate()
          FROM procenit   ;
