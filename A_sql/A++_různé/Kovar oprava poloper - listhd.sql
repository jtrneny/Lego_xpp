update poloper set poloper.nporcislis = listhd.nporcislis, poloper.nrokvytvor=listhd.nrokvytvor from listhd
    where poloper.cciszakazi = listhd.cciszakazi and poloper.ncisoper=listhd.ncisoper and 
	      ( substring(poloper.cciszakazi,1,1)='6' or substring(poloper.cciszakazi,1,1)='5') and listhd.nrokvytvor =2012 