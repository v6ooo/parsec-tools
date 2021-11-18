;
;  Hook keyboard input and send it to Parsec Soda.
;
;  The chat input box must be selected in Soda for it to work.
;  Will not be able to prevent input from all apps.
;
;  Ctrl+Shift+C to activate
;  Enter to send message, Esc to cancel
;

guiPositionX := 10
guiPositionY := 10
guiWidth := 700
backgroundColor := "000000"
fontSize := 16
fontColor := "00FF00"
windowClass := "ahk_class Parsec Soda"
windowControl := 

if not A_IsAdmin {
 try Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
 ExitApp
}

#NoEnv
#SingleInstance force
SetKeyDelay, 100, 100

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, %backgroundColor%, %backgroundColor%
Gui, Font, s%fontSize%
Gui, Add, Text, vMyText w%guiWidth% c%fontColor%
WinSet, Transparent, 225
return

UpdateOSD:
 string := StrReplace(ih.Input, "&", "&&")
 GuiControl,, MyText, %string%
return

^+c::
 global guiPosition
 SetTimer, UpdateOSD, 100
 Gui, Show, x%guiPositionX% y%guiPositionY% NoActivate
 endKey := chr(13) ; Enter
 abortKey := chr(27) ; Esc
 ih := InputHook("*", endKey, abortKey)
 ih.Start()
 ih.Wait()
 if (ih.EndReason = "EndKey") {
  textdata := ih.Input
  ControlSend, %windowControl%, {Text}%textdata%, %windowClass%
  Sleep, 100
  ControlSend, %windowControl%, {Enter}, %windowClass%
 }
 GuiControl,, MyText, 
 Gui, Hide
 SetTimer, UpdateOSD, Off
return
