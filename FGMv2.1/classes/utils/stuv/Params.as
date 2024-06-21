/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://flashgamemakeras3.blogspot.com/
*   Group:        http://groups.google.com.au/group/flashgamemaker
*   Google Code:  http://code.google.com/p/flashgamemaker/downloads/list
*   Source Forge: https://sourceforge.net/projects/flashgamemaker/files/
*/
/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*  
*   Permission is granted to copy, distribute and/or modify this document
*   under the terms of the GNU Free Documentation License, Version 1.3
*   or any later version published by the Free Software Foundation;
*   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*   Under this licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package utils.stuv{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.LoaderInfo;
	
	import framework.Framework;

	public class Params {

		private static var flashVars:Object;
		public static var URL:String;
		public static var LOADER_URL:String;
		public static var HEIGHT:Number;
		public static var WIDTH:Number;
		public static var SWF_VERSION:Number;
		public static var FRAME_RATE:Number;
		protected static var loaderInfo:LoaderInfo;
		
		public static function Init($loaderInfo:LoaderInfo):void {
			loaderInfo = $loaderInfo;
			ParseFlashVars( loaderInfo );
		}
		/**
		 * Parse flashVars
		 */
		public static function ParseFlashVars( $flashVars:Object ):void {
			flashVars 	= $flashVars;
			URL 		= flashVars['url'];
			LOADER_URL 	= flashVars['loaderURL'];
			WIDTH 		= flashVars['width'];
			HEIGHT 		= flashVars['height'];
			SWF_VERSION = flashVars['swfVersion'];
			FRAME_RATE  = flashVars['frameRate'];
		}
		/**
		 * Get FlashVar
		 */
		public static function GetFlashVar($name:String):Object {
			return flashVars[$name];
		}
		/**
		 * Parse flashVars
		 */
		public static function GetFlashVars():Object {
			return flashVars;
		}
	}
}

