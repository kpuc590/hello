C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

function Init()
	Log('»ŒŒÒ≤‚ ‘')
	ScriptSettings.CheckGmTransfer(false)
end

local swInterval = Stopwatch:new()

function OnPulse()
	
	try
	{
		main = function ()
			WowApi.DestroyBagItemsByWhiteList({})
			
			local loot = WowApi.GetLootUnit(10)
			if WoWObject.IsValid(loot) then
				WoWUnit.Loot(loot)
				WowApi.LootAll()
			end
			if Me.Combat() then
				SpellManager.Cast('√Õª˜')
				Sleep(50)
				return
			end
			if Me.HealthPercent() < 20 then
				return
			end
			local a =  WoWUnit.GetMobAround(Vector3:new(-492.854919, -4341.457031, 38.829273), 30)			
			if WoWObject.IsValid(a) then
				WoWMovement.NavigatorToNpc(a)
				CC.Pull(a)
			end
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end