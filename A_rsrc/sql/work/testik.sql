declare stmt String;
declare cc String;
declare i Integer;
declare oscisPrac Memo;

stmt = 'ahoj, '+char(10) +char(13) +'kolo';

cc  = replace( stmt, char(10) +char(13), '' );
cc  = '333,777,666';

oscisPrac = '333,777,666';

cc = convert(  777, SQL_CHAR); 
cc = replace( cc, ' ', '');

if locate( cc, oscisPrac) <> 0 then
  i = 22;
endif;  

i = 10;
