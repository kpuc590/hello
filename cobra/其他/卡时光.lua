C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

--��������(�Զ�װ������)
BagName='�����'
--����entry
MailboxEntry = 123
--��������
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