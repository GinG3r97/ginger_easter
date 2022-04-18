ESX = nil
TriggerEvent('trinity_base:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ginger_easter:test')
AddEventHandler('ginger_easter:test', function()
end)

RegisterServerEvent('ginger_easter:giveFirstEgg')
AddEventHandler('ginger_easter:giveFirstEgg', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    
    exports.ghmattimysql:execute("SELECT firstEgg FROM ginger_easter_egg WHERE steam = @steam",{
		['@steam'] = identifier
	},function(eggResult)
        if eggResult == nil or eggResult[1] == nil then
            exports.ghmattimysql:execute("INSERT INTO ginger_easter_egg (steam, collectedEgg, redeemedEgg, firstEgg) VALUES (@steam, @collectedEgg, @redeemedEgg, @firstEgg)",
            {
                ['steam'] = identifier,
                ['collectedEgg'] = 0,
                ['redeemedEgg'] = 0,
                ['firstEgg'] = 1
            }, function(result)
                TriggerClientEvent('player:receiveItem', xPlayer.source, 'normalEgg', 1, false)
            end)
        else
            gingerBreadEasterLogs(xPlayer.source)
            --LOG HERE TRYING TO GET FIRST EGG
        end
    end)
end)



RegisterServerEvent('ginger_easter:giveCollectedEgg')
AddEventHandler('ginger_easter:giveCollectedEgg', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if (math.random() * 100 < 30) then
        TriggerClientEvent('player:receiveItem', xPlayer.source, 'normalEgg', 1, false)
        updateCollectedEggs("normalEgg")
    elseif (math.random() * 100 < 20) then
        TriggerClientEvent('player:receiveItem', xPlayer.source, 'specialEgg', 1, false)
        updateCollectedEggs("specialEgg")
    elseif (math.random() * 100 < 15) then
        TriggerClientEvent('player:receiveItem', xPlayer.source, 'legendaryEgg', 1, false)
        updateCollectedEggs("legendaryEgg")
    elseif (math.random() * 100 < 10) then
        TriggerClientEvent('player:receiveItem', xPlayer.source, 'vipEgg', 1, false)
        updateCollectedEggs("vipEgg")
    else
        local randomPick = math.random(1, 2)
        if randomPick == 1 then
            TriggerClientEvent('player:receiveItem', xPlayer.source, 'normalEgg', 1, false)
            updateCollectedEggs("normalEgg")
        elseif randomPick == 2 then
            TriggerClientEvent('player:receiveItem', xPlayer.source, 'specialEgg', 1, false)
            updateCollectedEggs("specialEgg")
        end
    end
end)

