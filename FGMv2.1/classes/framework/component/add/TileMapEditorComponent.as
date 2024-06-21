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

package framework.component.add{
	import fl.controls.ButtonLabelPlacement;
	import fl.controls.CheckBox;
	import fl.controls.NumericStepper;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.component.core.*;
	import framework.entity.IEntity;
	
	import utils.tile.TileLayer;
	import utils.tile.TileMap;
	import utils.tile.TileSet;
	import utils.ui.LayoutUtil;

	/**
	 * TileMapEditorComponent Component
	 * 
	 */
	public class TileMapEditorComponent extends GraphicComponent {
		
		private var _tileMapComponent:TileMapComponent = null;
		private var _tileMap:TileMap = null;
		private var _tileLayers:Vector.<TileLayer> = null;
		private var _tool:MovieClip = new MovieClip;
		
		public function TileMapEditorComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
			_initBg();
			_initTool();
			_initTileSet();
			_initSettings();
			_layout();
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if(!$prop || !$prop.hasOwnProperty("tileMapComponent")){
				throw new Error("TileMapEditorComponent must be initialized with a tileMapComponent property !!!");
			}
			_tileMapComponent = $prop.tileMapComponent;
			_tileMap = _tileMapComponent.tileMap;
			_tileLayers = _tileMapComponent.tileLayers;
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerPropertyReference("render", {layer:2});
			registerProperty("tileMapEditor");
		}
		//-----Init Background  -----------------------------------
		private function _initBg():void {
			this.graphics.beginFill(0xEEEEEE,1);
			this.graphics.drawRoundRect(-20,0,100,200,10,10);
			this.graphics.endFill();
		}
		//-----Init Tile Editor Tool  -----------------------------------
		private function _initTool():void {
			addChild(_tool);
			_tool.inside = new CheckBox();
			_tool.inside.x=-280;
			_tool.inside.y=-248;
			_tool.inside.label="Inside";
			_tool.inside.labelPlacement=ButtonLabelPlacement.LEFT;
			//_tool.inside.addEventListener(MouseEvent.CLICK, onTileEditorInsideClick);
			_tool.mapSize = new NumericStepper();
			_tool.mapSize.minimum=2;
			_tool.mapSize.maximum=50;
			//_tool.mapSize.value = game.map.mapWidth;
			_tool.mapSize.x=_tool.inside.x+130;
			_tool.mapSize.y=-245;
			_tool.mapSize.width=40;
			_tool.mapSize.height-=5;
			_tool.mapSize.tabEnabled=false;
			_tool.mapSize.textField.editable=false;
			_tool.mapSizeText = new TextField();
			_tool.mapSizeText.x=_tool.mapSize.x-30;
			_tool.mapSizeText.y=_tool.mapSize.y-2;
			_tool.mapSizeText.text="Size";
			_tool.mapSizeText.selectable=false;
			_tool.mapSizeText.textColor=0x000000;
			//_tool.mapSize.addEventListener(SliderEvent.CHANGE, onTileEditorMapSizeChange);
			_tool.mapLevel = new NumericStepper();
			_tool.mapLevel.minimum=2;
			_tool.mapLevel.maximum=50;
			_tool.mapLevel.value=5;
			_tool.mapLevel.x=_tool.mapSize.x+80;
			_tool.mapLevel.y=_tool.mapSize.y;
			_tool.mapLevel.width=40;
			_tool.mapLevel.height-=5;
			_tool.mapLevel.tabEnabled=false;
			_tool.mapLevel.textField.editable=false;
			_tool.mapLevelText = new TextField();
			_tool.mapLevelText.x=_tool.mapLevel.x-35;
			_tool.mapLevelText.y=_tool.mapLevel.y-2;
			_tool.mapLevelText.text="Level";
			_tool.mapLevelText.selectable=false;
			_tool.mapLevelText.textColor=0x000000;
			//_tool.mapLevel.addEventListener(SliderEvent.CHANGE, onTileEditorMapLevelChange);
			_tool.tileLevel = new NumericStepper();
			_tool.tileLevel.maximum=5;
			_tool.tileLevel.value=0;
			_tool.tileLevel.x=20;
			_tool.tileLevel.width=40;
			_tool.tileLevel.height-=5;
			_tool.tileLevel.tabEnabled=false;
			_tool.tileLevel.textField.editable=false;
			_tool.tileLevelText = new TextField();
			_tool.tileLevelText.x-=10;
			_tool.tileLevelText.y=_tool.tileLevel.y-2;
			_tool.tileLevelText.text="Level";
			_tool.tileLevelText.selectable=false;
			_tool.tileLevelText.textColor=0x000000;
			//_tool.tileLevel.addEventListener(SliderEvent.CHANGE, onTileEditorLevelChange);
			_tool.tileFrameX = new Slider();
			_tool.tileFrameX.maximum=2;
			_tool.tileFrameX.width=50;
			_tool.tileFrameX.tabEnabled=false;
			_tool.tileFrameX.y+=25;
			_tool.tileFrameXText = new TextField();
			_tool.tileFrameXText.text="frame";
			_tool.tileFrameXText.selectable=false;
			_tool.tileFrameXText.textColor=0x000000;
			_tool.tileFrameXText.y=_tool.tileFrameX.y+3;
			_tool.tileFrameXText.x+=12;
			//_tool.tileFrameX.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorFrameXChange);
			//_tool.tileFrameX.addEventListener(SliderEvent.CHANGE, onTileEditorFrameXChange);
			_tool.tileFrameSet = new Slider();
			_tool.tileFrameSet.maximum=2;
			_tool.tileFrameSet.width=50;
			_tool.tileFrameSet.tabEnabled=false;
			_tool.tileFrameSet.y+=_tool.tileFrameX.y+25;
			_tool.tileFrameSetText = new TextField();
			_tool.tileFrameSetText.text="frameSet";
			_tool.tileFrameSetText.selectable=false;
			_tool.tileFrameSetText.textColor=0x000000;
			_tool.tileFrameSetText.y=_tool.tileFrameSet.y+3;
			_tool.tileFrameSetText.x+=8;
			//_tool.tileFrameSet.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorFrameSetChange);
			//_tool.tileFrameSet.addEventListener(SliderEvent.CHANGE, onTileEditorFrameSetChange);
			_tool.tileLayer = new Slider();
			_tool.tileLayer.maximum=1;
			_tool.tileLayer.width=50;
			_tool.tileLayer.tabEnabled=false;
			_tool.tileLayer.y+=_tool.tileFrameSet.y+25;
			_tool.tileLayerText = new TextField();
			_tool.tileLayerText.text="layer";
			_tool.tileLayerText.selectable=false;
			_tool.tileLayerText.textColor=0x000000;
			_tool.tileLayerText.y=_tool.tileLayer.y+3;
			_tool.tileLayerText.x+=14;
//			_tool.tileLayer.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorLayerChange);
//			_tool.tileLayer.addEventListener(SliderEvent.CHANGE, onTileEditorLayerChange);
			_tool.tileZoom = new Slider();
			_tool.tileZoom.maximum=10;
			_tool.tileZoom.minimum=5;
			_tool.tileZoom.snapInterval=5;
			_tool.tileZoom.value=10;
			_tool.tileZoom.width=50;
			_tool.tileZoom.tabEnabled=false;
			_tool.tileZoom.y+=_tool.tileLayer.y+25;
			_tool.tileZoomText = new TextField();
			_tool.tileZoomText.text="zoom";
			_tool.tileZoomText.selectable=false;
			_tool.tileZoomText.textColor=0x000000;
			_tool.tileZoomText.y=_tool.tileZoom.y+3;
			_tool.tileZoomText.x+=12;
			//_tool.tileZoom.addEventListener(SliderEvent.CHANGE, onTileEditorZoomChange);
			_tool.tileFlipFrame = new Slider();
			_tool.tileFlipFrame.maximum=1;
			_tool.tileFlipFrame.minimum=0;
			_tool.tileFlipFrame.value=0;
			_tool.tileFlipFrame.width=50;
			_tool.tileFlipFrame.tabEnabled=false;
			_tool.tileFlipFrame.y+=_tool.tileZoom.y+25;
			_tool.tileFlipFrameText = new TextField();
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.CLICK,onTileEditorFlipFrameTextClick);
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipFrameTextRollOver);
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipFrameTextRollOut);
			_tool.tileFlipFrameText.text="flip frame";
			_tool.tileFlipFrameText.selectable=false;
			_tool.tileFlipFrameText.textColor=0x000000;
			_tool.tileFlipFrameText.y=_tool.tileFlipFrame.y+7;
			_tool.tileFlipFrameText.x+=6;
			//_tool.tileFlipFrame.addEventListener(SliderEvent.CHANGE, onTileEditorFlipFrameChange);
			_tool.tileFlipPositionHText = new TextField();
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.CLICK,onTileEditorFlipPositionHTextClick);
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipPositionHTextRollOver);
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipPositionHTextRollOut);
			_tool.tileFlipPositionHText.text="flipH";
			_tool.tileFlipPositionHText.selectable=false;
			_tool.tileFlipPositionHText.textColor=0x000000;
			_tool.tileFlipPositionHText.y=_tool.tileFlipFrameText.y+20;
			_tool.tileFlipPositionHText.x-=5;
			_tool.tileFlipPositionVText = new TextField();
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.CLICK,onTileEditorFlipPositionVTextClick);
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipPositionVTextRollOver);
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipPositionVTextRollOut);
			_tool.tileFlipPositionVText.text="flipV";
			_tool.tileFlipPositionVText.selectable=false;
			_tool.tileFlipPositionVText.textColor=0x000000;
			_tool.tileFlipPositionVText.y=_tool.tileFlipFrameText.y+20;
			_tool.tileFlipPositionVText.x+=40;
			
			_tool.addChild(_tool.inside);
			_tool.addChild(_tool.mapSizeText);
			_tool.addChild(_tool.mapLevelText);
			_tool.addChild(_tool.tileLevelText);
			_tool.addChild(_tool.tileFrameXText);
			_tool.addChild(_tool.tileFrameSetText);
			_tool.addChild(_tool.tileLayerText);
			_tool.addChild(_tool.tileZoomText);
			_tool.addChild(_tool.tileFlipFrameText);
			_tool.addChild(_tool.tileFlipPositionHText);
			_tool.addChild(_tool.tileFlipPositionVText);
			_tool.addChild(_tool.mapSize);
			_tool.addChild(_tool.mapLevel);
			_tool.addChild(_tool.tileLevel);
			_tool.addChild(_tool.tileFrameSet);
			_tool.addChild(_tool.tileFrameX);
			_tool.addChild(_tool.tileLayer);
			_tool.addChild(_tool.tileZoom);
			_tool.addChild(_tool.tileFlipFrame);
		}
		//-----Init TileSet  -----------------------------------
		private function _initTileSet():void {
			var tileLayer:TileLayer = _tileLayers[0];
			var tileSet:TileSet = tileLayer.tileSet;
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			var tile:MovieClip
			for( var i:uint=0; i<tileSet.rows; i++){
				bitmapData = new BitmapData(tileSet.tileWidth, tileSet.tileHeight,true,0);
				bitmapData.copyPixels(tileSet.texture,new Rectangle(0,i*tileSet.tileHeight,tileSet.tileWidth, tileSet.tileHeight),new Point(0,0),null,null,true);
				bitmap = new Bitmap(bitmapData);
				tile = new MovieClip;
				tile.addChild(bitmap);
				tile.index = i*tileSet.columns;
				tile.y+=i*tileSet.tileHeight;
				addChild(tile);
			}
		}
		//-----Init Settings  -----------------------------------
		private function _initSettings():void {
			
		}
		//----- Layout  -----------------------------------
		private function _layout():void {
			LayoutUtil.Align(this,LayoutUtil.ALIGN_TOP_RIGHT);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
		
	}
}