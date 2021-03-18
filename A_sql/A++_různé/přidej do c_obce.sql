INSERT INTO c_obce ( cKodOBCE,cNazOBCE,cTypOBCE,cKodOBCEOU,cNazOBCEOU,cKodOBCERP,cNazOBCERP,cCZ_NUTSok,
                     cNAZ_okres,cCZ_NUTSkr,cNAZ_kraje,cCZ_NUTSob,cNAZ_oblas,cZkratStat,ndistrib)  
      SELECT ltrim(c1),ltrim(c3),ltrim(c4),ltrim(c5),ltrim(c6),ltrim(c7),ltrim(c8),ltrim(c9),ltrim(c10),
              ltrim(c11),ltrim(c12),ltrim(c13),ltrim(c14),'CZE',1
          FROM c_obce_