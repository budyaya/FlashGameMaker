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

package framework.component.core {
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.IMouseManager;
	import framework.system.MouseManager;

	/**
	* SimpleGraphicComponent is the basic class for a graphical component
	*/
	public class SimpleGraphicComponent extends Component{
		protected var _mouseManager:IMouseManager= null;
		protected var _componentParent:GraphicComponent =null;
		protected var _componentChildren:Array =null;
		protected var _graphic:*=null;
		protected var _isDisplayed:Boolean = false;
		protected var _layer:int = 0;
		//Background properties
		private var _color:uint = 0xFFFFFF;
		private var _alpha:Number = 1; // Value between 0 and 1
		private var _type:String = null; //GradientType.LINEAR or GradientType.RADIAL
		private var _colors:Array = null;
		private var _alphas:Array = null;
		private var _ratios:Array = null;
		private var _matrix:Matrix = null;
		private var _rectangle:Rectangle = null; //Background position and size
		//Button properties
		private var _buttonMode:Boolean = false;
		private var _mouseEnabled:Boolean = false;
		private var _mouseChildren:Boolean = false;
		private var _useHandCursor:Boolean = false;
		
		public function SimpleGraphicComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false , $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
			_mouseManager = MouseManager.getInstance();
			_graphic = new Sprite;
			_componentChildren = new Array;
			Framework.AddChild(_graphic,this);
			if ($prop != null) {
				if($prop.hasOwnProperty("layer"))		_layer=$prop.layer;
				setBgColor($prop);
			}
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("render", {layer:_layer});
		}
		//------ Move to  ------------------------------------
		public function moveTo($x:Number, $y:Number, $z:Number=0):void {
			x = $x;
			y = $y;
			z = $z;
		}
		//------ Scale to  ------------------------------------
		public function scaleTo($scaleX:Number, $scaleY:Number):void {
			scaleX = $scaleX;
			scaleY = $scaleY;
		}
		//------- Set Color -------------------------------
		public  function setBgColor($prop:Object):void {	
			if ($prop.color )		_color = $prop.color;
			if ($prop.alpha)		_alpha = $prop.alpha;				
			if ($prop.type)			_type = $prop.type;
			if ($prop.colors)		_colors = $prop.colors;
			if ($prop.alphas)		_alphas = $prop.alphas;
			if ($prop.ratios) 		_ratios = $prop.ratios;
			if ($prop.matrix)		_matrix = $prop.matrix;
			if ($prop.rectangle)	_rectangle = $prop.rectangle;
			
			if (_type) {
				_graphic.graphics.beginGradientFill(_type, _colors, _alphas, _ratios, _matrix);
			}else{
				_graphic.graphics.beginFill(_color, _alpha);
			}
			if(_rectangle){	
				//if a Rectangle is provided for x, y, width and height of background
				_graphic.graphics.drawRect(_rectangle.x, _rectangle.y, _rectangle.width, _rectangle.height);
			}
			else if(width == 0 || height == 0){
				//if the Sprite is empty then the bg is of same size as the Stage
				_graphic.graphics.drawRect(0, 0, Framework.width, Framework.height);
			}else{
				_graphic.graphics.drawRect(0, 0, width, height);
			}
			_graphic.graphics.endFill();	
		}
		//------- Set Button Mode -------------------------------
		public  function setButtonMode($prop:Object):void {
			if ($prop.buttonMode)		_buttonMode 	= $prop.buttonMode;
			if ($prop.mouseEnabled)		_mouseEnabled 	= $prop.mouseEnabled;
			if ($prop.mouseChildren)	_mouseChildren 	= $prop.mouseChildren;
			if ($prop.useHandCursor)	_useHandCursor 	= $prop.useHandCursor;
			buttonMode 		= 	_buttonMode;		
			mouseEnabled 	= 	_mouseEnabled;
			mouseChildren	=	_mouseChildren;
			useHandCursor 	= 	_useHandCursor
		}
		//------ Get Component Parent  ------------------------------------
		public function get componentParent():GraphicComponent {
			return _componentParent;
		}
		//------ Get Component Children  ------------------------------------
		public function get componentChildren():Array {
			return _componentChildren;
		}
		//------- Get/Set autoScroll -------------------------------
		public function get layer():int {
			return _layer;
		}
		public function set layer($layer:int):void{
			_layer = $layer;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("* SimpleGraphicComponent", componentName, entityName);
		}
	}
}