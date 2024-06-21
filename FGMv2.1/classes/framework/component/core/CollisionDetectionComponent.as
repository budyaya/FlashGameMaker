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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
//	import mx.core.mx_internal;
	
	import utils.iso.IsoPoint;
	import utils.physic.ShapeCollision;
	import utils.physic.SpatialMove;
	import utils.skinner.CollisionDetection;
	import utils.space.Space;
	import utils.time.Time;

	/**
	* Collision Detection Component
	* 
	*/
	public class CollisionDetectionComponent extends Component {
		private var _colorTransform:ColorTransform;
		private var _collisionColorTransform:ColorTransform;
		private var _components:Array;
		private var _collision:Dictionary;
		private var _others:Dictionary;//Rest of the components
		private var _drawin:Sprite=null;
		private var _collisionRect:Rectangle;
		private var _testPerformance:Boolean = false;
		private var time:Number = 0;
		public function CollisionDetectionComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_components = new Array;
			_collision = new Dictionary(true);
			_others = new Dictionary(true);
			_colorTransform = new ColorTransform;
			_collisionColorTransform = new ColorTransform(1,0,0,1,0,0,0);
			_drawin = new Sprite();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("collisionDetection");
			registerPropertyReference("enterFrame", {onEnterFrame:_onTick});
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "collisionDetection") {
				if($component.hasOwnProperty("collision") && $component.collision){
					if(_components.indexOf($component)==-1){
						_components.push($component);
						_collision[$component] = {component:$component,param:$param}
					}
				}else{
					throw new Error("A collision array must exist to be registered by CollisionDetectionComponent");
				}
			}
		}
		//------ On Tick ------------------------------------
		private function _onTick():void {
			if(_debugMode)	_drawin.graphics.clear();
			if(_testPerformance)			time = Time.GetTime();
			if(_components.length>=2){
				var count:Number =0;
				var component1:GraphicComponent, component2:GraphicComponent;
				for (var i:int=0; i<_components.length;i++){
					for (var j:int=i+1; j<_components.length;j++){
						component1 = _components[i];
						component2 = _components[j];
						var collision1:Object=_collision[component1];
						var collision2:Object=_collision[component2];
						if(!component1.graphic || !collision1){
							removeCollision(component1,component2);
							continue
						}if(!component2.graphic || !collision2){
							removeCollision(component1,component2);
							continue;
						}
						if(collision1 && collision1.component.hasOwnProperty("activeCollision") && !collision1.component.activeCollision){
							if(collision2 && collision2.component.hasOwnProperty("activeCollision") && !collision2.component.activeCollision){
								continue;
							}
						}
						checkCollision(collision1,collision2)
						//TODO Implement a way to give the distance with components and alignement (infront, behind...)
						count++;
					}
				}
			}
			if(_testPerformance)	trace("CheckCollision", Time.GetTime()-time+"ms, itération: "+count+", nb components: "+_components.length);
			dispatch();
			count=0;
		}
		//------ CheckCollision ------------------------------------
		private function checkCollision($component1:Object,$component2:Object,$shapeCollision:Boolean=false):Boolean {
			var component1:GraphicComponent = $component1.component;
			var component2:GraphicComponent = $component2.component;
			if(component1==component2)	return false;//Just to be sure no autocollision
			if($shapeCollision){
				_collisionRect = CollisionDetection.CheckCollision(component1.getGraphicCopy(),component2.getGraphicCopy());
			}else{
				var bounds1:Rectangle = component1.graphic.getRect(component1);
				var bounds2:Rectangle = component2.graphic.getRect(component2);
				_collisionRect = bounds1.intersection(bounds2);
			}
			var collision1:Array = component1.collision;
			var collision2:Array = component2.collision;
			
			if(_collisionRect && _collisionRect.width!=0 && _collisionRect.height!=0){
				addCollision(component1,component2);
				return true;
			}else{//Retirer la collision si plus existante 
				checkCollisionParam($component1,$component2,_collisionRect);
				checkCollisionParam($component2,$component1,_collisionRect);
				removeCollision(component1,component2);
				
			}	
			return false;
		}
		//------ Draw Collision  ------------------------------------
		private function drawCollision():void {
			if (_collisionRect) {
				_drawin.graphics.beginFill(0x0000FF,20);
				_drawin.graphics.lineStyle(0,0x00FF,40);
				_drawin.graphics.moveTo(_collisionRect.x,_collisionRect.y);
				_drawin.graphics.lineTo(_collisionRect.x+_collisionRect.width,_collisionRect.y);
				_drawin.graphics.lineTo(_collisionRect.x+_collisionRect.width,_collisionRect.y+_collisionRect.height);
				_drawin.graphics.lineTo(_collisionRect.x,_collisionRect.y+_collisionRect.height);
				_drawin.graphics.lineTo(_collisionRect.x,_collisionRect.y);
			}
		}
		//------ Check Collision Param ------------------------------------
		private function checkCollisionParam($component1:Object,$component2:Object, $intersection:Rectangle):void {
			var param1:Object = $component1.param;
			if(!param1 || !param1.anyDirection)	return;
			
			var param2:Object = $component2.param;
			var component1:GraphicComponent = $component1.component;
			var component2:GraphicComponent = $component2.component;
			var bounds1:Rectangle = component1.graphic.getRect(component1);
			var bounds2:Rectangle = component2.graphic.getRect(component2);
			
			if(param1.hasOwnProperty("anyDirection")){
				var range:Number= param1.anyDirection.range;
				var components:Array = param1.anyDirection.components;
				var dists:Array = param1.anyDirection.dists;
				var dist:Number = Point.distance(new Point(component1.x,component1.y) ,new Point(component2.x,component2.y));
				var index:* = components.indexOf(component2);
				if(index==-1 && range==0){
					components.push(component2);
					dists.push(dist);
				}else if(index==-1 && range<0 && dist<Math.abs(range)){
					components.push(component2);
					dists.push(dist);
				}else if(index==-1 && range>0 && dist>range){
					components.push(component2);
					dists.push(dist);
				}else if(index!=-1 && (range<0 && dist>Math.abs(range) || range>0 && dist<range)){
					components.splice(index,1);
					dists.splice(index,1);
				}
				return;
			}
			if(param1.hasOwnProperty("rightSide")){
				var rightSideIndex:int = param1.rightSide.indexOf(component2);
				if(rightSideIndex==-1 && Space.IsOnRightSide(bounds1,bounds2,true,true)){
					param1.rightSide.push(component2);
				}else if(rightSideIndex!=-1 && !Space.IsOnRightSide(bounds1,bounds2,true,true)){
					param1.rightSide.splice(rightSideIndex,1);
				}
			}
			if(param1.hasOwnProperty("leftSide")){
				var leftSideIndex:int = param1.leftSide.indexOf(component2);
				if(leftSideIndex==-1 && Space.IsOnLeftSide(bounds1,bounds2,true,true)){
					param1.leftSide.push(component2);
				}else if(leftSideIndex!=-1 && !Space.IsOnLeftSide(bounds1,bounds2,true,true)){
					param1.leftSide.splice(leftSideIndex,1);
				}
			}
			if(param1.hasOwnProperty("upSide")){
				var upSideIndex:int = param1.upSide.indexOf(component2);
				if(upSideIndex==-1 && Space.IsOnUpSide(bounds1,bounds2,true,true)){
					param1.upSide.push(component2);
				}else if(upSideIndex!=-1 && !Space.IsOnUpSide(bounds1,bounds2,true,true)){
					param1.upSide.splice(upSideIndex,1);
				}
			}
			if(param1.hasOwnProperty("downSide")){
				var downSideIndex:int = param1.downSide.indexOf(component2);
				if(downSideIndex==-1 && Space.IsOnDownSide(bounds1,bounds2,true,true)){
					param1.downSide.push(component2);
				}else if(downSideIndex!=-1 && !Space.IsOnDownSide(bounds1,bounds2,true,true)){
					param1.leftSide.splice(downSideIndex,1);
				}
			}
		}
		//------  Add Collision ------------------------------------
		private function addCollision($component1:GraphicComponent,$component2:GraphicComponent):void {
			if($component1.collision.indexOf($component2)==-1){
				$component1.collision.push($component2);
			}	
			if($component2.collision.indexOf($component1)==-1){
				$component2.collision.push($component1);
			}	
			if(_debugMode){
				//$component1.graphic.transform.colorTransform = _collisionColorTransform;
				//$component2.graphic.transform.colorTransform = _collisionColorTransform;
			}	
		}
		//------  Remove Collision ------------------------------------
		private function removeCollision($component1:GraphicComponent,$component2:GraphicComponent):void {
			if($component1.collision.length>0){
				var index:int = $component1.collision.indexOf($component2);
				if(index!=-1){
					$component1.collision.splice(index,1);
				}
			}
			if($component2.collision.length>0){
				index = $component2.collision.indexOf($component1);
				if(index!=-1){
					$component2.collision.splice(index,1);
				}
			}	
			if(_debugMode){
				//if($component1.collision.length ==0 && $component1.graphic)	$component1.graphic.transform.colorTransform = _colorTransform;
				//if($component2.collision.length ==0 && $component2.graphic)	$component2.graphic.transform.colorTransform = _colorTransform;
			}
		}
		//------  Dispatch ------------------------------------
		private function dispatch():void {
			var components:Vector.<Object> = _properties["collisionDetection"].components;
			for each (var object:Object in components){
				if(object.param && object.param.hasOwnProperty("callback")){
					if(object.component.collision && object.component.collision.length>0){
						object.param["callback"](object.component.collision);
					}
				}
			}
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			var collisionArray:Array = ($component as GraphicComponent).collision;
			for each(var component:GraphicComponent in collisionArray){
				removeCollision($component as GraphicComponent,component);
			}
			delete _collision[$component];
			var index:int = _components.indexOf($component);
			if(index!=-1)	_components.splice(index,1);
			super.removePropertyComponent($propertyName,$component);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}