ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local webhook = 'https://discord.com/api/webhooks/964481641626083348/ghqtDUkp9Uj7hOOMC-xzYMHhaqavK-XPdsn8_jZcUeduOn3pa1BqKOjAZG1zPUY06V50'

function gingerBreadEasterLogs(source)
    sendToDiscord("Ginger Bread Reporting!", GetPlayerName(source).." tried to redeem morethan 1 free easter egg - "..os.date("%Y/%m/%d %X") )
end

function gingerBreadEasterLogsNodata(source)
    sendToDiscord("Ginger Bread Reporting!", GetPlayerName(source).." tried to collect egg without any data - "..os.date("%Y/%m/%d %X") )
end

function sendToDiscord(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "".. name .."",
              ["description"] = args,
              ["footer"] = {
              ["text"] = "Made by Ginger Bread",
              },
          }
      }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Ginger Bread Report", embeds = connect, avatar_url = "https://cdn.discordapp.com/attachments/960051728277995520/960052105903755284/s-l1600.jpg"}), { ['Content-Type'] = 'application/json' })
end