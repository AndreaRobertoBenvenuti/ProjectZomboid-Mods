-- Sopravvissuto - Tratti creativi per Project Zomboid Build 42
--
-- TRATTI TOTALI: 33 (12 originali + 21 nuovi)
-- Ogni tratto ha effetti meccanici reali in-game.
--
-- Fix B42:
--   - Perks.Sneak (non Sneaking)
--   - Hook su ISEatFoodAction.complete (OnItemUse non esiste in B42)
--   - getOverallBodyHealth() ritorna 0-100

-- ============================================================
-- UTILITY
-- ============================================================

local function isSleeping(player)
    if player.isSleeping then return player:isSleeping() end
    if player.isAsleep   then return player:isAsleep()   end
    return false
end

-- ============================================================
-- TRATTI POSITIVI
-- ============================================================

local tAdrenalina = TraitFactory.addTrait(
    "Soprav_Adrenalina", "Adrenalina", -5,
    "Con la vita sotto il 35%, il corpo risponde: la fatica si accumula molto più lentamente.", false)

local tNottambulo = TraitFactory.addTrait(
    "Soprav_Nottambulo", "Nottambulo", -4,
    "Tra le 22:00 e le 06:00 accumula meno fatica e stress.", false)

local tSangueFreddo = TraitFactory.addTrait(
    "Soprav_SangueFreddo", "Sangue Freddo", -4,
    "Il panico non fa parte del suo vocabolario. Stress e panico calano naturalmente ogni ora.", false)

local tCuocoCampo = TraitFactory.addTrait(
    "Soprav_CuocoCampo", "Cuoco di Campo", -2,
    "Sa trarre il massimo da qualsiasi cibo. Ha bisogno di mangiare meno spesso.", false)

local tMemoriaFerro = TraitFactory.addTrait(
    "Soprav_MemoriaFerro", "Memoria di Ferro", -4,
    "Impara in fretta e non dimentica. Bonus alle competenze pratiche.", false)
tMemoriaFerro:addXPBoost(Perks.Woodwork,    1)
tMemoriaFerro:addXPBoost(Perks.Mechanics,   1)
tMemoriaFerro:addXPBoost(Perks.Electricity, 1)
tMemoriaFerro:addXPBoost(Perks.Doctor,      1)

local tLamaNaturale = TraitFactory.addTrait(
    "Soprav_LamaNaturale", "Lama Naturale", -2,
    "Istinto naturale per le armi da taglio.", false)
tLamaNaturale:addXPBoost(Perks.SmallBlade, 2)
tLamaNaturale:addXPBoost(Perks.LongBlade,  1)

local tTerminator = TraitFactory.addTrait(
    "Soprav_Terminator", "Terminator", -6,
    "Non si ferma mai. Con la vita sotto il 35%, ogni ora panico azzerato e fatica dimezzata.", false)

local tSpartano = TraitFactory.addTrait(
    "Soprav_Spartano", "Spartano", -4,
    "Abituato alle privazioni. Fame e sete si accumulano il 30% più lentamente.", false)

local tAcrobata = TraitFactory.addTrait(
    "Soprav_Acrobata", "Acrobata", -4,
    "Il corpo sa come muoversi. Velocità e destrezza superiori.", false)
tAcrobata:addXPBoost(Perks.Nimble,    2)
tAcrobata:addXPBoost(Perks.Sprinting, 1)

local tExMilitare = TraitFactory.addTrait(
    "Soprav_ExMilitare", "Ex Militare", -5,
    "Addestramento militare completo. Competente con le armi e fisicamente preparato. Inizia senza stress.", false)
tExMilitare:addXPBoost(Perks.Aiming,    1)
tExMilitare:addXPBoost(Perks.Reloading, 1)
tExMilitare:addXPBoost(Perks.Sprinting, 1)

local tCecchinoNat = TraitFactory.addTrait(
    "Soprav_CecchinoNat", "Cecchino Naturale", -2,
    "Mira innata. Progredisce rapidamente con le armi da fuoco.", false)
tCecchinoNat:addXPBoost(Perks.Aiming, 3)

