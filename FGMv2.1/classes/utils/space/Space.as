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
package utils.space{
	import flash.geom.Point;
	import flash.geom.Rectangle;


	public class Space  {
		public static const RIGHT:int		=0;
		public static const DOWN:int		=1;
		public static const LEFT:int		=2;
		public static const UP:int			=3;
		public static const RIGHT_DOWN:int	=4;
		public static const DOWN_LEFT:int	=5;
		public static const LEFT_UP:int		=6;
		public static const UP_RIGHT:int	=7;
		public static const CENTER:int		=8;
		
		public static function IsOnRightSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2>=$bound1.x+$bound1.width)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2>=$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2>=$bound1.y && $bound2.y+$bound2.height/2<=$bound1.y+$bound1.height)){
				return false;
			}
			return true;
		}
		public static function IsOnLeftSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2<=$bound1.x)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2<$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2>=$bound1.y && $bound2.y+$bound2.height/2<=$bound1.y+$bound1.height)){
				return false;
			}
			return true;
		}
		public static function IsOnUpSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictY && !($bound2.y+$bound2.height/2<=$bound1.y)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2<$bound1.y+$bound1.height/2)){
				return false;
			}
			if($strictX && !($bound2.x+$bound2.width/2>=$bound1.x && $bound2.x+$bound2.width/2<=$bound1.x+$bound1.width)){
				return false;
			}
			return true;
		}
		public static function IsOnDownSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictY && !($bound2.y+$bound2.height/2>=$bound1.y+$bound1.height)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2>$bound1.y+$bound1.height/2)){
				return false;
			}
			if($strictX && !($bound2.x+$bound2.width/2>=$bound1.x && $bound2.x+$bound2.width/2<=$bound1.x+$bound1.width)){
				return false;
			}
			return true;
		}
		public static function IsOnRightDownSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2>$bound1.x+$bound1.width)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2>$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2>=$bound1.y+$bound1.height)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2>$bound1.y+$bound1.height/2)){
				return false;
			}
			return true;
		}
		public static function IsOnDownLeftSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2<$bound1.x)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2<$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2>=$bound1.y+$bound1.height)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2>$bound1.y+$bound1.height/2)){
				return false;
			}
			return true;
		}
		public static function IsOnLeftUpSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2<$bound1.x)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2<$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2<=$bound1.y)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2<$bound1.y+$bound1.height/2)){
				return false;
			}
			return true;
		}
		public static function IsOnUpRightSide($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false):Boolean{
			if($strictX && !($bound2.x+$bound2.width/2>$bound1.x+$bound1.width)){
				return false;
			}else if(!$strictX && !($bound2.x+$bound2.width/2>$bound1.x+$bound1.width/2)){
				return false;
			}
			if($strictY && !($bound2.y+$bound2.height/2<=$bound1.y)){
				return false;
			}else if(!$strictY && !($bound2.y+$bound2.height/2<$bound1.y+$bound1.height/2)){
				return false;
			}
			return true;
		}
		public static function GetDirection($bound1:Rectangle,$bound2:Rectangle,$strictX:Boolean=false,$strictY:Boolean=false ):Number{
			if(!$bound1 || !$bound2)										return -1;
			if(IsOnRightDownSide($bound1,$bound2,$strictX,$strictY))		return RIGHT_DOWN;
			else if(IsOnDownLeftSide($bound1,$bound2,$strictX,$strictY))	return DOWN_LEFT;
			else if(IsOnLeftUpSide($bound1,$bound2,$strictX,$strictY))		return LEFT_UP;
			else if(IsOnUpRightSide($bound1,$bound2,$strictX,$strictY))		return UP_RIGHT;
			else if(IsOnRightSide($bound1,$bound2,$strictX,$strictY))		return RIGHT;
			else if(IsOnDownSide($bound1,$bound2,$strictX,$strictY))		return DOWN;
			else if(IsOnLeftSide($bound1,$bound2,$strictX,$strictY))		return LEFT;
			else if(IsOnUpSide($bound1,$bound2,$strictX,$strictY))			return UP;
			return CENTER;
		}
	}
}