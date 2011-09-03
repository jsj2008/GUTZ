package com.sparklemountain.gutz.creaturebuilder.model.vo {
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		AbstractPartVO
	 * @package:	com.sparklemountain.gutz.creaturebuilder.model.vo
	 * @created:	8:41:48 PM Sep 2, 2011
	 */
	public class AbstractPartVO implements iPartVO {
		
		public var ind:int;
		public var type:String;
		public var pos_pt:Point;
		public var ui:IVisualElement;
		
		public function AbstractPartVO(idx:int, kind:String, pos:Point, asset:IVisualElement=null) {
			
			this.ind = idx;
			this.type = kind;
			this.pos_pt = new Point(pos.x, pos.y);
			this.ui = asset;
		}
	}
}