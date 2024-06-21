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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A full copy of the license is available at http://www.gnu.org/licenses/fdl-1.3-standalone.html.
*	GNU General Public License v3
*
*/

package {
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import framework.Framework;
	
	/**
	 * Main Class of the document.
	 * FrameRate =30 -> 30fps === 33ms (processing a routine should not exceed 33ms to preserve fps)
	 */
	[SWF(width=480, height=320, backgroundColor=0x111111, frameRate=30, scriptTimeLimit=15)]
	public class MSOrigin extends Sprite {
		
		public function MSOrigin() {
			if (stage){
				_init();
			} 
			else { 
				addEventListener(Event.ADDED_TO_STAGE,_init, false, 0, true);
			}
		}
		// Flash Develop Compatibility
		private function _init($e:Event = null):void {
			trace("Init...");
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			addEventListener(Event.ENTER_FRAME,_onLoading,false,0,true);
		}
		private function _onLoading($e:Event = null):void {
			var loaded:Number = stage.loaderInfo.bytesLoaded;
			var total:Number = stage.loaderInfo.bytesTotal;
			trace("Loading... "+ Math.floor((loaded/total)*100)+ "%");
			if (loaded == total) {
				removeEventListener(Event.ENTER_FRAME, _onLoading);
				_onLoadingComplete();
			}
		}
		private function _onLoadingComplete():void {
			_initFramework();
			//_initProfiler();
			_initGame();
		}
		//------ Init Framework ------------------------------------
		private function _initFramework():void {
			var framework:Framework = new Framework(this);
		}
		//------ Init Profiler: The Miner ------------------------------------
		private function _initProfiler():void {
			this.addChild(new TheMiner());  
		}
		//------ Init Game ------------------------------------
		private function _initGame():void {
			var myGame:MyGame = new MyGame();
		}
	}
}