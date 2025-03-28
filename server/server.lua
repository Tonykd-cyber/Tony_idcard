ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory
lib.locale()

RegisterServerEvent('Tony:id')
AddEventHandler('Tony:id', function()    
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    
    if items >= 2000 then 
        ox_inventory:RemoveItem(src, 'money', 2000)
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function(user)
            for i = 1, #user do
                local row = user[i]
                local sex = (row.sex == 'm') and '男' or '女'
                local fullName = string.format('%s %s', row.firstname, row.lastname) 
                local metadata = {
                    type = fullName,
                    description = string.format('姓名: %s  \n出生日期: %s  \n性别: %s  \n身高: %s',
                    fullName,
                    row.dateofbirth, 
                    sex,  
                    row.height),
                    dateofbirth = row.dateofbirth,   
                    sex = sex,   
                    height = row.height 
                }
                ox_inventory:AddItem(src, 'id', 1, metadata)
            end
        end)
    else
        TriggerClientEvent('ox_lib:notify', src, {    
            title = '政府',
            description = '你没有足够的钱',
            position = 'top',
            style = {
                backgroundColor = '#db0606',
                color = '#ffffff',
                ['.description'] = {
                    color = '#b8b8ba'
                }
            },
            icon = 'fa-solid fa-money-bill-wave',
            iconColor = '#ffffff'
        })
    end    
end)

RegisterNetEvent('Tony:drive')
AddEventHandler('Tony:drive', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
        if items >=5000 then 
            ox_inventory:RemoveItem(src, 'money', 5000)

            MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
            function(user)
                for i = 1, #user do
                    local row = user[i]
                    local sex = (row.sex == 'm') and '男' or '女'
                    local fullName = string.format('%s %s', row.firstname, row.lastname) 
                    local metadata = {
                        type = fullName,
                        description = string.format('姓名: %s  \n出生日期: %s  \n性别: %s  \n身高: %s',
                        fullName,
                        row.dateofbirth, 
                        sex,  
                        row.height),
                        dateofbirth = row.dateofbirth,   
                        sex = sex,   
                        height = row.height 
                    }
                    ox_inventory:AddItem(src, 'drivers', 1, metadata)
                end
            end)
            TriggerEvent('esx_license:addLicense', source, 'drive', function()end)
        else
            TriggerClientEvent('ox_lib:notify', src, {    
                title = '政府',
                description = '你没有足够的钱',
                position = 'top',
                style = {
                    backgroundColor = '#db0606',
                    color = '#ffffff',
                    ['.description'] = {
                      color = '#b8b8ba'
                    }
                },
                icon = 'fa-solid fa-money-bill-wave',
                iconColor = '#ffffff'})
        end    
  end)
RegisterNetEvent('Tony:weapon')
AddEventHandler('Tony:weapon', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
        if items >=5000 then 
            ox_inventory:RemoveItem(src, 'money', 5000)

            MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
            function(user)
                for i = 1, #user do
                    local row = user[i]
                    local sex = (row.sex == 'm') and '男' or '女'
                    local fullName = string.format('%s %s', row.firstname, row.lastname) 
                    local metadata = {
                        type = fullName,
                        description = string.format('姓名: %s  \n出生日期: %s  \n性别: %s  \n身高: %s',
                        fullName,
                        row.dateofbirth, 
                        sex,  
                        row.height),
                        dateofbirth = row.dateofbirth,   
                        sex = sex,   
                        height = row.height 
                    }
                    ox_inventory:AddItem(src, 'weapon', 1, metadata)
                end
            end)
            TriggerEvent('esx_license:addLicense', source, 'weapon', function()end)
        else
            TriggerClientEvent('ox_lib:notify', src, {    
                title = '政府',
                description = '你没有足够的钱',
                position = 'top',
                style = {
                    backgroundColor = '#db0606',
                    color = '#ffffff',
                    ['.description'] = {
                      color = '#b8b8ba'
                    }
                },
                icon = 'fa-solid fa-money-bill-wave',
                iconColor = '#ffffff'})
            
        end  

end)    

 
ESX.RegisterUsableItem('id',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'id')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'id') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('id_car:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and '男' or '女'
                            TriggerClientEvent("id_car:client:id", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "未找到您的角色信息." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 

RegisterServerEvent('id_car:server:id')
AddEventHandler('id_car:server:id', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#8CC9A0"><strong>──────── 身份证 ────────</strong></font><br>' ..
                        '<strong>姓名:</strong> {1} {2}<br>' ..
                        '<strong>性别:</strong> {3}<br>' ..
                        '<strong>出生日期:</strong> {4}<br>' ..
                        '<strong>身高:</strong> {5} cm<br>' ..
                        '<font color="#8CC9A0">────────••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#8CC9A0"><strong>──────── 身份证 ────────</strong></font><br>' ..
                '<strong>姓名:</strong> {1} {2}<br>' ..
                '<strong>性别:</strong> {3}<br>' ..
                '<strong>出生日期:</strong> {4}<br>' ..
                '<strong>身高:</strong> {5} cm<br>' ..
                '<font color="#8CC9A0">────────••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)

ESX.RegisterUsableItem('weapon',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'weapon')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'weapon') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('id_car:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and '男' or '女'
                            TriggerClientEvent("id_car:client:weapon", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "未找到您的角色信息." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 
 

RegisterServerEvent('id_car:server:weapon')
AddEventHandler('id_car:server:weapon', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#ff5542"><strong>──────── 武器证 ────────</strong></font><br>' ..
                        '<strong>姓名:</strong> {1} {2}<br>' ..
                        '<strong>性别:</strong> {3}<br>' ..
                        '<strong>出生日期:</strong> {4}<br>' ..
                        '<strong>身高:</strong> {5} cm<br>' ..
                        '<font color="#ff5542">────────••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#8CC9A0"><strong>──────── 武器证 ────────</strong></font><br>' ..
                '<strong>姓名:</strong> {1} {2}<br>' ..
                '<strong>性别:</strong> {3}<br>' ..
                '<strong>出生日期:</strong> {4}<br>' ..
                '<strong>身高:</strong> {5} cm<br>' ..
                '<font color="#8CC9A0">────────••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)

ESX.RegisterUsableItem('drivers',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'drivers')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'drivers') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('id_car:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and '男' or '女'
                            TriggerClientEvent("id_car:client:drivers", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "未找到您的角色信息." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 
 

RegisterServerEvent('id_car:server:drivers')
AddEventHandler('id_car:server:drivers', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#f7f54f"><strong>──────── 驾驶证 ────────</strong></font><br>' ..
                        '<strong>姓名:</strong> {1} {2}<br>' ..
                        '<strong>性别:</strong> {3}<br>' ..
                        '<strong>出生日期:</strong> {4}<br>' ..
                        '<strong>身高:</strong> {5} cm<br>' ..
                        '<font color="#f7f54f">────────••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#f7f54f"><strong>──────── 驾驶证 ────────</strong></font><br>' ..
                '<strong>姓名:</strong> {1} {2}<br>' ..
                '<strong>性别:</strong> {3}<br>' ..
                '<strong>出生日期:</strong> {4}<br>' ..
                '<strong>身高:</strong> {5} cm<br>' ..
                '<font color="#f7f54f">────────••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)