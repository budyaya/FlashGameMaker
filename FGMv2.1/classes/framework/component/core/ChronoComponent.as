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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.component.Component;
	import framework.entity.*;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.time.Time;
	
	/**
	 * Chrono Class
	 * @ purpose: 
	 */
	public class ChronoComponent extends GraphicComponent {
		
		protected var _bitmapSet:* = null			// BitmapAnim property can be BitmapSet or extended to  SwfSet
		protected var _autoAnim:Boolean = true;
		private var _delay:Number=3500; 			//Timer properties
		private var _timeline:Dictionary;
		private var _count:Number=3;
		public var _reversed:Boolean = true;
		
		public function ChronoComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.delay)		_delay = $prop.delay;
			if($prop && $prop.bitmapSet)	_bitmapSet = $prop.bitmapSet;
			_graphic = new Bitmap;
			_autoAnim = false;
			_timeline = new Dictionary(true);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("chrono");
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function=null):void {
			bitmapSet = new BitmapSet($graphic,null);
			if($callback is Function)	$callback(this);
			start();
			registerPropertyReference("bitmapAnim");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "chrono") {
				updateComponent($component, $param);
			}
		}
		//------ Update Component ------------------------------------
		public function updateComponent($component:Component, $param:Object = null):void {
			//Check properties
			if(!_timeline[$component]){
				_timeline[$component] = {component:$component, param:$param};
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			if(_reversed && _bitmapSet.graph.animations["CHRONO"].position > 0){
				_bitmapSet.graph.anim("CHRONO",true);
				actualize("bitmapAnim");
			}else if(!_reversed && _bitmapSet.graph.animations["CHRONO"].position < _count){
				_bitmapSet.graph.anim("CHRONO");
				actualize("bitmapAnim");
			}else{
				stop();
			}
		}
		//------ Start ------------------------------------
		public function start():void {
			if(_reversed){
				_bitmapSet.graph.createGraph("CHRONO", 0,0,32,45,null, null,10,_count);
			}else{
				_bitmapSet.graph.createGraph("CHRONO", 0,0,32,45,null, null,10,1);
			}
			_bitmapSet.graph.currentAnim = 	_bitmapSet.graph.animations["CHRONO"];
			registerPropertyReference("timer",{callback:onTick, delay:_delay});
		}
		//------ Stop ------------------------------------
		public function stop():void {
			visible=false;
			//destroy();
			for each(var component:Object in _timeline){
				if(component.param && component.param.hasOwnProperty("onChronoEnd")){
					component.param.onChronoEnd();
				}else if(component.component.hasOwnProperty("onChronoEnd")){
					component.component.onChronoEnd();
				}
			}
		}
		//------ Rest Chrono ------------------------------------
		public function reset($count:Number):void {
			_count = $count;
		}
		//------ Get BitmapSet ------------------------------------
		public function get bitmapSet():BitmapSet {
			return _bitmapSet;
		}
		//------ Set BitmapSet ------------------------------------
		public function set bitmapSet($bitmapSet:BitmapSet):void {
			_bitmapSet = $bitmapSet;
		}
		//------- Get AutoAnim -------------------------------
		public function get autoAnim():Boolean {
			return _autoAnim;
		}
		//------- Set AutoAnim -------------------------------
		public function set autoAnim($autoAnim:Boolean):void {
			_autoAnim = $autoAnim;
		}
		//------- Get CurrentAnim -------------------------------
		public function get currentAnimName():String {
			return bitmapSet.currentAnimName;
		}
		//------- Get PrevAnim -------------------------------
		public function get previousAnimName():String {
			return bitmapSet.previousAnimName;
		}
//		//------- Get AutoAnim -------------------------------
//		public function get currentPoseName():String {
//			return bitmapSet.currentPoseName;
//		}
		//------- Get CurrentFrame -------------------------------
		public function get currentPosition():int {
			return bitmapSet.currentPosition;
		}
		//------- Get LastFrame -------------------------------
		public function get lastPosition():int {
			return bitmapSet.lastPosition;
		}
	}
}