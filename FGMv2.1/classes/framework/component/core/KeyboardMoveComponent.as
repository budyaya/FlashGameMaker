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
	import com.greensock.TweenLite;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.component.Component;
	import framework.entity.EntityManager;
	import framework.entity.IEntity;
	
	import utils.keyboard.KeyPad;
	import utils.keyboard.KeyPadInput;
	import utils.physic.SpatialMove;
	import utils.time.Time;
	
	/**
	* KeyboardMoveComponent Class
	*/
	public class KeyboardMoveComponent extends Component {

		//KeyboardInput properties
		protected var _keyPad:KeyPad=null;
		protected var _speed:Point=new Point(2,2);
		protected var _horizontalMove:Boolean = true;
		protected var _verticalMove:Boolean = true;
		protected var _diagonalMove:Boolean = true;
		
		public function KeyboardMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			_keyPad = new KeyPad();
			if($prop && $prop.speed)		_speed 			= $prop.speed;
			if($prop && $prop.horizontal)	_horizontalMove = $prop.horizontal;
			if($prop && $prop.vertical)		_verticalMove 	= $prop.vertical;
			if($prop && $prop.diagonal)		_diagonalMove 	= $prop.diagonal;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("keyboardMove");
			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
		}
		//------ On Key Fire ------------------------------------
		protected function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardMove") {
				updateComponent($component);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component):void {
			if(!$component.hasOwnProperty("spatialMove")) {
				throw new Error("A SpatialMove must exist to be registered by KeyboardMoveComponent");
			}
			if($component.hasOwnProperty("iso") && $component.iso){
				isoMoveComponent($component);
			}else{
				moveComponent($component);
			}
		}
		//------ Move Component------------------------------------
		protected function moveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("keyPad") && $component.keyPad){
				var keyPad:KeyPad=$component.keyPad;
			}else{
				keyPad=_keyPad;
			}
			if($component.hasOwnProperty("diagonalMove")&& $component.hasOwnProperty("horizontalMove")&& $component.hasOwnProperty("verticalMove")){
				var horizontalMove:Boolean = $component.horizontalMove;
				var verticalMove:Boolean = $component.verticalMove;
				var diagonalMove:Boolean = $component.diagonalMove;
			}else{
				horizontalMove = _diagonalMove;
				verticalMove = _verticalMove;
				diagonalMove = _diagonalMove;
			}
			//Move
			if(keyPad.upRight.isDown && diagonalMove){
				moveUpRight($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.upLeft.isDown && diagonalMove){
				moveUpLeft($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.downRight.isDown && diagonalMove){
				moveDownRight($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.downLeft.isDown && diagonalMove){
				moveDownLeft($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else{
				if(keyPad.right.isDown && horizontalMove){
					moveRight($component);
					animComponent($component,keyPad.right);
				}else if(keyPad.left.isDown && horizontalMove){
					moveLeft($component);
					animComponent($component,keyPad.left);
				}else if(keyPad.up.isDown && verticalMove){
					moveUp($component);
					animComponent($component,keyPad.up);
				}else if(keyPad.down.isDown && verticalMove){
					moveDown($component);
					animComponent($component,keyPad.down);
				}else{
					reset($component);
				}
			}
		}
		//------ Iso Move Component------------------------------------
		protected function isoMoveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("keyPad") && $component.keyPad){
				var keyPad:KeyPad=$component.keyPad;
			}else{
				keyPad=_keyPad;
			}
			var spatialMove:SpatialMove = $component.spatialMove;
			if(keyPad.upRight.isDown && spatialMove.movingType == SpatialMove.DIAGONAL){
				moveRight($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.upLeft.isDown && spatialMove.movingType == SpatialMove.DIAGONAL){
				moveUp($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.downRight.isDown && spatialMove.movingType == SpatialMove.DIAGONAL){
				moveDown($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else if(keyPad.downLeft.isDown && spatialMove.movingType == SpatialMove.DIAGONAL){
				moveLeft($component);
				$component.spatialMove.pose = [$component.spatialMove.WALK];
			}else{
				if(keyPad.right.isDown && spatialMove.movingType == SpatialMove.HORIZONTAL){
					moveDownRight($component);
					animComponent($component,keyPad.right);
				}else if(keyPad.left.isDown && spatialMove.movingType == SpatialMove.HORIZONTAL){
					moveUpLeft($component);
					animComponent($component,keyPad.left);
				}else if(keyPad.up.isDown && spatialMove.movingType == SpatialMove.VERTICAL){
					moveUpRight($component);
					animComponent($component,keyPad.up);
				}else if(keyPad.down.isDown && spatialMove.movingType == SpatialMove.VERTICAL){
					moveDownLeft($component);
					animComponent($component,keyPad.down);
				}else{
					reset($component);
				}
			}
		}
		//------ Move UpRight ------------------------------------
		public function moveUpRight($component:Component):void {
			move(1,-1,0, $component);
		}
		//------ Move UpLeft ------------------------------------
		public function moveUpLeft($component:Component):void {
			move(-1,-1,0, $component);
		}
		//------ Move DownRight ------------------------------------
		public function moveDownRight($component:Component):void {
			move(1,1,0, $component);
		}
		//------ Move DownLeft ------------------------------------
		public function moveDownLeft($component:Component):void {
			move(-1,1,0, $component);
		}
		//------ Move Right ------------------------------------
		public function moveRight($component:Component):void {
			move(1,0,0, $component);
		}
		//------ Move Left ------------------------------------
		public function moveLeft($component:Component):void {
			move(-1,0,0, $component);
		}
		//------ Move Up ------------------------------------
		public function moveUp($component:Component):void {
			move(0,-1,0, $component);
		}
		//------ Move Down ------------------------------------
		public function moveDown($component:Component):void {
			move(0,1,0, $component);
		}
		//------ Move ------------------------------------
		protected function move($x:Number, $y:Number,  $z:Number, $component:Component):void {
			var spatialMove:SpatialMove = $component.spatialMove;
			spatialMove.movingDir.x = $x;
			spatialMove.movingDir.y = $y;
//			spatialMove.movingDir.z = $z;
		}
		//------ Move Component------------------------------------
		protected function animComponent($component:Component,$keyPadInput:KeyPadInput):void {
			var spatialMove:SpatialMove = $component.spatialMove;
			if($keyPadInput.doubleClick && !spatialMove.isRunning()){
				spatialMove.move(spatialMove.RUN);
				$component.setCurrentAnimation("RUN");
			}else if (!spatialMove.isRunning() && !spatialMove.isWalking()){
				spatialMove.move(spatialMove.WALK);
				//$component.setCurrentAnimation("WALK");
			}
		}
		//------ Reset ------------------------------------
		protected function reset($component:Component):void {
			var spatialMove:SpatialMove = $component.spatialMove;
			if(spatialMove.isWalking() || spatialMove.isRunning()){
				spatialMove.pose = [spatialMove.STAND];
				//$component.setCurrentAnimation("STAND");
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}