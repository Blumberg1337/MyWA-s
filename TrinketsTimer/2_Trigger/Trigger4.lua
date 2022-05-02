-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
events = "TRINKET_TIMERS_INITIALIZED"

customTrigger = function()
    return true
end

hide = "Custom"

durationInfo = function()
    return aura_env.duration, aura_env.expirationTime
end

iconInfo = function()
    return aura_env.icon
end
