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
package utils.mouse{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MousePad{
		private var _mouseEvent:MouseEvent = null;
		private var _clickDuration:Number = 0; //-1 if still pressed
		private var _doubleClick:Boolean;
		private var _target:DisplayObject;
		private var _offset:Point = new Point;
		
		public function MousePad(){
		}
		
		//------ Getter ------------------------------------
		public function get mouseEvent():MouseEvent {
			return _mouseEvent;
		}
		public function get target():DisplayObject {
			return _target ;
		}
		public function set target($target:DisplayObject):void {
			_target = $target ;
		}
		public function set mouseEvent($mouseEvent:MouseEvent):void {
			_mouseEvent=$mouseEvent;
		}
		public function get clickDuration():Number {
			return _clickDuration;
		}
		public function set clickDuration($clickDuration:Number):void {
			_clickDuration=$clickDuration;
		}
		public function get doubleClick():Boolean {
			return _doubleClick;
		}
		public function set doubleClick($doubleClick:Boolean):void {
			_doubleClick=$doubleClick;
		}
		public function get offset():Point {
			return _offset;
		}
		public function set offset($offset:Point):void {
			_offset=$offset;
		}
	}
}