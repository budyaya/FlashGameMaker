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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.entity.IEntity;
	import framework.system.MouseManager;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.bitmap.SwfSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.physic.SpatialMove;
	import utils.text.StyleManager;
	import utils.transform.BasicTransform;
	
	/**
	* PlayerComponent Class
	*/
	public class PlayerComponent extends AnimationComponent {

		protected var _spatialMove:SpatialMove	=new SpatialMove;
		protected var _keyPad:KeyPad=null;		//KeyboardInput property
		protected var _mousePad:MousePad=null;	//MouseInput property
		protected var _direction:String= null;
		protected var _callback:Object = null;
		//AiInput properties
		//ServerInput properties
		//Player properties
		
		public function PlayerComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_keyPad = new KeyPad;
			if($prop && $prop.spatialMove)		_spatialMove = $prop.spatialMove;
			_callback = new Object;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("player");
//			registerPropertyReference("keyboardInput",{onKeyFire:onKeyFire});
//			registerPropertyReference("keyboardMove");
			registerPropertyReference("spatialMove");
//			registerPropertyReference("mouseInput",{capture:true, onMouseDown:onMouseDown, onMouseRollOver:onMouseRollOver, onMouseRollOut:onMouseRollOut});
			registerPropertyReference("mouseMove");
//			registerPropertyReference("aiInput");
//			registerPropertyReference("serverInput");
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function=null):void {
			super.onGraphicLoadingComplete($graphic,$callback);
		}
		//------ On Key Fire ------------------------------------
		protected function onKeyFire($keyPad:KeyPad):void {
			_keyPad = $keyPad;
			actualize("keyboardMove");
			actualize("spatialMove");
		}
		//------ On Mouse Down ------------------------------------
		public override function onMouseUp($mousePad:MousePad):void {
			_mousePad = $mousePad;
			actualize("mouseMove");
			var graph:BitmapGraph = _bitmapSet.graph;
			var anim:String = getAnim();
			graph.anim(anim);
			actualize("bitmapAnim");
		}
		//------- On Anim -------------------------------
		public  override function onAnim():void {
		}
		//------ On Mouse Roll Over ------------------------------------
		public override function onMouseRollOver($mousePad:MousePad):void {
		}
		//------ On Mouse Roll Out ------------------------------------
		public override function onMouseRollOut($mousePad:MousePad):void {
		}
		//------ Get Anim ------------------------------------
		public function getAnim():String {
			var anim:String;
			var bounds:Rectangle = _graphic.getBounds(_graphic);
			var mx:Number = mouseX + _mousePad.offset.x;
			var my:Number = mouseY + _mousePad.offset.y;
			var offsetY:Number = 10;
			if(my<bounds.height/3-offsetY){
				if(Math.abs(mx)<bounds.width/2){
					_direction = "UP"
				}else if(mx<0){
					_direction = "LEFT_UP"
				}else if(mx>0){
					_direction = "RIGHT_UP"
				}
			}else if(my<2*bounds.height/3-offsetY){
				if(mx<0){
					_direction = "LEFT"
				}else if(mx>0){
					_direction = "RIGHT"
				}
			}else{
				if(Math.abs(mx)<bounds.width/2){
					_direction = "DOWN"
				}else if(mx<0){
					_direction = "LEFT_DOWN"
				}else if(mx>0){
					_direction = "RIGHT_DOWN"
				}
			}
			var destination:Point = new Point(_mousePad.mouseEvent.stageX-graphic.width/2,_mousePad.mouseEvent.stageY-graphic.height/2);
			var distance:Number = Math.round(Point.distance(new Point(x,y),destination));
			if(distance>100){
				anim = "RUN_"+_direction;
			}else{
				anim = "WALK_"+_direction;
			}
			return anim;
		}
		//------ On Mouse Stop Moving ------------------------------------
		public function onMouseStopMoving():void {
			var graph:BitmapGraph = _bitmapSet.graph;
			graph.anim("STAND_"+_direction)
			actualize("bitmapAnim");
			var callback:Function = _callback.onMouseStopMoving as Function;
			if(callback!=null)	callback();
		}
		//------ On Mouse Stop Moving ------------------------------------
		public function anim($anim:String):void {
			var graph:BitmapGraph = _bitmapSet.graph;
			graph.anim($anim)
			actualize("bitmapAnim");
		}
		//------ Get KeyPad ------------------------------------
		public function get keyPad():Object {
			return _keyPad;
		}
		//------ Get MousePad ------------------------------------
		public function get mousePad():MousePad {
			return _mousePad;
		}
		//------- Get Spatial Move -------------------------------
		public function get spatialMove():SpatialMove {
			return _spatialMove;
		}
		//------- Get callback -------------------------------
		public function get callback():Object {
			return _callback;
		}
		//------- Set callback -------------------------------
		public function set callback($callback:Object):void {
			_callback = $callback;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}