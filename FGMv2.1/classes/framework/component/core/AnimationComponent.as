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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.IEntity;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.bitmap.SwfSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.text.StyleManager;
	
	/**
	* AnimationComponent Class
	*/
	public class AnimationComponent extends GraphicComponent {

		protected var _bitmapSet:* = null			// BitmapAnim property can be BitmapSet or extended to  SwfSet
		protected var _clonePool:Array = null;
		protected var _bounds:Rectangle = null;		// width and height
		protected var _isDrag:Boolean = false;
		protected var _autoAnim:Boolean = true;
		protected var _sequence:Boolean = true;		// Define how the animation is created from a timelined anim or clip
		
		public function AnimationComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_render= "bitmapRender";
			if ($prop && $prop.bounds)							_bounds = $prop.bounds;
			if ($prop && $prop.hasOwnProperty("sequence"))		_sequence = $prop.sequence;
			_graphic = new Bitmap;
			_clonePool = new Array;
		}
		//------ Load Graphic  ------------------------------------
		override public function loadGraphic($path:String, $callback:Function =null):void {
			if(_path){
				throw new Error("A graphic has already been loaded !!");
			}
			super.loadGraphic($path, $callback);
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function =null):void {
			initAnimComponent(this, $graphic);
			cloneFlush();
			if($callback is Function)	$callback(this);
		}
		//------ Init Anim Component  ------------------------------------
		protected function initAnimComponent($animComponent:AnimationComponent, $graphic:*):AnimationComponent {
			$animComponent.setLoaderInfo($graphic.loaderInfo);
			if($graphic is Bitmap){
				$animComponent.bitmapSet = createBitmap($graphic as Bitmap);
			}else if($graphic is MovieClip){
				$animComponent.bitmapSet = createSwf($graphic as MovieClip,true);
			}
			
			$animComponent.registerPropertyReference("bitmapAnim",{callback:$animComponent.onAnim});
			return $animComponent;
		}
		//------ Create Player ------------------------------------
		public function createBitmap($graphic:Bitmap):BitmapSet {
			var bitmapSet:BitmapSet = new BitmapSet($graphic,null);
			bitmapSet.graph.createSimpleGraph();
			return bitmapSet;
		}
		//------ Create Swf  ------------------------------------
		public function createSwf($graphic:MovieClip, $bitmapMode:Boolean=false, $sequence:Boolean = true):BitmapSet {
			var frameRate:int = Framework.stage.frameRate;
			var swfSet:SwfSet = new SwfSet($graphic,null);
			_sequence = $sequence;
			if(_bounds)	swfSet.bounds = _bounds;
			if($bitmapMode && _bitmapSet){// Only if this is clone
				swfSet = SwfSet(_bitmapSet).clone();	
			}else if(_sequence){
				swfSet.createSwfFrom("AssetDisplay",$bitmapMode,frameRate);
			}else{
				swfSet.createSwfFrom(null,$bitmapMode,frameRate, false);
			}
//			swfSet.graph.createSimpleSequence();
			return swfSet;
		}
		//------ Get BitmapSet ------------------------------------
		public function get bitmapSet():BitmapSet {
			return _bitmapSet;
		}
		//------ Set BitmapSet ------------------------------------
		public function set bitmapSet($bitmapSet:BitmapSet):void {
			 _bitmapSet = $bitmapSet;
		}
		//------- On Anim -------------------------------
		public  function onAnim():void {
		}
		//------ On Mouse Down  ------------------------------------
		public function onMouseDown($mousePad:MousePad):void {
			if(_mouseManager.isClicked(this)){
				this.startDrag();
				_mouseManager.drag = this;
			}
		}
		//------ On Mouse UP  ------------------------------------
		public function onMouseUp($mousePad:MousePad):void {
			if(_mouseManager.isDrag(this)){
				this.stopDrag();
				_mouseManager.drag = null;
			}
		}
		//------ On Mouse Roll Over  ------------------------------------
		public function onMouseRollOver($mousePad:MousePad):void {
			_graphic.filters = StyleManager.RedHalo;
		}
		//------ On Mouse Roll Out  ------------------------------------
		public function onMouseRollOut($mousePad:MousePad):void {
			_graphic.filters =[];
		}
		//------ Clone  ------------------------------------
		override public function clone():Component {
			var clone:AnimationComponent = _entity.entityManager.addComponentFromName(entityName,"AnimationComponent") as AnimationComponent;
			if(_graphic && bitmapSet && bitmapSet.bitmap){				// Bitmap
				initAnimComponent(clone, bitmapSet.bitmap);
			}else if(_graphic && bitmapSet && SwfSet(bitmapSet).swf){	// MovieClip
				initAnimComponent(clone, SwfSet(bitmapSet).swf);
			}else{
				_clonePool.push(clone);
			}
			return clone;
		}
		//------ Clone Flush  ------------------------------------
		//Used if the graphic has not been fully loaded
		private function cloneFlush():void {
			for each(var clone:AnimationComponent in _clonePool){
				if(_graphic && bitmapSet && bitmapSet.bitmap){				// Bitmap
					initAnimComponent(clone, bitmapSet.bitmap);
				}else if(_graphic && bitmapSet && SwfSet(bitmapSet).swf){	// MovieClip
					initAnimComponent(clone, SwfSet(bitmapSet).swf);
				}
			}
		}
		//------ Set graphic ------------------------------------
		public override function set graphic($graphic:*):void {
			if(!_bitmapSet){
				initAnimComponent(this, $graphic);
				cloneFlush();
			}else{
				_graphic = $graphic;
			}
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
		//------- Get AutoAnim -------------------------------
		public function get currentPoseName():String {
			return bitmapSet.currentPoseName;
		}
		//------- Get CurrentFrame -------------------------------
		public function get currentFrame():int {
			return bitmapSet.currentPosition;
		}
		//------- Get LastFrame -------------------------------
		public function get lastFrame():int {
			return bitmapSet.lastPosition;
		}
		//------- Get bitmapData -------------------------------
		public function get bitmapData():BitmapData {
			if(bitmapSet && _graphic && _graphic.bitmapData){
				return _graphic.bitmapData;
			}else if(bitmapSet && bitmapSet is SwfSet && SwfSet(bitmapSet).swf && bitmapSet.position.bitmapData){
				return bitmapSet.position.bitmapData;
			}
			return null;
		}
		//------- Get Width -------------------------------
		public override function get width():Number {
			if(_graphic)	return _graphic.width;
			return super.width;
		}
		//------- Get Width -------------------------------
		public override function get height():Number {
			if(_graphic)	return _graphic.height;
			return 0;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}