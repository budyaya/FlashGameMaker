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

package utils.movieclip{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * Frame
	 */
	public class Frame {
	//------ Get Frame ------------------------------------
		public static function GetFrameFromLabel($frame:Object, clip:MovieClip):Number{
			if($frame is Number){
				return Number($frame);
			}else if($frame is String){
				var labels:Array = clip.currentLabels;
				for(var i:Number=0;i<labels.length;i++){
					var frameLabel:FrameLabel = labels[i];
					if(frameLabel.name == $frame){
						return frameLabel.frame;
					}
				}
			} 
			return -1;
		}
	}
}