C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

--背包名字(自动装备背包)
BagName='深海背包'
--邮箱entry
MailboxEntry = 123
--邮箱坐标
MailboxLoc = Vector3:new(x, y, z)

function Init()
	Lua.DoString('C_WowTokenSecure.RedeemTokenConfirm()')
end

function OnPulse()
	
	try
	{
		main = function ()
	
			
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end