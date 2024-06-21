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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.bitmap.BitmapCell;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.bitmap.SwfSet;
	import utils.convert.BoolTo;
	import utils.keyboard.KeyPad;
	import utils.transform.BitmapDataTransform;
	
	/**
	* BitmapAnimComponent Class
	*/
	public class BitmapAnimComponent extends Component {
		
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		private var _cacheList:Dictionary = null
		
		public function BitmapAnimComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function _initVar($prop:Object):void {
			_timeline = new Dictionary(true);
			_cacheList = new Dictionary(true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("bitmapAnim");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "bitmapAnim") {
				updateComponent($component, $param);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component, $param:Object = null):void {
			//Check properties
			if($component.hasOwnProperty("graphic") && $component.graphic is Bitmap) {
				if($component.hasOwnProperty("autoAnim") && $component.autoAnim && !_timeline[$component]){
					_timeline[$component] = {component:$component, param:$param};
					if(!_isRunning){
						_isRunning = true;
						registerPropertyReference("enterFrame", {onEnterFrame:onTick});
					}
				}
				updateFrame($component);
			}else{
				throw new Error("A bitmapSet and graphic must exist to be registered by BitmapAnimComponent");
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			for each(var component:Object in _timeline){
				if(component.component.hasOwnProperty("isDisplayed") && !component.component.isDisplayed ||!component.component.bitmapSet || !component.component.autoAnim){
					continue;
				}
				updateAnim(component.component);
				updateFrame(component.component, component.param);
			}
		}
		//------ Update Anim------------------------------------
		protected function updateAnim($component:Component):void {
			var bitmapSet:BitmapSet = $component.bitmapSet;
			var graph:BitmapGraph = bitmapSet.graph;
			graph.anim();
		}
		//------ Update Component------------------------------------
		private function updateFrame($component:Component, $param:Object = null):void {
			if(!$component.bitmapSet || !$component.bitmapSet.position || !$component.graphic)	return;
			var bitmapSet:BitmapSet = $component.bitmapSet;
			var position:BitmapCell = bitmapSet.position;
			var bitmapCache:Object={bitmap:bitmapSet.bitmap,rect:new Rectangle(position.x, position.y,position.width,position.height)}
			if($component.cacheAsBitmap && _cacheList[bitmapCache]){
					$component.bitmapCache = _cacheList[bitmapCache];
			}else if(bitmapSet.bitmap){
				if(!position.offsetX)	position.offsetX=0;
				if(!position.offsetY)	position.offsetY=0;
				var source:Bitmap = bitmapSet.bitmap;
				var myBitmapData:BitmapData=new BitmapData(position.width,position.height,true,0);
				myBitmapData.lock();
				myBitmapData.copyPixels(source.bitmapData, new Rectangle(position.x, position.y,position.width,position.height), new Point(position.offsetX,position.offsetY),null,null,true);
				myBitmapData.unlock();
				if(bitmapSet.flip){
					BitmapDataTransform.FlipBitmapData(myBitmapData);
				}
				var previousBitmapData:BitmapData =Bitmap($component.graphic).bitmapData;
				if(!previousBitmapData || previousBitmapData.width!=myBitmapData.width || previousBitmapData.height!=myBitmapData.height){
					if(previousBitmapData){
						previousBitmapData.dispose();
						previousBitmapData = null;
					}
					$component.graphic = new Bitmap(myBitmapData);
				}else{
					previousBitmapData.lock();
					previousBitmapData.fillRect(previousBitmapData.rect, 0);
					previousBitmapData.copyPixels(myBitmapData,myBitmapData.rect, new Point(0,0),null,null,true);
					previousBitmapData.unlock();
					myBitmapData.dispose();
					myBitmapData = null;
				}
			}else if(SwfSet(bitmapSet).swf && position.bitmapData){ //BitmapMode
				if(bitmapSet.flip && !position.flip){
					position.flip=true;
					BitmapDataTransform.FlipBitmapData(position.bitmapData);
				}else if(!bitmapSet.flip && position.flip){
					position.flip=false;
					BitmapDataTransform.FlipBitmapData(position.bitmapData);
				}
				$component.graphic.bitmapData=position.bitmapData;
			}else if(SwfSet(bitmapSet).swf){
				$component.graphic.bitmapData=SwfSet(bitmapSet).screenFrame(null);
			}
			if($component.cacheAsBitmap && !_cacheList[bitmapCache]){
				_cacheList[bitmapCache] = $component.graphic.bitmapData;
			}
			callback($component, $param);
		}
		//------ Callback------------------------------------
		private function callback($component:Component, $param:Object = null):void {
			var bitmapSet:BitmapSet = $component.bitmapSet;
			if(bitmapSet.currentPosition==bitmapSet.lastPosition){
				if($param && $param.hasOwnProperty("onAnimEnd") && $param.onAnimEnd){
					$param.onAnimEnd();
				}else if($component.hasOwnProperty("onAnimEnd") && $component.onAnimEnd){
					$component.onAnim();
				}
			}else{
				if($param && $param.hasOwnProperty("onAnim") && $param.onAnim){
					$param.onAnim();
				}else if($component.hasOwnProperty("onAnim") && $component.onAnim){
					$component.onAnim();
				}
			}
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			if(_timeline[$component])	delete _timeline[$component];
			super.removePropertyComponent($propertyName,$component);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}