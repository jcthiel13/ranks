local fw = exports.framework:getServerFunctions()

rank = {}

RegisterNetEvent('NAT2K15:CHECKSQL', function(steam, discord, first_name, last_name, twt, dept, dob, gender, data)
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM characters WHERE id = @id',{['@id'] = data.char_id}, function(result)
        SetServerRank(src, dept, result[1].rank)
    end)
end)

function GetRank(sid)
    return rank[sid]
end

function SetServerRank(sid, dept, newrank)
    local serverPlayers = exports.framework:geteverything()
    rank[sid] = {
        ['num'] = tonumber(newrank),
        ['dept'] = serverPlayers[sid].dept,
        ['name'] = cfg.rank[dept][newrank]
    }
end

function SetRank(from, toplayer, nrank, type)
    if (rank[toplayer] ~= nil) then
        local currank = GetRank(toplayer)
        local todept = currank.dept
        if type == 'set' then
            if (cfg.rank[todept][nrank] ~= nil) then
                SetServerRank(toplayer, todept, nrank)
                UpdateDatabase(toplayer, nrank, todept)
                ChatNotify(from, toplayer, 'setrank', nrank)
                if (cfg.notifydiscord) then
                    fromname = GetPlayerName(from)
                    toname = GetPlayerName(toplayer)
                    discord = exports.framework:sendtothediscord(0x0099ff, 'User\'s rank has been manually set!', fromname .. ' has just set ' .. toname .. '\'s rank to ' .. cfg.rank[todept][rank])
                end
            else
                ChatNotify(from, toplayer, 'norank', 'Rank Number does not exist, the value input was too high.')
            end
        elseif type == 'promote' then
            newrank = currank.num + 1
            if (cfg.rank[todept][newrank] ~= nil) then
                SetServerRank(toplayer, todept, newrank)
                UpdateDatabase(toplayer, newrank, todept)
                ChatNotify(from, toplayer, 'promoted', newrank)
                if (cfg.notifydiscord) then
                    fromname = GetPlayerName(src)
                    toname = GetPlayerName(toplayer)
                    discord = exports.framework:sendtothediscord(0x0099ff, 'User has been PROMOTED!', fromname .. ' has just promoted ' .. toname .. ' to ' .. cfg.rank[todept][newrank])
                end
            else
                ChatNotify(from, toplayer, 'norank', 'Rank Number does not exist, you are the highest rank.')
            end
        elseif type == 'demote' then
            newrank = currank.num - 1
            if (cfg.rank[todept][newrank] ~= nil) then
                SetServerRank(toplayer, todept, newrank)
                UpdateDatabase(toplayer, newrank, todept)
                ChatNotify(from, toplayer, 'demoted', newrank)
                if (cfg.notifydiscord) then
                    fromname = GetPlayerName(src)
                    toname = GetPlayerName(toplayer)
                    discord = exports.framework:sendtothediscord(0x0099ff, 'User has been DEMOTED!', fromname .. ' has just demoted ' .. toname .. ' to ' .. cfg.rank[todept][newrank])
                end
            else
                ChatNotify(from, toplayer, 'norank', 'Rank Number does not exist, you are the lowest rank.')
            end
        end
    else
        ChatNotify(from, toplayer, 'notonline', 'Player is not online')
    end
end

--*COMMANDS

RegisterCommand("rank", function(source, args, rawcommands)
    local src = source
    local rank = GetRank(src)
    TriggerClientEvent('chat:addMessage', src, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"RANKS", "Current Rank is: " .. rank.num .. " which means you are a " .. rank.name .. " with the " .. rank.dept}
    })
end, false)

RegisterCommand("promote", function(source, args, rawcommands)
    local serverPlayers = exports.framework:geteverything()
    local from = source
    local to = tonumber(args[1])
    if (serverPlayers[from].admin) then
        SetRank(from, to, 'nil', 'promote')
    else
        ChatNotify(from, toplayer, 'notadmin', 'Can not preform this function, you are not an admin.')
    end
end, false)

RegisterCommand("demote", function(source, args, rawcommands)
    local serverPlayers = exports.framework:geteverything()
    local from = source
    local to = tonumber(args[1])
    if (serverPlayers[from].admin) then
        SetRank(from, to, 'nil', 'demote')
    else
        ChatNotify(from, toplayer, 'notadmin', 'Can not preform this function, you are not an admin.')
    end
end, false)

RegisterCommand("setrank", function(source, args, rawcommands)
    local serverPlayers = exports.framework:geteverything()
    local from = source
    local to = tonumber(args[1])
    local rank = tonumber(args[2])
    if (serverPlayers[from].admin) then
        SetRank(from, to, rank, 'set')
    else
        ChatNotify(from, toplayer, 'notadmin', 'Can not preform this function, you are not an admin.')
    end
end, false)


function ChatNotify(from, to, message, data)
    if message == 'promoted' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "You have promoted " .. GetPlayerName(to) .. " to  " .. rank[to].name .. " with the " .. rank[to].dept}
        })
        TriggerClientEvent('chat:addMessage', to, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "You have been promoted to " .. rank[to].name .. " with the " .. rank[to].dept .. ", CONGRATULATIONS!"}
        })
    elseif message == 'demoted' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "You have demoted " .. GetPlayerName(to) .. " to  " .. rank[to].name .. " with the " .. rank[to].dept}
        })
        TriggerClientEvent('chat:addMessage', to, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "You have been demoted to " .. rank[to].name .. " with the " .. rank[to].dept}
        })
    elseif message == 'setrank' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "You have set " .. GetPlayerName(to) .. "\'s rank to  " .. rank[to].name .. " with the " .. rank[to].dept}
        })
        TriggerClientEvent('chat:addMessage', to, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", "Your rank has been manually set to " .. rank[to].name .. " with the " .. rank[to].dept}
        })
    elseif message == 'norank' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", data}
        })
    elseif message == 'notadmin' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", data}
        })
    elseif message == 'notonline' then
        TriggerClientEvent('chat:addMessage', from, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"RANKS", data}
        })
    end
end

--*DATABASE FUNCTIONS

function UpdateDatabase(sid, rank, dept)
    if cfg.savemethod == 'charid' then
        local serverplayers = exports.framework:geteverything()
        local charid = serverplayers[sid].charid
        MySQL.Async.execute('UPDATE characters SET rank = ? WHERE id = ?', {rank, charid})
    elseif cfg.savemethod == 'discord' then
        local serverplayers = exports.framework:geteverything()
        local discordid = serverplayers[sid].discord
        MySQL.Async.execute('UPDATE characters SET rank = ? WHERE discord = ? AND dept = ?', {rank, discord, dept})
    elseif cfg.savemethod == 'steam' then
        local serverplayers = exports.framework:geteverything()
        local steamid = serverplayers[sid].steam
        MySQL.Async.execute('UPDATE characters SET rank = ? WHERE steamid = ? AND dept = ?', {rank, steamid, dept})
    else
        print('Invalid save method, please check your configuration!')
    end
end

exports('getallranks', function()
    return rank
end)
exports('GetRank', GetRank)
exports('SetRank', SetRank)