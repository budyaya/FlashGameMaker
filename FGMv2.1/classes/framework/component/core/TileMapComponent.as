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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.entity.IEntity;
	
	import utils.iso.IsoPoint;
	import utils.mouse.MousePad;
	import utils.text.StyleManager;
	import utils.tile.Tile;
	import utils.tile.TileLayer;
	import utils.tile.TileMap;
	import utils.tile.TileSet;
	
	/**
	 * TileMapComponent Component
	 * 
	 */
	public class TileMapComponent extends GraphicComponent {
		
		private var _tileMap:TileMap = null
		private var _tileLayers:Vector.<TileLayer> = null;
		private var _tileComponents:Dictionary = null;
		private var _scrollPosition:IsoPoint=null;
		private var _mapOffset:Point = null;
		private var _onComplete:Function = null;
		private var _pauseScroll:Boolean =false;
		private var _pauseBlit:Boolean =false;
		private var _bitmapData:BitmapData = null;
		
		public function TileMapComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, false);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			var entity:IEntity=_entity.entityManager.createEntity(_componentName);
			if($prop && $prop.hasOwnProperty("onComplete"))	_onComplete = $prop.onComplete;
			_tileLayers = new Vector.<TileLayer>;
			_tileComponents =  new Dictionary;
			_graphic = new MovieClip();
			_graphic.cacheAsBitmap = true;
			_scrollPosition = new IsoPoint;
			_mapOffset = new Point;
			_autoScroll = false;
			_alwaysDisplay = true;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("bitmapRender",{onScroll:onScroll});
		}
		//------ Init Map ------------------------------------
		public function initMap($mapHigh:int,$mapHeight:int,$mapWidth:int,$mode:uint=0):void {
			_tileMap = new TileMap($mapHigh,$mapHeight,$mapWidth,$mode);
		}
		//------ Add TileLayer  ------------------------------------
		public function addTileLayer($tileTable:String,$tileSet:BitmapData,$tileWidth:int,$tileHeight:int,$tileHigh:int,$visibilityBegin:IsoPoint=null,$visibilityEnd:IsoPoint=null,$callback:Function=null):void {
			if(!_tileMap){
				throw new Error("The TileMap has not been initialized please use the initMap function before adding layers");
			}
			var tileLayer:TileLayer = createTileLayer($tileTable,$tileSet,$tileWidth,$tileHeight,$tileHigh,$visibilityBegin,$visibilityEnd);
			displayTileLayer(tileLayer);
			_tileLayers.push(tileLayer);
			if($callback!=null)		$callback(tileLayer);
			screenGraphic();
		}
		//------ Screen Graphic ------------------------------------
		private function screenGraphic():void{
			if(_graphic.width==0 || _graphic.height==0){
				trace("[WARNING] Width and Height of the TileMapComponent are 0");
			}else{
				_bitmapData = new BitmapData(_graphic.width,_graphic.height,true,0);
				_bitmapData.lock();
				_bitmapData.draw(_graphic);
				_bitmapData.unlock();
			}
		}
		//------ Create Tile Layer ------------------------------------
		private function createTileLayer($tileTable:String,$tileSet:BitmapData,$tileWidth:int,$tileHeight:int,$tileHigh:int,$visibilityBegin:IsoPoint=null,$visibilityEnd:IsoPoint=null):TileLayer {
			var tileSet:TileSet = new TileSet($tileSet ,$tileWidth,$tileHeight,$tileHigh);
			return new TileLayer(_tileLayers.length,_tileMap,$tileTable,tileSet,$visibilityBegin,$visibilityEnd);
		}
		//------ Display Tile Layer ------------------------------------
		private function displayTileLayer($tileLayer:TileLayer):void{
			var tileComponent:TileComponent;
			var offset:Point = new Point;
			for each (var tile:Tile in $tileLayer.tiles){
				tileComponent = _entity.entityManager.addComponentFromName(_entity.entityName,"TileComponent",tile.tileName+"_"+_tileLayers.length,{componentParent:this}) as TileComponent;
//				tileComponent.registerPropertyReference("mouseInput",{onMouseRollOver:onMouseRollOver, onMouseRollOut:onMouseRollOut, onMouseClick:onMouseClick});
//				tileComponent.isDisplayed = true;
				tileComponent.buildTile(tile);
				_tileComponents[tile] = tileComponent;
				offset = min(offset,moveTile(tileComponent));
				componentChildren.push(tileComponent);
			}
			if(_tileMap.mode == TileMap.Iso){
				for each (tileComponent in componentChildren){
					tileComponent.graphic.x -=offset.x/2 ;
					tileComponent.graphic.y -=offset.y/2 
				}
			}
		}
		//------ Move Tile ------------------------------------
		private function moveTile($tileComponent:TileComponent):Point {
			var tile:Tile = $tileComponent.tile;
			if (_tileMap.mode == TileMap.Classic) {
				var position:IsoPoint=tileToScreen(tile.ztile,tile.ytile,tile.xtile,tile.tileHigh,tile.tileHeight,tile.tileWidth);
			}else if (_tileMap.mode == TileMap.Iso) {
				position=screenToIso(tile.ztile,tile.ytile,tile.xtile,tile.tileHigh,tile.tileHeight,tile.tileWidth);
			} else if (_tileMap.mode == TileMap.IsoRect) {
				position=screenToIsoRectangle(tile.ztile,tile.ytile,tile.xtile,tile.tileHigh,tile.tileHeight,tile.tileWidth);
			}else{
				throw new Error("The tileMap mode must be Classic, Iso or IsoRectanle !!!");
			}
			position.z+=tile.ztile*tile.tileHigh;
			tile.x=position.x;
			tile.y=position.y;
			tile.z=position.z;
			$tileComponent.moveTo(position.x/*-_mapOffset.x*/-_scrollPosition.x,position.y/*-_mapOffset.y*/-_scrollPosition.y-position.z);
			if($tileComponent.cacheGraphic){
				$tileComponent.graphic.x=$tileComponent.x+_scrollPosition.x;
				$tileComponent.graphic.y=$tileComponent.y+_scrollPosition.y-2000;//TODO remove -2000 and find a way to align this map !!!
			}
			return position;
		}
		//------ Add Visibility X  ------------------------------------
		public function addVisibilityX($offset:Number):void {
			var tileComponent:TileComponent;
			var tileFrame:int;
			var tile:Tile;
			for each (var layer:TileLayer in _tileLayers){
				for (var o:int=0; o<$offset; o++) {
					var offset:int=0;
					for (var y:int=layer.visibilityBegin.y; y<layer.visibilityEnd.y; y++) {
						for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
							if (layer.onSight(z,y,layer.visibilityEnd.x)) {
								tileFrame = layer.getFrame(z,y,layer.visibilityEnd.x);
								tile = layer.createTile(z,y,layer.visibilityEnd.x,tileFrame, false);
								try{
									tileComponent = _entity.entityManager.addComponentFromName(_entity.entityName,"TileComponent",tile.tileName,{componentParent:this}) as TileComponent;
								}catch(e:Error){
									tileComponent = _entity.entityManager.getComponent(_entity.entityName,tile.tileName) as TileComponent;
								}
								tileComponent.buildTile(tile);
								_tileComponents[tile] = tileComponent;
								moveTile(tileComponent);
								layer.addRight(tile,offset);
								offset++;
							}
						}
					}
					layer.visibilityEnd.x++;
				}
			}
		}
		//------ Remove Visibility X  ------------------------------------
		public function removeVisibilityX($offset:Number):void {
			var tileComponent:TileComponent;
			var tile:Tile;
			for each (var layer:TileLayer in _tileLayers){
				for (var o:int=0; o<$offset; o++) {
					var offset:int=0;
					for (var y:int=0; y<layer.visibilityHeight; y++) {
						for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
							var index:Number = z*layer.visibilityHeight*layer.visibilityWidth+y*layer.visibilityWidth+layer.visibilityWidth-1-offset;
							tile = layer.getTileAt(index);
							tileComponent = _entity.entityManager.getComponent(_entity.entityName,tile.tileName) as TileComponent;
							if(graphic.contains(tileComponent.graphic))
								Framework.RemoveChild(tileComponent.graphic,graphic);
							layer.removeRight(tile);
							offset++;
						}
					}
					layer.visibilityEnd.x--;
				}
			}
		}
		//------ Add Visibility Y  ------------------------------------
		public function addVisibilityY($offset:Number):void {
			var tileComponent:TileComponent;
			var tileFrame:int;
			var tile:Tile;
			for each (var layer:TileLayer in _tileLayers){
				for (var o:int=0; o<$offset; o++) {
					for (var x:int=layer.visibilityBegin.x; x<layer.visibilityEnd.x; x++) {
						for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
							if (layer.onSight(z,layer.visibilityEnd.y,x)) {
								tileFrame = layer.getFrame(z,layer.visibilityEnd.y,x);
								tile = layer.createTile(z,layer.visibilityEnd.y,x,tileFrame,false);
								try{
									tileComponent = _entity.entityManager.addComponentFromName(_entity.entityName,"TileComponent",tile.tileName,{componentParent:this}) as TileComponent;
								}catch(e:Error){
									tileComponent = _entity.entityManager.getComponent(_entity.entityName,tile.tileName) as TileComponent;
								}
								tileComponent.buildTile(tile);
								_tileComponents[tile] = tileComponent;
								componentChildren.push(tileComponent);
								moveTile(tileComponent);
								layer.addDown(tile);
							}
						}
					}
					layer.visibilityEnd.y++;
				}
			}	
		}
		//------ Remove Visibility Y  ------------------------------------
		public function removeVisibilityY($offset:Number):void {
			var tileComponent:TileComponent;
			var tile:Tile;
			for each (var layer:TileLayer in _tileLayers){
				for (var o:int=0; o<$offset; o++) {
					for (var x:int=layer.visibilityEnd.x-1; x>=layer.visibilityBegin.x; x--) {
						for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
							if (layer.onSight(z,layer.visibilityEnd.y-1,x)) {
								tile = layer.getTileAt(layer.tiles.length-1);
								tileComponent = _entity.entityManager.getComponent(_entity.entityName,tile.tileName) as TileComponent;
								if(graphic.contains(tileComponent.graphic))
									Framework.RemoveChild(tileComponent.graphic,graphic);
							}
						}
					}
					layer.visibilityEnd.y--;
				}
			}	
		}
		//------ Min ------------------------------------
		private function min($point1:Point, $point2:Point):Point {
			var point:IsoPoint = new IsoPoint($point1.x,$point1.y);
			if($point2.x<point.x){
				point.x = $point2.x;
			}
			if($point2.y<point.y){
				point.y = $point2.y;
			}
			return point;
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen($ztile:int,$ytile:int,$xtile:int,$tileHigh:int,$tileHeight:int,$tileWidth:int):IsoPoint {
			var point:IsoPoint=new IsoPoint  ;
			point.x=$xtile*$tileWidth;
			point.y=$ytile*$tileHeight;
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso($ztile:int,$ytile:int,$xtile:int,$tileHigh:int,$tileHeight:int,$tileWidth:int):IsoPoint {
			var point:IsoPoint=new IsoPoint  ;
			point.x=$xtile*$tileWidth/2;
			point.y=$ytile*$tileWidth/2;
			var isoPoint:IsoPoint=new IsoPoint  ;
			isoPoint.x=point.x-point.y;
			isoPoint.y=(point.x+point.y)/2;
			return isoPoint;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIsoRectangle($ztile:int,$ytile:int,$xtile:int,$tileHigh:int,$tileHeight:int,$tileWidth:int):IsoPoint {
			var point:IsoPoint=new IsoPoint  ;
			point.x=$xtile*$tileWidth;
			point.y=$ytile*($tileHeight-4)/2;
			var isoPoint:IsoPoint=new IsoPoint  ;
			isoPoint.x=point.x;
			isoPoint.y=point.y+2*_tileMap.mapHeight;
			if ($ytile%2==1) {
				isoPoint.x+=$tileWidth/2;
			}
			return isoPoint;
		}
		//----- On Scroll -----------------------------------
		private function onScroll($position:IsoPoint):void{
			if(!_pauseScroll && Framework.clip.mouseY<600 && _mouseManager.clicked==null && _mouseManager.rollOver==null){
				var positionX:Number = x;
				var positionY:Number = y;
				if(x-$position.x<=-40 && x-$position.x>-width){
					positionX = x-$position.x;
					_scrollPosition.x+=$position.x;
				}
				if(y-$position.y<=-40 && y-$position.y>-height){
					positionY = y-$position.y;
					_scrollPosition.y+=$position.y+$position.z;
				}
				if(positionX==x && positionY==y)	return;
				moveTo(positionX,positionY);
				blit($position);
			}
		}
		//----- ScrollTo -----------------------------------
		public function scrollTo($position:Point):void{
			var speed:int = 150;
			var origin:Sprite = new Sprite;
			origin.x=x;
			origin.y=y;
			var sprite:Sprite = new Sprite;
			sprite.x = x;
			sprite.y = y;
			var distance:Number = Point.distance(new Point(x,y),new Point(x+$position.x,y+$position.y));
			var duration :Number= distance/speed;
			TweenLite.to(sprite,duration,{x:x+$position.x,y:y+$position.y,onUpdate:onScrollUpdate,onUpdateParams:[origin,sprite] });
		}
		//----- On Scroll Update -----------------------------------
		public function onScrollUpdate($origin:Sprite,$sprite:Sprite):void{
			onScroll(new IsoPoint($sprite.x-$origin.x,$sprite.y-$origin.y))
			$origin.x-=$origin.x-$sprite.x;
			$origin.y-=$origin.y-$sprite.y;
		}
		//------ Blit  ------------------------------------
		private function blit($position:IsoPoint):void {
			if(_pauseBlit)	return;
			var result:Boolean = false;
			if ($position.x>0) {
				result = result || blitRight();
			} else if ($position.x<0) {
				result= result || blitLeft();
			}
			if ($position.y>0) {
				result = result || blitDown();
			} else if ($position.y<0) {
				result = result || blitUp();
			}
			if(result){
				screenGraphic();
			}
		}
		//------ Blit Right ------------------------------------
		private function blitRight():Boolean {
			var result:Boolean = false;
			for each (var layer:TileLayer in _tileLayers) {
				var blitX:int = Math.round(_scrollPosition.x/layer.tileWidth);
				if(blitX>0 && layer.visibilityBegin.x+layer.visibilityWidth<_tileMap.mapWidth){
					result = true;
					var offset:int = blitX-layer.visibilityBegin.x;
					for (var o:int=0; o<offset; o++) {
						for (var y:int=layer.visibilityBegin.y; y<layer.visibilityEnd.y; y++) {
							for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
								if (layer.onSight(z,y,layer.visibilityEnd.x)) {
									var tile:Tile = layer.getTile(z-layer.visibilityBegin.z,y-layer.visibilityBegin.y,0);
									layer.swapTile(tile,z,y,layer.visibilityEnd.x);
									var tileComponent:TileComponent = _tileComponents[tile] as TileComponent;
									moveTile(tileComponent);
									layer.blitRight(tile);
								}
							}
						}
						layer.visibilityBegin.x++;
						layer.visibilityEnd.x++;
					}
				}
			}
			return result;
		}
		//------ Blit Left ------------------------------------
		private function blitLeft():Boolean {
			var result:Boolean = false;
			for each (var layer:TileLayer in _tileLayers) {
				var blitX:int = Math.round(_scrollPosition.x/layer.tileWidth);
				if(blitX>=0 && layer.visibilityBegin.x>0){
					result = true;
					var offset:int = layer.visibilityBegin.x-blitX;
					for (var o:int=0; o<offset; o++) {
						for (var y:int=layer.visibilityBegin.y; y<layer.visibilityEnd.y; y++) {
							for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
								if (layer.onSight(z,y,layer.visibilityBegin.x-1)) {
									var tile:Tile = layer.getTile(z-layer.visibilityBegin.z,y-layer.visibilityBegin.y,layer.visibilityWidth-1);
									layer.swapTile(tile,z,y,layer.visibilityBegin.x-1);
									var tileComponent:TileComponent = _tileComponents[tile] as TileComponent;
									moveTile(tileComponent);
									layer.blitLeft(tile);
								}
							}
						}
						layer.visibilityBegin.x--;
						layer.visibilityEnd.x--;
					}
				}
			}
			return result;
		}
		//------ Blit Down ------------------------------------
		private function blitDown():Boolean {
			var result:Boolean = false;
			for each (var layer:TileLayer in _tileLayers) {
				if(_tileMap.mode==TileMap.IsoRect){
					var blitY:int = Math.ceil(_scrollPosition.y/((layer.tileHeight-4)/2));
				}else{
					blitY = Math.round(_scrollPosition.y/layer.tileHeight);
				}
				if(blitY>0 && layer.visibilityBegin.y+layer.visibilityHeight<_tileMap.mapHeight){
					result = true;
					var offset:int = blitY-layer.visibilityBegin.y;
					for (var o:int=0; o<offset; o++) {
						for (var x:int=layer.visibilityBegin.x; x<layer.visibilityEnd.x; x++) {
							for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
								if (layer.onSight(z,layer.visibilityEnd.y,x)) {
									var tile:Tile = layer.getTile(z-layer.visibilityBegin.z,0,x-layer.visibilityBegin.x);
									layer.swapTile(tile,z,layer.visibilityEnd.y,x);
									var tileComponent:TileComponent = _tileComponents[tile] as TileComponent;
									moveTile(tileComponent);
									layer.blitDown(tile);
								}
							}
						}
						layer.visibilityBegin.y++;
						layer.visibilityEnd.y++;
					}
				}
			}
			return result;
		}
		//------ Blit Up ------------------------------------
		private function blitUp():Boolean {
			var result:Boolean = false;
			for each (var layer:TileLayer in _tileLayers) {
				if(_tileMap.mode==TileMap.IsoRect){
					var blitY:int = Math.ceil(_scrollPosition.y/((layer.tileHeight-4)/2));
				}else{
					blitY = Math.floor(_scrollPosition.y/layer.tileHeight);
				}
				if(blitY>=0 && layer.visibilityBegin.y>0){
					var offset:int = layer.visibilityBegin.y-blitY;
					result = true;
					for (var o:int=0; o<offset; o++) {
						for (var x:int=layer.visibilityBegin.x; x<layer.visibilityEnd.x; x++) {
							for (var z:int=layer.visibilityBegin.z; z<layer.visibilityEnd.z; z++) {
								if (layer.onSight(z,layer.visibilityBegin.y-1,x)) {
									var tile:Tile = layer.getTile(z-layer.visibilityBegin.z,layer.visibilityHeight-1,x-layer.visibilityBegin.x);
									layer.swapTile(tile,z,layer.visibilityBegin.y-1,x);
									var tileComponent:TileComponent = _tileComponents[tile] as TileComponent;
									moveTile(tileComponent);
									layer.blitUp(tile);
								}
							}
						}
						layer.visibilityBegin.y--;
						layer.visibilityEnd.y--;
					}
				}
			}
			return result;
		}
		//------ Move to  ------------------------------------
		public override function moveTo($x:Number, $y:Number,$z:Number=0):void {
			_mapOffset.x-=$x-x;
			_mapOffset.y-=$y-y;
			super.moveTo($x,$y);
		}
		//------- Getter -------------------------------
		public function get tileMap():TileMap {
			return _tileMap;
		}
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		public function get tileLayers():Vector.<TileLayer> {
			return _tileLayers;
		}
		public override function get width():Number {
			var maxWidth:Number=0;
			for each (var layer:TileLayer in _tileLayers){
				maxWidth = Math.max(maxWidth,layer.width);
			}
			return maxWidth;
		}
		public function get maxWidth():Number {
			var maxTileWidth:Number=0;
			for each (var layer:TileLayer in _tileLayers){
				maxTileWidth = Math.max(maxTileWidth,layer.tileWidth);
			}
			return maxTileWidth*_tileMap.mapWidth;
		}
		public override function get height():Number {
			var maxHeight:Number=0;
			for each (var layer:TileLayer in _tileLayers){
				maxHeight = Math.max(maxHeight,layer.height);
			}
			return maxHeight;
		}
		public function get maxHeight():Number {
			var maxTileHeight:Number=0;
			for each (var layer:TileLayer in _tileLayers){
				maxTileHeight = Math.max(maxTileHeight,layer.tileHeight);
			}
			return maxTileHeight*_tileMap.mapHeight;
		}
		public function set pauseScroll($pauseScroll:Boolean):void {
			_pauseScroll=$pauseScroll;
		}
		public function set pauseBlit($pauseBlit:Boolean):void {
			_pauseBlit=$pauseBlit;
		}
		//------ On Mouse Roll Over  ------------------------------------
		public function onMouseRollOver($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters = StyleManager.RedHalo;
		}
		//------ On Mouse Roll Out  ------------------------------------
		public function onMouseRollOut($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.rollOver as GraphicComponent;
			target.graphic.filters =[];
		}
		//------ On Mouse Click  ------------------------------------
		public function onMouseClick($mousePad:MousePad):void {
			var target:GraphicComponent = _mouseManager.clicked as GraphicComponent;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
		
	}
}