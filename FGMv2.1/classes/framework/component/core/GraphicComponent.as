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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	import framework.system.IRessourceManager;
	import framework.system.RessourceManager;
	
	import utils.adobe.Export;
	import utils.iso.IsoPoint;
	import utils.text.StyleManager;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class GraphicComponent extends SimpleGraphicComponent {
		protected var _ressourceManager:IRessourceManager=null;
		protected var _graphicManager:IGraphicManager=null;
		protected var _path:String=null;
		protected var _loaderInfo:LoaderInfo = null;
		protected var _autoDisplay:Boolean = true;
		protected var _render:String = "render"; //"bitmapRender"
		protected var _z:Number =0;
		protected var _frame:Number =0;
		protected var _autoScroll:Boolean = true;
		protected var _isDisabled:Boolean = false;
		protected var _cacheAsBitmap:Boolean = true;
		protected var _bitmapCache:BitmapData = null;
		protected var _alwaysDisplay:Boolean = false
		protected var _alwaysOnTop:Boolean = false
		protected var _collision:Array = null;
		protected var _collisionParam:Object = null;
		protected var _activeCollision:Boolean = true;
		private var _point1:Point;//Used for Get Distance only
		private var _point2:Point;//Used for Get Distance only
		
		public function GraphicComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.componentParent){	
				_componentParent = $prop.componentParent;
				if(_componentParent.componentChildren.lastIndexOf(this)==-1){
					_componentParent.componentChildren.push(this);
					moveTo(_componentParent.graphic.x,_componentParent.graphic.y);
					if(_componentParent.mask)	mask = _componentParent.mask;
				}
			}
			if($prop && $prop.hasOwnProperty("autoDisplay")){
				_autoDisplay = $prop.autoDisplay;
			}
			if($prop && $prop.hasOwnProperty("render")){
				_render = $prop.render;
			}
			if($prop && $prop.hasOwnProperty("alwaysDisplay")){
				_alwaysDisplay = $prop.alwaysDisplay;
			}
			if($prop && $prop.hasOwnProperty("alwaysOnTop")){
				_alwaysOnTop = $prop.alwaysOnTop;
			}
			_collision = new Array;
			_collisionParam = new Object;
			_point1 = new Point;
			_point2 = new Point;
			_ressourceManager = RessourceManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			if(_autoDisplay  && _render =="render"){
				registerPropertyReference("render", {layer:_layer});
			}else if(_autoDisplay && _render =="bitmapRender"){
				registerPropertyReference("bitmapRender");
			}
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphic($path:String, $callback:Function =null):void {
			var callBack:Object = {onInit:onGraphicLoadingInit, onProgress:onGraphicLoadingProgress, onComplete:onGraphicLoadingComplete, onCompleteParams:$callback};
			_graphicManager.loadGraphic($path, callBack);
			_path = $path;
		}
		//------ On Graphic Loading Init ------------------------------------
		protected function onGraphicLoadingInit($evt:Event, $callback:Function =null):void {
			if($callback is Function)	$callback(this,$evt);
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected function onGraphicLoadingProgress($evt:ProgressEvent, $callback:Function =null):void {
			if($callback is Function)	$callback(this,$evt);
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function =null):void {
			_loaderInfo = $graphic.loaderInfo;
			_graphic = $graphic;
			Framework.AddChild($graphic,this);
			if(_propertyReferences["mouseInput"] && !$graphic.hasEventListener(MouseEvent.MOUSE_DOWN)){
				$graphic.addEventListener(MouseEvent.MOUSE_DOWN, dispatchToStage,false,0,true);
				$graphic.addEventListener(MouseEvent.MOUSE_UP, dispatchToStage,false,0,true);
				$graphic.addEventListener(MouseEvent.ROLL_OVER, dispatchToStage,false,0,true);
				$graphic.addEventListener(MouseEvent.ROLL_OUT, dispatchToStage,false,0,true);
			}
			if($callback is Function)	$callback(this);
		}
		//------ Dispatch Event to Stage ------------------------------------
		public function dispatchToStage($evt:MouseEvent):void {
			Framework.stage.dispatchEvent($evt);
		}
		//------ Create JPG ------------------------------------
		public function exportToJPG(fileName:String="image", quality:Number=90):void {
			Export.ExportJPG(this,fileName,quality);
		}
		//------ Get graphic ------------------------------------
		public function get graphic():* {
			return _graphic;
		}
		//------ Set graphic ------------------------------------
		public function set graphic($graphic:*):void {
			if(_render=="render" && _graphic && contains(_graphic)){
				Framework.RemoveChild(_graphic,this);
			}
			_graphic = $graphic;
			if(_render=="render"){
				Framework.AddChild(_graphic,this);
			}
		}
		//------ Get IsDisplayed ------------------------------------
		public function get isDisplayed():Boolean {
			return _isDisplayed;
		}
		//------ Set IsDisplayed ------------------------------------
		public function set isDisplayed($isDisplayed:Boolean):void {
			_isDisplayed = $isDisplayed;
		}
		//------ Set buttons ------------------------------------
		public function  setButton($button:InteractiveObject, $mouseEvent:Object, $newName:String=null):GraphicComponent {
			if(!_graphic.contains($button)){
				trace("[Warning] "+$button+" is not a children of "+ _componentName);
			}
			if(!$newName)	$newName = $button.name;
			var graphicComponent:GraphicComponent = _entity.entityManager.addComponentFromName(_entity.entityName,"GraphicComponent",$newName) as GraphicComponent;
			var position:Point =new Point($button.x,$button.y);
			position = $button.parent.localToGlobal(position);
			graphicComponent.graphic = $button;
			graphicComponent._componentParent = this;
			if(graphic is MovieClip){
				graphicComponent._frame = graphic.currentFrame;
			}
			if(_componentChildren.lastIndexOf(graphicComponent)==-1){
				_componentChildren.push(graphicComponent);
			}
			graphicComponent.moveTo(position.x,position.y);
			graphicComponent.graphic.x=graphicComponent.graphic.y=0;
			if(graphicComponent.graphic.hasOwnProperty("mouseChildren")){
				graphicComponent.graphic.mouseChildren = false;
			} 
			var mouseEvent:Object = new Object;
			if($mouseEvent.onMouseClick)	mouseEvent.onMouseClick		= $mouseEvent.onMouseClick;
			if($mouseEvent.onMouseUp)		mouseEvent.onMouseUp 		= $mouseEvent.onMouseUp;
			if($mouseEvent.onMouseDown)		mouseEvent.onMouseDown 		= $mouseEvent.onMouseDown;
			if($mouseEvent.onMouseRollOver)	mouseEvent.onMouseRollOver	= $mouseEvent.onMouseRollOver;
			if($mouseEvent.onMouseRollOut)	mouseEvent.onMouseRollOut 	= $mouseEvent.onMouseRollOut;
			graphicComponent.buttonMode = true;
			graphicComponent.useHandCursor = true;
			graphicComponent.registerPropertyReference("mouseInput",mouseEvent);
			return graphicComponent;
		}
		//------ Set buttons ------------------------------------
		public function  setButtons($buttons:Array, $mouseEvent:Object):void {
			for each (var button:InteractiveObject in $buttons){
				setButton(button,$mouseEvent);
			}
		}
		//------ Set button at Frame ------------------------------------
		public function  setButtonAtFrame($frame:Object,$buttonName:String, $mouseEvent:Object, $newName:String=null):void {
			var currentFrame:Number = _graphic.currentFrame;
			gotoAndStop($frame);
			try{
				var target:InteractiveObject = _graphic[$buttonName];
			}catch(e:Error){
				throw new Error("*Graphic Component: The object "+$buttonName+" is not a children of "+this);
			}
			setButton(target, $mouseEvent, $newName);
			gotoAndStop(currentFrame);
		}
		//------ Clone  ------------------------------------
		override public function clone():Component {
			var clone:GraphicComponent = _entity.entityManager.addComponentFromName(entityName,"GraphicComponent") as GraphicComponent;
			clone.loadGraphic(_path);
			return clone;
		}
		//------ Get LoaderInfo  ------------------------------------
		public function getLoaderInfo():LoaderInfo {
			if(_loaderInfo)
				return _loaderInfo;
			return null;
		}
		//------ Get LoaderInfo  ------------------------------------
		public function setLoaderInfo($loaderInfo:LoaderInfo):void {
			_loaderInfo = $loaderInfo;
		}
		//------ Move to  ------------------------------------
		public override function moveTo($x:Number, $y:Number, $z:Number=0):void {
			for each (var component:SimpleGraphicComponent in _componentChildren){
				if(component.parent != this){
					component.x+=$x-x;
					component.y+=$y-y;
					component.z+=$z-z;
				}
			}
			super.moveTo($x,$y,$z);
		}
		//------ Goto And Stop  ------------------------------------
		public function gotoAndStop($frame:Object, $scene:String = null):void {
			for each(var children:GraphicComponent in _componentChildren){
				if(children._frame == $frame && children.contains(children.graphic)){
					children.visible = true;
				}else if(children._frame != $frame && children.visible){
					children.visible = false;
				}
			}
			graphic.gotoAndStop($frame,$scene);
		}
		//------ Prev Frame  ------------------------------------
		public function prevFrame():void {
			for each(var children:GraphicComponent in _componentChildren){
				if(children._frame == children._frame-1 && children.contains(children.graphic)){
					children.visible = true;
				}else if(children._frame != children._frame-1 && children.visible){
					children.visible = false;
				}
			}
			graphic.prevFrame();
		}
		//------ Next Frame  ------------------------------------
		public function nextFrame():void {
			for each(var children:GraphicComponent in _componentChildren){
				if(children._frame == children._frame+1 && children.contains(children.graphic)){
					children.visible = true;
				}else if(children._frame != children._frame+1 && children.visible){
					children.visible = false;
				}
			}
			graphic.nextFrame();
		}
		//------ Destroy  ------------------------------------
		public override function destroy():void {
			if(parent){
				Framework.RemoveChild(_graphic,this);
			}
			for each (var child:GraphicComponent in _componentChildren){
				child.destroy();
			}
			_graphic = null;
			super.destroy();
		}
		//------- Get/Set z -------------------------------
		public override function get z():Number {
			return _z;
		}
		public override function set z($z:Number):void {
			_z=$z;
		}
		//------ Show  ------------------------------------
		public function show():void {
			visible = true
		}
		//------ Hide  ------------------------------------
		public function hide():void {
			visible = false
		}
		//------- Enable -------------------------------
		public  function enable():void {
			_isDisabled = false;
			filters=[];
		}
		//------- Disable -------------------------------
		public  function disable():void {
			_isDisabled = true;
			filters=StyleManager.UnsaturateFilter;
		}
		//------- Set Alpha -------------------------------
		public override function set visible($visible:Boolean):void {
			super.visible = $visible;
			for each (var child:GraphicComponent in _componentChildren){
				child.visible = $visible;
			}
		}
		//------- Set Alpha -------------------------------
		public override function set alpha($alpha:Number):void {
			super.alpha = $alpha;
			for each (var child:GraphicComponent in _componentChildren){
				child.alpha = $alpha;
			}
		}
		//------- Move To Front -------------------------------
		public  function moveToFront():void {
			if(parent){
				parent.setChildIndex(this,parent.numChildren-1);
			}
		}
		//------- Move To Back -------------------------------
		public  function moveToBack():void {
			if(parent){
				parent.setChildIndex(this,0);
			}
		}
		//------- Set as Mouse Target -------------------------------
		public  function setAsMouseTarget():void {
			_mouseManager.mouseTargets = [this].concat(componentChildren);
		}
		//------- Add to Mouse Target -------------------------------
		public  function addToMouseTarget($component:GraphicComponent=null):void {
			if(!_mouseManager.mouseTargets)	_mouseManager.mouseTargets = new Array;
			if(!$component)		$component=this;
			_mouseManager.mouseTargets.push($component);
		}
		//------- Clear Mouse Target -------------------------------
		public  function clearMouseTargets():void {
			_mouseManager.mouseTargets = null;
		}
		//------- Set as Mouse Target -------------------------------
		public  function setMouseExcludeTargets($targets:Array):void {
			_mouseManager.mouseExcludeTargets = $targets;
		}
		//------- Clear Mouse Target -------------------------------
		public  function clearMouseEcxcludeTargets():void {
			_mouseManager.mouseExcludeTargets = null;
		}
		//------- Get/Set autoScroll -------------------------------
		public function get autoScroll():Boolean {
			return _autoScroll;
		}
		public function set autoScroll($autoScroll:Boolean):void{
			_autoScroll = $autoScroll;
		}
		//------- Get/Set disabled -------------------------------
		public function get isDisabled():Boolean {
			return _isDisabled;
		}
		//------- Get Always Display -------------------------------
		public function get alwaysDisplay():Boolean {
			return _alwaysDisplay;
		}
		//------- Set Always Display -------------------------------
		public function set alwaysDisplay($alwaysDisplay:Boolean):void {
			_alwaysDisplay = $alwaysDisplay;
		}
		//------- Get Always On Top -------------------------------
		public function get alwaysOnTop():Boolean {
			return _alwaysOnTop;
		}
		//------ Get Dimension ------------------------------------
		public function getDimension():IsoPoint{
			if(width!=0 && height!=0){
				return new IsoPoint(width,height);
			}
			if(graphic){
				if(graphic.hasOwnProperty("high")){
					return  new IsoPoint(graphic.width,graphic.height,graphic.high);
				}
				return  new IsoPoint(graphic.width,graphic.height);
			}
			return null;
		}
		//------ Get Dimension ------------------------------------
		public override function getBounds($display:DisplayObject):Rectangle{
			if(!_graphic)	return null;
			return new Rectangle(x,y-z,_graphic.width,_graphic.height);
		}
		//------ Copy ------------------------------------
		public function getGraphicCopy():Sprite{
			var bounds:Rectangle =graphic.getBounds(graphic);
			try{
				var bitmapData:BitmapData =new BitmapData(bounds.width,bounds.height,true, 0);
				var matrix:Matrix = graphic.transform.matrix;
				matrix.translate(-bounds.x,-bounds.y);
				bitmapData.draw(graphic,matrix);
				var copy:Sprite = new Sprite;
				var bitmap:Bitmap = new Bitmap(bitmapData);
				bitmap.x=x;
				bitmap.y=y;
				copy.addChild(bitmap);
			}catch (e:Error){
				return null;
			}
			return copy;
		}
		//------- Get Active Collision -------------------------------
		public function get activeCollision():Boolean {
			return _activeCollision;
		}
		//------- Get Collision Param -------------------------------
		public function get collisionParam():Object {
			return _collisionParam;
		}
		//------- Get Collision Param -------------------------------
		public function set collisionParam($collisionParam:Object):void {
			_collisionParam=$collisionParam;
		}
		//------- Get Collision -------------------------------
		public function get collision():Array {
			return _collision;
		}
		//------- Set Collision -------------------------------
		public function set collision($collision:Array):void {
			_collision=$collision;
		}
		//------ Get Distance ------------------------------------
		public function getDistance($component1:GraphicComponent, $component2:GraphicComponent):Number {
			var bounds1:Rectangle = $component1.getBounds(null);
			var bounds2:Rectangle  = $component2.getBounds(null);
			_point1.x = bounds1.x+bounds1.width/2;
			_point1.y = bounds1.y+bounds1.height/2-$component1.z
			_point2.x = bounds2.x+bounds2.width/2;
			_point2.y = bounds2.y+bounds2.height/2-$component2.z;
			return Math.round(Point.distance(_point1,_point2));
		}
		//------ Get Distance ------------------------------------
		public function getVerticalDistance($component1:GraphicComponent, $component2:GraphicComponent):Number {
			var bounds1:Rectangle = $component1.getBounds(null);
			var bounds2:Rectangle  = $component2.getBounds(null);
			_point1.x = 0;
			_point1.y = bounds1.y+bounds1.height/2-$component1.z;
			_point2.x = 0;
			_point2.y = bounds2.y+bounds2.height/2-$component2.z;
			return Math.round(Point.distance(_point1,_point2));
		}
		//------ Get Horizontal Distance ------------------------------------
		public function getHorizontalDistance($component1:GraphicComponent, $component2:GraphicComponent):Number {
			var bounds1:Rectangle = $component1.getBounds(null);
			var bounds2:Rectangle  = $component2.getBounds(null);
			_point1.x = bounds1.x+bounds1.width/2;
			_point1.y = 0;
			_point2.x = bounds2.x+bounds2.width/2;
			_point2.y = 0;
			return Math.round(Point.distance(_point1,_point2));
		}
		//------- Cache as Bitmap -------------------------------
		public override function get cacheAsBitmap():Boolean{
			return _cacheAsBitmap;
		}
		//------- Cache as Bitmap -------------------------------
		public override function set cacheAsBitmap($cacheAsBitmap:Boolean):void{
			_cacheAsBitmap = $cacheAsBitmap;
		}
		//------- Bitmap Cache -------------------------------
		public function get bitmapCache():BitmapData{
			return _bitmapCache;
		}
		//------- Bitmap Cache -------------------------------
		public function set bitmapCache($bitmapCache:BitmapData):void{
			_bitmapCache=$bitmapCache;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
		}
	}
}