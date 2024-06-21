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
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.*;
	import framework.system.ISoundManager;
	import framework.system.SoundManager;
	
	import utils.loader.GraphicLoader;
	import utils.loader.SimpleLoader;
	import utils.loader.SoundLoader;
	import utils.ui.LayoutUtil;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class PreloaderComponent extends GraphicComponent {

		protected var _loadingBarRoot:MovieClip=null;
		protected var _loadingBarRootTF:TextField=null;
		protected var _loadingBarAssets:MovieClip=null;
		protected var _loadingBarAssetsTF:TextField=null;
		
		protected var _textField:TextField=null;
		private var _progress:Number=0;
		private var _onLoadingComplete:Function = null;
		private var _onAssetsLoadingComplete:Function = null;
		private var _onLoadingProgress:Function = null;
		private var _assetsToLoad:Array= null;
		private var _numAssetsToLoad:int =0;
		private var _soundManager:ISoundManager =null;
		
		public function PreloaderComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
			_loadAssets();
		}
		//------ Init Var ------------------------------------
		private  function _initVar($prop:Object):void {
			if($prop && $prop.graphic){
				setGraphic($prop.graphic);
			}	
			if($prop && $prop.onLoadingProgress)		_onLoadingProgress = $prop.onLoadingProgress;
			if($prop && $prop.onLoadingComplete)		_onLoadingComplete = $prop.onLoadingComplete;
			if($prop && $prop.onAssetsLoadingComplete)	_onAssetsLoadingComplete = $prop.onAssetsLoadingComplete;
			if($prop && $prop.assetsToLoad)				_assetsToLoad = $prop.assetsToLoad;	
			_textField = new TextField();
			_textField.text="Loading...";
			_textField.autoSize ="left";
			_textField.selectable=false;
			_soundManager = SoundManager.getInstance();
		}
		//------ Register Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("preloader");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "preloader") {
				if(!$param || !$param.hasOwnProperty("onLoadingComplete")){
					throw new Error("A function onLoadingComplete must exist to be registered by PreloaderComponent");
				}
			}
		}
		//------ LoadAssets ------------------------------------
		private function _loadAssets():void {
			_numAssetsToLoad = _assetsToLoad.length;
			for each (var assetPath:String in _assetsToLoad){
				var extension:String = SimpleLoader.GetFileExtension(assetPath).toLowerCase();
				if(GraphicLoader.SupportedFile.indexOf(extension)!=-1){
					loadGraphic(assetPath);
				}else if(SoundLoader.SupportedFile.indexOf(extension)!=-1){
					loadSound(assetPath);
				}else{
					loadFile(assetPath);
				}
			}
		}
		//------ Load Graphic  ------------------------------------
		public override function loadGraphic($path:String, $callback:Function =null):void {
			var callback:Object = {onInit:onAssetLoadingInit, onProgress:onAssetLoadingProgress, onComplete:onAssetLoadingComplete, onCompleteParams:$callback};
			_graphicManager.loadGraphic($path, callback);
		}
		//------ Load Sound  ------------------------------------
		public function loadSound($path:String, $callback:Function =null):void {
			var callback:Object = {onInit:onAssetLoadingInit, onProgress:onAssetLoadingProgress, onComplete:onAssetLoadingComplete, onCompleteParams:$callback};
			_soundManager.loadSound($path, callback);
		}
		//------ Load File  ------------------------------------
		public function loadFile($path:String, $callback:Function =null):void {
			var callback:Object = {onInit:onAssetLoadingInit, onProgress:onAssetLoadingProgress, onComplete:onAssetLoadingComplete, onCompleteParams:$callback};
			_ressourceManager.loadFile($path, callback);
		}
		//------ On Loading Progress ------------------------------------
		protected function onAssetLoadingInit($evt:Event, $callback:Function =null):void {
			if($callback is Function)	$callback(this,$evt);
		}
		//------ On Loading Progress ------------------------------------
		protected function onAssetLoadingProgress($evt:ProgressEvent, $callback:Function =null):void {
			var loaded:Number =$evt.bytesLoaded;
			var total:Number = $evt.bytesTotal;
			var name:String = SimpleLoader.GetFileName(_assetsToLoad[0]);
			_textField.text = "Loading... File: "+name+" , "+ _assetsToLoad.length+" / "+_numAssetsToLoad+" , "+ Math.floor((loaded/total)*100)+ "%";
			updateAssetsGraphic(loaded,total);
			//trace("*Preloader: "+_textField.text)
		}
		//------ On Loading Complete ------------------------------------
		protected function onAssetLoadingComplete($asset:Object, $callback:Function =null):void {
			if(_assetsToLoad.length>0){
				_assetsToLoad.shift();
			}
			if(_assetsToLoad.length==0){
				if(_onAssetsLoadingComplete is Function && _onAssetsLoadingComplete!=null){
					_textField.text="Loading Complete !";
					setTimeout(_onAssetsLoadingComplete,2000);
				}
			}
		}
		//------ Set Graphic  ------------------------------------
		public function setGraphic($display:*):void {
			_graphic = $display;
			LayoutUtil.Align(_graphic,LayoutUtil.ALIGN_CENTER_CENTER);
			Framework.AddChild(_graphic,this);
			if(_graphic.loadingBarRoot) 		_loadingBarRoot = _graphic.loadingBarRoot;
			if(_graphic.loadingBarRootTF)		_loadingBarRootTF = _graphic.loadingBarRootTF;
			if(_graphic.loadingBarAssets) 		_loadingBarAssets = _graphic.loadingBarAssets;
			if(_graphic.loadingBarAssetsTF) 	_loadingBarAssetsTF = _graphic.loadingBarAssetsTF;
		}
		//------ Update Root Graphic  ------------------------------------
		public function updateRootGraphic($loaded:Number, $total:Number):void {
			var progress:Number = Math.floor(($loaded/$total)*100)
			if(_loadingBarRoot && _loadingBarRoot.bar){
				_loadingBarRoot.bar.x = 100 - progress;
			} 
			if(_loadingBarRootTF){
				_loadingBarRootTF.text = _textField.text;
			}
		}
		//------ Update Assets Graphic  ------------------------------------
		public function updateAssetsGraphic($loaded:Number, $total:Number):void {
			var progress:Number = Math.floor(($loaded/$total)*100)
			if(_loadingBarAssets && _loadingBarAssets.bar){
				_loadingBarAssets.bar.x = 100 - progress;
			} 
			if(_loadingBarAssetsTF){
				_loadingBarAssetsTF.text = _textField.text;
			}
		}
		//------ On Loading Progress ------------------------------------
		public function addLoadingText():void {
			addChild(_textField);
		}
		//------ On Loading Complete ------------------------------------
		public function get progress():Number {
			return _progress;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}