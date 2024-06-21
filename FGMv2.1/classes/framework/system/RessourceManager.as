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

package framework.system {
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import utils.loader.*;

	/**
	* Ressource Manager
	* @ purpose: Manage all the non Fileal ressources of the game: Xml, SWF, Sound
	*/
	public class RessourceManager implements IRessourceManager{
		
		private static var _instance:IRessourceManager=null;
		private static var _allowInstanciation:Boolean = false;
		
		private var _simpleLoader:SimpleLoader=null;
		private var _pool:Array=null;
		private var _files:Dictionary = new Dictionary();
		private var _loader:Object;// Keep a reference to the object loaded
		
		public function RessourceManager(){
			if(!_allowInstanciation || _instance!=null){
				 throw new Error("Error: Instantiation failed: Use RessourceManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IRessourceManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance = new RessourceManager();
				return _instance;
			}
			return _instance;
		}
		//------ Get Instance ------------------------------------
		private function initVar():void{
			_files = new Dictionary();
			_pool = new Array();
		}
		//------ Get File ------------------------------------
		public function getFile($path:String):* {
			var name:String = SimpleLoader.GetFileName($path);
			var loader:URLLoader = _files[$path];
			if(loader && loader.data){
				return loader.data;
			}else{
				for (var path:String in _files) {
					if(SimpleLoader.GetFileName(path)==name){
						return _files[path].data;
					}
				}
			}
			throw new Error("*FileManager: the File requested ("+$path+") as not been fully loaded yet or doesn't exist!!!");
			return null;
		}
		//------ Get Files ------------------------------------
		public function getFiles($paths:Array):Array {
			var list:Array = new Array();
			for each(var path:String in $paths){
				list.push(getFile(path));
			}
			return list;
		}
		//------ Load File ------------------------------------
		public function loadFile($path:String, $callback:Object):void {
			var loader:URLLoader = _files[$path];
			if (loader) {
				var file:Object = loader.data;	
				$callback.onComplete(file, $callback.onCompleteParams);
			}else if (_simpleLoader && _simpleLoader.isLoading) {
				_pool.push({path:$path, callback:$callback});
			}else{
				_loader = {path:$path, callback:$callback};
				_simpleLoader = new SimpleLoader();
				_simpleLoader.addEventListener(Event.INIT, onFileLoadingInit,false,0, true);
				_simpleLoader.addEventListener(Event.COMPLETE, onFileLoadingComplete,false,0, true);
				_simpleLoader.addEventListener(ProgressEvent.PROGRESS, onFileLoadingProgress,false,0, true);
				_simpleLoader.loadFile($path);
			}
		}
		//------ On File Loading Complete ------------------------------------
		private function onFileLoadingComplete( $evt:Event ):void {
			_simpleLoader.isLoading = false;
			_simpleLoader.removeEventListener(Event.INIT, onFileLoadingInit);
			_simpleLoader.removeEventListener(Event.COMPLETE, onFileLoadingComplete);
			_simpleLoader.removeEventListener(ProgressEvent.PROGRESS, onFileLoadingProgress);
			var loader:URLLoader = $evt.target.loader as URLLoader;
			_files[_loader.path] = loader;
			var callback:Object = _loader.callback;
			var file:Object =loader.data;
			
			if(callback && callback.hasOwnProperty("onComplete")){
				if(callback.hasOwnProperty("onCompleteParams") && callback.onCompleteParams){
					callback.onComplete(file, callback.onCompleteParams);
				}else{
					callback.onComplete(file);
				}
			}
			if(_pool.length>0){
				var object:Object = _pool.pop();
				loadFile(object.path, object.callback);
			}
		}
		//------ On File Loading Init ------------------------------------
		private function onFileLoadingInit($evt:Event ):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onInit")){
				callback.onInit($evt);
			}
		}
		//------ On File Loading Progress ------------------------------------
		private function onFileLoadingProgress($evt:ProgressEvent ):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onProgress")){
				callback.onProgress($evt);
			}
		}
		//------- ToString -------------------------------
		 public  function ToString():void{
           
        }
	}
}