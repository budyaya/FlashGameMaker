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
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	/**
	 * Clip
	 */
	public class Clip {
	
		public static function ChangeClipColor($source:MovieClip, $colors:Array):void {
			var i:int=0;
			while(i<$source.numChildren){
				if($source.getChildAt(i) is MovieClip){
					var clip:MovieClip = $source.getChildAt(i) as MovieClip;
					for each(var object:Object in $colors){
						if(clip.name.indexOf(object.target)!=-1){
							var colorTransform:ColorTransform =new ColorTransform();
							colorTransform.color = object.color;
							clip.transform.colorTransform=colorTransform;
						}
					}
					if(clip.numChildren>0){
						ChangeClipColor(clip,$colors);
					}
				}
				i++;
			}
		}
		public static function ChangeClipFrame($source:MovieClip, $target:Array, $frame:uint):void {
			var clip:MovieClip = $source;
			for each (var target:String in  $target){
				if(clip.getChildByName(target)!=null){
					clip = clip[target];
				}else{
					trace("[*WARNING]" +target +" is not a children of "+clip.name);
					continue;
				}
			}
			if(clip is MovieClip){
				clip.gotoAndStop($frame);
			}
		}
		public static function ChangeClipsFrame($source:MovieClip, $targets:Array, $callback:Function=null):void {
			var i:int=0;
			var clip:MovieClip;
			while(i<$source.numChildren){
				clip = $source.getChildAt(i) as MovieClip;
				if(clip){
					for each (var object:Object in $targets){
						var target:Array = object.target;
						var frame:uint = object.frame;
						ChangeClipFrame(clip,target, frame);
					}
				}
				i++;
			}
			if($callback!=null)	setTimeout($callback,300,$source);
		}
	}
}