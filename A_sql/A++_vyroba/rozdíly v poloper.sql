//select * from kusov_,kusov where kusov_.sid <> kusov.sid 
//select * from kusov_ where cpolodp_2 = ''
update poloper_ set npozice = 0  ;
update poloper_ set npozice = 9 from poloper where poloper_.sid = poloper.sid ;
select * from poloper_ where npozice = 0;
 
