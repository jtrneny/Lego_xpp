
     insert into c_katast (ctask,cku_Kod,cku_Nazev,cKatastr,dVznikZazn,dZmenaZazn,mPoznamka)
      SELECT 'HIM',cku_Kod,cku_Nazev,cKatastr,dVznikZazn,dZmenaZazn,mPoznamka FROM c_katast_ 