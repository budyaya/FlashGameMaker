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
	import flash.display.BitmapData;
	
	public class BitmapCell{
		
		public var bitmapData:BitmapData;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var offsetX:Number;
		public var offsetY:Number;
		public var wait:int=0;
		public var next:BitmapCell=null;
		public var prev:BitmapCell=null;
		public var flip:Boolean = false;
		
		public function BitmapCell($bitmapData:BitmapData,$x:Number,$y:Number,$width:Number,$height:Number, $offsetX:Number=0, $offsetY:Number=0, $wait:int=0, $next:BitmapCell=null,$prev:BitmapCell=null){
			bitmapData 	= $bitmapData
			x 			= $x;
			y 			= $y;
			width 		= $width;
			height		= $height;
			offsetX 	= $offsetX;
			offsetY 	= $offsetY;
			wait 		= $wait
			next 		= $next;
			prev 		= $prev;
		}
	}
}