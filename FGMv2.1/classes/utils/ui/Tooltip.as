/*
*   @author AngelStreet
*   Blog:http://angelstreetv2.blogspot.com/
*   Google Code: http://code.google.com/p/2d-isometric-engine/
*   Source Forge: https://sourceforge.net/projects/isoengineas3/
*/

/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*
*    This program is distrubuted through the Creative Commons Attribution-NonCommercial 3.0 Unported License.
*    Under this licence you are free to copy, adapt and distrubute the work. 
*    You must attribute the work in the manner specified by the author or licensor. 
*    You may not use this work for commercial purposes.  
*    You should have received a copy of the Creative Commons Public License along with this program.
*    If not,visit http://creativecommons.org/licenses/by-nc/3.0/ or send a letter to Creative Commons,
*    171 Second Street, Suite 300, San Francisco, California, 94105, USA.  
*/
package utils.ui{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.Framework;

	/**
	 * Tooltip Class
	 */
	public class Tooltip {
		private static var _hPad:int = 10;
		private static var _vPad:int = 4;
		public static var tooltip:MovieClip = null;
		
		public static function CreateTooltip($displayObject:DisplayObject,$color:uint,$alpha:Number=1,$filters:Array=null, $reference:DisplayObject=null):MovieClip{
			if(tooltip && tooltip.content == $displayObject)	return null;
			RemoveTooltip();
			tooltip = new MovieClip();
			tooltip.mouseChildren = false;
			tooltip.mouseEnabled = false;
			var bg:Sprite = createBg($displayObject,$color);
			tooltip.addChild(bg);
			tooltip.addChild($displayObject);
			LayoutUtil.Align($displayObject,LayoutUtil.ALIGN_CENTER_CENTER,bg,null);
			tooltip.filters = $filters;
			tooltip.alpha = $alpha;
			tooltip.content = $displayObject;
			if($reference){
				LayoutUtil.Align(tooltip,LayoutUtil.ALIGN_BOTTOM_CENTER,$reference,LayoutUtil.ALIGN_TOP_CENTER,new Point(0,-15));
			}else{
				tooltip.x = Framework.clip.mouseX - tooltip.width/2;
				tooltip.y = Framework.clip.mouseY - tooltip.height/2 -40;
			}
			LayoutUtil.CheckBorder(tooltip);
			Framework.AddChild(tooltip); 
			return tooltip;
		}
		private static function createBg($displayObject:DisplayObject,$color:uint):Sprite{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill($color);
			sprite.graphics.drawRoundRect(0,0,$displayObject.width+_hPad,$displayObject.height+_vPad,6,6);
			sprite.graphics.endFill();
			return sprite;
		}
		public static function RemoveTooltip():void{
			if(tooltip && Framework.clip.contains(tooltip)){
				Framework.RemoveChild(tooltip);
			}
		}
		public static function GetTooltip():MovieClip{
			return tooltip;
		}
	}
}