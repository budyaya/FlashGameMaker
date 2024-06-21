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
*    Thanks to Skinner Shaped Based Hit Detection  
*    Grant Skinner 2005
*    http://www.gskinner.com/blog/archives/2005/10/source_code_sha.html
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

package utils.physic{

	import utils.skinner.CollisionDetection;

	import flash.geom.Rectangle;
	import flash.display.*;
	
	/**
	* Shape Collision
	*/
	public class ShapeCollision {
	
		//------ Check Collision  ------------------------------------
		public static function CheckCollision(clip1:*,clip2:*):Rectangle {
			if (clip1!=null&&clip2!=null) {
				var drawin:MovieClip=new MovieClip();
				var collisionRect:Rectangle=CollisionDetection.CheckCollision(clip1,clip2);
				if (collisionRect) {
					drawin.graphics.beginFill(0x00FF00,20);
					drawin.graphics.lineStyle(0,0x00FF00,40);
					drawin.graphics.moveTo(collisionRect.x,collisionRect.y);
					drawin.graphics.lineTo(collisionRect.x+collisionRect.width,collisionRect.y);
					drawin.graphics.lineTo(collisionRect.x+collisionRect.width,collisionRect.y+collisionRect.height);
					drawin.graphics.lineTo(collisionRect.x,collisionRect.y+collisionRect.height);
					drawin.graphics.lineTo(collisionRect.x,collisionRect.y);
					return collisionRect;
				}
			}
			return null;
		}
		//------ Collision Response  ------------------------------------
		private static function CollisionResponse(clip1:MovieClip,clip2:MovieClip,collisionRect:Rectangle):void {
			if (collisionRect) {
				if (collisionRect.width<collisionRect.height) {
					if (clip1._spatial_position.x<collisionRect.x) {
						trace("Left",collisionRect.width);
						clip1._spatial_position.x-=collisionRect.width+1;
					} else if (clip1._spatial_position.x>collisionRect.x) {
						trace("Right",collisionRect.width);
						clip1._spatial_position.x+=collisionRect.width+1;
					}
				} else {
					if (clip1._spatial_properties.isFalling && clip1._spatial_position.y<collisionRect.y) {
						//trace("down", clip1._spatial_position.y,collisionRect.y,clip1.height,collisionRect.height);
						clip1._spatial_position.y=collisionRect.y-collisionRect.height-clip1.height;
						clip1._spatial_properties.isColliding=true;
						clip1._spatial_properties.isFalling=false;
					} else if (clip1._spatial_properties.isJumping && clip1._spatial_position.y>collisionRect.y) {
						trace("up",collisionRect.height);
						clip1._spatial_position.y+=collisionRect.height+1;
					}
				}
			}
			else if (clip1){
				clip1._spatial_properties.isColliding=false;
				if(clip1._spatial_jump.z!=0 && !clip1._spatial_properties.isFalling){
					clip1._spatial_properties.isMoving=true;
					clip1._spatial_properties.isFalling=true;
				}
			}
		}
	}
}