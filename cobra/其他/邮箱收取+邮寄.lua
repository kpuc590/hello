C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

--背包名字(自动装备背包)
BagName='深海背包'
--邮箱entry
MailboxEntry = 123
--邮箱坐标
MailboxLoc = Vector3:new(x, y, z)

function Init()
	Log('取出邮箱，并且邮寄，注意身上不要有太多已经装备过的BOE，这样会造成误判')
	Log('请自行修改脚本参数')
	ScriptSettings.CheckStuck(false)
end

function OnPulse()
	
	try
	{
		main = function ()
			
			
			if WowApi.GetBagItemCount(BagName) > 0 then
				Log('发现' .. BagName)
				WowApi.UseItem2(BagName)
				Sleep(500)
				Lua.DoString('StaticPopup1Button1:Click()')
				Sleep(500)
				return
			end
			Log('取邮件')
			WowApi.PickMail(MailboxEntry, MailboxLoc)
			
			local items = {}
			local bagCount = WowApi.GetBagCount()
			--local  _, _, _, _, _, _, _, _,_, _, _, _, _, bindType= GetItemInfo(GetContainerItemLink(0,1)) return bindType
			for i=0, bagCount-1 do
				local slotCount = tonumber(Lua.GetReturnValuesSingle('return GetContainerNumSlots(' .. i .. ')'))
				for j=1, slotCount do
					local itemName, bindType = Lua.GetReturnValues('local itemLink=GetContainerItemLink(' .. i .. ',' .. j .. ') if itemLink == nil then return nil,nil end  local  itemName, _, _, _, _, _, _, _,_, _, _, _, _, bindType= GetItemInfo(itemLink) return itemName,bindType')
					
					if bindType == '0' or bindType == '2' then
						table.insert(items, itemName)
					end
				end
			end
			Log('邮寄')
			WowApi.MailTo(MailboxEntry, items, nil, nil, true)
			return
			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end