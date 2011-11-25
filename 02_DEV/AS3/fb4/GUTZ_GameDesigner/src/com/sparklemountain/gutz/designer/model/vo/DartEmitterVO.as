package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.display.MovieClip;
	import flash.geom.Point;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		DartEmitterVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	4:56:18 PM Nov 21, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class DartEmitterVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public var id:int;
		public var type_id:int;
		public var asset_mc:MovieClip;
		public var pos_pt:Point;
		public var interval:Number;
		public var speed:Number;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		// <*] class constructor [*>
		public function DartEmitterVO(idx:int, type:int, asset:MovieClip, pos:Point, itv:Number, spd:Number) {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			
			this.id = idx;
			this.type_id = type;
			this.asset_mc = asset;
			this.pos_pt = pos.clone();
			this.interval = itv;
			this.speed = spd;
			
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[id]: "+this.id;
				ret_str += "\n[type_id]: "+this.type_id;
				ret_str += "\n[asset_mc]: "+this.asset_mc;
				ret_str += "\n[pos_pt]: "+this.pos_pt;
				ret_str += "\n[interval]: "+this.interval;
				ret_str += "\n[speed]: "+this.speed;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
			
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}