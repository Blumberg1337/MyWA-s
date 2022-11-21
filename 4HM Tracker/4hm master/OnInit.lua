-- Name:                NpcId       MarkSpellId
-- Sir Zeliek:          16063       28835
-- Lady Blaumeux:       16065       28833
-- Thane Korth'azz:     16064       28832
-- Baron Rivendare:     30549       28834

aura_env.zStacks = aura_env.zStacks or 0
aura_env.mStacks = aura_env.mStacks or 0
aura_env.tStacks = aura_env.tStacks or 0
aura_env.bStacks = aura_env.bStacks or 0

aura_env.counter = aura_env.counter or 0

aura_env.nextRun = nil
aura_env.throttle = 3

aura_env.findBoss = function(givenNpcId)
    for i = 1,GetNumGroupMembers() do
        local target = "raid"..i.."target"
        local unitGUID = UnitGUID(target)
        local npcId = select(6,strsplit("-",unitGUID))
    
        if npcId == givenNpcId then
            return UnitHealth(target), UnitHealthMax(target), target.."target"
        end
    end
end

-- Mograine is replaced by Baron Rivendare in Wotlk Classic, but I didn't bother editing the old function and custom event names
aura_env.mograineUpdate = function()
    --print("mogUpdate")
    local tank = nil
    local health, healthMax, tank = aura_env.findBoss("30549")
    WeakAuras.ScanEvents("MOG_UPDATE", health, healthMax, tank) 
    if tank ~= nil then
        for i=1,10 do
            local aura = UnitAura(tank, i, "HARMFUL")
            local spellId = select(10, aura)
            local stacks = select(3, aura)
            if spellId == 28834 then
                aura_env.mStacks = stacks
            end
        end
        WeakAuras.ScanEvents("MOG_TANK", aura_env.mStacks, tank)
        aura_env.mStacks = 0
    end
end

aura_env.thaneUpdate = function()
    --print("thaneUpdate")
    local tank = nil
    local health, healthMax, tank = aura_env.findBoss("16064")
    WeakAuras.ScanEvents("THANE_UPDATE", health, healthMax, tank) 
    if tank ~= nil then
        for i=1,10 do
            local aura = UnitAura(tank, i, "HARMFUL")
            local spellId = select(10, aura)
            local stacks = select(3, aura)
            if spellId == 28832 then
                aura_env.tStacks = stacks
            end
        end
        WeakAuras.ScanEvents("THANE_TANK", aura_env.tStacks, tank)
        aura_env.tStacks = 0
    end
end

aura_env.blaumUpdate = function()
    --print("blaumUpdate")
    local tank = nil
    local health, healthMax, tank = aura_env.findBoss("16065")
    WeakAuras.ScanEvents("BLAUM_UPDATE", health, healthMax, tank) 
    if tank ~= nil then
        for i=1,10 do
            local aura = UnitAura(tank, i, "HARMFUL")
            local spellId = select(10, aura)
            local stacks = select(3, aura)
            if spellId == 28833 then
                aura_env.bStacks = stacks
            end
        end
        WeakAuras.ScanEvents("BLAUM_TANK", aura_env.bStacks, tank)
        aura_env.bStacks = 0
    end
end

aura_env.zeliUpdate = function()
    local tank = nil
    local health, healthMax, tank = aura_env.findBoss("16063")
    WeakAuras.ScanEvents("ZELI_UPDATE", health, healthMax, tank) 
    if tank ~= nil then
        for i=1,10 do
            local aura = UnitAura(tank, i, "HARMFUL")
            local spellId = select(10, aura)
            local stacks = select(3, aura)
            if spellId == 28835 then
                aura_env.zStacks = stacks
            end
        end
        WeakAuras.ScanEvents("ZELI_TANK", aura_env.zStacks, tank)
        aura_env.zStacks = 0
    end
    aura_env.zTank = tank
end


aura_env.recursive = function()
    if aura_env.encounterDone ~= true then
        aura_env.mograineUpdate()
        aura_env.thaneUpdate()
        aura_env.blaumUpdate()
        aura_env.zeliUpdate()
        C_Timer.After(3, aura_env.recursive)
    end
end
