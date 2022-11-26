fw = exports.framework:getClientFunctions()

--*Chat Suggestions
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/rank', 'Check your rank')

    TriggerEvent('chat:addSuggestion', '/promote', 'Promote a player', {
        { name="Server ID", help="Target of the promotion" }
    })
    
    TriggerEvent('chat:addSuggestion', '/demote', 'Demote a player', {
        { name="Server ID", help="Target of the demotion" }
    })

    TriggerEvent('chat:addSuggestion', '/setrank', 'Set the rank of a player', {
        { name="Server ID", help="Target of the demotion" },
        { name="Rank", help="Rank Number" }
    })
end)