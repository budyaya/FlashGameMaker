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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.richardlord.FiniteStateMachine;
	
	/**
	* Finite State Machine Component
	* 
	*/
	public class FiniteStateMachineComponent extends Component {
		private var _finiteStateMachineList:Dictionary = null;
		private var _callBackList:Dictionary = null;
		
		public function FiniteStateMachineComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_finiteStateMachineList = new Dictionary(true);
			_callBackList = new Dictionary(true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("finiteStateMachine");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "finiteStateMachine") {
				addToList($component,$param);
			}
		}
		//------ Add To List ------------------------------------
		private function addToList($component:Component, $param:Object):void {
			if(!$param || !$param.name){
				throw new Error("[Warning] To register you need to have a finiteMachineState name parameter");
			}
			var fsmObject:Object = _finiteStateMachineList[$param.name];
			if(!fsmObject){
				throw new Error("[Warning] There is no FiniteStateMachine with the name "+$param.name+". Please create a FSM prior to register");
			}
			var fsm:FiniteStateMachine = fsmObject["finiteStateMachine"];
			var componentList:Vector.<Component> = fsmObject["Components"];
			if(componentList.indexOf($component)!=-1)	{	
				trace("[WARNING] The component "+$component.name+" is already registered");
			}else{
				componentList.push($component);
				_callBackList[$component] = $param.callback;
			}
		}
		//------ Create Finite State Machine ------------------------------------
		public function createFiniteStateMachine($fsmName:String):FiniteStateMachine {
			if(_finiteStateMachineList[fsm.name]){
				trace("[Warning] A finite state machine already exist with this name "+$fsmName);
				return _finiteStateMachineList[fsm.name];
			}
			var fsm:FiniteStateMachine = new FiniteStateMachine($fsmName);
			fsm.addEventListener(Event.CHANGE,onFiniteStateMachineChange,false,0,true);
			_finiteStateMachineList[fsm.name] = {"finiteStateMachine": fsm, "Components":new Vector.<Component>()}
			return _finiteStateMachineList[fsm.name];
		}
		//------ Remove Finite State Machine ------------------------------------
		public function removeFiniteStateMachine($fsmName:String):void {
			if(_finiteStateMachineList[$fsmName]){
				var fsm:FiniteStateMachine = _finiteStateMachineList[$fsmName]["finiteStateMachine"];
				fsm.removeEventListener(Event.CHANGE,onFiniteStateMachineChange);
				fsm = null;
				delete _finiteStateMachineList[$fsmName];
			}
		}
		//------ On Finite State Machine Change ------------------------------------
		private function onFiniteStateMachineChange($evt:Event):void {
			var fsm:FiniteStateMachine = $evt.target as FiniteStateMachine;
			var fsmName:String = fsm.name;
			var componentList:Vector.<Component> = _finiteStateMachineList[fsmName]["Components"] as Vector.<Component>;
			if(componentList.length>1){
				dispatch(fsmName);
			}
		}
		//------ On Dispatch ------------------------------------
		private function dispatch($fsmName:String):void {
			var componentList:Vector.<Component> = _finiteStateMachineList[$fsmName]["Components"] as Vector.<Component>;
			var callBack:Function;
			for each (var component:Component in componentList){
				callBack = _callBackList[component]
				if(callBack!=null){
					callBack(_finiteStateMachineList[$fsmName]);
				}
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}