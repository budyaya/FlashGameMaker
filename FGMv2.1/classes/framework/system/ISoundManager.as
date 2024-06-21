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
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public interface ISoundManager {
		
		/**
		 * Load sound
		 */		
		function loadSound($path:String, $callBack:Object):void;
		/**
		 * Play sound
		 */		
		function play(path:String, volume:Number=0.5, loopMusic:Boolean=false):void;
		/**
		 * Play Wav
		 */		
		function playWav($wavUrl:String, $volume:Number=0.5, $kill:Boolean=false):void;
		/**
		 * Stop Sound
		 */		
		function stop(soundChannel:SoundChannel=null):Number;
		/**
		 * Resume Sound
		 */		
		function resume(sound:Sound=null,playingSoundPosition:Number=-1):void;
		/**
		 * Mute
		 */		
		function mute(soundChannel:SoundChannel=null):void ;
		/**
		 * Change Volume
		 */		
		function changeVolume(soundChannel:SoundChannel, volume:Number):void;
		/**
		 * To String
		 */		
		function ToString():void ;
		
	}
}