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
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.entity.*;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.keyboard.KeyPadInput;
	import utils.mouse.MousePad;
	import utils.physic.SpatialMove;
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;
	import framework.component.Component;

	/**
	* Jauge Class
	* @ purpose: 
	*/
	public class JaugeMoveComponent extends GraphicComponent {

		private var _jaugeText:TextField=null;
		private var _startText:TextField=null;
		private var _jauge:ProgressBar=null;
		private var _count:Number=0;
		private var _max:Number=100;
		private var _delay:int = 300;
		private var _facingDir:IsoPoint= new IsoPoint(1,0,0);
		private var _treshold:Number = 25;
		
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		
		public var _keyPad:KeyPad;	//KeyboardInput properties

		public function JaugeMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_keyPad = new KeyPad;
			_timeline = new Dictionary(true);
			_jauge=createProgressBar(100,20,0,0,0);
			_jauge.setStyle("themeColor", 0xFF0000);
			_jauge.x+=10;
			_jauge.maximum=100;
			addChild(_jauge);
			
			_jaugeText=new TextField  ;
			_jaugeText.autoSize="left";
			_jaugeText.text= "Press UP arrow to jump";
			_jaugeText.y+=20;
			addChild(_jaugeText);
			
			_startText=new TextField;
			_startText.autoSize="center";
			_startText.text= "Click to Start";
			_startText.setTextFormat(StyleManager.ClickToStart);
			_startText.selectable = false;
			LayoutUtil.Align(_startText,LayoutUtil.ALIGN_CENTER_CENTER);
			addChild(_startText);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("jaugeMove");
			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
			registerPropertyReference("mouseInput",{onMouseDown:start,capture:true});
		}
		//------ On Key Fire ------------------------------------
		private function start($mousePad:MousePad):void {
			if(!_isRunning){
				removeChild(_startText);
				registerPropertyReference("timer", {callback:onTick, delay:_delay});
				_isRunning = true;
			}
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
			updateComponents();
		}
		//------ On Key Fire ------------------------------------
		private function onTick():void {
			updateJauge();
			updateComponents();
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "jaugeMove") {
				updateComponent($component, $param);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component, $param:Object = null):void {
			//Check properties
			if($component.hasOwnProperty("spatialMove") && $component.spatialMove){
				_timeline[$component] = {component:$component, param:$param};
			}else{
				throw new Error("A SpatialMove and a BitmapSet must exist to be registered by JaugeMoveComponent");
			}
		}
		//------ Update Jauge ------------------------------------
		private function updateJauge():void {
			_count+=0.1;
			var count:Number = Math.sin(_count);
			if(_count>=0 && _count<= 1){
				_jauge.setProgress(count*100,_max);
			}else if (_count>1){
				_jauge.setProgress(_max,_max);
			}
		}
		//------ Move ------------------------------------
		private function updateComponents():void {
			var spatialMove:SpatialMove;
			var bitmapSet:BitmapSet;
			var graph:BitmapGraph
			for each(var object:Object in _timeline){
				spatialMove = object.component.spatialMove;
				spatialMove.movingDir.x=_facingDir.x;
				bitmapSet = object.component.bitmapSet;
				graph = bitmapSet.graph;
				if(_count>0){
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
							if(spatialMove.RUN.speed.x<3){
								spatialMove.RUN.speed.x+=_count;
							}
						}
					}
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
		//------- setDirection -------------------------------
		public function setDirection($direction:uint):void {
		/*	if(_direction!=$direction && $direction==RIGHT){
				_direction=$direction;
				_jauge.rotation = 0;
			}else if(_direction!=$direction && $direction==LEFT){
				_direction=$direction;
				_jauge.rotation = 180;
			}else if(_direction!=$direction && $direction==UP){
				_direction=$direction;
				_jauge.rotation = -90;
			}else if(_direction!=$direction && $direction==DOWN){
				_direction=$direction;
				_jauge.rotation = 90;
			}*/
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}