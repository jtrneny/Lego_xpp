update filtrs set ctypfiltrs = 'USER' where length(cidfilters)=9 ;
update filtrs set ncisfiltrs = CONVERT( SUBSTRING( cidfilters,5,5),SQL_NUMERIC) where length(cidfilters)=9  ;
update filtrs set cidfilters = 'USER0'+SUBSTRING( cidfilters,5,5) where length(cidfilters)=9  ;

update fltusers set cidfilters = 'USER0'+SUBSTRING( cidfilters,5,5) where length(cidfilters)=9