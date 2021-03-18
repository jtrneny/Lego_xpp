if(!bbMainDomain){bbMainDomain="intext.billboard.cz"
}if(typeof bbCodeDomain=="undefined"){var bbCodeDomain="code."+bbMainDomain
}if((typeof skipCdn=="undefined")||skipCdn==false){var cdnPrefix="bbcdn."
}else{var cdnPrefix=""
}if(typeof bbSite=="string"){bbLibManager={_loadedLibs:{},_libsInHead:{},_fncDependencies:[],_libPath:"http://"+bbMainDomain+"/js/",_DomLoaded:false,_afterDOM:[],run:function(callFce,data,libNames,whenDomLoaded){var notLoadedLibs=[];
var libPaths={};
var libFile="",libName="";
for(var i=0;
i<libNames.length;
i++){libName=libNames[i].name;
if(typeof (libNames[i].file)=="undefined"||libNames[i].file==null){libFile=libNames[i].name
}else{libFile=libNames[i].file
}libFile=libFile.replace(/ /gi,"");
var path=libNames[i].path.replace(/ /gi,"")||this._libPath;
if(!this._loadedLibs[libName]){notLoadedLibs.push(libName);
libPaths[libName]=path+libFile
}}if(notLoadedLibs.length==0&&(!whenDomLoaded||(whenDomLoaded&&this._DomLoaded))){this._execute(callFce,data)
}else{this._fncDependencies.push({fce:callFce,data:data,libs:notLoadedLibs,whenDomLoaded:whenDomLoaded})
}for(var lib in libPaths){if(this._DomLoaded){this.download(lib,libPaths[lib])
}else{var that=this;
this._afterDOM.push(function(){that.download(lib,libPaths[lib])
})
}}},download:function(lib,path){if(this._loadedLibs[lib]||this._libsInHead[lib]){return 
}var head=document.getElementsByTagName("head")[0];
var script=document.createElement("script");
script.type="text/javascript";
script.src=path;
script.charset="utf-8";
head.appendChild(script);
this._libsInHead[lib]=true
},ready:function(libName){var fce;
var data;
var dom;
this._loadedLibs[libName]=true;
for(var i=0;
i<this._fncDependencies.length;
i++){for(var j=0;
j<this._fncDependencies[i].libs.length;
j++){if(this._fncDependencies[i].libs[j]==libName){this._fncDependencies[i].libs.splice(j,1)
}}if(this._fncDependencies[i].libs.length==0){fce=this._fncDependencies[i].fce;
data=this._fncDependencies[i].data;
dom=this._fncDependencies[i].whenDomLoaded;
if(!dom||(dom&&this._DomLoaded)){this._fncDependencies.splice(i,1);
this._execute(fce,data)
}}}},_execute:function(fce,data){if(typeof fce=="function"){fce(data)
}else{if(typeof fce=="string"){if(!fce.match(/\([^)]*\)/gi)){fce+="(data)"
}eval(fce)
}}},domLoaded:function(){this._DomLoaded=true;
for(var i=0;
i<this._afterDOM.length;
i++){this._afterDOM[i]()
}this.ready("DOM")
}};
(function(){var DomReady=window.DomReady={};
var userAgent=navigator.userAgent.toLowerCase();
var browser={version:(userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/)||[])[1],safari:/webkit/.test(userAgent),opera:/opera/.test(userAgent),msie:(/msie/.test(userAgent))&&(!/opera/.test(userAgent)),mozilla:(/mozilla/.test(userAgent))&&(!/(compatible|webkit)/.test(userAgent))};
var readyBound=false;
var isReady=false;
var readyList=[];
function domReady(){if(!isReady){isReady=true;
if(readyList){for(var fn=0;
fn<readyList.length;
fn++){readyList[fn].call(window,[])
}readyList=[]
}}}function addLoadEvent(func){var oldonload=window.onload;
if(typeof window.onload!="function"){window.onload=func
}else{window.onload=function(event){if(oldonload){oldonload(event)
}func()
}
}}function bindReady(){if(readyBound){return 
}readyBound=true;
if(document.addEventListener&&!browser.opera){document.addEventListener("DOMContentLoaded",domReady,false)
}if(browser.msie&&window==top){(function(){if(isReady){return 
}try{document.documentElement.doScroll("left")
}catch(error){setTimeout(arguments.callee,0);
return 
}domReady()
})()
}if(browser.opera){document.addEventListener("DOMContentLoaded",function(){if(isReady){return 
}for(var i=0;
i<document.styleSheets.length;
i++){if(document.styleSheets[i].disabled){setTimeout(arguments.callee,0);
return 
}}domReady()
},false)
}if(browser.safari){var numStyles;
(function(){if(isReady){return 
}if(document.readyState!="loaded"&&document.readyState!="complete"){setTimeout(arguments.callee,0);
return 
}if(numStyles===undefined){var links=document.getElementsByTagName("link");
for(var i=0;
i<links.length;
i++){if(links[i].getAttribute("rel")=="stylesheet"){numStyles++
}}var styles=document.getElementsByTagName("style");
numStyles+=styles.length
}if(document.styleSheets.length!=numStyles){setTimeout(arguments.callee,0);
return 
}domReady()
})()
}addLoadEvent(domReady)
}DomReady.ready=function(fn,args){bindReady();
if(isReady){fn.call(window,[])
}else{readyList.push(function(){return fn.call(window,[])
})
}};
bindReady()
})();
DomReady.ready(function(){bbLibManager.domLoaded()
});
bbLibManager.run(function(){var url=window.location.href;
url=url.replace(/^[^/]+\/\//,"");
var endIndex=url.indexOf("?");
if(endIndex<0){endIndex=url.length
}url=url.substring(0,endIndex);
var fileName=url.replace(/\/|\\/g,"_");
bbLibManager.run("bbt.run()","",[{name:"wp.js",path:"http://"+cdnPrefix+bbCodeDomain+"/wp/"+bbSite+"/"},{name:"settings.js",path:"http://"+cdnPrefix+bbCodeDomain+"/codesettings/"+bbSite+"/"},{name:"globalSettings.js",path:"http://"+cdnPrefix+bbCodeDomain+"/codesettings/"},{name:"bubbleDesigner.js",path:"http://"+cdnPrefix+bbCodeDomain+"/codesettings/"+bbSite+"/"},{name:"sendWords",path:"http://"+bbCodeDomain+"/pages/"+bbSite+"/",file:fileName}],true)
},"",[{name:"bbt3.js",path:"http://"+cdnPrefix+bbCodeDomain+"/code/"}],false)
};