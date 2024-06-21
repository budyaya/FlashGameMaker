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

package framework.component.core{
	import flash.display.*;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import framework.Framework;
	import framework.entity.IEntity;
	
	import utils.iso.IsoPoint;

	/**
	* Scrolling Bitmap Component
	* @ purpose: 
	*/
	public class ScrollingBitmapComponent extends GraphicComponent {
		private var _bitmap:Bitmap=null;
		private var _canvas:Object=null;
		private var _rectangle:Rectangle=null; // Scrolling rectangle position
		private var _scrollingTarget:*=null; // If auto scroll based on a target
		private var _loop:Boolean=true; // At then end of the image go back to the start
		private var _speed:Point=new Point(0,0);
		private var _offset:Point = new Point(0,0);
		
		public function ScrollingBitmapComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			if($prop && $prop.speed)		_speed 		= $prop.speed;
			if($prop && $prop.autoScroll)	_autoScroll = $prop.autoScroll;
			if($prop && $prop.loop)			_loop 		= $prop.loop;
			if($prop && $prop.canvas)		_canvas 	= $prop.canvas;
			_bitmap = new Bitmap();
		}
		//------ On Graphic Loading Complete ------------------------------------
		protected override function onGraphicLoadingComplete($graphic:DisplayObject, $callback:Function=null):void {
			graphic = $graphic;
			if($callback is Function)	$callback(this);
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			scrollBitmap();
		}
		//----- Scroll Bitmap  -----------------------------------
		public function scrollBitmap():void {
			if(_speed.x!=0){//Horizontal
				scrollH();
			}
			if(_speed.y!=0){//Vertical
				scrollV();
			}
		}
		//----- Scroll Horizontal  -----------------------------------
		public function scrollH():void {
			_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect,0);//Try
			if(_speed.x>0){		
				if(_loop && _canvas.width>=_graphic.width){
					var rect1:Rectangle = new Rectangle(_speed.x, _rectangle.y, _rectangle.width-_speed.x, _rectangle.height);
					var rect2:Rectangle = new Rectangle(_offset.x, _rectangle.y, _speed.x, _rectangle.height);
					var tmp:Bitmap = new Bitmap();
					tmp.bitmapData = new BitmapData(rect2.width, rect2.height,true,0);
					tmp.bitmapData.copyPixels(_bitmap.bitmapData,rect2 , new Point(0, 0),null,null,true);
					rect2.x=0;
					_bitmap.bitmapData.copyPixels(_bitmap.bitmapData,rect1 , new Point(0, 0),null,null,true);
					_bitmap.bitmapData.copyPixels(tmp.bitmapData,tmp.bitmapData.rect , new Point(_rectangle.width-_speed.x, 0),null,null,true);
					tmp.bitmapData.dispose();
					tmp.bitmapData = null;
				}else if(_loop && _canvas.width<_graphic.width && _rectangle.x+_rectangle.width+_speed.x>_graphic.width && !(_rectangle.x+_speed.x>_graphic.width)){
					_rectangle.x+=_speed.x;
					var dist:Number = _rectangle.x+_rectangle.width - _graphic.width;
					rect1 = new Rectangle(_rectangle.x, _rectangle.y, _rectangle.width-dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect1 , new Point(0, 0),null,null,true);
					rect2 = new Rectangle(0, _rectangle.y, dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect2 , new Point(_rectangle.width-dist, 0),null,null,true);
				}else if(_loop || _rectangle.x+_rectangle.width<_graphic.width){
					_rectangle.x+=_speed.x;
					if(!_loop && _rectangle.x+_rectangle.width>_graphic.width){
						_rectangle.x=_graphic.width-_rectangle.width;
					}
					if(_rectangle.x>_graphic.width){
						_rectangle.x-= _graphic.width;
					}
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_rectangle , new Point(0, 0),null,null,true);
				}
			}else if(_speed.x<0){		
				if(_loop && _canvas.width>=_graphic.width){
					rect1 = new Rectangle(0, _rectangle.y, _rectangle.width+_speed.x, _rectangle.height);
					rect2 = new Rectangle(_graphic.width+_speed.x, _rectangle.y, -_speed.x, _rectangle.height);
					tmp = new Bitmap();
					tmp.bitmapData = new BitmapData(rect2.width, rect2.height,true,0);
					tmp.bitmapData.copyPixels(_bitmap.bitmapData,rect2 , new Point(0, 0),null,null,true);
					rect2.x=0;
					_bitmap.bitmapData.copyPixels(_bitmap.bitmapData,rect1 , new Point(-_speed.x, 0),null,null,true);
					_bitmap.bitmapData.copyPixels(tmp.bitmapData,tmp.bitmapData.rect , new Point(0, 0),null,null,true);
					tmp.bitmapData.dispose();
					tmp.bitmapData = null;
				}else if(_loop && _canvas.width<_graphic.width && _rectangle.x+_speed.x<0 && !(_rectangle.x+_speed.x+_rectangle.width<0)){
					_rectangle.x+=_speed.x;
					dist = -_rectangle.x;
					rect1 = new Rectangle(_graphic.width-dist, _rectangle.y, dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect1 , new Point(0, 0),null,null,true);
					rect2 = new Rectangle(0, _rectangle.y, _rectangle.width-dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect2 , new Point(dist, 0),null,null,true);
				}else if(_loop || _rectangle.x>0){
					_rectangle.x+=_speed.x;
					if(!_loop && _rectangle.x<0){
						_rectangle.x=0;
					}
					if(_rectangle.x+_speed.x+_rectangle.width<0){
						_rectangle.x= _graphic.width-_rectangle.width;
					}
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_rectangle , new Point(0, 0),null,null,true);
				}
			}
		}
		//----- Scroll Vertical  -----------------------------------
		public function scrollV():void {
			_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect,0);//Try
			if(_rectangle.y+_rectangle.height+_speed.y<_graphic.height){
				_rectangle.y+=_speed.y;
			}else if(_loop){
				if(_rectangle.y+_speed.y<_graphic.height){
					_rectangle.y+=_speed.y;
					var dist:Number = _rectangle.y+_rectangle.height+_speed.y - _graphic.height;
					var rect1:Rectangle = new Rectangle(_rectangle.y, _rectangle.y, _rectangle.height-dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect1 , new Point(0, 0),null,null,true);
					var rect2:Rectangle = new Rectangle(0, _rectangle.y, dist, _rectangle.height);
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,rect2 , new Point(_rectangle.height-dist, 0),null,null,true);
					return;
				}else{
					_rectangle.y=0;
				}
			}else{
				_rectangle.y=_graphic.height-_rectangle.height;
			}
			_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_rectangle , new Point(0, 0),null,null,true);
		}
		//----- Scroll  -----------------------------------
		public function scroll(x:Number,y:Number):void {
			_rectangle.x=x;
			_rectangle.y=y;
		}
		//----- Flip BitmapData  -----------------------------------
		public function flipBitmapData(myBitmapData:BitmapData):void {
			var flipHorizontalMatrix:Matrix = new Matrix();
			flipHorizontalMatrix.scale(-1,1);
			flipHorizontalMatrix.translate(myBitmapData.width,0);
			var flippedBitmapData:BitmapData=new BitmapData(myBitmapData.width,myBitmapData.height,true,0);
			flippedBitmapData.draw(myBitmapData,flipHorizontalMatrix);
			myBitmapData.fillRect(myBitmapData.rect,0);
			myBitmapData.draw(flippedBitmapData);
			flippedBitmapData.dispose();
			flippedBitmapData = null;
		}
		//----- Set Loop -----------------------------------
		public function set loop(loop:Boolean):void {
			_loop=loop;
		}
		//------ Set graphic ------------------------------------
		public override function set graphic($graphic:*):void {
			if(_graphic && contains(_graphic)){
				Framework.RemoveChild(_graphic,this);
			}
			_graphic = $graphic;
			Framework.AddChild(_bitmap,this);
			if(_canvas){
				if(_bitmap.bitmapData){
					_bitmap.bitmapData.dispose();//Try
					_bitmap.bitmapData = null;
				}	
				_bitmap.bitmapData = new BitmapData(_canvas.width,_canvas.height,true,0);
				_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect,0);//Try
				_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_graphic.bitmapData.rect , new Point(0, 0),null,null,true);
				if(_graphic.width<_canvas.width && _canvas.repeatX){
					var repeat:int = Math.ceil(_canvas.width/_graphic.width);
					_offset.x = _canvas.width - Math.floor(_canvas.width/_graphic.width)*_graphic.width;
					for (var i:int=1; i<repeat+1;i++){
						_bitmap.bitmapData.copyPixels(_graphic.bitmapData, _graphic.bitmapData.rect , new Point(i*_graphic.width, 0),null,null,true);
					}
				}
				/*if(_graphic.height<_canvas.height && _canvas.repeatY){
					distance = _canvas.height-_graphic.heightZ;
					_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_graphic.bitmapData.rect , new Point(0, _graphic.height),null,null,true);
				}*/
			}else{
				_canvas = {"width": _graphic.width, "height":_graphic.height}
				if(_bitmap.bitmapData){
					_bitmap.bitmapData.dispose();//Try
					_bitmap.bitmapData = null;
				}	
				_bitmap.bitmapData = new BitmapData(_graphic.width,_graphic.height,true,0 );
				_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect,0);//Try
				_bitmap.bitmapData.copyPixels(_graphic.bitmapData,_graphic.bitmapData.rect , new Point(0, 0),null,null,true);
			}
			_rectangle=new Rectangle(0,0,_bitmap.width,_bitmap.height);
			if(_autoScroll){
				registerPropertyReference("enterFrame", {onEnterFrame:onTick});
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}