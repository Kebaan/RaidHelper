#SingleInstance force
SetTitleMatchMode, 2
#persistent
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
global WindowTitle := "DR3AM RAID Helper @Kebaan"
global DebugMsg = ""
global Width
global Height

configFile = raidhelper_config.ini

;---------- Read config ---------------
IniRead, NrRuns2, %configFile%, Farm, NrRuns2, 10
IniRead, NrRuns3, %configFile%, Farm, NrRuns3, 24
IniRead, NrRuns4, %configFile%, Farm, NrRuns4, 52
IniRead, Runs2On, %configFile%, Farm, Runs2On, 1
IniRead, Runs3On, %configFile%, Farm, Runs3On, 0
IniRead, Runs4On, %configFile%, Farm, Runs4On, 0
IniRead, FarmTime, %configFile%, Farm, FarmTime, 7

IniRead, ReplayOn, %configFile%, Auto, ReplayOn, 0
IniRead, NextOn, %configFile%, Auto, NextOn, 0
IniRead, EnergyOn, %configFile%, Auto, EnergyOn, 0
IniRead, AutoAiOn, %configFile%, Auto, AutoAiOn, 0
IniRead, ArenaPickerOn, %configFile%, Auto, ArenaPickerOn, 0
IniRead, MasteriesOn, %configFile%, Auto, MasteriesOn, 0
IniRead, AutoFrequency, %configFile%, Auto, AutoFrequency, 2

;---------- GUI ---------------
Gui, Add, Tab, x2 y2 w345 h330 , Farm|Auto|Help|Debug

Gui, Tab, Farm
Gui, Add, GroupBox, x12 y25 w320 h50 , How many runs for leveling 2star?
Gui, Add, Edit, x22 y45 w70 h20 +Number gFarm vNrRuns2, % NrRuns2
Gui, Add, GroupBox, x12 y85 w320 h50 , How many runs for leveling 3star?
Gui, Add, Edit, x22 y105 w70 h20 +Number gFarm vNrRuns3, % NrRuns3
Gui, Add, GroupBox, x12 y145 w320 h50 , How many runs for leveling 4star?
Gui, Add, Edit, x22 y165 w70 h20 +Number gFarm vNrRuns4, % NrRuns4
Gui, Add, Radio, x102 y45 w50 h20 gFarm vRuns2On Checked%Runs2On%, [F5]
Gui, Add, Radio, x102 y105 w50 h20 gFarm vRuns3On Checked%Runs3On%, [F6]
Gui, Add, Radio, x102 y165 w50 h20 gFarm vRuns4On Checked%Runs4On%, [F7]
Gui, Add, Text, x12 y215 w80 h20 , Farm time [sec]
Gui, Add, Edit, x132 y212 w70 h20 +Number gFarm vFarmTime, % FarmTime
Gui, Add, CheckBox, x140 y300 w90 h30 gFarm vFarmOn, ON/OFF [F8]
Gui, Add, Text, x10 y235 w320, Farm 12-3 (or something else)  Hafax Style by replaying chosen amount of times.`n`nWill sell items along the way.

Gui, Tab, Auto
Gui, Add, Text, x12 y29 w80 h20 , replay
Gui, Add, CheckBox, x132 y29 w70 h20 gAuto vReplayOn Checked%ReplayOn%
Gui, Add, Text, x12 y59 w80 h20 , next
Gui, Add, CheckBox, x132 y59 w70 h20 gAuto vNextOn Checked%NextOn%
Gui, Add, Text, x12 y89 w80 h20 , energy
Gui, Add, CheckBox, x132 y89 w70 h20 gAuto vEnergyOn Checked%EnergyOn%
Gui, Add, Text, x12 y119 w80 h20 , auto AI
Gui, Add, CheckBox, x132 y119 w70 h20 gAuto vAutoAiOn Checked%AutoAiOn%
Gui, Add, Text, x12 y149 w80 h20 , arena picker
Gui, Add, CheckBox, x132 y149 w70 h20 gAuto vArenaPickerOn Checked%ArenaPickerOn%
Gui, Add, Text, x12 y179 w80 h20 , masteries
Gui, Add, CheckBox, x132 y179 w70 h20 gAuto vMasteriesOn Checked%MasteriesOn%
Gui, Add, Text, x12 y215 w80 h20 , frequency [sec]
Gui, Add, Edit, x132 y212 w70 h20 +Number gAuto vAutoFrequency, % AutoFrequency
Gui, Add, CheckBox, x140 y300 w90 h30 gAuto vAutoOn, ON/OFF [F12]
Gui, Add, Text, x10 y235 w320, This mode looks for specific colors and clicks on the position it found them.`n`nNote that it might find some colors in runs. Be carefull!

