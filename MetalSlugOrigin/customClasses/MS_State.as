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
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.getClassByAlias;
	
	import framework.Framework;
	
	import utils.bitmap.BitmapSet;
	import utils.convert.BoolTo;
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.physic.SpatialMove;
	import utils.richardlord.State;

	/**
	* LFE_State
	*/
	public class MS_State extends State{
		protected var _object:MS_ObjectComponent = null;
		private var _bitmap:Bitmap = null;
		protected var _bitmapData:BitmapData = null;
		protected var _debugMode:Boolean = false;
		
		public function MS_State(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			if(_debugMode){
				_initDebugMode();
			}
		}
		//------ Init Var ------------------------------------
		protected function _initDebugMode():void {
			_bitmapData = new BitmapData(10,10,true,0);
			_bitmap = new Bitmap(_bitmapData);
			Framework.AddChild(_bitmap);
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Stand");
			if (!_object.bitmapSet)	return;
			var spatialMove:SpatialMove = _object.spatialMove;
			if(!_object.bitmapSet.flip && spatialMove.facingDir.x==-1 || _object.bitmapSet.flip && spatialMove.facingDir.x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Stand");
			if (!_object.bitmapSet)	return;
			if(_debugMode)	_updateDebugMode();
			var spatialMove:SpatialMove = _object.spatialMove;
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(keyPad.fire1.isDown ){
				if(keyPad.down.isDown && frame.hasOwnProperty("hit_a_down")){
					updateAnim(frame.hit_a_down);
				}else if(keyPad.up.isDown && frame.hasOwnProperty("hit_a_up")){
					updateAnim(frame.hit_a_up);
				}else if(frame.hasOwnProperty("hit_a")) {
					updateAnim(frame.hit_a);
				}
				if(_object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition && _object.bitmapSet.readyToAnim){
					_object.bitmapSet.currentPosition=0;
				}
			}else if(frame.hasOwnProperty("hit_j") && keyPad.fire2.isDown && !keyPad.fire2.getLongClick()){
				updateAnim(frame.hit_j);
			}else if(frame.hasOwnProperty("hit_d") && keyPad.fire3.isDown && !keyPad.fire3.getLongClick()){
				updateAnim(frame.hit_d);
			}else if(frame.hasOwnProperty("hit_up") && keyPad.up.isDown){
				updateAnim(frame.hit_up);
			}else if(frame.hasOwnProperty("hit_down")&& keyPad.down.isDown){
				updateAnim(frame.hit_down);
			}else if(frame.hasOwnProperty("hit_right") && keyPad.right.isDown){
				updateAnim(frame.hit_right);
			}else if(frame.hasOwnProperty("hit_left") && keyPad.left.isDown){
				updateAnim(frame.hit_left);
			}else if(frame.hasOwnProperty("next") && _object.bitmapSet.endAnim && (_object.bitmapSet.currentPosition == 0 && _object.bitmapSet.reverse==-1 || _object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition || _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed)){
				if(_object.bitmapSet.readyToAnim){
					updateAnim(frame.next);
				}
		    }
			updateSpeed();
			checkFlip();
			updateState();
			checkObject();
		}
		//------ Update Speed ------------------------------------
		public function updateSpeed():void {
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(frame.hasOwnProperty("dvx")){
				spatialMove.speed.x = frame.dvx;
				checkMovingDirX(frame.dvx);
			}
		}
		//------ CheckMovingDirX ------------------------------------
		public function checkMovingDirX($dvx:Number):void {
			var spatialMove:SpatialMove = _object.spatialMove;
			var keyPad:KeyPad = _object.keyPad;
			if($dvx!=0 && spatialMove.movingDir.x==0 && spatialMove.movingDir.y==0){
				if(spatialMove.facingDir.x!=0){
					spatialMove.movingDir.x = spatialMove.facingDir.x;
				}else if($dvx>0){
					spatialMove.movingDir.x = 1;
				}else if($dvx<0){
					spatialMove.movingDir.x = -1;
				}
			}
		}
		//------ Update Anim ------------------------------------
		public function updateAnim($frameId:int):void {
			var frame:Object = _object.getMsFrame($frameId);
			_object.lastHit = null;
			if(!frame){
				trace("[WARNING] LFE_STATE : Frame is null !");
			}else{
				_object.setCurrentFrame(frame);
				_object.bitmapSet.graph.anim(frame.name);
			}
		}
		//------ Update State ------------------------------------
		public function updateState():void {
			var frame:Object = _object.getCurrentFrame();
			if(_name!=frame.state){
				_finiteStateMachine.changeStateByName(frame.state);
			}
		}
		//------ Check Flip ------------------------------------
		protected function checkFlip($force:Boolean=false):void {
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(frame.flip || _object.kind>1 || $force){
				if(keyPad.right.isDown || _object.spatialMove.facingDir.x==1 && !keyPad.left.isDown){
					checkFlipX(1);
				}else if(keyPad.left.isDown || _object.spatialMove.facingDir.x==-1){
					checkFlipX(-1);
				}
			}
		}
		//------ Check Flip x ------------------------------------
		protected function checkFlipX($x:Number):void {
			if(!_object.bitmapSet.flip && $x==-1 || _object.bitmapSet.flip && $x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
			if($x==1 && _object.spatialMove.facingDir.x==-1){
				_object.spatialMove.facingDir.x =1;
			}else if($x==-1 && _object.spatialMove.facingDir.x==1){
				_object.spatialMove.facingDir.x =-1;
			} 
		}
		//------ Move ------------------------------------
		protected function move($x:Number, $z:Number):void {
			//Change moving direction
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.movingDir.x = $x;
			spatialMove.movingDir.z = $z;
		}
		//------ Move ------------------------------------
		protected function moveDir($x:Number, $y:Number,  $z:Number):void {
			//Change facing direction
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.facingDir.x = $x;
			spatialMove.facingDir.z = $z;
			if(!_object.bitmapSet.flip && $x==-1 || _object.bitmapSet.flip && $x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
		}
		//------ Stop Moving ------------------------------------
		protected function stopMoving():void {
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.movingDir.x = 0;
			spatialMove.movingDir.z = 0;
		}
		//------ CheckObject ------------------------------------
		public function checkObject():void {
			var frame:Object = _object.getCurrentFrame();
			if(frame.hasOwnProperty("opoint") &&_object.bitmapSet.currentAnim.iteration==0 ){
				var object:MS_ObjectComponent = MS_Object.CreateObject(frame.opoint.oid,_object);
			}
		}
		//------ GET/SET ------------------------------------
		public function get object():MS_ObjectComponent {
			return _object;
		}
		//------ UpdateDebugMode ------------------------------------
		protected function  _updateDebugMode():void {
			var frame:Object = _object.getCurrentFrame();
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				_drawArea(_object,frame.bdy,0x5F0000FF);
			}
		}
		//------ Draw area ------------------------------------
		protected function  _drawArea($object:MS_ObjectComponent,$frameArea:Object,$color:uint):void {
			if($frameArea){
				_bitmapData.dispose();
				_bitmap.bitmapData = new BitmapData($frameArea.w,$frameArea.h);
				_bitmapData = _bitmap.bitmapData;
				_bitmapData.lock();
				_bitmapData.fillRect(new Rectangle(0,0,$frameArea.w,$frameArea.h),$color);
				_bitmapData.unlock();
				_bitmap.x=$object.x+$frameArea.x;
				_bitmap.y=$object.y+$frameArea.y;
				if(!_object.bitmapSet.flip){
					_bitmap.x=$object.x+$frameArea.x;
				}else{
					_bitmap.x=$object.x+$object.width-$frameArea.x-$frameArea.w;
				}
			}
		}
		public function set object($object:MS_ObjectComponent):void {
			_object=$object;
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit LFE_STATE");
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