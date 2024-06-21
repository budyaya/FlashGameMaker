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
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.mouse.MousePad;
	import utils.time.*;
	import utils.ui.Tooltip;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MouseInputComponent extends Component {
		protected var _mouseManager:IMouseManager = null;
		private var _isListening:Boolean = false;
		private var _pixelOnly:Boolean = true; //If true check collision zone
		private var _mousePad:MousePad;
		private var _doubleClick:Boolean = false;
		private var _longClick:Boolean = false;
		private var _longClickLatence:Number = 575;
		private var _timer:Number = 0;
		private var _interval:Number = 0;
		private var _list:Dictionary;
		private var _callback:Function = null;
		
		private var _testPerformance:Boolean = false;
		private var _testApi:Boolean = false;
		private var _mouseTest:Sprite;
		private var _displayTest:Sprite;
		private var _bitmapTest:Bitmap;
		private var _mouseMoveInterval:Number = 0; //Check time between 2 mouseMove
		private var _mouseGlobal:Point = null;
		private var _mousePixelColor:uint = 0;
		private var _colorTest:Boolean = false;
		
		public function MouseInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity, true);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			Framework.clip.doubleClickEnabled = true;
			_mouseManager = MouseManager.getInstance();
			_mousePad = new MousePad;
			_list = new Dictionary(true);
			_list["Component"] = new Array;
			_list["onMouseClick"] = new Array;
			_list["onMouseDown"] = new Array;
			_list["onMouseUp"] = new Array;
			_list["onMouseMove"] = new Array;
			_list["onMouseWheel"] = new Array;
		
			_mouseTest = new Sprite;
			_displayTest = new Sprite;
			_bitmapTest = new Bitmap();
			if(_testApi){
				_mouseTest.mouseEnabled = false;
				Framework.AddChild(_mouseTest);
				_displayTest.mouseEnabled = false;
				Framework.AddChild(_displayTest);
				//FlashGameMaker.AddChild(_bitmapTest);
			}
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			Framework.stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			Framework.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			Framework.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true, 0, true);
			Framework.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			Framework.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			//FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			Framework.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			Framework.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Framework.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,true);
			Framework.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Framework.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//Framework.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "mouseInput") {
				if(!_isListening){
					_isListening=true;
					initListener();
					//registerPropertyReference("enterFrame", {onEnterFrame:onTick}); //Only for detecting when mouse not moving
				}
				addToList($component,$param);
			}
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			removeFromList($component);
			super.removePropertyComponent($propertyName,$component);
		}
		//------ Add To List ------------------------------------
		private function addToList($component:Component, $param:Object):void {
			var componentList:Array = _list["Component"];
			if(!$param){
				trace("[Warning] A mouseEvent function such as  onMouseMove must exist to be registered by MouseInputComponent");
				return;
			}else if(!($param.hasOwnProperty("onMouseMove") || $param.hasOwnProperty("onMouseRollOut") || $param.hasOwnProperty("onMouseRollOver"))){
				if(!($param.hasOwnProperty("onMouseUp") || $param.hasOwnProperty("onMouseClick") || $param.hasOwnProperty("onMouseDown") || $param.hasOwnProperty("onMouseWheel"))){
					trace("[Warning] A mouseEvent function such as  onMouseMove must exist to be registered by MouseInputComponent");
					return;
				}
			}
			if(componentList.indexOf($component)!=-1)		return; //Component already assigned to list
			
			if($param.hasOwnProperty("onMouseMove") || $param.hasOwnProperty("onMouseRollOut") || $param.hasOwnProperty("onMouseRollOver")){
				_list["onMouseMove"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseDown")){
				_list["onMouseDown"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseUp")){
				_list["onMouseUp"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseClick")){
				_list["onMouseClick"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseWheel")){
				_list["onMouseWheel"].push({component:$component,param:$param});
			}
		}
		//------ Remove from List ------------------------------------
		private function removeFromList($component:Component):void {
			for each (var list:Array in _list){
				for each (var object:Object in list){
					if(object.component == $component){
						var index:int = list.lastIndexOf(object);
						list.splice(index,1);
						if($component == _mouseManager.rollOver)	_mouseManager.rollOver = null;
						if($component == _mouseManager.drag)		_mouseManager.drag = null;
						if($component == _mouseManager.clicked)		_mouseManager.clicked = null;
						break;
					}
				}
			}	
		}
		//------ On Dispatch ------------------------------------
		private function dispatch($callback:String):void {
			var time:Number = Time.GetTime(); 
			var iteration:int =0;
			var components:Vector.<Object> = _properties["mouseInput"].components;
			_list[$callback].sort(sortDepths);
			if(_mouseManager.rollOver && !_mouseManager.rollOver.visible){
				_mouseManager.rollOver = null
			}
			if(_mouseManager.drag && !_mouseManager.drag.visible){
				_mouseManager.drag = null
			}
			if(_mouseManager.clicked && !_mouseManager.clicked.visible){
				_mouseManager.clicked = null
			}
			var rollOver:Component = _mouseManager.rollOver as Component;
			var drag:Component = _mouseManager.drag as Component;
			var clicked:Component = _mouseManager.clicked as Component;
			var time2:Number;
			var hitTest:Boolean
			var callBack:Function;
			_mousePixelColor = MouseManager.MousePixelColor;
			_mouseGlobal = new Point(Framework.clip.mouseX,Framework.clip.mouseY);
			for each (var object:Object in _list[$callback]){
				if(object.component.hasOwnProperty("isDisplayed") && !object.component.isDisplayed || !object.component.visible){
					continue;
				}else if(object.component.hasOwnProperty("isDisabled") && object.component.isDisabled){
					continue;
				}else if(_mouseManager.mouseTargets && _mouseManager.mouseTargets.indexOf(object.component)==-1 && !(rollOver && rollOver==object.component)){ //Case of exclusive mouse targets
					continue;
				}
				iteration++;
				if(_testPerformance) 	time2 = Time.GetTime();
				hitTest = checkPosition(object.component);
				if(_testPerformance)	time2 = Time.GetTime()-time2;
				if($callback == "onMouseMove" && !drag){
					if(object.param.hasOwnProperty("onMouseRollOut") && rollOver==object.component && !hitTest){
						call(object.param["onMouseRollOut"],_mousePad);
						_mouseManager.rollOver=null;
						_callback = null;
						return;
					}else if(object.param.hasOwnProperty("onMouseRollOver") && rollOver!=object.component && hitTest){
						if(rollOver && checkPosition(rollOver)){
							if(Framework.IndexOf(rollOver)>Framework.IndexOf(object.component)) return;
							if(rollOver.y>object.component.y) return;
						}
						if(rollOver){
							call(_callback,_mousePad);
						}
						_mouseManager.rollOver=object.component;
						call(object.param["onMouseRollOver"],_mousePad);
						if(object.param.hasOwnProperty("onMouseRollOut")){
							_callback=object.param["onMouseRollOut"];
						}
						return;
					}
				}
				if(object.param.hasOwnProperty($callback)){
					if((object.param.hasOwnProperty("onMouseDown") && $callback == "onMouseDown" || object.param.hasOwnProperty("onMouseClick") && $callback == "onMouseClick") && hitTest &&!clicked){	
						/*if(object.param.hasOwnProperty("onMouseRollOut") && rollOver==object.component){
							call(object.param["onMouseRollOut"],_mousePad);
							_mouseManager.rollOver=null;
							rollOver =null;
						}*/
						_mouseManager.clicked = object.component;
						clicked = _mouseManager.clicked as Component;
						call(object.param[$callback],_mousePad);
					}else if((object.param.hasOwnProperty("onMouseDown") && $callback == "onMouseDown" || object.param.hasOwnProperty("onMouseClick") && $callback == "onMouseClick") && object.param.hasOwnProperty("capture")){
						call(object.param[$callback],_mousePad);
					}else if( object.param.hasOwnProperty($callback) && ($callback != "onMouseDown" && $callback != "onMouseClick")){
						call(object.param[$callback],_mousePad);
					}
				}
			}
			if(_testPerformance){
				trace($callback,": ", Time.GetTime()-time+"ms, checkPosition: "+time2+"ms, iteration: "+iteration, ", MouseClick: "+ _list["onMouseClick"].length,", MouseDown: "+ _list["onMouseDown"].length," MouseMove: "+ _list["onMouseMove"].length);
			}
		}
		//------ Call ------------------------------------
		private function call($callback:*,$mousePad:MousePad):void {
			if($callback is Array){
				for each (var callback:Function in $callback){
					callback($mousePad);
				}
			}else if($callback){
				$callback($mousePad);
			}
		}
		//------ On Tick ------------------------------------
		public function onTick():void {
			if(_mousePad && _mousePad.mouseEvent){
				dispatch("onMouseMove");
				dispatchEvent(_mousePad.mouseEvent);
			}
		}
		//------ Check Position ------------------------------------
		private function checkPosition($component:Component):Boolean {
			if(!$component || !$component.visible || !$component.graphic || ($component.graphic && !$component.graphic.visible))	return false;
			if($component.graphic is SimpleButton){
				var bounds:Rectangle =$component.graphic.hitTestState.getBounds(null);
			}else{
				bounds =$component.graphic.getBounds($component.graphic);
			}
			var width:Number = bounds.width;
			var height:Number = bounds.height;
			if($component.hasOwnProperty("getLoaderInfo")){
				var loaderInfo:LoaderInfo =  $component.getLoaderInfo();
				if(loaderInfo){
					width = loaderInfo.width;
					height = loaderInfo.height;
				}
			}
			if(width == 0 || height == 0){
				return false;
				//throw new Error("Bounds dimension can't be 0!!!")
			}
			//Bounds Drawing
			_displayTest.graphics.clear();
			_displayTest.graphics.beginFill(0xFF0000,0.5);
			_displayTest.graphics.drawRect(bounds.x,bounds.y,width,height);
			_displayTest.graphics.endFill();
			_displayTest.transform.matrix = $component.transform.matrix;
			//Mouse Drawing
			_mouseTest.graphics.clear();
			_mouseTest.graphics.beginFill(0x0000FF,0.5);
			_mouseTest.graphics.drawRect(_mouseGlobal.x-3,_mouseGlobal.y-3,6,6);
			_mouseTest.graphics.endFill();
			if(_displayTest.hitTestPoint(_mouseGlobal.x,_mouseGlobal.y)|| _displayTest.hitTestObject(_mouseTest)){
				if(!_pixelOnly || $component.graphic is SimpleButton)	return true;
				//Graphic Copy
				var bitmapData:BitmapData =new BitmapData(width,height,true, 0);
				var matrix:Matrix = $component.graphic.transform.matrix;
				matrix.translate(-bounds.x,-bounds.y);
				bitmapData.draw($component.graphic,matrix);
				bitmapData.colorTransform(bitmapData.rect,$component.graphic.transform.colorTransform);
				_bitmapTest.bitmapData = bitmapData;
				_bitmapTest.x = $component.x + bounds.x;
				_bitmapTest.y = $component.y + bounds.y;
				var pixel:uint = _bitmapTest.bitmapData.getPixel32(_mouseGlobal.x-($component.x + bounds.x),_mouseGlobal.y-($component.y + bounds.y));
				var alphaValue:uint = pixel >> 24 & 0xFF;
				var colorDistance:Number =  colorDist(pixel,_mousePixelColor);
//				trace($component.componentName,pixel.toString(16),_mousePixelColor.toString(16), colorDistance,alphaValue>0 && colorDistance<50);
				if(alphaValue>0 && !_colorTest || alphaValue>0 && (colorDistance<50 || $component==_mouseManager.clicked || $component==_mouseManager.rollOver)){
					return true;
				}
			}
			return false;
		}
		//------ Color Dist ------------------------------------
		private function colorDist(c1:uint, c2:uint):Number{
			var dr:int = ((c1 >> 16) & 0xFF) - ((c2 >> 16) & 0xFF);
			var dg:int = ((c1 >> 8) & 0xFF) - ((c2 >> 8) & 0xFF);
			var db:int = (c1 & 0xFF) - (c2 & 0xFF);
			return Math.sqrt(dr * dr + dg * dg + db * db);
		}
		//------ On MouseEvent ------------------------------------
		private function onMouseEvent($evt:MouseEvent ,$callBack:String):void {
			updateMouse($evt);
			dispatch($callBack);
			dispatchEvent($evt);
		}
		//------ On Mouse Down ------------------------------------
		private function onMouseDown($evt:MouseEvent):void {
			if ($evt.eventPhase == EventPhase.BUBBLING_PHASE) return;
			initTimer();
			onMouseEvent($evt, "onMouseDown");
		}
		//------ On Mouse Up ------------------------------------
		private function onMouseUp($evt:MouseEvent):void {
			updateTimer();
			checkLongClick();
			_mouseManager.clicked = null;
			onMouseEvent($evt, "onMouseUp");
		}
		//------ On Mouse Click ------------------------------------
		private function onMouseClick($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseClick");
		}
		//------ On Mouse Move ------------------------------------
		private function onMouseMove($evt:MouseEvent):void {
			var time:Number = Time.GetTime();
			if(time - _mouseMoveInterval>30){ 
				_mouseMoveInterval = time;
				onMouseEvent($evt, "onMouseMove");
			}
		}
		//------ On Mouse Wheel ------------------------------------
		private function onMouseWheel($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseWheel");
		}
		//------ Update Mouse ------------------------------------
		private function updateMouse($evt:MouseEvent):void {
			_mousePad.mouseEvent = $evt;
			_mousePad.clickDuration = _interval;
			_mouseManager.mousePad = _mousePad;
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			_timer = getTime();
			_interval = -1;
		}
		//------ Update Timer ------------------------------------
		private function checkTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Update Timer ------------------------------------
		private function updateTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Check Long Click ------------------------------------
		private function checkLongClick():void {
			if(_interval>_longClickLatence){
				_longClick = true;
			}else{
				_longClick = false;
			}
		}
		//---- Get Time ------------------------------------------------
		private function getTime():Number{
			return Time.GetTime();
		}	
		//------ Sort Depths ------------------------------------
		private function sortDepths($object1:Object, $object2:Object):int{
			if ($object1.component.y < $object2.component.y ) return 1;
			if ($object1.component.y > $object2.component.y) return -1;
			return 0;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}