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

package utils.fx{
	import com.greensock.TweenLite;
	
	import fl.motion.AdjustColor;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import framework.Framework;
	
	import utils.freeactionscript.Bubbles;
	import utils.senocular.PassParameters;
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;
	
	/**
	 * Fx Class
	 * 
	 */
	public class Fx {
		private static var _modal:Sprite = null;
		
		//------ Show Modal ------------------------------------
		public static function ShowModal($clip:MovieClip,$color:uint=0 ):Sprite {
			if(!_modal || !$clip.contains(_modal)){
				_modal = new Sprite();
				_modal.graphics.beginFill($color,0.5);
				var bounds:Rectangle = Framework.clip.getBounds(null);
				_modal.graphics.drawRect(0,0,bounds.width,bounds.height); 
				_modal.graphics.endFill();
				_modal.x-=$clip.getBounds($clip).x+$clip.parent.x;
				_modal.y-=$clip.getBounds($clip).y+$clip.parent.y;
				$clip.addChildAt(_modal,0);
			}else{
				Framework.clip.setChildIndex(_modal, Framework.clip.numChildren-1);
			}
			return _modal;
		}
		//------ Hide Modal ------------------------------------
		public static function HideModal():void {
			if(_modal && _modal.parent){
				_modal.parent.removeChild(_modal);
			}
			_modal = null;
		}
		//------ Button Over ------------------------------------
		public static function ButtonOver($clip:DisplayObject):void {
			if(!$clip)	return;
			var prevWidth:Number = $clip.width;
			var prevHeight:Number = $clip.height;
			$clip.scaleX+=0.1;
			$clip.scaleY+=0.1;
			$clip.x-=($clip.width-prevWidth)/2;
			$clip.y-=($clip.height-prevHeight)/2;
		}
		//------ Button Out ------------------------------------
		public static function ButtonOut($clip:DisplayObject):void {
			if(!$clip)	return;
			var prevWidth:Number = $clip.width;
			var prevHeight:Number = $clip.height;
			$clip.scaleX-=0.1;
			$clip.scaleY-=0.1;
			$clip.x-=($clip.width-prevWidth)/2;
			$clip.y-=($clip.height-prevHeight)/2;
		}
		//------ Button Out ------------------------------------
		public static function ButtonClicked($clip:DisplayObject):void {
			if(!$clip)	return;
			$clip.filters = StyleManager.RedStroke;
		}
		//------ Button Released ------------------------------------
		public static function ButtonReleased($clip:DisplayObject):void {
			if(!$clip)	return;
			$clip.filters = [];
		}
		//------ Add Bubbles ------------------------------------
		public static function AddBubbles($clip:MovieClip, $offset:Point=null):void {
			var bubbles:Bubbles = new Bubbles($offset);
			$clip.bubbles = bubbles;
			$clip.addChild(bubbles);
			bubbles.play();
			
			bubbles.alpha=0.5;
		}
		//------ Remove Bubbles ------------------------------------
		public static function RemoveBubbles($clip:MovieClip):void {
			var bubbles:Bubbles = $clip.bubbles;
			if(bubbles && $clip.contains(bubbles)){
				$clip.removeChild(bubbles);
				bubbles.destroy();
			}
		}
		//------ Night ------------------------------------
		public static function Night($clip:DisplayObject, $duration:Number=1000):void {
			var timer:Timer = new Timer($duration, 55);
			var onTimer:Function = function($timer:TimerEvent,$clip:DisplayObject):void{
				var color:AdjustColor = new AdjustColor();
				color.hue = -$timer.target.currentCount;
				color.contrast = -$timer.target.currentCount;
				color.brightness = -$timer.target.currentCount;
				color.saturation = -$timer.target.currentCount;
				$clip.filters = [new ColorMatrixFilter( color.CalculateFinalFlatArray() )]
			}
			timer.addEventListener(TimerEvent.TIMER, PassParameters.AddArguments(onTimer, [$clip]),false,0,true);
			timer.start();
		}
		//------ Day ------------------------------------
		public static function Day($clip:DisplayObject, $duration:Number=1000):void {
			var timer:Timer = new Timer($duration, 50);
			var onTimer:Function = function($timer:TimerEvent,$clip:DisplayObject):void{
				var color:AdjustColor = new AdjustColor();
				color.hue = -($timer.target.repeatCount-$timer.target.currentCount);
				color.contrast = -($timer.target.repeatCount-$timer.target.currentCount);
				color.brightness = -($timer.target.repeatCount-$timer.target.currentCount);
				color.saturation = -($timer.target.repeatCount-$timer.target.currentCount);
				$clip.filters = [new ColorMatrixFilter( color.CalculateFinalFlatArray() )]
			}
			timer.addEventListener(TimerEvent.TIMER, PassParameters.AddArguments(onTimer, [$clip]),false,0,true);
			timer.start();
		}
		//------ Disappearing Text ------------------------------------
		public static function DisappearingText($position:Point, $text:String, $color:uint=0xFFFFFF, $distance:Point=null,$duration:Number=5):void {
			if(!$distance){
				$distance=new Point(0,-50);
			}
			var tf:TextField = new TextField();
			tf.autoSize="center";
			tf.text = $text;
			var textFormat:TextFormat = new TextFormat("Arial",16, $color,true,null,null,null,null,TextAlign.CENTER);
			tf.setTextFormat(textFormat) ;
			tf.filters = [new GlowFilter(0,1,4,4,20,1)];
			Framework.clip.addChild(tf);
			tf.x = $position.x;
			tf.y = $position.y;
			TweenLite.to(tf,$duration,{x:tf.x+$distance.x,y:tf.y+$distance.y,alpha:0, onComplete:onTextComplete, onCompleteParams:[tf]});
		}
		//------ Disappearing Complete ------------------------------------
		public static function onTextComplete($tf:TextField):void {
			$tf.parent.removeChild($tf);
			$tf = null;
		}
	}
}