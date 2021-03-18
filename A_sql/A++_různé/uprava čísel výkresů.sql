update vyrpol set cnazev2=SUBSTRING( cnazev, POSITION( '03.7' IN cnazev),50) where ccissklad='500' and ccisvyk='   ' and POSITION( '03.7' IN cnazev) > 0 
