-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Status"
checkOn = 'Event(s)';
events = "LOADING_SCREEN_DISABLED, LOAD"

customTrigger = function()
  aura_env.compareTrinketTimes()
end
