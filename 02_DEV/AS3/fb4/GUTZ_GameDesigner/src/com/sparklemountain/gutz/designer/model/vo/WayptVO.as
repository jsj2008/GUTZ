package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.display.MovieClip;
	import flash.geom.Point;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		WayptVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	11:17:30 AM Nov 26, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class WayptVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public var id:int;
		public var asset_mc:MovieClip;
		public var pos_pt:Point;
		public var pan_pt:Point;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		// <*] class constructor [*>
		public function WayptVO(i:int, asset:MovieClip, pos:Point, pan:Point) {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			
			this.id = i;
			this.asset_mc = asset;
			this.pos_pt = pos.clone();
			this.pan_pt = pan.clone();
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[id]: "+this.id;
				ret_str += "\n[asset_mc]: "+this.asset_mc;
				ret_str += "\n[pos_pt]: "+this.pos_pt;
				ret_str += "\n[pan_pt]: "+this.pan_pt;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
			
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}