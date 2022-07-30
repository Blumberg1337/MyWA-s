-- function to decide about which cd or aura (buff or debuff) info to show
-- this is basically the core logic for this wa to function properly
aura_env.compareTrinketTimes = function()
  -- general trinkets information
  aura_env.trinket_1_Id = GetInventoryItemID("player", 13)
  aura_env.trinket_1_spellId = select(2, GetItemSpell(aura_env.trinket_1_Id))
  aura_env.trinket_1_spellName = select(1, GetItemSpell(aura_env.trinket_1_Id))
  aura_env.trinket_1_usable = select(1, IsUsableItem(aura_env.trinket_1_Id))

  aura_env.trinket_2_Id = GetInventoryItemID("player", 14)
  aura_env.trinket_2_spellId = select(2, GetItemSpell(aura_env.trinket_2_Id))
  aura_env.trinket_2_spellName = select(1, GetItemSpell(aura_env.trinket_2_Id))
  aura_env.trinket_2_usable = select(1, IsUsableItem(aura_env.trinket_2_Id))

  local duration_1, end_1, duration_2, end_2

  -- we want to check for the trinkets aura uptimes first
  duration_1, duration_2, end_1, end_2 = aura_env.getTrinketAurasTime()

  -- if we didn't find any trinket aura, we check for the trinkets cds
  if (end_1 == -1 and end_2 == -1) then
    duration_1, duration_2, end_1, end_2 = aura_env.getTrinketCds()
    -- set toggles for cd ready event of a trinket
    aura_env.cdReady_1 = false
    aura_env.cdReady_2 = false

    -- set toggle for overwriting possibilities to false (= we can overwrite again) for new trinket cooldowns cycle
    aura_env.overwroteExpirationTime = false

    -- if a trinket is off cd its expirationTime (end_n) is 0 and we toggle the referring aura_env variables
    if (end_1 == 0 or end_2 == 0) then
      aura_env.cdReady_1 = end_1 == 0
      aura_env.cdReady_2 = end_2 == 0
      aura_env.glowing(false)
    end

    -- to show trinket cooldowns shortly before expiring, we swap the expirationTimes
    -- we only want to do this for the last x seconds (default = 5s) of this trinket's cd
    -- in the end we overwrote the expirationTime (= end_n) manually here
    -- therefore we set the aura_env variable to true accourdingly (performance feature)
    -- we have to put this part of the wa here due to the wanding workaround mentioned above
    -- (there are other ways where to put this part, but this seems optimal)
    if (aura_env.config.lastSecondsToggle) then
      local currentTime = GetTime()
      local lastSeconds_1 = end_1 - currentTime
      local lastSeconds_2 = end_2 - currentTime
      -- lastSeconds_n can be negative (end_n == 0) if a trinket is off cd, but we want to overwrite its cd anyway
      -- we can run into an infinite recursion when both trinkets are off cd shortly after another here (within lastSeconds)
      -- to ensure that this doesn't happen, we enable the cancel condition for cdReady if the other trinket is off cd
      if (lastSeconds_1 < lastSeconds_2 or end_2 == 0) then
        if (lastSeconds_1 <= aura_env.config.lastSeconds and lastSeconds_1 > 0) then
          end_2 = end_1 + 1
          aura_env.overwroteExpirationTime = true
          aura_env.glowing(true, aura_env.config.glowBuffsOnly)
        end
      end
      if (lastSeconds_2 <= lastSeconds_1 or end_1 == 0) then
        if (lastSeconds_2 <= aura_env.config.lastSeconds and lastSeconds_2 > 0) then
          end_1 = end_2 + 1
          aura_env.overwroteExpirationTime = true
          aura_env.glowing(true, aura_env.config.glowBuffsOnly)
        end
      end
      if (lastSeconds_1 > 5 and lastSeconds_2 > 5) then
        aura_env.glowing(false)
      end
    end
  end

  -- we want to show the trinket with the lower remaining aura uptime or cooldown here
  -- we send a new event the wa listens for to ensure that the states of the weakaura doesn't get manipulated
  if (end_1 < end_2) then
    aura_env.duration = duration_1 or 0
    aura_env.expirationTime = end_1 or 0
    aura_env.icon = aura_env.trinket_1_usable and GetItemIcon(aura_env.trinket_1_Id)
    WeakAuras.ScanEvents("TRINKET_TIMERS_INITIALIZED")
  else
    aura_env.duration = duration_2 or 0
    aura_env.expirationTime = end_2 or 0
    if (aura_env.trinket_2_usable) then
      aura_env.icon = GetItemIcon(aura_env.trinket_2_Id)
    elseif (aura_env.trinket_1_usable) then
      aura_env.icon = GetItemIcon(aura_env.trinket_1_Id)
    else
      aura_env.icon = GetItemIcon(aura_env.trinket_2_Id)
    end
    WeakAuras.ScanEvents("TRINKET_TIMERS_INITIALIZED")
  end
end

