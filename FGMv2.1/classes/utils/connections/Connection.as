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
package utils.connections{
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	
	import utils.senocular.PassParameters;
	
	public class Connection{
		
		protected static var _instance:Connection=null;
		protected static var _allowInstanciation:Boolean=false;
		public static var AppBaseUrl:String = "http://apps.facebook.com/barnbuddy/";
		public static var ApiActionUrl:String = "http://farmsrv.com/barnbuddy/farm_actionst2.php";
		
		protected var _outgoingConnection:LocalConnection = null;
		protected var _outgoingConnectionName:String = null;
		protected var _incomingConnection:LocalConnection = null;
		protected var _incomingConnectionName:String = null;
		protected var _loaderInfo:LoaderInfo = null;
		
		public function Connection(){
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use Connection.getInstance() instead of new.");
			}
			_initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():Connection {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance = new Connection();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		protected function _initVar():void {
			
		}
		//------ SendJs ------------------------------------
		public function sendJS($methodName:String, $args:Array=null):void {
			_outgoingConnection.send(_outgoingConnectionName, "callFBJS", $methodName, $args);
		}
		//------ Call JavaScript ------------------------------------
		public static function CallJS($method:String,$methodArgs:Array=null,$callback:Function = null, $callbackArgs:Array=null):void {
			if (ExternalInterface.available) {
				ExternalInterface.call($method, $methodArgs);
				if($callback != null)
					ExternalInterface.addCallback($method, PassParameters.AddArguments($callback,$callbackArgs));
			}
		}
		//------ Call JavaScript ------------------------------------
		public function callFBJS($methodName:String,$methodArgs:Array=null,$callback:Function = null, $callbackArgs:Array=null):void {
			if (_outgoingConnectionName) {
				sendJS($methodName, $methodArgs);
//				if($callback != null)
//					ExternalInterface.addCallback($methodName, PassParameters.AddArguments($callback,$callbackArgs));
//				
			}
		}
		//------ Navigate to Page ------------------------------------
		public static function NavPage( $url:String, $newWindow:Boolean=false, $navTopWindow:Boolean=true ):void {
			if ($newWindow) {
				navigateToURL(new URLRequest($url), "_blank");
			} else {
				var js:String;
				if ($navTopWindow) {
					js = "window.top.location = '"+$url+"';";
				} else {
					js = "window.location = '"+$url+"';";
				}
				js = "function () {" + js + "}";
				CallJS(js);
			}
		}
		//------ Refresh Page ------------------------------------
		public static function RefreshPage():void {
			var js:String = "" + 
				"function () {" +
				"document.location=document.location;"+
				"}";
			CallJS(js);
		}
		//------ Display ALert ------------------------------------
		public static function DisplayAlert($message:String):void {
			var js:String = "" + 
				"function () {" +
				"window.alert('"+ $message+"');"+
				"}";
			CallJS(js);
		}
	}
}
		