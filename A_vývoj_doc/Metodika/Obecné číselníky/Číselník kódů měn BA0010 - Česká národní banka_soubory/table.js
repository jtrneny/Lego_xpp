window.onload = init;

function init() {
	stripeAllTables();
	}

function stripeTable(t) {
	var i, odd = true;
	for (i=0; i<t.rows.length; i++) {
		t.rows[i].className += odd ? ' odd' : ' even';
		odd = !odd;
		}
	}
function stripeAllTables() {
	var t = document.getElementsByTagName('TABLE');
	for (var i=0; i<t.length; i++) stripeTable(t[i])
	}