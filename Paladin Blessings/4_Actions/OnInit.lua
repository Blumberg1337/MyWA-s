-- This is a "PaladinBlessingsPrio"-WA to enable Blessing-WA's!

-- UnitClassBase: classID = classFilename
-- 1  = "WARRIOR"
-- 2  = "PALADIN"
-- 3  = "HUNTER"
-- 4  = "ROGUE"
-- 5  = "PRIEST"
-- 6  = "DEATHKNIGHT" - nil in Classic TBC
-- 7  = "SHAMAN"
-- 8  = "MAGE"
-- 9  = "WARLOCK"
-- 10 = "MONK"        - nil in Classic TBC
-- 11 = "DRUID"

-- aura_env.paladinBlessings = {
--   ["Kings"] = {20217, 25898},                                                                 -- (Greater) Blessing of Kings
--   ["Salvation"] = {1038, 25895},                                                              -- (Greater) Blessing of Salvation
--   ["Might"] = {19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140, 25782, 25916, 27141},  -- (Greater) Blessing of Might
--   ["Wisdom"] = {19742, 19850, 19852, 19853, 19854, 25290, 27142, 25894, 25918, 27143},        -- (Greater) Blessing of Wisdom
--   ["Light"] = {19977, 19978, 19979, 27144, 25890, 27145},                                     -- (Greater) Blessing of Light
--   ["Sanctuary"] = {20911, 20912, 20913, 20914, 27168, 25899, 27169},                          -- (Greater) Blessing of Sanctuary
-- }

aura_env.kingsSpellIds = {20217, 25898}
aura_env.sanctuarySpellIds = {27168, 27169}    -- {20911, 20912, 20913, 20914, 25899} other ranks (not important for GetSpellInfo())

-- We sadly cannot fetch values of custom options dropdown field arrays due to WeakAuras limitations...
-- So we have to double up the code here... https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Options#dropdown-menu
aura_env.playerBlessings = {
  "SALVATION",
  "KINGS",
  "MIGHT",
  "WISDOM",
  "LIGHT",
  "SANCTUARY",
  "none",
}

-- We sadly cannot fetch values of custom options dropdown field arrays due to WeakAuras limitations...
-- So we have to double up the code here... https://github.com/WeakAuras/WeakAuras2/wiki/Custom-Options#dropdown-menu
aura_env.petBlessings = {
  "MIGHT",
  "KINGS",
  "WISDOM",
  "SANCTUARY",
  "LIGHT",
  "SALVATION",
  "none",
}

