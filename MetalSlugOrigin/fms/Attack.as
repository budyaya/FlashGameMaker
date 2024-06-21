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
	
	import data.Data;
	
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;

	public class Attack extends MS_State{
		private var _hit_a:Boolean = false;
		private var _hit:Boolean = false;
		
		//Attack State
		public function Attack(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Attack";
			//_debugMode = true;
			if(_debugMode){
				_initDebugMode();
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Attack");
			if (!_object.bitmapSet)	return;
			move(_object.spatialMove.facingDir.x,0);
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Attack");
			if (!_object.bitmapSet)	return;
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER)	_updateDebugMode();
			var keyPad:KeyPad = _object.keyPad;
			var spatialMove:SpatialMove = _object.spatialMove;
			var frame:Object = _object.getCurrentFrame();
			updateSpeed();
			if(!_hit)	_hit = object.hurtEnemy();
			if(frame.hasOwnProperty("hit_a")){
				if(keyPad.fire1.isDown){
					_hit_a = true;
				}
			}
			if((_object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition && _object.bitmapSet.reverse==0 || _object.bitmapSet.currentPosition ==0 && _object.bitmapSet.reverse==-1 || _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed)&& _object.bitmapSet.readyToAnim){
				if(_hit_a && frame.hasOwnProperty("hit_a") && (_object.collision.length>0 ||_hit)){
					if(frame.hit_a is Array){
						updateAnim(frame.hit_a[SimpleMath.RandomBetween(0,frame.hit_a.length-1)]);
					}else{	
						updateAnim(frame.hit_a);
					}
					_hit = false;
				}else{
					updateAnim(frame.next);
				}
				_hit_a = false;
				updateState();
			}
			object.hurtEnemy();
		}
		//------ UpdateDebugMode ------------------------------------
		protected override function  _updateDebugMode():void {
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
				if(_object.getCurrentFrame().itr is Array){
					for each(var itr:Object in _object.getCurrentFrame().itr)
						_drawArea(_object,itr,0x5FFF0000);
				}else{
					_drawArea(_object,_object.getCurrentFrame().itr,0x5FFF0000);
				}
			}
		}
		//------ Set Hit_a ------------------------------------
		public function set hit_a($hit_a:Boolean):void {
			_hit_a=$hit_a
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Attack");
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