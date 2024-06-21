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
	
	import flash.events.*;
	import flash.geom.Point;
	
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.iso.IsoPoint;
	import utils.physic.SpatialMove;
	import utils.richardlord.FiniteStateMachine;
	import utils.richardlord.State;
	
	/**
	* SpatialMoveComponent Class
	*/
	public class SpatialMoveComponent extends Component {

		public var timeMultiplicator:Number = 1;//Use to slow down the time
		
		public function SpatialMoveComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object = null) {
			super($componentName, $entity, true, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function initVar($prop:Object):void {
			if($prop && $prop.timeMultiplicator){
				timeMultiplicator = $prop.timeMultiplicator;
			}
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("spatialMove");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "spatialMove") {
				if($component.hasOwnProperty("spatialMove") && $component.spatialMove){
					move($component);
				}else{
					throw new Error("A SpatialMove must exist to be registered by SpatialMoveComponent");
				}
			}
		}
		//------ Move ------------------------------------
		protected function move($component:Component):void {
			var spatialMove:SpatialMove = $component.spatialMove;
			if(spatialMove.movingDir.x==0 && spatialMove.movingDir.y==0 && spatialMove.movingDir.z==0 && spatialMove.remainingDistance==null && spatialMove.buffer.length==0)	return;
			if(spatialMove.remainingDistance!=null){
				$component.x+= spatialMove.remainingDistance.x;
				$component.y+= spatialMove.remainingDistance.y;
				spatialMove.remainingDistance.z--;
				if(spatialMove.remainingDistance.z<=0)	spatialMove.remainingDistance=null;
				spatialMove.buffer.push(spatialMove.speed);
			}else if(spatialMove.remainingDistance==null && spatialMove.buffer.length==0 && (timeMultiplicator!=1 || spatialMove.timeMultiplicator!=1)){
				var distance:Point = new Point();
				distance.x = (spatialMove.movingDir.x * spatialMove.speed.x) / (timeMultiplicator* spatialMove.timeMultiplicator);
				distance.y = (spatialMove.movingDir.y * spatialMove.speed.y) / (timeMultiplicator * spatialMove.timeMultiplicator);
				distance.y-= (spatialMove.movingDir.z * spatialMove.speed.z) / (timeMultiplicator * spatialMove.timeMultiplicator);
				spatialMove.remainingDistance = new IsoPoint(distance.x,distance.y,timeMultiplicator * spatialMove.timeMultiplicator-1);
				$component.x+= distance.x;
				$component.y+= distance.y;
				$component.z-=(spatialMove.movingDir.z * spatialMove.speed.z) / (timeMultiplicator * spatialMove.timeMultiplicator);
			}else if(spatialMove.remainingDistance==null && spatialMove.buffer.length>0 && (timeMultiplicator!=1 || spatialMove.timeMultiplicator!=1)){
				var speed:IsoPoint = spatialMove.buffer.shift();
				distance = new Point();
				distance.x = (spatialMove.movingDir.x * speed.x) / (timeMultiplicator* spatialMove.timeMultiplicator);
				distance.y = (spatialMove.movingDir.y * speed.y) / (timeMultiplicator * spatialMove.timeMultiplicator);
				distance.y-= (spatialMove.movingDir.z * speed.z) / (timeMultiplicator * spatialMove.timeMultiplicator);
				$component.z-= (spatialMove.movingDir.z * speed.z) / (timeMultiplicator * spatialMove.timeMultiplicator);
				spatialMove.remainingDistance = new IsoPoint(distance.x,distance.y,timeMultiplicator * spatialMove.timeMultiplicator-1);
				$component.x+= distance.x;
				$component.y+= distance.y;
			}else if(spatialMove.buffer.length>0){
				speed = spatialMove.buffer.shift();
				$component.x+= spatialMove.movingDir.x * speed.x;
				$component.y+= spatialMove.movingDir.y * speed.y;
				$component.y-= spatialMove.movingDir.z * speed.z;
				$component.z-= spatialMove.movingDir.z * speed.z;
			}else {
				$component.x+= spatialMove.movingDir.x * spatialMove.speed.x;
				$component.y+= spatialMove.movingDir.y * spatialMove.speed.y;
				$component.y-= spatialMove.movingDir.z * spatialMove.speed.z;
				$component.z-= spatialMove.movingDir.z * spatialMove.speed.z;
			}
			//trace (_remainingDistance.x,spatialMove.movingDir.x * spatialMove.speed.x + _remainingDistance.x,timeMultiplicator* spatialMove.timeMultiplicator)
				
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}