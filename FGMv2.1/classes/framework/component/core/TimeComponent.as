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
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.entity.*;
	
	import utils.time.Time;
	/**
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TimeComponent extends SimpleGraphicComponent {
		private var _beginTime:Number = 0;
		private var _currentTime:Number = 0;
		private var _delay:Number = 10;
		
		private var _virtualTimeTF:TextField=null;
		private var _realTimeTF:TextField=null;
		private var _virtualTime:Object = null;
		private var _realTime:Object = null;
		
		public function TimeComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.delay)	_delay = $prop.delay;
			_virtualTime = new Object();
			_realTime = new Object();
			_virtualTimeTF = new TextField();
			_virtualTimeTF.autoSize = "left";
			_virtualTimeTF.text = "Virtual Time";
			_realTimeTF = new TextField();
			_realTimeTF.autoSize = "left";
			_realTimeTF.text = "Real Time";
			_realTimeTF.y+=15;
			addChild(_virtualTimeTF);
			addChild(_realTimeTF);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("timer", {callback:onTick, delay:_delay});
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			updateText();
		}
		//------ Update Text ------------------------------------
		private function updateText():void {
			var realTime:Number = Time.GetTime();
			var virtualTime:Number = Time.GetTime()-_beginTime;
			
			var virtualTimeObject:Object = getTimeObject(virtualTime);
			var virtualTimeTxt:String="Day: "+virtualTimeObject.day;
			virtualTimeTxt +=" , Time: "+virtualTimeObject.hour+":"+virtualTimeObject.min+":"+virtualTimeObject.sec;
			_virtualTimeTF.text = "Virtual Time: " +virtualTimeTxt;
			
			var realTimeObject:Object = getTimeObject(realTime);
			var realTimeTxt:String="Day: "+realTimeObject.day;
			realTimeTxt +=" , Time: "+realTimeObject.hour+":"+realTimeObject.min+":"+realTimeObject.sec;
			_realTimeTF.text = "Real Time: " +realTimeTxt;
		}
		//------ Get Time ------------------------------------
		private function getTimeObject($time:Number):Object {
			var time:Object = {day:Time.GetDay($time) ,hour:Time.GetHour($time) ,min:Time.GetMin($time) ,sec:Time.GetSec($time)};
			return time;
		}
		//------ Update Time ------------------------------------
		private function updateVirtualTime():void {
			
		}
	}
}