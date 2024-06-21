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
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.entity.*;
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TextComponent extends SimpleGraphicComponent {

		protected var _textField:TextField=null;
		protected var _textFormat:TextFormat=null;
		
		public function TextComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop)
		}
		//------ Init Var ------------------------------------
		private  function _initVar($prop:Object):void {
			_textField = new TextField();
			_textField.text="TextComponent";
			_textFormat = new TextFormat();
			_textField.defaultTextFormat=_textFormat;
			addChild(_textField);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------Set Text -------------------------------------
		public function setText($text:String,$autoSize:String=TextFieldAutoSize.LEFT, $width:Number =100 , $height:Number=50 , $selectable:Boolean=false, $rotation:Number=0, $background:Boolean=false, $backgroundColor:uint=0, $border:Boolean=false, $displayAsPassword:Boolean=false , $multiline:Boolean= true, $maxChars:int =0 ):void {
			_textField.text				=$text;
			_textField.autoSize			=$autoSize;
			_textField.width			=$width;
			_textField.height			=$height;
			_textField.selectable		=$selectable;
			_textField.rotation			=$rotation;
			_textField.background		=$background;
			_textField.backgroundColor	=$backgroundColor;
			_textField.border			=$border;
			_textField.displayAsPassword=$displayAsPassword;
			_textField.multiline		=$multiline;
			_textField.maxChars			=$maxChars;
		}
		//------Set Format -------------------------------------
		public function setFormat($font:String = null, $size:Object = null, $color:Object = null, $bold:Object = null, $italic:Object = null, $underline:Object = null, $url:String = null, $target:String = null, $align:String = null):void {
			_textFormat=new TextFormat($font, $size, $color, $bold, $italic, $underline, $url, $target, $align);
			_textField.setTextFormat(_textFormat);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("TextField:"+_textField,"TextFormat:"+_textFormat);
		}

	}
}