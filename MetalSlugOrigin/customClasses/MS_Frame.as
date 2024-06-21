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

package customClasses{

	import com.adobe.serialization.json.JSON;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import utils.parse.ParseObject;
	
	
	/**
	* MS Frame
	* A frame is composed of a player frame and possibly Weapon, Object, Catch, Blood and Body frames.
	*/
	public class MS_Frame{
		
		public var data:Object = null;
		
		public function MS_Frame($myData:Object){
			_initVar($myData);
		}
		//------ Init Var ------------------------------------
		private function _initVar($myData:Object):void {
			data = $myData;
			//ParseObject.TraceObject(data);
		}
		//------ Create Frames ------------------------------------
		private function _createFrames():void {
		}
		//------ Create Frame ------------------------------------
		private function _createFrame():void {
		}
	}
}