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
*    Thanks to Skinner Shaped Based Hit Detection  
*    Grant Skinner 2005
*    http://www.gskinner.com/blog/archives/2005/10/source_code_sha.html
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

package utils.physic{

	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import utils.iso.IsoPoint;
	
	/**
	* SpatialMove
	*/
	public class SpatialMove extends EventDispatcher{
		public static const HORIZONTAL:int	= 0;
		public static const VERTICAL:int	= 1;
		public static const DIAGONAL:int	= 2;
		
		public var movingType:int	= DIAGONAL;
		public var iso:Boolean		= false;
		
		public var timeMultiplicator:int = 1;// Used to slow down time
		public var remainingDistance:IsoPoint = null;
		public var buffer:Array = new Array();
		
		public var facingDir:IsoPoint		= new IsoPoint(1,0,0);
		public var movingDir:IsoPoint		= new IsoPoint(0,0,0);
		private var _speed:IsoPoint			= new IsoPoint(1,1,1);
		public var jumpStart:Number			= 12;
		
		public var STAND:Object		= {name:"STAND", isStanding:false,speed:new IsoPoint()};
		public var KNEE:Object		= {name:"KNEE", isKneeing:false,speed:new IsoPoint()};
		public var WALK:Object		= {name:"WALK", isWalking:false, speed:new IsoPoint(3.5,2.5,0)};
		public var RUN:Object		= {name:"RUN", isRunning:false, speed:new IsoPoint(6.5,4,0)};
		public var JUMP:Object		= {name:"JUMP", isJumping: false,speed:new IsoPoint(9,5,0),jumpStart:16};
		public var FALL:Object		= {name:"FALL", isFalling: false,speed:new IsoPoint(0,0,0)};
		public var JUMP_RUN:Object	= {name:"JUMP_RUN", isRunJumping: false,speed:new IsoPoint(12,5,0),jumpStart:10};
		public var SIT:Object		= {name:"SIT", isSitting:false, speed:new IsoPoint()};
		public var ATTACK:Object	= {name:"ATTACK", isAttacking:false,speed:new IsoPoint(4,0,0)};
		public var RUN_ATTACK:Object= {name:"RUN_ATTACK", isRunAttacking:false,speed:new IsoPoint(6.4,4,0)};
		public var JUMP_ATTACK:Object= {name:"JUMP_ATTACK", isJumpAttacking:false,speed:new IsoPoint(6,5,0)};
		public var FALL_ATTACK:Object= {name:"FALL_ATTACK", isFallAttacking:false,speed:new IsoPoint(6,5,0)};
		public var DEFENSE:Object	= {name:"DEFENSE", isDefending:false,speed:new IsoPoint()};
		public var POWER:Object		= {name:"POWER", isAttacking:false, speed:new IsoPoint()};
		public var SLIDE:Object		= {name:"SLIDE", isSliding:false,speed:new IsoPoint(1,1,0), distance:0, distanceMax:5};
		public var ROLL:Object		= {name:"ROLL", isRolling:false,speed:new IsoPoint(7,5,0)};
		public var HURT:Object		= {name:"HURT", isHurt:false,speed:new IsoPoint(7,5,0)};
		public var FALL_DOWN:Object	= {name:"FAL_DOWN", isFalling:false,speed:new IsoPoint(7,5,0)};
		
		public var gravity:int = 2;
		
		public var pose:Array				= [STAND];
		public var symmetric:Boolean 		= false;
		
		//------ Move ------------------------------------
		public function move($anim:Object):void{
			if(isStanding() && $anim!=FALL && $anim!=JUMP){
				pose.splice(pose.lastIndexOf(STAND),1);
			}else if(isWalking() && $anim!=FALL && $anim!=JUMP){
				pose.splice(pose.lastIndexOf(WALK),1);
			}else if(isRunning() && $anim!=FALL && $anim!=JUMP){
				pose.splice(pose.lastIndexOf(RUN),1);
			}else if(isSliding() && $anim!=FALL && $anim!=JUMP){
				pose.splice(pose.lastIndexOf(SLIDE),1);
			}
			if(isJumping() && $anim == FALL){
				pose.splice(pose.lastIndexOf(JUMP),1);
			}
			if(pose.lastIndexOf($anim)==-1){
				pose.push($anim);
			}
		}
		//------ Is Moving ------------------------------------
		public function isMoving():Boolean{
			return isMovingHor() || isMovingVert();
		}
		//------ Is Moving Horizontally------------------------------------
		public function isMovingHor():Boolean{
			return isWalking() || isRunning() || isSliding();
		}
		//------ Is Moving Vertically------------------------------------
		public function isMovingVert():Boolean{
			return isJumping() || isFalling();
		}
		//------ Is Standing ------------------------------------
		public function isStanding():Boolean{
			if(pose.lastIndexOf(STAND)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Walking ------------------------------------
		public function isWalking():Boolean{
			if(pose.lastIndexOf(WALK)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Running ------------------------------------
		public function isRunning():Boolean{
			if(pose.lastIndexOf(RUN)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Jumping ------------------------------------
		public function isJumping():Boolean{
			if(pose.lastIndexOf(JUMP)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Falling ------------------------------------
		public function isFalling():Boolean{
			if(pose.lastIndexOf(FALL)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Sitting ------------------------------------
		public function isSitting():Boolean{
			if(pose.lastIndexOf(SIT)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Attacking ------------------------------------
		public function isAttacking():Boolean{
			if(pose.lastIndexOf(ATTACK)!=-1){
				return true;
			}
			return false;
		}
		//------ Is Sliding ------------------------------------
		public function isSliding():Boolean{
			if(pose.lastIndexOf(SLIDE)!=-1){
				return true;
			}
			return false;
		}
		//------ Get Speed ------------------------------------
		public function get speed():IsoPoint{
			return _speed;
		}
		//------ Set Speed ------------------------------------
		public function set speed($speed:IsoPoint):void{
			_speed.x = $speed.x;
			_speed.y = $speed.y;
			_speed.z = $speed.z;
		}
	}
}