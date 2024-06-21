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
	import data.Data;
	
	import flash.events.Event;
	
	import framework.Framework;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.IRessourceManager;
	import framework.system.ISoundManager;
	import framework.system.RessourceManager;
	import framework.system.SoundManager;
	
	import utils.richardlord.*;

	public class Preloader extends State implements IState{
		
		private var _entityManager:IEntityManager=null;
		private var _preloaderComponent:PreloaderComponent;
		private var _soundManager:ISoundManager=null;
		private var _ressourceManager:IRessourceManager=null;
		private var _currentDirectoryPath:String
		
		// Preloader load the main swf (FlashGameMaker.swf) and preload assets
		public function Preloader(){
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager = EntityManager.getInstance();
			_soundManager = SoundManager.getInstance();
			_ressourceManager = RessourceManager.getInstance();
			
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var renderComponent:RenderComponent = _entityManager.addComponentFromName("MSOrigin","RenderComponent","myRenderComponent") as RenderComponent;
			var assetsToLoad:Array = getAssetsToLoad();
			_preloaderComponent = _entityManager.addComponentFromName("MSOrigin","PreloaderComponent","myPreloaderComponent", {onLoadingComplete:onLoadingComplete ,onAssetsLoadingComplete:onAssetsLoadingComplete, assetsToLoad:assetsToLoad}) as PreloaderComponent;
			_preloaderComponent.addLoadingText();
		}
		//------ Get Assets To Load ------------------------------------
		private function getAssetsToLoad():Array {
			var assetsToLoad:Array = new Array();
			for each(var bg:Object in Data.BACKGROUND){
				assetsToLoad.push(Framework.root+bg.path);
			}
			for each(var object:Object in Data.OBJECT){
				assetsToLoad.push(Framework.root+object.data);
				for each(var graphic:String in object.graphics){
					assetsToLoad.push(Framework.root+graphic);
				}
			}
			for each(var other:Object in Data.OTHER){
				assetsToLoad.push(Framework.root+other.path);
			}
			
			return assetsToLoad;
		}
		//------ On Loading Complete ------------------------------------
		private function onLoadingComplete():void {
			
		}
		//------ On Asset Loading Complete ------------------------------------
		private function onAssetsLoadingComplete():void {
			_finiteStateMachine.goToNextState();
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			initVar();
			initComponent();
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			_preloaderComponent.destroy();
		}
	}
}