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
	
	import flash.display.Bitmap;
	import flash.events.*;
	
	import framework.Framework;
	import framework.entity.IEntity;
	
	import utils.iso.IsoPoint;
	import utils.tile.Tile;
	
	/**
	 * TileComponent Component
	 * 
	 */
	public class TileComponent extends GraphicComponent {
		
		private var _tile:Tile = null;
		public var cacheGraphic:Boolean = true;//Cache as Bitmap improve performance
		
		public function TileComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, false,$prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
		
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
		}
		//------ Build Tile ------------------------------------
		public function buildTile($tile:Tile):void {
			_tile = $tile;
			_graphic = new Bitmap($tile.bitmapData);
			_graphic.cacheAsBitmap = true;
			if(cacheGraphic){
				Framework.AddChild(_graphic,componentParent.graphic);
			}else{
				registerPropertyReference("bitmapRender");
			}
		}
		//------ Getter ------------------------------------
		public function get tile():Tile {
			return _tile;
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			_tile.ToString();
		}
		
	}
}