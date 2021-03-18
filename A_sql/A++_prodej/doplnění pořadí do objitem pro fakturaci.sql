update objitem set objitem.crozporadi = cenzboz.crozporadi from cenzboz where objitem.ccissklad=cenzboz.ccissklad and 
                                                                                 objitem.csklpol=cenzboz.csklpol and 
										  ( objitem.crozporadi = '' or objitem.crozporadi is null )