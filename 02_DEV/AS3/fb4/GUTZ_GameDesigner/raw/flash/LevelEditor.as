﻿package  {	import flash.display.MovieClip;	import flash.geom.Point;	import flash.geom.Rectangle;		public class LevelEditor {						private var _goalVO_arr:Array;		private var _wallVO_arr:Array;						private static const PLIST_HEAD:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n";		private static const WALLS_PREGRP:String = "\t<key>walls</key>\n\t<array>\n";		private static const WALLS_POSTGRP:String = "\t</array>\n";		private static const WALL_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";		private static const WALL_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";		private static const WALL_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";		private static const WALL_WIDTH:String = "</integer>\n\t\t\t<key>width</key>\n\t\t\t<integer>";		private static const WALL_HEIGHT:String = "</integer>\n\t\t\t<key>height</key>\n\t\t\t<integer>";		private static const WALL_FRICT:String = "</integer>\n\t\t\t<key>friction</key>\n\t\t\t<real>";		private static const WALL_BOUNCE:String = "</real>\n\t\t\t<key>bounce</key>\n\t\t\t<real>";		private static const WALL_POSTTAG:String ="</real>\n\t\t</dict>\n";				private static const GOALS_PREGRP:String = "\t<key>goals</key>\n\t<array>\n";		private static const GOALS_POSTGRP:String = "\t</array>\n";		private static const GOAL_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";		private static const GOAL_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";		private static const GOAL_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";		private static const GOAL_POSTTAG:String ="</integer>\n\t\t</dict>\n";				private static const PLIST_TAIL:String = "</dict>\n</plist>\n"						public function LevelEditor() {						var i:Number;						_goalVO_arr = new Array();			_wallVO_arr = new Array();						/*			for (i=0; i<1; i++)				_wallVO_arr.push(new WallVO(i, new MovieClip(), new Rectangle(i*2, i*5, 32, 12), Math.random(), Math.random()));									for (i=0; i<3; i++)				_goalVO_arr.push(new GoalVO(i, new MovieClip(), new Point(i*2, i*5)));			*/		}				public function addWall(id:int, asset:MovieClip, dim:Rectangle, frict:Number=-1, bounce:Number=-1):void {						if (frict == -1)				frict = 0.5;							if (bounce == -1)				bounce = 0.1;						_wallVO_arr.push(new WallVO(id, asset, dim, frict, bounce));		}				public function addGoal(id:int, asset:MovieClip, pos):void {			_goalVO_arr.push(new GoalVO(id, asset, pos));		}						public function writeData():void {						var i:Number;			var plist_str:String = "";						plist_str += PLIST_HEAD;			plist_str += WALLS_PREGRP;						for (i=0; i<_wallVO_arr.length; i++) {				plist_str += WALL_PRETAG + String((_wallVO_arr[i] as WallVO).id);				plist_str += WALL_POS_X + String((_wallVO_arr[i] as WallVO).dim_rect.x);				plist_str += WALL_POS_Y + String((_wallVO_arr[i] as WallVO).dim_rect.y);				plist_str += WALL_WIDTH + String((_wallVO_arr[i] as WallVO).dim_rect.width);				plist_str += WALL_HEIGHT + String((_wallVO_arr[i] as WallVO).dim_rect.height);				plist_str += WALL_FRICT + String((_wallVO_arr[i] as WallVO).friction_amt);				plist_str += WALL_BOUNCE + String((_wallVO_arr[i] as WallVO).bounce_amt);				plist_str += WALL_POSTTAG;			}						plist_str += WALLS_POSTGRP;			plist_str += GOALS_PREGRP;						for (i=0; i<_goalVO_arr.length; i++) {				plist_str += GOAL_PRETAG + String((_goalVO_arr[i] as GoalVO).id);				plist_str += GOAL_POS_X + String((_goalVO_arr[i] as GoalVO).pos_pt.x);				plist_str += GOAL_POS_Y + String((_goalVO_arr[i] as GoalVO).pos_pt.y);				plist_str += GOAL_POSTTAG;			}						plist_str += GOALS_POSTGRP;			plist_str += PLIST_TAIL;									trace (plist_str);		}	}	}