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
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	/**
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TimerComponent extends Component {
		
		private var _timer:Timer;
		private var _delay:Number = 100;
		private var _timeline:Dictionary;
		private var _pause:Boolean = false;
		
		public function TimerComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function initVar($prop:Object):void {
			if ($prop && $prop.delay )	_delay = $prop.delay;
			_timer = new Timer(_delay);
			_timeline = new Dictionary(true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("timer");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "timer") {
				addToTimeline($component, $param);
				if(!_timer.running){
					_timer.start();
					_timer.addEventListener(TimerEvent.TIMER, onTick,false,0,true);
				}
			}
		}
		//------ Add To Timeline  ------------------------------------
		private function addToTimeline($component:Component, $param:Object):void {
			if(!($param && $param.delay && $param.callback)) {
				throw new Error("To be registered to TimerComponent you need a delay and callback parameter");
			}else if($param && $param.params && !$param.params is Array) {
				throw new Error("Params must be an array");
			}
			var delay:Number = Math.ceil($param.delay/_delay); // need to adjust
			if(!_timeline[delay]){
				_timeline[delay] = {delay:delay, components:new Array, count:0, callbacks:new Array};
			}
			if(_timeline[delay].components.lastIndexOf($component)==-1){
				_timeline[delay].callbacks.push({callback:$param.callback,params:$param.params});
				_timeline[delay].components.push($component);
			}
		}
		//------ On Tick ------------------------------------
		private function onTick($evt:TimerEvent):void {
			if(_pause)	return;
			_pause=true;
			for each (var object:Object in _timeline){
				object.count++;
				if(object.count==object.delay){
					for each (var call:Object in object.callbacks){
						var callback:Function = call.callback;
						var params:Array = call.params;
						callback.apply(null,params);
					}
					object.count=0;
				}
			}
			_pause = false;
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			removeFromList($component);
			super.removePropertyComponent($propertyName,$component);
		}
		//------ Remove from List ------------------------------------
		private function removeFromList($component:Component):void {
			for each (var object:Object in _timeline){
				for each (var component:Object in object.components){
					if(component == $component){
						var index:Number = object.components.lastIndexOf(component);
						object.components.splice(index,1);
						object.callbacks.splice(index,1);
						if(object.components.length==0){
							delete _timeline[object.delay];
						}
					}
				}
			}
		}
	}
}