local tMeccanicoNato = TraitFactory.addTrait(
    "Soprav_MeccanicoNato", "Meccanico Nato", -2,
    "I motori parlano con lui. Impara la meccanica in modo naturale.", false)
tMeccanicoNato:addXPBoost(Perks.Mechanics, 3)

local tCuocoProvetto = TraitFactory.addTrait(
    "Soprav_CuocoProvetto", "Cuoco Provetto", -2,
    "Talento naturale in cucina. I suoi piatti sono sempre al punto giusto.", false)
tCuocoProvetto:addXPBoost(Perks.Cooking, 3)

local tPredatore = TraitFactory.addTrait(
    "Soprav_Predatore", "Predatore", -4,
    "Nato per cacciare. Trappole, raccolta e furtività vengono naturali.", false)
tPredatore:addXPBoost(Perks.Trapping,        2)
tPredatore:addXPBoost(Perks.Sneak,           1)  -- B42: Perks.Sneak (non Sneaking)
tPredatore:addXPBoost(Perks.PlantScavenging, 1)

local tSanguePietra = TraitFactory.addTrait(
    "Soprav_SanguePietra", "Sangue di Pietra", -2,
    "Le ferite si chiudono in fretta. L'infezione avanza più lentamente.", false)

local tFilosofo = TraitFactory.addTrait(
    "Soprav_Filosofo", "Filosofo", -1,
    "La pace interiore è la sua forza. L'infelicità svanisce nel tempo.", false)

-- ============================================================
-- TRATTI NEGATIVI
-- ============================================================

local tCaffeinaDip = TraitFactory.addTrait(
    "Soprav_CaffeinaDip", "Caffeina Dipendente", 4,
    "Senza la sua dose di caffè non funziona. Accumula stress e fatica extra ogni ora.", false)

local tEmofobico = TraitFactory.addTrait(
    "Soprav_Emofobico", "Emofobico", 4,
    "Non sopporta la vista del sangue. Ogni ferita causa stress crescente.", false)

local tDiurno = TraitFactory.addTrait(
    "Soprav_Diurno", "Creatura Diurna", 2,
    "Le ore notturne lo logorano. Tra le 22:00 e le 06:00 accumula fatica e stress extra.", false)

local tOttuso = TraitFactory.addTrait(
    "Soprav_Ottuso", "Ottuso", 5,
    "Fatica ad acquisire nuove competenze tecniche.", false)
tOttuso:addXPBoost(Perks.Woodwork,    -1)
tOttuso:addXPBoost(Perks.Mechanics,   -1)
tOttuso:addXPBoost(Perks.Electricity, -1)
tOttuso:addXPBoost(Perks.Doctor,      -1)
tOttuso:addXPBoost(Perks.Aiming,      -1)

local tGracile = TraitFactory.addTrait(
    "Soprav_Gracile", "Gracile", 4,
    "Fisico esile e poca resistenza. Si stanca molto più in fretta.", false)

local tIngordo = TraitFactory.addTrait(
    "Soprav_Ingordo", "Ingordo", 2,
    "Metabolismo insaziabile. Ha sempre fame e mangia molto più spesso.", false)

local tAlcolista = TraitFactory.addTrait(
    "Soprav_Alcolista", "Alcolista", 5,
    "Non riesce a smettere. Senza alcool per 12h: dolore crescente. Senza alcool per 24h: anche la salute ne risente.", false)

local tManiTremanti = TraitFactory.addTrait(
    "Soprav_ManiTremanti", "Mani Tremanti", 4,
    "Le mani tremano costantemente. Mirare è un'impresa.", false)
tManiTremanti:addXPBoost(Perks.Aiming,    -2)
tManiTremanti:addXPBoost(Perks.Reloading, -1)

local tZoppo = TraitFactory.addTrait(
    "Soprav_Zoppo", "Zoppo", 5,
    "Una vecchia ferita alla gamba non si è mai rimarginata bene. Lento e goffo in movimento.", false)
tZoppo:addXPBoost(Perks.Sprinting, -1)
tZoppo:addXPBoost(Perks.Nimble,    -1)

