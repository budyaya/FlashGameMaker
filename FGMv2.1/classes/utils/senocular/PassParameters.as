/* From Senocular 
*/
package utils.senocular{
	import flash.events.Event; 
	
	public class PassParameters{
		//DEPRECATED: Apply is very slow !!! see here :http://jacksondunstan.com/articles/1675
		public static function AddArguments (method:Function, additionalArguments:Array):Function{
			return function($event:Event=null):void{
				if($event){	
					method.apply(null, [$event].concat(additionalArguments));
				}else{ 
					method.apply(null, additionalArguments);
				}
			}
		}
		//That is why I prefer to do it myself !!! But it is not really faster...
		public static function ApplyArguments (method:Function, additionalArguments:Array):Function{
			var length:int = additionalArguments.length;
			if(length>=5)
				throw new Error("PassParameters: ApplyArguments only support 5 max parameters!!!");
			return function($event:Event=null):void{
				if($event){	
					if(length==0){	method([$event]);return;}
					if(length==1){	method([$event],additionalArguments[0]);return;}
					if(length==2){ 	method([$event],additionalArguments[0],additionalArguments[1]);return;}
					if(length==3){	method([$event],additionalArguments[0],additionalArguments[1],additionalArguments[2]);return;}
					if(length==4){	method([$event],additionalArguments[0],additionalArguments[1],additionalArguments[2],additionalArguments[3]);return;}
					if(length==5){	method([$event],additionalArguments[0],additionalArguments[1],additionalArguments[2],additionalArguments[3],additionalArguments[4]);return;}
				}else{ 
					if(length==0){	method();return;}
					else if(length==1){	method(additionalArguments[0]);return;}
					else if(length==2){ method(additionalArguments[0],additionalArguments[1]);return;}
					else if(length==3){	method(additionalArguments[0],additionalArguments[1],additionalArguments[2]);return;}
					else if(length==4){	method(additionalArguments[0],additionalArguments[1],additionalArguments[2],additionalArguments[3]);return;}
					else if(length==5){	method(additionalArguments[0],additionalArguments[1],additionalArguments[2],additionalArguments[3],additionalArguments[4]);return;}
				}
			}
		}
		//Example
		/*var aNum:int = 5;
		mc.addEventListener(MouseEvent.CLICK, PassParameters.AddArguments(onMouseEvent, [aNum]),false,0,true);
		private function onMouseEvent(e:Event,a:int):void{
			trace(a);
		} */
	}
}