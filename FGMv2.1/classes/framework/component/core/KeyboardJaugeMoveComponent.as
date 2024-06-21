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
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	
	import flash.events.*;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.entity.*;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.keyboard.KeyPadInput;
	import utils.physic.SpatialMove;
	import framework.component.Component;

	/**
	* Jauge Class
	* @ purpose: 
	*/
	public class KeyboardJaugeMoveComponent extends GraphicComponent {

		private const RIGHT:Number = 1;
		private const LEFT:Number = -1;
		private const DOWN:Number = 1;
		private const UP:Number = -1;
		private var _text:TextField=null;
		private var _jauge:ProgressBar=null;
		private var _count:Number=0;
		private var _max:Number=100;
		private var _delay:int = 100;
		private var _stepUp:Number=10;
		private var _stepDown:Number=10;
		private var _facingDir:IsoPoint= new IsoPoint(1,0,0);
		private var _prevKey:KeyPadInput=null;
		private var _treshold:Number = 30;
		
		private var _isRunning:Boolean = false;
		private var _pause:Boolean = false;
		private var _timeline:Dictionary;
		
		public var _keyPad:KeyPad;	//KeyboardInput properties

		public function KeyboardJaugeMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_keyPad = new KeyPad;
			_timeline = new Dictionary(true);
			
			_jauge=createProgressBar(100,20,0,0,0);
			_jauge.setStyle("themeColor", 0xFF0000);
			_jauge.x+=50;
			_jauge.maximum=100;
			addChild(_jauge);
			
			_text=new TextField  ;
			_text.autoSize="left";
			_text.text= "Press LEFT and RIGHT arrows to run";
			_text.y+=20;
			addChild(_text);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("keyboardJaugeMove");
			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
			updateJauge();
			_pause=false;
			updateComponents();
		}
		//------ OnTick ------------------------------------
		private function onTick():void {
			if(!_pause){
				updateComponents();
				step();
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "keyboardJaugeMove") {
				updateComponent($component, $param);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component, $param:Object = null):void {
			//Check properties
			if($component.hasOwnProperty("spatialMove") && $component.spatialMove){
				_timeline[$component] = {component:$component, param:$param};
				if(!_isRunning){
					_isRunning = true;
					registerPropertyReference("timer", {callback:onTick, delay:_delay});
				}
			}else{
				throw new Error("A SpatialMove and a BitmapSet must exist to be registered by JaugeMoveComponent");
			}
		}
		//------ Update Jauge ------------------------------------
		private function updateJauge():void {
			if (_keyPad.right.isDown &&_count<_max) {
				if(_prevKey==_keyPad.left && !_prevKey.isDown){
					_count+=_stepUp;
				}
				_prevKey = _keyPad.right;
			}else if (_keyPad.left.isDown &&_count<_max) {
				if(_prevKey==_keyPad.right && !_prevKey.isDown){
					_count+=_stepUp;
				}
				_prevKey = _keyPad.left;
			}
			_jauge.setProgress(_count,_max);
		}
		//------ Step ------------------------------------
		private function step():void {
			var stepDown:Number = _stepDown;
			if(_keyPad.isDown){
				stepDown/=2;
			}
			if(_count-stepDown>0){
				_count -= stepDown;
			}else{
				_count=0
			}
			_jauge.setProgress(_count,_max);
		}
		//------ Move ------------------------------------
		private function updateComponents():void {
			var spatialMove:SpatialMove;
			var bitmapSet:BitmapSet;
			var graph:BitmapGraph
			for each(var component:Object in _timeline){
				spatialMove = component.component.spatialMove;
				bitmapSet = component.component.bitmapSet;
				graph = bitmapSet.graph;
				if(_count>0){
					spatialMove.movingDir.x=_facingDir.x;
					if(spatialMove.isRunning() && _keyPad.up.isDown){
						spatialMove.move(spatialMove.JUMP);
						graph.anim("RUN_JUMP");
					}else{
						if(_jauge.percentComplete<_treshold){
							if(!spatialMove.isWalking()){
								spatialMove.move(spatialMove.WALK);
							}
							if(!spatialMove.isJumping())
								graph.anim("WALK_CYCLE");
						}else{
							if(!spatialMove.isRunning()){
								spatialMove.move(spatialMove.RUN);
							}
							if(!spatialMove.isJumping()){
								graph.anim("RUN_CYCLE");
							}
						}
					}
				}else if(!spatialMove.isStanding()){
					spatialMove.movingDir.x = 0;
					spatialMove.move(spatialMove.STAND);
					graph.anim("WALK_TO_IDLE");
					_pause =true;
				}
			}
		}
		//------ Create Progress Bar ------------------------------------
		public function createProgressBar($width:Number,$height:Number,$x:Number,$y:Number,$rotation:Number):ProgressBar {
			var progressBar:ProgressBar=new ProgressBar  ;
			progressBar.mode=ProgressBarMode.MANUAL;
			progressBar.setSize($width,$height);
			progressBar.move($x,$y);
			progressBar.rotation=$rotation;
			return progressBar;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}