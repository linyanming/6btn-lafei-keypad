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
	   tmp_msg = tohex(msg)
	   LogTrace("_MsgPos = %d",gKeypadProxy._MsgPos)
	   LogTrace("_sendMsgPos = %d",gKeypadProxy._MsgSendPos)
	   hexdump(tmp_msg)
	   if(#tmp_msg <= gKeypadProxy._MaxMsgLength) then
		  LogTrace("#tmp_msg <= gKeypadProxy._MaxMsgLength")
		  gKeypadProxy._MsgTable[gKeypadProxy._MsgPos] = tmp_msg
		  if(gKeypadProxy._MsgPos == gKeypadProxy._MsgTableMax) then
			 gKeypadProxy._MsgPos = 1
		  else
			 gKeypadProxy._MsgPos = gKeypadProxy._MsgPos + 1
		  end
	   else
		  while(#tmp_msg > gKeypadProxy._MaxMsgLength)
		  do
			 LogTrace("#tmp_msg > gKeypadProxy._MaxMsgLength")
			 local pos,devid,cmd = string.unpack(tmp_msg,"bb")
			 local command = nil
			 if(cmd == COMMAND.BTN_WRITE_CMD) then
				command = string.sub(tmp_msg,1,10)
				tmp_msg = string.sub(tmp_msg,11,#tmp_msg)
			 else
				command = string.sub(tmp_msg,1,8)
				tmp_msg = string.sub(tmp_msg,9,#tmp_msg)
			 end
			 LogTrace("_MsgPos = %d",gKeypadProxy._MsgPos)
			 gKeypadProxy._MsgTable[gKeypadProxy._MsgPos] = command
			 if(gKeypadProxy._MsgPos == gKeypadProxy._MsgTableMax) then
				gKeypadProxy._MsgPos = 1
			 else
				gKeypadProxy._MsgPos = gKeypadProxy._MsgPos + 1
			 end		  
			 LogTrace("command = ")
			 hexdump(command)
			 hexdump(tmp_msg)
		  end
		  LogTrace("_MsgPos = %d",gKeypadProxy._MsgPos)
	      LogTrace("_sendMsgPos = %d",gKeypadProxy._MsgSendPos)
		  gKeypadProxy._MsgTable[gKeypadProxy._MsgPos] = tmp_msg
		  if(gKeypadProxy._MsgPos == gKeypadProxy._MsgTableMax) then
			 gKeypadProxy._MsgPos = 1
		  else
			 gKeypadProxy._MsgPos = gKeypadProxy._MsgPos + 1
		  end
	   end
	end
end