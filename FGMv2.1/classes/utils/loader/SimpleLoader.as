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

package utils.loader{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	* Simple Loader Class
	*/
	public class SimpleLoader extends EventDispatcher{
		public static const SupportedFile:Array = ["*"];
		public var isLoading:Boolean = false;
		private var _loader:URLLoader = null;
		
		public function SimpleLoader() {
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
		}
		//------ Load File ------------------------------------
		public function loadFile($path:String):void {
			if(!isLoading){
				var myRequest:URLRequest = new URLRequest($path);
				isLoading=true;
				_loader = new URLLoader ();
				_loader.addEventListener(Event.INIT, onLoadingInit,false, 0, true);
				_loader.addEventListener(Event.COMPLETE, onLoadingComplete,false, 0, true);
				_loader.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress,false,0, true);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError,false,0, true);
				_loader.load( myRequest);
			}
		}
		//------ On Loading Successfull ------------------------------------
		private function onLoadingComplete( $evt:Event ):void {
			_loader.removeEventListener(Event.COMPLETE, onLoadingComplete);
			_loader.removeEventListener(Event.INIT, onLoadingInit);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			dispatchEvent($evt);
		}
		//------ Io Error ------------------------------------
		private function onIoError($evt:IOErrorEvent ):void {
			throw new Error("Error: Loading Fail \n" + $evt);
		}
		//------ On Loading Progress------------------------------------
		private function onLoadingProgress($evt:ProgressEvent ):void {
			dispatchEvent($evt);
		}
		//------ Get Loader------------------------------------
		public function get loader():URLLoader {
			return _loader;
		}
		//------ On Loading Init------------------------------------
		private function onLoadingInit($evt:Event ):void {
			dispatchEvent($evt);
		}
		//------ Get File Name ------------------------------------
		public static function GetFileName($path:String):String {
			var pathParts:Array = $path.split("/");
			var name:String = pathParts[pathParts.length-1];
			return name;
		}
		//------ Get File Extension ------------------------------------
		public static function GetFileExtension($path:String):String {
			var name:String = GetFileName($path);
			var nameParts:Array = name.split(".");//path or name
			var extension:String = nameParts[1];
			//trace ("The file extension is " + extension);
			return extension;
		}
		//------ Get File LessExtension ------------------------------------
		public static function GetFileLessExtension($path:String):String {
			var name:String = GetFileName($path);
			var nameParts:Array = name.split(".");//path or name
			var extensionless:String = nameParts[0];
			//trace ("The filename is " + extensionless);
			return extensionless;
		}
		//------ Get File Directory ------------------------------------
		public static function GetFileDirectory($path:String):String {
			var path:String;
			if($path.lastIndexOf("\\") !=-1){
				return path.substring(0,path.lastIndexOf("\\")+1);
			}
			path=$path.substring(0,$path.lastIndexOf("/"));
			path=path.substring(0,path.lastIndexOf("/")+1);
			return path;
		}
	}
}