C_Require(C_GetScriptPath() .. '\\utils\\util.luax')


function Init()
	
end

function OnPulse()
	
	try
	{
		main = function ()
			if Me.Combat() then
				return
			end
			local mob = WoWUnit.GetUnitByEntry(31146)
			if WoWObject.IsValid(mob) then
				CC.Pull(mob)
			end
			
			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end