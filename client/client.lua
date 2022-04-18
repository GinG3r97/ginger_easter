ESX = nil
local gingerEasterUIIsOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Wait(10)
	gingerEasterUIIsOpen = true
	SendNUIMessage({
		action = "openGingerEaster",
		array  = data
	})
end)

RegisterCommand("closeGingerEaster", function() 
	SendNUIMessage({
		action = "closeGingerEaster"
	})
	gingerEasterUIIsOpen = false
end)

RegisterKeyMapping("closeGingerEaster","closeGingerEaster", 'keyboard', 'BACK')

local entitys = {}
local egg = "prop_alien_egg_01"
local bunnyHunterPos1
local bunnyHunterPos2
local ground 
local bunnyReady = false
local isOnHunt = false
local isCollecting = false

function restartEggSpawn() 
	if entitys ~= 0 then
		for i, entity in pairs(entitys) do
			DeleteObject(entity)
			local model = GetEntityModel(entity)
			SetEntityAsNoLongerNeeded(entity)
			SetModelAsNoLongerNeeded(model)
			table.remove(entitys,i)	
		end
	end
end

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1000)
		bunnyReady = false
		isOnHunt = false
		restartEggSpawn()
		local modelHash = GetHashKey("A_F_M_BODYBUILD_01")
		local bunnyHunter = nil
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Wait(1)
		end
		bunnyHunter = CreatePed(0, modelHash , -78.47, -828.15, 40.57,true)
		FreezeEntityPosition(bunnyHunter, true)
		SetEntityHeading(bunnyHunter,  339.39)
		SetEntityInvincible(bunnyHunter, true)
		SetBlockingOfNonTemporaryEvents(bunnyHunter, true)
		bunnyHunterPos1 = GetEntityCoords(bunnyHunter,1)
		bunnyReady = true
		isOnHunt = true
		-- Citizen.Wait(10000)
		Citizen.Wait(1.5e+6)
	end
end)
------------------------------------------

Citizen.CreateThread(function()			 
	while true do
		Citizen.Wait(1000)
		if bunnyReady then
			if #entitys < 2 then --NUMBER OF EGGS TO BE SPAWN
				RequestModel(egg)
				while not HasModelLoaded(egg) or not HasCollisionForModelLoaded(egg) do
					Wait(1)
				end					
				posX = bunnyHunterPos1.x + math.random(-1000,1000) -- RADIUM OF POSITION X OF THE BUNNY MAN
				posY = bunnyHunterPos1.y + math.random(-1000,1000) -- RADIUM OF POSITION Y OF THE BUNNY MAN
				Z = bunnyHunterPos1.z + 999.0
				ground, posZ = GetGroundZFor_3dCoord(posX+.0,posY+.0,Z,1) --set Z pos as on ground
				if(ground) then -- IF THE EGG IS ON THE GROUND
					entity = CreateObject(GetHashKey(egg),posX,posY,posZ,true, false, true)-- CREATE EGG
					SetEntityAsMissionEntity(entity, true, true) -- IT WILL NOT BE DELETED IF PLAYER IS FAR
					table.insert(entitys,entity) -- INSERT TO THE TABLE OF EGGS
					local blip = AddBlipForEntity(entity) -- ADD BLIP OF THE EGG
					SetBlipSprite(blip, 153)
					SetBlipColour(blip, 1)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Spawned entity")
					EndTextCommandSetBlipName(blip)
				end
			else
				bunnyReady = false
			end	
		end
	end
end)

RegisterNetEvent('ginger_easter:startCollectingEgg')
AddEventHandler('ginger_easter:startCollectingEgg', function(xPlayer)
		if isCollecting then
			exports['mythic_notify']:DoLongHudText('error', 'Please wait, Still collecting Easter Egg')
		else
			isCollecting = true
			for i, entity in pairs(entitys) do
				local playerPos = GetEntityCoords(GetPlayerPed(-1), false)
				local eggPos = GetEntityCoords(entity, false)
				local distance = Vdist(eggPos.x, eggPos.y, eggPos.z, playerPos.x, playerPos.y, playerPos.z)
				if distance <= 2.0 then
					local playerPed = PlayerPedId()
					TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					Citizen.Wait(10000)
					if distance <= 2.0 then
						ClearPedTasks(playerPed)
						DeleteObject(entity)
						local model = GetEntityModel(entity)
						SetEntityAsNoLongerNeeded(entity)
						SetModelAsNoLongerNeeded(model)
						table.remove(entitys,i)	
						TriggerServerEvent('ginger_easter:giveCollectedEgg')
					end	
					isCollecting = false
				end	
			end
		end
end)
