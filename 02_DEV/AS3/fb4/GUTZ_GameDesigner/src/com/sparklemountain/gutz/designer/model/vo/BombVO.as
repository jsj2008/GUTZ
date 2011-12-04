package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.display.MovieClip;
	import flash.geom.Point;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		BombVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	4:00:24 PM Dec 1, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class BombVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public var id:int;
		public var asset_mc:MovieClip;
		public var pos_pt:Point;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		// <*] class constructor [*>
		public function BombVO(i:int, asset:MovieClip, pos:Point) {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			
			this.id = i;
			this.asset_mc = asset;
			this.pos_pt = pos.clone();
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		
		public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[id]: "+this.id;
				ret_str += "\n[asset_mc]: "+this.asset_mc;
				ret_str += "\n[pos_pt]: "+this.pos_pt;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
			
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}