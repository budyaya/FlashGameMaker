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
package utils.weather{
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Snowflake extends Shape {
		private var _stageWidth:int = 800;
		private var _stageHeight:int = 600;
		private var _highestDropSpeed:uint = 16;
		private var _dropSpeed:int = Math.round(Math.random() * Math.random() * _highestDropSpeed);
		private var _incrementer:int = Math.round(Math.random() * 100);
		//private var shades:Array = [ 0xFFFFFF, 0xCCCCCC, 0x999999, 0x666666 ];
		private var _shades:uint = 0xFFFFFF;
		private var _windSpeed:int = 2;
		private var _bitmapData:BitmapData = null;
		
		public function Snowflake($stageWidth:Number=800, stageHeight:Number=600) {
			_initVar($stageWidth,stageHeight);
		}
		//------ Init Var ------------------------------------
		private function _initVar($stageWidth:Number, $stageHeight:Number):void {
			_bitmapData = new BitmapData(20,20,true,0);
			_stageWidth = $stageWidth;
			_stageHeight = $stageHeight;
			graphics.beginFill(_shades);
			graphics.drawCircle(0,0,4);
			graphics.endFill();
			filters = [ new BlurFilter(1,_dropSpeed,1) ];
			reset();
		}
		//------ Reset ------------------------------------
		private function reset():void {
			y = Math.random() * _stageHeight * -1;
			x = Math.random() * _stageWidth - (_windSpeed*100);
			scaleX = scaleY = 0.25 + (Math.random() * Math.random() * 0.75);
			var matrix:Matrix = transform.matrix;
			matrix.translate(-x,-y);
			_bitmapData.draw(this,matrix);
		}
		//------ Update ------------------------------------
		public function update():void {
			y += _dropSpeed;
			x += _windSpeed + Math.sin(_incrementer/10) * (1/(_dropSpeed/3));
			if (y > _stageHeight) {
				reset();
			}
			_incrementer++;
		}
		//------ Get Bitmap ------------------------------------
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
	}
}