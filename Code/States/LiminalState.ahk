
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Liminal State

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

#Include ..\Utility\StateMachine.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

myLiminalState := -1

class LiminalState extends State {
    __New() {
        global myLiminalState
        myLiminalState := this
    }

    Enter(args) {
        this.awaitingKey := InputHook("L1")
        this.awaitingKey.Start()
        this.awaitingKey.Wait()
        if (this.awaitingKey.EndReason != "Stopped") {
            this.machine.TransitionTo(
                "Compose",
                Map("PressedKey", this.awaitingKey.Input)
            )
        }
    }
    
}

#HotIf myLiminalState.machine.state == myLiminalState
~LAlt::
~PrintScreen::
~LCtrl::
~CapsLock::{
    global myLiminalState
    myLiminalState.awaitingKey.Stop()
    myLiminalState.machine.TransitionTo("Hotkey")
}