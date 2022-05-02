-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
events = "UNIT_INVENTORY_CHANGED:player"

customTrigger = function()
    aura_env.compareTrinketTimes()
end

hide = "Custom"
