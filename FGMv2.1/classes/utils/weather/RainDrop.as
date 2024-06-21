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
	
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	
	public class RainDrop extends Shape {
		private var _stageWidth:int = 800;
		private var _stageHeight:int = 600;
		private var _highestDropSpeed:uint = 100;
		private var _dropSpeed:int = Math.round(Math.random() * Math.random() * _highestDropSpeed);
		private var _windSpeed:int = 2;
		private var _incrementer:int = 1;
		
		public function RainDrop($stageWidth:Number=800, stageHeight:Number=600) {
			_initVar($stageWidth,stageHeight);
		}
		//------ Init Var ------------------------------------
		private function _initVar($stageWidth:Number, $stageHeight:Number):void {
			_stageWidth = $stageWidth;
			_stageHeight = $stageHeight;
			//graphics.beginFill(shades[ Math.ceil(Math.random() * shades.length) ]);
			graphics.beginFill(/*_shades*/0xFF000000);
			graphics.drawCircle(0,0,4);
			graphics.endFill();
			
			reset();
		}
		//------ Reset ------------------------------------
		private function reset():void {
			y =  Math.floor( -50 + Math.random() * 50);
			x = Math.random() * _stageWidth - (_windSpeed*100);
			scaleX = scaleY = 0.80 + (Math.random() * Math.random() * 0.20);
			//x = Math.floor(Math.random()*stage.stageWidth+30);
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
	}
}