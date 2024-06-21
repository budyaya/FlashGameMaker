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

package framework.system{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import utils.loader.GraphicLoader;
	import utils.loader.SimpleLoader;
	import utils.senocular.PassParameters;
	
	/**
	 * GraphicManager Interface Class
	 */
	public class GraphicManager implements IGraphicManager {
		
		private static var _instance:IGraphicManager=null;
		private static var _allowInstanciation:Boolean=false;
		
		private var _graphicLoader:GraphicLoader=null;
		private var _pool:Array=null;
		private var _graphics:Dictionary = new Dictionary();
		private var _loader:Object;// Keep a reference to the object loaded
		
		public function GraphicManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use XmlManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IGraphicManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new GraphicManager();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphics = new Dictionary();
			_pool = new Array();
		}
		//------ Get Graphic ------------------------------------
		public function getGraphic($path:String):* {
			var name:String = SimpleLoader.GetFileName($path);
			var loader:Loader = _graphics[$path];
			if(loader && loader.content){
				return loader.content;
			}else{
				for (var path:String in _graphics) {
					if(SimpleLoader.GetFileName(path)==name){
						return _graphics[path].content;
					}
				}
			}
			throw new Error("*GraphicManager: the graphic requested ("+$path+") as not been fully loaded yet or doesn't exist!!!");	
			return null;
		}
		//------ Get Graphics ------------------------------------
		public function getGraphics($paths:Array):Array {
			var list:Array = new Array();
			for each(var path:String in $paths){
				list.push(getGraphic(path));
			}
			return list;
		}
		//------ Load Graphic ------------------------------------
		public function loadGraphic($path:String, $callback:Object):void {
			var loader:Loader = _graphics[$path];
			if ( loader && loader.content is Bitmap) {
				//var bitmap:Bitmap = cloneBitmap(loader.content as Bitmap) as Bitmap;	//Clone
				var source:DisplayObject =loader.content;
				if($callback && $callback.hasOwnProperty("onCompleteParams") && $callback.onCompleteParams){
					$callback.onComplete(source, $callback.onCompleteParams);
				}else if ($callback){
					$callback.onComplete(source);
				}
				if(_pool.length>0){
					var object:Object = _pool.pop();
					loadGraphic(object.path, object.callback);
				}
			}/*else if ( loader && loader.content is MovieClip) {							//Duplicating a Loader is like reloading file
				var swfClone:MovieClip = cloneLoader(loader,$callback) as MovieClip;
			}*/else if (_graphicLoader && _graphicLoader.isLoading) {
				_pool.push({path:$path, callback:$callback});
			}else{
				_loader = {path:$path, callback:$callback};
				_graphicLoader=new GraphicLoader();
				_graphicLoader.addEventListener(Event.INIT, onGraphicLoadingInit,false,0, true);
				_graphicLoader.addEventListener(Event.COMPLETE, onGraphicLoadingComplete,false,0, true);
				_graphicLoader.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress,false,0, true);
				_graphicLoader.loadGraphic($path);
			}
		}
		//------ On Graphic Loading Complete ------------------------------------
		private function onGraphicLoadingComplete( $evt:Event ):void {
			_graphicLoader.removeEventListener(Event.INIT, onGraphicLoadingInit);
			_graphicLoader.removeEventListener(Event.COMPLETE, onGraphicLoadingComplete);
			_graphicLoader.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicLoader.isLoading = false;
			var loader:Loader = $evt.target.loader as Loader
			_graphics[_loader.path] = loader;
			var callback:Object = _loader.callback;
			var source:DisplayObject =loader.content;
			
			if(callback && callback.hasOwnProperty("onComplete")){
				if(callback.hasOwnProperty("onCompleteParams") && callback.onCompleteParams){
					callback.onComplete(source, callback.onCompleteParams);
				}else{
					callback.onComplete(source);
				}
			}
			if(_pool.length>0){
				var object:Object = _pool.pop();
				loadGraphic(object.path, object.callback);
			}
		}
		//------ On Graphic Loading Init ------------------------------------
		private function onGraphicLoadingInit($evt:Event):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onInit")){
				callback.onInit($evt);
			}
		}
		//------ On Graphic Loading Progress ------------------------------------
		private function onGraphicLoadingProgress($evt:ProgressEvent ):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onProgress")){
				callback.onProgress($evt);
			}
		}
		//------ Clone Bitmap ------------------------------------
		private function cloneBitmap( $source:Bitmap):Bitmap {
			var clone:Bitmap = new Bitmap($source.bitmapData.clone());
			return clone;
		}
		// From Jloa - http://chargedweb.com/labs/2010/02/20/duplicatemovieclip-is-back-to-as3/
		//------ Clone Loader ------------------------------------
		private function cloneLoader( $loader:Loader,$callback:Object):void {
			var sourceBytes:ByteArray = $loader.contentLoaderInfo.bytes;
			var copyLoader:Loader = new Loader();
			copyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, PassParameters.AddArguments(onContentLoaded, [$callback]) ,false,0,true);
			copyLoader.loadBytes(sourceBytes);
		}
		//------ onContentLoaded------------------------------------
		private function onContentLoaded($evt:Event, $callback:Object):void {
			var loaderInfo:LoaderInfo = $evt.target as LoaderInfo;
			var clone:MovieClip = loaderInfo.content as MovieClip;
			if($callback && $callback.hasOwnProperty("onComplete")){
				$callback.onComplete(clone, $callback.onCompleteParams);
			}
			if(_pool.length>0){
				var loader:Object = _pool.pop();
				loadGraphic(loader.path, loader.callback);
			}
		}
		//------- ToString -------------------------------
		public function ToString():void {
			
		}
	}
}