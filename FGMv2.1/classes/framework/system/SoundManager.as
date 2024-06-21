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
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import utils.loader.SoundLoader;
	import utils.popforge.WavURLPlayer;

	/**
	* Sound Manager
	* @ purpose: 
	*/
	public class SoundManager implements ISoundManager {

		private static var _instance:ISoundManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _playingSound:Sound = null;
		private var _playingSoundChannel:SoundChannel=null;
		private var _playingSoundPosition:Number=0;
		private var _playingSoundVolume:Number =1;
		private var _mute:Boolean=false;
		private var _sounds:Dictionary=null;
		private var _volume:Number=0.5;//between 0 and 1
		private var _soundToLoad:Array = null;
		private var _playingSounds:Dictionary=null;
		private var _soundLoader:SoundLoader=null;
		private var _loader:Object;// Keep a reference to the object loaded

		public function SoundManager() {
			if (! _allowInstanciation || _instance!=null) {
				throw new Error("Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():ISoundManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance= new SoundManager();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_sounds = new Dictionary();
			_playingSounds = new Dictionary();
			_soundToLoad = new Array();
		}
		//------ Init Var ------------------------------------
		public function play($path:String, $volume:Number =0.5, $loopMusic:Boolean=false):void {
			if (_sounds[$path]==null) {
				_soundToLoad.push({path:$path,callback:{onComplete:_playCallback}});
				if(_soundToLoad.length==1){
					loadSound($path,{onComplete:_playCallback,onCompleteParams:{volume:$volume,loopMusic:$loopMusic}});
				}
			} else {
				var sound:Sound=_sounds[$path].sound;
				_sounds[$path].soundChannel = sound.play();
				_sounds[$path].volume = $volume;
				if($loopMusic){
					sound.addEventListener(Event.SOUND_COMPLETE, _loopMusic);
				}
			}
		}
		//------  Play Callback ------------------------------------
		private function _playCallback($sound:Sound):void {
			$sound.play();
		}
		//------ Loop Music ------------------------------------
		private function _loopMusic($evt:Event):void {
			var sound:Sound = $evt.target as Sound;
			sound.play();
		}
		//------ Load ------------------------------------
		public function loadSound($path:String, $callback:Object):void {
			var sound:Sound = _sounds[$path] as Sound;
			if (sound) {
				if($callback)	$callback.onComplete(sound);
				if(_soundToLoad.length>0){
					var object:Object = _soundToLoad.pop();
					loadSound(object.path, object.callback);
				}
			}else if (_soundLoader && _soundLoader.isLoading) {
				_soundToLoad.push({path:$path, callback:$callback});
			}else{
				_loader = {path:$path, callback:$callback};
				_soundLoader=new SoundLoader();
				_soundLoader.addEventListener(Event.COMPLETE, onSoundLoadingComplete,false,0,true);
				_soundLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError,false,0, true);
				_soundLoader.addEventListener(Event.OPEN, onSoundLoadingInit,false,0, true);
				_soundLoader.addEventListener(ProgressEvent.PROGRESS, onSoundLoadingProgress,false,0, true);
				_soundLoader.loadSound($path);
			}
		}
		//------ Sound Open ------------------------------------
		private function onSoundLoadingComplete($evt:Event):void {
			_soundLoader.removeEventListener(Event.OPEN,onSoundLoadingInit);
			_soundLoader.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			_soundLoader.removeEventListener(Event.COMPLETE,onSoundLoadingComplete);
			_soundLoader.removeEventListener(ProgressEvent.PROGRESS,onSoundLoadingProgress);
			var soundLoader:SoundLoader=$evt.target as SoundLoader;
			var sound:Sound=soundLoader.sound;
			var path:String = _loader.path;
			var callback:Object = _loader.callback;
			_sounds[_loader.path] = {sound:sound};
			if(callback && callback.hasOwnProperty("onComplete")){
				if(callback.hasOwnProperty("onCompleteParams") && callback.onCompleteParams ){
					callback.onComplete(sound, callback.onCompleteParams);
				}else{
					callback.onComplete(sound);
				}
			}
			if(_soundToLoad.length>0){
				var object:Object = _soundToLoad.pop();
				loadSound(object.path, object.callback);
			}
		}
		//------ Io Error  ------------------------------------
		private function onIoError($evt: IOErrorEvent):void {
			trace("Fichier .mp3 introuvable", $evt);
		}
		//------ On Sound Loading Init ------------------------------------
		private function onSoundLoadingInit($evt:Event):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onInit")){
				callback.onInit($evt);
			}
		}
		//------ On Sound Loading Progress ------------------------------------
		private function onSoundLoadingProgress($evt:ProgressEvent ):void {
			var callback:Object = _loader.callback;
			if(callback && callback.hasOwnProperty("onProgress")){
				callback.onProgress($evt);
			}
		}
		//------ Resume Music ------------------------------------
		public function resume($sound:Sound=null,$playingSoundPosition:Number=-1):void {
			if ($sound) {
				_playingSound = $sound;
			}
			if ($playingSoundPosition!=-1) {
				_playingSoundPosition = $playingSoundPosition;
			}
			_playingSoundChannel = _playingSound.play(_playingSoundPosition);
		}
		//------ Stop Music ------------------------------------
		public function stop($soundChannel:SoundChannel=null):Number {
			_playingSoundPosition = _playingSoundChannel.position;
			_playingSoundChannel.stop();
			return _playingSoundPosition;
		}
		//------ Mute ------------------------------------
		public function mute($soundChannel:SoundChannel=null):void {
			var soundTransform:SoundTransform=_playingSoundChannel.soundTransform;
			if (soundTransform.volume>0) {
				soundTransform.volume=0;
			}else{
				soundTransform.volume = _playingSoundVolume;
			}
		}
		//------ Change Volume ------------------------------------
		public function changeVolume($soundChannel:SoundChannel, $volume:Number):void {
			var soundTransform:SoundTransform=$soundChannel.soundTransform;
			soundTransform.volume=$volume;
			$soundChannel.soundTransform = soundTransform;
		}
		//------ Play Streaming Wav ------------------------------------
		public function playWav($wavUrl:String, $volume:Number=0.5, $kill:Boolean=false):void {
			if($kill && _playingSound){
				stop();
			}
			if(_playingSounds[$wavUrl]){
				trace("[WARNING] the sound "+$wavUrl+" has already been played");
			}else if(_sounds[$wavUrl]){
				var sound:Sound = _sounds[$wavUrl];
				sound.play();
			}else{
				_playingSounds[$wavUrl] = $wavUrl;
				WavURLPlayer.PlayWavFromURL($wavUrl);
			}
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}