update ucetprit set ctypuct = 'MZ_SOPZGEN' where ucetprit.culoha='M' and ucetprit.ctypuct='MZ_SRAZGEN' and
                                                  (ucetprit.cucetskup='504' or ucetprit.cucetskup='506' or 
                                                    ucetprit.cucetskup='508' or ucetprit.cucetskup='586')    ; 
update ucetprit set ctypuct = 'MZ_ZDPZGEN' where ucetprit.culoha='M' and ucetprit.ctypuct='MZ_SRAZGEN' and
                                                  (ucetprit.cucetskup='505' or ucetprit.cucetskup='507' or 
                                                    ucetprit.cucetskup='509' or ucetprit.cucetskup='587')    ; 
update ucetpol set ctypuct = 'MZ_SOPZGEN' where ucetpol.culoha='M' and ucetpol.ctypuct='MZ_SRAZGEN' and
                                                  (ucetpol.cucetskup='504' or ucetpol.cucetskup='506' or 
                                                    ucetpol.cucetskup='508' or ucetpol.cucetskup='586')    ; 
update ucetpol set ctypuct = 'MZ_ZDPZGEN' where ucetpol.culoha='M' and ucetpol.ctypuct='MZ_SRAZGEN' and
                                                  (ucetpol.cucetskup='505' or ucetpol.cucetskup='507' or 
                                                    ucetpol.cucetskup='509' or ucetpol.cucetskup='587')    ; 