-- function to present information about the active aura for either trinket with the shorter remaining uptime
aura_env.getTrinketAurasTime = function()
  local end_1, end_2
  -- we check for the aura by its name from GetItemSpell(itemId)
  local aura_1 = AuraUtil.FindAuraByName(aura_env.trinket_1_spellName, "player")
  local aura_2 = AuraUtil.FindAuraByName(aura_env.trinket_2_spellName, "player")

  -- set toggle for activeTrinket and glow and send glow event when there is at least one active trinket aura to true
  if (aura_1 or aura_2) then
    aura_env.activeTrinket = true
    aura_env.glowing(true)
  end

  -- if we found an aura from the use of either trinket get its duration, otherwise set it to 0
  local duration_1 = select(5, AuraUtil.FindAuraByName(aura_env.trinket_1_spellName, "player")) or 0
  local duration_2 = select(5, AuraUtil.FindAuraByName(aura_env.trinket_2_spellName, "player")) or 0

  -- here, we decide which expirationTime to choose for end_1 and end_2 representing their expirationTime(s)
  -- 1. we found the aura and choose its expirationTime
  -- 2. we found the other trinkets aura and have to set this trinkets aura expirationTime to a value higher then the other
  -- 3. we found neither aura
  end_1 =
    select(6, AuraUtil.FindAuraByName(aura_env.trinket_1_spellName, "player")) or
    (AuraUtil.FindAuraByName(aura_env.trinket_2_spellName, "player") and
      select(6, AuraUtil.FindAuraByName(aura_env.trinket_2_spellName, "player")) + 1) or
    -1

  end_2 =
    select(6, AuraUtil.FindAuraByName(aura_env.trinket_2_spellName, "player")) or
    (AuraUtil.FindAuraByName(aura_env.trinket_1_spellName, "player") and
      select(6, AuraUtil.FindAuraByName(aura_env.trinket_1_spellName, "player")) + 1) or
    -1

  return duration_1, duration_2, end_1, end_2
end

-- function to present information about the cooldown of either trinket with the shorter remaining uptime
aura_env.getTrinketCds = function()
  local start_1, duration_1, end_1, start_2, duration_2, end_2

  -- set toggle for activeTrinket when there are no active trinket auras to false
  aura_env.activeTrinket = false

  -- if we have a trinket equipped in INVSLOT_TRINKET1 (slotId: 13) and if it's usable we get its startTime, otherwise -1
  -- same goes for duration, but returning 0 instead of -1 if no trinket equipped in INVSLOT_TRINKET1 (slotId: 13)
  start_1 =
    aura_env.trinket_1_Id and aura_env.trinket_1_usable and select(1, GetItemCooldown(aura_env.trinket_1_Id)) or -1
  duration_1 = aura_env.trinket_1_Id and select(2, GetItemCooldown(aura_env.trinket_1_Id)) or 0

  -- same as above for INVSLOT_TRINKET2 (slotId: 14)
  start_2 =
    aura_env.trinket_2_Id and aura_env.trinket_2_usable and select(1, GetItemCooldown(aura_env.trinket_2_Id)) or -1
  duration_2 = aura_env.trinket_2_Id and select(2, GetItemCooldown(aura_env.trinket_2_Id)) or 0

  -- we either set the trinkets expirationTime (end_n) via calculating start + duration,
  -- or calculate the other trinkets expirationTime and add 1 to ensure a higher expirationTime for this trinket
  end_1 = start_1 >= 0 and start_1 + duration_1 or start_2 + duration_2 + 1
  end_2 = start_2 >= 0 and start_2 + duration_2 or start_1 + duration_1 + 1

  -- we do some checks here for wanding, what sets EVERYTHING on cd equal to its attack speed
  local wand = HasWandEquipped()
  local wandSpeed = wand and select(1, UnitRangedDamage("player"))

  -- now we set end_n to 0 if duration_n is the same as the determined attack speed of our wand
  -- this way we ignore the wand cd on a trinket or even both trinkets
  -- (using a wand sets EVERYTHING else on cd for the duration of the players ranged attack speed...)
  if (wand and duration_1 == math.floor((wandSpeed * 1000 + 0.5)) / 1000) then
    end_1 = 0
  end
  if (wand and duration_2 == math.floor((wandSpeed * 1000 + 0.5)) / 1000) then
    end_2 = 0
  end

  -- it appears to happen that the end_n time isn't 0 seconds when listening for a condition tracking a cd ready event
  -- we avoid this behavior to a limit of a second here, e.g. to ensure glowing effects to be handled correctly
  if ((end_1 - GetTime()) <= 1) then
    end_1 = 0
  end
  if ((end_2 - GetTime()) <= 1) then
    end_2 = 0
  end

  return duration_1, duration_2, end_1, end_2
end

aura_env.glowing = function(glow, restricted)
  if (aura_env.config.glow and not restricted) then
    aura_env.glow = glow == true
    WeakAuras.ScanEvents("TRINKET_TIMERS_GLOW")
  end
end
