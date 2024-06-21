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
package utils.tile{
	import flash.display.BitmapData;
	
	public class Tile{
		
		public var layerId:int = 0;
		public var ztile:int = 0;
		public var ytile:int = 0;
		public var xtile:int = 0;
		public var z:Number = 0;
		public var y:Number = 0;
		public var x:Number = 0;
		public var tileFrame:int = 0;
		public var flip:Boolean = false;
		public var bitmapData:BitmapData = null;
		public var tileHigh:int =10;

		public function Tile($layerId:int,$ztile:int, $ytile:int,$xtile:int, $tileFrame:int, $bitmapData:BitmapData,$tileHigh:int = 10){
			_initVar($layerId,$ztile,$ytile,$xtile,$tileFrame,$bitmapData,$tileHigh);
		}
		//------ Init Var ------------------------------------
		private function _initVar($layerId:int,$ztile:int, $ytile:int,$xtile:int, $tileFrame:int, $bitmapData:BitmapData,$tileHigh:int = 10):void {
			layerId = $layerId;
			ztile = $ztile;
			ytile = $ytile;
			xtile = $xtile;
			tileFrame = $tileFrame;
			bitmapData = $bitmapData;
			tileHigh = $tileHigh;
		}
		//------ Swap Tile ------------------------------------
		public function swapTile($layerId:int,$ztile:int, $ytile:int,$xtile:int, $tileFrame:int, $bitmapData:BitmapData,$tileHigh:int = 10):void {
			_initVar($layerId,$ztile,$ytile,$xtile,$tileFrame,$bitmapData,$tileHigh);
		}	
		//------ Check if Flip ------------------------------------
		private function checkFlip():void {
			if (tileFrame!=0) {
				if (tileFrame<0) {
					flip=true;
					tileFrame*=-1;
				}
			}
		}
		//------ Getter ------------------------------------
		public function get tileName():String {
			return "tile_"+ztile+"_"+ytile+"_"+xtile;
		}
		public function get tileWidth():Number {
			return bitmapData.width;
		}
		public function get tileHeight():Number {
			return bitmapData.height;
		}
		//------ To String ------------------------------------
		public function ToString():void {
			trace("*Tile: name: "+tileName,",layer: "+layerId,",frame: "+tileFrame, ",flip: "+flip,",width: "+tileWidth,",height: "+tileHeight,",high: "+tileHigh);
		}
	}
}