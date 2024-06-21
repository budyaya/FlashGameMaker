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

package framework.component.core{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.time.Time;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class KeyboardInputComponent extends Component{

		private var _keyPad:KeyPad = null;
		private var _keyBoardEvent:KeyboardEvent = null;
		private var _isListening:Boolean = false;
		private var _shift:Boolean = false;
		private var _ctrl:Boolean = false;
		private var _clickKeyCode:Number = 0; //Previous key click
		private var _interval:Number = 0;
		private var _nbClick:Number = 0;
		private var _doubleClick:Boolean = false;
		private var _doubleClickLatence:Number = 300; //Maximum time between two clicks
		private var _longClick:Boolean = false;
		private var	_longClickLatence:Number = 450; // Maximum time for a long click
		private var _doubleClickVerification:Number = 150; // Maximum time between the first and the last click
		private var _timer:Number = 0;
		
		
		public function KeyboardInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity, true);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_keyPad = new KeyPad;
		}
		
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			Framework.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown,false,0,true);
			Framework.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp,false,0,true);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			Framework.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Framework.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardInput") {
				startListening();
			}
		}
		//------ Start Listening ------------------------------------
		public function startListening():void {
			if(!_isListening){
				_isListening=true;
				initListener();
			}
		}
		//------ On Key Down ------------------------------------
		private function onKeyDown($evt:KeyboardEvent):void {
			var doubleClick:Boolean = checkDoubleClick($evt.keyCode);
			_shift=$evt.shiftKey;
			_ctrl=$evt.ctrlKey;
			_keyPad.keyDown($evt.keyCode,doubleClick);
			_keyPad.keyboardEvent = $evt;
			_keyBoardEvent = $evt;
			_updateKeyPadDown() //TODO in order to have multipad 
			onKeyFire();
		}
		//------ On Key Up ------------------------------------
		private function onKeyUp($evt:KeyboardEvent):void {
			doubleClickVerification($evt.keyCode);
			_shift=$evt.shiftKey;
			_ctrl=$evt.ctrlKey;
			_keyPad.keyUp($evt.keyCode);
			_keyPad.keyboardEvent = $evt;
			_keyBoardEvent = $evt;
			_updateKeyPadUp(); //TODO in order to have multipad 
			onKeyFire();
		}
		//---- Check Double Click ------------------------------------------------
		public function checkDoubleClick($keyCode:Number):Boolean {
			//---- Init Timer
			if (_nbClick == 0 && _timer==0){//Add Double Click Key to listen
				_timer = Time.GetTime();
				_nbClick++;
				_clickKeyCode=$keyCode;
			}else{
				_interval = (Time.GetTime() - _timer);
				//----Double Click  
				if (_nbClick == 2 &&  _clickKeyCode==$keyCode && (_interval < _doubleClickLatence || _doubleClick) ) {
					_doubleClick = true;
					return true;
				}
			}
			return false;
		}
		//---- Check Double Click ------------------------------------------------
		public function doubleClickVerification($keyCode:Number):void {
			_doubleClick = false;
			_interval = Time.GetTime() - _timer;
			//---- Double Click Verification ----------------------------
			if (_nbClick == 1 && _interval < _doubleClickVerification) {
				_nbClick++;
			}else {
				_nbClick = 0;
				_timer=0;
				_clickKeyCode=0;
			}
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire():void {
			dispatch("onKeyFire");
			dispatchEvent(_keyBoardEvent);
		}
		//------  Dispatch ------------------------------------
		private function _updateKeyPadDown():void {
			var components:Vector.<Object> = _properties["keyboardInput"].components;
			var keyPad:KeyPad;
			for each (var object:Object in components){
				if(object.param && object.param.hasOwnProperty("keyPad")){
					keyPad = object.param.keyPad;
				}else if(object.component && object.component.hasOwnProperty("keyPad")){
					keyPad = object.component.keyPad;
				}
				if(keyPad){
					keyPad.keyDown(_keyBoardEvent.keyCode,_doubleClick);
					keyPad.keyboardEvent = _keyBoardEvent;
				}
			}
		}
		//------  Dispatch ------------------------------------
		private function _updateKeyPadUp():void {
			var components:Vector.<Object> = _properties["keyboardInput"].components;
			var keyPad:KeyPad;
			for each (var object:Object in components){
				if(object.param && object.param.hasOwnProperty("keyPad")){
					keyPad = object.param.keyPad;
				}
				if(object.component && object.component.hasOwnProperty("keyPad")){
					keyPad = object.component.keyPad
				}
				if(keyPad){
					keyPad.keyUp(_keyBoardEvent.keyCode);
					keyPad.keyboardEvent = _keyBoardEvent;
				}
			}
		}
		//------  Dispatch ------------------------------------
		private function dispatch($callback:String):void {
			var components:Vector.<Object> = _properties["keyboardInput"].components;
			for each (var object:Object in components){
				if(object.param && object.param.hasOwnProperty($callback)){
					if(object.param && object.param.hasOwnProperty("keyPad")){
						object.param.keyPad.keyUp(_keyPad.keyboardEvent.keyCode);
						object.param.keyPad.keyboardEvent = _keyPad.keyboardEvent;
						object.param[$callback](object.param.keyPad);
					}else{
						object.param[$callback](_keyPad);
					}
				}
			}
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
	}
}