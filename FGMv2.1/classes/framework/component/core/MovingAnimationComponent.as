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
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.bitmap.BitmapCell;
	import utils.bitmap.SwfSet;
	import utils.iso.IsoPoint;
	import utils.physic.SpatialMove;
	
	/**
	* MovingAnimationComponent Class
	*/
	public class MovingAnimationComponent extends AnimationComponent {

		protected var _spatialMove:SpatialMove	= new SpatialMove;
		protected var _bound:Rectangle;		//Max Distance
		
		public function MovingAnimationComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_render= "bitmapRender";
			_bound = new Rectangle(0,0,500,500)
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("spatialMove");
			super.initProperty();
		}
		//------- On Anim -------------------------------
		public override function onAnim():void {
			if(currentAnimName.lastIndexOf("WALK_CYCLE")!=-1){
				_spatialMove.movingDir.x=_spatialMove.facingDir.x;
				_spatialMove.move(_spatialMove.WALK);
				actualize("spatialMove");
			}else if(currentAnimName.lastIndexOf("RUN_CYCLE")!=-1){
				_spatialMove.movingDir.x=_spatialMove.facingDir.x;
				_spatialMove.move(_spatialMove.RUN);
				actualize("spatialMove");
			}else if(_spatialMove.isJumping() || _spatialMove.isFalling()){
				actualize("spatialMove");
			}else{
				_spatialMove.move(_spatialMove.STAND);
			}
			if((currentAnimName.lastIndexOf("RUN_TO_IDLE")!=-1 || currentAnimName.lastIndexOf("WALK_TO_IDLE")!=-1) && currentFrame == lastFrame-1){
				turnIfAtEndOfPath();
			}
		}
		//------- Turn if at end of path -------------------------------
		private function turnIfAtEndOfPath():void {
			if (x<=_bound.x || x>_bound.x+_bound.width || Math.round(Math.random()*5)==1){
				_spatialMove.facingDir.x*=-1;
				bitmapSet.flip=!bitmapSet.flip;
			}
		}
		//------- Get Spatial Move -------------------------------
		public function get spatialMove():SpatialMove {
			return _spatialMove;
		}
		//------ Clone  ------------------------------------
		override public function clone():Component {
			var clone:MovingAnimationComponent = _entity.entityManager.addComponentFromName(entityName,"MovingAnimationComponent") as MovingAnimationComponent;
			if(_graphic && bitmapSet && bitmapSet.bitmap){				// Bitmap
				initAnimComponent(clone, bitmapSet.bitmap);
			}else if(_graphic && bitmapSet && SwfSet(bitmapSet).swf){	// MovieClip
				initAnimComponent(clone, SwfSet(bitmapSet).swf);
			}else{
				_clonePool.push(clone);
			}
			return clone;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}