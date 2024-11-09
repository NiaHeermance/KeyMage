
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Open Application State

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

#Include ..\Utility\StateMachine.ahk
#Include ..\Utility\InTrayDetector.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

myOpenApplicationState := -1

class OpenApplicationState extends State {
    __New() {
        global myOpenApplicationState
        myOpenApplicationState := this
    }

    windowStack := []
    maxStackSize := 5

    PushWindow() {
        if (WinExist("A")) {
            windowTitle := WinGetTitle("A")
            if (this.WindowStack.Length == 0 or windowTitle != this.windowStack[this.windowStack.Length]) {
                if (this.windowStack.Length >= this.maxStackSize) {
                    this.windowStack.RemoveAt(1)  ; Remove oldest entry if we're at capacity. O(n) is fine for this small stack.
                }
                this.windowStack.Push(windowTitle)
            }
        }
    }

    PopWindow() {
        if (this.windowStack.Length > 0) {
            return this.windowStack.Pop()
        }
        return ""
    }
    
}

openSoftware(softwarePath) {
    global myOpenApplicationState
    myOpenApplicationState.PushWindow()

    parts := StrSplit(softwarePath, "\")
    softwareName := parts[parts.Length]
    if WinExist("ahk_exe " . softwareName) {
        WinActivate
    }
    else {
        Run softwarePath
    }
}

; Open Notion
#HotIf myOpenApplicationState.machine.state == myOpenApplicationState
$n:: {
    global myOpenApplicationState
    openSoftware("C:\Users\Nia\AppData\Local\Programs\Notion\Notion.exe")
    myOpenApplicationState.machine.TransitionTo("Normal")
}

; Open Obsidian
#HotIf myOpenApplicationState.machine.state == myOpenApplicationState
$o:: {
    global myOpenApplicationState
    myOpenApplicationState.PushWindow()
    if DoesWinExistAtAll("ahk_exe obsidian.exe"){
        Send "^!+{PgDn}"
    }
    else {
        openSoftware("C:\Users\Nia\AppData\Local\Programs\Obsidian\Obsidian.exe")
    }
    myOpenApplicationState.machine.TransitionTo("Normal")
}

#HotIf myOpenApplicationState.machine.state == myOpenApplicationState
$r:: {
    global myOpenApplicationState

    windowFound := false
    while (lastWindow := myOpenApplicationState.PopWindow()) {
        if WinExist(lastWindow) {
            WinActivate lastWindow
            windowFound := true
            break
        }
    }
    if (!windowFound) {
        ToolTip "No previous windows available (or stack emptied)."
        SetTimer () => ToolTip(), -1000
    }
    myOpenApplicationState.machine.TransitionTo("Normal")
}