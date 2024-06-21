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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import framework.component.*;

	/**
	 * EntityManager manages the Entity and Components
	 * @author Tom Davies
	 */
	public class EntityManager implements IEntityManager {
		private static var _instance:IEntityManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _componentFolders:Array = null
		
		private var _index:Number = 0;
		private var _entities:Dictionary=null;		// List of entities
		private var _families:Dictionary=null;		// List of component listed by Class
		private var _properties:Dictionary=null;	// List of component having registered a property such as render
		
		public function EntityManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use EntityManager.getInstance() instead of new.");
			}
			_initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IEntityManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance = new EntityManager();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entities = new Dictionary(); 	
			_families = new Dictionary(); 	
			_properties = new Dictionary();	
			_componentFolders = ["framework.component.core.","framework.component.add.","framework.component."]
		}
		//------ Create Entity ------------------------------------
		public function createEntity($entityName:String):IEntity {
			if (_entities[$entityName]!=null) {
				trace("Warning: An Entity already exist with the name "+$entityName+" !!");
				return _entities[$entityName];
			}
			var entity:IEntity = new Entity($entityName,_instance) as IEntity;
			_entities[$entityName]=entity;
			return entity;
		}
		//------ Remove Entity ------------------------------------
		public function removeEntity($entityName:String):void {
			_entities[$entityName] = null;
			delete _entities[$entityName];
		}
		//------ Add Component ------------------------------------
		public function addComponent($entity:IEntity,$component:Component):void {
			var components:Dictionary = $entity.components;
			var componentName:String = $component.componentName;
			var entityName:String = $entity.entityName;
			if (components[componentName]!=null) {
				throw new Error("Error: A Component already exist with the name "+componentName+" within the entity "+entityName+" !!");
			}
			if ($component.entity !=null) {
				throw new Error("Error: the Component "+componentName+" belongs to the entity "+entityName+". Please remove first  !!");
			}
			$component.entity = $entity;
			components[componentName]=$component;
			addComponentToFamily($component);
			$component.initProperty();
		}
		//------ Add Component From Name------------------------------------
		public function addComponentFromName($entityName:String,$componentName:String,$newName:String=null, $prop:Object=null, $singleton:Boolean=false):Component {
			if(!$newName) $newName = getNewInstanceName();
			var entity:IEntity=_entities[$entityName];
			if (entity==null) {
				throw new Error("Error: The entity "+$entityName+" doesn't exist!!\n Impossible to add the component"+$componentName);
			}
			var components:Dictionary=entity.components;
			
			var classRef:Class=getClass($componentName);
			var family:Vector.<Component> = getComponentsFromFamily(classRef)
			if (family!=null && family.length>0 && family[0].singleton) {
				trace("Warning: A Component already exist with the family "+classRef+" and is a singleton !!");
				return family[0];
			}
			var component:Component=new classRef($newName, entity, $singleton, $prop);
			if (components[$newName]!=null) {
				throw new Error("Error: A Component already exist with the name "+$newName+" within the entity "+$entityName+" !!");
			}
			components[$newName] = component;
			addComponentToFamily(component);
			component.initProperty();
			return component;
		}
		//------ Remove Component ------------------------------------
		public function removeComponent($component:Component):void {
			$component.unregister();
			$component.entity.removeComponent($component);
		}
		//------ Remove Component From Name------------------------------------
		public function removeComponentFromName($entityName:String,$componentName:String):void {
			var component:Component = getComponent($entityName,$componentName);
			removeComponent(component);
		}
		//------ Remove All Components ------------------------------------
		public function removeAllComponents($entity:IEntity):void {
			if($entity){
				for each(var component:Component in $entity.components){
					removeComponent(component);
				}
			}
		}
		//------ Remove All Components From Name------------------------------------
		public function removeAllComponentsFromName($entityName:String):void {
			var entity:IEntity = _entities[$entityName];
			removeAllComponents(entity);
		}
		//------ Add Component To Family------------------------------------
		public function addComponentToFamily($component:Component):void {
			var family:Class = Object($component).constructor;
			if (_families[family]==null) {
				_families[family] = new Vector.<Component>;
				_families[family].push($component);
			}else{
				var familyList:Vector.<Component> =_families[family];
				if(familyList.indexOf($component)!=-1){
					throw new Error("Error: The component "+$component.componentName+" is already inside family "+family+" !!");
				}
				familyList.push($component);
			}
		}
		//------ Has Component To Family------------------------------------
		public function hasComponentFromFamily($family:Class):Boolean {
			if (_families[$family]) {
				return true;
			}
			return false;
		}
		//------ Remove Component From Family------------------------------------
		public function removeComponentFromFamily($component:Component):void {
			var family:Class = Object($component).constructor;
			if (_families[family]!=null) {
				var familyList:Vector.<Component> =_families[family];
				var componentIndex:int = familyList.indexOf($component);
				if(componentIndex!=-1){
					familyList.splice(componentIndex,1);
				}
			}
		}
		//------ Get Component ------------------------------------
		public function getComponent($entityName:String,$componentName:String):Component {
			var entity:IEntity=_entities[$entityName];
			if (_entities[$entityName]==null) {
				throw new Error("Error:The entity with the name "+$entityName+" doesn't exist!!");
			}
			var components:Dictionary=entity.components;
			var component:Component = components[$componentName] as Component;
			if (component==null) {
				throw new Error("Error:The component with the name "+$componentName+" doesn't belong to the entity "+$entityName+" !!");
			}
			return component;
		}
		//------ Get Components From Family ------------------------------------
		public function getComponentsFromFamily($family:Class):Vector.<Component> {
			var familyList:Vector.<Component> = _families[$family];
			return familyList;
		}
		//------ Register Property ------------------------------------
		public function registerProperty($propertyName:String, $component:Component):void {
			var property:Object = _properties[$propertyName];
			if (property != null) {
				var register:Component = property.register;
				if(register!=null){
					//throw new Error("Error: The component "+register.componentName+" already registers the property "+$propertyName+" !!");
					return;
				}
				property.register = $component;
				$component.addPreRegisteredComponents($propertyName, property.components);
			}else{
				_properties[$propertyName] = {register:$component, components:new Vector.<Object>};
			}			
		}	
		//------ Unregister Property ------------------------------------
		public function unregisterProperty($propertyName:String, $component:Component):void {
			var property:Object = _properties[$propertyName];
			if (property == null || property.register!=$component) {
				throw new Error("Error: The component"+$component.componentName+" is not registering the property "+$propertyName+" !!");
			}
			_properties[$propertyName].register = null;	
		}
		//------ Get Component Registering the Property ------------------------------------
		public function getComponentRegisteringProperty($propertyName:String):Component {
			var component:Component = _properties[$propertyName];
			if (component==null) {
				throw new Error("Error: The property "+$propertyName+" has not been registered !!");
			}
			return component;
		}
		//------ Register Property Reference ------------------------------------
		public function registerPropertyReference($propertyName:String, $component:Component, $param:Object=null):void {
			var property:Object = _properties[$propertyName];
			if (property==null) {
				var component:Vector.<Object> = new Vector.<Object>;
				component.push({component:$component, param:$param})
				_properties[$propertyName] = {register:null, components:component};
			}else{
				if (property.components.indexOf({component:$component, param:$param})!=-1) {
					throw new Error("Error: The component "+$propertyName+" is already registered to the property "+$propertyName+" !!");
				}
				_properties[$propertyName].components.push({component:$component,param:$param});
				if(_properties[$propertyName].register){
					_properties[$propertyName].register.registerComponent($propertyName, $component, $param);
				}
			}			
		}
		//------ Unregister Property Reference ------------------------------------
		public function unregisterPropertyReference($propertyName:String, $component:Component):void {
			var property:Object = _properties[$propertyName];
			if (property==null) {
				throw new Error("Error:No components have registered to the property "+$propertyName+" !!");
			}
			for each(var object:Object in property.components){
				if (object.component == $component){
					var index:int = property.components.indexOf(object);
					_properties[$propertyName].components.splice(index,1);
					if(_properties[$propertyName].register){
						_properties[$propertyName].register.removePropertyComponent($propertyName,$component);
					}
					return;
				}
			}
		}
		//------ Unregister Property Reference ------------------------------------
		public function actualizeComponent($propertyName:String,$component:Component, $param:Object=null):void {
			var property:Object = _properties[$propertyName];
			if($component.propertyReferences[$propertyName] == undefined){
				throw new Error("Error:The component "+$component.componentName+" is not registered to the property "+$propertyName+". Please registerReference before actualize !!");
			}
			if(property && property.register){
				property.register.actualizePropertyComponent($propertyName,$component,$param);
			}
		}
		//------ Gets class name from instance ------------------------------------
		private function getClass($componentName:String):Class {
			var classRef:Class = null;
			for each (var componentFolder:String in _componentFolders){
				try{
					classRef=getDefinitionByName(componentFolder+$componentName) as Class;
				}catch (e:Error){
					continue
				}
				return (classRef);
			}
			throw new Error("EntityManager: getClass couldn't find the component "+$componentName);
			return null;
		}
		//------ Get New Instance Name------------------------------------
		private function getNewInstanceName():String {
			_index++;
			return "instance_"+_index;
		}
		//------ Add Component Folder------------------------------------
		public function addComponentFolder($folderPath:String):void {
			//folderPath must terminate by a "."
			_componentFolders.push($folderPath);
		}
	}
}