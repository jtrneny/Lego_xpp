update msprc_mo set msprc_mo.nDovBezNar = 0,
                    msprc_mo.nDovBezCer = 0,
                    msprc_mo.nDovBezZus = 0,
                    msprc_mo.nDovMinNar = 0,
                    msprc_mo.nDovMinCer = 0,
                    msprc_mo.nDovMinZus = 0,
                    msprc_mo.nDovZustat = 0,
                    msprc_mo.nDoDBezNar = 0,
                    msprc_mo.nDoDBezCer = 0,
                    msprc_mo.nDoDBezZus = 0,
                    msprc_mo.nDoDMinNar = 0,
                    msprc_mo.nDoDMinCer = 0,
                    msprc_mo.nDoDMinZus = 0,
                    msprc_mo.nDoDZustat = 0,
                    msprc_mo.nDovZustCe = 0
                where msprc_mo.nrokobd=201301   ;


update msprc_mo set msprc_mo.nDovBezNar = msprc_mz.nDovBezNar,
                    msprc_mo.nDovBezCer = 0,
                    msprc_mo.nDovBezZus = msprc_mz.nDovBezNar,
                    msprc_mo.nDovMinNar = msprc_mz.nDovMinNar,
                    msprc_mo.nDovMinCer = 0,
                    msprc_mo.nDovMinZus = msprc_mz.nDovMinZus,
                    msprc_mo.nDovZustat = msprc_mo.nDovBezNar +msprc_mo.nDovMinZus,
                    msprc_mo.nDoDBezNar = msprc_mz.nDoDBezNar,
                    msprc_mo.nDoDBezCer = 0,
                    msprc_mo.nDoDBezZus = msprc_mz.nDoDBezNar,
                    msprc_mo.nDoDMinNar = msprc_mz.nDoDMinNar,
                    msprc_mo.nDoDMinCer = 0,
                    msprc_mo.nDoDMinZus = msprc_mz.nDoDMinNar,
                    msprc_mo.nDoDZustat = msprc_mo.nDoDBezZus +msprc_mo.nDoDMinZus,
                    msprc_mo.nDovZustCe = msprc_mo.nDovZustat +msprc_mo.nDoDZustat
                from msprc_mz    
                where msprc_mo.nrokobd=201301 and msprc_mo.noscisprac = msprc_mz.noscisprac and msprc_mo.nporpravzt = msprc_mz.nporpravzt   
