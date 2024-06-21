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
	public class KeyPadMultiInput{
		public var inputs:Array;
		public var isOr:Boolean;
		public var isDown:Boolean;
		public var isPressed:Boolean;
		public var isReleased:Boolean;
		public var downTicks:Number;
		public var upTicks:Number;
		public var doubleClick:Boolean;
		public var longClick:Boolean;
	
		
		public function KeyPadMultiInput($inputs:Array,$isOr:Boolean,$isDown:Boolean=false,$isPressed:Boolean=false,$isReleased:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1, $doubleClick:Boolean=false, $longClick:Boolean=false){
			initVar($inputs,$isOr,$isDown,$isPressed,$isReleased,$downTicks,$upTicks,$doubleClick,$longClick);
		}
		//------ Init Var ------------------------------------
		public function initVar($inputs:Array,$isOr:Boolean,$isDown:Boolean=false,$isPressed:Boolean=false,$isReleased:Boolean=false,$downTicks:Number=-1,$upTicks:Number=-1, $doubleClick:Boolean=false, $longClick:Boolean=false):void{
			inputs 		= $inputs;
			isOr		= $isOr;
			isDown 		= $isDown;
			isPressed	= $isPressed;
			isReleased	= $isReleased;
			downTicks	= $downTicks;
			upTicks		= $upTicks;
			doubleClick = $doubleClick;
			longClick	= $longClick;
		}
	}
}