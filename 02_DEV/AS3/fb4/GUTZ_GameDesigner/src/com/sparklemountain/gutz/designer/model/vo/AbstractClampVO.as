package com.sparklemountain.gutz.designer.model.vo {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		AbstractClampVO
	 * @package:	com.sparklemountain.gutz.designer.model.vo
	 * @created:	12:30:46 AM Sep 3, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class AbstractClampVO extends AbstractBodyVO implements iPartVO {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		// <*] class constructor [*>
		public function AbstractClampVO(idx:int, tid:int, kind:String, pos:Point, asset:IVisualElement=null) {
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
			super(idx, tid, kind, pos, asset);
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
		
		
		override public function toString():String {
		//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._	
			var ret_str:String = "\n"+this+":\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[ind]: "+this.ind;
				ret_str += "\n[type]: "+this.type;
				ret_str += "\n[pos_pt]: "+this.pos_pt;
				//ret_str += "\n[bodyA]: "+this.bodyA;
				//ret_str += "\n[bodyB]: "+this.bodyA;
				//ret_str += "\n[offsetA_pt]: "+this.offsetA_pt;
				//ret_str += "\n[offsetB_pt]: "+this.offsetB_pt;
				//ret_str += "\n[str]: "+this.str;
				//ret_str += "\n[dmp]: "+this.dmp;
				ret_str += "\n[ui]: "+this.ui;
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				ret_str += "\n[=-=-=-=-=-=-=-=-=-=-=-=-=-=]";
				
			return (ret_str + "\n");
		}//]~*~~*~~*~~*~~*~~*~~*~~*~~·¯
	}
}