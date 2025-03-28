ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local ox_target = exports.ox_target
lib.locale()

antidoublechatcl = false

CreateThread(function()

  local hospitalBlip = AddBlipForCoord(-544.6154, -203.5870, 38.2152)
  SetBlipSprite(hospitalBlip, 744)
  SetBlipScale(hospitalBlip, 0.8)
  SetBlipColour(hospitalBlip, 46)
  SetBlipAsShortRange(hospitalBlip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentSubstringPlayerName('领证处')
  EndTextCommandSetBlipName(hospitalBlip)

end)  

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			
			
			if dist < 40 and pedspawned == false then
				TriggerEvent('Tonyid:pedspawn',v.Cords,v.h)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('Tonyid:pedspawn')
AddEventHandler('Tonyid:pedspawn',function(coords,heading)

    local hash = Config.Postalped[math.random(#Config.Postalped)]

	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    pedspawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityInvincible(npc, true)

end)

RegisterNetEvent('Tony:idcarid')
AddEventHandler('Tony:idcarid',function()
  TriggerServerEvent('Tony:id')
end, false)


RegisterNetEvent('Tony:iddrive')
AddEventHandler('Tony:iddrive',function()
  TriggerServerEvent('Tony:drive')
end, false)

RegisterNetEvent('Tony:idweapon')
AddEventHandler('Tony:idweapon',function()
  TriggerServerEvent('Tony:weapon')
end, false)

 

RegisterNetEvent('Tony:idcarmenu')
AddEventHandler('Tony:idcarmenu',function()
  lib.registerContext({
    id = 'idcarmenu',
    title = '政府',
    options = {
      { 
        title = '身份证',
        description = '领取身份证 / $2000',
        icon = 'fa-solid fa-address-card',
        event = "Tony:idcarid",
      },
      { 
        title = '驾驶证',
        description = '领取驾驶证 / $5000',
        icon = 'fa-solid fa-address-card',
        event = "Tony:iddrive",
      },
      { 
        title = '持枪证',
        description = '领取持枪证 / $5000',
        icon = 'fa-solid fa-address-card',
        event = "Tony:idweapon",
      },
    }
  })

  lib.showContext('idcarmenu')

end)  

exports.ox_target:addBoxZone({
  coords = vec3(-545.1763, -204.0160, 38.2151),
  size = vec3(1, 2, 1),
  rotation = 209.1528,
  distance = 2,
  debug = false,
  options = {
      {
          name = 'idcarmenu',
          event = 'Tony:idcarmenu',
          icon = "fa-solid fa-user-doctor",
          label = '卡证中心', 

      }
  }
})
 
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if antidoublechatcl then
            antidoublechatcl = false
        end
    end
end)

RegisterNetEvent("id_car:client:id")
AddEventHandler("id_car:client:id", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not antidoublechatcl then
        antidoublechatcl = true
        TriggerServerEvent("id_car:server:id", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)

RegisterNetEvent("id_car:client:weapon")
AddEventHandler("id_car:client:weapon", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not antidoublechatcl then
        antidoublechatcl = true
        TriggerServerEvent("id_car:server:weapon", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)

RegisterNetEvent("id_car:client:drivers")
AddEventHandler("id_car:client:drivers", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not antidoublechatcl then
        antidoublechatcl = true
        TriggerServerEvent("id_car:server:drivers", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)


RegisterNetEvent("id_car:client:showanim")
AddEventHandler("id_car:client:showanim", function()
 
     lib.progressCircle({
        duration = 3000,   
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true },
        anim = { dict = 'paper_1_rcm_alt1-8', clip = 'player_one_dual-8' },
        prop = { model = 'prop_franklin_dl', bone = 57005, pos =  vec3(0.1, 0.02, -0.03),rot = vec3(-90.0, 170.0, -78.999001)}
      })  

end)
