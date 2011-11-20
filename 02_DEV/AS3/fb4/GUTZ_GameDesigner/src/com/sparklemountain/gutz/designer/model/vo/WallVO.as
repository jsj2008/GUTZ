package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		WallVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	7:44:11 PM Sep 5, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class WallVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public var ind:int;
		public var type_id:int;
		public var asset_mc:MovieClip;
		public var pos_pt:Point;
		public var dim_rect:Rectangle;
		public var friction_amt:Number;
		public var bounce_amt:Number;
		
		public var ui:IVisualElement;
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		
		// <*] class constructor [*>
		public function WallVO(idx:int, type:int, asset:MovieClip, pos:Point, frict:Number, bounce:Number) {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
			
			this.ind = idx;
			this.type_id = type;
			this.asset_mc = asset;
			this.pos_pt = pos.clone();
			this.dim_rect = new Rectangle(0, 0, asset.width, asset.height);
			this.friction_amt = frict;
			this.bounce_amt = bounce;
			
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		
		public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[ind]: "+this.ind;
				ret_str += "\n[type_id]: "+this.type_id;
				ret_str += "\n[asset_mc]: "+this.asset_mc;
				ret_str += "\n[pos_pt]: "+this.pos_pt;
				ret_str += "\n[dim_rect]: "+this.dim_rect;
				ret_str += "\n[friction_amt]: "+this.friction_amt;
				ret_str += "\n[bounce_amt]: "+this.bounce_amt;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
			
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}