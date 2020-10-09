
function Log(a)
	C_Log(tostring(a))
end

--系统当前毫秒
function GetMilliseconds()
	return C_GetMilliseconds();
end

--定时器
Stopwatch = { _startTime, _pauseTime, _isReset, IsRunning , IsPause}

function Stopwatch:new(started)
	local self = {}
	setmetatable(self, Stopwatch)
	Stopwatch.__index = Stopwatch
	
	self._startTime = 0
	self._pauseTime = 0
	self._isReset = true
	self.IsRunning = false
	self.IsPause = false
	started = started or false
	
	if not started then
		self.IsRunning = false
	else		
		self._startTime = GetMilliseconds()
	end
	self.IsRunning = started
	
	return self
end

function Stopwatch:TotalMilliseconds()	
	if not self.IsRunning then
		return 0
	end
	return GetMilliseconds() - self._startTime
end

function Stopwatch:TotalSeconds()	
	return self:TotalMilliseconds() / 1000
end

function Stopwatch:TotalMinutes()	
	return self:TotalSeconds() / 60
end

function Stopwatch:TotalHours()	
	return self:TotalMinutes() / 60
end

function Stopwatch:Start()
	if self.IsPause then
		self._startTime = self._pauseTime
	else
		self._startTime = GetMilliseconds()
	end
	self.IsRunning = true
	self.IsPause = false
end

function Stopwatch:Pause()
	self._pauseTime = GetMilliseconds()
	self.IsRunning = false
	self.IsPause = true
end

function Stopwatch:Stop()
	self.IsRunning = false
	self.IsPause = false
	self._startTime = 0
end

function Stopwatch:Reset()
	self.IsRunning = false
	self.IsPause = false
	self._startTime = GetMilliseconds()
end

function Stopwatch:Restart()
	self.IsRunning = true
	self.IsPause = false
	self._startTime = GetMilliseconds()
end
--定时器

--[[function haha(a, b)
	local c = a + b
	local d = a - b
	--Log(coroutine.running ())
	coroutine.yield(c, d)
	local c22 = 1
	
end

local co = nil

function OnPulse()
	if co == nil then
		co = coroutine.wrap(haha)
	end
	
	if coroutine.status(co) == 'suspended' then
		--Log(coroutine.running ())
		local status, d,e = coroutine.resume(co, 3, 2)
		Log(status)
	elseif coroutine.status(co) == 'dead' then
		--co = nil
	else
		Log(coroutine.status(co))
		
	end
	
end--]]

local sleepMillis = 0
local swSleep = Stopwatch:new()

function Sleep(a)
	sleepMillis = a
	swSleep:Restart()
	coroutine.yield()
end

function LuaDoString(a)
	C_LuaDoString(a)
end

function LuaGetReturnValues(a, paramCount)
	paramCount = paramCount or 20
	return C_GetReturnValues(a, paramCount)
end

co = coroutine.create(function ()
	while true do
		Log(111)
		Sleep(2000)
		local swTime = Stopwatch:new(true)
		local c 
		for i=1,1000 do
			c = LuaGetReturnValues('return 123')
		end
		Log('c=' .. tostring(c))
		Log(swTime:TotalMilliseconds())
		--逻辑部分
		--XXXXXXXXXXXXXXXXXXXXXXXX
		coroutine.yield()
	end
end)

function OnPulse()
	if swSleep.IsRunning and swSleep:TotalMilliseconds() < sleepMillis then
		return
	else
		swSleep:Reset()
		sleepMillis = 0
	end
	coroutine.resume(co)
end