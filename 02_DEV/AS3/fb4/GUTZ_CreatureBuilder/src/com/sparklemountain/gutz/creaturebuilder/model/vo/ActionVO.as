package com.sparklemountain.gutz.creaturebuilder.model.vo {
	
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		ActionVO
	 * @package:	com.sparklemountain.gutz.creaturebuilder.model.vo
	 * @created:	8:54:07 PM Sep 2, 2011
	 */
	public class ActionVO {
		
		public var type_str:String;
		public var vo:AbstractPartVO;
		
		public function ActionVO(type:String, aVO:AbstractPartVO) {
			
			type_str = type;
			vo = aVO;
		}
	}
}