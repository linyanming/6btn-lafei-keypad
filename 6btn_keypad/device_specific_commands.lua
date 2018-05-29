--[[=============================================================================
    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_specific_commands = "2016.01.08"
end

--[[=============================================================================
    ExecuteCommand Code

    Define any functions for device specific commands (EX_CMD.<command>)
    received from ExecuteCommand that need to be handled by the driver.
===============================================================================]]
--function EX_CMD.NEW_COMMAND(tParams)
--	LogTrace("EX_CMD.NEW_COMMAND")
--	LogTrace(tParams)
--end

function EX_CMD.BTNPRESS(tParams)
	LogTrace("EX_CMD.BTNPRESS")
	LogTrace(tParams)
	local buttonid = tParams["BUTTON_ID"]
	local cmd = {}
     cmd.BUTTON_ID = buttonid
     cmd.ACTION = 1
	NOTIFY.KEYPAD_BUTTON_ACTION(gKeypadProxy._BindingID,cmd)
	cmd.ACTION = 2
	NOTIFY.KEYPAD_BUTTON_ACTION(gKeypadProxy._BindingID,cmd)
end

function EX_CMD.RECVMSG(tParams)
    LogTrace("EX_CMD.RECVMSG")
	LogTrace(tParams)
	local msg = tParams["MESSAGE"]
	local tmp_msg = ""
	if(msg ~= nil and msg ~= "") then
	    local msglen = #msg/2
	    local message = string.lower(msg)
	    for i = 1,msglen do
	        local temp = 0
	        local tab = (i - 1)*2 + 1
            if(string.byte(message,tab) >= string.byte("a")) then
                temp = temp + (string.byte(message,tab) - string.byte("a") + 10) * 16
            else
                temp = temp + (string.byte(message,tab) - string.byte("0")) * 16
            end
            if(string.byte(message,tab+1) >= string.byte("a")) then
                temp = temp + (string.byte(message,tab+1) - string.byte("a") + 10)
            else
                temp = temp + (string.byte(message,tab+1) - string.byte("0"))
            end            
            print(temp)
            tmp_msg = tmp_msg .. string.pack("b",temp)
	    end
	    gKeypadProxy:HandleMessage(tmp_msg,msglen)
	end
end