C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

function Init()
	Log('系统消息事件')
	ScriptSettings.CheckGmTransfer(false)
end

local swInterval = Stopwatch:new()

function OnPulse()
	
	try
	{
		main = function ()
			if not swInterval.IsRunning or swInterval:TotalSeconds() > 1 then
				Lua.DoString('\
					if systemMsgList == nil then systemMsgList={} \
					if systemMsgFrame == nil then\
						systemMsgFrame = CreateFrame("Frame")\
						local isRegistered = systemMsgFrame:IsEventRegistered("CHAT_MSG_SYSTEM");\
						if isRegistered == false then\
							systemMsgFrame:RegisterEvent("CHAT_MSG_SYSTEM")\
							function onSystemMsg(a,b,msg)\
								if string.find(msg, "你在短时间内进入副本的次数过多") ~= nil then\
									table.insert(systemMsgList, msg)\
								end\
							end\
							systemMsgFrame:SetScript("OnEvent", onSystemMsg)\
						end	\
					end end\
				');
				swInterval:Restart()
			end
			
			
			local systemMsgStr = Lua.GetReturnValuesSingle("if systemMsgList == nil then return '' end local a = '' for i,v in ipairs(systemMsgList) do a=a..v..';;##' end systemMsgList={} return a");
			if systemMsgStr ~= nil and systemMsgStr ~= '' then
				local tbMsg = string.split(systemMsgStr , ';;##')
				if tbMsg ~= nil  and #tbMsg > 0 then
					for i=1, #tbMsg do
						local cur = tbMsg[i]
						if cur ~= '' then
							Log(cur)
						end
					end
				end
			end
			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end