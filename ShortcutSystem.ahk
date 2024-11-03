
; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

; ShortcutSystem

; This script is desgined around these rebindings:

; CapsLock::LCtrl
; LWin::RAlt
; PrintScreen::LAlt
; PgUp::LWin

; Activate KeyRemapping.ahk

; ~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~ ;

#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Code/Utility/StateMachine.ahk

#Include Code/States/NormalState.ahk
#Include Code/States/LiminalState.ahk
#Include Code/States/ComposeState.ahk
#Include Code/States/HotkeyState.ahk

#Include Code/States/OpenApplicationState.ahk

; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;



; ...*...



; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;

states := Map(
    "Normal",  NormalState(),
    "Liminal", LiminalState(),
    "Compose", ComposeState(),
    "Hotkey",  HotkeyState(),
    "OpenApplication", OpenApplicationState()
)

machine := StateMachine(states, "Normal")


; .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:. ;
