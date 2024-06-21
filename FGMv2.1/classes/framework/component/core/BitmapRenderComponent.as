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
/*
* Inspired from Iain Lobb - iainlobb@googlemail.com
* BunnyBenchMark Experiment http://www.iainlobb.com/bunnies/BlitTest.html
*/

package framework.component.core{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.FullScreenEvent;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.iso.IsoPoint;
	import utils.mouse.MousePad;
	import utils.senocular.PassParameters;
	import utils.text.StyleManager;
	import utils.time.Time;
	import utils.ui.LayoutUtil;
	
	/**
	 * Bitmap Render Component: Manage the graphical rendering
	 */
	public class BitmapRenderComponent extends Component {
		
		protected var _mouseManager:IMouseManager = null;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		private var _lastClick:Point = null;
		private var _position:IsoPoint = null;
		private var _zoom:Array;
		private var _zoomPosition:int = 1;
		private var _scrollTarget:DisplayObject=null;
		private var _scrollArea:Rectangle=null;
		private var _scrollPosition:IsoPoint=null;
		private var _scrollEnabled:Boolean = true;
		private var _testPerformance:Boolean = false;
		private var _interval:Number=0;
		private var _intervalMax:Number=30;
		private var _sortDepth:Boolean = true;
		private var _drawOnlyVisible:Boolean = true; //Slowdown CPU if you have a lot of Sprites visible but increase CPU perf if just a few are visible
		private var _boost:Boolean = false; //Optimized render for increased performance ! Implies no sortDepth, no callback, no display management
		
		public function BitmapRenderComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_mouseManager = MouseManager.getInstance();
			_bitmapData = new BitmapData(Framework.width, Framework.height,true,0);
			_bitmap = new Bitmap(_bitmapData);
			_timeline = new Dictionary(true);
			Framework.AddChild(_bitmap,this);//Properties of BitmapRender will influe Display
			Framework.AddChild(this,null,0);
			_position = new IsoPoint;
			_scrollPosition = new IsoPoint;
			_zoom = [0.5,1,1.5];
			if($prop && $prop.hasOwnProperty("sortDepth")){
				_sortDepth = $prop.sortDepth;
			}
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("bitmapRender");
			if(!_entity.entityManager.hasComponentFromFamily(EnterFrameComponent)){
				trace("[Warning] BitmapRenderComponent need the EnterFrameComponent to work !!!");
			}
			if(!_entity.entityManager.hasComponentFromFamily(MouseInputComponent)){
				trace("[Warning] BitmapRenderComponent need the MouseInputComponent to scroll !!!");
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "bitmapRender") {
				displayComponent($component, $param);
			}
		}
		//------ Display Component ------------------------------------
		public function displayComponent($component:Component, $param:Object = null):void {
			//Check properties
			if($component.hasOwnProperty("graphic") /*&& $component.graphic is Bitmap*/) {
				if(!_timeline[$component]){
					_timeline[$component] = {component:$component, param:$param};
					if(!_isRunning){
						_isRunning = true;
						onTick();
						registerPropertyReference("enterFrame", {onEnterFrame:onTick});
					}
				}
			}else{
				throw new Error("A graphic must exist to be registered by BitmapRenderComponent");
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			// -- Variable Declaration --
			if(_testPerformance)	var time:Number = Time.GetTime(); 
			var iteration:int =0;
			var time2:Number;
			var component:Component;
			var param:Object;
			var newScrollPosition:Point;
			var dimension:Point;
			var offset:Point;
			var rect:Rectangle;
			var bounds:Rectangle;
			var callback:Function;
			var bitmapData:BitmapData = null;
			var onScrollCallBack:Array= new Array;
			var drawableComponent:Array=new Array;
			// -- Methods --
			_scrollView();
			_updateView();
			_bitmapData.lock();
			_bitmapData.fillRect(_bitmapData.rect, 0);
			
			// -- Drawable Loop --
			for each(var object:Object in _timeline){
				component = object.component;
				// --  Direct drawing
				if(_boost){
					// --  Execute Functions
					_executeComponentFunction(component); //Permit to execute function in a single loop for every component!!! Power Max !!!
					_drawComponent(component,bitmapData)
					continue;
				}	
				if(!component.graphic || !component.visible){	
					if(component.hasOwnProperty("isDisplayed")){
						component.isDisplayed = false;
					}
					continue;
				}
				param = object.param;
				if(_lastClick){
					newScrollPosition = new Point(_scrollPosition.x+_lastClick.x - mouseX,_scrollPosition.y+_lastClick.y - mouseY-_scrollPosition.z);
					if(newScrollPosition && (!_scrollArea || _scrollArea.containsPoint(newScrollPosition))){
						if((_position.x!=0 || _position.y!=0) && param && param.hasOwnProperty("onScroll")){
							onScrollCallBack.push(param.onScroll);
						}else if((_position.x!=0 || _position.y!=0) && component.hasOwnProperty("onScroll")){
							onScrollCallBack.push(component.onScroll);
						}else if((_position.x!=0 || _position.y!=0) && !(component.hasOwnProperty("autoScroll") && !component.autoScroll)){
							component.x-=_position.x;
							component.y-=_position.y;
						}
					}
				}
				// -- Drawable Component --
				dimension = GraphicComponent(component).getDimension();//Width and Height
				if(!_drawOnlyVisible){
					iteration++;
					drawableComponent.push(component);
				}else if(component.hasOwnProperty("alwaysDisplay") && component.alwaysDisplay){
					if(component.hasOwnProperty("isDisplayed")){
						component.isDisplayed = true;
					}
					iteration++;
					drawableComponent.push(component);
				}else if (component.x+dimension.x >=_bitmap.x+_bitmap.x && component.x <_bitmap.x+_bitmap.width){
					if (component.y+dimension.y>=_bitmap.y+_bitmap.y && component.y <_bitmap.y+_bitmap.height){
						if(component.hasOwnProperty("isDisplayed")){
							component.isDisplayed = true;
						}
						iteration++;
						drawableComponent.push(component);
					}else if(component.hasOwnProperty("isDisplayed")){
						component.isDisplayed = false;
					}
				}else if(component.hasOwnProperty("isDisplayed")){
					component.isDisplayed = false;
				}
				// --  Execute Function -- DO NOT DELETE CONDITIONNAL
				// --  Execute Functions
				//Permit to execute function in a single loop for every component!!! Power Max !!!
				_executeComponentFunction(component); 
			}
			// -- Drawable Loop End --
			if(_testPerformance)	time2 = Time.GetTime();
			if(_sortDepth)	drawableComponent.sort(sortDepths);
			if(_testPerformance) trace("BitmapRender Sort: ", Time.GetTime()-time2+"ms");
			for each(component in drawableComponent){
				_drawComponent(component,bitmapData);
			}
			_bitmapData.unlock();
			
			//-- Callback ---
			for each(callback in onScrollCallBack){
				callback(_position);
			}
			//-- Memory Clean ---
			if(bitmapData){
				bitmapData.dispose();
				bitmapData=null;
			} 	
			drawableComponent = null;
			onScrollCallBack = null;
			if(_testPerformance && drawableComponent)trace("BitmapRender Draw: ", Time.GetTime()-time+"ms, "+drawableComponent.length+"/"+iteration);
			else if(_testPerformance)trace("BitmapRender Draw: ", Time.GetTime()-time+"ms, "+iteration);
		}
		//------ Execute Function ------------------------------------
		private function _executeComponentFunction($component:Component):void {
			if($component.functions){
				for each(var functions:Object in $component.functions){
					//Prototype: {executeOnlyIfDisplayed:true,callback:functionToExecute,parameters:[]}
					if(!_boost && functions.executeOnlyIfDisplayed && !$component.isDisplayed)	return;
					if(functions.parameters && functions.parameters is Array){
						//functions.callback(functions.parameters[0]);return; //For test only
						//Apply is too slow!!! Same goes for switch
						/*var callback:Function = PassParameters.ApplyArguments(functions.callback,functions.parameters);
						callback();*/
						var lenght:int = functions.parameters.length
						if(length==0){	functions.callback();return;}
						else if(length==1){	functions.callback(functions.parameters[0]);return;}
						else if(length==2){ functions.callback(functions.parameters[0],functions.parameters[1]);return;}
						else if(length==3){	functions.callback(functions.parameters[0],functions.parameters[1],functions.parameters[2]);return;}
						else if(length==4){	functions.callback(functions.parameters[0],functions.parameters[1],functions.parameters[2],functions.parameters[3]);return;}
						else if(length==5){	functions.callback(functions.parameters[0],functions.parameters[1],functions.parameters[2],functions.parameters[3],functions.parameters[4]);return;}
						else throw new Error("BitmapRenderComponent: ApplyArguments only support 5 max parameters!!!");
					}else{
						functions.callback();
					} 
				}
			}
		}
		//------ Draw Component ------------------------------------
		private function _drawComponent($component:Component,$bitmapData:BitmapData):void {
			if($component.hasOwnProperty("cacheAsBitmap") && $component.cacheAsBitmap && $component.hasOwnProperty("bitmapCache") && $component.bitmapCache){
				$bitmapData = $component.bitmapCache;
				_copyPixels($component,$bitmapData);
			}else if($component.hasOwnProperty("bitmap") && $component.bitmap){
				$bitmapData = $component.bitmap.bitmapData;
				_copyPixels($component,$bitmapData);
			}else if($component.graphic is Bitmap && $component.graphic.bitmapData){
				$bitmapData = $component.graphic.bitmapData;
				_copyPixels($component,$bitmapData);
			}else if($component.hasOwnProperty("bitmapData") && $component.bitmapData){
				$bitmapData = $component.bitmapData;
				_copyPixels($component,$bitmapData);
			}else if($component.graphic.width!=0 && $component.graphic.height!=0){
				trace("[WARNING] BitmapRenderComponent cannot display this component "+$component);
			}
		}
		//------ CopyPixels ------------------------------------
		private function _copyPixels($component:Component,$bitmapData:BitmapData):void {
			if(!_boost){
				for each( var filter:BitmapFilter in $component.graphic.filters){
					$bitmapData.applyFilter($bitmapData,$bitmapData.rect,new Point,filter);
				}
				if($component.graphic.transform.colorTransform!=StyleManager.BasicColorTransform){
					$bitmapData.colorTransform($bitmapData.rect,$component.graphic.transform.colorTransform);
				}else if($component.transform.colorTransform!=StyleManager.BasicColorTransform){
					$bitmapData.colorTransform($bitmapData.rect,$component.transform.colorTransform);
				}
			}
			_bitmapData.copyPixels($bitmapData, $bitmapData.rect,new Point($component.x,$component.y),null,null,true); //rect permits to draw only the parts of the graphic$component which are in the drawable area
		}
		//------ Update View ------------------------------------
		private function _updateView():void {
			if(!_scrollEnabled)	return;
			if(_mouseManager.drag)	return;
			if(_mouseManager.lastClickPosition && !_lastClick){
				_lastClick = _mouseManager.lastClickPosition;
				_mouseManager.switchHandCursor(MouseCursor.HAND);
			}else if(_lastClick && !_mouseManager.lastClickPosition){
				_lastClick = null;
				_position.x = _position.y = _position.z =0;
				_mouseManager.switchHandCursor(MouseCursor.ARROW);
			}
			if(_lastClick){
				var newScrollPosition:Point = new Point(_scrollPosition.x+_lastClick.x - mouseX,_scrollPosition.y+_lastClick.y - mouseY-_scrollPosition.z);
				if(newScrollPosition.x<0)	newScrollPosition.x=0;
				if(newScrollPosition.y<0)	newScrollPosition.y=0;
				if (_scrollArea && !_scrollArea.containsPoint(newScrollPosition)){
					return;
				}
				_position.x= _lastClick.x - mouseX;
				_position.y= _lastClick.y - mouseY;
				_scrollPosition.x+=_position.x;
				_scrollPosition.y+=_position.y;
				_lastClick.x = mouseX;
				_lastClick.y = mouseY;
			}
		}
		//------ Set Target ------------------------------------
		public function setTarget($target:DisplayObject):void {
			_scrollTarget = $target;
		}
		//------ Set Scroll Area ------------------------------------
		public function setScrollArea($scrollArea:Rectangle):void {
			_scrollArea = $scrollArea;
		}
		//------ Scroll View ------------------------------------
		private function _scrollView():void {
			if(_scrollTarget){
				if(_scrollTarget.x<10){
					_position.x=-10;
				}else if(_scrollTarget.x>Framework.width-100){
					_position.x=10;
				}else if (_position.x!=0){
					_position.x=0;
				}
				if(_scrollTarget.y<10){
					_position.y=-10;
				}else if(_scrollTarget.y>Framework.height-100){
					_position.y=10;
				}else if (_position.y!=0){
					_position.y=0;
				}
			}
		}
		//------ Sort Depths ------------------------------------
		private function sortDepths($component1:Component, $component2:Component):int{
			var layer1:int = SimpleGraphicComponent($component1).layer;
			var layer2:int = SimpleGraphicComponent($component2).layer;
			if (layer1>layer2 || $component1.hasOwnProperty("alwaysOnTop") && $component1.alwaysOnTop){
				return 1;
			}else if (layer1<layer2 || $component2.hasOwnProperty("alwaysOnTop") && $component2.alwaysOnTop){
				return -1;
			}
			var dimension1:IsoPoint= GraphicComponent($component1).getDimension();
			var dimension2:IsoPoint= GraphicComponent($component2).getDimension();
			var height1:Number = dimension1.y;
			var height2:Number = dimension2.y;
			var width1:Number = dimension1.x;
			var width2:Number = dimension2.x;
			
			if ($component1.y+height1-$component1.z < $component2.y+height2-$component2.z ) return -1;
			if ($component1.y+height1-$component1.z > $component2.y+height2-$component2.z) return 1;
			if ($component1.x+width1 < $component2.x+width2 ) return 1;
			if ($component1.x+width1 > $component2.x+width2) return -1;
			return 0;
		}
		//------ Remove Graphic ------------------------------------
		public function removeComponent($component:Component):void {
			
		}
		//------ Zoom In ------------------------------------
		public function zoomIn():void{
			_zoomPosition++;
			if(_zoomPosition>=_zoom.length){
				_zoomPosition = _zoom.length-1;
			}
		}
		//------ Zoom Out ------------------------------------
		public function zoomOut():void{
			_zoomPosition--;
			if(_zoomPosition<0){
				_zoomPosition = 0;
			}
		}
		//------ Getter ------------------------------------
		public function get scrollEnabled():Boolean{
			return _scrollEnabled;
		}
		public function set scrollEnabled($scrollEnabled:Boolean):void{
			_scrollEnabled = $scrollEnabled;
		}
		public function set boost($boost:Boolean):void{
			_boost = $boost;
		}
		public function set drawOnlyVisible($drawOnlyVisible:Boolean):void{
			_drawOnlyVisible=$drawOnlyVisible;
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			if(_timeline[$component])	delete _timeline[$component];
			super.removePropertyComponent($propertyName,$component);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			
		}
	}
}