select nrok as rok, nobdobi as obdobi, nrecItem as zdrPojis, sum(nkcMD) as nkcmd                
            from ucetpol                                                        
            where (nordUcto = 1 and nrok = 2014 and nobdobi = 01 and 
              ( ( LEFT(ctypUct,7) = 'MZ_ZDPO' or LEFT(ctypUct,7) = 'MZ_ZDPZ' )  or 
                ( LEFT(ctypUct,7) = 'MZ_SOPO' or LEFT(ctypUct,7) = 'MZ_SOPZ' )    ) ) 
            group by nrok, nobdobi, nrecItem