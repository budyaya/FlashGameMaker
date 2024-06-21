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

package utils.stuv{	
	
	public class NavigatePath{
		
		//------ Up  ------------------------------------
		static public function up(pathT:String, levelT:Number):String {
			var newPath:String = new String(pathT);
			var levels:Number = levelT + 1;
			while (levels--) {
				newPath = current(newPath);
			}
			return newPath;
		}
		//------ Current  ------------------------------------
		static public function current(pathT:String):String {
			var curDir:Number = Math.max(pathT.lastIndexOf("\\"), pathT.lastIndexOf("/"));
			return pathT.substr(0, curDir);
		}
		//------ Get File Name  ------------------------------------
		static public function getFileName(fullPathT:String):String {
			var pos:int = fullPathT.lastIndexOf("/");
			return fullPathT.substr(pos+1);
		}
	}
}


