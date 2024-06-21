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
package utils.bitmap{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;

	public class SwfSet extends BitmapSet{
		
		public var swf:MovieClip = null; 		// SWF Container
		public var realDisp:MovieClip = null;	// MovieClip to display
		public var bounds:Rectangle = null;		// width and height
		public var bitmapMode:Boolean = false; // If bitmapMode create a bitmapData for every single frame of swf
		
		public function SwfSet($swf:DisplayObject,$graph:BitmapGraph = null){
			super($swf,$graph);
		}
		//------ Init Var ------------------------------------
		override protected function _initVar($swf:DisplayObject,$graph:BitmapGraph):void {
			swf = $swf as MovieClip;
			if($graph){
				graph = $graph;
			}else{
				graph = new BitmapGraph;
			}
		}
		//------ Create Swf From() ------------------------------------
		public function createSwfFrom($className:String=null,$bitmapMode:Boolean =false, $fps:int=30, $sequence:Boolean=true):void {
			bitmapMode = $bitmapMode;
			if($className && swf.loaderInfo.applicationDomain.hasDefinition($className)){
				realDisp = getAssetByClass($className,swf);
			}else{
				realDisp = swf;
			}
			realDisp.x =realDisp.y=0;
			if(!bitmapMode)		graph.realDisp = realDisp;
			createBitmapFrom($className,$fps, $sequence)
		}
		//------ Create Bitmap ------------------------------------
		private function createBitmapFrom($className:String,$fps:int=30, $sequence:Boolean=true):void {
			if(!realDisp){
				throw new Error("The MovieClip specified "+$className+" doesn't exist or is not exported"); 
			}
			var labels:Array = realDisp.currentLabels;
			var y:int =0;
			if($sequence){									//All animations are on the same timeline
				for each(var label:FrameLabel in labels){
					graph.animations[label.name] = createBitmapAnimFromLabel(label.name, y, $fps);
					y++;
				}
				graph.currentAnim = graph.animations[labels[0].name];
			}else{											//All animations are contained in children movieClips
				for (var i:int = 0; i<realDisp.numChildren;i++){
					var clip:MovieClip = realDisp.getChildAt(i) as MovieClip;
					graph.animations[clip.name] = createBitmapAnimFromClip(clip, y, $fps);
					y++;
				}
				graph.currentAnim = graph.animations[realDisp.getChildAt(0).name];
			}
			graph.currentPosition = graph.currentAnim.getCell();
		}
		//------ Create Bitmap Anim From Label------------------------------------
		public function createBitmapAnimFromLabel($name:String, $y:int, $fps:int):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			realDisp.gotoAndStop($name);
			var bitmapCell:BitmapCell;
			var x:int =0;
			var bitmapData:BitmapData = null;
			while((realDisp.totalFrames==1 && list.length==0)|| realDisp.currentLabel == $name && realDisp.currentFrame<realDisp.totalFrames){
				if(bitmapMode){
					bitmapData = screenFrame();
				}
				bitmapCell = new BitmapCell(bitmapData,x,$y,swf.loaderInfo.width*swf.scaleX,swf.loaderInfo.height*swf.scaleY);
				list.push(bitmapCell);
				x++;
				realDisp.nextFrame();
			}
			return new BitmapAnim($name, list, 0, $fps);
		}
		//------ Create Bitmap Anim From Clip------------------------------------
		public function createBitmapAnimFromClip($clip:MovieClip, $y:int, $fps:int):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			var bitmapCell:BitmapCell;
			var x:int =0;
			var bitmapData:BitmapData = null;
			var prevFrame:int=0;
			$clip.x=$clip.y=0;
			$clip.gotoAndStop(1);
			//trace($clip.name, $clip.totalFrames);
			while($clip.currentFrame<=$clip.totalFrames && prevFrame!=$clip.currentFrame){
				if(bitmapMode){
					bitmapData = screenFrame($clip);
				}
				bitmapCell = new BitmapCell(bitmapData,x,$y,swf.loaderInfo.width*swf.scaleX,swf.loaderInfo.height*swf.scaleY);
				list.push(bitmapCell);
				x++;
				prevFrame = $clip.currentFrame;
				$clip.nextFrame();
			}
			return new BitmapAnim($clip.name, list, 0, $fps);
		}
		//------ Screen Frame ------------------------------------
		public function screenFrame($clip:MovieClip=null):BitmapData {
			if(!$clip)	$clip = realDisp;
			var bitmapData:BitmapData = new BitmapData(swf.loaderInfo.width*swf.scaleX,swf.loaderInfo.height*swf.scaleY, true,0);
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect, 0);
//			if(realDisp.width> bounds.width || realDisp.height> bounds.height)	
//				trace("Error: The dimension of the clip are wrong ", realDisp.width, bounds.width , realDisp.height, bounds.height);
			bitmapData.draw($clip,null);//matrix cause issues !!!
			bitmapData.unlock();
			return bitmapData;
		}
		//------ Update ------------------------------------
		public override function update():void {
		}
		/**
		 * Retrieve an exported class from the asset SWF.
		 */
		public function getAssetClass($className:String,$swf:MovieClip ):Class {
			if (!$swf.loaderInfo) {
				throw new Error("This movieClip has not been  loaded dynamically");
			}
			if ($swf) {
				return $swf.loaderInfo.applicationDomain.getDefinition($className) as Class;
			}
			return null;
		}
		/**
		 * Get an instance of a MovieClip from an asset.
		 */
		public function getAssetByClass($className:String ,$swf:MovieClip):MovieClip {
			var targetClass:Class = getAssetClass($className,$swf);
			if (targetClass is Class) {
				return new targetClass();
			}
			return null;
		}
		//------ Get Cell ------------------------------------
		override public function get position():BitmapCell {
			return graph.currentPosition;
		}
		//------ Show Frames  ------------------------------------
		public function showFrames():void {
			var index:Number=0;
			for each( var  bitmapAnim:BitmapAnim in graph.animations){
				//trace(bitmapAnim.name);
				var bitmap:DisplayObject = Framework.AddChild(new Bitmap(bitmapAnim.getCell().bitmapData));
				bitmap.y=index;
				index+=bitmap.height;
			}
		}
		//------ Clone ------------------------------------
		public function clone():SwfSet {
			var clone:SwfSet = new SwfSet(swf,null);
			clone.bitmapMode = bitmapMode;
			clone.realDisp = realDisp;
			clone.graph = graph.clone();
			clone.bounds = bounds;
			return clone;
		}
	}
}