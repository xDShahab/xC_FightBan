ESX = nil 
CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
	Wait(0)
	end
end) 

local FightBan = false 
function SetPlayerBan()
	CreateThread(function()
		while true do 
			SetCurrentPedWeapon(PlayerPedId()  , GetHashKey("WEAPON_UNARMED"), true)      
			Wait(5)         
		end 
	end)
end 

RegisterNetEvent('xC_FightBan:Notif')
AddEventHandler('xC_FightBan:Notif', function(FightBan,time) 
	FightBan = FightBan 
	if FightBan == true then 
		SetPlayerBan()
	else 
		ESX.ShowNotification("Shoma Az FightBan Remove Shodid")
	end 
end)