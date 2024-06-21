/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://flashgamemakeras3.blogspot.com/
*   Gro_up:        http://gro_ups.google.com.au/gro_up/flashgamemaker
*   Google Code:  http://code.google.com/p/flashgamemaker/_downloads/list
*   Source Forge: https://sourceforge.net/projects/flashgamemaker/files/
*/
/*
*    Inspired from GamePad  
*    Ian Lobb 2008
*    http://blog.iainlobb.com/search/label/gamepad
*/
/*
* Copy_right (C) <2010>  <Joachim N'DOYE>
*  
*   Permission is granted to copy, distribute and/or modify graphic document
*   under the terms of the GNU Free Documentation License, Version 1.3
*   or any later version published by the Free Software Foundation;
*   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*   Under graphic licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.component.add{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.ui.LayoutUtil;

	/**
	* GamePad Class
	*/
	public class GamePadComponent extends GraphicComponent {

		//KeyboardInput properties
		private var _keyPad:KeyPad=null;
		
		private var _isCircle:Boolean;
		private var _isAligned:Boolean;
		private var _background:Sprite;
		private var _ball:Sprite;
		private var _button1:Sprite;
		private var _button1TF:TextField;
		private var _button2:Sprite;
		private var _button2TF:TextField;
		private var _button3:Sprite;
		private var _button3TF:TextField;
		private var _button4:Sprite;
		private var _button4TF:TextField;
		private var _up:Sprite;
		private var _upTF:TextField;
		private var _down:Sprite;
		private var _downTF:TextField;
		private var _left:Sprite;
		private var _leftTF:TextField;
		private var _right:Sprite;
		private var _rightTF:TextField;
		private var _colour:uint;
		private var _ballStep:Number=15;
		private var _alpha:Number = 0.6;
		private var _textFormat:TextFormat;
		public var update:Boolean=true;
		// THE "STICK"
		private var _targetX:Number=0;
		private var _targetY:Number=0;
		private var _x:Number = 0;
		private var _y:Number = 0;
		public function GamePadComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.hasOwnProperty("keyPad")){
				_keyPad = $prop.keyPad;
			}else{
				throw new Error("A keyPad must be given as parameter to the GamePadComponent !!!");
			}
			graphic = new Sprite;
			_isCircle=false;
			_isAligned = true;
			_colour=0x333333;
			_textFormat = new TextFormat("Arial", 16, 0xFFFFFF, true);
			drawBackground();
			createBall();
			createButtons();
			createKeypad();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("keyboardInput", {onKeyFire:onKeyFire});
			//registerPropertyReference("mouseInput", {onMouseDown:onMouseDown, onMouseUp:onMouseUp, onMouseRollOver:onMouseRollOver, onMouseRollOut:onMouseRollOut});
		}
		//------ On Key Fire ------------------------------------
		public function onKeyFire($keyPad:KeyPad):void {
			if(update){
				updateState();
				step();
				updateGamePad();
			}
		}
		//------ Draw Background ------------------------------------
		private function drawBackground():void {
			if (_isCircle) {
				drawCircle();
			} else {
				drawSquare();
			}
			graphic.addChild(_background);
		}
		//------ Draw Square ------------------------------------
		private function drawSquare():void {
			_background = new Sprite();
			_background.graphics.beginFill(_colour, _alpha);
			_background.graphics.drawRoundRect(0, 0, 80, 80, 40, 40);
			_background.graphics.endFill();
		}
		//------ Draw Circle ------------------------------------
		private function drawCircle():void {
			_background.graphics.beginFill(_colour, 0.2);
			_background.graphics.drawCircle(0, 40, 40);
			_background.graphics.endFill();
		}
		//------ Create Ball ------------------------------------
		private function createBall():void {
			_ball = new Sprite();
			_ball.graphics.beginFill(_colour, 1);
			_ball.graphics.drawCircle(40, 40, 20);
			_ball.graphics.endFill();
			graphic.addChild(_ball);
		}
		//------ Create Keypad ------------------------------------
		private function createKeypad($keyPad:KeyPad=null):void {
			_up=createKey();
			_up.x=140;
			_up.y=0;
			_upTF = new TextField();
			_upTF.selectable = false;
			_up.addChild(_upTF);

			_down=createKey();
			_down.x=140;
			_down.y=_up.y+35;
			_downTF = new TextField();
			_downTF.selectable = false;
			_down.addChild(_downTF);

			_left=createKey();
			_left.x=105;
			_left.y=_up.y+35;
			_leftTF = new TextField();
			_leftTF.selectable = false;
			_left.addChild(_leftTF);

			_right=createKey();
			_right.x=175;
			_right.y=_up.y+35;
			_rightTF = new TextField();
			_rightTF.selectable = false;
			_right.addChild(_rightTF);
			
			setKeyTouch();
		}
		//------ Create Buttons ------------------------------------
		private function createButtons():void {
			_button1=createButton();
			_button1TF = new TextField();
			_button1TF.selectable = false;
			_button1.addChild(_button1TF);
			_button2=createButton();
			_button2TF = new TextField();
			_button2TF.selectable = false;
			_button2.addChild(_button2TF);
			_button3=createButton();
			_button3TF = new TextField();
			_button3TF.selectable = false;
			_button3.addChild(_button3TF);
			_button4=createButton();
			_button4TF = new TextField();
			_button4TF.selectable = false;
			_button4.addChild(_button4TF);
			if(_isAligned){
				_button1.x=245;
				_button1.y=45;
				_button2.x=280;
				_button2.y=45;
				_button3.x=315;
				_button3.y=45;
				_button4.x=350;
				_button4.y=45;
			}else{
				_button1.x=243.50;
				_button1.y=30;
				_button2.x=265;
				_button2.y=60;
				_button3.x=272.5;
				_button3.y=25 -12.5;
				_button4.x=295;
				_button4.y=30 +12.5;
			}
		}
		//------ Create Button ------------------------------------
		private function createButton():Sprite {
			var button:Sprite = new Sprite();
			button.graphics.beginFill(_colour, 1);
			button.graphics.drawCircle(0, 0, 15);
			button.graphics.endFill();
			button.alpha=_alpha;
			button.buttonMode =true;
			button.useHandCursor = true;
			button.tabEnabled = false;
			graphic.addChild(button);
			return button;
		}
		//------ Create Key ------------------------------------
		protected function createKey():Sprite {
			var key:Sprite = new Sprite();
			key.graphics.beginFill(_colour, 1);
			key.graphics.drawRoundRect(0, 0, 30, 30, 20, 20);
			key.graphics.endFill();
			key.alpha=_alpha;
			key.buttonMode =true;
			key.useHandCursor = true;
			key.tabEnabled = false;
			graphic.addChild(key);
			return key;
		}
		//------ On Mouse Down ------------------------------------
		public function onMouseDown($mousePad:MousePad):void {
			if(_mouseManager.isClicked(graphic)){
				if ($mousePad.mouseEvent.currentTarget.alpha!=0) {
					$mousePad.mouseEvent.currentTarget.alpha=1;
				}
			}
		}
		//------ On Mouse Up ------------------------------------
		public function onMouseUp($mousePad:MousePad):void {
			/*if ($mousePad.mouseEvent.currentTarget.alpha!=0) {
				$mousePad.mouseEvent.currentTarget.alpha=_alpha;
			}*/
		}
		//------ On Mouse RollOver ------------------------------------
		public function onMouseRollOver($mousePad:MousePad):void {
			if(_mouseManager.isClicked(graphic)){
			}
		}
		//------ On Mouse RollOvut ------------------------------------
		public function onMouseRollOut($mousePad:MousePad):void {
			/*if ($mousePad.mouseEvent.currentTarget.alpha!=0) {
			$mousePad.mouseEvent.currentTarget.alpha=_alpha;
			}*/
		}
		//------ UpdateGamePad ------------------------------------
		private function updateGamePad():void {
			var targetAngle:Number=Math.atan2(_targetX,_targetY);
			//trace(_keyPad,_keyPad.targetX,_keyPad.targetY);
			if (_isCircle&&_keyPad.anyDirection.isDown) {
				_targetX=Math.sin(targetAngle);
				_targetY=Math.cos(targetAngle);
			}
			_ball.x=_x*_ballStep;
			_ball.y=_y*_ballStep;
			if (_button1.alpha!=0) {
				_button1.alpha=_keyPad.fire1.isDown?1:_alpha;
			}
			if (_button2.alpha!=0) {
				_button2.alpha=_keyPad.fire2.isDown?1:_alpha;
			}
			if (_button3.alpha!=0) {
				_button3.alpha=_keyPad.fire3.isDown?1:_alpha;
			}
			if (_button4.alpha!=0) {
				_button4.alpha=_keyPad.fire4.isDown?1:_alpha;
			}
			if (_up.alpha!=0) {
				_up.alpha=_keyPad.up.isDown?1:_alpha;
			}
			if (_down.alpha!=0) {
				_down.alpha=_keyPad.down.isDown?1:_alpha;
			}
			if (_left.alpha!=0) {
				_left.alpha=_keyPad.left.isDown?1:_alpha;
			}
			if (_right.alpha!=0) {
				_right.alpha=_keyPad.right.isDown?1:_alpha;
			}
		}
		//------ DisplayButton ------------------------------------
		public function showButton(buttonName:String):void {
			graphic[buttonName].alpha=_alpha;
		}
		//------ HideButton ------------------------------------
		public function hideButton(buttonName:String):void {
			graphic[buttonName].alpha=0;
		}
		//------ Show All ------------------------------------
		public function showAll():void {
			for (var i:int=0; i<graphic.numChildren; i++) {
				graphic.getChildAt(i).alpha=_alpha;
			}
		}
		//------ Hide All ------------------------------------
		public function hideAll():void {
			for (var i:int=0; i<graphic.numChildren; i++) {
				graphic.getChildAt(i).alpha=0;
			}
		}
		//------ Move Button ------------------------------------
		public function moveButton(buttonName:String,x:Number,y:Number):void {
			graphic[buttonName].x=x;
			graphic[buttonName].y=y;
		}
		//------ SetKeyTouch ------------------------------------
		public function setKeyTouch():void {
			_button1TF.text = KeyCode.GetKey(_keyPad.fire1.mappedKeys[0]);
			_button2TF.text = KeyCode.GetKey(_keyPad.fire2.mappedKeys[0]);
			_button3TF.text = KeyCode.GetKey(_keyPad.fire3.mappedKeys[0]);
			_button4TF.text = KeyCode.GetKey(_keyPad.fire4.mappedKeys[0]);
			_upTF.text = KeyCode.GetKey(_keyPad.up.mappedKeys[0]).charAt(0);
			_downTF.text = KeyCode.GetKey(_keyPad.down.mappedKeys[0]).charAt(0);
			_rightTF.text = KeyCode.GetKey(_keyPad.right.mappedKeys[0]).charAt(0);
			_leftTF.text = KeyCode.GetKey(_keyPad.left.mappedKeys[0]).charAt(0);
			
			_button1TF.setTextFormat(_textFormat);
			_button2TF.setTextFormat(_textFormat);
			_button3TF.setTextFormat(_textFormat);
			_button4TF.setTextFormat(_textFormat);
			_upTF.setTextFormat(_textFormat);
			_downTF.setTextFormat(_textFormat);
			_rightTF.setTextFormat(_textFormat);
			_leftTF.setTextFormat(_textFormat);
			
			_button1TF.x = _button2TF.x = _button3TF.x = _button4TF.x = -7.5;
			_button1TF.y = _button2TF.y = _button3TF.y = _button4TF.y = -10;
			_upTF.x =_downTF.x =_rightTF.x = _leftTF.x = 7;
			_upTF.y =_downTF.y =_rightTF.y = _leftTF.y = 5;
		}
		//------ Update State ------------------------------------
		private function updateState():void {
			if (_keyPad.up.isDown) {
				_targetY=-1;
			} else if (_keyPad.down.isDown) {
				_targetY=1;
			} else {
				_targetY=0;
			}
			if (_keyPad.left.isDown) {
				_targetX=-1;
			} else if (_keyPad.right.isDown) {
				_targetX=1;
			} else {
				_targetX=0;
			}
		}
		//------ Step ------------------------------------
		public function step():void {
			if(_keyPad.anyDirection.isDown){
				_x += (_targetX - _x);
				_y += (_targetY - _y);
			}else{
				_x=0;
				_y=0;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}