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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	
	/**
	 * LayoutUtil Class: Help organize displayObjetc on the scene
	 */
	public class LayoutUtil {
		
		public static const CENTER:String = 	"CENTER";
		public static const RIGHT:String = 		"RIGHT";
		public static const LEFT:String = 		"LEFT";
		public static const TOP:String = 		"TOP";
		public static const BOTTOM:String = 	"BOTTOM";
		
		public static const ALIGN_TOP_LEFT:String =		"TOP_LEFT";
		public static const ALIGN_TOP_CENTER:String =	"TOP_CENTER";
		public static const ALIGN_TOP_RIGHT:String = 	"TOP_RIGHT";
		public static const ALIGN_CENTER_LEFT:String =	"CENTER_LEFT";
		public static const ALIGN_CENTER_CENTER:String ="CENTER_CENTER";
		public static const ALIGN_CENTER_RIGHT:String =	"CENTER_RIGHT";
		public static const ALIGN_BOTTOM_LEFT:String = 	"BOTTOM_LEFT";
		public static const ALIGN_BOTTOM_CENTER:String ="BOTTOM_CENTER";
		public static const ALIGN_BOTTOM_RIGHT:String =	"BOTTOM_RIGHT";	
		
		public function LayoutUtil() {
			
		}
		/**
		 * Align on both axes using the ALIGN_ consts to as alignment params.
		 * eg align( a, ALIGN_TOP_LEFT, b, ALIGN_CENTER_CENTER ) will align the top left of a to the full center of b.
		 * 
		 * @param $subject:DisplayObject	: the object to be moved.
		 * @param $subjectAlign:String		: one of the ALIGN_ consts
		 * @param $reference:DisplayObject	: the object to be aligned to
		 * @param $refAlign:String			: one of the ALIGN_ consts
		 * @param $offset:Point				: offset the position of the $subject by this much
		 * @param $addAsChild:Boolean		: whether to add the $subject to the $reference as a child
		 * @param $round:Boolean			: whether to round the position values
		 */
		public static function Aligns( $subjects:Array, $subjectAlign:String, $reference:DisplayObject=null, $refAlign:String=null, $offset:Point=null, $addAsChild:Boolean=false, $round:Boolean=true ):void {
			for each (var subject:DisplayObject in $subjects){
				Align(subject,$subjectAlign,$reference,$refAlign,$offset,$addAsChild,$round);
			}
		}
		public static function Align( $subject:DisplayObject, $subjectAlign:String, $reference:DisplayObject=null, $refAlign:String=null, $offset:Point=null, $addAsChild:Boolean=false, $round:Boolean=true, $checkBorder:Boolean=false  ):void {
			if (!$refAlign) $refAlign = $subjectAlign;
			if (!$offset) $offset = new Point(0,0);
			
			var subStrs:Array = $subjectAlign.split("_");
			var refStrs:Array = $refAlign.split("_");
			
			if(!$reference || $reference.width ==0 || $reference.height==0){
				var rect:Sprite = new Sprite;
				rect.graphics.beginFill(0);
				rect.graphics.drawRect(0,0,Framework.width, Framework.height);
				rect.graphics.endFill();
				$reference = rect;
			}else{
				var bounds:Rectangle = $reference.getBounds($reference);
				rect = new Sprite;
				rect.graphics.beginFill(0);
				rect.graphics.drawRect(0,0,bounds.width, bounds.height);
				rect.graphics.endFill();
				rect.x = bounds.x;
				rect.y = bounds.y;
				if($reference.parent){
					var globalPosition:Point = $reference.parent.localToGlobal(new Point(rect.x,rect.y));
					rect.x = globalPosition.x;
					rect.y = globalPosition.y;
				}
				$reference = rect;
			}	
			
			verticalAlign( $subject, subStrs[0], $reference, refStrs[0], $offset.y, false, $round );
			horizontalAlign( $subject, subStrs[1], $reference, refStrs[1], $offset.x, false, $round );
			if($checkBorder){
				CheckBorder($subject);
			}
			if ($addAsChild) ($reference as Sprite).addChild( $subject );
		}
		public static function GetAlignPosition( $subject:DisplayObject, $subjectAlign:String, $reference:DisplayObject=null, $refAlign:String=null, $offset:Point=null, $addAsChild:Boolean=false, $round:Boolean=true, $checkBorder:Boolean=false ):Point {
			var rect:Sprite = new Sprite;
			rect.graphics.beginFill(0);
			rect.graphics.drawRect(0,0,$subject.width, $subject.height);
			rect.graphics.endFill();
			rect.x = $subject.x;
			rect.y = $subject.y;
			Align(rect, $subjectAlign, $reference, $refAlign, $offset, $addAsChild, $round, $checkBorder);
			return new Point(rect.x,rect.y);
		}
		/**
		 * leftAlign one DisplayObject to another DisplayObject
		 * 
		 * @param $subject:DisplayObject	: the DisplayObject to be moved
		 * @param $reference:Sprice			: the DisplayObject to be aligned with
		 * @param $offset:Number			: offset the x position by this much
		 * @param $addAsChild:Boolean		: and add the $subject to the $reference as a child.
		 */
		public static function leftAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			horizontalAlign($subject, LEFT, $reference, LEFT, $offset, $addAsChild);
		}
		
		/**
		 * Like leftAlign
		 */
		public static function hCenterAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			horizontalAlign($subject, CENTER, $reference, CENTER, $offset, $addAsChild);
		}
		
		/**
		 * Like leftAlign
		 */
		public static function rightAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			horizontalAlign($subject, RIGHT, $reference, RIGHT, $offset, $addAsChild);
		}
		
		/**
		 * Like leftAlign
		 */
		public static function topAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			verticalAlign($subject, TOP, $reference, TOP, $offset, $addAsChild);
		}
		
		/**
		 * Like leftAlign
		 */
		public static function vCenterAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			verticalAlign($subject, CENTER, $reference, CENTER, $offset, $addAsChild);
		}
		
		/**
		 * Like leftAlign
		 */
		public static function bottomAlign( $subject:DisplayObject, $reference:DisplayObject, $offset:Number=0, $addAsChild:Boolean=false ):void {
			verticalAlign($subject, BOTTOM, $reference, BOTTOM, $offset, $addAsChild);
		}
		
		/**
		 * Align center on X and Y
		 * 
		 * @param $subject:DisplayObject	: the DisplayObject to be moved
		 * @param $reference:Sprice			: the DisplayObject to be aligned with
		 * @param $xOffset:Number			: offset the x position by this much
		 * @param $yOffset:Number			: offset the y position by this much
		 * @param $addAsChild:Boolean		: and add the $subject to the $reference as a child.
		 */
		public static function centerAlign( $subject:DisplayObject, $reference:DisplayObject, $xOffset:Number=0, $yOffset:Number=0, $addAsChild:Boolean=false ):void {
			verticalAlign($subject, CENTER, $reference, CENTER, $yOffset, false);
			horizontalAlign($subject, CENTER, $reference, CENTER, $xOffset, false);
			
			if ($addAsChild) ($reference as Sprite).addChild( $subject );
		}
		
		/**
		 * Center a DisplayObject on the stage
		 */
		public static function centerOnStage( $subject:DisplayObject, $xOffset:Number=0, $yOffset:Number=0 ):void {
			var stage:DisplayObject = getStage();
			//			Core.log("stage w: "+stage.width+ " stage h:"+stage.height);
			horizontalAlign($subject, CENTER, stage, CENTER, $xOffset, false); 
			verticalAlign($subject, CENTER, stage, CENTER, $yOffset, false);
		}
		
		/**
		 * Get a DisplayObject representing the stage. Can be used to align DisplayObjects to the stage.
		 */
		public static function getStage():DisplayObject {
			var s:Sprite = new Sprite();
			var r:Rectangle = new Rectangle(0,0,Framework.width, Framework.height);
			s.graphics.drawRect( r.x, r.y, r.width, r.height );
			return s;
		}
		
		/**
		 * addToParentCentred
		 *
		 * @param $parent - parent obj
		 * @param $child - child obj
		 * @param $y - y coord to use for this display object
		 */ 
		public static function addToParentCentred($parent:DisplayObject, $child:DisplayObject, $y:int):void {
			$child.y = $y;
			hCenterAlign( $child, $parent, 0, true );
		}
		
		/**
		 * Align one DisplayObject to another horizontally.  You can define which points on the subject and reference to align.
		 * eg: You can align the left edge of the subject to the center of the reference.
		 * 
		 * @param $subject:DisplayObject	: the DisplayObject to be moved
		 * @param $subjectAlign:String		: the alignment option. one of LEFT, CENTER, or RIGHT
		 * @param $reference:DisplayObject	: the DisplayObject to be aligned with
		 * @param $refAlign:String			: one of LEFT, CENTER, or RIGHT
		 * @param $offset:Number			: after alignment, adjust the $subject's x position
		 * @param $addAsChild:Boolean		: whether to add the $subject as a child of the $reference.
		 * @param $round:Boolean			: whether to round the position value
		 */
		public static function horizontalAlign( $subject:DisplayObject, $subjectAlign:String, $reference:DisplayObject, $refAlign:String=null, $offset:Number=0, $addAsChild:Boolean=false, $round:Boolean=true):void {
			if (!$refAlign) $refAlign = $subjectAlign;
			
			var refPoint:Number;
			switch ($refAlign) {
				case LEFT:
					refPoint = $reference.x;
					break;
				case CENTER:
					refPoint = $reference.x + $reference.width/2;
					break;
				case RIGHT:
					refPoint = $reference.x + $reference.width;
			}
			
			var pos:Number;
			switch ($subjectAlign) {
				case LEFT:
					pos = refPoint;
					break;
				case CENTER:
					pos = refPoint - $subject.width/2;
					break;
				case RIGHT:
					pos = refPoint - $subject.width;
			}
			
			pos += $offset;
			
			if ($round) {
				$subject.x = Math.round(pos);
			} else {
				$subject.x = pos;
			}
			
			if ($addAsChild) ($reference as Sprite).addChild( $subject );
		}
		
		
		/**
		 * Similar to horizontalAlign
		 */
		public static function verticalAlign( $subject:DisplayObject, $subjectAlign:String, $reference:DisplayObject, $refAlign:String=null, $offset:Number=0, $addAsChild:Boolean=false, $round:Boolean=true ):void {
			if (!$refAlign) $refAlign = $subjectAlign;
			
			var refPoint:Number;
			switch ($refAlign) {
				case TOP:
					refPoint = $reference.y;
					break;
				case CENTER:
					refPoint = $reference.y + $reference.height/2;
					break;
				case BOTTOM:
					refPoint = $reference.y + $reference.height;
			}
			
			var pos:Number;
			switch ($subjectAlign) {
				case TOP:
					pos = refPoint;
					break;
				case CENTER:
					pos = refPoint - $subject.height/2;
					break;
				case BOTTOM:
					pos = refPoint - $subject.height;
			}
			
			pos += $offset;
			
			if ($round) {
				$subject.y = Math.round(pos);
			} else {
				$subject.y = pos;
			}
			
			if ($addAsChild) ($reference as Sprite).addChild( $subject );
		}
		
		public static function constrainToRectangle( $subject:DisplayObject, $targetBounds:Rectangle, $padding:Number=0 ):void {
			
			var subjectBounds:Rectangle = $subject.getBounds($subject);
			var targetBounds:Rectangle = $targetBounds;
			
			if ($padding) {
				targetBounds.x += $padding;
				targetBounds.y += $padding;
				targetBounds.width -= $padding*2;
				targetBounds.height -= $padding*2;
			}
			
			var ratio:Number = Math.min( targetBounds.width/subjectBounds.width, targetBounds.height/subjectBounds.height );
			
			$subject.scaleX = $subject.scaleY = ratio;
			
			$subject.x = (targetBounds.x - subjectBounds.x) + targetBounds.width/2  - subjectBounds.width/2;
			$subject.y = (targetBounds.y - subjectBounds.y) + targetBounds.height/2 - subjectBounds.height/2;
		}
		
		public static function drawDebugGuide( $subject:DisplayObject, $color:int=0xFF0000, $reference:DisplayObjectContainer=null ):void {
			var ref:DisplayObjectContainer = $reference ? $reference: Framework.stage;
			
			var b:Rectangle = $subject.getBounds( ref );
			var vis:Sprite = new Sprite();
			vis.graphics.lineStyle( 1, $color );
			vis.graphics.drawRect( b.x, b.y, b.width, b.height );
			
			var loc:Point = new Point( $subject.x, $subject.y );
			$subject.localToGlobal( loc );
			vis.graphics.lineStyle( 3, $color );
			vis.graphics.drawCircle( loc.x, loc.y, 3);
			
			ref.addChild( vis );
		}
		
		public static function drawDebugPoint( $point:Point, $color:int=0xFF0000, $reference:DisplayObjectContainer=null ):void {
			var ref:DisplayObjectContainer = $reference ? $reference: Framework.stage;
			
			var vis:Sprite = new Sprite();
			vis.graphics.beginFill($color);
			vis.graphics.drawCircle($point.x, $point.y, 3);
			vis.graphics.endFill();
			
			ref.addChild( vis );
		}
		
		public static function describeDisplayObject( $disp:DisplayObject, $indent:String="\t" ):void{
			trace($indent
				+ $disp.parent.getChildIndex($disp) +": "
				+ $disp.toString() 
				+ " n:"+$disp.name
				+ ", vis:"+$disp.visible
				+ ", x:"+$disp.x
				+ ", y:"+$disp.y
				+ " bounds:"+$disp.getBounds(Framework.stage).toString()
			);
			
			if ($disp.mask) {
				trace( $indent + "with mask: "+$disp.mask.toString());
			}
			if ($disp is DisplayObjectContainer) {
				var doc:DisplayObjectContainer = DisplayObjectContainer($disp);
				for (var i:int=0; i<doc.numChildren; i++) {
					describeDisplayObject( doc.getChildAt(i), $indent+"\t" );
				}
			}
		}
		public static function DistributeH( $subjects:Array, $reference:DisplayObject,$paddH:Number, $offset:Point=null):void{
			if(!$offset)		$offset = new Point; // Offset left and right
			var num:Number = $subjects.length;
			var dist:Number = ($reference.width-num*$paddH -$offset.x+$offset.y)/num;
			for (var i:int=0;i<num;i++){
				$subjects[i].x = $offset.x + $paddH+ i*(dist+$paddH);
			}
		}
		public static function CheckBorder($reference:DisplayObject):void{
			if($reference.x<0){		
				$reference.x=0;
			}else if($reference.x+$reference.width>Framework.stage.stageWidth){	
				$reference.x=Framework.stage.stageWidth-$reference.width-1;
			}
			if($reference.y<0){		
				$reference.y=0;
			}else if($reference.y+$reference.height>Framework.stage.stageHeight){	
				$reference.y=Framework.stage.stageHeight-$reference.height-1;
			}
		}
	}
}

