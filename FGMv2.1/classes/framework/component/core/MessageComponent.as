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
	import framework.entity.*;
	import framework.system.ServerManager;
	import framework.system.IServerManager;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import framework.component.Component;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MessageComponent extends GraphicComponent {

		private var _serverManager:IServerManager=null;
		private var _clip:MovieClip=null;
		//ServerInput Properties
		public var _server_data:String;

		public function MessageComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity,false, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_serverManager=ServerManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("serverInput");
		}
		//------ On Graphic Loading Successful ------------------------------------
		/*protected override function onGraphicLoadingComplete($graphic:DisplayObject):void {
			_clip=$graphic as MovieClip;
			if (_clip!=null) {
				_clip.sendBt.addEventListener(MouseEvent.CLICK,onSend,false,0,true);
				_clip.inputTxt.addEventListener(MouseEvent.CLICK,onInput,false,0,true);
				addChild(_clip);
			}
		}*///TODO: Need to be fix
		//-- On Send ---------------------------------------------
		private function onSend(evt:MouseEvent):void {
			var msgToSend:String=getInput();
			if (msgToSend!="") {
				sendMessage(msgToSend);
				_clip.inputTxt.text="";
				_clip.inputTxt.stage.focus=null;
			}
		}
		//-- On Input ---------------------------------------------
		private function onInput(evt:MouseEvent):void {
			if(_clip.inputTxt.text=="Write your message here"){
				_clip.inputTxt.text="";
			}
		}
		//-- Send Message ---------------------------------------------
		public function sendMessage(msgToSend:String):void {
			_serverManager.sendText(msgToSend);
		}
		//-- Get Message ---------------------------------------------
		public function getMessage():String {
			return _clip.messageClip.messageTxt.text;
		}
		//-- Set Message ---------------------------------------------
		public function setMessage(msgReceived:String):void {
			if (_clip!=null) {
				msgReceived=parseMessage(msgReceived);
				if (msgReceived!=null) {
					var msg:String=_clip.messageClip.messageTxt.text;
					_clip.messageClip.messageTxt.text=msgReceived;
					_clip.messageClip.messageTxt.text+="\n"+msg;
				}
			}
		}
		//-- Parse Message ---------------------------------------------
		private function parseMessage(msgReceived:String):String {
			var xml:XML=new XML(msgReceived);
			if (xml.name()=="message") {
				return xml.toString();
			}
			return null;
		}
		//-- Get Input ---------------------------------------------
		public function getInput():String {
			return _clip.inputTxt.text;
		}
		//------ Actualize Components  ------------------------------------
		/*public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
			setMessage(_server_data);
		}*///TODO: Need to be fix
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}