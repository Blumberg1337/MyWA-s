-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Status"
checkOn = "Event(s)"
events = "TRINKET_TIMERS_GLOW"

customTrigger = function()
    return aura_env.glow
end
