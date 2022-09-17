-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
events = "CLEU:SWING_DAMAGE, CLEU:SWING_MISSED, CLEU:SPELL_EXTRA_ATTACKS, CLEU:SPELL_DAMAGE, CLEU:SPELL_MISSED, UNIT_INVENTORY_CHANGED:player"

customTrigger = function(e,...)
  aura_env.parryHasteBonus = 0
  
  local subEvent = select(2, ...)
  local sourceName = select(5,...)
  local destName = select(9,...)
  local playerName = UnitName("player")

  -- Main hand weapon change results in a swing timer reset
  if (e == "UNIT_INVENTORY_CHANGED") then
    local mhId = GetInventoryItemID("player", 16)
    if aura_env.mhId and aura_env.mhId ~= mhId then
      aura_env.startTime = GetTime()
      return true
    end
  else
    aura_env.mhId = GetInventoryItemID("player", 16)
  end

  -- Weapon swing succeded to hit target
  if (subEvent == "SWING_DAMAGE") then
    -- Weapon swing from player's main hand weapon excluding extra attacks
    if (select(21, ...) == false and sourceName == playerName and not aura_env.extraAttacks) then
      aura_env.startTime = GetTime()
      aura_env.extraAttacks = false
      return true
    end
    aura_env.extraAttacks = false
  end
  
  -- Weapon swing failed to hit target
  if (subEvent == "SWING_MISSED") then
    -- Weapon swing from player's main hand weapon
    if (select(13, ...) == false and sourceName == playerName) then
      aura_env.startTime = GetTime()
      return true
    end
    -- Player gets parry-hasted
    if (destName == playerName and select(12, ...) == "PARRY") then
      if (aura_env.startTime and aura_env.startTime <= GetTime()) then
        local mhSpeed = UnitAttackSpeed("player")
        local swingTimeRemaining = aura_env.startTime + mhSpeed - GetTime()
        local minSwingTime = mhSpeed * 0.2
        
        -- Swing time remaining must be above 20% 
        if (minSwingTime < swingTimeRemaining) then
          swingTimeRemaining = swingTimeRemaining - (mhSpeed * 0.4)
          aura_env.parryHasteBonus = mhSpeed * 0.4
          
          -- New calculated swing timer below 20% (or old one above 80%) -> set to 20%
          if (swingTimeRemaining < minSwingTime) then
            aura_env.parryHasteBonus = minSwingTime
          end
          return true
        end 
      end
    end
  end
  
  -- Ability on weapon swing succeded or failed to hit target
  if (subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_MISSED") then
    if (sourceName == playerName and not aura_env.extraAttacks) then
      for i=1, #aura_env.swingTimerSpellIds do
        if (select(12, ...) == aura_env.swingTimerSpellIds[i]) then
          aura_env.startTime = GetTime()
          aura_env.extraAttacks = false
          return true
        end
      end
    end
    aura_env.extraAttacks = false
  end
  
 -- Extra attacks should not reset weapon swing timer
  if (subEvent == "SPELL_EXTRA_ATTACKS") then
    if (sourceName == playerName) then
      aura_env.extraAttacks = true
      return true
    end
  end
end

hide = "Timed"

dynamicDuration = true

durationInfo = function()
  local mhSpeed = UnitAttackSpeed("player")
  if aura_env.startTime and aura_env.startTime <= GetTime() then
    if aura_env.parryHasteBonus then
      return mhSpeed, aura_env.startTime + mhSpeed - aura_env.parryHasteBonus
    end
    return mhSpeed, aura_env.startTime + mhSpeed
  end
end
