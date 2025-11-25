#Persistent

global scriptActive := false
global leftClickTimes := []
global rightClickTimes := []

; Toggle script active/deactivate with 'c' key
c::
    scriptActive := !scriptActive
    if (scriptActive)
        TrayTip, Click Script, Activated
    else
        TrayTip, Click Script, Deactivated
    return

; Left mouse button hotkey
$LButton::
    if (scriptActive)
    {
        ; Handle multi-click logic when active
        HandleSingleClick("left", leftClickTimes)
        ; Block original click to prevent duplicate
        Return
    }
    else
    {
        ; Script disabled, allow normal mouse behavior
        ; Use ~ prefix to let clicks pass through without interference:
        Send {LButton down}
        KeyWait, LButton
        Send {LButton up}
        Return
    }

; Right mouse button hotkey
$RButton::
    if (scriptActive)
    {
        HandleSingleClick("right", rightClickTimes)
        Return
    }
    else
    {
        Send {RButton down}
        KeyWait, RButton
        Send {RButton up}
        Return
    }

HandleSingleClick(buttonType, ByRef clickTimes)
{
    currentTime := A_TickCount

    while (clickTimes.MaxIndex() > 0 && clickTimes[1] < currentTime - 1000)
        clickTimes.RemoveAt(1)

    clickTimes.Push(currentTime)
; amt of cps u need to clock for script to start adding clicks
    if (clickTimes.MaxIndex() >= 1)
    {
        clickTimes.Clear()
        if (buttonType = "left")
            Click 2
        else if (buttonType = "right")
            Click 2 right
    }
    else
    {
        if (buttonType = "left")
            Click
        else if (buttonType = "right")
            Click right
    }
    return
}
