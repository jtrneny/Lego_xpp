//update osoby set osoby.nis_doh = 1 where osoby.lstavem = true and cidoskarty <> ''  ;
delete from osobysk where czkr_skup = 'PER'     ; 
insert into osobysk (ncisosoby, czkr_skup)
      select ncisosoby,'PER' from osoby where nis_per = 1  