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
package fms{
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import customClasses.*;
	import data.Data;
	
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Stand extends MS_State{
		private var _stand:Number = 0;//0 stand, 1 stand up and -1 stand downs
		//Stand State
		public function Stand(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Stand";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Stand");
			if (!_object.bitmapSet)	return;
			if(_debugMode ){
				_initDebugMode();
			}
			stopMoving();
			checkObject();
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Stand");
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(keyPad.upRight.isDown || keyPad.upLeft.isDown){
				updateAnim(frame.hit_walk_up);
				updateState();
				return;
			}else if(keyPad.downRight.isDown || keyPad.downLeft.isDown){
				updateAnim(frame.hit_walk_down);
				updateState();
				return;
			}else if (keyPad.down.isDown && _stand != -1) {
				_stand=-1
				updateAnim(frame.hit_stand_down);
			}else if (keyPad.up.isDown && _stand != 1) {
				_stand = 1;
				updateAnim(frame.hit_stand_up);
			}else if(keyPad.right.isDown || keyPad.left.isDown){
				updateAnim(frame.hit_walk);
				updateState();
				return;
			}else if (!keyPad.anyDirection.isDown && _stand!=0) {
				updateAnim(frame.next);
				_stand=0;
			}
			super.update();
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Stand");
			_stand = 0;
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
			}
		}
	}
}