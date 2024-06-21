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
	
	import framework.Framework;
	
	import utils.senocular.PassParameters;
	
	public class FacebookConnection extends Connection{
		public function FacebookConnection(){
			super();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():FacebookConnection {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance = new FacebookConnection();
			}
			return _instance as FacebookConnection;
		}
		//------ Init Var ------------------------------------
		protected override function _initVar():void {
			try{
				_loaderInfo = Framework.loaderInfo;
				_outgoingConnection = new LocalConnection(); //Communication from Flash to Javascript
				_outgoingConnectionName = _loaderInfo.parameters.fb_local_connection;
				_incomingConnection = new LocalConnection(); //Communication from Javascript to Flash
				_incomingConnection.allowDomain("*");
				_incomingConnectionName = _loaderInfo.parameters.fb_fbjs_connection;
				_incomingConnection.client = this;
				_incomingConnection.connect(_incomingConnectionName);
			}catch(e: Error){
				trace(e);
			}
		}
	}
}
		