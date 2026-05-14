-- Peso Reale - Controllo peso oggetti per Project Zomboid Build 42
--
-- Per ogni categoria puoi scegliere tra:
--   Modalità 1 (Moltiplicatore): moltiplica il peso originale (es. 0.5 = metà peso)
--   Modalità 2 (Valore Fisso):   ogni oggetto pesa esattamente il valore indicato

local PesoReale = {}

local originalWeights = {}
local initialized = false

local function getOptions()
    local v = SandboxVars.PesoReale
    if not v then return nil end
    return {
        weapon   = { mode = v.WeaponMode   or 1, value = v.WeaponValue   or 1.0 },
        ammo     = { mode = v.AmmoMode     or 1, value = v.AmmoValue     or 1.0 },
        clothing = { mode = v.ClothingMode or 1, value = v.ClothingValue or 1.0 },
        food     = { mode = v.FoodMode     or 1, value = v.FoodValue     or 1.0 },
        medical  = { mode = v.MedicalMode  or 1, value = v.MedicalValue  or 1.0 },
        misc     = { mode = v.MiscMode     or 1, value = v.MiscValue     or 1.0 },
    }
end

local function needsApplication(opts)
    for _, cat in pairs(opts) do
        if cat.mode == 2 then return true end
        if cat.value ~= 1.0 then return true end
    end
    return false
end

-- Tipi vanilla B42: "Weapon", "Ammo", "Clothing", "Food", "Normal",
-- "Container", "Literature", "Key", "Radio", ecc.
local function getCategory(item)
    local t = item:getType()
    if t == "Weapon" then
        return "weapon"
    elseif t == "Ammo" then
        return "ammo"
    elseif t == "Clothing" then
        return "clothing"
    elseif t == "Food" then
        return "food"
    elseif t == "Normal" then
        if item:hasTag("Medical") or item:hasTag("FirstAid") or item:hasTag("Bandage") then
            return "medical"
        end
        return "misc"
    else
        return "misc"
    end
end

local function computeNewWeight(origWeight, catOpts)
    if catOpts.mode == 2 then
        return catOpts.value
    else
        return origWeight * catOpts.value
    end
end

local function applyWeights()
    if initialized then return end
    local opts = getOptions()
    if not opts then return end
    if not needsApplication(opts) then return end
    local items = getAllItems()
    if not items then return end
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item then
            local fullType = item:getFullType()
            if not originalWeights[fullType] then
                originalWeights[fullType] = item:getActualWeight()
            end
            local origWeight = originalWeights[fullType]
            if origWeight and origWeight > 0 then
                local cat       = getCategory(item)
                local catOpts   = opts[cat]
                local newWeight = computeNewWeight(origWeight, catOpts)
                if newWeight ~= origWeight then
                    item:setActualWeight(newWeight)
                end
            end
        end
    end
    initialized = true
end

function PesoReale.reapply()
    initialized = false
    applyWeights()
end

Events.OnGameStart.Add(applyWeights)
Events.OnServerStarted.Add(applyWeights)
