local core = require('openmw.core')
local async = require('openmw.async')
local storage = require('openmw.storage')
local I = require('openmw.interfaces')

local settings = require('scripts.AdjustableMerchantGold.settings')

-----------------------------------------------------------
-- Settings UI registration
-----------------------------------------------------------

I.Settings.registerPage(settings.page)
I.Settings.registerGroup(settings.group)

-----------------------------------------------------------
-- Sync multiplier to global script
-----------------------------------------------------------

local playerSettings = storage.playerSection(settings.SETTINGS_KEY)

local function syncMultiplier()
    core.sendGlobalEvent('AdjustableMerchantGold_SetMultiplier', {
        multiplier = settings.getMultiplier(),
    })
end

playerSettings:subscribe(async:callback(function(_, key)
    if key == 'GoldMultiplier' or key == nil then
        syncMultiplier()
    end
end))

return {
    engineHandlers = {
        onActive = function()
            syncMultiplier()
        end,
    },
}
