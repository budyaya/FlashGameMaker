package utils.richardlord{
	public interface IState{
		function enter($previousState:State):void; 	// called on entering the state
		function exit($nextState:State):void; 	// called on leaving the state
		function update():void;	// called while in the state
		function get finiteStateMachine():FiniteStateMachine;
		function set finiteStateMachine($finiteStateMachine:FiniteStateMachine):void;
	}
}