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
package utils.bitmap{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class BitmapTo{
		
		public static function BitmapToBitmapData($bitmap:Bitmap):BitmapData{
			var bitmapData:BitmapData = new BitmapData($bitmap.width,$bitmap.height,true,0);
			bitmapData.draw($bitmap);
			return bitmapData;
		}
		public static function BitmapsToBitmap($bitmaps:Vector.<Bitmap>,$direction:String="HORIZONTAL",$offsetX:Number=0,$offsetY:Number=0):Bitmap{
			if($bitmaps.length==1){
				return $bitmaps[0];
			}
			if($direction=="HORIZONTAL"){
				var width:Number =0;
				for each(var bitmap:Bitmap in $bitmaps){
					width+=bitmap.width+$offsetX;
				}
				var height:Number = $bitmaps[0].height;
			}else if($direction=="VERTICAL"){
				height =0;
				for each(bitmap in $bitmaps){
					height+=bitmap.height+$offsetY;
				}
				width = $bitmaps[0].width;
			}else{
				throw new Error("BitmapTo: Direction must be either HORIZONTAL or VERTICAL");
			}
			var bitmapData:BitmapData = new BitmapData(width,height,true,0);
			var dist:Number=0;
			for each(bitmap in $bitmaps){
				if($direction=="HORIZONTAL"){
					bitmapData.copyPixels(bitmap.bitmapData,bitmap.bitmapData.rect,new Point(dist,0));
					dist+=bitmap.width+$offsetX;
				}else if($direction=="VERTICAL"){
					bitmapData.copyPixels(bitmap.bitmapData,bitmap.bitmapData.rect,new Point(0,dist));
					dist+=bitmap.height+$offsetY;
				}
			}
			return new Bitmap(bitmapData);
		}
	}
}