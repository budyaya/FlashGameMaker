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

package framework.component{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.component.core.SystemInfoComponent;
	import framework.entity.*;

	/**
	* Component Class
	*/
	public dynamic class Component extends Sprite implements IComponent{
		protected var _debugMode:Boolean = false;
		protected var _componentName:String;
		protected var _entity:IEntity = null;
		protected var _properties:Dictionary = null;
		protected var _propertyReferences:Dictionary = null;
		protected var _singleton:Boolean = false; //If Yes only 1 component can be instanciated within an Entity
		protected var _prop:Object = {};
		protected var _functions:Array;//Prototype: {executeOnlyIfDisplayed:true,callback:functionToExecute,parameters:[]}
		public function Component($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			if ($entity == null) {
				throw new Error("Error: Component must have a non null Entity !!!");
			}
			initVar($componentName, $entity, $singleton);
		}
		//------ Init Var ------------------------------------
		private function initVar($componentName:String, $entity:IEntity,  $singleton:Boolean):void {
			_debugMode = Framework.debugMode;
			_componentName = $componentName;
			_entity = $entity;
			_properties = new Dictionary(true);	
			_propertyReferences = new Dictionary(true);
			_singleton = $singleton;
		}
		//------ Init Property  ------------------------------------
		public function initProperty():void {
			//	Overrided
		}
		//------ Register Property  ------------------------------------
		public function registerProperty($propertyName:String):void {
			_properties[$propertyName]= {name:$propertyName, components:new Vector.<Object>};
			_entity.entityManager.registerProperty($propertyName, this);
		}
		//------- Remove Property -------------------------------
		public function unregisterProperty($propertyName:String):void {
			_entity.entityManager.unregisterProperty($propertyName,this);
			_properties[$propertyName] = null;
			delete _properties[$propertyName];
		}
		//------- Add Property Components --------------------------
		//After a component register to a property he needs to be added to the register if it exists
		public function registerComponent($propertyName:String, $component:Component, $param:Object=null):void {
			for each (var object:Object in _properties[$propertyName].components){
				if(object.component == $component){
					return
				}
			}
			_properties[$propertyName].components.push({component:$component, param:$param});
			actualizePropertyComponent($propertyName, $component, $param);
		}
		//------- Add Property Components --------------------------
		//After registering EntityManager callback this function to populate properties with existent registered component to the property
		public function addPreRegisteredComponents($propertyName:String, $components:Vector.<Object>):void {
			if($components){
				_properties[$propertyName].components=$components;
				actualizeProperty($propertyName);
			}
		}
		//------- Actualize Property -------------------------------
		//Called the component is registering a new property if some components are already in the pool of registered
		public function actualizeProperty($propertyName:String):void {
			var components:Vector.<Object> = _properties[$propertyName].components;
			for each (var object:Object in components){
				actualizePropertyComponent($propertyName, object.component,object.param);
			}
		}
		//------- Actualize Property -------------------------------
		//need to be overwritted by register component such as render, spatial
		public function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
		}
		//------- Remove Property Component -------------------------------
		//Called when a component is registered to a property and decide to unregister its propertyReference
		public function removePropertyComponent($propertyName:String, $component:Component):void {
			var property:Object = _properties[$propertyName];
			if(!property){
				throw new Error("Error:The component "+componentName+" is not registering the property "+$propertyName+" !!");
			}
			for each(var object:Object in property.components){
				if(object.component == $component){
					var index:int = property.components.lastIndexOf(object);
					_properties[$propertyName].components.splice(index,1);
					return;
				}
			}
		}
		//------ Actualize  ------------------------------------
		//When component need the register to update him as with spatial
		public function actualize($propertyName:String):void {
			_entity.entityManager.actualizeComponent($propertyName, this)
		}
		//------ Actualize Components  ------------------------------------
		//Call back from the register component in need to be actualize
		public function actualizeComponent($propertyName:String, component:Component):void {
			
		}
		//------ Set Property Reference ------------------------------------
		public function registerPropertyReference($propertyName:String, $param:Object=null):void {
			_entity.entityManager.registerPropertyReference($propertyName, this, $param);
			_propertyReferences[$propertyName] = {name:$propertyName, param:$param};
		}
		//------ Unregister Property Reference ------------------------------------
		public function unregisterPropertyReference($propertyName:String):void {
			_entity.entityManager.unregisterPropertyReference($propertyName,this);
			if(!_propertyReferences[$propertyName]){
				trace("[Warning] Error:The component "+componentName+" is not registered to the property "+$propertyName+" !!");
			}else{
				delete _propertyReferences[$propertyName];
			}
		}
		//------ Unregister Component ------------------------------------
		public function unregister():void {
			_entity.entityManager.removeComponentFromFamily(this);
			for each(var property:Object in _properties){
				unregisterProperty(property.name);
			}
			for each(var propertyReference:Object in _propertyReferences){
				unregisterPropertyReference(propertyReference.name);
			}
			_entity = null;
		}
		//------ Remove Component From Name-----------------------------------
		public function removeComponentFromName():void {
			_entity.removeComponentFromName(_componentName);
		}
		//------ Get Component Name  ------------------------------------
		public function get componentName():String {
			return _componentName;
		}
		//------- Get Singleton -------------------------------
		public function get singleton():Boolean {
			return _singleton;
		}
		//------- Get/Set Component Owner -------------------------------
		public function get entity():IEntity {
			return _entity;
		}
		public function set entity($entity:IEntity):void {
			 _entity = $entity;
		}
		//------- Get Owner Name -------------------------------
		public function get entityName():String {
			return _entity.entityName;
		}	
		//------ Get Property Reference  ------------------------------------
		public function get propertyReferences():Dictionary {
			return _propertyReferences;
		}
		//------ Get Properties  ------------------------------------
		protected function get properties():Dictionary {
			return _properties;
		}
		//------ Get Debug Mode  ------------------------------------
		protected function get debugMode():Boolean {
			return _debugMode;
		}
		//------- Get Matrix -------------------------------
		public function get matrix():Matrix{
			return transform.matrix;
		}
		//------- Get Color Transform -------------------------------
		public function get colorTransform():ColorTransform{
			return transform.colorTransform;
		}
		//------ Clone  ------------------------------------
		public function clone():Component {
			//To be overwritted
			return null;
		}
		//------ Destroy  ------------------------------------
		public function destroy():void {
			if(parent){
				Framework.RemoveChild(this,parent);
			}
			if(_entity){
				_entity.removeComponent(this);
				unregister();
			}
		}
		//------ Destroys  ------------------------------------
		public static function DestroyComponents($components:Array):void {
			for each (var component:Component in $components){
				component.destroy();
				component = null;
			}
		}
		//------ Get Prop  ------------------------------------
		public function get prop():Object {
			return _prop;
		}
		//------- Get Functions -------------------------------
		public function get functions():Array{
			return _functions
		}
		//------- Push Function -------------------------------
		public function pushFunction($function:Object):void{
			if(!_functions)	_functions = new Array;
			_functions.push($function);
		}
		//------- Unshift Function -------------------------------
		public function unshiftFunction($function:Object):void{
			if(!_functions)	_functions = new Array;
			_functions.unshift($function);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_componentName, entityName);
		}
		
	}
}