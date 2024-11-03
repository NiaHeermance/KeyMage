
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Hotkey State

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

#Include ..\Utility\StateMachine.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

myHotkeyState := -1

class HotkeyState extends State {
    __New() {
        global myHotkeyState
        myHotkeyState := this
    }
    
}

; Open Applications
#HotIf myHotkeyState.machine.state == myHotkeyState
^o::
o:: {
    global myHotkeyState
    myHotkeyState.machine.TransitionTo("OpenApplication")
}