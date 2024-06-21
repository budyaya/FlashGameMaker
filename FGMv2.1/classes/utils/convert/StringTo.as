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
	public class StringTo {

		//------ String To Bool ------------------------------------
		public static function Bool(data:String):Boolean {
			if (data=="true") {
				return true;
			} else if (data=="false") {
				return false;
			}
			return false;
		}
		//------ Sting To Tab Xml ------------------------------------
		public static function Tab(string:String,mapHigh:Number,mapHeight:Number,mapWidth:Number ):Array {
			var stringToTab:Array = string.split(",");
			var tab:Array=new Array(mapHigh);
			tab[0]=new Array(mapHeight);
			tab[0][0]=new Array(mapWidth);
			var tmp:Number=0;
			var i:Number=0;
			var j:Number=0;
			var k:Number=0;
			while (tmp<stringToTab.length) {
				var list:Array=stringToTab[tmp].split("*");
				if (list.length==1) {
					tab[k][j][i]=list[0];
					i++;
					if (i>=mapWidth) {
						i=0;
						j++;
						tab[k][j]=new Array(mapWidth);
						if (j>=mapHeight) {
							j=0;
							k++;
							tab[k]=new Array(mapHeight);
							tab[k][0]=new Array(mapWidth);
						}
					}
				} else {
					//This function does not work properly creation of bigger tab than needed !!!!
					for (var l:Number=0; l<Number(list[0]); l++) {
						tab[k][j][i]=list[1];
						i++;
						if (i>=mapWidth) {
							i=0;
							j++;
							tab[k][j]=new Array(mapWidth);
							if (j>=mapHeight) {
								j=0;
								k++;
								tab[k]=new Array(mapHeight);
								tab[k][0]=new Array(mapWidth);
							}
						}
					}
				}
				tmp++;
			}
			return tab;
		}
	}
}