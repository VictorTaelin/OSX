#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

!(::
Send {ASC 91}
return

!)::
Send {ASC 93}
return

!n::
Send {Numpad0}
return

!m::
Send {Numpad1}
return

!,::
Send {Numpad2}
return

!.::
Send {Numpad3}
return

!j::
Send {Numpad4}
return

!k::
Send {Numpad5}
return

!l::
Send {Numpad6}
return

!u::
Send {Numpad7}
return

!i::
Send {Numpad8}
return

!o::
Send {Numpad9}
return

!space::
Send {Space}
return