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

	public interface IEntity{
		/**
		 * Add a component to the entity
		 * @param name of component to be added
		 */
		function addComponent($component:Component):void;
		/**
		 * Add a component to the entity from name
		 * @param name of component to be added
		 */
		function addComponentFromName($componenName:String, $newName:String):Component;
		/**
		 * Remove a component
		 */
		function removeComponent($component:Component):void;
		/**
		 * Remove a component from the entity
		 */
		function removeComponentFromName($componentName:String):void;
		/**
		 * Get Entity Manager
		 */
		function get entityManager():IEntityManager;
		/**
		 * Get Entity Name
		 */
		function get entityName():String;
		/**
		 * Get Component
		 */
		function getComponent($componentName:String):Component;
		/**
		 * Return the List of Components
		 */
		function get components():Dictionary;
		/**
		 * Invoked when instance is to be destroyed
		 */
		function destroy():void;
		/**
		 * Trace the Name of the Entity
		 */
		function ToString():void;
	}
}