Gui, Tab, Help
Gui, Add, Text, x10 y30 w320, replay: send 'r', won't do anything if replay isn't visible`n`nnext: Clicks the next button if present.`n`nenergy: buys energy if empty, some of these buttons colors could be found in the level and therefore might end up in targetting spiderlings etc.`n`nauto: sends 't' to start auto if it isn't on already.`n`narena picker: starts new arena fight by pressing battle, start etc. Also presses continue when finished.`nNOTE: make sure you can win all fights shown on the page if using this.`n`nmasteries: Keeps buying energy untill no champ receives scrolls`n`n

Gui, Tab, Debug
Gui, Add, Edit, r20 +ReadOnly vDebugLog w320, 
Gui, Add, CheckBox, x140 y300 w90 h30 gDebug vTraceOn, Trace

Gui, Show, x431 y353 h335 w350, %WindowTitle%

;---------- Body ---------------

Loop {
    Sleep, % 1000
    if(AutoOn) {
        RunAuto()
    } else if(FarmOn) {
        if(Runs2On) {
            RunFarm(NrRuns2)
        } else if(Runs3On) {
            RunFarm(NrRuns3)
        } else if(Runs4On) {
            RunFarm(NrRuns4)
        }
    }
}

Return

;---------- Hotkeys ---------------

F5::
    activateFarmRuns(2)
    return
F6::
    activateFarmRuns(3)
    return
F7::
    activateFarmRuns(4)
    return
F8::
    toggleFarm()
    return

F12::
    toggleAuto()
    return

;---------- GUI flow Labels/Functions ---------------

GuiClose:
    Gui, Submit, NoHide
    IniWrite, %NrRuns2%, %configFile%, Farm, NrRuns2
    IniWrite, %NrRuns3%, %configFile%, Farm, NrRuns3
    IniWrite, %NrRuns4%, %configFile%, Farm, NrRuns4
    IniWrite, %Runs2On%, %configFile%, Farm, Runs2On
    IniWrite, %Runs3On%, %configFile%, Farm, Runs3On
    IniWrite, %Runs4On%, %configFile%, Farm, Runs4On
    IniWrite, %FarmTime%, %configFile%, Farm, FarmTime

    IniWrite, %ReplayOn%, %configFile%, Auto, ReplayOn
    IniWrite, %NextOn%, %configFile%, Auto, NextOn
    IniWrite, %EnergyOn%, %configFile%, Auto, EnergyOn
    IniWrite, %AutoAiOn%, %configFile%, Auto, AutoAiOn
    IniWrite, %ArenaPickerOn%, %configFile%, Auto, ArenaPickerOn
    IniWrite, %MasteriesOn%, %configFile%, Auto, MasteriesOn
    IniWrite, %AutoFrequency%, %configFile%, Auto, AutoFrequency
    ExitApp

Farm:
    Gui, Submit, NoHide
    debug("Runs2On " . Runs2On . " Runs3On " . Runs3On . " Runs4On " . Runs4On . " NrRuns2 " . NrRuns2 . " NrRuns3 " . NrRuns3 . " NrRuns4 " . NrRuns4 . " FarmTime " . FarmTime . " FarmOn " . FarmOn)
    toggleFarm(FarmOn)
    Return

Auto:
    Gui, Submit, NoHide
    debug("replay " . ReplayOn . " next " . NextOn . " EnergyOn " . EnergyOn . " AutoAI " . AutoAiOn . " ArenaPicker " . ArenaPickerOn . " Masteries " . MasteriesOn . " AutoFrequency " . AutoFrequency . " AutoOn " . AutoOn)
    toggleAuto(AutoOn)
    Return

Debug:
    Gui, Submit, NoHide
    debug("TraceOn " . TraceOn)
    Return

