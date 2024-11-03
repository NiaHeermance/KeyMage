
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; StateMachine

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

; -----------------
; The Machine
; ---------

class StateMachine {
    /**
     * 
     * @param {Map<String, State>} states A map from a state's name to the state itself.  
     * @param {String} startingState The state we start in.
     */
    __New(states, startingState) {
        this.states := states
        this.state := states[startingState]

        for name, aState in states {
            aState.SetMachine(this)
        }
    }

    TransitionTo(nextState, args := -1) {
        this.state.Exit()
        this.state := this.states[nextState]
        this.state.Enter(args)
    }

}

/**
 * An abstract class for a State meant to be extended.
 */
class State {

    /**
     * Gives us a machine we can use for acivating transitions.
     * @param {StateMachine} machine  The machine we are a part of.
     */
    SetMachine(machine) {
        this.machine := machine
    }

    /**
     * Activaqted upon becoming active state.
     * @param {Map} args Arguments sent by the previous state for us to use.
     */
    Enter(args) {
        
    }

    Exit() {
        
    }

}