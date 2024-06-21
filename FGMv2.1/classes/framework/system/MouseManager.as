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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.system{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import framework.Framework;
	import framework.component.Component;
	
	import utils.mouse.MousePad;
	import utils.time.Time;
	
	/**
	* MouseManager Class
	*/
	public class MouseManager implements IMouseManager {

		private static var _instance:IMouseManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _mousePad:MousePad = null;
		private var _clicked:DisplayObject = null;
		private var _drag:* = null;
		private var _dragInitialPosition:Point = null;
		private var _rollOver:DisplayObject = null;
		private var _lastClickPosition:Point = null;
		private var _lastClickTime:Number = 0;
		private var _mouseTargets:Array=null;
		private var _mouseExcludeTargets:Array=null;
	
		public function MouseManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use MouseManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IMouseManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new MouseManager();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			Framework.stage.addEventListener(FocusEvent.FOCUS_OUT,onLoseFocus,false,0,true);
		}
		//------ Mouse Pixel Color ------------------------------------
		public static function get MousePixelColor():uint {
			var bitmapData:BitmapData = new BitmapData(Framework.width, Framework.height,true,0);
			bitmapData.draw(Framework.clip);
			var pixel:uint = bitmapData.getPixel32(Framework.clip.mouseX, Framework.clip.mouseY);
			return pixel;
		}
		//------ Mouse Pixel Color ------------------------------------
		public static function get MousePixelHexColor():String {
			return MousePixelColor.toString(16);
		}
		//---- Is Caller Clicked ------------------------------------------------
		public  function isClicked($caller:DisplayObject):Boolean{
			if($caller == _clicked)	return true;
			return false;
		}
		//---- Is Caller Drag ------------------------------------------------
		public  function isDrag($caller:DisplayObject):Boolean{
			if($caller == _drag)	return true;
			return false;
		}
		//---- Is Caller RollOver ------------------------------------------------
		public  function isRollOver($caller:DisplayObject):Boolean{
			if($caller == _rollOver)	return true;
			return false;
		}
		//---- Use Hand Cursor ------------------------------------------------
		public  function switchHandCursor($cursor:String):void{
			Mouse.cursor=$cursor;
		}
		//---- Update Cursor ------------------------------------------------
		private  function updateCursor():void{
			if(drag){
				switchHandCursor(MouseCursor.HAND);
			}else if(_clicked || _rollOver){
				switchHandCursor(MouseCursor.BUTTON);
			}else{
				switchHandCursor(MouseCursor.ARROW);
			}
		}
		//------ Getter ------------------------------------
		public function get clicked():DisplayObject {
			return _clicked;
		}
		public function get drag():* {
			return _drag;
		}
		public function get dragInitialPosition():Point {
			return _dragInitialPosition;
		}
		public function get rollOver():DisplayObject {
			return _rollOver;
		}
		public function get lastClickPosition():Point {
			return _lastClickPosition;
		}
		public function get lastClickTime():Number {
			return _lastClickTime;
		}
		//---- Check Click ------------------------------------------------
		private function checkClick():void{
			var mouseEvent:MouseEvent = _mousePad.mouseEvent
			if(mouseEvent.type == MouseEvent.MOUSE_DOWN){
				_lastClickPosition = new Point(mouseEvent.stageX,mouseEvent.stageY);
				_lastClickTime = Time.GetTime();
			}else if(mouseEvent.type == MouseEvent.MOUSE_UP){
				_lastClickPosition = null;
				_lastClickTime = 0;
				_clicked = null;
			}
		}
		//------ onLoseFocus ------------------------------------
		private function onLoseFocus($evt:FocusEvent):void {
			trace("*MouseManager: FlashGameMaker focus lost");
			reset();
		}
		//------ Reset ------------------------------------
		private function reset():void {
			_clicked = null;
			//_drag = null;
			_rollOver = null;
			_lastClickPosition = null;
			_lastClickTime = 0;
			_clicked = null;
		}
		//------ Setter ------------------------------------
		public function get mousePad():MousePad {
			return _mousePad;
		}
		public function set mousePad($mousePad:MousePad):void {
			_mousePad = $mousePad;
			checkClick();
		}
		
		public function set clicked($clicked:DisplayObject):void {
			_clicked = $clicked;
			updateCursor();
		}
		public function set drag($drag:*):void {
			_drag = $drag;
			if(_drag){
				_dragInitialPosition = new Point(_drag.x,_drag.y);
				updateCursor();
			}
		}
		public function set rollOver($rollOver:DisplayObject):void {
			_rollOver = $rollOver;
			updateCursor();
		}
		public function get mouseTargets():Array {
			return _mouseTargets;
		}
		public function set mouseTargets($mouseTargets:Array):void {
			_mouseTargets = $mouseTargets;
		}
		public function get mouseExcludeTargets():Array {
			return _mouseExcludeTargets;
		}
		public function set mouseExcludeTargets($mouseExcludeTargets:Array):void {
			_mouseExcludeTargets = $mouseExcludeTargets;
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}