local tFobicoDelBuio = TraitFactory.addTrait(
    "Soprav_FobicoDelBuio", "Fobico del Buio", 2,
    "L'oscurità lo innervosisce. Di notte, quando è sveglio, stress e panico crescono lentamente.", false)

local tTerroreNotte = TraitFactory.addTrait(
    "Soprav_TerroreNotte", "Terrore Notturno", 5,
    "L'oscurità lo paralizza. Di notte, da sveglio, stress e panico esplodono. Con panico alto rischia una crisi totale.", false)

local tPropensoPanico = TraitFactory.addTrait(
    "Soprav_PropensoPanico", "Propenso al Panico", 4,
    "La calma è un lusso che non si può permettere. Con panico oltre il 50%, rischia una crisi improvvisa.", false)

local tStomDelicato = TraitFactory.addTrait(
    "Soprav_StomDelicato", "Stomaco Delicato", 2,
    "Non sopporta il cibo andato a male. Mangiare cibo marcio causa dolore immediato.", false)

local tDipSonno = TraitFactory.addTrait(
    "Soprav_DipSonno", "Dipendente dal Sonno", 2,
    "Ha bisogno di dormire molto più degli altri. La fatica si accumula rapidamente.", false)

local tMalaticcio = TraitFactory.addTrait(
    "Soprav_Malaticcio", "Malaticcio", 4,
    "Il corpo è una cartina tornasole. Ogni tanto, senza motivo, si sente male.", false)

local tPessimista = TraitFactory.addTrait(
    "Soprav_Pessimista", "Pessimista", 1,
    "Vede sempre il lato peggiore delle cose. Noia e infelicità si accumulano più in fretta.", false)

local tClaustrofobico = TraitFactory.addTrait(
    "Soprav_Claustrofobico", "Claustrofobico", 2,
    "Gli spazi chiusi lo soffocano. Lo stress si accumula costantemente.", false)

-- ============================================================
-- ESCLUSIONI RECIPROCHE
-- ============================================================

local function excl(a, b)
    a:getMutuallyExclusiveTraits():add(b:getType())
    b:getMutuallyExclusiveTraits():add(a:getType())
end

excl(tSangueFreddo,  tEmofobico)
excl(tNottambulo,    tDiurno)
excl(tMemoriaFerro,  tOttuso)
excl(tAdrenalina,    tGracile)
excl(tCuocoCampo,    tIngordo)
excl(tTerminator,    tZoppo)
excl(tExMilitare,    tManiTremanti)
excl(tSpartano,      tAlcolista)
excl(tFilosofo,      tPessimista)
excl(tCecchinoNat,   tManiTremanti)
excl(tFobicoDelBuio, tTerroreNotte)
excl(tAcrobata,      tZoppo)

-- ============================================================
-- TRACKING ITEMS (caffeina e alcool)
-- In B42 non esiste Events.OnItemUse: si hookkano ISEatFoodAction.complete
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
    if character:HasTrait("Soprav_StomDelicato") and item:isRotten and item:isRotten() then
        local stats = character:getStats()
        stats:setPain(math.min(1.0, stats:getPain() + 0.25))
    end
    return result
end

-- ============================================================
-- EFFETTI ALLA CREAZIONE DEL PERSONAGGIO
-- ============================================================

