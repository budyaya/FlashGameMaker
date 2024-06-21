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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package utils.loader{
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	
	
	/**
	* Graphic Loader Class
	* 
	*/
	public class GraphicLoader extends EventDispatcher {
		
		public static const SupportedFile:Array = ["gif","png","jpg","jpeg","swf","bmp",".gif",".png",".jpg",".jpeg",".swf",".bmp"];
		public var isLoading:Boolean = false;
		private var _loader:Loader = null;
		private var _loaderContext:LoaderContext = null; 

		public function GraphicLoader() {
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_loaderContext = new LoaderContext ();
			_loaderContext.checkPolicyFile = true;
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic(path:String):void {
			if(!isLoading){
				isLoading=true;
				_loader = new Loader ();
				_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadingInit,false, 0, true);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadingComplete,false, 0, true);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress,false,0, true);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError,false,0, true);
				_loader.load( new URLRequest(path),_loaderContext);
			}
		}
		//------ On Loading Successfull ------------------------------------
		private function onLoadingComplete( $evt:Event ):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadingComplete);
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoadingInit);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
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
		public function get loader():Loader {
			return _loader;
		}
		//------ On Loading Init------------------------------------
		private function onLoadingInit($evt:Event ):void {
			dispatchEvent($evt);
		}
	}
}