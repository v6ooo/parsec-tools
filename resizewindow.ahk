;
;   This script adds a icon with tray menu that will resize the
;   last active window so the resolution fits inside the client area
;

#NoEnv
#SingleInstance, force
#Persistent

; ----------------------------------------------------------------------------------------------------------------------
; GetWindowInfo(HWND)
; Function:
;     Retrieves information about the specified window.
; Parameter:
;     HWND - A handle to the window whose information is to be retrieved.
; Return value:
;     If the function succeeds, the return value is an object containing the information.
;     If the function fails, the return value is zero.
; MSDN:
;     http://msdn.microsoft.com/en-us/library/ms632610(v=vs.85).aspx
; ----------------------------------------------------------------------------------------------------------------------
GetWindowInfo(HWND) {
   Static SizeOfWINDOWINFO := 60
   ; Struct WINDOWINFO
   VarSetCapacity(WINDOWINFO, SizeOfWINDOWINFO, 0)
   NumPut(SizeOfWINDOWINFO, WINDOWINFO, "UInt")
   If !DllCall("User32.dll\GetWindowInfo", "Ptr", HWND, "Ptr", &WINDOWINFO, "UInt")
      Return False
   ; Object WI
   WI := {}
   WI.WindowX := NumGet(WINDOWINFO,  4, "Int")                 ; X coordinate of the window
   WI.WindowY := NumGet(WINDOWINFO,  8, "Int")                 ; Y coordinate of the window
   WI.WindowW := NumGet(WINDOWINFO, 12, "Int") - WI.WindowX    ; Width of the window
   WI.WindowH := NumGet(WINDOWINFO, 16, "Int") - WI.WindowY    ; Height of the window
   WI.ClientX := NumGet(WINDOWINFO, 20, "Int")                 ; X coordinate of the client area
   WI.ClientY := NumGet(WINDOWINFO, 24, "Int")                 ; Y coordinate of the client area
   WI.ClientW := NumGet(WINDOWINFO, 28, "Int") - WI.ClientX    ; Width of the client area
   WI.ClientH := NumGet(WINDOWINFO, 32, "Int") - WI.ClientY    ; Height of the client area
   WI.Style   := NumGet(WINDOWINFO, 36, "UInt")                ; The window styles.
   WI.ExStyle := NumGet(WINDOWINFO, 40, "UInt")                ; The extended window styles.
   WI.State   := NumGet(WINDOWINFO, 44, "UInt")                ; The window status (1 = active).
   WI.BorderW := NumGet(WINDOWINFO, 48, "UInt")                ; The width of the window border, in pixels.
   WI.BorderH := NumGet(WINDOWINFO, 52, "UInt")                ; The height of the window border, in pixels.
   WI.Type    := NumGet(WINDOWINFO, 56, "UShort")              ; The window class atom.
   WI.Version := NumGet(WINDOWINFO, 58, "UShort")              ; The Windows version of the application.
   Return WI
}

setClientSize(winTitle, width, height) {
    WinGet, myHwnd, ID, %winTitle%
    my := GetWindowInfo(myHwnd)
    newW := width + (my.WindowW - my.ClientW)
    newH := height + (my.WindowH - my.ClientH)
    WinMove, %winTitle%, , my.WindowX, my.WindowY, newW, newH
}

traySetSize(width, height) {
    SendInput, !{Esc}
    Sleep, 10
    setClientSize("A", width, height)
}

trayExit() {
    ExitApp
}

setRes_1280_720 := Func("traySetSize").Bind(1280, 720)
setRes_1920_1080 := Func("traySetSize").Bind(1920, 1080)

;Menu, Tray, Icon, icons\r.ico
Menu, Tray, NoStandard
Menu, Tray, Add, 1280 x 720, % setRes_1280_720
Menu, Tray, Add, 1920 x 1080, % setRes_1920_1080
Menu, Tray, Add
Menu, Tray, Add, Exit, trayExit
return

;^#s::Menu, Tray, Show
