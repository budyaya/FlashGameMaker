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
	* BoolTo Class
	* 
	*/
	public class BoolTo {

		//------ Bool To Number ------------------------------------
		public static function Num($bool:Boolean, $negative:Boolean=false):Number {
			if ($bool) {
				return 1;
			}else if($negative)
				return -1;
			return 0;
		}
	}
}