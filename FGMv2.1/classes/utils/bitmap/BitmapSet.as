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
package utils.bitmap{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public class BitmapSet{
		
		public var bitmap:Bitmap = null;
		public var graph:BitmapGraph;
		public var flip:Boolean = false;
		
		public function BitmapSet($bitmap:DisplayObject, $graph:BitmapGraph = null){
			_initVar($bitmap,$graph);
		}
		//------ Init Var ------------------------------------
		protected function _initVar($bitmap:DisplayObject,$graph:BitmapGraph):void {
			bitmap = $bitmap as Bitmap;
			if($graph){
				graph = $graph;
			}else{
				graph = new BitmapGraph;
			}
		}
		//------ Get Position ------------------------------------
		public function get position():BitmapCell {
			return graph.currentPosition;
		}
		//------- Get Anim With Name -------------------------------
		public function getAnimWithName($animName:String):BitmapAnim {
			return graph.animations[$animName];
		}
		//------- Get CurrentAnim -------------------------------
		public function get currentAnim():BitmapAnim {
			return graph.currentAnim;
		}
		//------- Get CurrentAnim -------------------------------
		public function get readyToAnim():Boolean {
			if(!graph.currentAnim)	return false;
			return graph.currentAnim.readyToAnim();
		}
		//------- Get CurrentAnim -------------------------------
		public function get currentAnimName():String {
			if(!graph.currentAnim)	return null;
			return graph.currentAnim.name;
		}
		//------- Get PrevAnim -------------------------------
		public function get previousAnimName():String {
			if(!graph.previousAnim)	return null;
			return graph.previousAnim.name;
		}
		//------- Get AutoAnim -------------------------------
		public function get currentPoseName():String {
			return graph.currentPose;
		}
		//------- Get Prev Pose -------------------------------
		public function get previousPoseName():String {
			return graph.previousPose;
		}
		//------- Get Position -------------------------------
		public function get currentPosition():int {
			if(!graph.currentAnim)	return 0;
			return graph.currentAnim.position;
		}
		//------- Get LastFrame -------------------------------
		public function get lastPosition():int {
			if(!graph.currentAnim)	return 0;
			return graph.currentAnim.lastPosition;
		}
		//------- Get Reverse -------------------------------
		public function get reverse():int {
			if(!graph.currentAnim)	return 0;
			return graph.currentAnim.reverse;
		}
		//------- Get EndAnim -------------------------------
		public function get endAnim():Boolean {
			if(!graph.currentAnim)	return false;
			return graph.currentAnim.endAnim;
		}
		//------ Update ------------------------------------
		public function  update():void {
			
		}
	}
}