-- trigger data (copy text inside of quotes)
type = "Custom"
eventType = "Event"
events = "CLEU:SPELL_CAST_SUCCESS"

customTrigger = function(e,...)
    -- local source = select(5,...)
    -- local name = select(13,...)
    local spellId = select(12,...)
    -- either blaumeux or zeliek should die last, so we check for their marks
    if spellId == 28835 and aura_env.zTank then
        aura_env.counter = aura_env.counter + 1
        WeakAuras.ScanEvents("4HM_MARK_CAST", aura_env.counter, 14.9)
    elseif spellId == 28833 then
        aura_env.counter = aura_env.counter + 1
        WeakAuras.ScanEvents("4HM_MARK_CAST", aura_env.counter, 14.9)
    -- elseif name == "Schildwall" then
    --     if source == "Thane Korth'azz" then
    --         WeakAuras.ScanEvents("4HM_WALL_THANE")
    --     elseif source == "Hochlord Mograine" then
    --         WeakAuras.ScanEvents("4HM_WALL_MOG")
    --     elseif source == "Lady Blaumeux" then
    --         WeakAuras.ScanEvents("4HM_WALL_BLAUM")
    --     elseif source == "Sire Zeliek" then
    --         WeakAuras.ScanEvents("4HM_WALL_ZEL")
    --     end
    end
end
  

hide = "Timed"

dynamicDuration = false

duration = 0.1
