//PRIPRAVA SQL DOTAZU 
//	- ArrivalParam = vstupni parametr procedury
//	- ulRetVal = navratova hodnota k vyhodnoceni spravnosti zadaneho SQL dotazu
//	- hSQL = vytvoreny SQL dotaz 
	
/* Prepare a statement handle to be executed with a named parameter */
ulRetVal = AdsPrepareSQL( hSQL, "SELECT * FROM plane WHERE arrival = :ArrivalParam" );
if ( ulRetVal != AE_SUCCESS ) {
	/* some kind of error, tell the user what happened */
	AdsShowError( "ACE Couldn't Prepare Statement to be Executed" );
	return ulRetVal;
}


/* Execute the SQL statment */
ulRetVal = AdsExecuteSQL( hSQL, null );
if ( ulRetVal != AE_SUCCESS ) {
	/* some kind of error, tell the user what happened */
	AdsShowError( "ACE Couldn't Execute the Statement" );
	return ulRetVal;
}