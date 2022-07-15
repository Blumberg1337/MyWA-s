-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
events = "CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REMOVED"

customTrigger = function(e,_,_,_,sourceGUID,_,_,_,_,_,_,_,spellId,...)
  -- if we have a sourceGUID which yields the player...
  local playerGUID = UnitGUID("player")
  if (playerGUID and sourceGUID and playerGUID == sourceGUID) then
    -- if either trinket's spellId matches the combat logged spellId...
    if (aura_env.trinket_1_spellId == spellId or aura_env.trinket_2_spellId == spellId) then
      aura_env.compareTrinketTimes()
    end
  end
end

hide = "Custom"
