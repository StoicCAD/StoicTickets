-- Registering a server event for issuing a ticket through the MDT
RegisterServerEvent('sendChatMessageToPlayer')
AddEventHandler('sendChatMessageToPlayer', function(targetPlayer, officerName, violation, fineAmount)
    local src = source  -- The source is the officer interacting with the MDT

    -- Validate if the target player exists using your player management system (like NDCore)
    local target = NDCore.getPlayer(targetPlayer)
    if not target then
        -- Notify the officer that the target player was not found
        TriggerClientEvent('ox_lib:notify', src, {
            id = 'errorNotification',
            title = 'Error',
            description = "Target player not found.",
            duration = 5000,
            position = 'top',
            type = 'error',
            style = { backgroundColor = '#FF0000', color = '#FFFFFF' },
            icon = 'times',
            iconColor = '#FFFFFF'
        })
        return
    end

    -- Insert ticket data into the database
    local char_id = targetPlayer  -- Assuming each player has a unique character ID related to nd_characters
    local sql = "INSERT INTO tickets (char_id, issued_by, issue_date, violation, fine_amount) VALUES (?, ?, NOW(), ?, ?)"
    MySQL.Async.execute(sql, {char_id, officerName, violation, fineAmount}, function(rowsChanged)
        if rowsChanged > 0 then
            -- Notify success
            TriggerClientEvent('ox_lib:notify', src, {
                id = 'ticketIssuanceSuccess',
                title = 'Ticket Issued',
                description = "You have successfully issued a ticket for " .. violation .. ". Invoice of $" .. fineAmount .. " sent.",
                duration = 5000,
                position = 'top',
                type = 'success',
                style = { backgroundColor = '#4BB543', color = '#FFFFFF' },
                icon = 'check',
                iconColor = '#FFFFFF'
            })

            -- Create invoice from the Government to the target player
            local from = {
                name = "Government",
                account = "0"
            }
            local to = {
                character = target.id  -- Assuming each player has a unique character ID
            }

            -- Create the invoice using the ND_Banking resource
            local banking = exports["ND_Banking"]
            banking:createInvoice(fineAmount, 7, false, from, to)

            -- Setup data for the notification to the target player
            local notificationData = {
                id = 'uniqueTicketNotification',  -- Ensure this is unique if needed to avoid spam
                title = 'Ticket Issued',          -- Title of the notification
                description = officerName .. " has issued you a ticket for " .. violation .. " with a fine of $" .. fineAmount,
                duration = 5000,                  -- Duration in milliseconds
                position = 'top',                 -- Position on screen
                type = 'error',                   -- Type of notification
                style = {
                    backgroundColor = '#141517',  -- Background color
                    color = '#C1C2C5',            -- Text color
                    ['.description'] = {
                        color = '#909296'        -- Description text color
                    }
                },
                icon = 'ban',                     -- FontAwesome icon
                iconColor = '#C53030'             -- Color of the icon
            }

            -- Triggering the client event with the notification data for the target player
            TriggerClientEvent('ox_lib:notify', targetPlayer, notificationData)
        else
            -- Notify failure
            TriggerClientEvent('ox_lib:notify', src, {
                id = 'ticketIssuanceFailure',
                title = 'Ticket Issue Failed',
                description = "Failed to issue a ticket.",
                duration = 5000,
                position = 'top',
                type = 'error',
                style = { backgroundColor = '#FF0000', color = '#FFFFFF' },
                icon = 'times',
                iconColor = '#FFFFFF'
            })
        end
    end)
end)
