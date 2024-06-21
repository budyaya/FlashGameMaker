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

package customClasses{
	
	import com.adobe.serialization.json.JSON;
	
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.Framework;
	import framework.entity.EntityManager;
	import framework.system.GraphicManager;
	import framework.system.RessourceManager;
	
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.transform.BitmapDataTransform;
	
	/**
	* MS Class
	*/
	public class MS_Object {
		private static var _list:Dictionary = new Dictionary;
		
		//------- Create Object  -------------------------------
		public static function CreateObject($oid:int, $caller:MS_ObjectComponent=null, $keyPad:KeyPad=null, $position:IsoPoint=null):MS_ObjectComponent {
			var object:Object = Data.OBJECT[$oid];
			var dataString:String = RessourceManager.getInstance().getFile(object.data);
			var dataJSON:Object = JSON.decode(dataString);
			//var dataJSON:Object = JSON.parse(dataString);
			var graphics:Array = object.graphics as Array;
			var ms_object:MS_ObjectComponent = null;
			switch(object.kind){
				case Data.OBJECT_KIND_CHARACTER: 
					ms_object=CreatePlayer(object.kind,dataJSON,graphics,$keyPad,$position);
					break;
				case Data.OBJECT_KIND_PROJECTILE: 
					ms_object=CreateProjectile(object.kind,dataJSON,graphics,$caller);
					break;
			}
			return ms_object;
		}
		//------- Create Player  -------------------------------
		public static function CreatePlayer($kind:int,$data:Object,$graphics:Array,$keyPad:KeyPad=null, $position:IsoPoint=null):MS_ObjectComponent {
			var ms_frame:MS_Frame = new MS_Frame($data);
			var player:MS_ObjectComponent= EntityManager.getInstance().addComponentFromName("MSOrigin","MS_ObjectComponent",null,{ms_frame:ms_frame,kind:$kind,keyPad:$keyPad}) as MS_ObjectComponent;
			if(_list[$graphics]){
				player.createBitmap(_list[$graphics]);
			}else{
				var bitmaps:Vector.<Bitmap> = Vector.<Bitmap>(GraphicManager.getInstance().getGraphics($graphics as Array));
				var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"VERTICAL");
				BitmapDataTransform.SwapColor(bitmap.bitmapData,0xFF000000,0);//Remove black to transparent
				player.createBitmap(bitmap);
				_list[$graphics] = bitmap;
			}
			if($position){
				player.x=$position.x;
				player.y=$position.y;
			}
			//player.registerPropertyReference("collisionDetection",player.collisionParam);
			return player;
		}
		//------- Create Special Move  -------------------------------
		public static function CreateProjectile($kind:int,$data:Object,$graphics:Array, $source:MS_ObjectComponent=null):MS_ObjectComponent {
			var projectileframe:MS_Frame = new MS_Frame($data);
			var projectile:MS_ObjectComponent=EntityManager.getInstance().addComponentFromName("MSOrigin","MS_ObjectComponent",null,{ms_frame:projectileframe,kind:$kind, source:$source}) as MS_ObjectComponent;
			if(_list[$graphics]){
				projectile.createBitmap(_list[$graphics]);
			}else{
				var bitmaps:Vector.<Bitmap> = Vector.<Bitmap>(GraphicManager.getInstance().getGraphics($graphics as Array));
				var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"VERTICAL");
				BitmapDataTransform.SwapColor(bitmap.bitmapData,0xFF000000,0);//Remove black to transparent
				projectile.createBitmap(bitmap);
				_list[$graphics] = bitmap;
			}
			if($source){
				var opoint:Object = $source.getCurrentFrame().opoint;
				if(opoint){
					switch (opoint.facing){
						case 0: projectile.spatialMove.facingDir = $source.spatialMove.facingDir;//move in front of source
							break;
						case 1: projectile.spatialMove.facingDir = $source.spatialMove.facingDir.toInverse();//move in front of source
							break;
					}
					projectile.x=$source.x+(opoint.x+opoint.dvx)*projectile.spatialMove.facingDir.x;//dvx and dvy are the original propulsion
					projectile.y=$source.y+opoint.y+opoint.dvy;
				}
			}
			//projectile.registerPropertyReference("collisionDetection");
			return projectile;
		}
	}
}