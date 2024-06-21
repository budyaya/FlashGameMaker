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
package script{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.component.add.*;
	import framework.component.core.*;
	import framework.entity.*;
	
	/**
	 * Test
	 */
	public class Demo {
		
		public function Demo() {
			//EntityFactory.CreateBgColor("BgColor", 0x00CC00, 0.5);
			//EntityFactory.CreateBgGradientColor("BgGradientColor", GradientType.LINEAR, [0x0000FF,0xFFFFFF], [1,1], [0,255]);
			//EntityFactory.CreateScrollingBitmap("ScrollingBitmap","../assets/nuage.jpg", 0, 30, 1, new Point(0.4,0));//TODO:DEPRECATED need a fix
			//EntityFactory.CreateGraphic("graphic1", "../FGM.png", 90, 300);
			//EntityFactory.CreateGraphic("graphic2", "../FGM.png", 90, 500);
			EntityFactory.CreateSystemInfo("SystemInfo",0,0);
			//EntityFactory.CreateRPGText("RPGText","../assets/rpgText.swf",3000);
			//EntityFactory.CreateTime("Time",200, 200, 0, 15);
			//EntityFactory.CreateGamePad("GamePad", 0,30);
			//EntityFactory.CreateBitmapPlayer("BitmapPlayer", "../assets/templeKnightSet.png", 90, 300, new Point(2,2),false, true,true,true);
			//EntityFactory.CreateSwfPlayer("SwfPlayer", "../assets/bebeClip.swf", 90, 300, new Point(2,2),false, true,true,true);
			//EntityFactory.CreateFoxMiniGame("Fox", "../assets/Fox.swf", 10,150);
			//EntityFactory.CreateFoxMiniGame2("Fox", "../assets/Fox.swf", 10,150);
			//EntityFactory.CreateAnimation("Fox", "../assets/Fox.swf", 0,150);
			EntityFactory.CreateAnimations("Animations");
			//EntityFactory.CreateTileMap("TileMap");
			//EntityFactory.CreateCursor("Cursor", "../assets/cursor.swf");
			//EntityFactory.CreateChrono("Chrono", "../assets/chrono.png", 250,500, 100,100);
			
		}
	}
}