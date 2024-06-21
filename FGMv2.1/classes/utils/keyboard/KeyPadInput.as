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
package utils.keyboard{
	import utils.time.Time;

	public class KeyPadInput{
		public var isDown:Boolean;
		public var isPressed:Boolean;
		public var isReleased:Boolean;
		public var doubleClick:Boolean;
		private var _longClick:Boolean = false;
		public var shift:Boolean;
		public var ctrl:Boolean;
		public var hit:Number = 0;// Number of time the key is hit
		public var downTicks:Number;
		public var upTicks:Number;
		public var mappedKeys:Array = new Array;
		public var isDownTime:Number=-1;
		public function KeyPadInput($isDown:Boolean=false,$isPressed:Boolean=false, $isReleased:Boolean=false,$doubleClick:Boolean=false, $shift:Boolean=false,$ctrl:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1,$mappedKeys:Array=null){
			initVar($isDown,$isPressed,$isReleased,$doubleClick,$shift,$ctrl,$downTicks,$upTicks,$mappedKeys);
		}
		//------ Init Var ------------------------------------
		public function initVar($isDown:Boolean=false,$isPressed:Boolean=false,$isReleased:Boolean=false,$doubleClick:Boolean=false, $shift:Boolean=false,$ctrl:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1,$mappedKeys:Array=null):void{
			isDown 		= $isDown;
			isPressed	= $isPressed;
			isReleased	= $isReleased;
			doubleClick	= $doubleClick;
			shift		= $shift;
			ctrl		= $ctrl;
			downTicks	= $downTicks;
			upTicks		= $upTicks;
			if($mappedKeys)	mappedKeys	= $mappedKeys;
		}
		//------ Long click ------------------------------------
		public function get longClick():Boolean {
			if(isDownTime==-1){
				return getLongClick()
			}
			return _longClick;
		}
		//------ Long click ------------------------------------
		public function set longClick($longClick:Boolean):void {
			_longClick=$longClick;
		}
		//------ Long click ------------------------------------
		public function getLongClick($longClickLatence:Number=100):Boolean {
			var interval:Number = Time.GetTime()-isDownTime ;
			//trace("Long Click Interval: "+interval+", Latence: "+$longClickLatence,interval>=$longClickLatence);
			if(interval>=$longClickLatence){
				return true;
			}
			return false
		}
		
	}
}