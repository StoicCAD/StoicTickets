RegisterNUICallback('sendTicketData', function(data, cb)
    local targetPlayer = tonumber(data.target_id)
    local officerName = data.officer_name
    local badgeNumber = data.badge_number
    local violation = data.violation
    local fineAmount = data.fine_amount

    -- Sending a chat message to the specified player (by server ID)
    TriggerServerEvent('sendChatMessageToPlayer', targetPlayer, officerName, violation, fineAmount)
end)
