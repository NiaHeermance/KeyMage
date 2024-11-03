
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Compose State

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

#Include ..\Utility\StateMachine.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

myComposeState := -1

/**
 * Activates WinCompose for typing Unicode characters.
 */
class ComposeState extends State {
    __New() {
        global myComposeState
        myComposeState := this
    }

    /**
     * 
     * @param {Map} args "PressedKey": The key pressed that told us we should be in compose.
     */
    Enter(args) {
        output := "{Insert}"
        output .= args["PressedKey"]

        ; Activate WinCompose
        Send output
        this.machine.TransitionTo("Normal")
    }
}