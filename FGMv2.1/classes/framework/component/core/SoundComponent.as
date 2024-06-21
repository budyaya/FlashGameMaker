﻿/*
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
	import flash.events.*;
	import flash.events.EventDispatcher;
	
	import framework.entity.*;
	import framework.system.ISoundManager;
	import framework.system.SoundManager;

	/**
	* Sound Component
	* @ purpose: 
	* 
	*/
	public class SoundComponent extends GraphicComponent {

		private var _soundManager:ISoundManager=null;
		//Sound properties
		public var _sound_name:String;
		public var _sound_path:String;
		public var _sound_volume:Number=0.5;//Between 0 and 100
		public var _sound_isPlaying:Boolean=false;
		public var _sound_play:Boolean=false;
		public var _sound_position:Number=0;

		public function SoundComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		override protected function initVar($prop:Object):void {
			super.initVar($prop);
			_soundManager=SoundManager.getInstance();
			_sound_name="MySound";
			_sound_path="sound/sound.mp3";
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}