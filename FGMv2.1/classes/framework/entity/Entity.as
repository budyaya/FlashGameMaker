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
*    Inspired from Ember  
*    Tom Davies 2010
*    http://github.com/tdavies/Ember/wiki
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

package framework.entity{
	import flash.utils.Dictionary;
	
	import framework.component.*;
	
	/**
	 * Entity Class
	 * @ purpose: An entity is an object wich represents something in the game such as player or map. 
	 * In FGM an entity is an empty container managed by the EntityManager.
	 */
	public class Entity implements IEntity {
		
		private var _entityName:String;
		private var _entityManager:IEntityManager = null;
		private var _components:Dictionary = new Dictionary();
		
		public function Entity($entityName:String, $entityManager:IEntityManager){
			initVar($entityName,$entityManager);
		}
		//------ Init Var ------------------------------------
		private function initVar($entityName:String, $entityManager:IEntityManager):void {
			_entityName= $entityName;
			_entityManager= $entityManager;
		}
		//------ Add Component ------------------------------------
		public function addComponent($component:Component):void {
			_entityManager.addComponent(this,$component);
			_components[$component.componentName] =$component ;
		}
		//------ Add Component From Name ------------------------------------
		public function addComponentFromName($componentName:String, $newName:String):Component {
			return _entityManager.addComponentFromName(_entityName, $componentName, $newName);
		}
		//------ Remove Component ------------------------------------
		public function removeComponent($component:Component):void {
			if($component && $component.entity!=this){
				throw new Error("Error: "+$component.componentName+" is not a component of the entity"+entityName+" !!" );
			}
			_components[$component.componentName]=null;
			delete _components[$component];
		}
		//------ Remove Component From Name ------------------------------------
		public function removeComponentFromName($componentName:String):void {
			var component:Component = _components[$componentName]
			removeComponent(component);
		}
		//------- Get EntityManager -------------------------------
		public function get entityManager():IEntityManager{
			return _entityManager;
		}
		//------ Get Entity Name  ------------------------------------
		public function get entityName():String {
			return _entityName;
		}
		//------- Get Components -------------------------------
		public function get components():Dictionary{
			return _components;
		}
		//------ Get Component ------------------------------------
		public function getComponent($componentName:String):Component{	
			return _entityManager.getComponent(_entityName,$componentName);
		}
		//------ Destroy ------------------------------------
		public function destroy():void{
			_entityManager.removeEntity(_entityName);
			_entityManager = null;
			_components = null;
		}
		//------- ToString -------------------------------
		public function ToString():void{
			trace(_entityName);
		}
	}
}