ALTER TRIGGER actatek_after_insert
   ON ACTATEK
   AFTER 
   INSERT 
BEGIN 

  declare @eventid     String ; 
  declare @ccas        String ; 
  declare @timeentry   TimeStamp  ; 
  declare @nden        Integer;
  declare @nmesic      Integer;
  declare @nhod        Integer;
  declare @nmin        Integer;
  declare @nsid        Integer;
  declare @t_lastin    TimeStamp  ; 
  declare @t_lastout   TimeStamp  ; 

  @eventid   = ( select [eventid] from __new)  ;
  @timeentry = ( select [timeentry] from __new)  ;
  @nsid      = ( select [sID] from __new)      ;
 
  
  @nmesic = MONTH( @timeentry )        ;
  @nden   = DAYOFMONTH( @timeentry )   ;
  @nhod   = HOUR( @timeentry )         ;
  @nmin   = MINUTE( @timeentry )       ;

  
  if @eventid = 'IN' then 
     update actatek set cKodPrer = 'PRI' where [sID] = @nsid   ;
	 @t_lastin = @timeentry ;
  elseif @eventid = 'OUT' then
     update actatek set cKodPrer = 'ODC' where [sID] = @nsid   ;
	 @t_lastout = @timeentry ; 
  else
     update actatek set cKodPrer = 'MPR' where [sID] = @nsid   ;
  end ;

   
  update actatek set ctypprer   = Left(@eventid,4)                      where [sID] = @nsid   ;  
  update actatek set cidoskarty = Left(userid,3)                        where [sID] = @nsid   ;  
  update actatek set nrok       = YEAR( timeentry )                     where [sID] = @nsid   ;  
  update actatek set nmesic     = MONTH( timeentry )                    where [sID] = @nsid   ;  
  update actatek set nden       = DAYOFMONTH( timeentry )               where [sID] = @nsid   ;  
  update actatek set crok       = Left(convert(nrok,SQL_CHAR ),4)       where [sID] = @nsid   ;
  
  if @nmesic > 9 then
    update actatek set cmesic   = Left(convert(nmesic,SQL_CHAR),2)      where [sID] = @nsid   ;
  else
    update actatek set cmesic   = '0' +Left(convert(nmesic,SQL_CHAR),1) where [sID] = @nsid   ;
  end;   

  if @nden > 9 then
    update actatek set cden     = Left(convert(nden,SQL_CHAR),2)      where [sID] = @nsid   ;
  else
    update actatek set cden     = '0' +Left(convert(nden,SQL_CHAR),1) where [sID] = @nsid   ;
  end;
  
  if @nhod > 9 then
    @ccas = Left(convert( @nhod, SQL_CHAR),2) ;  
  else
    @ccas = '0' +Left(convert( @nhod, SQL_CHAR),1) ;   
  end;

  if @nmin > 9 then
    @ccas = @ccas + ':' + Left(convert( @nmin, SQL_CHAR),2) ;  
  else
    @ccas = @ccas + ':' + '0' +Left(convert( @nmin, SQL_CHAR),1) ;   
  end;
    
  update actatek set ccas       = @ccas                                 where [sID] = @nsid   ;  
  	  
  update actatek set dden       = convert(timeentry,SQL_DATE )          where [sID] = @nsid   ;  
  update actatek set ddatum     = convert(timeentry,SQL_DATE )          where [sID] = @nsid   ;  
  update actatek set csnterm    = Left(terminalsn,30)                   where [sID] = @nsid   ;  

	
  insert into dotermin(dDatum,cKodPrer, ctypprer, crok, nrok,cmesic,nmesic,cden,nden,ccas,
                       cdenvtydnu,cidoskarty,cadrterm,csnterm,bblock,ctable,id,
					   ctableid,tlastin,tlastout)
         select dDatum,cKodPrer, ctypprer, crok, nrok,cmesic,nmesic,cden,nden,ccas,
                       cdenvtydnu,cidoskarty,cadrterm,csnterm,jpegPhoto,'actatek',sid,
					   ('actatek   '+Left(convert( sid, SQL_CHAR),10)),@t_lastin,@t_lastout
          from actatek WHERE [sID] = @nsID   ;
    
  

END 
   PRIORITY 1;

