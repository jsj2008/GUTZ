package com.sparklemountain.gutz.creaturebuilder.model.vo {
	
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		HistoryVO
	 * @package:	com.sparklemountain.gutz.creaturebuilder.model.vo
	 * @created:	2:52:25 PM Sep 2, 2011
	 */
	public class HistoryVO {
		
		public var prevSelect_type:int;
		public var nextSelect_type:int;
		
		public var part_arr:Array;
		public var acts_arr:Array;
		
		public function HistoryVO(prev:int=-1, next:int=-1) {
			
			acts_arr = new Array();
			part_arr = new Array();
			
			prevSelect_type = prev;
			nextSelect_type = next;
		}
		
		
		public function stepSelect(type:int=-1):void {
			prevSelect_type = nextSelect_type;
			nextSelect_type = type;
		}
		
		
		public function increment(type:String, vo:AbstractPartVO):void {
			acts_arr.push(new ActionVO(type, vo));
		}
		
		public function undo():ActionVO {
			return (acts_arr.pop() as ActionVO);
		}
		
		
		public function reset(type:int=-1):void {
			acts_arr = new Array();
			
			prevSelect_type = type;
			nextSelect_type = type;
		}
		
		
		public function get undoSteps():int {
			return (acts_arr.length);
		}
		
		
		public function getAction(steps:int=1):ActionVO {
			var ind:int = acts_arr.length - steps;
			
			return (acts_arr[ind] as ActionVO);
		}
	}
}