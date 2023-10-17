-- Config all --

local webhookAll = "PLACE_HERE_YOUR_WEBHOOK" -- Replace with your Discord webhook URL

-- Config one per one -- 
local webhookJoin = "PLACE_HERE_YOUR_WEBHOOK" -- Replace with your Discord webhook URL
local webhookLeave = "PLACE_HERE_YOUR_WEBHOOK" -- Replace with your Discord webhook URL
local name = "Z-Logs System"
local logo = "https://imgur.com/aZIMrO9.jpg" -- Replace if you want


-- Function to send the embed message to the Discord webhook --
local function sendEmbedMessage(webhook, embed)
    PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({ username = name, embeds = { embed } }), { ['Content-Type'] = 'application/json' })
end

-- Function to extract player identifiers --
local function ExtractIdentifiers(playerId)
    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)

        if string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "license:") then
            identifiers['license'] = id
        elseif string.find(id, "license2:") then
            identifiers['license2'] = id
        end
    end

    return identifiers
end

-- Function to format IP as spoiler --
local function formatSpoiler(text)
    return "||" .. text .. "||"
end

-- Event when a player is connecting to the server --
AddEventHandler('playerConnecting', function()
    local playerId = source
    local playerName = GetPlayerName(playerId) -- Get the player's name
    local playerIp = GetPlayerEndpoint(playerId) -- Get the player's IP
    local playerPing = GetPlayerPing(playerId) -- Get the player's ping
    local playerServerId = playerId -- Get the player's server ID
    local identifiers = ExtractIdentifiers(playerId) -- Get the player's identifiers

    -- Create an embed message for the connecting player --
    local connectingEmbed = {
        title = ":arrow_right: | Player Connecting",
        color = 65280, -- Green
        fields = {
            { name = ":bust_in_silhouette: | Name", value = playerName },
            { name = ":globe_with_meridians: | IP", value = formatSpoiler(playerIp) },
            { name = ":speech_balloon: | Discord", value = identifiers['discord'] or "N/A" },
            { name = ":video_game: | Steam", value = identifiers['steam'] or "N/A" },
            { name = ":signal_strength: | Ping", value = playerPing },
            { name = ":id: | Server ID", value = playerServerId },
            { name = ":key: | License", value = identifiers['license'] or "N/A" },
            { name = ":key2: | License 2", value = identifiers['license2'] or "N/A" }
        },
        footer = {
            text = name,
            icon_url = logo
        }
    }

    sendEmbedMessage(webhookJoin, connectingEmbed)
    sendEmbedMessage(webhookAll, connectingEmbed)
end)

-- Event when a player disconnects from the server --
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local playerName = GetPlayerName(playerId) -- Get the player's name
    local playerIp = GetPlayerEndpoint(playerId) -- Get the player's IP
    local playerPing = GetPlayerPing(playerId) -- Get the player's ping
    local playerServerId = playerId -- Get the player's server ID
    local identifiers = ExtractIdentifiers(playerId) -- Get the player's identifiers

    -- Create an embed message for the disconnecting player --
    local disconnectingEmbed = {
        title = ":arrow_left: Player Disconnected",
        color = 16711680, -- Red
        fields = {
            { name = ":bust_in_silhouette: | Name", value = playerName },
            { name = ":globe_with_meridians: | IP", value = formatSpoiler(playerIp) },
            { name = ":speech_balloon: | Discord", value = identifiers['discord'] or "N/A" },
            { name = ":video_game: | Steam", value = identifiers['steam'] or "N/A" },
            { name = ":signal_strength: | Ping", value = playerPing },
            { name = ":id: | Server ID", value = playerServerId },
            { name = ":key: | License", value = identifiers['license'] or "N/A" },
            { name = ":key2: | License 2", value = identifiers['license2'] or "N/A" }
        },
        footer = {
            text = name,
            icon_url = logo
        }
    }

    sendEmbedMessage(webhookLeave, disconnectingEmbed)
    sendEmbedMessage(webhookAll, disconnectingEmbed)
end)
