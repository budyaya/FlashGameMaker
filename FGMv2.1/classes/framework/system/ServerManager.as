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
*Under this licence you are free to copy, adapt and distrubute the work. 
*You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.system{
	import flash.events.EventDispatcher;
	
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.net.XMLSocket;
	/**
	* Keyboard Manager
	* @ purpose: Handle the keyboard event
	*/
	public class ServerManager extends EventDispatcher implements IServerManager {

		private static var _instance:IServerManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _ressourceManager:IRessourceManager=null
		private var _socket:XMLSocket;
		private var _xmlName:String = null;
		private var _hostName:String="localhost";
		private var _port:Number=4444;
		private var _online:Boolean=false;
		private var _connected:Boolean=false;
		
		public function ServerManager() {
			if (! _allowInstanciation || _instance!=null) {
				throw new Error("Error: Instantiation failed: Use ServerManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IServerManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new ServerManager();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
		}
		//------ Set Connection From Path ------------------------------------
		public function setConnectionFromPath(path:String, name:String):void {
//			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
//			dispatcher.addEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
//			_xmlName = name;
//			_ressourceManager.loadXml(path, name);
		}
		//------ On Xml Loading Successful ------------------------------------
		private function onXmlLoadingSuccessful( evt:Event ):void {
//			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
//			dispatcher.removeEventListener(Event.COMPLETE, onXmlLoadingSuccessful);
//			if(_xmlName!=null){
//				var xml:XML = _ressourceManager.getXml(_xmlName);
//				setConnectionFromXml(xml);
//				dispatchEvent(evt);
//			}
		}
		//------ Set Connection From Xml ------------------------------------
		public function setConnectionFromXml(xml:XML):void {
			_hostName = xml.hostName;
			_port = xml.port;
			_online = new Boolean(xml.online);
		}
		//------ Set Connection ------------------------------------
		public function setConnection(hostName:String, port:Number):void {
			_hostName = hostName;
			_port = port;
		}
		//------ Start Connection ------------------------------------
		public function startConnection():void {
			_socket = new XMLSocket();
			initListener(_socket);
			_socket.connect(_hostName,_port);
		}
		//------ Close Connection ------------------------------------
		public function closeConnection():void {
			_socket.close();
		}
		//-- Init Listener ---------------------------------------------
		private function initListener(dispatcher:IEventDispatcher):void {
			addEventListener(Event.CLOSE, closeHandler,false,0,true);
			addEventListener(Event.CONNECT, connectHandler,false,0,true);
			addEventListener(DataEvent.DATA, dataHandler,false,0,true);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			addEventListener(ProgressEvent.PROGRESS, progressHandler,false,0,true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler,false,0,true);
		}
		//-- Close Handler ---------------------------------------------
		private function closeHandler(evt:Event):void {
			//trace("Clonnection to server closed");
			_socket.close();
			dispatchEvent(evt);
		}
		//-- Connect Handler ---------------------------------------------
		private function connectHandler(evt:Event):void {
			//trace("Connection to server:" + _hostName + ", port:"+ _port +" Successfull ");
			_connected=true;
			dispatchEvent( evt);
			sendText("-- Welcome --");
		}
		//-- Data Handler ---------------------------------------------
		private function dataHandler(evt:DataEvent):void {
			var data:String=evt.data.split('\n').join('');
			onReceiveData(data);
			dispatchEvent( evt);
		}
		//-- IO Error Handler ---------------------------------------------
		private function ioErrorHandler(evt:IOErrorEvent):void {
			//trace("Connection to server:" + _hostName + ", port:"+ _port +" Failed ");
			_connected=false;
			_socket.close();
			dispatchEvent(evt);
		}
		//-- Progress Handler ---------------------------------------------
		private function progressHandler(evt:ProgressEvent):void {
			//trace("progressHandler loaded:" + evt.bytesLoaded + " total: " + evt.bytesTotal);
			dispatchEvent(evt);
		}
		//-- Security Error Handler ---------------------------------------------
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			_connected=false;
			_socket.close();
			dispatchEvent(evt);
			throw new Error("Error: Security Error in Server Manager:\n" + evt);
		}
		//-- Send XML ---------------------------------------------
		public function sendXml(xmlToSend:XML):void {
			if(_connected){
			_socket.send(xmlToSend+"\r");
			}
		}
		//-- Send Text ---------------------------------------------
		public function sendText(textToSend:String):void {
			if(_connected){
				textToSend = parseText(textToSend);
				_socket.send(textToSend+"\r");
			}
		}
		//-- Parse Text ---------------------------------------------
		private function parseText(textToSend:String):String {
			textToSend = "<message>"+textToSend+"</message>";
			return textToSend;
		}
		//-- On Receive Data ---------------------------------------------
		private function onReceiveData(data:String):void {
			
		}
		//-- Get Server ---------------------------------------------
		public function getServer():Object {
			var server:Object=new Object();
			server.hostName = _hostName;
			server.port = _port;
			server.connected = _connected;
			server.online = _online;
			return server;
		}
		//------ Send Player ------------------------------------
		public function sendPlayer(playerXml:XML,playerName:String):void {
			if(_connected){
				var textToSend:String = parsePlayer(playerXml,playerName);
				_socket.send(textToSend+"\r");
			}
		}
		//-- Parse Player ---------------------------------------------
		private function parsePlayer(playerXml:XML,playerName:String):String {
			var textToSend:String = "<player action='create' name='playerName'>"+playerXml.toString()+"</player>";
			return textToSend;
		}
		//------- ToString -------------------------------
		 public  function ToString():void{
           
        }
	}
}