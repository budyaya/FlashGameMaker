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
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import utils.time.Time;

	public class BitmapGraph extends EventDispatcher{
		
		public var animations:Dictionary;
		public var poses:Dictionary; // Sequence of animation
		public var currentPosition:BitmapCell;
		public var currentAnim:BitmapAnim;
		public var previousAnim:BitmapAnim = null;
		public var currentPose:String;
		public var previousPose:String;
		private var _realDisp:MovieClip = null;
		
		public function BitmapGraph($realDisp:MovieClip=null){
			_initVar($realDisp);
		}
		//------ Init Var ------------------------------------
		private function _initVar($realDisp:MovieClip):void {
			_realDisp = $realDisp;
			animations 	= new Dictionary;
			poses 		= new Dictionary;
		}
		//------ Create Graph ------------------------------------
		public function createGraph($name:String,$column:int,$row:int, $cellWidth:Number, $cellHeight:Number,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $numFrame:int=0 ,$position:int=0):void {
			if(animations[$name]){
				throw new Error(" An animation already exist with the name: "+$name);
			}
			animations[$name] = createAnim($name,$column,$row,$cellWidth,$cellHeight,$waits,$offsets,$numFrame, $position);
			currentPosition = animations[$name].getCell();
		}
		//------ Create Classic Graph ------------------------------------
		public function createSimpleGraph():void {
			initAnimation("STAND", 0,0);
			initAnimation("WALK",  0,1);
			initAnimation("JUMP",  0,2);
			initAnimation("FALL",  0,3);
			currentAnim = animations["STAND_RIGHT"];
			currentPosition = currentAnim.getCell();
		}
		//------ Init Animation ------------------------------------
		public function initAnimation($name:String, $row:int, $col:int, $cellWidth:Number=64, $cellHeight:Number=64,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null,$offsetY:Number=0, $numFrame:int=4,$position:int=0,$fps:int=0,$reverse:Number=0,$endAnim:Boolean=false,$autoAnim:Boolean=true):void {
			animations[$name+"_RIGHT"]	= createAnim($name+"_RIGHT",$row,$col,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
			animations[$name+"_LEFT"]	= createAnim($name+"_DOWN",	$row+4,$col,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
			animations[$name+"_UP"]		= createAnim($name+"_LEFT",	$row+8,$col,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
			animations[$name+"_DOWN"]	= createAnim($name+"_UP",	$row+12,$col,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
			if(!currentAnim){
				currentAnim = animations[$name+"_RIGHT"];
				currentPosition = currentAnim.getCell();
			}
		}
		//------ Init Single Animation ------------------------------------
		public function initSingleAnimation($name:String, $row:int, $col:int, $cellWidth:Number=64, $cellHeight:Number=64,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $numFrame:int=4,$position:int=0,$fps:int=0,$reverse:Number=0,$endAnim:Boolean=false,$autoAnim:Boolean=true):void {
			animations[$name]	= createAnim($name,$row,$col,$cellWidth,$cellHeight,$waits,$offsets,$numFrame,$position,$fps,$reverse,$endAnim,$autoAnim);
			if(!currentAnim){
				currentAnim = animations[$name];
				currentPosition = currentAnim.getCell();
			}
		}
		//------ Init Frame Animation ------------------------------------
		public function initFrameAnimation($name:String, $frames:Vector.<Point>, $cellWidth:Number=64, $cellHeight:Number=64,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $position:int=0,$fps:int=0,$reverse:Number=0,$endAnim:Boolean=false,$autoAnim:Boolean=true):void {
			animations[$name]	= createFrameAnim($name,$frames,$cellWidth,$cellHeight,$waits,$offsets,$position,$fps,$reverse,$endAnim,$autoAnim);
			//Frames are a list of Point(x,y) pointing at a frame
			if(!currentAnim){
				currentAnim = animations[$name];
				currentPosition = currentAnim.getCell();
			}
		}//------ Create Anim ------------------------------------
		public function createEmptyAnimation($name:String, $cellWidth:Number, $cellHeight:Number,$position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false,$autoAnim:Boolean=true):void {
			animations[$name] = new BitmapAnim($name, null, $position, $fps, null, $reverse, $endAnim,$autoAnim);
			if(!currentAnim){
				currentAnim = animations[$name];
			}
		}
		//------ Create Anim ------------------------------------
		public function createAnim($name:String,  $column:int, $row:int, $cellWidth:Number, $cellHeight:Number,$waits:Vector.<int>,$offsets:Vector.<Point>=null, $numFrame:int=0,$position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false,$autoAnim:Boolean=true):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			var cell:BitmapCell;
			var x:Number, y:Number;
			for(var i:int =0; i<$numFrame; i++){
				x = $column*$cellWidth+$cellWidth*i;
				y = $row*$cellHeight;
				cell = new BitmapCell(null, x , y, $cellWidth, $cellHeight);
				if($waits)	cell.wait = $waits[i];
				if($offsets && i<$offsets.length && $offsets[i]){
					cell.offsetX = $offsets[i].x;
					cell.offsetY = $offsets[i].y;
				}
				list.push(cell);
			}
			//trace($name, list.length, $numFrame,$position);
			return new BitmapAnim($name, list, $position, $fps,null, $reverse, $endAnim,$autoAnim);
		}
		//------ Create Frame Anim ------------------------------------
		public function createFrameAnim($name:String,  $frames:Vector.<Point>, $cellWidth:Number, $cellHeight:Number,$waits:Vector.<int>=null,$offsets:Vector.<Point>=null, $position:int=0,$fps:int=0, $reverse:Number=0,$endAnim:Boolean = false,$autoAnim:Boolean=true):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			var cell:BitmapCell;
			var x:Number, y:Number,i:Number;
			for each(var frame:Point in $frames){
				x = frame.x*$cellWidth;
				y = frame.y*$cellHeight;
				cell = new BitmapCell(null, x , y, $cellWidth, $cellHeight);
				i = $frames.indexOf(frame);
				if($offsets && i<$offsets.length && $offsets[i]){
					cell.offsetX = $offsets[i].x;
					cell.offsetY = $offsets[i].y;
				}
				list.push(cell);
			}
			//trace($name, list.length, $numFrame,$position);
			return new BitmapAnim($name, list, $position, $fps,null, $reverse, $endAnim,$autoAnim);
		}
		//------ Create Classic Graph ------------------------------------
		public function anim($anim:String=null, $inversed:Boolean = false):void{
			if(!currentAnim)	return;
			if(!$anim){
				$anim = currentAnim.name;
			}
			//trace(currentAnim.name,$anim, currentAnim.position, currentAnim.lastPosition ,currentAnim.reverse, currentAnim.endAnim );
			if(!currentAnim.autoAnim && !currentPosition.next && currentAnim == animations[$anim] ||  currentAnim.endAnim && (currentAnim.position == currentAnim.lastPosition && currentAnim.reverse==0 || currentAnim.position == 0 && currentAnim.reverse==-1) && currentAnim == animations[$anim])
				return; //End the animation
			if(currentAnim.position == currentAnim.lastPosition && currentAnim.nextPose){
				currentAnim.position = 0;
				previousAnim = currentAnim;
				previousPose = currentPose;
				currentPose = currentAnim.nextPose;
				currentAnim = getAnimFromPose(currentPose);
				currentPosition = currentAnim.getCell();
				if(_realDisp)		_realDisp.gotoAndStop(currentAnim.name);
				
				return
			}else if(currentAnim != animations[$anim]){
				currentAnim.position = 0;
				previousAnim = currentAnim;
				currentAnim = animations[$anim]	;
				currentAnim.lastAnim = Time.GetTime();
				currentPosition = currentAnim.getCell();
				if(currentAnim.reverse==-1)		currentAnim.reverse=1;
				if(_realDisp)		_realDisp.gotoAndStop(currentAnim.name);
				return; 
			}
			if(currentAnim && currentAnim.autoAnim && $inversed){
				currentPosition = currentAnim.prev();
				if(_realDisp)		_realDisp.prevFrame();
			}else if (currentAnim && currentAnim.autoAnim){
				currentPosition = currentAnim.next();
				if(_realDisp)	_realDisp.nextFrame();
			}else if(currentAnim && !currentAnim.autoAnim && currentPosition.next && currentAnim.readyToAnim()){
				currentPosition = currentPosition.next;
			}else{
				trace("Warning: currentAnim is undefined");
			}
			
		}
		//------ Create Classic Graph ------------------------------------
		public function reset():void{
			currentAnim.position = 0;
			currentPosition = currentAnim.getCell();
			if(_realDisp)		_realDisp.gotoAndStop(currentAnim.name);
		}
		//------ Create Simple Sequence ------------------------------------
		public function createSimpleSequence():void {
			poses = new Dictionary;
			currentPose = "POSE_IDLE";
			poses[currentPose] = new Array();
			for each(var bitmapAnim:BitmapAnim in animations){
				bitmapAnim.nextPose = "POSE_IDLE";
				poses[currentPose].push(bitmapAnim);
			}
		}
		//------ Create Sequence ------------------------------------
		private function _createSequence($poses:Array):void {
			// Example
			/*var poses:Array = [
				{name:"POSE_IDLE", 		animations:[{name:"IDLE", frequency:3} , {name:"JUMP", frequency:1}]},
				{name:"POSE_IDLE_RUN", 	animations:[{name:"IDLE_RUN", frequency:1}]},
				{name:"POSE_RUN", 		animations:[{name:"RUN", frequency:2} , {name:"RUN_IDLE", frequency:1}]},
			];
			setPoses(poses);
			*/
			poses = new Dictionary(true);
			currentPose = $poses[0].name;
			for each(var pose:Object in $poses){
				var poseName:String = pose.name;
				var anims:Object = pose.animations;
				poses[poseName] = new Array();
				for each(var anim:Object in anims){
					var animName:String = anim.name;
					var frequency:int = anim.f;
					if(anims.length==1)		frequency=1;
					for (var i:int=0;i<frequency;i++){
						poses[poseName].push(animations[animName]);
					}
				}
			}
		}
		//------ Get Anim From Pose ------------------------------------
		public function getAnimFromPose($pose:String):BitmapAnim {
			if(!poses || !poses[$pose]){
				throw new Error("Poses are not initialized correctly!!");
			}
			var rdm:int = Math.random()*poses[$pose].length;
			return poses[$pose][rdm];
		}
		//------ Set Current Position ------------------------------------
		public function setCurrentPosition($position:int):void {
			currentAnim.position = $position;
			currentPosition = currentAnim.getCell();
		}
		//------ Set RealDisp ------------------------------------
		public function set realDisp($realDisp:MovieClip):void {
			_realDisp = $realDisp;
		}
		//------ Get Create Sequence ------------------------------------
		public function get createSequence():Function {
			return _createSequence;
		}
		//------ Get Create Sequence ------------------------------------
		public function setTimeMultiplicator($timeMultiplicator:Number):void {
			for each(var bitmapAnim:BitmapAnim in animations){
				bitmapAnim.timeMultiplicator = $timeMultiplicator;
			}
		}
		//------ Clone ------------------------------------
		public function clone():BitmapGraph {
			var clone:BitmapGraph = new BitmapGraph();
			clone.currentPose = currentPose;
			clone.poses = poses;
			clone.animations = animations;
			clone.currentAnim = clone.animations[currentAnim.name];
			clone.currentPosition = clone.currentAnim.getCell();
			return clone;
		}
	}
}