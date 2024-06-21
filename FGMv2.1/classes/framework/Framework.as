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
*   A full copy of the license is available at http://www.gnu.org/licenses/fdl-1.3-standalone.html.
*
*/

package framework{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import framework.component.ComponentReference;
	
	import script.ScriptReference;
	
	import utils.loader.SimpleLoader;
	import utils.stuv.Params;
	import utils.stuv.Platform;
	
	/**
	* Initialize the framework
	*/
	public class Framework{
		private static var ROOT:String=null;//Project directory
		private static var DEBUG_MODE:Boolean = true;
		private static var CLIP:Sprite=null;
		private static var STAGE:Stage=null;
		private static var LOADER_INFO:LoaderInfo=null;
		private static var NUM_CHILDREN:Number=0;
		
		public function Framework($root:Sprite) {
			_initClassReference();
			_initVar($root);
			_initParams();
		}
		//------ Init Class Reference  ------------------------------------
		private  function _initClassReference():void{
			new ComponentReference();
			new ScriptReference();
		}
		//------ Init Var ------------------------------------
		private function _initVar($root:Sprite):void {
			CLIP=$root;
			CLIP.focusRect = false;
			STAGE=$root.stage;
			LOADER_INFO = $root.loaderInfo;
			ROOT = SimpleLoader.GetFileDirectory(LOADER_INFO.loaderURL);
		}
		//------ Init Params ------------------------------------
		private function _initParams():void {
			STAGE.doubleClickEnabled = true;
			//Security.allowInsecureDomain("*");
			Platform.Init(LOADER_INFO);
			Params.Init(LOADER_INFO)
		}
		//------ Add Child  ------------------------------------
		public static function AddChild($displayObject:DisplayObject, $container:DisplayObjectContainer=null, $layer:int = -1):DisplayObject {
			if (!$container) {
				$container = CLIP;
			}
			NUM_CHILDREN++;
			if($layer==-1)
				return $container.addChild($displayObject);
			return $container.addChildAt($displayObject, $layer);
		}
		//------ Add Child  ------------------------------------
		public static function RemoveChild($displayObject:DisplayObject, $container:DisplayObjectContainer=null):DisplayObject {
			if (!$container) {
				$container = CLIP;
			}
			if ($container.contains($displayObject)) {	
				NUM_CHILDREN--;
				$container.removeChild($displayObject);
			}
			return null;
		}
		//------ IndexOf  ------------------------------------
		public static function IndexOf($displayObject:DisplayObject):int {
			var container:DisplayObjectContainer = $displayObject.parent;
			if(!container)	return 0;
			return container.getChildIndex($displayObject);
		}
		//------ Set Child Index  ------------------------------------
		public static function SetChildIndex($displayObject:DisplayObject, $index:int):void{
			var container:DisplayObjectContainer = $displayObject.parent;
			if(!container)	return;
			container.setChildIndex($displayObject,$index);
		}
		//------ Focus  ------------------------------------
		public static function Focus():void {
			STAGE.focus=CLIP;
		}
		//------ Get Clip  ------------------------------------
		public static function get clip():Sprite {
			return CLIP;
		}
		//------ Get Stage  ------------------------------------
		public static function get stage():Stage {
			return STAGE;
		}
		//------ Get Loader Info  ------------------------------------
		public static function get loaderInfo():LoaderInfo {
			return LOADER_INFO;
		}
		//------ Get Width ------------------------------------
		public static function get width():Number {
			return stage.stageWidth;
		}
		//------ Get Height  ------------------------------------
		public static function get height():Number {
			return stage.stageHeight;
		}
		//------ Get Num Children  ------------------------------------
		public static function get numChildren():Number {
			return CLIP.numChildren;
		}
		//------ Get Debug Mode  ------------------------------------
		public static function get debugMode():Boolean {
			return DEBUG_MODE;
		}
		//------ Get Root   ------------------------------------
		public static function get root():String {
			return ROOT;
		}
	}
}