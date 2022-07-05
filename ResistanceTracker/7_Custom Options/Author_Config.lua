-- just a stub

space = {
    optionType = "Space",
    width = "2"
}

description = {
    optionType = "Description",
    width = "2",
    fontSize = "Large",
    descriptionText = "TrinketTimers by iceqty"
}

space = {
    optionType = "Space",
    width = "2"
}

description = {
    optionType = "Description",
    width = "2",
    fontSize = "Medium",
    descriptionText = "Please report any occurring bugs on the wago.io site in this WeakAura's comment section."
}

separator = {
    optionType = "Separator"
}

space = {
    optionType = "Space",
    width = "2"
}

enableGlowEffect = {
    optionType = "Toggle",
    displayName = "Enable Glow Effect",
    optionKey = "glow",
    width = "1",
    default = true
}

restrictGlowToTrinketBuffsRunning = {
    optionType = "Toggle",
    displayName = "Restrict Glow to Trinket Buffs running",
    optionKey = "glowBuffsOnly",
    width = "1",
    default = false
}

space = {
    optionType = "Space",
    width = "2"
}

enableLastSecondsFeature = {
    optionType = "Toggle",
    displayName = "Enable lastSeconds-Feature",
    optionKey = "lastSecondsToggle",
    tooltip = "Show the trinket coming off cooldown in the next x seconds.",
    width = "1",
    default = true
}

lastSecondsSlider = {
    optionType = "Slider",
    displayName = "Last Seconds from 0.05 to 30 seconds",
    optionKey = "lastSeconds",
    width = "1",
    default = "5",
    min = "0",
    max = "30",
    stepSize = "0.05"
}
