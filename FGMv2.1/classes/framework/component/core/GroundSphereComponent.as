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
	import framework.entity.*;

	/**
	* GroundSphere Component
	* @ 
	*/
	public class GroundSphereComponent extends GraphicComponent {

		public function GroundSphereComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {

		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Rotate Graphic  ------------------------------------
		public function rotate():void {
//			if (_spatial_rotation!=0) {
//				var mySwfPlayerComponent:SwfPlayerComponent = entity.getComponent("mySwfPlayerComponent") as SwfPlayerComponent;
//				if (mySwfPlayerComponent!=null) {
//					if (mySwfPlayerComponent._spatial_position.x-mySwfPlayerComponent.width<=10||mySwfPlayerComponent._spatial_position.x+mySwfPlayerComponent.width>=350) {
//						this.rotation+=_spatial_rotation/2;
//					}
//				}
//			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}