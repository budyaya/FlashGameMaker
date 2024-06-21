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
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import framework.Framework;
	import framework.entity.IEntity;
	
	import utils.time.Time;
	import utils.weather.Snowflake;
	
	/**
	 * SnowComponent Component
	 * 
	 */
	public class SnowComponent extends GraphicComponent {
		
		private var _snowflakes:Vector.<Snowflake>;
		private var _interval:Number=0;
		private var _intervalMax:Number=30;
		private var _bitmapData:BitmapData = null;
		
		public function SnowComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_bitmapData = new BitmapData(Framework.stage.fullScreenWidth,Framework.stage.fullScreenHeight);
			_snowflakes = new Vector.<Snowflake>;
			_bitmapData.lock();
			for(var i:uint; i<800; i++){
				var snowflake:Snowflake = new Snowflake();
				_graphic.addChild(snowflake);
				_snowflakes.push(snowflake);
				_bitmapData.copyPixels(snowflake.bitmapData,snowflake.bitmapData.rect,new Point(snowflake.x,snowflake.y),null,null,true);
			}
			_bitmapData.unlock();
			moveTo(0,0,2);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("bitmapRender");
			registerPropertyReference("enterFrame", {onEnterFrame:onTick});
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			if(Time.GetTime()-_interval>_intervalMax){
				_interval = Time.GetTime();
			}else{ 
				return;
			}
			_bitmapData.lock();
			_bitmapData.fillRect(_bitmapData.rect,0);
			for each(var snowflake:Snowflake in _snowflakes){
				snowflake.update();
				_bitmapData.copyPixels(snowflake.bitmapData,snowflake.bitmapData.rect,new Point(snowflake.x,snowflake.y),null,null,true);
			}
			_bitmapData.unlock();
		}
		//------ Get Bitmap ------------------------------------
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}