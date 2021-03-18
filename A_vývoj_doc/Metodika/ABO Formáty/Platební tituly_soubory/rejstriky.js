function odeberDiakritiku(text)
{
	var s = 'áÁéÉíÍýÝěĚóÓšŠčČřŘžŽňŇůŮúÚťŤďĎäÄëËiIöÖüÜĺĹ';
	var bez = 'aAeEiIyYeEoOsScCrRzZnNuUuUtTdDaAeEiIoOuUlL';

	for (i=0; i < s.length; i++)
	{
		for (j=0; j < text.length; j++)
		{
			text = text.replace(s.charAt(i), bez.charAt(i));
		}
	}
	return text;
}
function hledejRejstriky() {
	var targetUrl;
	switch (document.forms['HledaniRejstriky'].elements['rejstrik'].value) {
		case 'or-firma':
			targetUrl = 'http://www.justice.cz/xqw/xervlet/insl/index?sysinf.@typ=or&sysinf.@strana=searchResults&hledani.@typ=subjekt&hledani.podminka.prijmeni=&hledani.podminka.ico=&hledani.format.pocet_polozek=&hledani.format.trideni=netridit&hledani.format.typHledani=x*&hledani.format.obchodniJmeno=platne&hledani.podminka.subjekt=';
			targetUrl += odeberDiakritiku(document.forms['HledaniRejstriky'].elements['hledej'].value);
			break;
		case 'or-ico':
			targetUrl = 'http://www.justice.cz/xqw/xervlet/insl/index?sysinf.@typ=or&sysinf.@strana=searchResults&hledani.@typ=subjekt&hledani.podminka.subjekt=&hledani.podminka.prijmeni=&hledani.format.pocet_polozek=&hledani.format.trideni=netridit&hledani.format.typHledani=x*&hledani.format.obchodniJmeno=platne&hledani.podminka.ico=';
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
		case 'or-prij':
			targetUrl = 'http://www.justice.cz/xqw/xervlet/insl/index?sysinf.@typ=or&sysinf.@strana=searchResults&hledani.@typ=osoba&hledani.podminka.subjekt=&hledani.podminka.ico=&hledani.format.pocet_polozek=&hledani.format.trideni=netridit&hledani.format.typHledani=x*&hledani.format.obchodniJmeno=platne&hledani.podminka.prijmeni=';
			var prijmeni;
			prijmeni = document.forms['HledaniRejstriky'].elements['hledej'].value.toLowerCase();
			prijmeni = prijmeni.substr(0,1).toUpperCase().concat(prijmeni.substr(1,prijmeni.length));
			targetUrl += odeberDiakritiku(prijmeni);
			break;
		case 'ares-jmeno':
			targetUrl = 'http://wwwinfo.mfcr.cz/cgi-bin/ares/ares_es.cgi?xml=1&obch_jm=';
			targetUrl += odeberDiakritiku(document.forms['HledaniRejstriky'].elements['hledej'].value);
			break;
		case 'ares-ico':
			targetUrl = 'http://wwwinfo.mfcr.cz/cgi-bin/ares/ares_es.cgi?xml=1&ico='
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
		case 'rzp-jmeno':
			targetUrl = 'http://rzp.mpo.cz/cgi-bin/rzpi.fpl?AKCE=hledej&ICO=&OBEC=&OKRES=&ULICE=&CDOM=&COR=&OBCHJM='
			targetUrl += odeberDiakritiku(document.forms['HledaniRejstriky'].elements['hledej'].value);
			break;
		case 'rzp-ico':
			targetUrl = 'http://rzp.mpo.cz/cgi-bin/rzpi.fpl?AKCE=hledej&OBEC=&OKRES=&ULICE=&CDOM=&COR=&OBCHJM=&ICO='
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
		case 'upadci-firma':
			targetUrl = 'http://www.justice.cz/cgi-bin/sqw1250.cgi/upkuk/s_i6.sqw?vyber=0&ico=&maxpoc=50&typ_sort=0&nazev='
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
		case 'upadci-ico':
			targetUrl = 'http://www.justice.cz/cgi-bin/sqw1250.cgi/upkuk/s_i6.sqw?vyber=0&nazev=&maxpoc=50&typ_sort=0&ico='
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
		case 'dph-ico':
			targetUrl = 'http://adis.mfcr.cz/cgi-bin/adis/idph/int_dp_prij.cgi?ZPRAC=RDPHI1&id=1&pocet=2&fu=&dic=&OK=+Hledej+&fu=&dic='
			targetUrl += document.forms['HledaniRejstriky'].elements['hledej'].value;
			break;
	}
	window.open(targetUrl);
	return true;
}