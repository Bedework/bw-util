/*
All credits to zichun. Original source code found at
http://www.thecodeproject.com/jscript/jsactb.asp

License
This control is published under Creative Common License by the original author.

Modified by Satish Sekharan, Jan 16 2005
Added XMLHttpRequest method and additional code to implement 
a backend database integration with the auto complete text box. 

*/

// global flag
var isIE = false;

// Script used to retrieve the database table info
var url = " ";

// global request and XML document objects for location request
var reqLocation;

// global request and XML document objects for sponsor request
var reqSponsor;

// Location array 
var locations= new Array(" ");

// Sponsor array 
var sponsors= new Array(" ");


/* Auto complete text box function */

/*    Caret Functions     */
function getCaretEnd(obj){
	if(typeof obj.selectionEnd != "undefined"){
		return obj.selectionEnd;
	}else if(document.selection && document.selection.createRange){
		var M=document.selection.createRange();
		var Lp=obj.createTextRange();
		Lp.setEndPoint("EndToEnd",M);
		var rb=Lp.text.length;
		if(rb>obj.value.length){
			return -1;
		}
		return rb;
	}
}
function getCaretStart(obj){
	if(typeof obj.selectionStart != "undefined"){
		return obj.selectionStart;
	}else if(document.selection && document.selection.createRange){
		var M=document.selection.createRange();
		var Lp=obj.createTextRange();
		Lp.setEndPoint("EndToStart",M);
		var rb=Lp.text.length;
		if(rb>obj.value.length){
			return -1;
		}
		return rb;
	}
}
function setCaret(obj,l){
	obj.focus();
	if (obj.setSelectionRange){
		obj.setSelectionRange(l,l);
	}else if(obj.createTextRange){
		m = obj.createTextRange();		
		m.moveStart('character',l);
		m.collapse();
		m.select();
	}
}
/* ----------------- */

