select nprepNedop, nKVR_danBo, nZuctovano 
       from vyucDane
	   where (nprepNedop +nKVR_danBo) > 0 and nMZDDAVHD <> 0
	   
update vyucDane 
       set vyucDane.nZuctovano = vyucDane.nprepNedop +vyucDane.nKVR_danBo
	   where (nprepNedop +nKVR_danBo) > 0 and nMZDDAVHD <> 0

           
	   