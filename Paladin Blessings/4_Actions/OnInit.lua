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
--   ["Sanctuary"] = {20911, 20912, 20913, 20914, 27168, 25899, 27169},                          -- (Greater) Blessing of Wisdom
-- }

aura_env.kingsSpellIds = {20217, 25898}
aura_env.sanctuarySpellIds = {27168, 27169, 20911, 20912, 20913, 20914, 25899}

-- Data Model
-- {Class-SpecRole, {paladinBlessings}, classFileName, talentTreeNumber, talentNumber}
aura_env.defaultBuffPriorities = {
  {"WARRIOR-MELEE", {"SALVATION", "MIGHT", "KINGS", "LIGHT", "SANCTUARY"}, "WARRIOR", 2, 13 --[[Sweeping Strikes]]},
  {"WARRIOR-TANK", {"KINGS", "MIGHT", "LIGHT", "SANCTUARY"}, "WARRIOR", 3, 19 --[[Shield Slam]]},
  {"PALADIN-HEAL", {"KINGS", "Wisdom", "SALVATION", "LIGHT", "SANCTUARY"}, "PALADIN", 1, 17 --[[Holy Shock]]},
  {"PALADIN-TANK", {"KINGS", "SANCTUARY", "WISDOM", "LIGHT", "MIGHT"}, "PALADIN", 2, 19 --[[Holy Shield]]},
  {"PALADIN-MELEE", {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "PALADIN", 3, 22 --[[Crusader Strike]]},
  {"HUNTER-BM", {"MIGHT", "KINGS", "SALVATION", "WISDOM", "LIGHT", "SANCTUARY"}, "HUNTER", 1, 21 --[[The Beast Within]]},
  {"HUNTER-SV", {"KINGS", "MIGHT", "SALVATION", "WISDOM", "LIGHT", "SANCTUARY"}, "HUNTER", 3, 21 --[[Expose Weakness]]},
  {"ROGUE", {"SALVATION", "MIGHT", "KINGS", "LIGHT", "SANCTUARY"}, "ROGUE"},
  {"PRIEST-HEAL", {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"}, "PRIEST", 2, 3 --[[Holy Specialization]]},
  {"PRIEST-CASTER", {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "PRIEST", 3, 19 --[[Shadowform]]},
  {"SHAMAN-CASTER", {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "SHAMAN", 1, 17 --[[Elemental Mastery]]},
  {"SHAMAN-MELEE", {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "SHAMAN", 2, 18 --[[Dual Wield]]},
  {"SHAMAN-HEAL", {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"}, "SHAMAN", 3, 20 --[[Earth Shield]]},
  {"MAGE", {"WISDOM", "KINGS", "SALVATION", "LIGHT", "SANCTUARY"}, "MAGE"},
  {"WARLOCK", {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "WARLOCK"},
  {"DRUID-CASTER", {"SALVATION", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "DRUID", 1, 18 --[[Moonkin Form]]},
  {"DRUID-TANK", {"KINGS", "MIGHT", "LIGHT", "SANCTUARY", "WISDOM"}, "DRUID", 2, 21 --[[Mangle]]},
  {"DRUID-MELEE", {"SALVATION", "MIGHT", "KINGS", "WISDOM", "LIGHT", "SANCTUARY"}, "DRUID", 2, 21 --[[Mangle]]},
  {"DRUID-HEAL", {"KINGS", "WISDOM", "SALVATION", "LIGHT", "SANCTUARY"}, "DRUID", 3, 14 --[[Empowered Touch]]},
  {"PET", {"MIGHT", "KINGS", "SANCTUARY", "LIGHT", "SALVATION"}},
}

aura_env.iterateGroupMembersFor = function(reason)
  aura_env.paladinCount = 0
  for unit in WA_IterateGroupMembers() do
    -- (Greater) Blessing of Sanctuary is only available if a prot paladin is within your raid group. (Talent taken)
    -- Also (Greater) Blessing of Kings is only available if a talent is taken by a paladin in your group.
    -- Because of that, we track for other raid members having these buffs first to ensure availability.
    if (reason == "sanctuaryAvailability") then
      for spellId in aura_env.sanctuarySpellIds do
        local name = GetSpellInfo(spellId)
        if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
          return true
        end
      end
      return false
    end

    if (reason == "kingsAvailability") then
      for spellId in aura_env.kingsSpellIds do
        local name = GetSpellInfo(spellId)
        if (AuraUtil.FindAuraByName(name, unit) ~= nil) then
          return true
        end
      end
      return false
    end

    -- In the rare case of having only a protection paladin able to buff Blessing of Sanctuary OR Blessing of Kings,
    -- we need this function, because it is impossible for this single protection paladin to buff players with both buffs.
    -- This functions validates that there is one paladin buffing Blessing of Sanctuary AND another one buffing Blessing of Kings.
    if (reason == "sanctuaryAndKingsAvailability") then
      for spellIdSanctuary in aura_env.sanctuarySpellIds do
        for spellIdKings in aura_env.kingsSpellIds do
          local nameSanctuary = GetSpellInfo(spellIdSanctuary)
          local nameKings = GetSpellInfo(spellIdKings)
          if (AuraUtil.FindAuraByName(nameSanctuary, unit) ~= nil and
              AuraUtil.FindAuraByName(nameKings, unit) ~= nil) then
            return true
          end
        end
      end
      return false
    end

    -- Count paladins in raid group.
    if (reason == "paladinCount") then
      local classFilename = UnitClassBase(unit)
      if (classFilename == "PALADIN") then
        aura_env.paladinCount = aura_env.paladinCount + 1
      end
    end
  end
end

aura_env.sendPaladinBlessingEvents = function()
  aura_env.iterateGroupMembersFor("paladinCount")

  local sanctuaryAndKingsAvailability = aura_env.iterateGroupMembersFor("sanctuaryAndKingsAvailability")
  local sanctuaryAvailability = aura_env.iterateGroupMembersFor("sanctuaryAvailability")
  local kingsAvailability = aura_env.iterateGroupMembersFor("kingsAvailability")

  -- extract logic from here and make data map with ["HUNTER-SV"] = {classFileName: "HUNTER", GetTalentInfo(x:3,y:21) oder nur x und y}
  -- iterate over data map and see if classFileName matches, then do stuff
  -- commentate why availabilty-Workarounds are necessary
  local classFilename = UnitClassBase("player")
  local customEvent = "PALADIN_BLESSING_PRIORITY_"
  local sanctuaryPriority, kingsPriority = nil

  for i=1, #aura_env.defaultBuffPriorities do
    if (classFileName == aura_env.defaultBuffPriorities[i][3]) then
      local talentTreeNumber = aura_env.defaultBuffPriorities[i][4]
      local talentNumber = aura_env.defaultBuffPriorities[i][5]
      local _, _, _, _, rank = GetTalentInfo(talentTreeNumber, talentNumber)
      
      if (rank > 0) then
        for k=1, k <= aura_env.paladinCount do
          if (sanctuaryAndKingsAvailability) then
            if (aura_env.defaultBuffPriorities[i][2][k] == "SANCTUARY" or
                aura_env.defaultBuffPriorities[i][2][k] == "KINGS") then
              WeakAuras.ScanEvent(customEvent..aura_env.defaultBuffPriorities[i][2][k])
            end
          elseif (kingsAvailability or sanctuaryAvailability) then
            if (kingsAvailability and aura_env.defaultBuffPriorities[i][2][k] == "KINGS") then
              kingsPriority = i
              if (sanctuaryPriority and kingsPriority < sanctuaryPriority) then
                WeakAuras.ScanEvent(customEvent..aura_env.defaultBuffPriorities[i][2][k])
              end
            end
            if (sanctuaryAvailability and aura_env.defaultBuffPriorities[i][2][k] == "SANCTUARY") then
              sanctuaryPriority = i
              if (kingsPriority and sanctuaryPriority < kingsPriority) then
                WeakAuras.ScanEvent(customEvent..aura_env.defaultBuffPriorities[i][2][k])
              end
            end
          else
            WeakAuras.ScanEvent(customEvent..aura_env.defaultBuffPriorities[i][2][k])
          end  
        end
      end
    end
  end
end

-- Send custom event when buffs are about to run out (customizable in seconds!).
-- check druid tank spec via if def = crit immune
-- track fire elemental from shaman and more
