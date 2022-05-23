_if = {
    allOf = {
        trigger_5 = {
            "Active",
            "True"
        },
        customCheck = {
            additionalEvents = "",
            customCheck = "function() return aura_env.trinket_1_usable and not aura_env.cdReady_1 end"
        }
    }
}

_then = {
    runCustomCode = {
        customCode = "aura_env.compareTrinketTimes()"
    }
}
