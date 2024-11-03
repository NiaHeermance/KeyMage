#Requires AutoHotkey v2.0

class KeyChecker {
    callbackFunction := -1

    totalTime := -1
    interval := -1

    count := 0
    endCount := -1

    mode := "matching"


    __New(callbackFunction, desiredKeys, interval, totalTime := -1, mode := "matching") {
        this.callbackFunction := callbackFunction
        this.interval = interval
        this.totalTime = totalTime

        this.endCount := Ceil(totalTime / interval)
        
        this.mode := mode

    }

    checkKey() {

    }
}