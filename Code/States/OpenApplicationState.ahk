
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; Open Application State

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0

#Include ..\Utility\StateMachine.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

myOpenApplication := -1

class OpenApplicationState extends State {
    __New() {
        global myOpenApplication
        myOpenApplication := this
    }
    
}


openSoftware(softwarePath) {
    parts := StrSplit(softwarePath, "\")
    softwareName := parts[parts.Length]
    if WinExist("ahk_exe " . softwareName)
        WinActivate
    else
        Run softwarePath
}

; Open Notion
#HotIf myOpenApplication.machine.state == myOpenApplication
$n:: {
    global myOpenApplication
    openSoftware("C:\Users\Nia\AppData\Local\Programs\Notion\Notion.exe")
    myOpenApplication.machine.TransitionTo("Normal")
}

; Open Obsidian
#HotIf myOpenApplication.machine.state == myOpenApplication
$o:: {
    global myOpenApplication
    Send "^!+{PgDn}"
    myOpenApplication.machine.TransitionTo("Normal")
}