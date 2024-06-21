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
	
	import utils.time.Time;

	public class BitmapAnim{
		
		public var name:String;
		private var _list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
		private var _position:int=0;
		private var _fps:int = 30;
		private var _lastAnim:Number=0;			//Time of the last animation
		private var _endAnim:Boolean = false; 	//If true finish the animation (jump, slide, attack...)
		private var _autoAnim:Boolean = true; 	//If true auto anim
		private var _reverse:Number = 0;	// Permits to have a forward backward animation (very usefull to walk): 0 false, 1 forward and -1 backward
		private var _nextPose:String;
		private var _iteration:Number=0;
		private var _timeMultiplicator:Number=1;
		
		public function BitmapAnim($name:String, $list:Vector.<BitmapCell> , $position:int=0, $fps:int=30, $nextPose:String =null, $reverse:Number=0,$endAnim:Boolean = false,$autoAnim:Boolean=true,$timeMultiplicator:Number=1){
			_initVar($name,$list,$position, $fps, $nextPose, $reverse,$endAnim,$autoAnim,$timeMultiplicator);
		}
		//------ Init Var ------------------------------------
		private function _initVar($name:String, $list:Vector.<BitmapCell>,  $position:int, $fps:int, $nextPose:String, $reverse:Number, $endAnim:Boolean,$autoAnim:Boolean,$timeMultiplicator:Number):void {
			name 		= $name
			if($list)	_list = $list;
			_position 	= $position;
			_fps 		= $fps
			_nextPose	= $nextPose;
			_reverse 	= $reverse;
			_endAnim 	= $endAnim;
			_autoAnim 	= $autoAnim;
			_timeMultiplicator = $timeMultiplicator;
		}
		//------ Get Cell ------------------------------------
		public function getCell():BitmapCell {
			return _list[_position];
		}
		//------ Next ------------------------------------
		public function next():BitmapCell {
			//trace(readyToAnim(),_position,_list.length-1,_reverse);
			if(_list.length>1 && readyToAnim()){
				if(_position<_list.length-1 && _reverse!=-1){
					_position++;
				}else if (_position==_list.length-1 && _reverse==1){
					_reverse=-1;	
					_position--;
				}else if (_position>0 && _reverse==-1){
					_position--;	
				}else if (_position==0 && _reverse==-1){
					_reverse=1;	
					_position++;
				}else{
					_position =0;
				}
				_lastAnim = Time.GetTime();
			}
			return getCell();
		}
		//------ Prev ------------------------------------
		public function prev():BitmapCell {
			//To be adjusted to handle reverse like next
			if(_list.length>1 && readyToAnim()){
				if(_position==0){
					_position = _list.length-1;
				}else{
					_position--;	
				}
				_lastAnim = Time.GetTime();
			}
			return getCell();
		}
		//------ Next ------------------------------------
		public function readyToAnim():Boolean {
			var wait:int = getCell().wait;
			wait*=_timeMultiplicator;
			//wait=1000;
			if(wait==0 && _fps==0){
				return true;
			}
			if(_fps>0){
				var delay:Number = Math.round(1000/_fps);
			}else{
				delay =0;
			}
			var now:Number = Time.GetTime();
			var duration:Number = now-_lastAnim;
			//trace(duration < delay+wait, duration,now,_lastAnim, delay+wait,duration < delay+wait);
			if(duration < delay+wait){
				_iteration++;
				return false;
			}
			_iteration=0;
			return true;
		}
		//------ GETTER ------------------------------------
		public function get position():int {
			return _position;	
		}
		public function get nextPose():String {
			return _nextPose;	
		}
		public function get lastPosition():int {
			return _list.length-1;	
		}
		public function get endAnim():Boolean {
			return _endAnim;	
		}
		public function get autoAnim():Boolean {
			return _autoAnim;	
		}
		public function get reverse():Number {
			return _reverse;	
		}
		//------ Setter ------------------------------------
		public function set position($position:int):void {
			_lastAnim = Time.GetTime();
			_position=$position;	
		}
		public function set nextPose($nextPose:String):void {
			_nextPose=$nextPose;	
		}
		public function set endAnim($endAnim:Boolean):void {
			_endAnim=$endAnim;	
		}
		public function set autoAnim($autoAnim:Boolean):void {
			_autoAnim=$autoAnim;	
		}
		public function set lastAnim($lastAnim:Number):void {
			_lastAnim=$lastAnim;	
		}
		public function set reverse($reverse:Number):void {
			_reverse=$reverse;	
		}
		public function get list():Vector.<BitmapCell> {
			return _list;	
		}
		public function get iteration():Number {
			return _iteration;	
		}
		public function set timeMultiplicator($timeMultiplicator:Number):void {
			_timeMultiplicator=$timeMultiplicator;	
		}
	}
}