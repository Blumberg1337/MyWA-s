-- local gmatch, trim = string.gmatch, string.trim
-- local wipe = table.wipe

-- -- __waIconSkinTool is faux-global, if we are upgrading from a version with a true global, check for it, too.
-- local skinner = __waIconSkinTool or getglobal("IconSkinTool")
-- local E = _G.ElvUI and ElvUI[1]

-- if not skinner then
--     skinner = {
--         blacklist = {},
--         children = {},
--         backdrop = {},
--         cooldowns = {}
--     }
--     __waIconSkinTool = skinner
-- else
--     wipe(skinner.blacklist)
--     for token in gmatch(aura_env.config.exclusions, "[^,]+") do
--         token = trim(token)
--         skinner.blacklist[token] = true
--     end
-- end

-- skinner.borderColor = skinner.borderColor or {}
-- for i = 1, 4 do
--     skinner.borderColor[i] = aura_env.config.borderColor[i] or 0
-- end
-- skinner.borderWidth = aura_env.config.bWidth or 1
-- skinner.borderOffset = aura_env.config.borderOffset or 1
-- skinner.zoom = aura_env.config.zoom or 0.3
-- skinner.solid = aura_env.config.solid or false
-- skinner.elvCDs = aura_env.config.useElvCooldowns

-- -- Backdrop/Border Template
-- -- skinner.backdrop.bgFile   = nil
-- skinner.backdrop.bgFile = nil -- "interface\\buttons\\white8x8"
-- skinner.backdrop.edgeFile = "interface\\buttons\\white8x8"
-- skinner.backdrop.tileEdge = true
-- skinner.backdrop.edgeSize = skinner.borderWidth
-- -- skinner.backdrop.insets   = { left = skinner.borderInset, right = skinner.borderInset, top = skinner.borderInset, bottom = skinner.borderInset }
-- -- skinner.backdrop.backdropColor = { r = 0, g = 0, b = 1, a = 0 }
-- skinner.backdrop.insets = {left = 0, right = 0, top = 0, bottom = 0}

-- function skinner:ApplyElvCDs(region)
--     local cd = region.cooldown.CooldownSettings or {}
--     cd.font = E.Libs.LSM:Fetch("font", E.db.cooldown.fonts.font)
--     cd.fontSize = E.db.cooldown.fonts.fontSize
--     cd.fontOutline = E.db.cooldown.fonts.fontOutline

--     region.cooldown.CooldownSettings = cd
--     region.cooldown.hideText = region.cooldown.noCooldownCount

--     if not self.cooldowns[region] then
--         E:RegisterCooldown(region.cooldown)
--         self.cooldowns[region] = true
--     end
-- end

-- function skinner:InitTemplate(region)
--     local a = min(select(4, region.icon:GetVertexColor()), region.icon:GetAlpha())
--     if self.solid then
--         a = a > 0 and 1 or a
--     end

--     local bg = region.bgFrame or CreateFrame("Frame")
--     bg:ClearAllPoints()
--     bg:SetPoint("TOPLEFT", region, "TOPLEFT", -skinner.borderOffset, skinner.borderOffset)
--     bg:SetPoint("TOPRIGHT", region, "TOPRIGHT", skinner.borderOffset, skinner.borderOffset)
--     bg:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", -skinner.borderOffset, -skinner.borderOffset)
--     bg:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", skinner.borderOffset, -skinner.borderOffset)
--     bg:SetBackdrop(self.backdrop)

--     local r, g, b = unpack(self.borderColor)
--     bg:SetBackdropBorderColor(r, g, b, a)

--     bg:SetParent(region)
--     region.bgFrame = bg

--     -- Preserve actual zoom setting, but account for "Keep Aspect Ratio"
--     local realZoom = region.zoom

--     region.zoom = self.zoom
--     region:UpdateTexCoords()
--     region.zoom = realZoom

--     if E and self.elvCDs then
--         self:ApplyElvCDs(region)
--     end

