package com.sparklemountain.gutz.designer {
	
	//] includes [!]>
	//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
	import cc.gullinbursti.lang.Numbers;
	import cc.gullinbursti.lang.Strings;
	//]~=~=~=~=~=~=~=~=~=~=~=~=~=~[]~=~=~=~=~=~=~=~=~=~=~=~=~=~[
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		FileIOConsts
	 * @package:	com.sparklemountain.gutz.designer
	 * @created:	8:59:16 PM Sep 2, 2011
	 */
	
	// <[!] class delaration [¡]>
	public class FileIOConsts {
	//~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~~*~._
		
		//] class properties ]>
		//]=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~.
		public static const PLIST_HEADER:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n";
		public static const PLIST_FOOTER:String = "</dict>\n</plist>\n"
		
		public static const BODYPART_PREGRP:String = "\t<key>parts</key>\n\t<array>\n";
		public static const BODYPART_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const BODYPART_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const BODYPART_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const BODYPART_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const BODYPART_RADIUS:String = "</integer>\n\t\t\t<key>radius</key>\n\t\t\t<integer>";
		public static const BODYPART_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const BODYPART_POSTGRP:String = "\t</array>\n";
		
		public static const CLAMP_PREGRP:String = "\t<key>clamps</key>\n\t<array>\n";
		public static const CLAMP_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const CLAMP_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const CLAMP_BODY_A:String = "</integer>\n\t\t\t<key>body1</key>\n\t\t\t<integer>";
		public static const CLAMP_BODY_B:String = "</integer>\n\t\t\t<key>body2</key>\n\t\t\t<integer>";
		public static const CLAMP_STR:String = "</integer>\n\t\t\t<key>str</key>\n\t\t\t<real>";
		public static const CLAMP_DMP:String = "</real>\n\t\t\t<key>damp</key>\n\t\t\t<real>";
		public static const CLAMP_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const CLAMP_POSTGRP:String = "\t</array>\n";
		
		
		public static const WALL_PREGRP:String = "\t<key>walls</key>\n\t<array>\n";
		public static const WALL_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const WALL_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const WALL_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const WALL_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const WALL_WIDTH:String = "</integer>\n\t\t\t<key>width</key>\n\t\t\t<integer>";
		public static const WALL_HEIGHT:String = "</integer>\n\t\t\t<key>height</key>\n\t\t\t<integer>";
		public static const WALL_FRICT:String = "</integer>\n\t\t\t<key>friction</key>\n\t\t\t<real>";
		public static const WALL_BOUNCE:String = "</real>\n\t\t\t<key>bounce</key>\n\t\t\t<real>";
		public static const WALL_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const WALL_POSTGRP:String = "\t</array>\n";
		
		public static const GOAL_PREGRP:String = "\t<key>goals</key>\n\t<array>\n";
		public static const GOAL_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const GOAL_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const GOAL_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const GOAL_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const GOAL_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const GOAL_POSTGRP:String = "\t</array>\n";
		
		
		public static const FILE_PATHNAME:String = "GUTZ-Editors.demo";
		public static const DIR_PATHNAME:String = "./";
		
		
		public static const CREATURE_PLIST_NAME:String = "CreatureData_";
		public static const LEVEL_PLIST_NAME:String = "LevelData_";
		public static const PLIST_EXT:String = ".plist";
		// <[=-=-=-=-=-=-=-=-=-=-=-=][=-=-=-=-=-=-=-=-=-=-=-=]>
		
		/**
		 * 
		 */
		// <*] class constructor [*>
		public function FileIOConsts() {/**…\(^_^)/…**/}
		//]~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~._
		
		//]~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=[>
		//]~=~=~=~=~=~=~=~=~=[>
	}
}