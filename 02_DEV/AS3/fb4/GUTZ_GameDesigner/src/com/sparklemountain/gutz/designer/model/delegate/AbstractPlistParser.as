package com.sparklemountain.gutz.designer.model.delegate {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		AbstractPlistParser
	 * @package:	com.sparklemountain.gutz.designer.model.delegate
	 * @created:	5:28:54 PM Sep 6, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class AbstractPlistParser {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		
		protected var _data_xmlList:XMLList;
		protected var _data_xml:XML;
		
		protected var _data_obj:Object; 
		
		
		private var _key_str:String;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		
		// <*] class constructor [*>
		public function AbstractPlistParser(xml:XML) {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".CONSTRUCTOR("+xml+") [|-|]");
			
			/*
			if (xmlList.name() != "plist")
				throw "Root Element must be 'plist'.  Found: " + xmlList.name();
			
			if (xmlList.children().length() != 1)
				throw "'plist' element must contain a single 'dict' element.  Found multiple child elements";					
			*/
			
			this._data_xml = xml;
			this._data_obj = this.parse(this._data_xml);
			
			
			/*for each (var k1:* in this._data_obj) {
				trace ("\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]\n this._data_obj['"+k1+"'] = "+this._data_obj[k1]+"");
				
				if (k1) {
					var arr:Array = k1 as Array;
					
					for (var q:Number=0; q<arr.length; q++) {
						trace (" -[= arr["+q+"] = "+arr[q]+"");
						
						for each (var k2:* in (arr[q] as Object)) {
							trace (" -[= (arr["+q+"] as Object)['"+k2+"'] = "+(arr[q] as Object)[k2]+"\n");
						}
					}
				}
				
				//for each (var k2:* in ((this._data_obj[k1] as Array)[0] as Object)) {
				//	trace (" -[= this._data_obj['"+k1+"']['"+k2+"'] = "+(this._data_obj[k1] as Object)[k2]+"\n");
				//}
			}*/
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		
		private function parse(xml:XML):Object {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("\n[|-|] "+this+".parseXML['"+xml.name()+"']("+xml+") [|-|]");
			
			switch (xml.name().localName) {
				case 'plist':
					return (parse(xml.children()[0]));
					
				case 'dict':
					return (parseDict(xml));
					
				case 'array':
					return (parseArray(xml));
					
				case 'string':
					return (parseString(xml));
					
				case 'integer':
					return (parseInteger(xml));
					
				case 'real':
					return (parseNumber(xml));
					
				case 'data':
					return (parseData(xml));
					
				case 'date':
					return (parseDate(xml));
					
				case 'true': case 'false':
					return (parseBoolean(xml));
					
			}
			
			return (null);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		
		private function parseDict(xml:XML):Object {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseDict() [|-|]");
			
			var obj:Object = {};
			var children:XMLList = xml.children();
			
			for (var i:int=0, cnt:int=xml.children().length(); i<cnt; i+=2) {
				var key:String = children[i].text();
				
				trace ("  --["+key+"]["+String(children[i+1])+"]--")
				obj[key] = parse(children[i+1]);
			}
			
			for each (var k1:* in obj)
				trace ("\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=]\n obj['"+k1+"'] = "+obj[k1]+"");
			
			return (obj);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		
		private function parseArray(xml:XML):Object {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseArray() [|-|]");
			
			var arr:Array = [];
			
			for each (var el:XML in xml.children())
				arr.push(parse(el));
			
			return (arr);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		
		public function parseData(xml:XML):ByteArray {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".() [|-|]");
			
			var value:String = parseString(xml);
			
			var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(value);
			
			return (decoder.toByteArray());
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function parseDate(xml:XML):Date {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseDate() [|-|]");
		
			var ts:Number = Date.parse(parseString(xml));
			var d:Date = new Date();
				d.setTime(ts);
			
			return (d);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯	
		
		public function parseString(xml:XML):String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseString() [|-|]");
			
			return (xml.text());
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function parseInteger(xml:XML):int {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseInteger() [|-|]");
			
			return (parseInt(parseString(xml), 10));
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function parseNumber(xml:XML):Number {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseNumber() [|-|]");
			
			return (Number(parseString(xml)));
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function parseBoolean(xml:XML):Boolean {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			trace ("[|-|] "+this+".parseBoolean() [|-|]");
			
			return (xml.name() == 'true');
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
	}
}