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
	
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;

	public class Jump extends MS_State{
		private var _bool:Boolean = true;
		private var _throw:Boolean=false;
		private var _gravity:int =1;
		
		//Jump State
		public function Jump(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Jump";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Jump");
			if (!_object.bitmapSet)	return;
			var spatialMove:SpatialMove = _object.spatialMove;
			var frame:Object = _object.getCurrentFrame();
			updateSpeed();
			update();
		}
		//------ Update ------------------------------------
		public override function update():void {
			//trace("Update Jump");
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			checkObject();
			if(spatialMove.movingDir.z==0 && _bool && (frame.hasOwnProperty("dvz"))){
				spatialMove.movingDir.z=1;
				spatialMove.speed.z = frame.dvz;
			}else if(spatialMove.movingDir.z==1){
				//trace("Jump",spatialMove.speed.z,spatialMove.gravity );
				if((keyPad.fire1.isDown) && (frame.hasOwnProperty("hit_a")|| frame.hasOwnProperty("hit_n_w_a")) && (frame.name == "Jump" || frame.name == "RunJump")){
					updateAnim(frame.hit_a);
				}
				spatialMove.speed.z-= _gravity;
				if(spatialMove.speed.z<=0){
					spatialMove.movingDir.z=-1;
					spatialMove.speed.z =0;
				}
			}else if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z+= _gravity;
				if(_object.z>=0){
					_bool = false;
					_object.z=0;
					stopMoving();
				}
			}else{
				_bool = true;
				updateAnim(frame.next);
				updateState();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Jump");
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