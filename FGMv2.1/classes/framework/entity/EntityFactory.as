/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://Frameworkas3.blogspot.com/
*   Group:        http://groups.google.com.au/group/Framework
*   Google Code:  http://code.google.com/p/Framework/downloads/list
*   Source Forge: https://sourceforge.net/projects/Framework/files/
*/
/*
*    Inspired from Ember  
*    Tom Davies 2010
*    http://github.com/tdavies/Ember/wiki
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

package framework.entity{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.Framework;
	import framework.component.add.*;
	import framework.component.core.*;
	import framework.entity.IEntity;
	import framework.system.GraphicManager;
	import framework.system.IGraphicManager;
	
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	import utils.transform.BasicTransform;
	import utils.ui.LayoutUtil;
	
	/**
	 * Entity Factory 2D
	 */
	public class EntityFactory {
		
		private static var entityManager:IEntityManager=EntityManager.getInstance(); 
		
		//------- Init Main Component -------------------------------
		public static function InitMainComponent($entityName:String):void{
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent") as TimerComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var renderComponent:RenderComponent = entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
		}
		//------- Create System Info -------------------------------
		public static function CreateSystemInfo($entityName:String, $x:Number, $y:Number):SystemInfoComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent = entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var systemInfoComponent:SystemInfoComponent=entityManager.addComponentFromName($entityName,"SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
			systemInfoComponent.moveTo($x, $y);
			return systemInfoComponent;
		}
		//------- Create GamePad -------------------------------
		public static function CreateGamePad($entityName:String, $x:Number, $y:Number, $keyPad:KeyPad = null):GamePadComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var gamePadComponent:GamePadComponent=entityManager.addComponentFromName($entityName,"GamePadComponent","myGamePadComponent",{keyPad:$keyPad}) as GamePadComponent;
			gamePadComponent.moveTo($x, $y);
			Framework.Focus();
			return gamePadComponent;
		}
		//------- Create Graphic -------------------------------
		public static function CreateGraphic($entityName:String, $path:String,  $x:Number, $y:Number):GraphicComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var graphicComponent:GraphicComponent=entityManager.addComponentFromName($entityName,"GraphicComponent","myGraphicComponent") as GraphicComponent;
			graphicComponent.loadGraphic($path);
			graphicComponent.moveTo($x,$y);
			return graphicComponent;
		}
		//------- Create Cursor -------------------------------
		public static function CreateCursor($entityName:String, $path:String):CursorComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var cursorComponent:CursorComponent=entityManager.addComponentFromName($entityName,"CursorComponent","myCursorComponent") as CursorComponent;
			cursorComponent.loadGraphic($path);
			return cursorComponent;
		}
		//------- Create Time -------------------------------
		public static function CreateTime($entityName:String,$timerDelay:uint, $timeDelay:uint, $x:Number, $y:Number):TimeComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:$timerDelay}) as TimerComponent;
			var timeComponent:TimeComponent=entityManager.addComponentFromName($entityName,"TimeComponent","myTimeComponent", {delay:$timeDelay}) as TimeComponent;
			timeComponent.moveTo($x,$y);
			return timeComponent;
		}
		//------- Create Chrono -------------------------------
		public static function CreateChrono($entityName:String, $path:String, $timerDelay:uint, $chronoDelay:uint, $x:Number, $y:Number):ChronoComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent",{layer:1}) as BitmapRenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:$timerDelay}) as TimerComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var chronoComponent:ChronoComponent=entityManager.addComponentFromName($entityName,"ChronoComponent","myChronoComponent",{delay:$chronoDelay}) as ChronoComponent;
			chronoComponent.loadGraphic($path);
			chronoComponent.moveTo($x,$y);
			return chronoComponent;
		}
		//------- Create RPG Text -------------------------------
		public static function CreateRPGText($entityName:String, $path:String, $timerDelay:uint):RPGTextComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:$timerDelay}) as TimerComponent;
			var rpgTextComponent:RPGTextComponent=entityManager.addComponentFromName($entityName,"RPGTextComponent","myRPGTextComponent") as RPGTextComponent;
			rpgTextComponent.loadGraphic($path,SetRPGText);
			return rpgTextComponent;
		}
		//------- Set RPG Text -------------------------------
		public static function SetRPGText($rpgText:RPGTextComponent):void{
			var sequences:Array = [{title:"Title1", content:"Content1", icon:null, delay:5000},{title:"Title2", content:"Content2", icon:null, delay:5000}];
			$rpgText.setSequences(sequences);
			$rpgText.moveTo(300,0);
		}
		//------- Create Bitmap Player -------------------------------
		public static function CreateBitmapPlayer($entityName:String, $path:String,  $x:Number, $y:Number,  $speed:Point = null, $iso:Boolean=false, $horizontal:Boolean=true, $vertical:Boolean=true, $diagonal:Boolean=false):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var keyboardMoveComponent:KeyboardMoveComponent=entityManager.addComponentFromName($entityName,"KeyboardMoveComponent","myKeyboardMoveComponent") as KeyboardMoveComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var mouseMoveComponent:MouseMoveComponent=entityManager.addComponentFromName($entityName,"MouseMoveComponent","myMouseMoveComponent") as MouseMoveComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var playerComponent:PlayerComponent=entityManager.addComponentFromName($entityName,"PlayerComponent","myPlayerComponent") as PlayerComponent;
			playerComponent.loadGraphic($path);
			playerComponent.moveTo($x,$y);
		}
		//------- Create Swf Player -------------------------------
		public static function CreateSwfPlayer($entityName:String, $path:String,  $x:Number, $y:Number,  $speed:Point = null, $iso:Boolean=false, $horizontal:Boolean=true, $vertical:Boolean=true, $diagonal:Boolean=false):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var keyboardMoveComponent:KeyboardMoveComponent=entityManager.addComponentFromName($entityName,"KeyboardMoveComponent","myKeyboardMoveComponent") as KeyboardMoveComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			/*var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var playerComponent:PlayerComponent=entityManager.addComponentFromName($entityName,"PlayerComponent","myPlayerComponent", {sequence:false, bounds:new Rectangle(0,0,80,100)}) as PlayerComponent;
			playerComponent.loadGraphic($path);
			playerComponent.moveTo($x,$y);*/
		}
		//------- Create Fox -------------------------------
		public static function CreateFoxMiniGame($entityName:String, $path:String,  $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var spatialMoveComponent:SpatialMoveComponent=entityManager.addComponentFromName($entityName,"SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent",{layer:1}) as BitmapRenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:10}) as TimerComponent;
			var keyboardJaugeMoveComponent:KeyboardJaugeMoveComponent=entityManager.addComponentFromName($entityName,"KeyboardJaugeMoveComponent","myKeyboardJaugeMoveComponent") as KeyboardJaugeMoveComponent;
			keyboardJaugeMoveComponent.moveTo(10,30);	
			var fox:MovingAnimationComponent=entityManager.addComponentFromName($entityName,"MovingAnimationComponent","myFox") as MovingAnimationComponent;
			fox.loadGraphic($path,SetFoxPlayerAnim);
			fox.registerPropertyReference("keyboardJaugeMove");
			fox.moveTo($x,$y);		
			bitmapRenderComponent.setTarget(fox);
			Framework.Focus();
		}
		//------- Create Fox -------------------------------
		public static function CreateFoxMiniGame2($entityName:String, $path:String,  $x:Number, $y:Number):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var keyBoardInput:KeyboardInputComponent=entityManager.addComponentFromName($entityName,"KeyboardInputComponent","myKeyboardInputComponent") as KeyboardInputComponent;
			var spatialMoveComponent:SpatialMoveComponent=entityManager.addComponentFromName($entityName,"SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent",{layer:1}) as BitmapRenderComponent;
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var timerComponent:TimerComponent=entityManager.addComponentFromName($entityName,"TimerComponent","myTimerComponent", {delay:10}) as TimerComponent;
			var jaugeMoveComponent:JaugeMoveComponent=entityManager.addComponentFromName($entityName,"JaugeMoveComponent","myJaugeMoveComponent") as JaugeMoveComponent;
			jaugeMoveComponent.moveTo(10,30);
			var fox:MovingAnimationComponent=entityManager.addComponentFromName($entityName,"MovingAnimationComponent","myFox") as MovingAnimationComponent;
			fox.loadGraphic($path,SetFoxPlayerAnim);
			fox.registerPropertyReference("jaugeMove");
			fox.moveTo($x,$y);		
			bitmapRenderComponent.setTarget(fox);
		}
		//------- Create Animation -------------------------------
		public static function CreateAnimation($entityName:String, $path:String,  $x:Number, $y:Number):GraphicComponent{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var animation:GraphicComponent=entityManager.addComponentFromName($entityName,"GraphicComponent","myAnimation") as GraphicComponent;
			animation.loadGraphic($path);
			animation.moveTo($x,$y);
			animation.registerPropertyReference("mouseInput",{onMouseDown:OnAnimationMouseDown});
			return animation;
		}
		//------- onAnimationMouseDown -------------------------------
		public static function OnAnimationMouseDown($mousePad:MousePad):void{
			trace("CLICK")
		}
		//------- Create Animations -------------------------------
		public static function CreateAnimations($entityName:String):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			var zoomComponent:ZoomComponent=entityManager.addComponentFromName($entityName,"ZoomComponent","myZoomComponent") as ZoomComponent;
			bitmapRenderComponent.registerPropertyReference("zoom");
			var bitmapAnimComponent:BitmapAnimComponent=entityManager.addComponentFromName($entityName,"BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var spatialMoveComponent:SpatialMoveComponent=entityManager.addComponentFromName($entityName,"SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var panda:AnimationComponent=entityManager.addComponentFromName($entityName,"AnimationComponent","myPanda") as AnimationComponent;
			panda.loadGraphic("../assets/Panda.swf");
			//panda.registerPropertyReference("mouseInput",{onMouseRollOver:panda.onMouseRollOver, onMouseRollOut:panda.onMouseRollOut/*, onMouseDown:panda.onMouseDown, onMouseUp:panda.onMouseUp*/});
			panda.moveTo(Math.random()*Framework.width,Math.random()*Framework.height,1);
			var clone:AnimationComponent;
			for (var i:Number=0; i<500; i++){
				clone=panda.clone() as AnimationComponent;
				clone.moveTo(Math.random()*3000,Math.random()*3000+100,1);
				//clone.registerPropertyReference("mouseInput",{onMouseRollOver:clone.onMouseRollOver, onMouseRollOut:clone.onMouseRollOut/*, onMouseDown:clone.onMouseDown, onMouseUp:clone.onMouseUp*/});
			}
			var fox:MovingAnimationComponent=entityManager.addComponentFromName($entityName,"MovingAnimationComponent","myFox") as MovingAnimationComponent;
			fox.loadGraphic("../assets/Fox.swf",OnFoxAnimComplete);
			//fox.registerPropertyReference("mouseInput",{onMouseRollOver:fox.onMouseRollOver, onMouseRollOut:fox.onMouseRollOut/*, onMouseDown:fox.onMouseDown, onMouseUp:fox.onMouseUp*/});
			
			fox.moveTo(Math.random()*Framework.width,Math.random()*Framework.height,1);
		}
		//------- Create Background Color -------------------------------
		public static function CreateBgColor($entityName:String, $color:uint, $alpha:Number=1):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var simpleGraphicComponent:SimpleGraphicComponent=entityManager.addComponentFromName($entityName,"SimpleGraphicComponent","mySimpleGraphicComponent", {color:$color, alpha:$alpha}) as SimpleGraphicComponent;
		}
		//------- Create Background Color -------------------------------
		public static function CreateBgGradientColor($entityName:String, $type:String, $colors:Array, $alphas:Array, $ratios:Array, $rectangle:Rectangle=null,$matrix:Matrix=null):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			if(!$matrix){
				$matrix = new Matrix();
				$matrix.createGradientBox(50, 50, Math.PI/2, 0, 0);
			}
			var simpleGraphicComponent:SimpleGraphicComponent=entityManager.addComponentFromName($entityName,"SimpleGraphicComponent","mySimpleGraphicComponent", {type:$type, colors:$colors, alphas:$alphas, ratios:$ratios, rectangle:$rectangle, matrix:$matrix}) as SimpleGraphicComponent;
		}
		//------- Create Scrolling Bitmap -------------------------------
		public static function CreateScrollingBitmap($entityName:String, $path:String,  $x:Number, $y:Number, $frameRate:Number, $speed:Point=null, $autoScroll:Boolean=true, $loop:Boolean=true):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var renderComponent:RenderComponent=entityManager.addComponentFromName($entityName,"RenderComponent","myRenderComponent") as RenderComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent",{frameRate:$frameRate}) as EnterFrameComponent;
			var scrollingBitmapComponent:ScrollingBitmapComponent=entityManager.addComponentFromName($entityName,"ScrollingBitmapComponent","myScrollingBitmapComponent", {speed:$speed, autoScroll:$autoScroll, loop:$loop}) as ScrollingBitmapComponent;
			scrollingBitmapComponent.loadGraphic($path);
			scrollingBitmapComponent.moveTo($x,$y);
		}
		//-------onFoxAnimComplete -------------------------------
		public static function OnFoxAnimComplete($fox:AnimationComponent):void{
			SetFoxAnim($fox);
			var clone:MovingAnimationComponent;
			for (var i:Number=0; i<500; i++){
				clone=$fox.clone() as MovingAnimationComponent;
				clone.moveTo(Math.random()*3000,Math.random()*3000+100,1);
				//clone.registerPropertyReference("mouseInput",{onMouseRollOver:clone.onMouseRollOver, onMouseRollOut:clone.onMouseRollOut/*, onMouseDown:$animComponent.onMouseDown, onMouseUp:$animComponent.onMouseUp*/});
				SetFoxAnim(clone);
			}
		}
		//------- Set Fox Anim -------------------------------
		public static function SetFoxAnim($fox:AnimationComponent):void{
			var foxPoses:Array = [
				{name:"POSE_IDLE", 		animations:[{name:"IDLE", f:2} , {name:"LOOK_UP", f:2}, {name:"IDLE_TAILWHIP", f:3}, {name:"GRAZE", f:2}, {name:"IDLE_TO_WALK", f:3}, {name:"IDLE_TO_RUN", f:3}]},
				{name:"POSE_WALK", 		animations:[{name:"WALK_CYCLE", f:1}]},
				{name:"POSE_WALK_IDLE", animations:[{name:"WALK_CYCLE", f:1},{name:"WALK_TO_IDLE", f:2}]},
				{name:"POSE_RUN", 		animations:[{name:"RUN_CYCLE", f:1}]},
				{name:"POSE_RUN_IDLE", 	animations:[{name:"RUN_CYCLE", f:1},{name:"RUN_TO_IDLE", f:2}]},
				{name:"POSE_FALL", 		animations:[{name:"FALL", f:1}]}
			];
			var graph:BitmapGraph = $fox.bitmapSet.graph;
			graph.createSequence(foxPoses);
			graph.animations["IDLE"].nextPose = "POSE_IDLE";
			graph.animations["LOOK_UP"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TAILWHIP"].nextPose = "POSE_IDLE";
			graph.animations["JUMP"].nextPose = "POSE_IDLE";
			graph.animations["GRAZE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_WALK"].nextPose = "POSE_WALK";
			graph.animations["WALK_CYCLE"].nextPose = "POSE_WALK_IDLE";
			graph.animations["WALK_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_RUN"].nextPose = "POSE_RUN";
			graph.animations["RUN_CYCLE"].nextPose = "POSE_RUN_IDLE";
			graph.animations["RUN_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["JUMP"].nextPose = "POSE_FALL";
			graph.animations["FALL"].nextPose = "POSE_IDLE";
		}
		//------- Set Fox Anim -------------------------------
		public static function SetFoxPlayerAnim($fox:AnimationComponent):void{
			var foxPoses:Array = [
				{name:"POSE_IDLE", 		animations:[{name:"IDLE", f:2} , {name:"LOOK_UP", f:2}, {name:"IDLE_TAILWHIP", f:3}, {name:"GRAZE", f:2}]},
				{name:"POSE_WALK", 		animations:[{name:"WALK_CYCLE", f:1}]},
				{name:"POSE_WALK_IDLE", animations:[{name:"WALK_CYCLE", f:1},{name:"WALK_TO_IDLE", f:1}]},
				{name:"POSE_RUN", 		animations:[{name:"RUN_CYCLE", f:1}]},
				{name:"POSE_RUN_IDLE", 	animations:[{name:"RUN_TO_IDLE", f:1}]},
				{name:"POSE_FALL", 		animations:[{name:"FALL", f:1}]}
			];
			var graph:BitmapGraph = $fox.bitmapSet.graph;
			graph.createSequence(foxPoses);
			graph.animations["IDLE"].nextPose = "POSE_IDLE";
			graph.animations["LOOK_UP"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TAILWHIP"].nextPose = "POSE_IDLE";
			graph.animations["JUMP"].nextPose = "POSE_IDLE";
			graph.animations["GRAZE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_WALK"].nextPose = "POSE_WALK";
			graph.animations["WALK_CYCLE"].nextPose = "POSE_WALK";
			graph.animations["WALK_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["IDLE_TO_RUN"].nextPose = "POSE_RUN";
			graph.animations["RUN_CYCLE"].nextPose = "POSE_RUN";
			graph.animations["RUN_TO_IDLE"].nextPose = "POSE_IDLE";
			graph.animations["RUN_JUMP"].nextPose = "POSE_RUN";
			graph.animations["JUMP"].nextPose = "POSE_FALL";
			graph.animations["FALL"].nextPose = "POSE_IDLE";
		}
		//------ CreateTileMap -------------------------------
		public static function CreateTileMap($entityName:String):void{
			var entity:IEntity=entityManager.createEntity($entityName);
			var graphicManager:IGraphicManager = GraphicManager.getInstance();
			var callBack:Object = {onComplete:OnTileSetLoaded, onCompleteParams:$entityName};
			graphicManager.loadGraphic("../assets/kawaiiTileSet.png", callBack);
		}
		//------ On Tile Set Loaded -------------------------------
		public static function OnTileSetLoaded($graphic:DisplayObject, $entityName:String =null):void{
			var mouseInput:MouseInputComponent=entityManager.addComponentFromName($entityName,"MouseInputComponent","myMouseInputComponent") as MouseInputComponent;
			var enterFrameComponent:EnterFrameComponent=entityManager.addComponentFromName($entityName,"EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var bitmapRenderComponent:BitmapRenderComponent=entityManager.addComponentFromName($entityName,"BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			BasicTransform.SetRectMask(bitmapRenderComponent,10,20,Framework.width-20,Framework.height-40);
			var tileMapComponent:TileMapComponent=entityManager.addComponentFromName($entityName,"TileMapComponent","myTileMapComponent") as TileMapComponent;
			tileMapComponent.initMap(1,1000,500, 2);
			var tileSet:Bitmap = $graphic as Bitmap;
			var bitmapData:BitmapData = BitmapTo.BitmapToBitmapData(tileSet);
			tileMapComponent.addTileLayer("1,498*10,1,499000*1,1,498*10,1",bitmapData,60,40,10,null,new IsoPoint(12,28,1));
			var position:Point = LayoutUtil.GetAlignPosition(tileMapComponent,LayoutUtil.ALIGN_CENTER_CENTER,null,null,new Point(tileMapComponent.x,tileMapComponent.y+20));
			if(tileMapComponent.height>Framework.height){	
				position.y+=(tileMapComponent.height-Framework.height)/2;
			}
			bitmapRenderComponent.setScrollArea(new Rectangle(0,0,tileMapComponent.x+tileMapComponent.maxWidth,tileMapComponent.y+tileMapComponent.maxHeight));
			//var tileMapEditorComponent:TileMapEditorComponent=entityManager.addComponentFromName($entityName,"TileMapEditorComponent","myTileMapEditorComponent", {tileMapComponent:tileMapComponent}) as TileMapEditorComponent;
		}
		//------- ToString -------------------------------
		public function ToString():void{
			trace();
		}
	}
}