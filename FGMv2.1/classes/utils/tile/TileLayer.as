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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import utils.iso.IsoPoint;
	import utils.transform.BitmapDataTransform;
	
	public class TileLayer{
		
		private var _id:int=0;
		private var _tileMap:TileMap=null;
		private var _tileTable:Array = null
		private var _tiles:Vector.<Tile> = null;
		private var _tileSet:TileSet = null;
		private var _visibilityBegin:IsoPoint = new IsoPoint;
		private var _visibilityEnd:IsoPoint = new IsoPoint(5,5,1);
		
		public function TileLayer($id:int, $tileMap:TileMap,$tileTable:String, $tileset:TileSet,$visibilityBegin:IsoPoint=null,$visibilityEnd:IsoPoint=null){
			_initVar($id,$tileMap,$tileTable,$tileset,$visibilityBegin,$visibilityEnd);
			_buildTileLayer();
		}
		//------ Init Var ------------------------------------
		private function _initVar($id:int, $tileMap:TileMap,$tileTable:String, $tileset:TileSet,$visibilityBegin:IsoPoint,$visibilityEnd:IsoPoint):void {
			_id = $id;
			_tileMap = $tileMap;
			_tileTable = $tileTable.split(",");;
			_tileSet = $tileset;
			_tiles = new Vector.<Tile>;
			if($visibilityBegin)	_visibilityBegin = $visibilityBegin;
			if($visibilityEnd) 		_visibilityEnd = $visibilityEnd;
		}
		//------ Build Tile Layer ------------------------------------
		private function _buildTileLayer():void {
			var sum:Number=0;
			for each (var cell:String in _tileTable) {
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				for (var i:Number=0; i<num; i++) {
					var ztile:int = Math.floor((i+sum)/(_tileMap.mapHeight*_tileMap.mapWidth));
					var ytile:int=Math.floor((i+sum)/_tileMap.mapWidth);
					var xtile:int=(i+sum)%_tileMap.mapWidth;
					addTile(ztile,ytile,xtile,tileFrame);
				}
				sum+=num;
			}
		}
		//------ Build Tile Layer ------------------------------------
		public function addTile($ztile:int,$ytile:int,$xtile:int,$frame:int):void {
			if (onSight($ztile,$ytile,$xtile) && isVisible($ztile,$ytile,$xtile)) {
				createTile($ztile,$ytile,$xtile,$frame);
			}
		}
		//------ On Sight ------------------------------------
		public function onSight($ztile:int,$ytile:int,$xtile:int):Boolean {
			if ($ztile>=_tileMap.mapHigh||$ytile>=_tileMap.mapHeight||$xtile>=_tileMap.mapWidth) {
				return false;
			} else if ($ztile<0||$ytile<0||$xtile<0) {
				return false;
			}
			return true;
		}
		//------ is Visible ------------------------------------
		public function isVisible($ztile:int,$ytile:int,$xtile:int):Boolean {
			if ($ztile>=visibilityEnd.z||$ytile>=visibilityEnd.y||$xtile>=visibilityEnd.x) {
				return false;
			} else if ($ztile<visibilityBegin.z||$ytile<visibilityBegin.y||$xtile<visibilityBegin.x) {
				return false;
			}
			return true;
		}
		//------ Create Tile ------------------------------------
		public function createTile($ztile:int,$ytile:int,$xtile:int,$tileFrame:int,$addToTiles:Boolean=true):Tile {
			var bitmapData:BitmapData = new BitmapData(_tileSet.tileWidth,_tileSet.tileHeight,true,0);
			var tile:Tile = new Tile(_id,$ztile,$ytile,$xtile,$tileFrame,bitmapData,_tileSet.tileHigh);
			var x:int=($tileFrame-1)% _tileSet.rows;
			var y:int=Math.floor(($tileFrame-1)/(_tileSet.rows));
			bitmapData.copyPixels(_tileSet.texture, new Rectangle(x * tile.tileWidth, y * tile.tileHeight,tile.tileWidth,tile.tileHeight), new Point(0, 0),null,null,true);
			if (tile.flip) {
				BitmapDataTransform.FlipBitmapData(bitmapData);
			}
			if($addToTiles){
				_tiles.push(tile);
			}
			return tile;
		}
		//------ Swap Tile ------------------------------------
		public function swapTile($tile:Tile,$ztile:int,$ytile:int,$xtile:int):void {
			var frame:int = $tile.tileFrame
			var tileFrame:int = getFrame($ztile,$ytile,$xtile);
			$tile.swapTile(_id,$ztile,$ytile,$xtile,tileFrame,$tile.bitmapData,_tileSet.tileHigh);
			if(tileFrame!=frame){
				var x:int=(tileFrame-1)% _tileSet.rows;
				var y:int=Math.floor((tileFrame-1)/(_tileSet.rows));
				$tile.bitmapData.fillRect($tile.bitmapData.rect,0);
				$tile.bitmapData.copyPixels(_tileSet.texture, new Rectangle(x * $tile.tileWidth, y * $tile.tileHeight,$tile.tileWidth,$tile.tileHeight), new Point(0, 0),null,null,true);
				if ($tile.flip) {
					BitmapDataTransform.FlipBitmapData($tile.bitmapData);
				}
			}
		}
		//------ Blit Right ------------------------------------
		public function blitRight($tile:Tile):void {
			var index:int = visibilityWidth*($tile.ytile-visibilityBegin.y+1);
			var newIndex:int = index-visibilityWidth;
			var sliceDown:Vector.<Tile> = _tiles.slice(0,index);
			sliceDown.splice(newIndex,1);
			sliceDown.push($tile);
			var sliceUp:Vector.<Tile> = _tiles.slice(index);
			_tiles = sliceDown.concat(sliceUp);
		}
		//------ Blit Left ------------------------------------
		public function blitLeft($tile:Tile):void {
			var newIndex:int = visibilityWidth*($tile.ytile-visibilityBegin.y+1);
			var index:int = newIndex-visibilityWidth;
			var sliceDown:Vector.<Tile> = _tiles.slice(index,newIndex);
			sliceDown.splice(visibilityWidth-1,1);
			var sliceUp:Vector.<Tile> = _tiles.slice(newIndex);
			_tiles = _tiles.slice(0,index);
			_tiles.push($tile);
			_tiles = _tiles.concat(sliceDown);
			_tiles = _tiles.concat(sliceUp);
		}
		//------ Blit Down ------------------------------------
		public function blitDown($tile:Tile):void {
			var index:int = $tile.xtile-visibilityBegin.x;
			for(var y:int=index;y<index+(visibilityHeight-1)*visibilityWidth;y+=visibilityWidth){
				_tiles[y]=_tiles[y+visibilityWidth];
			}
			_tiles[y]=$tile;
		}
		//------ Blit Up ------------------------------------
		public function blitUp($tile:Tile):void {
			var newIndex:int = $tile.xtile-visibilityBegin.x;
			var index:int = newIndex+(visibilityHeight-1)*visibilityWidth;
			for(var y:int=index; y>=visibilityWidth; y-=visibilityWidth){
				_tiles[y]=_tiles[y-visibilityWidth];
			}
			_tiles[y]=$tile;
		}
		//------ Add Right ------------------------------------
		public function addRight($tile:Tile,$offset:int=0):void {
			var index:int = visibilityWidth*($tile.ytile-visibilityBegin.y+1)+$offset;
			var sliceDown:Vector.<Tile> = _tiles.slice(0,index);
			sliceDown.push($tile);
			var sliceUp:Vector.<Tile> = _tiles.slice(index);
			_tiles = sliceDown.concat(sliceUp);
		}
		//------ Add Right ------------------------------------
		public function removeRight($tile:Tile):void {
			var index:int = _tiles.indexOf($tile);
			_tiles.splice(index,1);
		}
		//------ Add Down ------------------------------------
		public function addDown($tile:Tile):void {
			_tiles.push($tile);
		}
		//------ Remove Down ------------------------------------
		public function removeDown($tile:Tile):void {
			_tiles.pop();
		}
		//------ Get Tile ------------------------------------
		public function getTile($ztile:int,$ytile:int,$xtile:int):Tile {
			var index:int = $ztile*visibilityHeight*visibilityWidth+$ytile*visibilityWidth+$xtile;
			return getTileAt(index);
		}
		//------ Get Tile Index------------------------------------
		public function getTileIndex($tile:Tile):int {
			var index:int = $tile.ztile*visibilityHeight*visibilityWidth+$tile.ytile*visibilityWidth+$tile.xtile;
			return index;
		}
		//------ Get Tiles ------------------------------------
		public function getTiles($rect:Rectangle):Tile {
			return null;
		}
		//------ Get Tile At ------------------------------------
		public function getTileAt($index:int):Tile {
			if($index>=_tiles.length){
				throw new Error("*TileLayer: the tile index is out of bounds !!!");
			}
			return _tiles[$index];
		}
		//------ Get Tile with tileFrame ------------------------------------
		public function getTilesWithTileFrame($tileFrame:int):Vector.<Tile> {
			return null;
		}
		//------ Get Frame ------------------------------------
		public function getFrame($ztile:int, $ytile:int, $xtile:int):int {
			var index:Number=0;
			var sum:Number=0;
			while (index<_tileTable.length) {
				var cell:String=_tileTable[index];
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				sum+=num;
				if ($ztile*_tileMap.mapHeight*_tileMap.mapWidth+$ytile*_tileMap.mapWidth+$xtile<sum) {
					return tileFrame;
				}
				index++;
			}
			return 0;
		}
		//------ Set Frame ------------------------------------
		public function setFrame($ztile:int, $ytile:int, $xtile:int, $tileFrame:int):void {
			var index:Number=0;
			var sum:Number=0;
			while (index<_tileTable.length) {
				var cell:String=_tileTable[index];
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				sum+=num;
				if ($ztile*_tileMap.mapHeight*_tileMap.mapWidth+$ytile*_tileMap.mapWidth+$xtile<sum) {
					if (content.length==2) {
						var res:String = $tileFrame.toString();
						var pos:Number = $ztile*_tileMap.mapHeight*_tileMap.mapWidth+$ytile*_tileMap.mapWidth+$xtile;
						if(sum-pos>2){
							res =res+","+(sum-pos-1)+"*"+tileFrame;
						}else if (sum-pos>1){
							res =res+ ","+tileFrame;
						}
						if(pos-sum+num>1){
							res= pos-sum+num+"*"+tileFrame+","+res;
						}else if (pos-sum+num==1){
							res= tileFrame+","+res;
						}
						_tileTable[index] = res;
					}else{
						_tileTable[index] = $tileFrame;
					}
					return;
				}
				index++;
			}
			return ;
		}
		//------ Getter ------------------------------------
		public function get tiles():Vector.<Tile> {
			return _tiles
		}
		public function get tileSet():TileSet {
			return _tileSet
		}
		public function get tileWidth():int {
			return _tileSet.tileWidth
		}
		public function get tileHeight():int {
			return _tileSet.tileHeight;
		}
		public function get visibilityBegin():IsoPoint {
			return _visibilityBegin;
		}
		public function set visibilityBegin($visibilityBegin:IsoPoint):void {
			_visibilityBegin=$visibilityBegin;
		}
		public function get visibilityEnd():IsoPoint {
			return _visibilityEnd;
		}
		public function set visibilityEnd($visibilityEnd:IsoPoint):void {
			_visibilityEnd=$visibilityEnd;
		}
		public function get visibilityWidth():int {
			return _visibilityEnd.x-_visibilityBegin.x;
		}
		public function get visibilityHeight():int {
			return _visibilityEnd.y-_visibilityBegin.y;
		}
		public function get visibilityHigh():int {
			return _visibilityEnd.z-_visibilityBegin.z;
		}
		public function get width():Number {
			return visibilityWidth*tileWidth;
		}
		public function get height():Number {
			return visibilityHeight*tileHeight;
		}
	}
}