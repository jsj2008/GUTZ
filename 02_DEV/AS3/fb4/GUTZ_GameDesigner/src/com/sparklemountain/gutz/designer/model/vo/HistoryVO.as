package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		HistoryVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	2:52:25 PM Sep 2, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class HistoryVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public var prevSelect_type:int;
		public var nextSelect_type:int;
		
		public var part_arr:Array;
		public var acts_arr:Array;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		
		// <*] class constructor [*>
		public function HistoryVO(prev:int=-1, next:int=-1) {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			acts_arr = new Array();
			part_arr = new Array();
			
			prevSelect_type = prev;
			nextSelect_type = next;
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		public function stepSelect(type:int=-1):void {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			prevSelect_type = nextSelect_type;
			nextSelect_type = type;
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function increment(type:String, vo:AbstractBodyVO):void {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			acts_arr.push(new ActionVO(type, vo));
		}
		
		public function undo():ActionVO {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			return (acts_arr.pop() as ActionVO);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function reset(type:int=-1):void {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			acts_arr = new Array();
			
			prevSelect_type = type;
			nextSelect_type = type;
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function get undoSteps():int {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			return (acts_arr.length);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		public function getAction(steps:int=1):ActionVO {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			var ind:int = acts_arr.length - steps;
			return (acts_arr[ind] as ActionVO);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		
		
		public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[prevSelect_type]: "+this.prevSelect_type;
				ret_str += "\n[nextSelect_type]: "+this.nextSelect_type;
				ret_str += "\n[part_arr]: "+this.part_arr;
				ret_str += "\n[acts_arr]: "+this.acts_arr;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
			
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}