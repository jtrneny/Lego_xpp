declare ndoklad numeric(10,0);
declare c string;

ndoklad = convert( convert(91530, SQL_VARCHAR) +
                   convert(1, SQL_VARCHAR)   +
				   convert(1, SQL_VARCHAR),  SQL_NUMERIC);


c = 'aa';
