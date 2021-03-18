Trigger nad CenZboz ( after insert )

UPDATE  CenZboz SET muserzmenr = CAST( NOW() AS SQL_CHAR ) + ' ' + USER() WHERE cCisSklad = '' and cSklPol = '';