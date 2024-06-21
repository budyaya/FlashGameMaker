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

package utils.time{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	* Time Class
	* 
	*/
	public class Time {
		
		public function Time() {
	
		}
		//------ Get Time ------------------------------------
		public static function GetTime():Number {
			 var date:Date = new Date();
		  	 return date.getTime();
		}
		//------ Get Month ------------------------------------
		public static function GetMonth(time:Number):Number {
			var date:Date = getDate(time);
			return date.getMonth();
		}
		//------ Get Day ------------------------------------
		public static function GetDay(time:Number):String {
			var date:Date = getDate(time);
			return date.getDate().toString();
		}
		//------ Get Hour ------------------------------------
		public static function GetHour(time:Number):String {
			var date:Date = getDate(time);
			var hour:String = doubleDigitFormat(date.getHours());
			return hour;
		}
		//------ Get Minute ------------------------------------
		public static function GetMin(time:Number):String {
			var date:Date = getDate(time);
			var min:String = doubleDigitFormat(date.getMinutes());
			return min;
		}
		//------ Get Seconde ------------------------------------
		public static function GetSec(time:Number):String {
			var date:Date = getDate(time);
			var sec:String = doubleDigitFormat(date.getSeconds());
			return sec;
		}
		//------ getDate ------------------------------------
		private static function getDate(time:Number):Date {
			var date:Date = new Date();
			date.setTime(time);
			return date;
		}
		//------ Double Digit Format ------------------------------------
		private static function doubleDigitFormat(value:Number):String {
    		if(value < 10) {
        		return ("0" + value);
   		 }
   		 return value.toString();
		}
	}
}