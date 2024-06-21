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

package framework.component.core{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import framework.Framework;
	import framework.component.*;
	import framework.entity.*;

	/**
	* Navigation Component Class
	*
	*
	*/
	public class NavigationComponent extends GraphicComponent {

		private var _entityManager:IEntityManager=null;
		private var _startBt:SimpleButton=null;
		private var _scriptName:String=null;
		private var _label:TextField=null;

		public function NavigationComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		override protected function initVar($prop:Object):void {
			super.initVar($prop);
			_entityManager=EntityManager.getInstance();
		}
		//------- Set Script -------------------------------
		public function setScript(scriptName:String):void {
			_scriptName=scriptName;
		}
		//------- Lauch Script -------------------------------
		public function launchScript():void {
			if (_scriptName!=null) {
				var classRef:Class = getClass(_scriptName);
				new classRef();
				Framework.Focus();
				entity.removeComponentFromName(_componentName);
			}
		}
		//------- On Start -------------------------------
		private function onStart(evt:MouseEvent):void {
			launchScript();
		}
		//------ Gets class name from instance ------------------------------------
		private function getClass(scriptName:String):Class {
			var classRef:Class=getDefinitionByName("script."+scriptName) as Class;
			return (classRef);
		}
		//------ Reset  ------------------------------------
		public function reset(ownerName:String,componentName:String):void {
			_startBt.removeEventListener(MouseEvent.CLICK, onStart);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}