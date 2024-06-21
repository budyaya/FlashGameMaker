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
package data{
	import com.adobe.serialization.json.JSON;
	
	public class Data{
		public static const OBJECT_KIND_CHARACTER:int 		= 0; // Character
		public static const OBJECT_KIND_PROJECTILE:int 		= 1; // Bullet
		
		public static const OBJECT:Object =
			{
				'1':{
					'name': 'Player','kind':0,'data':'data/Player.txt',
					'graphics':['assets/MS.png']
					},
				'100':{
					'name': 'Bullet','kind':1,'data':'data/Bullet.txt',
					'graphics':['assets/bullet.png']
				}
			}
		public static const BACKGROUND:Object =
			{
				'bg':{
					'path':'assets/MSbg.png'
				},
				'mainMusic':{
					'path':'assets/main.mp3'
				}
			}
		public static const OTHER:Object =
			{
				'chrono':{
					'path':'assets/chrono.png'
				},
				'score':{
					'path':'assets/score.png'
				},
				'rpgText':{
					'path':'assets/rpgText.swf'
				},
				'statutBar':{
					'path':'assets/statutBar.swf'
				},
				'soundControl':{
					'path':'assets/soundControl.swf'
				},
				'gameOverScreen':{
					'path':'assets/gameOverScreen.swf'
				}
			}
	}
}