toggleFarm(Val = "") {
    GuiControlGet, FarmOn
    NewValue := % (Val == "" ? !FarmOn : Val)
    GuiControl,, FarmOn, % NewValue
    GuiControl,, AutoOn, 0
    Gui, Submit, NoHide

    debug("Farm set to " . NewValue)
}

activateFarmRuns(StarLvl) {
    GuiControl,, Runs%StarLvl%On, 1
    Gui, Submit, NoHide
    debug("Activated farm Runs" . StarLvl . "On")
}

toggleAuto(Val = "") {
    GuiControlGet, AutoOn
    NewValue := % (Val == "" ? !AutoOn : Val)
    GuiControl,, AutoOn, % NewValue
    GuiControl,, FarmOn, 0
    Gui, Submit, NoHide
    
    debug("Auto set to " . NewValue)
}

debug(Msg) {
    global DebugMsg .= Msg . "`n"
}

trace(Msg) {
    GuiControlGet, TraceOn
    if(TraceOn) {
        debug(Msg)
    }
}

resetDebugMsg() {
    global DebugMsg = ""
}

commitDebugMsg() {
    if(DebugMsg == "") {
        return
    }

    GuiControlGet, DebugLog
    FormatTime, MyTime,, HH:mm:ss
    WinGetPos, X, Y, Width, Height, Raid: Shadow Legends
    GuiControl,, DebugLog, %DebugLog%%MyTime%: Running actions on window with width %Width% and height  %Height%`n%DebugMsg%`n
    ;ControlSend, Edit6, ^{END}
    SendMessage, 0x115, 7, 0, Edit6, %WindowTitle% ;0x115 is WM_VSCROLL ; 7 is SB_BOTTOM
}

;--------- Raid functions --------------------

runFarm(Runs) {
    currentRun := 0
    Loop {
        GuiControlGet, FarmOn
        GuiControlGet, FarmTime
        if(not FarmOn or currentRun == Runs) {
            trace("not running round FarmOn " . FarmOn . " currentRun " . currentRun . " Runs " . Runs)
            break
        }
        
        InitialPos := activate()
        
        if(isResultScreen()) {
            currentRun += 1
            debug("running " . currentRun . "/" . Runs . " farm round")
            sellItemIfPresent(685, 300, 970, 390, 0xCA307B)

            replay()
            confirmEnergy()
            replay()
        } else {
            trace("not running round since we are not on resultscreen yet")
        }
        deactivate(InitialPos.X, InitialPos.Y, InitialPos.Title, 0)

        Sleep, % (FarmTime + 5) * 1000
    }
    toggleFarm(false)
    return
}

runAuto() {
    InitialPos := activate()
    GuiControlGet, ReplayOn
    GuiControlGet, NextOn
    GuiControlGet, EnergyOn
    GuiControlGet, AutoAiOn
    GuiControlGet, ArenaPickerOn
    GuiControlGet, MasteriesOn
    GuiControlGet, AutoFrequency
    if(NextOn) {
        next()
    }   
    if(ReplayOn and isResultScreen()) {
        debug("auto replay")
        replay()
    }
    if(EnergyOn) {
        confirmEnergy() 
    }   
    if(AutoAiOn) {
        activateAuto()
    }   
    if(ArenaPickerOn) {
        continue()
        continue()
        arenaBattle()
        start()
    }   
    if(MasteriesOn) {
        masteries()
    }

    deactivate(InitialPos.X, InitialPos.Y, InitialPos.Title, 0) 
    Sleep, AutoFrequency * 1000
}

sellItemIfPresent(X1, Y1, X2, Y2, Color) {
    if (clickIfPresent(X1, Y1, X2, Y2, Color)) {
        sell()
        confirmSell()
    }
}

replay() {
    ControlSend, , r, Raid: Shadow Legends
    Sleep, 250
}

next() {
    if (clickIfPresent(1600, 900, 1850, 1100, 0xAA6E00)) {
        debug("clicking next")
        Sleep, 150
    } else {
        trace("next not present")
    }
}

sell() {
    if (clickIfPresent(980, 750, 1380, 900, 0xAA6E00)) {
        debug("sell item")
        Sleep, 150
    } else {
        trace("sell not present")
    }
}

