_if = {
    allOf = {
        trigger_6 = {
            "Active",
            "True"
        },
        customCheck = {
            additionalEvents = "",
            customCheck = "function() return aura_env.trinket_2_usable and not aura_env.cdReady_2 end"
        }
    }
}

_then = {
    runCustomCode = {
        customCode = "aura_env.compareTrinketTimes()"
    }
}
