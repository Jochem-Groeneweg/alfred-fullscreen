on run argv
	if count of argv is 0 then
		return "No application name provided."
	end if
	
	set appName to item 1 of argv
	
	-- First, activate the application to switch to its space
	tell application appName
		activate
	end tell
	
	-- A short delay to ensure the app is frontmost and its windows are accessible
	delay 0.5
	
	-- Now, toggle the fullscreen state using the standard keyboard shortcut.
	-- This is more reliable than toggling AXFullScreen attribute.
	tell application "System Events"
		tell process appName
			keystroke "f" using {command down, control down}
		end tell
	end tell
end run