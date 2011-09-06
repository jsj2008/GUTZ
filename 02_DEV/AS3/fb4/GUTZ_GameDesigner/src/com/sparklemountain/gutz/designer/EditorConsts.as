package com.sparklemountain.gutz.designer {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		AppConsts
	 * @package:	com.sparklemountain.gutz.designer
	 * @created:	9:04:09 PM Sep 2, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class EditorConsts {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public static const PART_ACTION:String = "PART_ACTION";
		public static const CLAMP_ACTION:String = "CLAMP_ACTION";
		public static const UNDO_ACTION:String = "UNDO_ACTION";
		
		
		public static const CANVAS_SIZE:Rectangle = new Rectangle(0, 0, 320, 480);
		public static const CANVAS_CENTER:Point = new Point((CANVAS_SIZE.width * 0.5) << 0, (CANVAS_SIZE.height * 0.5) << 0);
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		/**
		 * 
		 */
		// <*] class constructor [*>
		public function EditorConsts() {/**…\(^_^)/…**/}
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
	}
}