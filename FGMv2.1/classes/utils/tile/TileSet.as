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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TileSet{
		
		public var texture:BitmapData = null;
		public var tileWidth:int=64;
		public var tileHeight:int=64;
		public var tileHigh:int = 10;
		public var rows:int=0;
		public var columns:int=0;
		
		public function TileSet($bitmapData:BitmapData, $tileWidth:int,$tileHeight:int,$tileHigh:int ){
			_initVar($bitmapData,$tileWidth,$tileHeight,$tileHigh);
		}
		//------ Init Var ------------------------------------
		private function _initVar($texture:BitmapData, $tileWidth:int,$tileHeight:int,$tileHigh:int):void {
			texture = $texture;
			tileWidth = $tileWidth;
			tileHeight = $tileHeight;
			tileHigh = $tileHigh;
			rows = Math.floor(texture.width/tileWidth);
			columns = Math.floor(texture.height/tileHeight);
		}
		//------ Get Tile ------------------------------------
		public function getTile(x:int,y:int):BitmapData {
			var sourceRect:Rectangle = new Rectangle(x*tileWidth,y*tileHeight,tileWidth,tileHeight);
			var tile:BitmapData = new BitmapData(tileWidth,tileHeight,true);
			tile.copyPixels(texture,sourceRect,new Point(0,0),null,null,true);
			return tile;
		}
		//------ Get Tile At ------------------------------------
		public function getTileAt(index:int):BitmapData {
			var x:int = Math.floor(index/rows);
			var y:int = Math.floor(index/columns);
			return getTile(x,y);
		}
	}
}