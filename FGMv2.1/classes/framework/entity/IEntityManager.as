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
	import framework.component.*;
	
	public interface IEntityManager{
		
		/**
		 * Create Entity new entity
		 * @return the entity created
		 */
		function createEntity($entityName:String):IEntity;
		/**
		 * Remove Entity
		 */
		function removeEntity($entityName:String):void;
		/**
		 * Add Component
		 */
		function addComponent($entity:IEntity,$component:Component):void;
		/**
		 * Add Component From Name
		 */
		function addComponentFromName($entityName:String,$componentName:String,$newName:String=null, $prop:Object=null, $singleton:Boolean=false):Component;
		/**
		 * Remove Component
		 */
		function removeComponent($component:Component):void;
		/**
		 * Remove Component From Name
		 */
		function removeComponentFromName($entityName:String,$componentName:String):void;
		/**
		 * Remove All Components
		 */
		function removeAllComponents($entity:IEntity):void;
		/**
		 * Remove All Components
		 */
		function removeAllComponentsFromName($entityName:String):void;
		/**
		 * Add Component To Family
		 */
		function addComponentToFamily($component:Component):void;
		/**
		 * Has Component To Family
		 */
		function hasComponentFromFamily($family:Class):Boolean ;
		/**
		 * Remove Component From Family
		 */
		function removeComponentFromFamily($component:Component):void;
		/**
		 * Get Component
		 */
		function getComponent($entityName:String,$componentName:String):Component;
		/**
		 * Get Components From Family
		 */
		function getComponentsFromFamily($family:Class):Vector.<Component>;
		/**
		 * Register Property
		 */
		function registerProperty($propertyName:String, $component:Component):void;
		/**
		 * Get Component Registering the Property
		 */
		function unregisterProperty($propertyName:String, $component:Component):void;
		/**
		 * Get Component Registering the Property
		 */
		function getComponentRegisteringProperty($propertyName:String):Component;
		/**
		 * Register Property Reference
		 */
		function registerPropertyReference($propertyName:String, $component:Component, $param:Object=null):void;
		/**
		 * Unregister Property Reference
		 */
		function unregisterPropertyReference($propertyName:String, $component:Component):void;
		/**
		 * Actualize Component
		 */
		function actualizeComponent($propertyName:String,$component:Component, $param:Object=null):void;
		/**
		 * Add Component Folder
		 */
		function addComponentFolder($folderPath:String):void;
		
	}
}