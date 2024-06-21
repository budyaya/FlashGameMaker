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
package utils.transform{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BasicTransform{
		
		//------ Change Color ------------------------------------
		public static function ChangeColor($clip:DisplayObject, $color:uint):void {
			var myColorTransform:ColorTransform = $clip.transform.colorTransform;
			myColorTransform.color = $color;
			$clip.transform.colorTransform = myColorTransform; 
		}
		//------ Change Color ------------------------------------
		public static function ChangeColorTransform($clip:DisplayObject,$redMultiplier:Number = 1.0, $greenMultiplier:Number = 1.0, $blueMultiplier:Number = 1.0, $alphaMultiplier:Number = 1.0, $redOffset:Number = 0, $greenOffset:Number = 0, $blueOffset:Number = 0, $alphaOffset:Number = 0):void {
			var myColorTransform:ColorTransform = new ColorTransform($redMultiplier,$greenMultiplier,$blueMultiplier,$alphaMultiplier,$redOffset,$greenOffset,$blueOffset,$alphaOffset);
			$clip.transform.colorTransform = myColorTransform; 
		}
		//------ FlipHorizontal  ------------------------------------
		public static function FlipHorizontal($clip:DisplayObject):void{
			var bounds:Rectangle = $clip.getBounds($clip);
			var matrix:Matrix = $clip.transform.matrix;
			matrix.a=-matrix.a;
			matrix.tx=$clip.width+bounds.x;
			$clip.transform.matrix=matrix;
		}
		//------ FlipVertical  ------------------------------------
		public static function FlipVertical($clip:DisplayObject):void{
			var bounds:Rectangle = $clip.getBounds($clip);
			var matrix:Matrix = $clip.transform.matrix;
			matrix.d=-matrix.d;
			matrix.ty=$clip.height+bounds.y;
			$clip.transform.matrix=matrix;
		}
		//------ Scale in position  ------------------------------------
		public static function ScaleInPosition($clip:DisplayObject, $scaleX:Number, $scaleY:Number):void{
			$clip.scaleX = $scaleX
			$clip.scaleY = $scaleY;
		}
		//------ SetMask  ------------------------------------
		public static function SetRectMask($clip:DisplayObject, $x:int,$y:int,$width:int,$height:int):void {
			var rectMask:Sprite = new Sprite();
			rectMask.graphics.beginFill(0x0000FF);
			rectMask.graphics.drawRect($x,$y,$width,$height);
			rectMask.graphics.endFill();
			$clip.mask = rectMask;
		}
	}
}

