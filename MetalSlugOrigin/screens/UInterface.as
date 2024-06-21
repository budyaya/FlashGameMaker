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
package screens{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.ISoundManager;
	import framework.system.MouseManager;
	import framework.system.SoundManager;
	
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.movieclip.Frame;
	import utils.popforge.WavURLPlayer;
	import utils.richardlord.*;
	import utils.ui.LayoutUtil;

	/**
	 * User Interface
	 */
	public class UInterface extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _menuComponent:GraphicComponent=null;
		private var _soundManager:ISoundManager=null;
		private var _mainMusic:String;
		
		public function UInterface(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_soundManager = SoundManager.getInstance();
			//_mainMusic = Framework.root+"assets/main.mp3"
		}
		//------ Start Music ------------------------------------
		private function startMusic():void {
			//_soundManager.play(_mainMusic,0.01,true);
		}
		//------ Stop Music ------------------------------------
		private function stopMusic():void {
			//_soundManager.stop(_mainMusic);
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var mouseInput:MouseInputComponent=_entityManager.addComponentFromName("MSOrigin","MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var keyInput:KeyboardInputComponent=_entityManager.addComponentFromName("MSOrigin","KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			keyInput.addEventListener(KeyboardEvent.KEY_DOWN,onKeyFire,false,0,true);
			keyInput.startListening();
		}
		//------ On Control Settings Bt Click ------------------------------------
		private function onControlSettingsBtClick($mousePad:MousePad):void {
			//_menuComponent.gotoAndStop(3);
			//_finiteStateMachine.changeStateByName("StageGame");
		}
		//------ On Key Fire ------------------------------------
		private function onKeyFire($evt:KeyboardEvent):void {
			if($evt.keyCode == KeyCode.ESC){
			}
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			initVar();
			initComponent();
			//startMusic();
		}
		//------ Enter ------------------------------------
		public override function exit($previousState:State):void {
			//stopMusic();
		}
	}
}