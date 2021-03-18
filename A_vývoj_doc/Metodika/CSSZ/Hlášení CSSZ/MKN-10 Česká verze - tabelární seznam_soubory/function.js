function Kod(hodnota)
{
for (x=0; x<=H0.length-2; x++)
    {
    //window.alert(H0[x]+hodnota);
    if (H0[x]==hodnota) { Strom(3,x,-1); break;}
    else
	{	
	for (y=0; y<=H[x].length-1; y++)
		{
		if (H[x][y][0]==hodnota) { Strom(3,x,y); break;}
		}
	}
    }
}

function Strom(kmen,x_strom,y_strom)
{
parent.note.document.open();
parent.note.document.write("<HTML><HEAD><Title>Struktura</Title><meta http-equiv='Content-Type' content='text/html; charset=windows-1250'><link rel=stylesheet type=text/css href=styl.css title=styl><base target='main'></head><body topmargin='0px' leftmargin='2px' bgcolor='#ffFFFF'>");
//parent.note.document.write("<table cellpadding=0px cellspacing=0px><tr><td class=navigace>&nbsp;&nbsp;</td><td class=navigace>&nbsp;<a class=m href='javascript:Strom(0,0,0)'>1</a>&nbsp;</td><td class=navigace>&nbsp;<a class=m href='javascript:Strom(1,0,0)'>2</a>&nbsp;</td><td class=navigace>&nbsp;<a class=m href='javascript:Strom(2,0,0)'>3</a>&nbsp;</td></tr></table>");
if (kmen==3) parent.note.document.write("<table border=0px cellpadding=0px cellspacing=0px><tr><td nowrap class=navigace valign='bottom' background='"+H0[x_strom]+".gif' height=92 width=98>&nbsp;<a class=H0 href="+ H0[x_strom] +".html>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><br>&nbsp;&nbsp;&nbsp;<a class=m href='javascript:Strom(0,0,0)'><img src='1.gif' border='0' title='zobraz všechny kapitoly'></a>–<a class=m href='javascript:Strom(1,0,0)'><img src='2.gif' border='0' title='zobraz všechny kapitoly a podkapitoly'></a>–<a class=m href='javascript:Strom(2,0,0)'><img src='3.gif' border='0' title='zobraz celou strukturu'></a></td></tr>");
else parent.note.document.write("<table border=0px cellpadding=0px cellspacing=0px><tr><td nowrap class=navigace valign='bottom' background='struktura.gif' height=92 width=98>&nbsp;&nbsp;&nbsp;<a class=m href='javascript:Strom(0,0,0)'><img src='1.gif' border='0px' title='zobraz všechny kapitoly'></a>–<a class=m href='javascript:Strom(1,0,0)'><img src='2.gif' border='0' title='zobraz všechny kapitoly a podkapitoly'></a>–<a class=m href='javascript:Strom(2,-1,-1)'><img src='3.gif' border='0' title='zobraz celou strukturu'></a></td></tr>");

for (x=0; x<=H0.length-2; x++)
    {
    if (kmen==0) H_0(0,H0[x]);
    else
	{
	if (x_strom==x) H_0(2,'[..]');
	else if (kmen<=2) H_0(0,H0[x]);
	for (y=0; y<=H[x].length-1; y++)
		{
    		if (kmen==1) H_1(0,H[x][y][0]);
    		else
			{
			if (kmen==3 && x_strom==x && y_strom==y) H_1(1,H[x][y][0]);
			else if (kmen<=2 || x_strom==x) H_1(0,H[x][y][0]);
			for (z=1; z<=H[x][y].length-1; z++)
				{
    				if (kmen<=2) H_2(0,H[x][y][z]);
    				else if (x_strom==x && y_strom==y) H_2(1,H[x][y][z]);		
				}
			}
		}
	}
    }
parent.note.document.write("</table></body></html>")
parent.note.document.close();

function H_0 (styl,text)
{
if (styl==0) tisk="<tr><td nowrap class=navigace>&nbsp;<img src='kapitola.gif' title='kapitola'>&nbsp;<a class=navig href='"+text+".html'>"+text+"</a>&nbsp;</td></tr>";
else if (styl==1) tisk="<tr><td nowrap class=menu>&nbsp;<img src='kapitola.gif'>&nbsp;<a class=navig title='kapitola' href='"+text+".html'><b>"+text+"</b></a>&nbsp;</td></tr>";
else if (styl==2) tisk="<tr><td nowrap class=navigace>&nbsp;<img src='back.gif'>&nbsp;<a class=m title='zpět na tabelární seznam' href='seznam.html'>"+text+"</a>&nbsp;</td></tr>";
parent.note.document.write(tisk);
}

function H_1 (styl,text)
{
if (styl==0) tisk="<tr><td nowrap class=navigace>&nbsp;<img src='podkapitola.gif' title='podkapitola'>&nbsp;<a class=m href='"+text+".html'>"+text+"</a>&nbsp;</td></tr>";
else tisk="<tr><td nowrap class=menu>&nbsp;<img src='podkapitola_a.gif' title='podkapitola'>&nbsp;<a class=navig href='"+text+".html'>"+text+"</a>&nbsp;</td></tr>";
parent.note.document.write(tisk);
}

function H_2 (styl,text)
{
if (styl==0) tisk="<tr><td nowrap class=navigace>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='kotva.gif'>&nbsp;<a class=m href='"+H[x][y][0]+".html#"+text+"'>"+text+"</a>&nbsp;</td></tr>";
else tisk="<tr><td nowrap class=menu>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='kotva.gif'>&nbsp;<a class=navig href='"+H[x][y][0]+".html#"+text+"'>"+text+"</a>&nbsp;</td></tr>";
parent.note.document.write(tisk);
}
}