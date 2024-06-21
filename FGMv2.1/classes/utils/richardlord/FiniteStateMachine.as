/* From Richard Lord 
* http://www.richardlord.net/blog/finite-state-machines-for-ai-in-actionscript
*/
package utils.richardlord{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import utils.time.Time;
	
	public class FiniteStateMachine extends EventDispatcher{
		private var _name:String = null;
		private var _currentState:State=null;
		private var _previousState:State=null;
		private var _nextState:State=null;
		private var _stateList:Dictionary = null;
		public function stateMachine():void{
		}
		//------ FiniteStateMachine  ------------------------------------
		public function FiniteStateMachine($name:String=null):void {
			_name = $name;
		}
		// prepare a state for use after the current state
		private function setNextState( $state:State ):void{
			_nextState = $state;
			if(!$state.finiteStateMachine){
				$state.finiteStateMachine=this;
			}
		}
		// prepare a state for use before the current state
		private function setPreviousState( $state:State ):void{
			_previousState = $state;
			if(!$state.finiteStateMachine){
				$state.finiteStateMachine=this;
			}
		}
		// prepare a state for use after the current state
		public function setNextStateByName( $stateName:String ):void{
			var state:State = getStateByName($stateName);
			setNextState(state);
		}
		// prepare a state for use before the current state
		public function setPreviousStateByName( $stateName:String ):void{
			var state:State = getStateByName($stateName);
			setPreviousState(state);
		}
		// prepare a state list
		public function setStateList( $stateList:Dictionary):void{
			_stateList = $stateList;
		}
		// prepare a state for use after the current state
		public function addState( $stateName:String, $state:IState):void{
			if(_stateList[$stateName]){
				trace("[Warning] the state "+ $stateName+" already exists");
				return
			}
			_stateList[$stateName] = $state;
			if(!$state.finiteStateMachine){
				$state.finiteStateMachine=this;
			}
		}
		// add a simple state
		public function addSimpleState( $stateName:String):void{
			if(_stateList[$stateName]){
				trace("[Warning] the state "+ $stateName+" already exists");
				return
			}
			var state:State = new State();
			_stateList[$stateName] = state;
			if(!state.finiteStateMachine){
				state.finiteStateMachine=this;
			}
		}
		// add severals simples states
		public function addSimpleStates( $stateNames:Array):void{
			for each(var stateName:String in  $stateNames as String){
				addSimpleState(stateName);
			}
		}
		// Get a state by its name
		public function getStateByName( $stateName:String ):State{
			if($stateName)
				return _stateList[$stateName];
			return null;
		}
		// Update the FSM. Parameter is the frametime for this frame.
		public function update():void{
			if( _currentState ){
				trace("test",Time.GetTime());
				_currentState.lastUpdateTime = Time.GetTime();
				_currentState.update();
			}
		}
		
		// Change to another state
		private function changeState( $state:State,$previousState:State=null,$nextState:State=null ):void{
			if(!$state){
				throw new Error ("Finite State Machine: State can not be null !");
			}
			if(_currentState){
				if(_currentState!=$state){
					_currentState.exit($state);
					_currentState.exitStateTime = Time.GetTime();
				}else{
					trace("[WARNING] No exit of state "+$state.name+" since state is currentState !");
				}
			}
			if($previousState){
				_previousState = $previousState;//Force previousState
			}else{
				_previousState = _currentState;
			}
			if($nextState){
				_nextState = $nextState;//Force nextState
			}
			_currentState = $state;
			if(_currentState){
				if(!_currentState.finiteStateMachine){
					_currentState.finiteStateMachine=this;
				}
				_currentState.enter(_previousState);
				_currentState.enterStateTime = Time.GetTime();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		// Change to another state by name
		public function changeStateByName( $stateName:String,$previousState:String=null,$nextState:String=null ):State{
			var state:State = getStateByName($stateName);
			var previous:State = getStateByName($previousState);
			var nextState:State = getStateByName($nextState);
			changeState(state,previous,nextState);
			return state;
		}
		// Change back to the previous state
		public function goToPreviousState():void{
			if(!_previousState.finiteStateMachine){
				_previousState.finiteStateMachine=this;
			}
			changeState( _previousState );
		}
		
		// Go to the next state
		public function goToNextState():void{
			if(!_nextState.finiteStateMachine){
				_nextState.finiteStateMachine=this;
			}
			changeState( _nextState );
		}
		// Get Current State
		public function get currentState():State{
			return _currentState;
		}
		// Get Previous State
		public function get previousState():State{
			return _previousState;
		}
		// Get Next State
		public function get nextState():State{
			return _nextState;
		}
		// Get Name
		public function get name():String{
			return _name;
		}
		// Set Name
		public function set name($name:String):void{
			_name=$name;
		}
		// destroy
		public function destroy():void{
			_currentState = null;
			_previousState = null;
			_nextState = null;
			_stateList = null;
		}
	}
}