/*    Escape function   */
String.prototype.addslashes = function(){
	return this.replace(/(["\\\.\|\[\]\^\*\+\?\$\(\)])/g, '\\$1');
}
String.prototype.trim = function () {
    return this.replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1");
}; 


function autoComplete(obj,evt,ca){
	/* ---- Variables ---- */
	var autoComplete_timeOut = -1; // Autocomplete Timeout in ms (-1: autocomplete never time out)
	var autoComplete_lim = 10;      // Number of elements autocomplete can show (-1: no limit)
	var autoComplete_firstText = true; // should the auto complete be limited to the beginning of keyword?
	var autoComplete_mouse = true; // Enable Mouse Support
	var autoComplete_delimiter = new Array();  // Delimiter for multiple autocomplete. Set it to empty array for single autocomplete
	/* ---- Variables ---- */

	/* ---- Don't touch :P---- */
	var autoComplete_delimwords = new Array();
	var autoComplete_cdelimword = 0;
	var autoComplete_delimchar = new Array();
	var autoComplete_keywords = new Array();
	var autoComplete_display = false;
	var autoComplete_pos = 0;
	var autoComplete_total = 0;
	var autoComplete_curr = null;
	var autoComplete_rangeu = 0;
	var autoComplete_ranged = 0;
	var autoComplete_bool = new Array();
	var autoComplete_pre = 0;
	var autoComplete_toid;
	var autoComplete_tomake = false;
	var autoComplete_getpre = "";
	var autoComplete_mouse_on_list = true;
	var autoComplete_kwcount = 0;
	var autoComplete_caretmove = false;
	/* ---- "Constants" ---- */

	
	autoComplete_keywords = ca;
	autoComplete_curr = obj;
	
	var oldkeydownhandler = document.onkeydown;
	var oldblurhandler = obj.onblur;
	var oldkeypresshandler = obj.onkeypress;

	document.onkeydown = autoComplete_checkkey;
	obj.onblur = autoComplete_clear;
	obj.onkeypress = autoComplete_keypress;
	
	function autoComplete_clear(evt){
		if (!evt) evt = event;
		document.onkeydown = oldkeydownhandler;
		autoComplete_curr.onblur = oldblurhandler;
		autoComplete_curr.onkeypress = oldkeypresshandler;
		autoComplete_removedisp();
	}
	function autoComplete_parse(n){
		if (autoComplete_delimiter.length > 0){
			var t = autoComplete_delimwords[autoComplete_cdelimword].trim().addslashes();
			var plen = autoComplete_delimwords[autoComplete_cdelimword].trim().length;
		}else{
			var t = autoComplete_curr.value.addslashes();
			var plen = autoComplete_curr.value.length;
		}
		var tobuild = '';
		var i;

		if (autoComplete_firstText){
			var re = new RegExp("^" + t, "i");
		}else{
			var re = new RegExp(t, "i");
		}
		var p = n.search(re);
				
		for (i=0;i<p;i++){
			tobuild += n.substr(i,1);
		}
		tobuild += "<span class='autoCompleteMatched'>"
		for (i=p;i<plen+p;i++){
			tobuild += n.substr(i,1);
		}
		tobuild += "</span>";
		for (i=plen+p;i<n.length;i++){
			tobuild += n.substr(i,1);
		}
		return tobuild;
	}
	function curTop(){
		autoComplete_toreturn = 0;
		obj = autoComplete_curr;
		while(obj){
			autoComplete_toreturn += obj.offsetTop;
			obj = obj.offsetParent;
		}
		return autoComplete_toreturn;
	}
	function curLeft(){
		autoComplete_toreturn = 0;
		obj = autoComplete_curr;
		while(obj){
			autoComplete_toreturn += obj.offsetLeft;
			obj = obj.offsetParent;
		}
		return autoComplete_toreturn;
	}
	function autoComplete_generate(){
		if (document.getElementById('tat_table')){ autoComplete_display = false;document.body.removeChild(document.getElementById('tat_table')); } 
		if (autoComplete_kwcount == 0){
			autoComplete_display = false;
			return;
		}
		a = document.createElement('table');
		a.style.position='absolute';
		a.style.top = eval(curTop() + autoComplete_curr.offsetHeight) + "px";
		a.style.left = curLeft() + "px";
		a.className = "autoCompleteTable";
		a.id = 'tat_table';
		document.body.appendChild(a);
		var i;
		var first = true;
		var j = 1;
		if (autoComplete_mouse){
			a.onmouseout= autoComplete_table_unfocus;
			a.onmouseover=autoComplete_table_focus;
		}
		var counter = 0;
		for (i=0;i<autoComplete_keywords.length;i++){
			if (autoComplete_bool[i]){
				counter++;
				r = a.insertRow(-1);
				if (first && !autoComplete_tomake){
					r.className = "autoCompleteHover";;
					first = false;
					autoComplete_pos = counter;
				}else if(autoComplete_pre == i){
					r.className = "autoCompleteHover";;
					first = false;
					autoComplete_pos = counter;
				}else{
					r.className = "autoCompleteNormal";
				}
				r.id = 'tat_tr'+(j);
				c = r.insertCell(-1);
				c.innerHTML = autoComplete_parse(autoComplete_keywords[i]);
				c.id = 'tat_td'+(j);
				c.setAttribute('pos',j);
				if (autoComplete_mouse){
					c.onclick=autoComplete_mouseclick;
					c.onmouseover = autoComplete_table_highlight;
				}
				j++;
			}
			if (j - 1 == autoComplete_lim && j < autoComplete_total){
				r = a.insertRow(-1);
				r.className = "autoCompleteNormal";
				break;
			}
		}
		autoComplete_rangeu = 1;
		autoComplete_ranged = j-1;
		autoComplete_display = true;
		if (autoComplete_pos <= 0) autoComplete_pos = 1;
	}
	function autoComplete_remake(){
		document.body.removeChild(document.getElementById('tat_table'));
		a = document.createElement('table');
		a.style.position='absolute';
		a.style.top = eval(curTop() + autoComplete_curr.offsetHeight) + "px";
		a.style.left = curLeft() + "px";
		a.className = "autoCompleteTable";
		a.id = 'tat_table';
		if (autoComplete_mouse){
			a.onmouseout= autoComplete_table_unfocus;
			a.onmouseover=autoComplete_table_focus;
		}
		document.body.appendChild(a);
		var i;
		var first = true;
		var j = 1;

		for (i=0;i<autoComplete_keywords.length;i++){
			if (autoComplete_bool[i]){
				if (j >= autoComplete_rangeu && j <= autoComplete_ranged){
					r = a.insertRow(-1);
					r.className = "autoCompleteNormal";
					r.id = 'tat_tr'+(j);
					c = r.insertCell(-1);
					c.innerHTML = autoComplete_parse(autoComplete_keywords[i]);
					c.id = 'tat_td'+(j);
					c.setAttribute('pos',j);
					if (autoComplete_mouse){
						c.onclick=autoComplete_mouseclick;
						c.onmouseover = autoComplete_table_highlight;
					}
					j++;
				}else{
					j++;
				}
			}
			if (j > autoComplete_ranged) break;
		}
		if (j-1 < autoComplete_total){
			r = a.insertRow(-1);
			r.className = "autoCompleteNormal";
		}
	}
	function autoComplete_goup(){
		if (!autoComplete_display) return;
		if (autoComplete_pos == 1) return;
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteNormal";
		autoComplete_pos--;
		if (autoComplete_pos < autoComplete_rangeu) autoComplete_moveup();
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteHover";
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list=0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	function autoComplete_godown(){
		if (!autoComplete_display) return;
		if (autoComplete_pos == autoComplete_total) return;
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteNormal";
		autoComplete_pos++;
		if (autoComplete_pos > autoComplete_ranged) autoComplete_movedown();
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteHover";
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list=0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	function autoComplete_movedown(){
		autoComplete_rangeu++;
		autoComplete_ranged++;
		autoComplete_remake();
	}
	function autoComplete_moveup(){
		autoComplete_rangeu--;
		autoComplete_ranged--;
		autoComplete_remake();
	}

	/* Mouse */
	function autoComplete_mouse_down(){
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteNormal";
		autoComplete_pos++;
		autoComplete_movedown();
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteHover";
		autoComplete_curr.focus();
		autoComplete_moue_on_list = 0;
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list=0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	function autoComplete_mouse_up(evt){
		if (!evt) evt = event;
		if (evt.stopPropagation){
			evt.stopPropagation();
		}else{
			evt.cancelBubble = true;
		}
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteNormal";
		autoComplete_pos--;
		autoComplete_moveup();
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteHover";
		autoComplete_curr.focus();
		autoComplete_moue_on_list = 0;
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list=0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	function autoComplete_mouseclick(evt){
		if (!evt) evt = event;
		if (!autoComplete_display) return;
		autoComplete_mouse_on_list = 0;
		autoComplete_pos = this.getAttribute('pos');
		autoComplete_penter();
	}
	function autoComplete_table_focus(){
		autoComplete_mouse_on_list = 1;
	}
	function autoComplete_table_unfocus(){
		autoComplete_mouse_on_list = 0;
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list = 0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	function autoComplete_table_highlight(){
		autoComplete_mouse_on_list = 1;
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteNormal";
		autoComplete_pos = this.getAttribute('pos');
		while (autoComplete_pos < autoComplete_rangeu) autoComplete_moveup();
		while (autoComplete_pos > autoComplete_ranged) autoComplete_mousedown();
		document.getElementById('tat_tr'+autoComplete_pos).className = "autoCompleteHover";
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list = 0;autoComplete_removedisp();},autoComplete_timeOut);
	}
	/* ---- */

	function autoComplete_insertword(a){
		if (autoComplete_delimiter.length > 0){
			str = '';
			l=0;
			for (i=0;i<autoComplete_delimwords.length;i++){
				if (autoComplete_cdelimword == i){
					str += a;
					l = str.length;
				}else{
					str += autoComplete_delimwords[i];
				}
				if (i != autoComplete_delimwords.length - 1){
					str += autoComplete_delimchar[i];
				}
			}
			autoComplete_curr.value = str;
			setCaret(autoComplete_curr,l);
		}else{
			autoComplete_curr.value = a;
		}
		autoComplete_mouse_on_list = 0;
		autoComplete_removedisp();
	}
	function autoComplete_penter(){
		if (!autoComplete_display) return;
		autoComplete_display = false;
		var word = '';
		var c = 0;
		for (var i=0;i<=autoComplete_keywords.length;i++){
			if (autoComplete_bool[i]) c++;
			if (c == autoComplete_pos){
				word = autoComplete_keywords[i];
				break;
			}
		}
		autoComplete_insertword(word);
	}
	function autoComplete_removedisp(){
		if (!autoComplete_mouse_on_list){
			autoComplete_display = false;
			if (document.getElementById('tat_table')){ document.body.removeChild(document.getElementById('tat_table')); }
			if (autoComplete_toid) clearTimeout(autoComplete_toid);
		}
	}
	function autoComplete_keypress(){
		return !autoComplete_caretmove;
	}
	function autoComplete_checkkey(evt){
		if (!evt) evt = event;
		a = evt.keyCode;
		caret_pos_start = getCaretStart(autoComplete_curr);
		autoComplete_caretmove = 0;
		switch (a){
			case 38:
				autoComplete_goup();
				autoComplete_caretmove = 1;
				return false;
				break;
			case 40:
				autoComplete_godown();
				autoComplete_caretmove = 1;
				return false;
				break;
   		    case 9:
				return false;
				break;
			case 13:
				autoComplete_penter();
				autoComplete_caretmove = 1;
				return false;
				break;
			default:
				setTimeout(function(){autoComplete_tocomplete(a)},50);
				break;
		}
	}

	function autoComplete_tocomplete(kc){
		if (kc == 38 || kc == 40 || kc == 13) return;
		var i;
		if (autoComplete_display){ 
			var word = 0;
			var c = 0;
			for (var i=0;i<=autoComplete_keywords.length;i++){
				if (autoComplete_bool[i]) c++;
				if (c == autoComplete_pos){
					word = i;
					break;
				}
			}
			autoComplete_pre = word;
		}else{ autoComplete_pre = -1};
		
		if (autoComplete_curr.value == ''){
			autoComplete_mouse_on_list = 0;
			autoComplete_removedisp();
			return;
		}
		if (autoComplete_delimiter.length > 0){
			caret_pos_start = getCaretStart(autoComplete_curr);
			caret_pos_end = getCaretEnd(autoComplete_curr);
			
			delim_split = '';
			for (i=0;i<autoComplete_delimiter.length;i++){
				delim_split += autoComplete_delimiter[i];
			}
			delim_split = delim_split.addslashes();
			delim_split_rx = new RegExp("(["+delim_split+"])");
			c = 0;
			autoComplete_delimwords = new Array();
			autoComplete_delimwords[0] = '';
			for (i=0,j=autoComplete_curr.value.length;i<autoComplete_curr.value.length;i++,j--){
				if (autoComplete_curr.value.substr(i,j).search(delim_split_rx) == 0){
					ma = autoComplete_curr.value.substr(i,j).match(delim_split_rx);
					autoComplete_delimchar[c] = ma[1];
					c++;
					autoComplete_delimwords[c] = '';
				}else{
					autoComplete_delimwords[c] += autoComplete_curr.value.charAt(i);
				}
			}

			var l = 0;
			autoComplete_cdelimword = -1;
			for (i=0;i<autoComplete_delimwords.length;i++){
				if (caret_pos_end >= l && caret_pos_end <= l + autoComplete_delimwords[i].length){
					autoComplete_cdelimword = i;
				}
				l+=autoComplete_delimwords[i].length + 1;
			}
			var t = autoComplete_delimwords[autoComplete_cdelimword].addslashes().trim();
		}else{
			var t = autoComplete_curr.value.addslashes();
		}
		if (autoComplete_firstText){
			var re = new RegExp("^" + t, "i");
		}else{
			var re = new RegExp(t, "i");
		}
		
		autoComplete_total = 0;
		autoComplete_tomake = false;
		autoComplete_kwcount = 0;
		for (i=0;i<autoComplete_keywords.length;i++){
			autoComplete_bool[i] = false;
			if (re.test(autoComplete_keywords[i])){
				autoComplete_total++;
				autoComplete_bool[i] = true;
				autoComplete_kwcount++;
				if (autoComplete_pre == i) autoComplete_tomake = true;
			}
		}
		if (autoComplete_toid) clearTimeout(autoComplete_toid);
		if (autoComplete_timeOut > 0) autoComplete_toid = setTimeout(function(){autoComplete_mouse_on_list = 0;autoComplete_removedisp();},autoComplete_timeOut);
		autoComplete_generate();
	}
}
