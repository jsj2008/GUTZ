package com.sparklemountain.gutz.creaturebuilder {
	
	
	/**
	 * 
	 * @author:		Gullinbursti
	 * @class:		PlistConsts
	 * @package:	com.sparklemountain.gutz.creaturebuilder
	 * @created:	8:59:16 PM Sep 2, 2011
	 */
	public class PlistConsts {
		
		public static const FILE_HEADER:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n";
		public static const FILE_FOOTER:String = "</dict>\n</plist>"
		
		public static const CIRCLE_PREGRP:String = "\t<key>circles</key>\n\t<array>\n";
		public static const CIRCLE_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const CIRCLE_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const CIRCLE_POS_X:String = "</integer>\n\t\t\t<key>x</key>\n\t\t\t<integer>";
		public static const CIRCLE_POS_Y:String = "</integer>\n\t\t\t<key>y</key>\n\t\t\t<integer>";
		public static const CIRCLE_RADIUS:String = "</integer>\n\t\t\t<key>radius</key>\n\t\t\t<integer>";
		public static const CIRCLE_POSTTAG:String ="</integer>\n\t\t</dict>\n";
		public static const CIRCLE_POSTGRP:String = "\t</array>\n";
		
		public static const CLAMP_PREGRP:String = "\t<key>clamps</key>\n\t<array>\n";
		public static const CLAMP_PRETAG:String = "\t\t<dict>\n\t\t\t<key>id</key>\n\t\t\t<integer>";
		public static const CLAMP_TYPE:String = "</integer>\n\t\t\t<key>type</key>\n\t\t\t<integer>";
		public static const CLAMP_BODY_A:String = "</integer>\n\t\t\t<key>body1</key>\n\t\t\t<integer>";
		public static const CLAMP_BODY_B:String = "</integer>\n\t\t\t<key>body2</key>\n\t\t\t<integer>";
		public static const CLAMP_STR:String = "</integer>\n\t\t\t<key>str</key>\n\t\t\t<real>";
		public static const CLAMP_DMP:String = "</real>\n\t\t\t<key>damp</key>\n\t\t\t<real>";
		public static const CLAMP_POSTTAG:String ="</real>\n\t\t</dict>\n";
		public static const CLAMP_POSTGRP:String = "\t</array>\n";
		
		
		
		public function PlistConsts() {/**…\(^_^)/…**/}
	}
}