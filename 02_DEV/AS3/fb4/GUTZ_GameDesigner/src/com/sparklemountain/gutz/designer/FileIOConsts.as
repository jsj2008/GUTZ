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
		
		public static const BG_PRETAG:String = "\t<key>bg</key>\n\t<integer>";
		public static const BG_POSTTAG:String = "</integer>\n";
		
		public static const PLAYER_PRETAG:String = "\t<key>player</key>\n\t<integer>";
		public static const PLAYER_POSTTAG:String = "</integer>\n";
		
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
		public static const WALL_SPIKE:String = "</integer>\n\t\t\t<key>spikes</key>\n\t\t\t<integer>";
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
		
		public static const PICKUP_PREGRP:String = "\t<key>pickups</key>\n\t<array>\n";
		public static const PICKUP_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const PICKUP_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const PICKUP_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const PICKUP_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const PICKUP_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const PICKUP_POSTGRP:String = "\t</array>\n";
		
		public static const HEALTH_PREGRP:String = "\t<key>healths</key>\n\t<array>\n";
		public static const HEALTH_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const HEALTH_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const HEALTH_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const HEALTH_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const HEALTH_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const HEALTH_POSTGRP:String = "\t</array>\n";
		
		public static const WYPT_PREGRP:String = "\t<key>waypts</key>\n\t<array>\n";
		public static const WYPT_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const WYPT_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const WYPT_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const WYPT_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const WYPT_PAN_X:String = "</integer>\n\t\t\t<key>pan_x</key>\n\t\t\t<integer>";
		public static const WYPT_PAN_Y:String = "</integer>\n\t\t\t<key>pan_y</key>\n\t\t\t<integer>";
		public static const WYPT_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const WYPT_POSTGRP:String = "\t</array>\n";
		
		public static const TRAP_PREGRP:String = "\t<key>traps</key>\n\t<array>\n";
		public static const TRAP_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const TRAP_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const TRAP_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const TRAP_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const TRAP_MIN:String = "</integer>\n\t\t\t<key>min</key>\n\t\t\t<integer>";
		public static const TRAP_MAX:String = "</integer>\n\t\t\t<key>max</key>\n\t\t\t<integer>";
		public static const TRAP_SPD:String = "</integer>\n\t\t\t<key>speed</key>\n\t\t\t<real>";
		public static const TRAP_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const TRAP_POSTGRP:String = "\t</array>\n";
		
		public static const DART_PREGRP:String = "\t<key>darts</key>\n\t<array>\n";
		public static const DART_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const DART_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const DART_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const DART_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const DART_ITV:String = "</integer>\n\t\t\t<key>interval</key>\n\t\t\t<integer>";
		public static const DART_SPD:String = "</integer>\n\t\t\t<key>speed</key>\n\t\t\t<real>";
		public static const DART_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const DART_POSTGRP:String = "\t</array>\n";
		
		public static const STUD_PREGRP:String = "\t<key>studs</key>\n\t<array>\n";
		public static const STUD_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const STUD_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const STUD_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const STUD_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const STUD_RAD:String = "</integer>\n\t\t\t<key>radius</key>\n\t\t\t<integer>";
		public static const STUD_FRICT:String = "</integer>\n\t\t\t<key>friction</key>\n\t\t\t<real>";
		public static const STUD_BOUNCE:String = "</real>\n\t\t\t<key>bounce</key>\n\t\t\t<real>";
		public static const STUD_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const STUD_POSTGRP:String = "\t</array>\n";
		
		public static const HANDWHEEL_PREGRP:String = "\t<key>handwheels</key>\n\t<array>\n";
		public static const HANDWHEEL_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const HANDWHEEL_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const HANDWHEEL_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const HANDWHEEL_SPD:String = "</integer>\n\t\t\t<key>speed</key>\n\t\t\t<real>";
		public static const HANDWHEEL_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const HANDWHEEL_POSTGRP:String = "\t</array>\n";
		
		public static const CONVEYOR_PREGRP:String = "\t<key>conveyors</key>\n\t<array>\n";
		public static const CONVEYOR_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const CONVEYOR_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const CONVEYOR_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const CONVEYOR_WIDTH:String = "</integer>\n\t\t\t<key>width</key>\n\t\t\t<integer>";
		public static const CONVEYOR_SPD:String = "</integer>\n\t\t\t<key>speed</key>\n\t\t\t<real>";
		public static const CONVEYOR_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const CONVEYOR_POSTGRP:String = "\t</array>\n";
		
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