UPDATE firmy SET muserzmeny = convert(curdate(),SQL_CHAR) +' '+
                              convert(curtime(),SQL_CHAR) + 
                              char(13)                    +
                              muserzmeny  
             WHERE ncisfirmy = (SELECT ncisfirmy Number" FROM __new);