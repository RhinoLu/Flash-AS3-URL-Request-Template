package gtap.utils{
	
	public class Checker {

		/*demo usage
		 //==========================================================================================
		var list:Array = new Array({type:"p",tar:"姓名",value:name_txt.text});
		var ft:Checker = new Checker(list);
		ft.CheckAll();
		
		
		
		//校驗普通電話、傳真號碼：可以“+”開頭，除數字外，可含有“-”
function isTel(s)
{
//var patrn=/^[+]{0,1}(d){1,3}[ ]?([-]?(d){1,12})+$/;
var patrn=/^[+]{0,1}(d){1,3}[ ]?([-]?((d)|[ ]){1,12})+$/;
if (!patrn.exec(s)) return false
return true
}

//校驗手機號碼：必須以數位開頭，除數字外，可含有“-”
function isMobil(s)
{
var patrn=/^[+]{0,1}(d){1,3}[ ]?([-]?((d)|[ ]){1,12})+$/;
if (!patrn.exec(s)) return false
return true
}
		//==========================================================================================
		*/
		public var clist:Array;
		public var elist:Array;

		public function Checker(listin:Array = null) {
			clist = listin;
		}
		public function CheckAll():Boolean {
			elist = new Array();
			for (var s:Number = 0; s < clist.length; s++) {
				checkOne(clist[s]);
			}
			if (elist.length > 0) {
				return false;
			} else {
				return true;
			}
		}
		public function results() {
			var outs:String = "";
			for (var p = 0; p < elist.length; p++) {
				outs += elist[p] + "\r";
			}
			return outs;
		}
		public function checkOne(oin:Object) {
			//get the type
			var types:Array = oin.type.split(",");
			for (var t:Number = 0; t < types.length; t++) {
				switch (types[t]) {
					case "txt" :
						//純文字檢查
						if (Checker.isEmpty(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push("請輸入" + oin.tar);
							}
						}
						break;
					case "eng" :
						//純英文字檢查
						if (Checker.isEng(oin.value)) {
							if (oin.autotxt == false) {
								elist.push(oin.tar);
							}else {
								elist.push(oin.tar+"請輸入英文");
							}
						}
						break;
					case "number" :
						//純數字檢查
						if (!Checker.isNumber(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push(oin.tar + "請輸入數字");
							}
						}
						break;
					case "email" :
						//Email檢查
						if (!Checker.isEmail(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push(oin.tar + "請輸入有效電子信箱");
							}
						}
						break;
					case "id" :
						//身分證字號檢查
						if (!Checker.isID(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push(oin.tar + "請輸入有效身分證字號");
							}
						}
						break;
					case "date" :
						//日期檢查
						if (!Checker.isBday(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push(oin.tar + "請輸入有效日期");
							}
						}
						break;
					case "radio" :
						//radio檢查
						if (!radioSelected(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push("請選擇" + oin.tar);
							}
						}
						break;
					case "combo" :
						if (!comboSelected(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push("請選擇" + oin.tar);
							}
						}
						break;
					case "droplab" :
						if (!droplabSelected(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push("請選擇" + oin.tar);
							}
						}
						break;
					case "file" :
						if (!fileSelected(oin.value)) {
							if(oin.autotxt==false){
								elist.push(oin.tar);
							}else {
								elist.push("請選擇" + oin.tar);
							}
						}
						break;
				}
			}
		}
		public static function isEmpty(v:String):Boolean {
			v = trim(v);
			if (v.length < 1) {
				return true;
			} else {
				return false;
			}
		}
		public static function isEng(v:String):Boolean {
			v = trim(v);
			var eng:RegExp = /^[A-Za-z]+$/;
			if (eng.test(v)) {
				return false;
			} else {
				return true;
			}
			return false;
		}
		public static function isEmail(v:String):Boolean {
			v = trim(v);
			var email:RegExp = /^[\w][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return email.test(v);
		}
		public static function isNumber(v:String):Boolean {
			//var num:RegExp = /^\d/;
			var num:RegExp = /^[0-9]+$/;
			return num.test(v);
		}
		public static function isBday(v:String):Boolean {
			//the "/^/i" part is the body
			//check for "yyyy-mm-dd"
			var checkp:RegExp = /^\d{4}-\d{1,2}-\d{1,2}/i;
			//first time use regex to check
			if (checkp.test(v)) {
				//year part
				var year:Number = Number(v.substr(0,4));
				var month:Number = Number(v.substring(v.indexOf("-")+1,v.lastIndexOf("-")));
				var day:Number = Number(v.substr(v.lastIndexOf("-")+1));
				if (month>12 || day>31) {
					return false;
				}
				//31 days month check
				if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
					if (day>31) {
						return false;
					}
				} else {
					//30 days check
					if (month!=2) {
						if (day>30) {
							return false;
						}
					} else {
						//leap year cheak,if it is not leap year and more than 28 days return false;
						if (year%4!=0) {
							if (day>28) {
								return false;
							}
						}
					}
				}
				return true;
			} else {
				return false;
			}
		}

		public static function isID(input:String):Boolean {
			if (input.length != 10) {
				return false;
			}
			var tempc:String = input.substr(0, 1);
			tempc = tempc.toUpperCase();
			//see if ths is in //A~Z
			var inList:Boolean = false;
			for (var x = 65; x<91; x++) {
				//A~Z => 65~90
				if (tempc == String.fromCharCode(x)) {
					inList = true;
				}
			}
			if (inList == false) {
				return false;
			}
			var tempn:String = input.substring(1, 10);
			if (!isNumber(tempn)) {
				return false;
			}
			//validate ID by ID rules
			var clist:Array = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
			var nlist:Array = new Array(10, 11, 12, 13, 14, 15, 16, 17, 34, 18, 19, 20, 21, 22, 35, 23, 24, 25, 26, 27, 28, 29, 32, 30, 31, 33);
			var tempadd:Number = 0;
			for (x = 0; x<clist.length; x++) {
				if (tempc == clist[x]) {
					tempadd = nlist[x];
				}
			}
			//put the english alphabet decoded number into to one digit and multiple it by 1 and 9
			var value1:Number = Number(tempadd.toString().substr(0, 1));
			var value2:Number = Number(tempadd.toString().substr(1, 1));
			value1 = value1*1;
			value2 = value2*9;
			var value3:Number = 0;
			for (var k = 1; k<9; k++) {
				var tempNum:Number = Number(input.substr(k, 1))*(9-k);
				value3 += tempNum;
				//trace( "k"+ k + " : "+ input.substr(k,1)+ " : "+tempNum);
			}
			var totalvalue:Number = value1+value2+value3;
			var cNum:Number = totalvalue%10;
			var tocheck = Number(input.substr(9, 1));
			//trace(totalvalue + " : "+cNum + " : "+tocheck);
			if (cNum != 0) {
				//trace(10-cNum);
				if (10-cNum == tocheck) {
					return true;
				} else {
					return false;
				}
			} else {
				//when cNum value is 0 , we simplely check if it is 0 on checkNumber
				if (cNum == tocheck) {
					return true;
				} else {
					return false;
				}
			}
		}
		public static function radioSelected(v:String) {
			//trace("radioSelected:"+v)
			return v == null?false:true;
		}
		public static function comboSelected(v:String) {
			return v == "請選擇"?false:true;
		}
		public static function droplabSelected(v:String) {
			return v == "請選擇"?false:true;
		}
		public static function fileSelected(v:String) {
			trace("fileSelected:"+v)
			return v == null?false:true;
		}
		public static function trim( value:String ):String {
			var LTrimExp:RegExp = /^(\s|\n|\r|\t|\v)*/m;
			var RTrimExp:RegExp = /(\s|\n|\r|\t|\v)*$/;
			value = value.replace(LTrimExp, "");
			value = value.replace(RTrimExp, "");
			return value;
		}
	}
}