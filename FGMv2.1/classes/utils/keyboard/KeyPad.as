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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import utils.time.Time;
	
	public class KeyPad{
		
		public var keyboardEvent:KeyboardEvent = null;
		private var _keysDown:Array = null;
		private var _previousKeysDown:Array = null;
		private var _keyPadInputsDown:Array = null;
		private var _previousKeyPadInputsDown:Array = null;
		
		// INPUTS
		private var _up:KeyPadInput;
		private var _down:KeyPadInput;
		private var _left:KeyPadInput;
		private var _right:KeyPadInput;
		private var _fire1:KeyPadInput;
		private var _fire2:KeyPadInput;
		private var _fire3:KeyPadInput;
		private var _fire4:KeyPadInput;
		private var _inputs:Array;
		
		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		private var _upLeft:KeyPadMultiInput;
		private var _downLeft:KeyPadMultiInput;
		private var _upRight:KeyPadMultiInput;
		private var _downRight:KeyPadMultiInput;
		private var _anyDirection:KeyPadMultiInput;
		private var _doubleClick: Boolean=false;
		private var _longClick: Boolean=false;
		private var _multiInputs:Array;
		
		public function KeyPad($customKeys:Boolean=false){
			initGamePad($customKeys);
		}
		//------ Init Game Pad ------------------------------------
		private function initGamePad($customKeys:Boolean):void {
			_keyPadInputsDown = new Array;
			_previousKeyPadInputsDown = new Array;
			_up=createGamepadInput();
			_down=createGamepadInput();
			_left=createGamepadInput();
			_right=createGamepadInput();
			_fire1=createGamepadInput();
			_fire2=createGamepadInput();
			_fire3=createGamepadInput();
			_fire4=createGamepadInput();
			_inputs=[_up,_down,_left,_right,_fire1,_fire2,_fire3,_fire4];
			_upLeft=createGamepadMultiInput([_up,_left],false);
			_upRight=createGamepadMultiInput([_up,_right],false);
			_downLeft=createGamepadMultiInput([_down,_left],false);
			_downRight=createGamepadMultiInput([_down,_right],false);
			_anyDirection=createGamepadMultiInput([_up,_down,_left,_right,_upLeft,_upRight,_downLeft,_downRight],true);
			_multiInputs=[_upLeft,_upRight,_downLeft,_downRight,_anyDirection];
			if(!$customKeys){
				useZQSD();
				useArrows();
				useJKLM();
			}
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadInput():KeyPadInput {
			var gamePadInput:KeyPadInput= new KeyPadInput;
			return gamePadInput;
		}
		//------ Create Game Pad Input ------------------------------------
		private function createGamepadMultiInput(inputs:Array, isOr:Boolean):KeyPadMultiInput {
			var gamePadMultiInput:KeyPadMultiInput=new KeyPadMultiInput(inputs, isOr);
			return gamePadMultiInput;
		}
		//------ Map Direction ------------------------------------
		public function mapDirection($up:int, $down:int, $left:int, $right:int, $replaceExisting:Boolean = false):void {
			mapKey(_up,$up, $replaceExisting);
			mapKey(_down,$down, $replaceExisting);
			mapKey(_left,$left, $replaceExisting);
			mapKey(_right,$right, $replaceExisting);
		}
		//------ Map Fire Buttons ------------------------------------
		public function mapFireButtons($fire1:int, $fire2:int,$fire3:int, $fire4:int,$replaceExisting:Boolean = false):void{
			mapKey(_fire1,$fire1, $replaceExisting);
			mapKey(_fire2,$fire2, $replaceExisting);
			mapKey(_fire3,$fire3, $replaceExisting);
			mapKey(_fire4,$fire4, $replaceExisting);
		}
		//------ Use Arrows ------------------------------------
		public function useArrows($replaceExisting:Boolean = false):void {
			mapDirection(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, $replaceExisting);
		}
		//------ Use WASD ------------------------------------
		public function useWASD($replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.W, KeyCode.S, KeyCode.A, KeyCode.D, $replaceExisting);
		}
		//------ Use IJKL ------------------------------------
		public function useIJKL($replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.I, KeyCode.K, KeyCode.J, KeyCode.L, $replaceExisting);
		}
		//------ Use ZQSD ------------------------------------
		public function useZQSD($replaceExisting:Boolean = false):void {
			mapDirection(KeyCode.Z, KeyCode.S, KeyCode.Q, KeyCode.D, $replaceExisting);
		}
		//------ Use JKLM ------------------------------------
		public function useJKLM($replaceExisting:Boolean = false):void {
			mapFireButtons(KeyCode.J, KeyCode.K,KeyCode.L,KeyCode.M, $replaceExisting);
		}
		//------ Map Key ------------------------------------
		public function mapKey($key:Object,$keyCode:int, $replaceExisting:Boolean = false):void {
			if ($replaceExisting) {
				$key.mappedKeys=[$keyCode];
			} else if ($key.mappedKeys.indexOf($keyCode) == -1) {
				$key.mappedKeys.push($keyCode);
			}
		}
		//------ Unmap Key ------------------------------------
		public function unmapKey($key:Object,$keyCode:int):void {
			$key.mappedKeys.splice($key.mappedKeys.indexOf($keyCode), 1);
		}
		//------ Update Gamepad Input ------------------------------------
		public function updateKeyPadInput($keyPadInput:Object):void {
			if ($keyPadInput.isDown) {
				$keyPadInput.isPressed=$keyPadInput.downTicks==-1;
				$keyPadInput.isReleased=false;
				$keyPadInput.downTicks++;
				$keyPadInput.upTicks=-1;
			} else {
				$keyPadInput.isReleased=$keyPadInput.upTicks==-1;
				$keyPadInput.isPressed=false;
				$keyPadInput.upTicks++;
				$keyPadInput.downTicks=-1;
			}
		}
		//------ Update Gamepad Multi Input ------------------------------------
		public function updateKeyPadMultiInput(keyPadMultiInput:KeyPadMultiInput):void {
			if (keyPadMultiInput.isOr) {
				keyPadMultiInput.isDown=false;
				for each (var keyPadInput:* in keyPadMultiInput.inputs) {
					if (keyPadInput.isDown) {
						keyPadMultiInput.isDown=true;
						if (keyPadInput.doubleClick) {
							_doubleClick = true;
							keyPadMultiInput.doubleClick=true;
						}
						break;
					}
				}
			} else {
				keyPadMultiInput.isDown=true;
				for each (keyPadInput in keyPadMultiInput.inputs) {
					if (keyPadInput.doubleClick) {
						_doubleClick = true;
						keyPadMultiInput.doubleClick=true;
					}
					if (! keyPadInput.isDown) {
						keyPadMultiInput.isDown=false;
						break;
					}
				}
			}
			if (keyPadMultiInput.isDown) {
				keyPadMultiInput.isPressed=keyPadMultiInput.downTicks==-1;
				keyPadMultiInput.isReleased=false;
				keyPadMultiInput.downTicks++;
				keyPadMultiInput.upTicks=-1;
			} else {
				keyPadMultiInput.isReleased=keyPadMultiInput.upTicks==-1;
				keyPadMultiInput.isPressed=false;
				keyPadMultiInput.doubleClick = false;
				_doubleClick = false;
				keyPadMultiInput.upTicks++;
				keyPadMultiInput.downTicks=-1;
			}
		}
		//------ On Key Down ------------------------------------
		public function keyDown($keyCode:int, $doubleClick:Boolean = false):void {
			for each (var keyPadInput:KeyPadInput in _inputs) {
				if (keyPadInput.mappedKeys.indexOf($keyCode)!=-1) {
					if (keyPadInput==_right&&_left.isDown||keyPadInput==_left&&_right.isDown||keyPadInput==_up&&_down.isDown||keyPadInput==_down&&_up.isDown) {
						return;
					}
					if(_keyPadInputsDown.indexOf(keyPadInput)==-1){
						_keyPadInputsDown.push(keyPadInput);
					}
					keyPadInput.isDown=true;
					if(keyPadInput.isDownTime==-1){
						keyPadInput.isDownTime = Time.GetTime();
					}
					keyPadInput.doubleClick = $doubleClick;
				}
			}
			for each (var keyPadMultiInput:KeyPadMultiInput in _multiInputs) {
				updateKeyPadMultiInput(keyPadMultiInput);
			}
		}
		//------ On Key Up ------------------------------------
		public function keyUp($keyCode:int):void {
			for each (var keyPadInput:KeyPadInput in _inputs) {
				if (keyPadInput.mappedKeys.indexOf($keyCode)!=-1) {
					var index:Number = _keyPadInputsDown.indexOf(keyPadInput)
					if(index!=-1){
						_keyPadInputsDown.splice(index,1);
						_previousKeyPadInputsDown.unshift(keyPadInput)
						if(_previousKeyPadInputsDown.length>10){
							_previousKeyPadInputsDown.pop();
						}
					}
					keyPadInput.isDown=false;
					keyPadInput.longClick = keyPadInput.getLongClick();
					keyPadInput.isDownTime=-1;
				}
			}
			for each (var keyPadMultiInput:KeyPadMultiInput in _multiInputs) {
				updateKeyPadMultiInput(keyPadMultiInput);
			}
		}
		//------ Getter ------------------------------------
		public function get up():KeyPadInput {
			return _up;
		}
		public function get down():KeyPadInput {
			return _down;
		}
		public function get left():KeyPadInput {
			return _left;
		}
		public function get right():KeyPadInput {
			return _right;
		}
		public function get fire1():KeyPadInput {
			return _fire1;
		}
		public function get fire2():KeyPadInput {
			return _fire2;
		}
		public function get fire3():KeyPadInput {
			return _fire3;
		}
		public function get fire4():KeyPadInput {
			return _fire4;
		}
		public function get upLeft():KeyPadMultiInput {
			return _upLeft;
		}
		public function get downLeft():KeyPadMultiInput {
			return _downLeft;
		}
		public function get upRight():KeyPadMultiInput {
			return _upRight;
		}
		public function get downRight():KeyPadMultiInput {
			return _downRight;
		}
		public function get anyDirection():KeyPadMultiInput {
			return _anyDirection;
		}
		/*public function get doubleClick():Boolean {
			return _doubleClick;
		}*/
		public function set doubleClick($doubleClick:Boolean):void {
			_doubleClick=$doubleClick;
		}
		public function get longClick():Boolean {
			return _longClick;
		}
		//------ Is Down ------------------------------------
		public function get isDown():Boolean {
			if(_up.isDown || _down.isDown || _right.isDown || _left.isDown)
				return true;
			else if	(_fire1.isDown || _fire2.isDown || _fire3.isDown ||_fire4.isDown)
				return true;
			return false;
		}
		//------ Keys Down ------------------------------------
		public function get keysDown():Array {
			return _keyPadInputsDown;
		}
		//------ Keys Down ------------------------------------
		public function get previousKeysDown():Array {
			return _previousKeyPadInputsDown;
		}
		//------ Keys Down ------------------------------------
		public function isKeyPadInputLastKeyDown($keyPadInput:*):Boolean {//Could be multiInput
			return _previousKeyPadInputsDown[0] == $keyPadInput;
		}
		//------ Index KeyPad ------------------------------------
		public function getIndexOfKeyPadInput($keyPadInput:*):Number {
			return _previousKeyPadInputsDown.indexOf($keyPadInput);
		}
		//------ Index KeyPad ------------------------------------
		public function getPreviousKeyPadInputAtIndex($index:int):* {//Could be multiInput
			//if( _previousKeyPadInputsDown[$index])	trace( _previousKeyPadInputsDown[$index].mappedKeys)
			return _previousKeyPadInputsDown[$index];
		}
		//------ Index KeyPad ------------------------------------
		public function getPreviousKeyPadInput():* {//Could be multiInput
			return _previousKeyPadInputsDown[0];
		}
		//------ Index KeyPad ------------------------------------
		public function isPreviousKeydPadInputAtIndex($index:int,$keyPadInput:KeyPadInput):Boolean {//Could be multiInput
			if(_previousKeyPadInputsDown.length==0)	return false;
			var keyPadInput:* = _previousKeyPadInputsDown[$index];
			//Do not delete
			/*var keyTouchArray:Array = new Array;
			for each (var keyTouch:KeyPadInput in _previousKeyPadInputsDown){
				if(keyPadInput is KeyPadInput){
					keyTouchArray.push(KeyCode.GetKey(keyTouch.mappedKeys[0]))
				}
			}
			trace(keyTouchArray);*/
			// ---
			if(keyPadInput is KeyPadInput){
				//trace(KeyCode.GetKey(KeyPadInput(keyPadInput).mappedKeys[0]), KeyCode.GetKey($keyPadInput.mappedKeys[0]));
				return keyPadInput==$keyPadInput;
			}
			return false;
		}
		//------ Keys Down Char ------------------------------------
		public function get keysDownChar():Array {
			var keyKapInputsDownChar:Array = new Array();
			for each (var keyCode:Number in _keyPadInputsDown){
				var keyChar:String =KeyCode.GetKey(keyCode);
				keyKapInputsDownChar.push(keyChar);
			}
			return keyKapInputsDownChar;
		}
		//------ Key Is Down ------------------------------------
		public function keyIsDown($keyCode:int):Boolean {
			if(_keyPadInputsDown.indexOf($keyCode)!=-1){
				return true;
			}
			return false
		}
		//------ Key Char Is Down ------------------------------------
		public function keyCharIsDown($keyChar:String):Boolean {
			if(keysDownChar.indexOf($keyChar)!=-1){
				return true;
			}
			return false
		}
		//------ Press Right ------------------------------------
		public function pressRightKey($doubleClick:Boolean=false):void {
			keyDown(_right.mappedKeys[0],$doubleClick);
			
		}
		//------ Press Left ------------------------------------
		public function pressLeftKey($doubleClick:Boolean=false):void {
			keyDown(_left.mappedKeys[0],$doubleClick);
		}
		//------ Press Up ------------------------------------
		public function pressUpKey($doubleClick:Boolean=false):void {
			keyDown(_up.mappedKeys[0],$doubleClick);
		}
		//------ Press Down ------------------------------------
		public function pressDownKey($doubleClick:Boolean=false):void {
			keyDown(_down.mappedKeys[0],$doubleClick);
		}
		//------ Press Fire1 ------------------------------------
		public function pressFire1Key($doubleClick:Boolean=false):void {
			keyDown(_fire1.mappedKeys[0],$doubleClick);
		}
		//------ Press Fire2 ------------------------------------
		public function pressFire2Key($doubleClick:Boolean=false):void {
			keyDown(_fire2.mappedKeys[0],$doubleClick);
		}
		//------ Press Fire3 ------------------------------------
		public function pressFire3Key($doubleClick:Boolean=false):void {
			keyDown(_fire3.mappedKeys[0],$doubleClick);
		}
		//------ Press Fire4 ------------------------------------
		public function pressFire4Key($doubleClick:Boolean=false):void {
			keyDown(_fire4.mappedKeys[0],$doubleClick);
		}
		//------ Press Key ------------------------------------
		public function pressKey($keyCode:int,$doubleClick:Boolean=false):void {
			keyDown($keyCode,$doubleClick);
		}
		//------ Press Right ------------------------------------
		public function releaseRightKey():void {
			keyUp(_right.mappedKeys[0]);
		}
		//------ Press Left ------------------------------------
		public function releaseLeftKey():void {
			keyUp(_left.mappedKeys[0]);
		}
		//------ Press Up ------------------------------------
		public function releaseUpKey():void {
			keyUp(_up.mappedKeys[0]);
		}
		//------ Press Down ------------------------------------
		public function releaseDownKey():void {
			keyUp(_down.mappedKeys[0]);
		}
		//------ Press Fire1 ------------------------------------
		public function releaseFire1Key():void {
			keyUp(_fire1.mappedKeys[0]);
		}
		//------ Press Fire2 ------------------------------------
		public function releaseFire2Key():void {
			keyUp(_fire2.mappedKeys[0]);
		}
		//------ Press Fire3 ------------------------------------
		public function releaseFire3Key():void {
			keyUp(_fire3.mappedKeys[0]);
		}
		//------ Press Fire4 ------------------------------------
		public function releaseFire4Key():void {
			keyUp(_fire4.mappedKeys[0]);
		}
		//------ Press Key ------------------------------------
		public function releaseKey($keyCode:int):void {
			keyUp($keyCode);
		}
		//------ To String() ------------------------------------
		public function toString():void {
			trace("Right",_right.isDown,"Left",_left.isDown,"Up",_up.isDown,"Down",_down.isDown,"Fire1",_fire1.isDown,"Fire2",_fire2.isDown,"Fire3",_fire3.isDown,"Fire4",_fire4.isDown); 
		}
	}
}