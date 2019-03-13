tell application "Safari"
      activate
      do JavaScript "window.location.reload();" in first document
end tell
