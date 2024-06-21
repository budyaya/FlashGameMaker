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
	import framework.component.add.*;
	import framework.component.core.*;
	
	
	/**
	* Component Reference Class
	* 
	*/
	public class ComponentReference{

		public function ComponentReference() {
			initReference();
		}
		//------ Init Reference ------------------------------------
		private function initReference():void {
			//-- In order to import your component  classes in the compiled SWF and use them at runtime --
			//-- please insert your component classes here as follow --
			var animationComponent:AnimationComponent;
			var bitmapAnimComponent:BitmapAnimComponent;
			var cursorComponent:CursorComponent;
			var chronoComponent:ChronoComponent;
			var enterFrameComponent:EnterFrameComponent;
			var graphicComponent:GraphicComponent;
			var gamePadComponent:GamePadComponent;
			var groundSphereComponent:GroundSphereComponent;
			var jaugeMoveComponent:JaugeMoveComponent;
			var keyboardInputComponent:KeyboardInputComponent;
			var keyboardMoveComponent:KeyboardMoveComponent;
			var keyboardJaugeMoveComponent:KeyboardJaugeMoveComponent;
			var mouseInputComponent:MouseInputComponent;
			var navigationComponent:NavigationComponent;
			var preloaderComponent:PreloaderComponent;
			var renderComponent:RenderComponent;
			var scrollingBitmapComponent:ScrollingBitmapComponent;
			var simpleGraphicComponent:SimpleGraphicComponent;
			var soundComponent:SoundComponent;
			var snowComponent:SnowComponent;
			var systemInfoComponent:SystemInfoComponent;
			var textComponent:TextComponent;
			var timeComponent:TimeComponent;
			var timerComponent:TimerComponent;
			var zoomComponent:ZoomComponent;
		}
	}
}