
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
        this.activeState := states[startingState]
        this.states := states

        for name, state in states {
            state.SetMachine(this)
        }
    }

    TransitionTo(nextState, args := -1) {
        this.activeState.Exit()

        results := this.FindCousinsAndAncestors(this.activeState, nextState)
        cousins := results[1]
        path := results[2]

        Loop cousins.Length {
            i := A_Index
            if (i == 1 || i == cousins.Length) {
                continue
            }
            state := cousins[i]
            state.FromActiveChildToNone()
        }
        if (path.Length == 1) {
            cousins[0].FromActiveChildToNone()
        }
        else {
            if (path[2] != cousins[0].activeChild) {
                cousins[0].OnChildChange(path[2])
            }
            Loop path.Length {
                i := A_Index
                if (i == 1 || i == path.Length) {
                    continue
                }
                state.FromNoneToActiveChild(path[i+1])
            }
        }

        this.activeState := this.states[nextState]
        this.activeState.Enter(args)

    }

    FindCousinsAndAncestors(oldState, newState) {
        cousins := []
        path := []
        
        state := oldState
        while state != -1 {
            cousins.Push(state)
            path := this.InSubTree(state, newState)
            if (path.Length != 0) {
                break
            }
            state := state.parent
        }
        if (state == -1) {
            Exit(1)
        }

        return [cousins.Reverse(), path.Reverse()]
    }

    InSubTree(state, targetState) {
        path := []
        this.InSubTreeR(state, targetState, path)
        return path
    }

    InSubTreeR(state, targetState, path) {
        if (state.name == targetState.name) {
            path.Push(state)
            return true
        }
        for name, child in state.children {
            if (this.InSubTreeR(child, targetState, path)) {
                path.Push(state)
                return true
            }
        }
        return false
    }

}

/**
 * An abstract class for a State meant to be extended.
 */
class State {

    /**
     * States up a state and its hierarchy.
     * @param {State} parent Our parent state if we have one.
     * @param {Map<String, State>} children A map from names to children (if we have any).
     */
    State(parent := -1, children := Map()) {
        this.name := this.__Class.SubStr(-5)
        this.parent := parent
        this.children := Map()
    }

    /**
     * 
     * @param {Map<String, State>} children A map from names to children (if we have any).
     */
    SetChildren(children) {
        this.children := Map()
        for child in children {
            this.children[child.name] := child
        }
    }

    /**
     * 
     * @param  {State} parent Our parent state if we have one.
     */
    SetParent(parent) {
        this.parent := parent
    }

    /**
     * Gives us a machine we can use for acivating transitions.
     * @param {StateMachine} machine  The machine we are a part of.
     */
    SetMachine(machine) {
        this.machine := machine
    }

    IsParentOf(stateName) {
        return this.children.Has(stateName)
    }

    IsChildOf(stateName) {
        state := this.parent
        while state != -1 {
            if (state.name == stateName) {
                return True
            }
            state := state.perent
        }
        return False
    }

    ; -------------

    ; Abstract Methods
    ; -----

    /**
     * Activaqted upon becoming active state.
     * @param {State} previousState The state we came from.
     * @param {Map} args Arguments sent by the previous state for us to use.
     */
    Enter(previousState, args := -1) {
        
    }

    /**
     * 
     * @param {State} child The child state becoming active.
     */
    FromNoneToActiveChild(child) {
        this.activeChild := child
    }

    /**.
     * @param {State} newChild The new child state active.
     */
    OnChildChange(newChild) {
        this.activeChild := newChild
    }


    FromActiveChildToNone() {
        this.activeChild := -1
    }

    Exit(nextState) {
        
    }

}