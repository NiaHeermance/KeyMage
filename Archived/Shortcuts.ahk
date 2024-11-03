
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Shortcuts

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#SingleInstance Force

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

; -----------------
; HELPER FUNCTIONS
; ---------

join(arr) {
    ret := ""
    for index, str in arr {
        ret .= str
    }
    return ret
}


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
    
    ; Stage Two
        ; Buffers of keys pressed
            composeHotkeyLiminal_keysPressed := []

        ; Count for number of key pressed checks
            composeHotkeyLiminal_checksCount := 0


; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; ---

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; Transition Functions
; -----

; Enter ComposeHotkeyLiminal
    
    ; Stage One
        activateComposeHotkeyLiminalStageOne() {
            global composeHotkeyLiminal_waitingForFirstKeyPressed
            global composeHotkeyLiminal_OnCountdown

            composeHotkeyLiminal_waitingForFirstKeyPressed := true
            composeHotkeyLiminal_OnCountdown := false

            waitForFirstKey()
        }

        waitForFirstKey() {
            if A_PriorKey != "RAlt" {
               activateComposeHotkeyLiminalStageTwo()
            }
            else {
                SetTimer waitForFirstKey, -10
            }
        }

    ; Stage Two
    activateComposeHotkeyLiminalStageTwo() {
        global composeHotkeyLiminal_waitingForFirstKeyPressed
        global composeHotkeyLiminal_OnCountdown
        global composeHotkeyLiminal_keysPressed
        global composeHotkeyLiminal_keysPressed
        global composeHotkeyLiminal_checksCount

        composeHotkeyLiminal_waitingForFirstKeyPressed := false
        composeHotkeyLiminal_OnCountdown := true
        composeHotkeyLiminal_keysPressed := []
        composeHotkeyLiminal_keysPressed.Push(A_PriorKey)

        composeHotkeyLiminal_checksCount := 0
        potentiallyActivateComposeMode()
    }

; -------------

; Enter Hotkey Mode
    activateHotkeyMode() {
        global composeHotkeyLiminal_waitingForFirstKeyPressed
        global composeHotkeyLiminal_OnCountdown
        global HotkeyMode
        global composeHotkeyLiminal_keysPressed

        composeHotkeyLiminal_waitingForFirstKeyPressed := false
        composeHotkeyLiminal_OnCountdown := false
        HotkeyMode := true
        
        toSend := A_PriorKey
        toSend .= join(composeHotkeyLiminal_keysPressed)
        Send toSend
    }

; -------------

; Enter Compose Mode
    potentiallyActivateComposeMode() {
        global composeHotkeyLiminal_OnCountdown
        global composeHotkeyLiminal_keysPressed

        previousKey = composeHotkeyLiminal_keysPressed[composeHotkeyLiminal_keysPressed.Length]

        excludedKeys := ["Control", "LAlt", "Shift"]
        if (!excludedKeys.Has(A_PriorKey)) {
            composeHotkeyLiminal_OnCountdown := false
            toSend := "{Insert}"
            if (composeHotkeyLiminal_keysPressed.Length > 1) {
                toSend .= join(composeHotkeyLiminal_keysPressed)
            }
            toSend .= A_PriorKey
            Send toSend
            return
        }
        else if (A_PriorKey != previousKey) {
            composeHotkeyLiminal_keysPressed .= A_PriorKey
        }

        if (co)
    }

; -------------

; Transition Checkers

    checkIfTransitionToHotkeyMode() {
        global composeHotkeyLiminal_waitingForFirstKeyPressed
        global composeHotkeyLiminal_OnCountdown

        return composeHotkeyLiminal_waitingForFirstKeyPressed || composeHotkeyLiminal_OnCountdown
    }


; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; ---

; _,.-'~'-.,__,.-'~'-.,__,.-'~'-.,_

; Key Strokes
; ------

; Initial Liminal Activation
    RAlt::activateComposeHotkeyLiminalStageOne()

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
    
    global HotkeyMode
    HotkeyMode := false
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

    global HotkeyMode
    HotkeyMode := false
}

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;