ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local FightBans = {}
AddEventHandler("esx:playerLoaded", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local BannedAlready = false
	for a, b in pairs(FightBans) do
		for c, d in pairs(b) do
			if d.Steam == xPlayer.identifier then
				if os.time() < tonumber(d.Expire) then
					BannedAlready = true
					break
				else
					break
				end
			end
		end
	end
	if BannedAlready then
		FightBan(source)
	end
end)

function FightBan(source)
	TriggerClientEvent("xC_FightBan:Notif", source, true)
end

function UnFightBan(Steam)
	local Steam = Steam
	MySQL.Async.fetchAll("SELECT Steam FROM fightbans WHERE Steam = @Steam", {
		["@Steam"] = Steam
	}, function(data)
		if data[1] then
			MySQL.Async.execute("UPDATE fightbans SET isBnaned = @isBnaned, Expire = @Expire WHERE Steam = @Steam", {
				["@isBnaned"] = 0,
				["@Steam"] = Steam,
				["@Expire"] = 0
			})
			SetTimeout(5000, function()
				ReloadBans()
			end)
		end
	end)
	if ESX.GetPlayerFromIdentifier(Steam) then
		TriggerClientEvent("xC_FightBan:Notif", (ESX.GetPlayerFromIdentifier(Steam)).source, false)
	end
end

function CreatheFightBan(target, day)
	local xPlayer = ESX.GetPlayerFromId(target)
	local time = os.time() + day * 86400
	MySQL.Async.execute("INSERT INTO fightbans (Steam, isBnaned , Expire) VALUES (@Steam, @isBnaned , @Expire)", {
		["@Steam"] = xPlayer.identifier,
		["@Expire"] = time,
		["@isBnaned"] = 1
	})
    TriggerClientEvent('esx:showNotification', target, "Shoma Be Modat ~o~" ..day.. "~w~ Rooz Fight Ban Shodid")
	TriggerClientEvent("xC_FightBan:Notif", target, true)
end

function ReloadBans()
	CreateThread(function()
		FightBans = {}
		MySQL.Async.fetchAll("SELECT * FROM fightbans", {}, function(info)
			for i = 1, #info do
				if info[i].isBnaned == 1 then
					Wait(2)
					table.insert(FightBans, {
						info[i]
					})
				end
			end
		end)
	end)
end

ReloadBans()
TriggerEvent("es:addAdminCommand", "fightban", 5, function(source, args, user)
	if tonumber(args[1]) and tonumber(args[2]) then
		CreatheFightBan(tonumber(args[1]), tonumber(args[2]))
		TriggerClientEvent("chat:addMessage", source, {args = {"[ System ]","Player Fight Ban Shod."}})
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {args = {"[ System ]","Insufficient Permissions."}})
end, {
	help = "Fight Ban Player",
	params = {
		{
			name = "Player ID",
			help = "ID Ra Vared Konid "
		},
		{
			name = "Day",
			help = "Teadad Rozi ke Player Fight Ban Shavd"
		}
	}
})

TriggerEvent("es:addAdminCommand", "unfightban", 5, function(source, args, user)
	if tostring(args[1]) then
		UnFightBan(tostring(args[1]))
		TriggerClientEvent("chat:addMessage", source, {args = {"[ System ]","Player Ba Steam hex : " .. tostring(args[1]) .. " unfight ban shod"}})
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {args = {"[ System ]","Insufficient Permissions."}})
end, {
	help = "Fight Ban Player",
	params = {
		{
			name = "Steam Hex",
			help = "Steam Hex Ra Vared Konid "
		}
	}
})

TriggerEvent("es:addAdminCommand", "reloadfightban", 5, function(source, args, user)
	ReloadBans()
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {args = {"[ System ]","Insufficient Permissions."}})
end, {
	help = " ReloadFight Bans ",
	params = {}
})