function updateCollectedEggs(eggType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    
    exports.ghmattimysql:execute("SELECT * FROM ginger_easter_egg WHERE steam = @steam",{
		['@steam'] = identifier
	},function(eggResult)
        local normalEggToAdd = eggResult[1].normalEggCollected
        local specialEggToAdd = eggResult[1].specialEggCollected
        local legendaryEggToAdd = eggResult[1].legendaryEggCollected
        local vipEggToAddAdd = eggResult[1].VIPEggCollected 

        if eggType == "normalEgg" then
            normalEggToAdd = eggResult[1].normalEggCollected + 1
        elseif eggType == "specialEgg" then
            specialEggToAdd = eggResult[1].specialEggCollected + 1
        elseif eggType == "legendaryEgg" then
            legendaryEggToAdd = eggResult[1].legendaryEggCollected + 1
        elseif eggType == "vipEgg" then
            vipEggToAddAdd = eggResult[1].VIPEggCollected + 1
        end

        if eggResult ~= nil or eggResult[1] ~= nil then
            exports.ghmattimysql:execute("UPDATE ginger_easter_egg SET `totalCollectedEgg` = @totalCollectedEgg,`normalEggCollected` = @normalEggCollected,`specialEggCollected` = @specialEggCollected,`legendaryEggCollected` = @legendaryEggCollected,`VIPEggCollected` = @VIPEggCollected WHERE steam = @steam", 
            {
                ['@steam'] = identifier,
                ['totalCollectedEgg'] = eggResult[1].totalCollectedEgg + 1, 
                ['normalEggCollected'] = normalEggToAdd, 
                ['specialEggCollected'] = specialEggToAdd, 
                ['legendaryEggCollected'] = legendaryEggToAdd, 
                ['VIPEggCollected'] = vipEggToAddAdd
            }, function(rowsChanged)
            end)
        else
            gingerBreadEasterLogsNodata(xPlayer.source)
            --LOG HERE TRYING TO GET FIRST EGG
        end
    end)
end


RegisterServerEvent('ginger_easter:redeemEgg')
AddEventHandler('ginger_easter:redeemEgg', function(eggType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if eggType == "normalEgg" then
        local randomNormalEgg  = math.random(1, #EasterConfig.normalReward)
        TriggerClientEvent('player:receiveItem', xPlayer.source, EasterConfig.normalReward[randomNormalEgg].name, 1, false)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received '.. EasterConfig.normalReward[randomNormalEgg].displayName..'.', duration = 5000 })

    elseif eggType == "specialEgg" then
        if (math.random() * 100 < 70) then
            local amount = math.random(500,1000)
            xPlayer.addMoney(amount)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received $'..amount, duration = 5000 })

        elseif (math.random() * 100 < 60) then
            local amount = math.random(500,1000)
            xPlayer.addAccountMoney('black_money', amount)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received $'..amount, duration = 5000 })

        elseif (math.random() * 100 < 50) then
            local amount = math.random(10,20)
            TriggerEvent('trinity_base:AddReputation', xPlayer.source, amount)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received '..amount..' reputation, type /checkrep to check it.', duration = 5000 })

        else
            local amount = 500
            TriggerClientEvent('player:receiveItem', xPlayer.source, "seed_weed",  math.random(1,5), false)
            xPlayer.addMoney(amount) 
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received $'..amount..' and some seed weeds.', duration = 5000 })

        end
    elseif eggType == "legendaryEgg" then
            local randomLegandaryEgg  = math.random(1, #EasterConfig.legendaryReward)
            TriggerClientEvent('player:receiveItem', xPlayer.source, EasterConfig.legendaryReward[randomLegandaryEgg].name,  math.random(1,3), false)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received '..EasterConfig.legendaryReward[randomLegandaryEgg].displayName, duration = 5000 })

    elseif eggType == "vipEgg" then
        if (math.random() * 100 < 30) then
            TriggerClientEvent('player:receiveItem', xPlayer.source, "-1716589765", 1, false)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received .50 Pistol.', duration = 5000 })

        elseif (math.random() * 100 < 35) then
            TriggerClientEvent('player:receiveItem', xPlayer.source, "584646201", 1, false)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received AP Pistol.', duration = 5000 })

        elseif (math.random() * 100 < 50) then
            TriggerClientEvent('player:receiveItem', xPlayer.source, "-619010992", 1, false)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received Machine Pistol.', duration = 5000 })

        elseif (math.random() * 100 < 80) then
            TriggerClientEvent('player:receiveItem', xPlayer.source, "-538741184", 1, false)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received Switch Blade.', duration = 5000 })
        else
            TriggerClientEvent('player:receiveItem', xPlayer.source, "police_vest",  math.random(1,5), false)
            xPlayer.addMoney(3000) 
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You received $3000 and some Police Vest.', duration = 5000 })
        end
    end
end)


function updateRedeemedEggs(eggType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    
    exports.ghmattimysql:execute("SELECT * FROM ginger_easter_egg WHERE steam = @steam",{
		['@steam'] = identifier
	},function(eggResult)
        local normalEggToAdd = eggResult[1].normalEggCollected
        local specialEggToAdd = eggResult[1].specialEggCollected
        local legendaryEggToAdd = eggResult[1].legendaryEggCollected
        local vipEggToAddAdd = eggResult[1].VIPEggCollected 

        if eggType == "normalEgg" then
            normalEggToAdd = eggResult[1].normalEggCollected + 1
        elseif eggType == "specialEgg" then
            specialEggToAdd = eggResult[1].specialEggCollected + 1
        elseif eggType == "legendaryEgg" then
            legendaryEggToAdd = eggResult[1].legendaryEggCollected + 1
        elseif eggType == "vipEgg" then
            vipEggToAddAdd = eggResult[1].VIPEggCollected + 1
        end

        if eggResult ~= nil or eggResult[1] ~= nil then
            exports.ghmattimysql:execute("UPDATE ginger_easter_egg SET `totalCollectedEgg` = @totalCollectedEgg,`normalEggCollected` = @normalEggCollected,`specialEggCollected` = @specialEggCollected,`legendaryEggCollected` = @legendaryEggCollected,`VIPEggCollected` = @VIPEggCollected WHERE steam = @steam", 
            {
                ['@steam'] = identifier,
                ['totalCollectedEgg'] = eggResult[1].totalCollectedEgg + 1, 
                ['normalEggCollected'] = normalEggToAdd, 
                ['specialEggCollected'] = specialEggToAdd, 
                ['legendaryEggCollected'] = legendaryEggToAdd, 
                ['VIPEggCollected'] = vipEggToAddAdd
            }, function(rowsChanged)
            end)
        else
            gingerBreadEasterLogsNodata(xPlayer.source)
            --LOG HERE TRYING TO GET FIRST EGG
        end
    end)
end 