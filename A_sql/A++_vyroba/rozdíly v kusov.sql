//select * from kusov_,kusov where kusov_.sid <> kusov.sid 
update kusov_ set cpolodp_2 = ''  ;
update kusov_ set cpolodp_2 = '9' from kusov where kusov_.sid = kusov.sid ;
select * from kusov_ where cpolodp_2 = ''
 
