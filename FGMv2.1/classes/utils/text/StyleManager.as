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
package utils.text{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class StyleManager {
		public static var BasicColorTransform:ColorTransform = new ColorTransform();
		public static var BlackStroke:Array = [new GlowFilter(0,1,2,2,15,2)];
		public static var LightBlackStroke:Array = [new GlowFilter(0,1,2,2,4,2)];
		public static var RedStroke:Array = [new GlowFilter(0xFF0000,1,5,5,10,1,true)];
		public static var RedHalo:Array= [new GlowFilter(0xFFFFFF,1,2.5,2.5,8,BitmapFilterQuality.MEDIUM),new DropShadowFilter(2,90,0xFF0000,0.5,2,2,3, BitmapFilterQuality.HIGH)];
		public static var GreenStroke:Array= [new GlowFilter(0x5A7709,1,2,2,100,BitmapFilterQuality.HIGH)];
		public static var DropShadow:Array = [new DropShadowFilter(2, 90, 0x000000, 0.25, 2, 2, 1, BitmapFilterQuality.MEDIUM)];
		public static var DarkenFilter:Array = [new ColorMatrixFilter([
			0.9, 0,   0,   0, 0, // red
			0,   0.9, 0,   0, 0, // green
			0,   0,   0.9, 0, 0, // blue
			0,   0,   0,   1, 0  // alpha
		])];
		public static var UnsaturateFilter:Array = [new ColorMatrixFilter([
			0.309, 0.609, 0.082, 0, 0, // red
			0.309, 0.609, 0.082, 0, 0, // green
			0.309, 0.609, 0.082, 0, 0, // blue
			0,     0,     0,     1, 0  // alpha
		])];
		
		public static const  ClickToStart:TextFormat 	= new TextFormat("Arial", 50, 0x990000,true,null,null,null,null,TextAlign.CENTER) ;
		public static const  ToolTip:TextFormat 		= new TextFormat("Arial", 12, 0xFFFFFF,true,null,null,null,null,TextAlign.CENTER) ;
	}
}