confirmSell() {
    if (clickIfPresent(980, 530, 1380, 670, 0xAA6E00)) {
        debug("confirm sell")
        Sleep, 150
    } else {
        trace("confirm sell not present")
    }
}

confirmEnergy() {
    if (clickIfPresent(760, 700, 1160, 820, 0xAA6E00)) {
        debug("confirm energy")
        Sleep, 150
    } else {
        trace("confirm energy not present")
    }
}

masteries() { 
    if (isResultScreen() and (isPresent(300, 400, 1600, 475, 0xFF6132)
        or isPresent(300, 400, 1600, 475, 0xC9A98F)
        or isPresent(300, 400, 1600, 475, 0x739E10))) {
        
        debug("replaying masteries")
        replay()
    }
}

arenaBattle() {
    if (clickIfPresent(1600, 300, 1850, 1100, 0xAA6E00)) {
        debug("clicking arena battle")
        Sleep, 150
    } else {
        trace("arena battle not present")
    }
}

start() {
    if (clickIfPresent(1600, 900, 1850, 1100, 0xAA6E00)) {
        debug("clicking start")
        Sleep, 150
    } else {
        trace("start not present")
    }
}

continue() {
    if (clickIfPresent(556, 932, 1369, 1000, 0xFFE87D)) {
        debug("clicking continue / start battle")
        Sleep, 150
    } else {
        trace("continue not present")
    }
}

activateAuto() {
    present := isPresent(50, 900, 150, 1000, 0xD8CE9C)
    
    if (present) {
        debug("activating auto")
        ControlSend, , t, Raid: Shadow Legends
    } else {
        trace("auto was not activated")
    }
}

deactivate(X, Y, Title, MoveMouse = true, SleepTime = 2000) {
    WinActivate, % Title
    if (MoveMouse) {
        MouseMove, % X, % Y, 0
    }
    BlockInput, Off
    BlockInput, MouseMoveOff
    commitDebugMsg()
    resetDebugMsg()
    Sleep, % SleepTime
}

activate() {
    BlockInput, On
    BlockInput, MouseMove
    WinGetActiveTitle, Title
    MouseGetPos, X, Y
    WinActivate, Raid: Shadow Legends
    Sleep, 20
    return {X: X, Y: Y, Title: Title}
}

click(X, Y) {
    MouseMove, X, Y, 0
    MouseClick, left
    Sleep, 750
}

isResultScreen() {
    if(isPresent(900, 5, 1000, 70, 0x29DAFD)) {
        debug("is result screen due to " . 0x29DAFD)
        return true
    }
    if(isPresent(900, 5, 1000, 70, 0xE6286A)) {
        debug("is result screen due to " . 0xE6286A)
        return true
    }
    if(isPresent(900, 5, 1000, 70, 0xD22451)) {
        debug("is result screen due to " . 0xD22451)
        return true
    }
    if(isPresent(900, 5, 1000, 70, 0x1EC0F6)) {
        debug("is result screen due to " . 0x1EC0F6)
        return true
    }
    trace("did not recognize resultscreen")
    return false
}

clickIfPresent(X1, Y1, X2, Y2, Color) {

    present := isPresent(X1, Y1, X2, Y2, Color)
    
    if (present) {
        click(present.X, present.Y)
        return true
    }
    return false
}

isPresent(X1, Y1, X2, Y2, Color) {
    TranslatedX1 := Round(Width * X1/1936)
    TranslatedY1 := Round(Height * Y1/1056)
    TranslatedX2 := Round(Width * X2/1936)
    TranslatedY2 := Round(Height * Y2/1056)
    PixelSearch, OutputVarX, OutputVarY, TranslatedX1, TranslatedY1, TranslatedX2, TranslatedY2, Color, 3, FAST RGB
    if (ErrorLevel = 0) {
        trace("Found " . Color . " at (" . OutputVarX . ";" . OutputVarY . ")")
        
        return {X: OutputVarX, Y: OutputVarY}
    }
    trace("Couldn't find " . Color . " at X [" . TranslatedX1 . ";" . TranslatedX2 . "] Y [" . TranslatedY1 . ";" . TranslatedY2 . "]")
    return false
}