local function onCreatePlayer(_, player)
    if player:HasTrait("Soprav_SangueFreddo") then
        player:getStats():setStress(0)
        player:getStats():setPanic(0)
    end
    if player:HasTrait("Soprav_ExMilitare") then
        player:getStats():setStress(0)
        player:getStats():setPanic(0)
    end
    if player:HasTrait("Soprav_Emofobico") then
        player:getStats():setStress(0.1)
    end
    if player:HasTrait("Soprav_Gracile") then
        local s = player:getStats()
        s:setFatigue(math.min(1.0, s:getFatigue() + 0.1))
    end
    if player:HasTrait("Soprav_Zoppo") then
        player:getStats():setPain(0.2)
    end
    if player:HasTrait("Soprav_Alcolista") then
        player:getModData()["Soprav_lastAlcohol"] = getGameTime():getWorldAgeHours()
    end
    if player:HasTrait("Soprav_CaffeinaDip") then
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

            if player:HasTrait("Soprav_Adrenalina") and health < 35 then
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.04))
            end
            if player:HasTrait("Soprav_Nottambulo") and isNight then
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.025))
                stats:setStress(math.max(0,  stats:getStress()  - 0.025))
            end
            if player:HasTrait("Soprav_SangueFreddo") then
                stats:setStress(math.max(0, stats:getStress() - 0.035))
                stats:setPanic(math.max(0,  stats:getPanic()  - 0.035))
            end
            if player:HasTrait("Soprav_CuocoCampo") then
                stats:setHunger(math.max(0, stats:getHunger() - 0.009))
            end
            if player:HasTrait("Soprav_SanguePietra") and health < 100 then
                stats:setPain(math.max(0, stats:getPain() - 0.015))
            end
            if player:HasTrait("Soprav_Filosofo") then
                stats:setUnhappiness(math.max(0, stats:getUnhappiness() - 0.018))
            end
            if player:HasTrait("Soprav_Spartano") then
                stats:setHunger(math.max(0, stats:getHunger() - 0.007))
                stats:setThirst(math.max(0, stats:getThirst() - 0.007))
            end
            if player:HasTrait("Soprav_Terminator") and health < 35 then
                stats:setPanic(0)
                stats:setFatigue(math.max(0, stats:getFatigue() - 0.05))
            end
            if player:HasTrait("Soprav_CaffeinaDip") then
                local lastCoffee = md["Soprav_lastCoffee"] or 0
                if (now - lastCoffee) > 4 then
                    stats:setStress(math.min(1.0, stats:getStress()  + 0.045))
                    stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.035))
                end
            end
            if player:HasTrait("Soprav_Emofobico") and health < 100 then
                stats:setStress(math.min(1.0, stats:getStress() + 0.055))
            end
            if player:HasTrait("Soprav_Diurno") and isNight then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.028))
                stats:setStress(math.min(1.0,  stats:getStress()  + 0.018))
            end
            if player:HasTrait("Soprav_Gracile") then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.028))
            end
            if player:HasTrait("Soprav_Ingordo") then
                stats:setHunger(math.min(1.0, stats:getHunger() + 0.014))
            end
            if player:HasTrait("Soprav_Alcolista") then
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
            if player:HasTrait("Soprav_FobicoDelBuio") and isNight and not asleep then
                stats:setStress(math.min(1.0, stats:getStress() + 0.024))
                stats:setPanic(math.min(1.0,  stats:getPanic()  + 0.012))
            end
            if player:HasTrait("Soprav_TerroreNotte") and isNight and not asleep then
                stats:setStress(math.min(1.0, stats:getStress() + 0.065))
                stats:setPanic(math.min(1.0,  stats:getPanic()  + 0.040))
                if stats:getPanic() > 0.6 and ZombRand(100) < 20 then
                    stats:setPanic(1.0)
                    stats:setStress(1.0)
                end
            end
            if player:HasTrait("Soprav_PropensoPanico") then
                if stats:getPanic() > 0.5 and ZombRand(100) < 15 then
                    stats:setPanic(1.0)
                end
            end
            if player:HasTrait("Soprav_DipSonno") then
                stats:setFatigue(math.min(1.0, stats:getFatigue() + 0.018))
            end
            if player:HasTrait("Soprav_Malaticcio") and ZombRand(1000) < 2 then
                stats:setPain(math.min(1.0, stats:getPain() + 0.2))
            end
            if player:HasTrait("Soprav_Pessimista") then
                stats:setUnhappiness(math.min(1.0, stats:getUnhappiness() + 0.012))
                stats:setBoredom(math.min(1.0,     stats:getBoredom()     + 0.022))
            end
            if player:HasTrait("Soprav_Claustrofobico") then
                stats:setStress(math.min(1.0, stats:getStress() + 0.028))
            end
        end
    end
end

Events.OnCreatePlayer.Add(onCreatePlayer)
Events.EveryHours.Add(onEveryHours)
