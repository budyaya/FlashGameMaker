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
	import flash.media.Sound;
	import flash.net.*;
	import flash.system.LoaderContext;
	
	
	/**
	* Sound Loader Class
	* 
	*/
	public class SoundLoader extends EventDispatcher {
		
		public static const SupportedFile:Array = [".mp3","mp3"];
		public var isLoading:Boolean = false;
		private var _sound:Sound = null;

		public function SoundLoader() {
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
		}
		//------ Load Sound ------------------------------------
		public function loadSound($path:String):void {
			if(!isLoading){
				isLoading=true;
				_sound = new Sound();
				_sound.addEventListener(Event.OPEN, onLoadingInit,false, 0, true);
				_sound.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress,false,0, true);
				_sound.addEventListener(Event.COMPLETE,onSoundLoadingComplete,false,0,true);
				_sound.addEventListener(IOErrorEvent.IO_ERROR,onIoError,false,0,true);
				_sound.load(new URLRequest($path));
			}
		}
		//------ On Sound Loading Complete ------------------------------------
		private function onSoundLoadingComplete( $evt:Event ):void {
			isLoading=false;
			dispatchEvent($evt);
			_sound.removeEventListener(Event.COMPLETE, onSoundLoadingComplete);
			_sound.removeEventListener(Event.OPEN, onLoadingInit);
			_sound.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		//------ Io Error ------------------------------------
		private function onIoError($evt:IOErrorEvent ):void {
			throw new Error("Error: Loading Fail \n" + $evt);
		}
		//------ On Loading Progress------------------------------------
		private function onLoadingProgress($evt:ProgressEvent ):void {
			dispatchEvent($evt);
		}
		//------ On Loading Init------------------------------------
		private function onLoadingInit($evt:Event ):void {
			dispatchEvent($evt);
		}
		//------ Get Sound------------------------------------
		public function get sound():Sound {
			return _sound;
		}
	}
}