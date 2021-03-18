update msprc_mo set crodcisprn = replace( replace( crodcispra,'-', ''),'/','') where nrodcispra = 0 ;
update msprc_mo set nrodcispra = cast( crodcisprn AS SQL_NUMERIC) where nrodcispra = 0