
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Shortcuts

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#SingleInstance Force

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

; -----------------
; LEADER KEYS
; ---------

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; State
; -----

; Modes
    ; ComposeHotkeyLiminal Mode
        ; Stage One
        ; When waiting for the key to be pressed
        composeHotkeyLiminal_waitingForFirstKeyPressed := false
    
        ; Stage Two
        ; When waiting for a non-modifier key to decide if we go to hotkey mode or not.
        composeHotkeyLiminal_OnCountdown := false

    ; Hotkey Mode
    HotkeyMode := false

; -------------

; Variables For Modes
    
    ; Buffers of keys pressed in Stage Two of Liminal mode.
        composeKeyLiminal_keysPressed := []

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_
; ---

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; Transition Functions
; -----

; Enter ComposeHotkeyLiminal
    
    ; Stage One
    activateComposeHotkeyLiminalStageOne() {
        global composeHotkeyLiminal_waitingForFirstKeyPressed := true
        global composeHotkeyLiminal_OnCountdown := false
    }

    ; Stage Two
    activateComposeHotkeyLiminalStageTwo() {
        global;
        composeHotkeyLiminal_waitingForFirstKeyPressed := false
        composeHotkeyLiminal_OnCountdown := true
        composeKeyLiminal_keysPressed.Clear()
        composeKeyLiminal_keysPressed.Push(A_PriorKey)
        SetTimer potentiallyActivateComposeMode, -100
    }

; -------------

; Enter Hotkey Mode
    activateHotkeyMode() {
        global;
        composeHotkeyLiminal_waitingForFirstKeyPressed := false
        composeHotkeyLiminal_OnCountdown := false
        HotkeyMode := true
        
        toSend := A_PriorKey
        toSend .= composeKeyLiminal_keysPressed.Join()
        Send toSend
    }

; -------------

; Enter Compose Mode
    potentiallyActivateComposeMode() {
        if composeHotkeyLiminal_OnCountdown {
            toSend := "{Insert}"
            toSend .= global composeKeyLiminal_keysPressed.Join()
            composeHotkeyLiminal_OnCountdown := false
            Send toSend
        }
    }

; -------------

; Transition Checkers

    checkIfTransitionToHotkeyMode() {
        global;
        return composeHotkeyLiminal_waitingForFirstKeyPressed || composeHotkeyLiminal_OnCountdown
    }


; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; ---

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; Key Strokes
; ------

; Initial Liminal Activation
    RAlt:::activateComposeHotkeyLiminal()

; -------------

; If Modifers Pressed During Liminal
    ; CTRL Pressed
    #HotIf checkIfTransitionToHotkeyMode
    CTRL::activateHotkeyMode()
    #HotIf

    ; LAlt Pressed
    #HotIf checkIfTransitionToHotkeyMode
    LAlt::activateHotkeyMode()
    #HotIf

; -------------

; Any Other Key Pressed During Liminal
    ; During Stage One
    #HotIf composeHotkeyLiminal_waitingForFirstKeyPressed
    *::activateComposeHotkeyLiminalStageTwo()
    #HotIf

    ; During Stage Two
    excludedKeys := ["Control", "LAlt", "Shift"]
    #HotIF composeHotkeyLiminal_OnCountdown
    *::{
        global;
        if !excludedKeys.Has(A_PriorKey) {
            composeKeyLiminal_keysPressed.Push(A_PriorKey)
        }
    }
    #HotIf


; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

; -----------------
; APPLICATION OPENING HOTKEYS
; ---------

; Notion
#HotIf HotkeyMode
$^n:: {
    if WinExist("ahk_exe Notion.exe")
        WinActivate
    else
        Run "C:\Users\Nia\AppData\Local\Programs\Notion\Notion.exe"

    global HotkeyMode := false
}

; YNAB
$^y:: {
    if WinExist("ahk_exe firefox.exe") {
        WinActivate
        Sleep 300 
        Send "^t"
        Sleep 300
    } else {
        Run "firefox.exe"
        Sleep 1000
    }
    ToolTip "Activating Firefox..."
    Send "https://app.ynab.com/98f38188-aa37-4290-9658-9e0aeb241f9c/budget{Enter}"
    
    global HotkeyMode := false
}

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;
