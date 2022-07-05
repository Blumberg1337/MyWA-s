-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
--PLAYER_REGEN_DISABLED = getting outfight event
events = "PLAYER_REGEN_DISABLED, LOADING_SCREEN_DISABLED, UNIT_INVENTORY_CHANGED:player"

customTrigger = function()
  return aura_env.resistanceBuffsValue()
end

hide = "Custom"

nameInfo = function()
  return aura_env.resistanceName
end

iconInfo = function()
  return aura_env.resistanceIconId
end