-- Data Model
-- ["Class-SpecRole"] = {paladinBlessings}
aura_env.defaultBuffPriorities = {
  ["WARRIOR-MELEE"] = {"SALVATION", "MIGHT", "KINGS", "LIGHT", "SANCTUARY"},
  ["WARRIOR-TANK"] = {"KINGS", "MIGHT", "LIGHT", "SANCTUARY"},
  ["PALADIN-HEAL"] = {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"},
  ["PALADIN-TANK"] = {"KINGS", "SANCTUARY", "WISDOM", "LIGHT", "MIGHT"},
  ["PALADIN-MELEE"] = {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["HUNTER-BM"] = {"MIGHT", "KINGS", "SALVATION", "WISDOM", "LIGHT", "SANCTUARY"},
  ["HUNTER-SV"] = {"KINGS", "MIGHT", "SALVATION", "WISDOM", "LIGHT", "SANCTUARY"},
  ["ROGUE"] = {"SALVATION", "MIGHT", "KINGS", "LIGHT", "SANCTUARY"},
  ["PRIEST-HEAL"] = {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"},
  ["PRIEST-CASTER"] = {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["SHAMAN-CASTER"] = {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["SHAMAN-MELEE"] = {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["SHAMAN-HEAL"] = {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"},
  ["MAGE-ARCANE"] = {"WISDOM", "KINGS", "SALVATION", "LIGHT", "SANCTUARY"},
  ["MAGE-FIRE"] = {"SALVATION", "WISDOM", "KINGS", "LIGHT", "SANCTUARY"},
  ["MAGE-FROST"] = {"SALVATION", "WISDOM", "KINGS", "LIGHT", "SANCTUARY"},
  ["WARLOCK"] = {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["DRUID-CASTER"] = {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["DRUID-TANK"] = {"KINGS", "MIGHT", "LIGHT", "SANCTUARY", "WISDOM"},
  ["DRUID-MELEE"] = {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"},
  ["DRUID-HEAL"] = {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"},
  ["PET"] = {"MIGHT", "KINGS", "WISDOM", "SANCTUARY", "LIGHT", "SALVATION"},
}

-- Data Model
-- ["Class-SpecRole"] = {classFileName, talentTreeNumber, talentNumber}
aura_env.specRoleData = {
  ["WARRIOR-MELEE"] = {"WARRIOR", 2, 13 --[[Sweeping Strikes]]},
  ["WARRIOR-TANK"] = {"WARRIOR", 3, 19 --[[Shield Slam]]},
  ["PALADIN-HEAL"] = {"PALADIN", 1, 17 --[[Holy Shock]]},
  ["PALADIN-MELEE"] = {"PALADIN", 3, 22 --[[Crusader Strike]]},
  ["PALADIN-TANK"] = {"PALADIN", 2, 19 --[[Holy Shield]]},
  ["HUNTER-BM"] = {"HUNTER", 1, 21 --[[The Beast Within]]},
  ["HUNTER-SV"] = {"HUNTER", 3, 21 --[[Expose Weakness]]},
  ["ROGUE"] = {"ROGUE"},
  ["PRIEST-CASTER"] = {"PRIEST", 3, 19 --[[Shadowform]]},
  ["PRIEST-HEAL"] = {"PRIEST", 2, 3 --[[Holy Specialization]]},
  ["SHAMAN-CASTER"] = {"SHAMAN", 1, 17 --[[Elemental Mastery]]},
  ["SHAMAN-HEAL"] = {"SHAMAN", 3, 20 --[[Earth Shield]]},
  ["SHAMAN-MELEE"] = {"SHAMAN", 2, 18 --[[Dual Wield]]},
  ["MAGE-ARCANE"] = {"MAGE", 1, 22 --[[Mind Mastery]]},
  ["MAGE-FIRE"] = {"MAGE", 2, 19 --[[Combustion]]},
  ["MAGE-FROST"] = {"MAGE", 3, 20 --[[Winter's Chill]]},
  ["WARLOCK"] = {"WARLOCK"},
  ["DRUID-CASTER"] = {"DRUID", 1, 18 --[[Moonkin Form]]},
  ["DRUID-HEAL"] = {"DRUID", 3, 14 --[[Empowered Touch]]},
  ["DRUID-MELEE"] = {"DRUID", 2, 21 --[[Mangle]]},
  ["DRUID-TANK"] = {"DRUID", 2, 21 --[[Mangle]]},
}

-- (Greater) Blessing of Sanctuary is only available if the related talent is taken by a paladin in your group.
-- Because of that, we track for other raid members having these buffs first to ensure availability.
aura_env.sanctuaryAvailability = function()
  for unit in WA_IterateGroupMembers() do
    for i = 1, #aura_env.sanctuarySpellIds do
      local name = GetSpellInfo(aura_env.sanctuarySpellIds[i])
      if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
        return true
      end
    end
  end
  return false
end

-- (Greater) Blessing of Kings is only available if the related talent is taken by a paladin in your group.
-- Because of that, we track for other raid members having these buffs first to ensure availability.
aura_env.kingsAvailability = function()
  for unit in WA_IterateGroupMembers() do
    for i = 1, #aura_env.kingsSpellIds do
      local name = GetSpellInfo(aura_env.kingsSpellIds[i])
      if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
        return true
      end
    end
  end
  return false
end

-- In the rare case of having only a protection paladin able to buff Blessing of Sanctuary OR Blessing of Kings,
-- we need this function, because it is impossible for a single paladin to buff another player with both buffs.
-- This function validates that there is one paladin buffing Blessing of Sanctuary AND another one buffing Blessing of Kings.
aura_env.sanctuaryAndKingsAvailability = function()
  local sanctuary = false
  local kings = false
  for unit in WA_IterateGroupMembers() do
    for i = 1, #aura_env.sanctuarySpellIds do
      local name = GetSpellInfo(aura_env.sanctuarySpellIds[i])
      if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
        sanctuary = true
      end
    end
    for i = 1, #aura_env.kingsSpellIds do
      local name = GetSpellInfo(aura_env.kingsSpellIds[i])
      if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
        kings = true
      end
    end
  end
  return sanctuary and kings
end

-- Count paladins in raid / group.
aura_env.countPaladinsInRaidGroup = function()
  aura_env.paladinCount = 0
  
  for unit in WA_IterateGroupMembers() do
    local classFilename = UnitClassBase(unit)
    if (classFilename == "PALADIN" and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit)) then
      aura_env.paladinCount = aura_env.paladinCount + 1
    end
  end
end

aura_env.sendPaladinBlessingEvents = function()
  aura_env.countPaladinsInRaidGroup()
  
  local classFilename = UnitClassBase("player")
  local hasPet = HasPetUI()
  local customEventName = "PALADIN_BLESSING_PRIORITY_"
  local playerSpecRole = nil
  local playerBlessingPriority = {}
  local petBlessingPriority = {}
  
  -- Find player spec.
  for specRole, data in pairs(aura_env.specRoleData) do
    if (data[1] == classFilename) then
      if (data[2] and data[3]) then
        local _, _, _, _, rank = GetTalentInfo(data[2], data[3])
        if (rank > 0) then
          -- Druid Tank and Druid Melee set same talent points. Therefore we check for crit immunity here.
          if (data[1] == "DRUID") then
            playerSpecRole = aura_env.evaluateRoleByCritImmunity()
          else
            playerSpecRole = specRole
          end
        end
        -- Rogues have no specs that differ in blessing priorities. So they don't have any talent information.
      elseif (not data[2] and not data[3]) then
        playerSpecRole = specRole
      end
    end
  end
  
  -- Find and copy the player's blessing priority
  if (playerSpecRole) then
    local buffPriority = aura_env.defaultBuffPriorities[playerSpecRole]
    if (aura_env.config.overwriteBlessings) then
      buffPriority = {
        aura_env.playerBlessings[aura_env.config.blessing1],
        aura_env.playerBlessings[aura_env.config.blessing2],
        aura_env.playerBlessings[aura_env.config.blessing3],
        aura_env.playerBlessings[aura_env.config.blessing4],
        aura_env.playerBlessings[aura_env.config.blessing5],
        aura_env.playerBlessings[aura_env.config.blessing6],
      }
    end
    playerBlessingPriority = aura_env.filterBlessings(buffPriority)
  end
  
  -- Find and copy the player's pet blessing priority
  if (hasPet) then
    local petBuffPriority = aura_env.defaultBuffPriorities["PET"]
    if (aura_env.config.overwritePetBlessings) then
      petBuffPriority = {
        aura_env.petBlessings[aura_env.config.blessingPet1],
        aura_env.petBlessings[aura_env.config.blessingPet2],
        aura_env.petBlessings[aura_env.config.blessingPet3],
        aura_env.petBlessings[aura_env.config.blessingPet4],
        aura_env.petBlessings[aura_env.config.blessingPet5],
        aura_env.petBlessings[aura_env.config.blessingPet6],
      }
    end
    petBlessingPriority = aura_env.filterBlessings(petBuffPriority)
  end
  
  -- Send custom events to check for available paladin blessing for the player.
  if (#playerBlessingPriority > 0) then
    for i=1, math.min(#playerBlessingPriority, aura_env.paladinCount) do
      WeakAuras.ScanEvents(customEventName..playerBlessingPriority[i])
    end
  end

  -- Send custom events to check for available paladin blessing for the player's pet.
  if (#petBlessingPriority > 0) then
    for i=1, #petBlessingPriority do
      WeakAuras.ScanEvents(customEventName.."PET_"..petBlessingPriority[i])
    end
  end
end

aura_env.filterBlessings = function(buffPriority)
  local sanctuaryAndKingsAvailability = aura_env.sanctuaryAndKingsAvailability()
  local sanctuaryAvailability = aura_env.sanctuaryAvailability()
  local kingsAvailability = aura_env.kingsAvailability()
  local blessingPriority = {}

  for i = 1, #buffPriority do
    if (sanctuaryAndKingsAvailability) then
      blessingPriority[i] = buffPriority[i]
    -- Filter (Greater) Blessing of Sanctuary if not available.
    elseif (buffPriority[i] == "SANCTUARY" and not sanctuaryAvailability) then
      blessingPriority[i] = aura_env.nextValidBlessing()
    -- Filter (Greater) Blessing of Kings if not available.
    elseif (buffPriority[i] == "KINGS" and not kingsAvailability) then
      blessingPriority[i] = aura_env.nextValidBlessing()
    -- Filter overwritten "none" priority.
    elseif (buffPriority[i] == "none") then
      blessingPriority[i] = aura_env.nextValidBlessing()
    else
      blessingPriority[i] = buffPriority[i]
    end
  end

  -- filter doubles
  return blessingPriority
end

aura_env.nextValidBlessing = function(current, buffPriority, kingsAvailability, sanctuaryAvailability)
  for i = current + 1, #buffPriority do
    -- Avoid index out of bounds error.
    if (buffPriority[i] and
        buffPriority[i] ~= "none" and
        (buffPriority[i] ~= "KINGS" or kingsAvailability) and
        (buffPriority[i] ~= "SANCTUARY" or sanctuaryAvailability)) then
      return buffPriority[i]
    end
  end
end

-- Druid Tank and Druid Melee set same talent points. Therefore we check for crit immunity here.
aura_env.evaluateRoleByCritImmunity = function ()
  local defenseRating = GetCombatRating(CR_DEFENSE_SKILL)
  local resilience = GetCombatRating(COMBAT_RATING_RESILIENCE_CRIT_TAKEN)

  local critImmunityPercentage = defenseRating / 59.135 + resilience / 39.4
  if (critImmunityPercentage >= 2.6) then
    return "DRUID-TANK"
  end
  return "DRUID-MELEE"
end

-- filter nil(maybe not necessary -> no valid next blessing = end of array)
-- filter double values
-- check if player connected 162
-- Send custom event when buffs are about to run out (customizable in seconds! 10s - 9min/540s -> in receiving wa).
-- 232, 239, 246 needed? (avoid index out of bound error condition)
