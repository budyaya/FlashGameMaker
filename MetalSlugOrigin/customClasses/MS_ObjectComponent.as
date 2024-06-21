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

package customClasses{
	
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import fms.*;
	
	import framework.component.core.AnimationComponent;
	import framework.entity.IEntity;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapCell;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.*;
	import utils.time.Time;
	import utils.transform.BasicTransform;
	import utils.transform.BitmapDataTransform;
	
	/**
	* LittleFighterObjectComponent Class
	*/
	public class MS_ObjectComponent extends AnimationComponent {
		
		protected var _spatialMove:SpatialMove= null;
		protected var _keyPad:KeyPad=null;		//KeyboardInput property
		protected var _scaleX:Number =1;
		protected var _playerStateMachine:FiniteStateMachine = null;
		protected var _aiStateMachine:FiniteStateMachine = null;
		protected var _ms_frame:MS_Frame = null;
		protected var _currentFrame:Object = null;
		protected var _kind:int;
		protected var _depth:int=20;
		protected var _lastHit:Array;
		protected var _source:MS_ObjectComponent = null //For object such as weapon
		protected var _weapon:MS_ObjectComponent = null;
		protected var _target:MS_ObjectComponent = null;
		protected var _ai:Object = null;
		
		public function MS_ObjectComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
			_initPlayerStateMachine();
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_spatialMove = new SpatialMove();
			_render= "bitmapRender";
			if($prop && $prop.spatialMove)						_spatialMove = $prop.spatialMove;
			if($prop && $prop.hasOwnProperty("source"))			_source = $prop.source;
			if($prop && $prop.hasOwnProperty("activeCollision"))_activeCollision = $prop.activeCollision;
			if($prop && $prop.hasOwnProperty("ms_frame"))		_ms_frame = $prop.ms_frame;
			if($prop && $prop.hasOwnProperty("kind")){
				_kind = $prop.kind;
			}else{
				throw new Error("You must give a kind as property when creating a LFE_ObjectComponent");
			}			
			if($prop && $prop.keyPad){
				_keyPad = $prop.keyPad;
			}else{
				_keyPad = new KeyPad;
			}
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("spatialMove");
			registerPropertyReference("bitmapAnim");
			pushFunction({executeOnlyIfDisplayed:false,callback:onTick});
		}
		//------ Init Player Finite StateMachine ------------------------------------
		private function _initPlayerStateMachine():void {
			var stateList:Dictionary = new Dictionary(true);
			stateList["Stand"] 		= _initState(new Stand());
			stateList["Walk"] 		= _initState(new Walk());
			stateList["Run"] 		= _initState(new Run());
			stateList["Jump"] 		= _initState(new Jump());
			stateList["Attack"]		= _initState(new Attack());
			stateList["Hurt"] 		= _initState(new Hurt());
			stateList["Fall"] 		= _initState(new Fall());
			stateList["Fly"] 		= _initState(new Fly());
			_playerStateMachine 	= new FiniteStateMachine();
			_playerStateMachine.setStateList(stateList);
			_playerStateMachine.changeStateByName("Stand");
		}
		//------ Init State ------------------------------------
		private function _initState($state:MS_State):MS_State {
			$state.object = this;
			return $state;
		}
		//------ Create Player ------------------------------------
		public override function createBitmap($graphic:Bitmap):BitmapSet {
			bitmapSet = new BitmapSet($graphic,null);
			var graph:BitmapGraph = bitmapSet.graph;
			var bitmapCell:BitmapCell;
			var positionx:Number,positiony:Number;
			var fps:int=_ms_frame.data.fps
			var reverse:Number=0;
			var wait:Number=0;
			var endAnim:Boolean = false;
			var autoAnim:Boolean = true;
			for each(var frame:Object in _ms_frame.data.frames){
				fps=_ms_frame.data.fps;
				reverse=0;
				endAnim = false;
				autoAnim = true;
				if(frame.hasOwnProperty("wait")){
					wait = frame.wait;
				}
				if(frame.hasOwnProperty("fps")){
					fps = frame.fps;
				}
				if(frame.hasOwnProperty("reverse")){
					reverse = frame.reverse;
				}
				if(frame.hasOwnProperty("endAnim")){
					endAnim = frame.endAnim;
				}
				if(frame.hasOwnProperty("autoAnim")){
					autoAnim = frame.autoAnim;
				}
				if(!graph.animations[frame.name]){
					_createEmptyAnimation(frame.name,_ms_frame.data.w,_ms_frame.data.h,0,fps,reverse,endAnim,autoAnim);
				}
				if(_ms_frame.data.hasOwnProperty("d"))	_depth = _ms_frame.data.d;
				positionx = frame.frame%_ms_frame.data.col;
				positiony = Math.floor(frame.frame/_ms_frame.data.col);
				bitmapCell = new BitmapCell(null,positionx*_ms_frame.data.w,positiony*_ms_frame.data.h,_ms_frame.data.w,_ms_frame.data.h,frame.offsetx,frame.offsety,wait);
				graph.animations[frame.name].list.push(bitmapCell);
			}
			_currentFrame = _ms_frame.data.frames[0];
			return bitmapSet;
		}
		//------ Init Empty Animation ------------------------------------
		private function _createEmptyAnimation($name:String, $cellWidth:Number, $cellHeight:Number,$position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false,$autoAnim:Boolean=true):void {
			bitmapSet.graph.createEmptyAnimation($name, $cellWidth, $cellHeight,$position,$fps, $reverse,$endAnim,$autoAnim);
		}
		//------ Init Animation ------------------------------------
		private function _initAnimation($name:String, $column:int, $row:int, $cellWidth:Number, $cellHeight:Number,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $numFrame:int=0,$position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false, $autoAnim:Boolean=true ):void {
			bitmapSet.graph.initSingleAnimation($name,$column,$row,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
		}
		//------ Init Frame Animation ------------------------------------
		private function _initFrameAnimation($name:String, $frames:Vector.<Point>, $cellWidth:Number, $cellHeight:Number,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false, $autoAnim:Boolean=true ):void {
			bitmapSet.graph.initFrameAnimation($name,$frames,$cellWidth,$cellHeight,$waits,$offsets,$position,$fps,$reverse,$endAnim);
		}
		//------ On Tick ------------------------------------
		protected function onTick():void {
			actualize("spatialMove");
			_playerStateMachine.currentState.lastUpdateTime = Time.GetTime();
			_playerStateMachine.currentState.update();
			if(_aiStateMachine){
				_aiStateMachine.currentState.lastUpdateTime = Time.GetTime();
				_aiStateMachine.currentState.update();
			}
		}
		//------ Hurt Enemy ------------------------------------
		public function hurtEnemy():Boolean {
			var hit:Boolean =false;
			var frame:Object = getCurrentFrame();
			if(frame && frame.hasOwnProperty("itr")|| _weapon && _weapon.getCurrentFrame().hasOwnProperty("itr")){
				var itr:Object = getCurrentFrame().itr;
				var collisionArray:Array = collision;
				var collisionResult:Boolean;
				var bdy:Object;
				var objectCurrentFrame:Object;
				var objectMsFrame:Object;
				var depthAlignement:Number;
				for each(var object:MS_ObjectComponent in collisionArray){
					if(object==this)							continue;//To avoid autoCollision
					if(_source && object==_source)				continue;//To avoid collision with special move
					depthAlignement =  Math.abs(object.y+object.height-object.z-y-height+z);
					objectCurrentFrame = object.getCurrentFrame();
					if(objectCurrentFrame.hasOwnProperty("bdy") && depthAlignement<=_depth && (!_lastHit || _lastHit[0]!=object || _lastHit[1]!=frame.id)){
						collisionResult = checkCollision(this,object);
						if(collisionResult){
							hit=true;
							var target:MS_ObjectComponent=this;
							if(object.target){
								if(kind!=Data.OBJECT_KIND_CHARACTER)	target=_source;
								var dist1:Number = object.getDistance(object ,object.target);
								var dist2:Number = object.getDistance(object ,target);
								if(dist2<dist1){
									object.target = target;
									object.spatialMove.facingDir.x = -spatialMove.facingDir.x;
								}
							}	
							if(object.kind == Data.OBJECT_KIND_PROJECTILE){
								Fly(object.getCurrentState()).explode();
								continue;
							}
							if(itr.hasOwnProperty("fall") || object.z!=0){
								if(itr.hasOwnProperty("dvx"))	object.spatialMove.speed.x=itr.dvx;
								if(itr.hasOwnProperty("dvy"))	object.spatialMove.speed.y=itr.dvy;
								switch(itr.fall){
									case 70:	
									ennemyFall(object,itr);
									return true;
								}
								if(object.spatialMove.speed.z!=0){
									ennemyFall(object,itr);
									return true;
								}
							}
							ennemyInjured(object,itr);
						}
					}
				}
			}
			return hit;
		}
		//------ Ennemy Fall ------------------------------------
		public function ennemyFall($ennemy:MS_ObjectComponent,$itr:Object):void {
			var objectMsFrame:Object = $ennemy.ms_Frame;
			var ennemyFrame:Object = $ennemy.getCurrentFrame();
			if($ennemy.spatialMove.speed.z==0 && $itr.hasOwnProperty("dvz")){	
				$ennemy.spatialMove.speed.z=$itr.dvz;
			}else if($ennemy.spatialMove.speed.z==0){
				$ennemy.spatialMove.speed.z=-10;
			}
			if($itr.hasOwnProperty("effect") && $itr.effect==20){
				$ennemy.spatialMove.facingDir.x=-spatialMove.facingDir.x;
				$ennemy.spatialMove.movingDir.x=spatialMove.facingDir.x;
				$ennemy.updateAnim(objectMsFrame.fallFireId);
			}else if($ennemy.spatialMove.facingDir.x==spatialMove.facingDir.x){
				$ennemy.updateAnim(objectMsFrame.fallFrontId);
			}else{
				$ennemy.updateAnim(objectMsFrame.fallBackId);
				$ennemy.spatialMove.movingDir.x=-$ennemy.spatialMove.facingDir.x;
			}
			$ennemy.updateState();
		}
		//------ EnnemyInjured------------------------------------
		public function ennemyInjured($ennemy:MS_ObjectComponent,$itr:Object):void {
			var frame:Object = getCurrentFrame();
			var objectCurrentFrame:Object = $ennemy.getCurrentFrame();
			var objectMsFrame:Object = $ennemy.ms_Frame;
			if(objectCurrentFrame.state == "Hurt"){
				var id:int = (objectMsFrame.hurtId as Array).indexOf(objectCurrentFrame.id);
				id=(id+1)%objectMsFrame.hurtId.length;
				id = objectMsFrame.hurtId[id];
				$ennemy.updateAnim(id);
				if($itr.hasOwnProperty("dvx")){
					$ennemy.x+=$itr.dvx*spatialMove.facingDir.x;
				}
				if($itr.hasOwnProperty("dvy")){
					$ennemy.y+=$itr.dvy*spatialMove.facingDir.x;
				}
			}else if(objectCurrentFrame.name == "Defense" && objectMsFrame.hasOwnProperty("defenseHurtId") && spatialMove.facingDir.x==-$ennemy.spatialMove.facingDir.x){
				$ennemy.updateAnim(objectMsFrame.defenseHurtId);
			}else if(objectCurrentFrame.name == "DefenseHurt" && objectMsFrame.hasOwnProperty("defenseBrokenId")&& spatialMove.facingDir.x==-$ennemy.spatialMove.facingDir.x){
				$ennemy.updateAnim(objectMsFrame.defenseBrokenId);
			}else if(objectMsFrame.hasOwnProperty("hurtId")){
				$ennemy.updateAnim(objectMsFrame.hurtId[0]);
				if($itr.hasOwnProperty("dvx")){
					$ennemy.x+=$itr.dvx*spatialMove.facingDir.x;
				}
				if($itr.hasOwnProperty("dvy")){
					$ennemy.y+=$itr.dvy*spatialMove.facingDir.x;
				}
			}
			$ennemy.updateState();
			_lastHit = new Array($ennemy,frame.id);
			//if($itr.hasOwnProperty("arest"))	return; //Interact with only 1 ennemy
		}
		//------ Check Collision using bdy and itr ------------------------------------
		public function checkCollision($stricker:MS_ObjectComponent,$opponent:MS_ObjectComponent):Boolean {
			var itrs:Object = $stricker.getCurrentFrame().itr;
			var bdys:Object = $opponent.getCurrentFrame().bdy;
			var rect1:Rectangle, rect2:Rectangle;
			if(itrs is Array){
				for each(var itr:Object in itrs){
					rect1 = getArea($stricker,itr);
					if(bdys is Array){
						for each(var bdy:Object in bdys){
							rect2 = getArea($opponent,bdy);
							if(rect1.intersects(rect2))	return true;
						}
					}else{
						rect2 = getArea($opponent,bdys);
						if(rect1.intersects(rect2))	return true;
					}
				}
			}else if (itrs){
				rect1 = getArea($stricker,itrs);
				if(bdys is Array){
					for each(bdy in bdys){
						rect2 = getArea($opponent,bdy);
						if(rect1.intersects(rect2))	return true;
					}
				}else{
					rect2 = getArea($opponent,bdys);
					if(rect1.intersects(rect2))	return true;
				}
			}
			return false;
		}
		//------ GetArea ------------------------------------
		public function getArea($object:MS_ObjectComponent,$frameArea:Object):Rectangle {
			var rect:Rectangle = new Rectangle (0,0,$frameArea.w,$frameArea.h);
			if($object.spatialMove.facingDir.x==1){
				rect.x=$object.x+$frameArea.x;
			}else{
				rect.x=$object.x+$object.width-$frameArea.x-$frameArea.w;
			}
			return rect;
		}
		//------ Update Anim ------------------------------------
		public function updateAnim($frameId:int):void {
			_lastHit =null;
			MS_State(_playerStateMachine.currentState).updateAnim($frameId);
		}
		//------ Update Anim ------------------------------------
		public function updateAnimPosition($frameId:int):void {
			_lastHit =null;
			var position:int = $frameId-_currentFrame.id;
			if(bitmapSet.currentAnim.list.length> position && position>=0){
				bitmapSet.graph.setCurrentPosition(position);
			}else{
				updateAnim($frameId);
			}
		}
		
		//------ Update State ------------------------------------
		public function updateState():void {
			MS_State(_playerStateMachine.currentState).updateState();
		}
		//------ Update State ------------------------------------
		public function updateSpeed():void {
			MS_State(_playerStateMachine.currentState).updateSpeed();
		}
		//------ Get Current State ------------------------------------
		public function getCurrentState():MS_State {
			return _playerStateMachine.currentState as MS_State;
		}
		//------ Get KeyPad ------------------------------------
		public function get keyPad():KeyPad {
			return _keyPad;
		}
		//------- Get Spatial Move -------------------------------
		public function get spatialMove():SpatialMove {
			return _spatialMove;
		}
		//------- Get FSM -------------------------------
		public function get finisteStateMachine():FiniteStateMachine {
			return _playerStateMachine;
		}
		//------- Set Last Hit -------------------------------
		public function set lastHit($lastHit:Array):void {
			_lastHit = $lastHit;
		}
		//------ Get Current Lfe Frame ------------------------------------
		public function getCurrentFrame():Object {
			var position:int = bitmapSet.currentAnim.position;
			return getMsFrame(_currentFrame.id+bitmapSet.currentAnim.position);
		}
		//------ Get Current Lfe Frame ------------------------------------
		public function setCurrentFrame($frame:Object):void {
			if($frame)
				_currentFrame = $frame;
		}
		//------ Get Frame ------------------------------------
		public function getMsFrame($frameId:int):Object {
			return _ms_frame.data.frames[$frameId];
		}
		//------ Get Frame ------------------------------------
		public function get ms_Frame():Object {
			return _ms_frame.data;
		}
		//------ Get Source ------------------------------------
		public function get source():MS_ObjectComponent {
			return _source;
		}
		//------ Set Source ------------------------------------
		public function set source($source:MS_ObjectComponent):void {
			_source=$source;
		}
		//------ Get Kind ------------------------------------
		public function get kind():int {
			return _kind;
		}
		//------ Get Target ------------------------------------
		public function get target():MS_ObjectComponent {
			return _target;
		}
		//------ Set Weapon ------------------------------------
		public function set target($target:MS_ObjectComponent):void {
			_target=$target;
		}
		//------ Set Time Multiplicator ------------------------------------
		public function setTimeMultiplicator($timeMultiplicator:Number):void {
			_bitmapSet.graph.setTimeMultiplicator($timeMultiplicator);
			_spatialMove.timeMultiplicator = $timeMultiplicator;
		}
		//------ Destroy  ------------------------------------
		public override function destroy():void {
			_playerStateMachine = null;
			//TODO: memory leak 
			//BitmapSet(_bitmapSet).bitmap.bitmapData.dispose()
			super.destroy();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace(name);
		}

	}
}