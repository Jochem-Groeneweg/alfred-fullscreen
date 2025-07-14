tell application "System Events"
    set frontApp to first application process whose frontmost is true
    set frontAppName to name of frontApp
    
    tell process frontAppName
        tell application "System Events" to keystroke "f" using {command down, control down}
    end tell
end tell 