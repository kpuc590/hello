C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

function Init()
	Log('任务测试')
	ScriptSettings.CheckGmTransfer(false)
	ScriptSettings.CanCombat(false)
end

function TargetHasDebuffFromMe(name)
	local isMe = Lua.GetReturnValuesSingle('return select(7, AuraUtil.FindAuraByName("' .. name .. '", "target", "HARMFUL"))')
	if isMe == 'nil' then
		return false
	end
	return true
end

function TargetHasAuraFromMe(name)
	local isMe = Lua.GetReturnValuesSingle('return select(7, AuraUtil.FindAuraByName("' .. name .. '", "target"))')
	if isMe == 'nil' then
		return false
	end
	return true
end

function MyAuraCount(name)
	local count = Lua.GetReturnValuesSingle('return select(3, AuraUtil.FindAuraByName("' .. name .. '", "player"))')
	if count == 'nil' then
		return 0
	end
	return tonumber(count)
end

local swXingchengyaoban = Stopwatch:new(true)
local swMingyuedaji = Stopwatch:new(true)

function GetRaidLowestHealthPercentName()
	local lua = "\
		local cur = 1	\
		local index = 0	\
		for i = 1, 25 do	\
			local maxHealth = UnitHealthMax('raid' .. i)	\
			if maxHealth ~= 0 then	\
				local percent = UnitHealth('raid' .. i) / maxHealth	\
				if percent < 1 and cur > percent and percent > 0 then	\
					cur = percent	\
					index = i	\
				end	\
			end	\
		end		\
		if index ~= 0 then	\
			return UnitName('raid' .. index), cur * 100	\
		end	\
		return '',nil	\
	"
	return Lua.GetReturnValues(lua)
end

local leaderName = nil

function TargetDistance()
	local _x, _y = Lua.GetReturnValues('return UnitPosition("target")')
	return Distance2D(Me.Location(), Vector3:new(tonumber(_x), tonumber(_y), 0))
end

local swBaihuaqifang = Stopwatch:new()

function CCHealer()	
	
	local name, _percent = GetRaidLowestHealthPercentName()
	if name ~= '' then
		local percent = tonumber(_percent)
		if not swBaihuaqifang.IsRunning or swBaihuaqifang:TotalSeconds() > 30 then
			Sleep(800)
			SpellManager.Cast('百花齐放')
			Sleep(200)
			SpellManager.ClickRemoteLocation(Me.Location())
			swBaihuaqifang:Restart()
			return
		end
		Lua.RunMacro('/target ' .. name)
		if SpellManager.CastCoolDown('野性成长') then
			return
		end
		if name ~= leaderName then
			
			--队员			
			if percent < 90 then
				if not TargetHasAuraFromMe('回春术') then
					SpellManager.Cast('回春术')
					return
				end
				if not TargetHasAuraFromMe('愈合') then
					SpellManager.Cast('愈合')
					Sleep(500)
					WaitTimer(3000, 'not Me.IsCasting()')
					return
				end
			end
		else
			--坦克
			if SpellManager.IsCoolDown('塞纳里奥结界') then
				SpellManager.Cast('塞纳里奥结界')
			end
			if not TargetHasAuraFromMe('回春术') then
				SpellManager.Cast('回春术')
				return
			end
			if not TargetHasAuraFromMe('生命绽放') then
				SpellManager.Cast('生命绽放')
				return
			end
			if not TargetHasAuraFromMe('愈合') then
				SpellManager.Cast('愈合')
				Sleep(500)
				WaitTimer(3000, 'not Me.IsCasting()')
				return
			end
			
			
		end
		
	end
end

function CCDps(mob)
	if not Me.HasAuraByID(24858) then
		SpellManager.CastSpellByID(24858)
		return
	end
	WoWUnit.Face(mob)
	WoWUnit.Target(mob)
	
	local power = tonumber(Lua.GetReturnValuesSingle('return UnitPower("player")'))
	
	if SpellManager.CastCoolDown('火红烈焰') then
		return	
	end
	
	if not TargetHasDebuffFromMe('月火术') then
		SpellManager.Cast('月火术')
		return
	end
	
	if not TargetHasDebuffFromMe('阳炎术') then
		SpellManager.Cast('阳炎术')
		return
	end
	
	if swXingchengyaoban:TotalSeconds() > 3 then
		if not TargetHasDebuffFromMe('星辰耀斑') then
			SpellManager.Cast('星辰耀斑')
			return
		end
		swXingchengyaoban:Restart()
	end
	
	
	if power > 40 then
		if SpellManager.CastCoolDown('超凡之盟') then
			return
		end
		SpellManager.Cast('星涌术')
		return
	end
	
	
	if MyAuraCount('月光增效') > 1 then
		SpellManager.Cast('明月打击')
		swMingyuedaji:Restart()
		return
	end
	
	
	
	SpellManager.Cast('阳炎之怒')
end

function CCTank(mob)
	if Distance2D(Me.Location(), WoWObject.Location(mob)) > 6 then
		WoWMovement.MoveTo(WoWObject.Location(mob), nil, nil, nil, 'Distance2D(Me.Location(), WoWObject.Location(mob)) < 5')
	end
	
	if not Me.HasAura('熊形态') then
		SpellManager.Cast('熊形态')
		return
	end
	
	local power = tonumber(Lua.GetReturnValuesSingle('return UnitPower("player", 1)'))
	local healthPercent = Me.HealthPercent()
	if (power >= 80 and healthPercent < 80 and not Me.HasAuraByID(192081)) then	
		--铁鬃
		SpellManager.CastCoolDownByID(192081);
	end
	
	if (healthPercent < 60 and power >= 20) then	
		--狂暴回复
		if (not Me.HasAuraByID(22842)) then
		
			if (SpellManager.CastCoolDownByID(22842)) then
				return
			end
		end
	end
	
	--明月普照
	if (healthPercent < 80 and SpellManager.CastCoolDownByID(204066)) then	
		return
	end
	
	--血量
	if (healthPercent < 60) then	
		--树皮术
		SpellManager.CastCoolDownByID(22812);
	end
	if (healthPercent < 40) then	
		--生存本能
		if (not Me.HasAuraByID(61336)) then
		
			SpellManager.CastCoolDownByID(61336);
		end
	end
	
	--痛击
	if (SpellManager.CastCoolDownByID(77758)) then	
		return;
	end
	--裂伤
	if (SpellManager.CastCoolDownByID(33917)) then	
		return;
	end
	
	--星河守护者
	if (Me.HasAuraByID(213708)) then
	
		--月火术
		if (SpellManager.CastCoolDownByID(8921)) then		
			return;
		end
	end
	
	if SpellManager.CastCoolDown('蛮力猛击') then
		return
	end

	--横扫
	SpellManager.CastCoolDownByID(213764);--]]
end

function OnPulse()
	
	try
	{
		main = function ()
			if leaderName == nil then
				leaderName = WowApi.LeaderName2()
			end
			--CCHealer()
			
			local mob = WoWUnit.GetMobByEntry(31146)	
			if WoWObject.IsValid(mob) then
				CCTank(mob)
			end
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end