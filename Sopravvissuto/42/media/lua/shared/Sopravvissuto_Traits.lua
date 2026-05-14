-- Sopravvissuto - Effetti dei tratti per Project Zomboid Build 42+
--
-- La registrazione dei tratti avviene in:
--   registries.lua                           → CharacterTrait.register()
--   media/scripts/Sopravvissuto_Traits.txt   → character_trait_definition
--   media/lua/shared/Translate/IT/UI_IT.txt  → nomi e descrizioni
--
-- In questo file si gestiscono solo gli effetti in-game:
--   player:hasTrait(SopravvissutoTraits.xxx)
--   Salute: getOverallBodyHealth() ritorna 0-100 in B42

-- ============================================================
-- UTILITY
-- ============================================================

local function isSleeping(player)
    if player.isSleeping then return player:isSleeping() end
    if player.isAsleep   then return player:isAsleep()   end
    return false
end

-- ============================================================
-- TRACKING ITEMS (caffeina e alcool)
-- ============================================================

local CAFFEINE_ITEMS = {
    ["Base.Coffee"]      = true,
    ["Base.CoffeeMug"]   = true,
    ["Base.HotCoffee"]   = true,
    ["Base.EspressoMug"] = true,
    ["Base.SodaCan"]     = true,
    ["Base.EnergyDrink"] = true,
}

local ALCOHOL_ITEMS = {
    ["Base.Whiskey"]      = true,
    ["Base.WhiskeyFull"]  = true,
    ["Base.Beer"]         = true,
    ["Base.BeerCan"]      = true,
    ["Base.Wine"]         = true,
    ["Base.WineFull"]     = true,
    ["Base.Vodka"]        = true,
    ["Base.VodkaFull"]    = true,
    ["Base.Bourbon"]      = true,
    ["Base.BourbonFull"]  = true,
    ["Base.Rum"]          = true,
    ["Base.RumFull"]      = true,
    ["Base.Scotch"]       = true,
    ["Base.ScotchFull"]   = true,
    ["Base.Champagne"]    = true,
    ["Base.Martini"]      = true,
}

local origEatComplete = ISEatFoodAction.complete
ISEatFoodAction.complete = function(self)
    local result = origEatComplete(self)
    local item      = self.item
    local character = self.character
    if not item or not character then return result end

    local fullType = item:getFullType()
    local md       = character:getModData()
    local now      = getGameTime():getWorldAgeHours()

    if CAFFEINE_ITEMS[fullType] then
        md["Soprav_lastCoffee"] = now
    end
    if ALCOHOL_ITEMS[fullType] or item:hasTag("Alcoholic") then
        md["Soprav_lastAlcohol"] = now
    end
    -- Stomaco Delicato: dolore immediato mangiando cibo marcio
    if character:hasTrait(SopravvissutoTraits.stomdelicato) and item:isRotten and item:isRotten() then
        local stats = character:getStats()
        stats:setPain(math.min(1.0, stats:getPain() + 0.25))
    end
    return result
end

-- ============================================================
-- EFFETTI ALLA CREAZIONE DEL PERSONAGGIO
-- ============================================================

local function onCreatePlayer(_, player)
    if player:hasTrait(SopravvissutoTraits.sanguefreddo) then
        player:getStats():setStress(0)
        player:getStats():setPanic(0)
    end
    if player:hasTrait(SopravvissutoTraits.exmilitare) then
        player:getStats():setStress(0)
        player:getStats():setPanic(0)
    end
    if player:hasTrait(SopravvissutoTraits.emofobico) then
        player:getStats():setStress(0.1)
    end
    if player:hasTrait(SopravvissutoTraits.gracile) then
        local s = player:getStats()
        s:setFatigue(math.min(1.0, s:getFatigue() + 0.1))
    end
    if player:hasTrait(SopravvissutoTraits.zoppo) then
        player:getStats():setPain(0.2)
    end
    if player:hasTrait(SopravvissutoTraits.alcolista) then
        player:getModData()["Soprav_lastAlcohol"] = getGameTime():getWorldAgeHours()
    end
    if player:hasTrait(SopravvissutoTraits.caffeinadip) then
        player:getModData()["Soprav_lastCoffee"] = getGameTime():getWorldAgeHours()
    end
end

-- ============================================================
-- EFFETTI CONTINUATIVI (ogni ora di gioco)
-- getOverallBodyHealth() ritorna 0-100 in B42
-- ============================================================

