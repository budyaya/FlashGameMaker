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
	import customClasses.*;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import framework.Framework;
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;
	import utils.time.Time;

	public class Fly extends MS_State{
		private var _max:Number = 2000;//Max flying time 
		//Fly State
		public function Fly(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Fly";
			//_debugMode = true;
			if(_debugMode){
				_initDebugMode();
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Fly");
			if (!_object.bitmapSet)	return;
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Fly");
			if(_debugMode)	_updateDebugMode();
			updateSpeed();
			if(!_object)	return
			var duration:Number = lastUpdateTime-enterStateTime;
			var hit:Boolean = _object.hurtEnemy();
			if(hit || _object.ms_Frame.hasOwnProperty("max") && duration > _object.ms_Frame.max || !_object.ms_Frame.hasOwnProperty("max") && duration > _max){
				explode();
			}
		}
		//------ Explode ------------------------------------
		public function explode():void {
			stopMoving();
			var frame:Object = _object.getCurrentFrame();
			_finiteStateMachine.destroy();
			_object.destroy();
			_object=null;
		}
		//------ UpdateDebugMode ------------------------------------
		protected override function  _updateDebugMode():void {
			var frame:Object = _object.getCurrentFrame();
			if(_debugMode){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
				if(frame.itr is Array){
					for each(var itr:Object in frame.itr)
					_drawArea(_object,itr,0x5FFF0000);
				}else{
					_drawArea(_object,frame.itr,0x5FFF0000);
				}
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Fly");
			if(_debugMode){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
			}
		}
	}
}