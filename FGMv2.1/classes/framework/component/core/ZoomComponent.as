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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.transform.BasicTransform;
	import utils.mouse.MousePad;
	import utils.ui.LayoutUtil;
	import framework.component.Component;

	/**
	* Zoom Component: Manage the ZoomIn ZoomOut FullScreen
	*/
	public class ZoomComponent extends Component {

		protected var _mouseManager:IMouseManager = null;
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		private var _zoomIn:GraphicComponent = null;
		private var _zoomOut:GraphicComponent = null;
		private var _fullScreen:GraphicComponent = null;
		private var _scrollTarget:DisplayObject=null;
		private var _allowFullScreen:Boolean = false;
		
		public function ZoomComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_mouseManager = MouseManager.getInstance();
			_timeline = new Dictionary(true);
			_initZoom();
		}
		//------ Init Var ------------------------------------
		private function _initZoom():void {
			_zoomIn =_entity.entityManager.addComponentFromName(_entity.entityName,"GraphicComponent","ZoomIn") as GraphicComponent;
			_zoomIn.graphic = new SharedElement_ZoomIn();
			LayoutUtil.Align(_zoomIn,LayoutUtil.ALIGN_TOP_RIGHT, null,null,new Point(-50,0));
			
			_zoomOut =_entity.entityManager.addComponentFromName(_entity.entityName,"GraphicComponent","ZoomOut") as GraphicComponent;
			_zoomOut.graphic = new SharedElement_ZoomOut();
			LayoutUtil.Align(_zoomOut,LayoutUtil.ALIGN_TOP_RIGHT, null,null,new Point(0,0));
			
			if(_allowFullScreen){
				_fullScreen =_entity.entityManager.addComponentFromName(_entity.entityName,"GraphicComponent","FullScreen") as GraphicComponent;
				_fullScreen.graphic = new SharedElement_FullScreen();
				BasicTransform.ScaleInPosition(_fullScreen, 0.5,  0.5);
				LayoutUtil.Align(_fullScreen,LayoutUtil.ALIGN_TOP_RIGHT, null,null,new Point(-2,60));
			}
			
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("zoom");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "zoom") {
				if($param && $param.hasOwnProperty("zoomIn") && $param.hasOwnProperty("zoomOut")) {
					updateComponent($component, $param);
				}else if($component.hasOwnProperty("zoomIn") && $component.hasOwnProperty("zoomOut")) {
					if(!$param)		$param = new Object;
					$param.zoomIn = $component.zoomIn;
					$param.zoomOut = $component.zoomOut;
					updateComponent($component, $param);
				}else{
					throw new Error("A ZoomIn  and ZoomOut function must exist to be registered by ZoomComponent");
				}
			}
		}
		//------ Update Component ------------------------------------
		public function updateComponent($component:Component, $param:Object = null):void {
			if(!_isRunning){
				_isRunning = true;
				_zoomIn.registerPropertyReference("mouseInput",{onMouseDown:onZoomInMouseDown,onMouseRollOver:onMouseRollOver,onMouseRollOut:onMouseRollOut});
				_zoomOut.registerPropertyReference("mouseInput",{onMouseDown:onZoomOutMouseDown,onMouseRollOver:onMouseRollOver,onMouseRollOut:onMouseRollOut});
				if(_allowFullScreen){
					_fullScreen.registerPropertyReference("mouseInput",{onMouseDown:onFullScreenMouseDown,onMouseRollOver:onMouseRollOver,onMouseRollOut:onMouseRollOut});
				}
			}
			if(!_timeline[$component]){
				_timeline[$component] = {component:$component, param:$param};
				
			}
		}
		//------ on Mouse RollOver ------------------------------------
		public function onMouseRollOver($mousePad:MousePad):void{
			var target:DisplayObject = $mousePad.mouseEvent.target.parent as GraphicComponent;
			if(target){
				if(_zoomIn.scaleX!=1 || _zoomIn.scaleY!=1){
					BasicTransform.ScaleInPosition(_zoomIn, 1, 1);
				}else if(_zoomOut.scaleX!=1 || _zoomOut.scaleY!=1){
					BasicTransform.ScaleInPosition(_zoomOut, 1, 1);
				}
				BasicTransform.ScaleInPosition(target, 1.2, 1.2);
			}
		}
		//------ on Mouse RollOut ------------------------------------
		public function onMouseRollOut($mousePad:MousePad):void{
			var target:DisplayObject = $mousePad.mouseEvent.target.parent as GraphicComponent;
			if(target){
				BasicTransform.ScaleInPosition(target, 1, 1);
			}
		}
		//------ onZoomInMouseDown ------------------------------------
		public function onZoomInMouseDown($mousePad:MousePad):void{
			if (_mouseManager.isClicked(_zoomIn) ) {
				for each(var object:Object in _timeline){
					object.param.zoomIn();
				}
			}
		}
		//------ onZoomOutMouseDown ------------------------------------
		public function onZoomOutMouseDown($mousePad:MousePad):void{
			if (_mouseManager.isClicked(_zoomOut) ) {
				for each(var object:Object in _timeline){
					object.param.zoomOut();
				}
			}
		}
		//------ onZoomOutMouseDown ------------------------------------
		private function onFullScreenMouseDown($mousePad:MousePad):void{
			if (_mouseManager.isClicked(_fullScreen) ) {
				for each(var object:Object in _timeline){
					if(object.param.hasOwnProperty("fullScreen")){
						object.param.fullScreen();
					}
				}
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}