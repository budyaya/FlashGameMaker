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
package utils.iso{

	import flash.geom.Point;

	public class IsoPoint extends Point {

		public var z:Number=0;
		public var xtile:Number=0;
		public var ytile:Number=0;
		public var ztile:Number=0;
		
		public function IsoPoint(x:Number=0, y:Number=0, z:Number=0){
			super(x,y);
			this.z=z;
		}
		public override function toString():String{
			var res:String= "x="+x+", y="+y+", z="+z;
			return res;
		}
		public function toNegative():IsoPoint{
			return new IsoPoint(-Math.abs(x),-Math.abs(y),-Math.abs(z));
			
		}
		public function toInverse():IsoPoint{
			return new IsoPoint(-x,-y,-z);
		}
	}
}