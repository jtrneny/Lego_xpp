update fakprihd set nUhrCelFaZ = nUhrCelFak where cZkratMenZ = 'CZK' ;
update fakprihd set nUhrCelFaZ = nCenZahCel where cZkratMenZ<>'CZK' and nUhrCelFaZ=0 and
                                                  nUhrCelFak = nCenZakCel   