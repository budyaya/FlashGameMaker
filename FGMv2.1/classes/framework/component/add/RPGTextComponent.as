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

package framework.component.add{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.component.core.GraphicComponent;
	import framework.entity.*;
	
	import utils.mouse.MousePad;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class RPGTextComponent extends GraphicComponent {

		private var _sequences:Array=null;
		private var _position:int=0;
		private var _textBlockIndex:Number=0;
		
		private var _titleTF:TextField;
		private var _contentTF:TextField;
		private var _icon:MovieClip;
		private var _prevBt:SimpleButton;
		private var _nextBt:SimpleButton;

		public function RPGTextComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("rpgText");
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function =null):void {
			_graphic = $graphic;
			var rpgText:MovieClip = $graphic as MovieClip;
			_titleTF = rpgText.titleTF as TextField;
			_contentTF = rpgText.contentTF as TextField;
			_icon = rpgText.icon as MovieClip;
			_prevBt = rpgText.prevBt as SimpleButton;
			_nextBt  = rpgText.nextBt as SimpleButton;
			super.onGraphicLoadingComplete($graphic,$callback);
			setButton(rpgText.nextBt, {onMouseClick:onNextClick});
			setButton(rpgText.prevBt, {onMouseClick:onPrevClick});
		}
		//------Set Text -------------------------------------
		public function setSequences($sequences:Array):void {
		    //Ex: var sequences:Array = [{title:"Title1", content:"Content1", icon:null, delay:5000},{title:"Title2", content:"Content2", icon:null, delay:5000}];
			_sequences=$sequences;
			updateText();
		}
		//------ UpdateText ------------------------------------
		private function updateText():void {
			var sequence:Object = _sequences[_position];
			_titleTF.text = sequence.title;
			_contentTF.text = String(sequence.content).charAt(0);
			//_icon = sequence.icon;
			addEventListener(Event.ENTER_FRAME,typeWritter,false,0,true);// start updating the text  
		}
		//------ Type Writter ------------------------------------
		private function typeWritter(e:Event):void {
			var sequence:Object = _sequences[_position];
			var content:String=sequence.content;
			if (_contentTF.text.length<content.length) {
				_contentTF.text=content.substr(0,_contentTF.length+1);
			} else {
				removeEventListener(Event.ENTER_FRAME,typeWritter);
			}
		}
		//------ On Next Click ------------------------------------
		private function onNextClick($mousePad:MousePad):void {
			var sequence:Object = _sequences[_position];
			var content:String=sequence.content;
			if (_contentTF.text.length<content.length) {
				_contentTF.text=sequence.content;
			} else {
				_position++;
				if (_position>=_sequences.length) {
					_position=_sequences.length-1;
					return;
				}
				updateText();
			}
		}
		//------ On Prev Click ------------------------------------
		private function onPrevClick($mousePad:MousePad):void {
			if (_position>0) {
				_position--;
				updateText();
			}
		}
		//------ On Prev Click ------------------------------------
		public override function set graphic($graphic:*):void{
			onGraphicLoadingComplete($graphic);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("* RPGTextComponent");
		}
	}
}