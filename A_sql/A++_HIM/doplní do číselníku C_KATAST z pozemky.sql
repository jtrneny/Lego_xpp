insert into c_katast (ckatastr,ctask,dvznikzazn)
      SELECT DISTINCT [ckatastr],'HIM',curdate() FROM pozemky