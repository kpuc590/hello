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
			if Me.Combat() then
				local cur = CC.GetFightUnit()
				if not WoWObject.IsValid(cur) then
					Log('set tar')
					local o = WoWObject.GetByEntry(46647)
					CC.Pull(o)
				end
				return
			end
			--[[local file = io.open(C_GetScriptPath() .. "\\test.lua", "rb")
			WaitTimer(100000)
			if file then 
				Log('close file')
				file:close() 
			end--]]
			
			Quest.TurnIn(10342, 19617, nil, Vector3:new(3080.512207,3684.403320,142.449997))
			--Quest.PickUp(10342, 19617, nil, Vector3:new(3080.512207,3684.403320,142.449997))
			--Quest.PickUp(10701, 183811, nil, Vector3:new(3052.924072, 3693.169189, 142.897644), 'gameobject')
			--Log(Quest.GetQuestNameById(10701, 183811, 1))
			--Log(Quest.GetQuestNameById(10186, 19570, 1))
			StopGame()

			--Quest.GetQuestNameById(1)			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end