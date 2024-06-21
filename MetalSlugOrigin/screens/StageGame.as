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
package screens{
	import com.adobe.serialization.json.JSON;
	import com.google.analytics.debug.Align;
	
	import customClasses.*;
	
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import framework.Framework;
	import framework.component.add.*;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.*;
	
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyCode;
	import utils.keyboard.KeyPad;
	import utils.loader.SimpleLoader;
	import utils.mouse.MousePad;
	import utils.popforge.WavURLPlayer;
	import utils.richardlord.*;
	import utils.ui.LayoutUtil;

	/**
	 * Game
	 */
	public class StageGame extends State implements IState{
		
		private var _entityManager:IEntityManager	=null;
		private var _graphicManager:IGraphicManager =null;
		private var _soundManager:ISoundManager		=null;
		private var _soundComponent:SoundComponent	=null;
		private var _volume:Number					= 0.01;
		private var _player:MS_ObjectComponent		=null;
		private var _bg:ScrollingBitmapComponent 	=null;
		private var _statutBar:GraphicComponent 	=null;
		private var _gamePad:GamePadComponent		=null;
		public function StageGame(){
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			initVar();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager=EntityManager.getInstance();
			_graphicManager = GraphicManager.getInstance();
			_soundManager = SoundManager.getInstance();
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("MSOrigin","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			var timerComponent:TimerComponent=_entityManager.addComponentFromName("MSOrigin","TimerComponent","myTimerComponent") as TimerComponent;
			var spatialMoveComponent:SpatialMoveComponent=_entityManager.addComponentFromName("MSOrigin","SpatialMoveComponent","mySpatialMoveComponent") as SpatialMoveComponent;
			var bitmapAnimComponent:BitmapAnimComponent=_entityManager.addComponentFromName("MSOrigin","BitmapAnimComponent","myBitmapAnimComponent") as BitmapAnimComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("MSOrigin","BitmapRenderComponent","myBitmapRenderComponent") as BitmapRenderComponent;
			bitmapRenderComponent.scrollEnabled = false;
		
			_bg =_entityManager.addComponentFromName("MSOrigin","ScrollingBitmapComponent","myBackgroundComponent",{render:"bitmapRender"}) as ScrollingBitmapComponent;
			//_bg.registerPropertyReference("timer");
			_bg.graphic = _graphicManager.getGraphic(Data.BACKGROUND.bg.path);
			//_bg.pushFunction({executeOnlyIfDisplayed:false,callback:_bg.scrollView});
			LayoutUtil.Align(_bg,LayoutUtil.ALIGN_BOTTOM_LEFT);
			
			var keyPad:KeyPad = new KeyPad(true);
			keyPad.useZQSD();
			keyPad.useArrows();
			keyPad.mapFireButtons(KeyCode.I,KeyCode.O,KeyCode.P,221);
			_player = MS_Object.CreateObject(1,null,keyPad);
			_player.registerPropertyReference("keyboardInput");
			_player.moveTo(10,160);
			_player.layer=1;
			
			//_bg.setTarget(_player);
			
			_gamePad = EntityFactory.CreateGamePad("GamePad", 20,30,keyPad);
			_gamePad.hideDirectionKeys();
			_gamePad.button4.visible=false;
			_gamePad.button2.x+=5;
			_gamePad.button3.x+=5;
			_gamePad.hideBg();
			_gamePad.moveFireKeys(120,10);
			LayoutUtil.Align(_gamePad,LayoutUtil.ALIGN_BOTTOM_LEFT,null,null,new Point(10,-20));
			
			_statutBar=_entityManager.addComponentFromName("MSOrigin","GraphicComponent","myStatutBarGraphicComponent") as GraphicComponent;
			_statutBar.graphic = _graphicManager.getGraphic(Data.OTHER.statutBar.path);
			LayoutUtil.Align(_statutBar,LayoutUtil.ALIGN_BOTTOM_LEFT);
			_bg.y-=_statutBar.height-12;
			
			var scoreComponent:ScoreComponent=_entityManager.addComponentFromName("MSOrigin","ScoreComponent","myScoreComponent") as ScoreComponent;
			scoreComponent.graphic = _graphicManager.getGraphic(Data.OTHER.score.path);
			LayoutUtil.Align(scoreComponent,LayoutUtil.ALIGN_TOP_LEFT,null,null,new Point(5,5));
			
			var rpgTextComponent:RPGTextComponent=_entityManager.addComponentFromName("MSOrigin","RPGTextComponent","myRPGTextComponent",{onRPGTextComplete:onRPGTextComplete}) as RPGTextComponent;
			rpgTextComponent.graphic = _graphicManager.getGraphic(Data.OTHER.rpgText.path);
			var sequence:Array=[{title:"???", content:"You have 24H to accomplish your mission", icon:null, delay:5000},{title:"Squad", content:"...Roger that", icon:null, delay:5000},{title:"Squad", content:"1, 2, 3, ..., Go! Go!!!", icon:null, delay:5000}]
			rpgTextComponent.setSequences(sequence);
			rpgTextComponent.moveTo(80,35);
			
			_soundComponent=_entityManager.addComponentFromName("MSOrigin","SoundComponent","mySoundComponent") as SoundComponent;
			_soundComponent.graphic = _graphicManager.getGraphic(Data.OTHER.soundControl.path);
			_soundComponent.scaleX /=1.5;
			_soundComponent.scaleY /=1.5;
			_soundComponent.sound = _soundManager.getSound(Framework.root+Data.BACKGROUND.mainMusic.path);
			_soundComponent.nextFrame();
			_soundComponent.registerPropertyReference("mouseInput",{onMouseDown:onSoundClick});
			LayoutUtil.Align(_soundComponent,LayoutUtil.ALIGN_TOP_RIGHT,null,null,new Point(-5,5));
			
		}
		//------ On Chrono Complete ------------------------------------
		private function onSoundClick($mousePad:MousePad):void {
			if(_soundComponent.isPlaying){
				_soundComponent.stop();
				_soundComponent.graphic.nextFrame();
			}else{
				_soundComponent.resume(_volume);
				_soundComponent.graphic.prevFrame();
			}
		}
		//------ On Chrono Complete ------------------------------------
		private function onRPGTextComplete($rpgTextComponent:RPGTextComponent):void {
			_soundComponent.prevFrame();
			_soundComponent.play(_volume);
			var endChronoComponent:ChronoComponent=_entityManager.addComponentFromName("MSOrigin","ChronoComponent","myChronoComponent",{onChronoComplete:onChronoComplete}) as ChronoComponent;
			endChronoComponent.graphic = _graphicManager.getGraphic(Data.OTHER.chrono.path);
			endChronoComponent.start(60, true);
			LayoutUtil.Align(endChronoComponent,LayoutUtil.ALIGN_TOP_CENTER,null,null,new Point(45,5));
		}
		//------ On Chrono Complete ------------------------------------
		private function onChronoComplete($chronoComponent:ChronoComponent):void {
			var bg:SimpleGraphicComponent = _entityManager.addComponentFromName("MSOrigin","SimpleGraphicComponent","myGameOverBgSimpleGraphicComponent",{color:0x111111,rectangle:new Rectangle(0,0,Framework.width,Framework.height)}) as SimpleGraphicComponent;
			var gameOver:GraphicComponent=_entityManager.addComponentFromName("MSOrigin","GraphicComponent","myGameOverGraphicComponent") as GraphicComponent;
			gameOver.graphic = _graphicManager.getGraphic(Data.OTHER.gameOverScreen.path);
			LayoutUtil.Align(gameOver, LayoutUtil.ALIGN_CENTER_CENTER);
			_gamePad.visible = false;
			
		}
		//------ On Game Over Complete ------------------------------------
		private function onGameOverComplete(evt:Event):void {
		
		}
	}
}