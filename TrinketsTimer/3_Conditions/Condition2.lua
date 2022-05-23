_if = {
    allOf = {
        trigger_8 = {
            "Remaining Duration",
            ">",
            "0"
        },
        trigger_8 = {
            "Remaining Duration",
            "<=",
            "5"
        }
    }
}

_then = {
    runCustomCode = {
        customCode = "if (aura_env.trinket_2_usable and not aura_env.overwroteExpirationTime) then" +
            "aura_env.compareTrinketTimes()" +
            "end"
    }
}
