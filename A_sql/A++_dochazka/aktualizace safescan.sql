ALTER TRIGGER d_safescan_after_insert
   ON D_SAFESCAN
   AFTER 
   INSERT 
BEGIN 

  declare @terminalsn  String ; 
  declare @eventid     String ; 
  declare @ccas        String ; 
  declare @timeentry   TimeStamp  ; 
  declare @nden        Integer;
  declare @nmesic      Integer;
  declare @nhod        Integer;
  declare @nmin        Integer;
  declare @nsid        Integer;
  declare @userid      String ; 
  declare @ckodprer    String ; 
  declare @cinout      String ; 

  @terminalsn = ( select [terminalsn] from __new)  ;
  @eventid    = ( select [eventid] from __new)  ;
  @timeentry  = ( select [timeentry] from __new)  ;
  @nsid       = ( select [sID] from __new)      ;
  @userid     = ( select [userid] from __new)  ;
 
  
  @nmesic = MONTH( @timeentry )        ;
  @nden   = DAYOFMONTH( @timeentry )   ;
  @nhod   = HOUR( @timeentry )         ;
  @nmin   = MINUTE( @timeentry )       ;

  @ckodprer = ( select [ckodprer] from stavterm  where  stavterm.csnterm = @terminalsn and 
                                                        stavterm.cstavterm = @eventid and 
                                                         stavterm.ctask = 'DOH'  )   ;

  @cinout = ( select [cinout] from c_prerus where [ckodprer]=@ckodprer and
                                                      [ctask]='DOH')  ;       

  if @cinout = 'I' then 
     update osoby   set tlastin  = @timeentry where cidoskarty = @userid   ;  
  elseif @cinout = 'O' then
     update osoby   set tlastout = @timeentry where cidoskarty = @userid  ;
  else
  end ;
   
  update d_safescan set ctypprer   = left(@eventid,4)                    where [sID] = @nsid   ;  
  update d_safescan set ckodprer   = @ckodprer                             where [sID] = @nsid   ;  
  update d_safescan set cidoskarty = left(userid,25)                       where [sID] = @nsid   ;  
  update d_safescan set nrok       = YEAR( timeentry )                     where [sID] = @nsid   ;  
  update d_safescan set nmesic     = MONTH( timeentry )                    where [sID] = @nsid   ;  
  update d_safescan set nden       = DAYOFMONTH( timeentry )               where [sID] = @nsid   ;  
  update d_safescan set crok       = Left(convert(nrok,SQL_CHAR ),4)       where [sID] = @nsid   ;
  
  if @nmesic > 9 then
    update d_safescan set cmesic   = left(convert(nmesic,SQL_CHAR),2)      where [sID] = @nsid   ;
  else
    update d_safescan set cmesic   = '0' +Left(convert(nmesic,SQL_CHAR),1) where [sID] = @nsid   ;
  end;   

  if @nden > 9 then
    update d_safescan set cden     = Left(convert(nden,SQL_CHAR),2)      where [sID] = @nsid   ;
  else
    update d_safescan set cden     = '0' +Left(convert(nden,SQL_CHAR),1) where [sID] = @nsid   ;
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
    
  update d_safescan set ccas       = @ccas                                 where [sID] = @nsid   ;  
  	  
  update d_safescan set dden       = convert(timeentry,SQL_DATE )          where [sID] = @nsid   ;  
  update d_safescan set ddatum     = convert(timeentry,SQL_DATE )          where [sID] = @nsid   ;  
  update d_safescan set csnterm    = Left(terminalsn,30)                   where [sID] = @nsid   ;  

	
  insert into dotermin(dDatum,cKodPrer, ctypprer, cobdobi, crok, nrok,cmesic,nmesic,cden,nden,ccas,tpohyb,
                       cdenvtydnu,cidoskarty,cadrterm,csnterm,bblock,ctable,cinout,id,
	      ctableid)
         select dDatum,cKodPrer, ctypprer, (cmesic+ '/'+ right(crok,2)), crok, nrok,cmesic,nmesic,cden,nden,ccas,@timeentry,
                       cdenvtydnu,cidoskarty,cadrterm,csnterm,jpegPhoto,'d_safescan',@cinout,sid,
	       ('d_safescan '+Left(convert( sid, SQL_CHAR),10))
          from d_safescan WHERE [sID] = @nsID   ;
   

END 
   PRIORITY 1;