--     self:HookIt(region)

--     region.isSkinned = true
-- end

-- function skinner:RefreshTemplate(region)
--     if self.SkinIsRefreshing then
--         return
--     end

--     if region.regionType == "icon" and region.icon and region.isSkinned then
--         self.SkinIsRefreshing = true

--         if self.blacklist[region.id] then
--             -- note, ElvUI cooldowns are not unregistered; their style will persist until reload until fixed.
--             region.bgFrame:SetBackdrop(nil)
--             region:UpdateSize()
--             region.isSkinned = nil
--         else
--             local bg = region.bgFrame
--             bg:ClearAllPoints()
--             bg:SetPoint("TOPLEFT", region, "TOPLEFT", -skinner.borderOffset, skinner.borderOffset)
--             bg:SetPoint("TOPRIGHT", region, "TOPRIGHT", skinner.borderOffset, skinner.borderOffset)
--             bg:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", -skinner.borderOffset, -skinner.borderOffset)
--             bg:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", skinner.borderOffset, -skinner.borderOffset)
--             bg:SetBackdrop(self.backdrop)

--             local a = min(select(4, region.icon:GetVertexColor()), region.icon:GetAlpha())
--             if self.solid then
--                 a = a > 0 and 1 or a
--             end

--             local r, g, b = unpack(self.borderColor)
--             region.bgFrame:SetBackdropBorderColor(r, g, b, a)

--             -- Preserve actual zoom setting, but account for "Keep Aspect Ratio"
--             local realZoom = region.zoom

--             region.zoom = self.zoom
--             region:UpdateTexCoords()
--             region.zoom = realZoom

--             if E and self.elvCDs then
--                 region.cooldown.hideText = region.cooldown.noCooldownCount
--             end
--         end

--         self.SkinIsRefreshing = nil
--     end
-- end

-- function skinner:ApplyTemplate(region, cloneId)
--     local r = WeakAuras.GetRegion(region, cloneId)

--     if r and r.regionType == "icon" then
--         if r.isSkinned then
--             self:RefreshTemplate(r)
--         elseif not skinner.blacklist[region] then
--             self:InitTemplate(r)
--         end
--     end
-- end

-- -- Our hook functions should refer to the skinner table, so that we can make changes without duplicating hooks.
-- function skinner:OnSetRegion(data, cloneId)
--     if not data or not data.id then
--         return
--     end
--     self:ApplyTemplate(data.id, cloneId)
-- end

-- if not skinner.SetRegionIsHooked then
--     hooksecurefunc(
--         WeakAuras,
--         "SetRegion",
--         function(...)
--             skinner:OnSetRegion(...)
--         end
--     )
--     skinner.SetRegionIsHooked = true
-- end

-- function skinner:HookIt(region)
--     if not self.children[region] then
--         local rt = function(...)
--             skinner:RefreshTemplate(...)
--         end

--         hooksecurefunc(region, "Color", rt)
--         hooksecurefunc(region, "SetAlpha", rt)
--         hooksecurefunc(region, "UpdateSize", rt)

--         hooksecurefunc(region.icon, "SetVertexColor", rt)

--         self.children[region] = true
--     end
-- end

-- local needsRefresh = true

-- function skinner:SkinAllIcons()
--     for aura, clones in pairs(WeakAuras.clones) do
--         local r = WeakAuras.GetRegion(aura)

--         if r and r.regionType == "icon" then
--             self:ApplyTemplate(aura)

--             for cloneId, clone in pairs(clones) do
--                 self:ApplyTemplate(aura, cloneId)
--             end
--         end
--     end
-- end

-- function aura_env.CheckLogin()
--     if WeakAuras.IsLoginFinished() and needsRefresh then
--         skinner:SkinAllIcons()
--         needsRefresh = false
--         return
--     end

--     C_Timer.After(
--         1,
--         function()
--             WeakAuras.ScanEvents("WA_LOGIN_FINISHED")
--         end
--     )
-- end
