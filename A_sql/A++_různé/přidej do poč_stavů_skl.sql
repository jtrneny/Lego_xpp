INSERT INTO CENZB_PS(ccissklad,csklpol,nrok,nzbozikat,nucetskup,
                      ncenaszbo,ncenapoc,nmnozpoc)
       SELECT ccissklad,csklpol,nrok,nzbozikat,nucetskup,
                      ncenaszbo,ncenapoc,nmnozpoc			
       FROM CENZB_PS_ ;
