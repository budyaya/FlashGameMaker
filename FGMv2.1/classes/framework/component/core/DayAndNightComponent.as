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
	import fl.motion.AdjustColor;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.time.Time;
	
	/**
	 * Day and Night Component
	 * 
	 */
	public class DayAndNightComponent extends Component {
		private var _timer:Timer = null;
		private var _duration:Number = 500;
		private var _count:Number=1;
		private var _target:DisplayObject = null;
		private var _color:AdjustColor = null;
		private var _day:Boolean=true;
		public function DayAndNightComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_color = new AdjustColor();
			_timer = new Timer(_duration);
			_timer.addEventListener(TimerEvent.TIMER, onTimer,false,0,true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
		}
		//------ On Tick ------------------------------------
		private function onTimer($evt:TimerEvent):void {
			_color.hue = -1*_count;
			_color.contrast = -1*_count;
			_color.brightness = -1*_count;
			_color.saturation = -1*_count;
			_target.filters = [new ColorMatrixFilter( _color.CalculateFinalFlatArray() )]
			if(_day && _count<50){
				_count++;
			}else if(!_day && _count>0){
				_count--;
			}else{
				_day = !_day
			}
		}
		//------ Set Target ------------------------------------
		public function setTarget($target:DisplayObject):void {
			_target = $target;
			_timer.start();
		}
		//------- ToString -------------------------------
		public  override function ToString():void {
			trace();
		}
	}
}