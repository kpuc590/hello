C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

--��������(�Զ�װ������)
BagName='�����'
--����entry
MailboxEntry = 123
--��������
MailboxLoc = Vector3:new(x, y, z)

function Init()
	Log('ȡ�����䣬�����ʼģ�ע�����ϲ�Ҫ��̫���Ѿ�װ������BOE���������������')
	Log('�������޸Ľű�����')
	ScriptSettings.CheckStuck(false)
end

function OnPulse()
	
	try
	{
		main = function ()
			
			
			if WowApi.GetBagItemCount(BagName) > 0 then
				Log('����' .. BagName)
				WowApi.UseItem2(BagName)
				Sleep(500)
				Lua.DoString('StaticPopup1Button1:Click()')
				Sleep(500)
				return
			end
			Log('ȡ�ʼ�')
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
			Log('�ʼ�')
			WowApi.MailTo(MailboxEntry, items, nil, nil, true)
			return
			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end