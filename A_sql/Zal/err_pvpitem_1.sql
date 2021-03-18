select a.ndoklad, a.norditem, b.ndoklad, b.norditem, b.nkcmd, b.nkcdal from pvpitem as a
left outer join ucetpol as b on a.ndoklad = b.ndoklad and a.norditem = b.norditem 
where a.ncislpoh   = 150 and a.nrok = 2007 and a.nobdobi = 3 
order by a.ndoklad,a.norditem