local function onEveryHours()
    local gt      = getGameTime()
    local hour    = gt:getTimeOfDay()
    local isNight = (hour >= 22.0 or hour < 6.0)

    for i = 0, 3 do
        local player = getSpecificPlayer(i)
        if player and not player:isDead() then
            local stats  = player:getStats()
            local md     = player:getModData()
            local now    = gt:getWorldAgeHours()
            local asleep = isSleeping(player)
            local health = player:getBodyDamage():getOverallBodyHealth()  -- 0-100

            -- TRATTI POSITIVI
            if player:hasTrait(SopravvissutoTraits.adrenalina) and health < 35 then
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.04))
            end
            if player:hasTrait(SopravvissutoTraits.nottambulo) and isNight then
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.025))
                stats:setStress(math.max(0,  stats:getStress()  - 0.025))
            end
            if player:hasTrait(SopravvissutoTraits.sanguefreddo) then
                stats:setStress(math.max(0, stats:getStress() - 0.035))
                stats:setPanic(math.max(0,  stats:getPanic()  - 0.035))
            end
            if player:hasTrait(SopravvissutoTraits.cuococampo) then
                stats:setHunger(math.max(0, stats:getHunger() - 0.009))
            end
            if player:hasTrait(SopravvissutoTraits.sanguepietra) and health < 100 then
                stats:setPain(math.max(0, stats:getPain() - 0.015))
            end
            if player:hasTrait(SopravvissutoTraits.filosofo) then
                stats:setUnhappiness(math.max(0, stats:getUnhappiness() - 0.018))
            end
            if player:hasTrait(SopravvissutoTraits.spartano) then
                stats:setHunger(math.max(0, stats:getHunger() - 0.007))
                stats:setThirst(math.max(0, stats:getThirst() - 0.007))
            end
            if player:hasTrait(SopravvissutoTraits.terminator) and health < 35 then
                stats:setPanic(0)
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.05))
            end

            -- TRATTI NEGATIVI
            if player:hasTrait(SopravvissutoTraits.caffeinadip) then
                local lastCoffee = md["Soprav_lastCoffee"] or 0
                if (now - lastCoffee) > 4 then
                    stats:setStress(math.min(1.0, stats:getStress()  + 0.045))
                    stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.035))
                end
            end
            if player:hasTrait(SopravvissutoTraits.emofobico) and health < 100 then
                stats:setStress(math.min(1.0, stats:getStress() + 0.055))
            end
            if player:hasTrait(SopravvissutoTraits.diurno) and isNight then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.028))
                stats:setStress(math.min(1.0,  stats:getStress()  + 0.018))
            end
            if player:hasTrait(SopravvissutoTraits.gracile) then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.028))
            end
            if player:hasTrait(SopravvissutoTraits.ingordo) then
                stats:setHunger(math.min(1.0, stats:getHunger() + 0.014))
            end
            if player:hasTrait(SopravvissutoTraits.alcolista) then
                local lastAlc      = md["Soprav_lastAlcohol"] or 0
                local hoursWithout = now - lastAlc
                if hoursWithout > 24 then
                    stats:setPain(math.min(1.0, stats:getPain() + 0.06))
                    player:getBodyDamage():setOverallBodyHealth(
                        math.max(0, player:getBodyDamage():getOverallBodyHealth() - 0.02))
                elseif hoursWithout > 12 then
                    stats:setPain(math.min(1.0, stats:getPain() + 0.05))
                end
            end
            if player:hasTrait(SopravvissutoTraits.fobicodelbuio) and isNight and not asleep then
                stats:setStress(math.min(1.0, stats:getStress() + 0.024))
                stats:setPanic(math.min(1.0,  stats:getPanic()  + 0.012))
            end
            if player:hasTrait(SopravvissutoTraits.terrorenotte) and isNight and not asleep then
                stats:setStress(math.min(1.0, stats:getStress() + 0.065))
                stats:setPanic(math.min(1.0,  stats:getPanic()  + 0.040))
                if stats:getPanic() > 0.6 and ZombRand(100) < 20 then
                    stats:setPanic(1.0)
                    stats:setStress(1.0)
                end
            end
            if player:hasTrait(SopravvissutoTraits.propensopanico) then
                if stats:getPanic() > 0.5 and ZombRand(100) < 15 then
                    stats:setPanic(1.0)
                end
            end
            if player:hasTrait(SopravvissutoTraits.dipsonno) then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.018))
            end
            if player:hasTrait(SopravvissutoTraits.malaticcio) and ZombRand(1000) < 2 then
                stats:setPain(math.min(1.0, stats:getPain() + 0.2))
            end
            if player:hasTrait(SopravvissutoTraits.pessimista) then
                stats:setUnhappiness(math.min(1.0, stats:getUnhappiness() + 0.012))
                stats:setBoredom(math.min(1.0,     stats:getBoredom()     + 0.022))
            end
            if player:hasTrait(SopravvissutoTraits.claustrofobico) then
                stats:setStress(math.min(1.0, stats:getStress() + 0.028))
            end
        end
    end
end

Events.OnCreatePlayer.Add(onCreatePlayer)
Events.EveryHours.Add(onEveryHours)
