;@Ahk2Exe-SetOrigFilename   Elysium Engine ExpGen
;@Ahk2Exe-SetProductVersion 1.0
;@Ahk2Exe-SetVersion        1.0
;@Ahk2Exe-SetCopyright      Freeware
;@Ahk2Exe-SetCompanyName    None
;@Ahk2Exe-SetProductName    ExpGen to Elysium Engine Server
;@Ahk2Exe-SetDescription    Experience Generator to Elysium Engine Server

#SingleInstance Force
Menu, Tray, NoIcon
SetWorkingDir %A_ScriptDir%

Gui Add, Text,, LVL Initial (1 to 9.998):
Gui, Add, Edit, w220 vLVInit1 number Limit4 Disabled
Gui, Add, UpDown, vLVInit2 Range1-9998

Gui Add, Text,, LVL Max (2 to 9.999):
Gui, Add, Edit, w220 vLVMax1 number Limit4 Disabled
Gui, Add, UpDown, vLVMax2 Range2-9999

Gui Add, Text,, EXP Initial (2 to 999.999):
Gui, Add, Edit, w220 vExpInit1 number Limit6 Disabled
Gui, Add, UpDown, vExpInit2 Range2-999999

Gui Add, Text,, Multiplier - Formule: (Current += Exp * Mult):

Gui, Add, Edit, w220 vMultip1 number Limit3 Disabled
Gui, Add, UpDown, vMultip2 Range1-999, 2

Gui, Add, Button, w222 x9 gSave vBSubmit Disabled, Save

Gui, Add, Text, vStatus w222
Gui, Add, Text, w222, Elysium Engine Server - Experience Generator

Gui, -MinimizeBox -MaximizeBox
Gui, Show, AutoSize Center, Experience Generator

readIni:
firstlvl := 0
firstexp := 0
mult := 2

IniRead, maxlvl, Data.ini, MAX, MAX_LEVEL, 0

Loop, %maxlvl%
{
	if (firstlvl < 1)
	{
		IniRead, firstexp, experience.ini, EXPERIENCE, Exp%A_Index%, 0
		if (firstexp > 1)
		{
			firstlvl := A_Index
			break
		}
	}
}
mult := firstlvl+1

GuiControl, Enable, LVInit1
GuiControl, Enable, LVInit2
GuiControl, Enable, LVMax1
GuiControl, Enable, LVMax2
GuiControl, Enable, ExpInit1
GuiControl, Enable, ExpInit2
GuiControl, Enable, Operand
GuiControl, Enable, Multip1
GuiControl, Enable, Multip2
GuiControl, Enable, BSubmit

IniRead, mult, experience.ini, EXPERIENCE, Exp%mult%, 60
mult := (mult - firstexp) / firstexp

if (maxlvl > 1)
{
	GuiControl,, LVInit2, %firstlvl%
	MsgBox %firstlvl%
	GuiControl,, LVMax2, %maxlvl%
	GuiControl,, ExpInit2, %firstexp%
	GuiControl,, Multip2, %mult%
}
else
{
	GuiControl,, LVInit2, 1
	GuiControl,, LVMax2, 100
	GuiControl,, ExpInit2, 20
	GuiControl,, Multip2, 2
}
return

Save:
GuiControl, +AltSubmit, Operand
Gui, Submit, NoHide

if (LVInit2 > LVMax2 || LVInit2 = LVMax2)
{
	MsgBox, 0x30, , The starting level cannot be equal to or higher than the maximum level!
	return
}
firstexp := ExpInit2

GuiControl, Disable, LVInit1
GuiControl, Disable, LVInit2
GuiControl, Disable, LVMax1
GuiControl, Disable, LVMax2
GuiControl, Disable, ExpInit1
GuiControl, Disable, ExpInit2
GuiControl, Disable, Operand
GuiControl, Disable, Multip1
GuiControl, Disable, Multip2
GuiControl, Disable, BSubmit

FileDelete, experience.ini
Loop, %LVMax2%
{
	if (A_Index >= LVInit2)
	{
		progress := Round((A_Index/LVMax2)*100)
		Gui, Font, c0000FF Bold
		Guicontrol, Font, Status
		GuiControl,, Status, Progress`: %progress%`%
		IniWrite, %firstexp%, experience.ini, EXPERIENCE, Exp%A_Index%
		firstexp += (ExpInit2 * Multip2)
		IniWrite, %A_Index%, Data.ini, MAX, MAX_LEVEL
	}
}
Gui, Font, c000000
Guicontrol, Font, Status

Goto readIni

GuiEscape:
GuiClose:
if (progress < 1 || progress > 99)
{
	ExitApp
}
else
{
	return
}
