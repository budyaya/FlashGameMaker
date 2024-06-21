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
package utils.popforge{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class WavURLPlayer{
		//From http://stackoverflow.com/questions/668186/can-the-flash-player-play-wav-files-from-a-url	
		//Demo: WavURLPlayer.PlayWavFromURL("http://path.wav");
	
		public static var _callBack:Function = onSoundFactoryComplete;
		public static var _autoPlay:Boolean = true;
		public static function PlayWavFromURL($wavurl:String,$callBack:Function=null,$autoPlay:Boolean=true):void{
			if($callBack!=null){
				_callBack=$callBack;
			}	
			_autoPlay = $autoPlay;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete,false,0,true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError,false,0,true);
			var urlRequest:URLRequest = new URLRequest($wavurl);
			urlLoader.load(urlRequest);
		}
		//------ onLoaderComplete ------------------------------------
		private static function onLoaderComplete(e:Event):void{
			var urlLoader:URLLoader = e.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			
			var wavformat:WavFormat = WavFormat.decode(urlLoader.data);
			
			if(_autoPlay)
				SoundFactory.fromArray(wavformat.samples, wavformat.channels, wavformat.bits, wavformat.rate, _callBack);
			else	
				SoundFactory.fromArray(wavformat.samples, wavformat.channels, wavformat.bits, wavformat.rate, null);
		}
		//------ onLoaderComplete ------------------------------------
		private static function onLoaderIOError(e:IOErrorEvent):void{
			var urlLoader:URLLoader = e.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onLoaderComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			trace("error loading sound");
		}
		//------ onLoaderComplete ------------------------------------
		private static function onSoundFactoryComplete($sound:Sound):void{
			$sound.play();
		}
	}	
}