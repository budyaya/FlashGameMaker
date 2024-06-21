/* From Richard Lord 
* http://www.richardlord.net/blog/finite-state-machines-for-ai-in-actionscript
*/
package utils.richardlord{
	import utils.time.Time;
	
	public class State implements IState{
		protected var _name:String = null;
		protected var _finiteStateMachine:FiniteStateMachine = null;
		public var enterStateTime:Number= 0;
		public var lastUpdateTime:Number= 0;
		public var exitStateTime:Number= 0;
		
		public function State():void{
			_initVar()
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			
		}
		//------ Set FSM ------------------------------------
		public function set finiteStateMachine($finiteStateMachine:FiniteStateMachine):void{
			_finiteStateMachine=$finiteStateMachine;
		}
		//------ Get FSM ------------------------------------
		public function get finiteStateMachine():FiniteStateMachine{
			return _finiteStateMachine;
		}
		//------ Enter ------------------------------------
		public function enter($previousState:State):void {
			//trace("Enter State");
		}
		//------ Enter ------------------------------------
		public function update():void {
			//trace("Update State");
		}
		//------ Exit ------------------------------------
		public function exit($nextState:State):void {
			//trace("Exit state");
		}
		//------ Get Name ------------------------------------
		public function get name():String {
			return _name;
		}
	}
}