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

package utils.convert{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* StringTo Class
	* 
	*/
	public class TabTo {
		
		public function TabTo() {
	
		}
		//------ Tab To String Xml ------------------------------------
		public static function tabToStringXml(_tab:Array):String {
			/*var string:String = "";
			var frame:Number=-999;
			var cpt:Number=1;
			for (var k=0; k<game.map.mapHigh; k++) {
				for (var j=0; j<game.map.mapHeight; ++j) {
					for (var i=0; i<game.map.mapWidth; ++i) {
						if(frame!=-999){
							if(frame == _tab[k][j][i]){
								cpt++;
							}else{
								if(cpt>1){
									string+=cpt+"*"+frame;
									cpt=1;
								}else{
									string+=frame;
								}
								if(k!=game.map.mapHigh && j!=game.map.mapHeight && i!=game.map.mapWidth){
									string+=",";
								}
							}
						}
						frame=_tab[k][j][i];
					}							
				}
			}
			if(cpt>1){
				string+=cpt+"*"+frame;
			}
			return string;*/
			return null;
		}
	}
}