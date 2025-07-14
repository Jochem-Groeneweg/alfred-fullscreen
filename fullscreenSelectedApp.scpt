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
	
	-- Now, toggle the fullscreen state
	tell application "System Events"
		tell process appName
			try
				set isFullScreen to get value of attribute "AXFullScreen" of window 1
				set value of attribute "AXFullScreen" of window 1 to not isFullScreen
			on error errMsg number errNum
				-- Fallback for apps that don't respond to the above, e.g. some games or older apps
				tell application "System Events" to keystroke "f" using {command down, control down}
			end try
		end tell
	end tell
end run