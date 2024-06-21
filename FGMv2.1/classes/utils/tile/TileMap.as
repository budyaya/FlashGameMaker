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
	
	import utils.iso.IsoPoint;
	
	public class TileMap{
		
		public static const Classic:int		= 0;
		public static const Iso:int 		= 1;
		public static const IsoRect:int		= 2;
		private var _mapHigh:int  	= 1;
		private var _mapHeight:int 	= 5;
		private var _mapWidth:int 	= 5;
		private var _mode:int = Iso;
		private var _rectangle:Boolean = false;
		
		public function TileMap($mapHigh:int,$mapHeight:int,$mapWidth:int,$mode:uint=Iso){
			_initVar($mapHigh,$mapHeight,$mapWidth,$mode);
		}
		//------ Init Var ------------------------------------
		private function _initVar($mapHigh:int,$mapHeight:int,$mapWidth:int,$mode:uint=Iso):void {
			_mapHigh = $mapHigh;
			_mapHeight = $mapHeight;
			_mapWidth = $mapWidth;
			_mode = $mode;
		}
		//------ Getter ------------------------------------
		public function get mapHigh():int {
			return _mapHigh;
		}
		public function get mapHeight():int {
			return _mapHeight;
		}
		public function get mapWidth():int {
			return _mapWidth;
		}
		public function get mode():uint {
			return _mode;
		}
	}
}