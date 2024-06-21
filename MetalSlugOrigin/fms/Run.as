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
package fms{
	import flash.events.Event;
	
	import framework.component.core.*;
	import framework.entity.*;
	
	import customClasses.*;
	
	import utils.keyboard.KeyPad;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;

	public class Run extends MS_State{
		
		//Run State
		public function Run(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_name = "Run";
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Run");
			if (!_object.bitmapSet)	return;
			var keyPad:KeyPad = _object.keyPad;
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Run");
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			updateSpeed();
			if(keyPad.up.isDown){
				move(_object.spatialMove.facingDir.x,0);
			}else if(keyPad.down.isDown){
				move(_object.spatialMove.facingDir.x,0);
			}else{
				move(_object.spatialMove.facingDir.x,0);
			}
			var x:Number =_object.spatialMove.facingDir.x;
			if(keyPad.right.isDown){
				x = 1;
			}else if(keyPad.left.isDown){
				x=-1;
			}
			if(keyPad.fire1.isDown && !keyPad.fire1.getLongClick()){
				updateAnim(frame.hit_a);
				updateState();
			}else if(keyPad.fire2.isDown && !keyPad.fire2.getLongClick()){
				updateAnim(frame.hit_j);
				updateState();
			}else if(keyPad.fire3.isDown && !keyPad.fire3.getLongClick()){
				updateAnim(frame.hit_d);
				updateState();
			}else if(_object.spatialMove.facingDir.x!=x){
				updateAnim(frame.next);
				updateState();
			}
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit Run");
		}
	}
}