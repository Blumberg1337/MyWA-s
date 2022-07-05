-- UnitResistance: resistanceIndex
-- 0 = Armor
-- 1 = Holy (no resistance possible)
-- 2 = Fire
-- 3 = Nature
-- 4 = Frost
-- 5 = Shadow
-- 6 = Arcane

-- stackIndex
-- Player-cast buffs do not stack.
-- They also do not stack with potions, but with self-applied buffs (Mage Armor, Ice Armor) and elixir(s)/flask(s).
-- 1 = player-cast buffs, potions
-- 2 = self-applied buffs
-- 3 = elixir(s), flask(s)

-- Data Model
-- [SpellId] = {resistanceValue, resistanceIndexes, stackIndex, modifiable}
aura_env.resistanceBuffs = {
  -- Minor Magic Resistance Potion
  [2380] = {25, {2, 3, 4, 5, 6}, 1, false},
  -- Magic Resistance Potion
  [11364] = {50, {2, 3, 4, 5, 6}, 1, false},
  -- Juju Ember
  [16326] = {15, {2}, 3, false},
  -- Juju Chill
  [16325] = {15, {4}, 3, false},
  -- Flask of Chromatic Wonder
  [42735] = {35, {2, 3, 4, 5, 6}, 3, false},
  -- Flask of Chromatic Resistance
  [42735] = {25, {2, 3, 4, 5, 6}, 3, false},
  -- Ice Armor (Mage only)
  [7302] = {6, {4}, 2, true},
  [7320] = {9, {4}, 2, true},
  [10219] = {12, {4}, 2, true},
  [10220] = {15, {4}, 2, true},
  [27124] = {18, {4}, 2, true},
  -- Mage Armor (Mage only)
  [6117] = {5, {2, 3, 4, 5, 6}, 2, false},
  [22782] = {10, {2, 3, 4, 5, 6}, 2, false},
  [22783] = {15, {2, 3, 4, 5, 6}, 2, false},
  [27125] = {18, {2, 3, 4, 5, 6}, 2, false},
  -- Shadow Protection
  [976] = {30, {5}, 1, false},
  [10957] = {45, {5}, 1, false},
  [10958] = {60, {5}, 1, false},
  [25433] = {70, {5}, 1, false},
  -- Prayer of Shadow Protection
  [27683] = {60, {5}, 1, false},
  [39374] = {70, {5}, 1, false},
  --
  -- For MotW/GotW we just take the maximum possible values (round down from resistanceValue * 1,35). 
  -- We do so, because we can't track on other players for improved MotW/GotW then the druid buffing.
  -- In the end, we have to ignore any MotW/GotW modifiers (modifiable = false).
  --
  -- Mark of the Wild
  [5234] = {6, {2, 3, 4, 5, 6}, 1, false},
  [8907] = {13, {2, 3, 4, 5, 6}, 1, false},
  [9884] = {20, {2, 3, 4, 5, 6}, 1, false},
  [9885] = {27, {2, 3, 4, 5, 6}, 1, false},
  [26990] = {33, {2, 3, 4, 5, 6}, 1, false},
  -- Gift of the Wild
  [21849] = {20, {2, 3, 4, 5, 6}, 1, false},
  [21850] = {27, {2, 3, 4, 5, 6}, 1, false},
  [26991] = {33, {2, 3, 4, 5, 6}, 1, false},
  --
  -- Aspect of the Wild
  [20043] = {45, {3}, 1, false},
  [20190] = {60, {3}, 1, false},
  [27045] = {70, {3}, 1, false},
  -- Fire Resistance Totem
  [8185] = {30, {2}, 1, false},
  [10534] = {45, {2}, 1, false},
  [10535] = {60, {2}, 1, false},
  [25559] = {70, {2}, 1, false},
  -- Frost Resistance Totem
  [8182] = {30, {4}, 1, false},
  [10476] = {45, {4}, 1, false},
  [10477] = {60, {4}, 1, false},
  [25562] = {70, {4}, 1, false},
  -- Nature Resistance Totem
  [10596] = {30, {3}, 1, false},
  [10598] = {45, {3}, 1, false},
  [10599] = {60, {3}, 1, false},
  [25573] = {70, {3}, 1, false},
  -- Fire Resistance Aura
  [19891] = {30, {2}, 1, false},
  [19899] = {45, {2}, 1, false},
  [19900] = {60, {2}, 1, false},
  [27153] = {70, {2}, 1, false},
  -- Frost Resistance Aura
  [19888] = {30, {4}, 1, false},
  [19897] = {45, {4}, 1, false},
  [19898] = {60, {4}, 1, false},
  [27152] = {70, {4}, 1, false},
  -- Shadow Resistance Aura
  [19876] = {30, {5}, 1, false},
  [19895] = {45, {5}, 1, false},
  [19896] = {60, {5}, 1, false},
  [27151] = {70, {5}, 1, false},
}

