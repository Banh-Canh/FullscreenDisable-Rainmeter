#Include _changedisplaysettings.ahk
isUltra := false
WinWait, ahk_exe Rainmeter.exe
Sleep, 20000
Loop 
{
    WinId := WinExist("A")
    WinGetClass, class, A
	WinGet, Active_ID, ID, A
    WinGet, Active_Process, ProcessName, ahk_id %Active_ID%
	
    isFullScreen := isActiveWindowFullScreen(WinId, class)
    if (isFullScreen)
    {
		if ( !isRainmeterDisabled && ProcessExist("Rainmeter.exe") )
		{
			RunWait %comspec% /c ""C:\Program Files\Rainmeter\Rainmeter.exe" !LoadLayout "EMPTY"",,Hide ;
			isRainmeterDisabled := true
		}
    }
    else if (!isFullScreen)
    {	
		if ( isRainmeterDisabled != false && ProcessExist("Rainmeter.exe") && Active_Process !="rpcs3_mod.exe" && Active_Process !="rpcs3.exe" )
		{
			RunWait %comspec% /c ""C:\Program Files\Rainmeter\Rainmeter.exe" !LoadLayout "Custom"",,Hide ;
			isRainmeterDisabled := false
		}
    }
    Sleep, 5000
}

ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}

isActiveWindowFullScreen(WinId, class) {
	;checks if the specified window is full screen
	
	winID := WinExist( winTitle )
	
	;exception, do not count as fullscreen even if app is in fullscreen
	if ( !winID or class == "WorkerW" or class == "Progman" or class == "WPEUI" or class == "Shell_TrayWnd" or class == "CEF-OSC-WIDGET" or class == "MozillaWindowClass" or class == "" or class == "mpv" or class == "SDL_app" )
        return false
	
	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}