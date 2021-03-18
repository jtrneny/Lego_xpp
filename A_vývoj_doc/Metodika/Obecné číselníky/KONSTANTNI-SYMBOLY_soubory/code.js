function nvc(){
var n=navigator;
var p=document;
var c,t,b,j,m,r,y;
var n3f8q,d,x,w;
n3f8q=d=x=w=0;
b=(n.appName=="Netscape" && parseInt(n.appVersion)==4)?"border=\"0\"":"style=\"border:none\"";
if(n.plugins && n.plugins["Shockwave Flash"]){
t=n.plugins["Shockwave Flash"].description;
n3f8q=parseInt(t.substr(t.indexOf(".")-2,2),10);
} else{
var fo="ShockwaveFlash.ShockwaveFlash";
var a;
try{ a=new ActiveXObject(fo+".7"); } catch(e){
try{ a=new ActiveXObject(fo+".6");
n3f8q=6; a.AllowScriptAccess="always"; n3f8q=0;
} catch(ee){ if(n3f8q==0){ try{ a=new ActiveXObject(fo); } catch(e){ } } }
}
if(n3f8q==0 && a){
try{
var v=a.GetVariable("$version");
if(v){ v=v.split(" ")[1].split(","); n3f8q=parseInt(v[0],10); }
} catch(e){ }
}
}
m=(n.userAgent.substring(0,8)=="Mozilla/")?n.userAgent.substring(8,9):4;
if(m>2)
j=(n.javaEnabled())?1:0;
r=window.top.document.referrer;
if(m>3 && screen){
d=screen.colorDepth;
if(d==0)
d=screen.pixelDepth;
x=screen.width;
w=top.innerWidth?top.innerWidth:(top.document.documentElement && top.document.documentElement.clientWidth?top.document.documentElement.clientWidth:(top.document.body?top.document.body.clientWidth:0));
}
y=new Date();
y.setTime(y.getTime()-31536000000);
p.cookie="nvt=1";
c=(p.cookie.indexOf("nvt") != -1)?1:0;
p.cookie="nvt=1; expires="+y.toGMTString();
p.write("<a href=\"http://navrcholu.cz/Statistika/129296/\"><img src=\"http://c1.navrcholu.cz/hit?site=129296;t=o14;"
+"fv="+n3f8q+";js="+j+";cs="+c+";ref="+escape(r)+";cd="
+d+";sx="+x+";wx="+w+";jss=1;r="+Math.random()
+"\" width=\"14\" height=\"14\" alt=\"NAVRCHOLU.cz\" "+b+" /></a>"); }
nvc();
