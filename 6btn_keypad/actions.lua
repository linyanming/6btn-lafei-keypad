--[[=============================================================================
    Lua Action Code

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.actions = "2016.01.08"
end

-- TODO: Create a function for each action defined in the driver

function LUA_ACTION.TemplateVersion()
	TemplateVersion()
end



function LUA_ACTION.Sync()
     LogTrace("LUA_ACTION.Sync")
     gKeypadProxy._SyncMode = true
end

function LUA_ACTION.SENDCOMMAND(tParams)
     LogTrace("LUA_ACTION.SENDCOMMAND")
	LogTrace(tParams)
	local cmd = tParams["CMD"]
	local command = tohex(cmd)
	hexdump(command)
     gKeypadProxy:AddToQueue(command)
end

function LUA_ACTION.SETID(tParams)
     LogTrace("LUA_ACTION.SETID")
	local deviceid = tParams["DEVICEID"]
	local cmd = gKeypadProxy:CommandPack(COMMAND.WRITE_CMD,BASEADDR.KEYPAD_BASE_ADDR,deviceid)
     hexdump(cmd)
	gKeypadProxy:SendCommandToDeivce(cmd)
	gKeypadProxy._SetID = tonumber(deviceid)
	StartTimer(gKeypadProxy._SetIDTimer)
end
