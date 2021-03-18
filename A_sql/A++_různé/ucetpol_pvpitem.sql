select a.ndoklad, a.norditem, b.ndoklad, b.norditem, a.nkcmd, a.nkcdal from ucetpol as a
full outer join pvpitem as b on a.ndoklad = b.ndoklad and a.norditem = b.norditem 
where b.ncislpoh   = 150 and b.nrok = 2007 and a.nobdobi = 3 
order by a.ndoklad,a.norditem