var ACN = ACN || {};
ACN.JSLibrary = ACN.JSLibrary || {};

ACN = function (configObject) {
    this.version = '1.00.00';
    
    for ( propertyName in configObject ) {
        this[propertyName] = configObject[propertyName];
    }
	
	//this["pSBC"] = pSBC;
	this["colorShadeBlendConvert"] = colorShadeBlendConvert;
}

ACN.prototype = {
    getVersion: function (configObject) {
        var acn = this;

		return acn.version;
	}
}

ACN.JSLibrary = function (configObject) {
    this.version = '1.00.00';
    this.acn = new ACN(configObject);
    
    for ( propertyName in configObject ) {
        this[propertyName] = configObject[propertyName];
    }
}

ACN.JSLibrary.prototype = {
    getUrlParameterByName: function (configObject) {
        var acnlib = this;
        var acn = acnlib.acn;
        var returnObject = {};
		
		var url = configObject.urlOrUri;
		var name = configObject.urlParameterName;
		
        if (!url) { 
			url = window.location.href;
		}
        name = name.replace(/[\[\]]/g, '\\$&').replace("queryParam.","");
        var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }   
}

/*
const pSBC=(p,c0,c1,l)=>{
	let r,g,b,P,f,t,h,i=parseInt,m=Math.round,a=typeof(c1)=="string";
	if(typeof(p)!="number"||p<-1||p>1||typeof(c0)!="string"||(c0[0]!='r'&&c0[0]!='#')||(c1&&!a))return null;
	if(!this.pSBCr)this.pSBCr=(d)=>{
		let n=d.length,x={};
		if(n>9){
			[r,g,b,a]=d=d.split(","),n=d.length;
			if(n<3||n>4)return null;
			x.r=i(r[3]=="a"?r.slice(5):r.slice(4)),x.g=i(g),x.b=i(b),x.a=a?parseFloat(a):-1
		}else{
			if(n==8||n==6||n<4)return null;
			if(n<6)d="#"+d[1]+d[1]+d[2]+d[2]+d[3]+d[3]+(n>4?d[4]+d[4]:"");
			d=i(d.slice(1),16);
			if(n==9||n==5)x.r=d>>24&255,x.g=d>>16&255,x.b=d>>8&255,x.a=m((d&255)/0.255)/1000;
			else x.r=d>>16,x.g=d>>8&255,x.b=d&255,x.a=-1
		}return x};
	h=c0.length>9,h=a?c1.length>9?true:c1=="c"?!h:false:h,f=pSBCr(c0),P=p<0,t=c1&&c1!="c"?pSBCr(c1):P?{r:0,g:0,b:0,a:-1}:{r:255,g:255,b:255,a:-1},p=P?p*-1:p,P=1-p;
	if(!f||!t)return null;
	if(l)r=m(P*f.r+p*t.r),g=m(P*f.g+p*t.g),b=m(P*f.b+p*t.b);
	else r=m((P*f.r**2+p*t.r**2)**0.5),g=m((P*f.g**2+p*t.g**2)**0.5),b=m((P*f.b**2+p*t.b**2)**0.5);
	a=f.a,t=t.a,f=a>=0||t>=0,a=f?a<0?t:t<0?a:a*P+t*p:0;
	if(h)return"rgb"+(f?"a(":"(")+r+","+g+","+b+(f?","+m(a*1000)/1000:"")+")";
	else return"#"+(4294967296+r*16777216+g*65536+b*256+(f?m(a*255):0)).toString(16).slice(1,f?undefined:-2)
}
*/

