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
package {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import framework.entity.EntityManager;
	import framework.entity.IEntity;
	import framework.entity.IEntityManager;
	
	import screens.*;
	
	import utils.richardlord.FiniteStateMachine;
	
	/**
	 * MyGame Class
	 */
	public class MyGame{
		private var _preloader:Preloader=null;
		private var _uInterface:UInterface=null;
		private var _finiteStateMachine:FiniteStateMachine = null;
		public function MyGame() {
			_initVar();
			_initStateMachine();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			var entityManager:IEntityManager=EntityManager.getInstance();
			var entity:IEntity=entityManager.createEntity("MSOrigin");
			entityManager.addComponentFolder("customClasses.");
		}
		//------ Init Finite StateMachine ------------------------------------
		private function _initStateMachine():void {
			_finiteStateMachine = new FiniteStateMachine();
			var stateList:Dictionary = new Dictionary(true);
			stateList["Preloader"]=new Preloader();
			stateList["UInterface"]=new UInterface();
			stateList["StageGame"]=new StageGame();
			_finiteStateMachine.setStateList(stateList);
			_finiteStateMachine.setNextStateByName("StageGame"); 
			_finiteStateMachine.changeStateByName("Preloader");
		}
	}
}