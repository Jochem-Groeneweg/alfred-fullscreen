#!/usr/bin/env bash

query="$1"

# No need to check for empty query anymore, as it's handled by a different workflow path

function getRunningApps() {
  osascript <<'SCRIPT'
tell application "System Events"
	set listOfProcesses to (name of every process where background only is false)
end tell
set results to {}
repeat with visibleProcess in listOfProcesses
	set the results to the results & visibleProcess
end repeat
return results
SCRIPT
}

xmlItems="<?xml version=\"1.0\"?><items>"
IFS=$'\n'
for app in $(getRunningApps | sed 's/, /\'$'\n/g' | sort); do
  app_lower=$(echo "$app" | tr '[:upper:]' '[:lower:]')
  query_lower=$(echo "$query" | tr '[:upper:]' '[:lower:]')
  if [[ "$app_lower" == "$query_lower"* ]]; then
    pathToApp=$(ps -u "$USER" -o command | grep -v grep | grep -F "${app}" | head -n 1 | sed -e 's/-psn.*//' -e 's/\.app.*/.app/g')
    displayName="${app}"
    if [[ -f "${pathToApp}/Contents/Info.plist" ]]; then
      bundleName=$(defaults read "${pathToApp}/Contents/Info.plist" CFBundleName 2>/dev/null)
      if [[ -n "$bundleName" ]]; then
        displayName="$bundleName"
      fi
    fi
    icon="<icon type=\"fileicon\">${pathToApp}</icon>"
    title="<title>${displayName}</title>"
    item="<item uid=\"${app}\" arg=\"${displayName}\" autocomplete=\"${displayName}\" type=\"file\">${title}${icon}</item>"
    xmlItems="${xmlItems}${item}"
  fi
done
echo "${xmlItems}</items>"