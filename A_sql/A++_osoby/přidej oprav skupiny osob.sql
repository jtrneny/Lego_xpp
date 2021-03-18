update osoby set osoby.nis_doh = 1 where osoby.lstavem = true and cidoskarty <> '';
insert into osobysk (ncisosoby, czkr_skup)
      select ncisosoby,'DOH' from osoby where nis_doh = 1 and lstavem = true 