const colorShadeBlendConvert = function (percentage, fromColor, toColor, useRadial){
	//percentage: Used, as a percentage, with typical range of -1.0 to 1.0. Out of range parameter will cause a return of null.
	var toColorIsString = typeof(toColor)=="string";
	var red = 0;
	var green = 0;
	var blue = 0;
	var alpha = 0;

	if( typeof(percentage)!="number" || percentage <- 1 || percentage > 1 || typeof ( fromColor ) != "string" || (fromColor[0] != 'r' && fromColor[0] != '#') || ( toColor && !toColorIsString )) {
		return null;
	}

	if( !this.colorShadeBlendConverter ){ 
		this.colorShadeBlendConverter = function(color) {
			var colorStringLength = color.length;
			var colorObject = {};

			if(colorStringLength > 9) {
				var colorArray = color.split(",");
				if (colorArray && colorArray.length > 0) {
					red = colorArray[0];
				}
				if (colorArray && colorArray.length > 1) {
					green = colorArray[1];
				}
				if (colorArray && colorArray.length > 2) {
					blue = colorArray[2];
				}
				if (colorArray && colorArray.length > 3) {
					alpha = colorArray[3];
				}
				//[red, green, blue, alpha] = (color = color.split(","));
				var colorArrayLength = colorArray.length;
				if ( colorArrayLength < 3 || colorArrayLength > 4 ) {
					return null;
				}
				//Separate rgb from rgba (only for first color (red)
				colorObject.red = parseInt(red[3] == "a" ? red.slice(5) : red.slice(4));
				colorObject.green = parseInt(green);
				colorObject.blue = parseInt(blue);
				colorObject.alpha = alpha ? parseFloat(alpha) : -1;
			}
			else {
				if ( colorArrayLength == 8 || colorArrayLength == 6 || colorArrayLength < 4) {
					return null;
				}
				if ( colorArrayLength < 6 ) {
					color = "#" + color[1] + color[1] + color[2] + color[2] + color[3] + color[3] + ( colorArrayLength > 4 ? color[4] + color[4] : "");
				}
				color = parseInt(color.slice(1),16);
				if ( colorArrayLength == 9 || colorArrayLength == 5 ) {
					colorObject.red = color >> 24 & 255;
					colorObject.green = color >> 16 & 255;
					colorObject.blue = color >> 8 & 255;
					colorObject.alpha = Math.round ((d&255)/0.255)/1000;
				}
				else {
					colorObject.red = color >> 16;
					colorObject.green = color >> 8 & 255;
					colorObject.blue = color & 255;
					colorObject.alpha = -1;
				}
			}
			
			return colorObject;
		};
	}
	
	var fromColorIsRgb = fromColor.length > 9;
	fromColorIsRgb = toColorIsString ? toColor.length > 9 ? true : toColor == "c" ? !fromColorIsRgb : false : fromColorIsRgb;
	var fromColorObject = this.colorShadeBlendConverter(fromColor);
	var toColorObject = toColor && toColor != "c" ? this.colorShadeBlendConverter(toColor) : makeDarker ? {red: 0, green: 0, blue: 0, alpha: -1} : {red: 255, green: 255, blue: 255, alpha: -1};
	var makeDarker = percentage < 0;
	var blendPercentage = 1 - percentage;
	percentage = makeDarker ? percentage * -1 : percentage;

	if (!fromColorObject || !toColorObject) {
		return null;
	}

	if (useRadial) {
		red = Math.round ( ( blendPercentage * fromColorObject.red ^ 2 + percentage * toColorObject.red ^ 2 ) ^ 0.5 );
		green = Math.round ( ( blendPercentage * fromColorObject.green ^ 2 + percentage * toColorObject.green ^ 2 ) ^ 0.5 );
		blue = Math.round ( ( blendPercentage * fromColorObject.blue ^ 2 + percentage * toColorObject.blue ^ 2 ) ^ 0.5 );
	}
	else {
		red = Math.round ( blendPercentage * fromColorObject.red + percentage * toColorObject.red );
		green = Math.round ( blendPercentage * fromColorObject.green + percentage * toColorObject.green );
		blue = Math.round ( blendPercentage * fromColorObject.blue + percentage * toColorObject.blue );
	}

	var fromColorAlpha = fromColorObject.alpha;
	var toColorAlpha = toColorObject.alpha;
	var hasTransparency = fromColorAlpha >= 0 || toColorAlpha >= 0;
	
	fromColorAlpha = hasTransparency ? fromColorAlpha < 0 ? toColorAlpha : toColorAlpha < 0 ? fromColorAlpha : fromColorAlpha * percentage + toColorAlpha * percentage: 0;
	
	var newColor = fromColor;
	if (fromColorIsRgb) {
		newColor = "rgb" + (hasTransparency ? "a(":"(") + red + "," + green + "," + blue + (hasTransparency ? "," + Math.round ( alpha * 1000 ) / 1000 : "" ) + ")";
	}
	else {
		newColor =  "#" + (4294967296 + red * 16777216 + green * 65536 + blue * 256 + (hasTransparency ? Math.round ( alpha * 255 ) : 0 ) ).toString(16).slice(1, hasTransparency ? undefined : -2);
	}
	
	//console.log ("fromColor: " + fromColor);
	//console.log ("newColor: " + newColor);
	//debugger;
	
	return newColor;
}