-- There are two modifiers for resistance buffs. For MotW/GotW and Ice Armor.
-- We can easily track Ice Armor modifier as it is self-applied only.
-- Sadly, we can't track MotW/GotW modifiers for buffed characters other then the buffing character.
aura_env.frostWarding = function()
  -- Get talent points for "Frost Warding"
  name, _, _, _, rank = GetTalentInfo(3, 1)
  if name == "Frost Warding" then
    if rank == 1 then return 1,15
    elseif rank == 2 then return 1,3
    else return 1 end
  else
    return
  end
end

-- Sum up all resistances from buffs and test if those values match the players bonus resistance values. --
aura_env.resistanceBuffsValue = function()
  -- Save all active resistance buffs. --
  local activeResistanceBuffs = {}
  for spellId, value in pairs(aura_env.resistanceBuffs) do
    local name = GetSpellInfo(spellId)
    if (AuraUtil.FindAuraByName(name, "player") ~= nil) then
      activeResistanceBuffs[spellId] = value
      -- Frost Warding with Ice Armor logic:
      if (spellId == 7302 or spellId == 7320 or spellId == 10219 or spellId == 10220 or spellId == 27124) then
        activeResistanceBuffs[spellId][1] = activeResistanceBuffs[spellId][1] * aura_env.frostWarding();
      end
    end
  end

  -- Find maximum bonus resistance values per stackIndex. --
  -- "armor" and "holy" cannot get resisted.
  local maximumValuesFound = {
    { 
      0,  -- fire
      0,  -- nature
      0,  -- frost
      0,  -- shadow
      0,  -- arcane
    },
    { 
      0,  -- fire
      0,  -- nature
      0,  -- frost
      0,  -- shadow
      0,  -- arcane
    },
    {
      0,  -- fire
      0,  -- nature
      0,  -- frost
      0,  -- shadow
      0,  -- arcane
    },
  }

  for spellId, value in pairs(activeResistanceBuffs) do
    for i=1, #maximumValuesFound do
      if (i == value[3]) then
        for k=1, #value[2] do
          -- value[1] = resistanceValue
          -- value[2][k] = resistanceIndex in aura_env.resistanceBuffs
          -- value[2][k] - 1 = resistanceIndex in maximalValuesFound (iteration starts from "fire" = 1, but resistanceIndex "fire" = 2)
          if (maximumValuesFound[i][value[2][k]-1] < value[1]) then
            maximumValuesFound[i][value[2][k]-1] = value[1]
          end
        end
      end
    end
  end

  -- Sum up resistances and calculate bonus resistance values. --
  local resistanceTypeValues = {
    0,  -- fire
    0,  -- nature
    0,  -- frost
    0,  -- shadow
    0,  -- arcane
  }

  for i=1, #maximumValuesFound do
    for k=1, #maximalValuesFound[i] do
      resistanceTypeValues[k] = resistanceTypeValues[k] + maximumValuesFound[i][k]
    end
  end

  local resistanceIndex
  for i=1, #resistanceTypeValues do
    -- i+1 = resistanceIndex starting with 2 -> "fire", etc.
    local _, _, bonus = UnitResistance("player", i+1)
    if (bonus - resistanceTypeValues[i] > 0) then
      resistanceTypeValues[i] = bonus - resistanceTypeValues[i]
    end
    if (i == 1 and resistanceTypeValues[i] > 0) then
      resistanceIndex = i
    elseif (i > 1 and resistanceTypeValues[i] > 0 and resistanceTypeValues[i] >= resistanceTypeValues[i-1]) then
      resistanceIndex = i
    end
  end

  if (resistanceIndex > 0) then
    aura_env.resistanceNameAndIcon(resistanceIndex)
    return true
  end

  return false
end


aura_env.resistanceNameAndIcon = function(index)
  -- Data Model: {resistanceName, resistanceIconId}
  local resistanceInfo = {{"FR", 135805}, {"NR", 136074}, {"FR", 135849}, {"SR", 136121}, {"AR", 136222}}
  aura_env.resistanceName = resistanceInfo[index][1]
  aura_env.resistanceIconId = resistanceInfo[index][2]
end
