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
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;
	
	import utils.mouse.MousePad;

	/**
	* Renderer Component: Manage the graphical rendering and layout of an Entity's graphical components
	*/
	public class RenderComponent extends Component {

		protected var _mouseManager:IMouseManager = null;
		private var _layers:Array;
		private var _defaultLayer:int = 0;
		private var _defaultAlign:String = "left";
		private var _zoom:Array;
		private var _zoomPosition:int = 1;
		private var _scrollTarget:DisplayObject=null;
		
		public function RenderComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_mouseManager = MouseManager.getInstance();
			_layers = new Array();
			_zoom = [0.5,1,1.5];
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("render");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $prop:Object = null):void {
			if ($propertyName == "render") {
				displayComponent($component, $prop);
			}
		}
		//------ Display Component ------------------------------------
		public function displayComponent($component:Component, $prop:Object = null):void {
			if($component.hasOwnProperty("isDisplayed")){
				$component.isDisplayed = true;
			}
			if($component.componentParent){
				Framework.AddChild($component,$component.componentParent.graphic);
			}else{
				var layer:int = _defaultLayer;
				if($prop && $prop.hasOwnProperty("layer")){
					layer = $prop.layer;
				}	
				if (layer>=_layers.length) {
					layer = createNewLayer();
				}
				$component.layer = layer;
				_layers[layer].layer.addChild($component);
				_layers[layer].components.push($component);
			}
		}
		//------ Create New Layer ------------------------------------
		public function createNewLayer():int {
			var layer:Sprite = new Sprite();
			Framework.AddChild(layer);
			var components:Vector.<Component> = new Vector.<Component>;
			_layers.push({layer:layer, components:components});
			return _layers.length-1;
		}
		//------ Remove Graphic ------------------------------------
		public function removeComponent($component:Component):void {
			if($component.hasOwnProperty("isDisplayed")){
				$component.isDisplayed = false;
			}
		}
		//------ Remove Layer ------------------------------------
		public function removeLayer($layer:int):void {
			if ($layer>=_layers.length) {
				throw new Error("The index "+$layer+" is out of bond!!");
			}
			var layer:Sprite=_layers[$layer];
			Framework.RemoveChild(layer);
			_layers.splice($layer,1);
		}
		//------ onZoomInMouseDown ------------------------------------
		public function zoomIn():void{
			_zoomPosition++;
			if(_zoomPosition>=_zoom.length){
				_zoomPosition = _zoom.length-1;
			}
		}
		//------ onZoomOutMouseDown ------------------------------------
		public function zoomOut():void{
			_zoomPosition--;
			if(_zoomPosition<0){
				_zoomPosition = 0;
			}
		}
		//------ onZoomOutMouseDown ------------------------------------
		public function goFullScreen():void{
			
		}
		//------- Remove Property Component -------------------------------
		public override function removePropertyComponent($propertyName:String, $component:Component):void {
			if($component.componentParent){
				Framework.RemoveChild($component,$component.componentParent.graphic);
			}else{
				var layer:int = SimpleGraphicComponent($component).layer;
				var index:int = _layers[index].components.indexOf($component);
				if(_layers[layer].layer.contains($component))
					_layers[layer].layer.removeChild($component);
				if(index!=-1)
					_layers[layer].components.splice(index,1);
			}
			super.removePropertyComponent($propertyName,$component);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}