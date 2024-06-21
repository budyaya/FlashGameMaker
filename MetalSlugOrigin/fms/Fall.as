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

	public class Fall extends MS_State{
		
		//Fall_Down State
		public function Fall(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Fall";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//("Enter Fall");
			if (!_object.bitmapSet)	return;
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(spatialMove.speed.z>0){
				spatialMove.speed.z =0;
				spatialMove.movingDir.z=-1;
			}else{
				spatialMove.speed.z*=-1;
				spatialMove.movingDir.z=1;
			}
			checkFlip();
		}
		//------ Update ------------------------------------
		public override function update():void {
			//trace("Update Fall);
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			updateSpeed();
			if(spatialMove.movingDir.z==-1){
				//trace("Fall",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z+= spatialMove.gravity;
				if(_object.z>=0){
					spatialMove.speed.z =0;
					_object.z=0;
					spatialMove.movingDir.z=0;
				}
			}else if(spatialMove.movingDir.z==1){
				//trace("Jump",spatialMove.speed.z,spatialMove.gravity);
				spatialMove.speed.z-= spatialMove.gravity;
				if(spatialMove.speed.z<0){
					spatialMove.speed.z =0;
					spatialMove.movingDir.z=-1;
				}
			}else if(spatialMove.movingDir.z==0 && (_object.bitmapSet.currentAnim.position == 0 && _object.bitmapSet.currentAnim.reverse==-1 || _object.bitmapSet.currentAnim.position == _object.bitmapSet.currentAnim.lastPosition || _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed) && _object.bitmapSet.readyToAnim){
				stopMoving();
				updateAnim(frame.next);
				updateState();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Fall");
			_object.z=0;
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