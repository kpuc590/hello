C_Require(C_GetScriptPath() .. '\\utils\\util.luax')

--��������(�Զ�װ������)
BagName='�����'
--����entry
MailboxEntry = 123
--��������
MailboxLoc = Vector3:new(x, y, z)

function Init()
	
end

function OnPulse()
	
	try
	{
		main = function ()
			
			WowApi.UpdatePlayerGold('Destinybwmvg', 'The Scryers', '1234567')
			StopGame()
		end,
		catch = function (errors)
			
		end,
		finally = function (ok, errors)
			
		end,
	}
end