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
	import com.greensock.easing.Linear;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.mouse.MousePad;
	
	/**
	* KeyboardMoveComponent Class
	*/
	public class MouseMoveComponent extends Component {
		public static var CLICK:int = 0;
		public static var PRESS:int = 1;
		//MouseInput properties
		private var _mouseManager:IMouseManager = null
		private var _mousePad:MousePad = null;
		private var _type:int = CLICK;//PRESS or CLICK
		private var _speed:Number = 80;
		
		public function MouseMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			_mousePad = new MousePad();
			if($prop && $prop.type)		_type = $prop.type;
			_mouseManager = MouseManager.getInstance();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseMove");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ((!$param || !$param.hasOwnProperty("mousePad")) && !$component.hasOwnProperty("mousePad")) {
				throw new Error($component + "must have a MousePad to be registered to " + this);
			}
			if ($propertyName == "mouseMove") {
				moveComponent($component);
			}
		}
		//------ Move Component------------------------------------
		protected function moveComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("mousePad") && $component.mousePad){
				var mousePad:MousePad=$component.mousePad;
			}
			//Move
			if(mousePad && mousePad.mouseEvent /*&& mousePad.mouseEvent.buttonDown*/){
				onMouseDown(mousePad, $component);
			}/*else if(mousePad && mousePad.mouseEvent){
				onMouseUp(mousePad, $component);
			}*/
		}
		//------ On Mouse Down ------------------------------------
		protected function onMouseDown($mousePad:MousePad, $component:Component):void {
			//if(_mouseManager.clicked !=null || _mouseManager.rollOver!=null)	return;
			var destination:Point = new Point($mousePad.mouseEvent.stageX-$component.graphic.width/2,$mousePad.mouseEvent.stageY-$component.graphic.height/2);
			destination.x+=$mousePad.offset.x;
			destination.y+=$mousePad.offset.y;
			var distance:Number = Point.distance(new Point($component.x,$component.y), destination);
			var duration:Number = distance/_speed;
			if(distance>100)	duration/=2;
			if($component.hasOwnProperty("onMouseStartMoving")){
				$component.onMouseStartMoving(destination.x,destination.y);
			}
			$component.spatialMove.move($component.spatialMove.WALK);
			TweenLite.to($component,duration,{x:destination.x, y:destination.y,ease:Linear.easeNone, onComplete :onTweenComplete, onCompleteParams:[$component] });
		}
		//------ On Mouse Up ------------------------------------
		protected function onMouseUp($mousePad:MousePad, $component:Component):void {
			if($component.hasOwnProperty("type")){
				var type:int = $component.type;
			}else{
				type =_type;
			}
			if(type==PRESS){
				TweenLite.killTweensOf($component);
			}
			$component.spatialMove.move($component.spatialMove.STAND);
		}
		//------ On Tween Complete ------------------------------------
		protected function onTweenComplete($component:Component):void {
			if($component.hasOwnProperty("onMouseStopMoving")){
				$component.onMouseStopMoving();
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}