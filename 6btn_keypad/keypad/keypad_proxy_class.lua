--[[=============================================================================
    Keypad Proxy Class

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.keypad_proxy_class = "2018.05.23"
end

KeypadProxy = inheritsFrom(nil)

function KeypadProxy:construct(bindingID)
	-- member variables
	self._BindingID = bindingID

	self:Initialize()

end

function KeypadProxy:Initialize()
	-- create and initialize member variables
--    self._PackLen = 8
	self._SyncDevid = Properties["DeviceID"]
	self._SyncMode = false
	self._PressTimes = 0
	self._SyncFirstCode = 0
	self._MaxMsgLength = 10
	self._MsgTable = {}
	self._MsgPos = 1
	self._MsgSendPos = 1
	self._MsgTableMax = 100
	self._MsgSync = false
	
	self._CmdTable = {}
	self._CmdPos = 1
	self._CmdSendPos = 1
	self._CmdTableMax = 100
	self._CmdSync  = false
	
	self._Timer = CreateTimer("SYNC_DEVID", 3, "SECONDS", TimerCallback, false, nil)
	self._MsgTimer = CreateTimer("MSG_PROCESS", 50, "MILLISECONDS", MsgTimerCallback, true, nil)
	self._CmdTimer = CreateTimer("CMD_PROCESS", 50, "MILLISECONDS", CmdTimerCallback, true, nil)
	self._CmdCnfTimer = CreateTimer("CMD_CONFIRM", 200, "MILLISECONDS", CmdCnfTimerCallback, false, nil)
end

function CmdCnfTimerCallback()
    LogTrace("confirm fail")
    gKeypadProxy:SendCommandToDeivce(gKeypadProxy._CmdTable[gKeypadProxy._CmdSendPos])
    gKeypadProxy._CmdTable[gKeypadProxy._CmdSendPos] = ""
    if(gKeypadProxy._CmdSendPos == gKeypadProxy._CmdTableMax) then
	   gKeypadProxy._CmdSendPos = 1
    else
	   gKeypadProxy._CmdSendPos = gKeypadProxy._CmdSendPos + 1
    end
    gKeypadProxy._CmdSync = false
end

function CmdTimerCallback()
    if(gKeypadProxy._CmdTable[gKeypadProxy._CmdSendPos] ~= nil and gKeypadProxy._CmdTable[gKeypadProxy._CmdSendPos] ~= "" and gKeypadProxy._CmdSync ~= true) then
	   gKeypadProxy._CmdSync = true
	   gKeypadProxy:SendCommandToDeivce(gKeypadProxy._CmdTable[gKeypadProxy._CmdSendPos])
	   StartTimer(gKeypadProxy._CmdCnfTimer)
    end
end

function MsgTimerCallback()
    if(gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos] ~= nil and gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos] ~= "" and gKeypadProxy._MsgSync ~= true) then
	   gKeypadProxy._MsgSync = true
	   LogTrace("MsgTimerCallback 1 _sendMsgPos = %d",gKeypadProxy._MsgSendPos)
	   hexdump(gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos])
	   gKeypadProxy:HandleMessage(gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos],#gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos])
	   gKeypadProxy._MsgTable[gKeypadProxy._MsgSendPos] = ""
	   if(gKeypadProxy._MsgSendPos == gKeypadProxy._MsgTableMax) then
		  gKeypadProxy._MsgSendPos = 1
	   else
		  gKeypadProxy._MsgSendPos = gKeypadProxy._MsgSendPos + 1
	   end
	   LogTrace("MsgTimerCallback 2 _sendMsgPos = %d",gKeypadProxy._MsgSendPos)
	   gKeypadProxy._MsgSync = false
    end
end

function TimerCallback()
     LogTrace("TimerCallback")
     gKeypadProxy._SyncMode = false
	gKeypadProxy._PressTimes = 0
end

function KeypadProxy:dev_Newbuttoncreate(buttonid,buttonname)
	local new_button = {}
     new_button.BUTTON_ID = buttonid
	new_button.NAME = buttonname
	new_button.LOCK_COLORS = true

	NOTIFY.NEW_KEYPAD_BUTTON(self._BindingID, new_button)
end

BASEADDR = {KEYPAD_BASE_ADDR = 0x1000,
			BUTTON_BASE_ADDR = 0x1011,BUTTON_MAX_ADDR = 0x101F,
			LED_BASE_ADDR    = 0x1020,LED_MAX_ADDR    = 0x102F,
			RELAY_BASE_ADDR  = 0x1031,RELAY_MAX_ADDR  = 0x103F}
COMMAND = {READ_CMD = 0x03,WRITE_CMD = 0x06,BTN_WRITE_CMD = 0x20}
BUTTONDATA = {LEDOFF_PRESSED = 0x80,LEDOFF_RELEASED = 0xff,
              LEDON_PRESSED  = 0x00,LEDON_RELEASED  = 0x7f,
              LEDOFF_LONG_RELEASE = 0xfd,LEDOFF_LONG_PRESS = 0x81,LEDOFF_BTN_DEAD = 0xfe,
              LEDON_LONG_RELEASE  = 0x7d,LEDN_LONG_PRESS   = 0x01,LEDON_BTN_DEAD  = 0x7e
              }

--[[=====================================================================
Send Command To Device
parameters:
command:READ_CMD or WRITE_CMD  in COMMAND table
reg_addr:address in BASEADDR table 2bytes
reg_data:Register data 2bytes
=======================================================================]]

function KeypadProxy:SendCommandToDeivce(cmd)
    LogTrace("KeypadProxy:SendCommandToDeivce")
	local message = ""
	for i = 1,#cmd do
	    message = message .. string.format("%02x",string.byte(cmd,i))
	end
	local devid = C4:GetDeviceID()
	local id = C4:GetBoundProviderDevice(devid,BUS_BINDING_ID)
	print("Id is " .. id)
	C4:SendToDevice(id,"SENDCMD",{COMMAND = message})
end

function KeypadProxy:CommandPack(command,reg_addr,reg_data)
    LogTrace("KeypadProxy:CommandPack")
    local cmd = string.pack("bb>H>H",self._SyncDevid,command,reg_addr,reg_data)
    hexdump(cmd)
    local crccode = usMBCRC16(cmd,#cmd)
    cmd = cmd .. string.pack("H",crccode)
    hexdump(cmd)
    return cmd
end

function KeypadProxy:AddToQueue(command)
    LogTrace("KeypadProxy:AddToQueue")
    self._CmdTable[self._CmdPos] = command
    if(self._CmdPos == self._CmdTableMax) then
	   self._CmdPos = 1
    else
	   self._CmdPos = self._CmdPos + 1
    end
end

--[[=====================================================================
Control Button LED
parameters:
btnid:A number 0~15
state:0   OFF
	  1   ON
=======================================================================]]

function KeypadProxy:ButtonLedControl(btnid,state)
    LogTrace("KeypadProxy:ButtonLedControl")
	local led_reg_addr = BASEADDR.LED_BASE_ADDR + btnid
	if(led_reg_addr > BASEADDR.LED_MAX_ADDR) then
		return false
	end
	local cmd = self:CommandPack(COMMAND.WRITE_CMD,led_reg_addr,state)
	self:AddToQueue(cmd)
	return true
end


function KeypadProxy:HandleMessage(message,msglen)
    LogTrace("KeypadProxy:HandleMessage")
    LogTrace("msglen = %d",msglen)
    hexdump(message)
    local crccode = usMBCRC16(message,msglen-2)
    local cmddata = ""
    if(bit.rshift(crccode,8) == string.byte(message,msglen-2+2) and bit.band(crccode,0xff) == string.byte(message,msglen-2+1)) then
	   print("self._SyncMode = ")
	   print(self._SyncMode)
	   if(self._SyncMode == true) then
		  if(self._PressTimes == 0) then
			 self._SyncFirstCode = crccode
			 self._PressTimes = self._PressTimes + 1
			 StartTimer(self._Timer)
		  else
			 if(self._SyncFirstCode == crccode) then
				self._PressTimes = self._PressTimes + 1
			 end
		  end
		  if(self._PressTimes == 3) then
			 local device_id = string.byte(message,1)
			 KillTimer(self._Timer)
			 self._PressTimes = 0
			 self._SyncMode = false
			 UpdateProperty("DeviceID",device_id)
			 self._SyncDevid = device_id
		  end
	   else
		  local pos,devid,cmd,reg_addr = string.unpack(message,"bb>H")
		  local datalen,data
		  if(devid == self._SyncDevid) then
			 cmddata = string.sub(message,pos)
			 hexdump(cmddata)
			 if(cmd == COMMAND.BTN_WRITE_CMD) then
				pos,datalen,data = string.unpack(cmddata,">H>H")
				print("datalen = " .. datalen .. "data = " .. data)
				if(datalen == 1 and (data == BUTTONDATA.LEDOFF_PRESSED or data == BUTTONDATA.LEDON_PRESSED)) then
				    local notifycmd = {}
				    notifycmd.BUTTON_ID = reg_addr - BASEADDR.BUTTON_BASE_ADDR + 1
				    notifycmd.ACTION = 1
				    self:prx_KEYPAD_BUTTON_ACTION(notifycmd)
				elseif(datalen == 1 and (data == BUTTONDATA.LEDOFF_RELEASED or data == BUTTONDATA.LEDON_RELEASED or data == BUTTONDATA.LEDOFF_LONG_RELEASE or data == BUTTONDATA.LEDON_LONG_RELEASE))
				then
				    local notifycmd = {}
				    notifycmd.BUTTON_ID = reg_addr - BASEADDR.BUTTON_BASE_ADDR + 1
				    notifycmd.ACTION = 0
				    self:prx_KEYPAD_BUTTON_ACTION(notifycmd)
				else
				    LogTrace("data error")
				end
			 elseif(cmd == COMMAND.READ_CMD or cmd == COMMAND.WRITE_CMD) then
				pos,data = string.unpack(cmddata,">H")
				LogTrace("cmd == COMMAND.READ_CMD or cmd == COMMAND.WRITE_CMD")
				if(message == self._CmdTable[self._CmdSendPos]) then
				    if(TimerStarted(self._CmdCnfTimer)) then
					   LogTrace("confirm success")
					   KillTimer(self._CmdCnfTimer)
					   self._CmdTable[self._CmdSendPos] = ""
					   if(self._CmdSendPos == self._CmdTableMax) then
						  self._CmdSendPos = 1
					   else
						  self._CmdSendPos = self._CmdSendPos + 1
					   end
					   self._CmdSync = false
				    end
				else
				    LogTrace("restart confirm")
				end
			 else
				LogTrace("cmd error")
			 end
		  else
			 LogTrace("device addr error")
		  end
	   end
    else
	   if(self._SyncMode == true and self._PressTimes > 0) then
		  KillTimer(self._Timer)
		  self._PressTimes = 0
		  self._SyncMode = false
	   end
        LogTrace("HandleMessage data error!!")
    end
end

function KeypadProxy:ButtonPressed(buttonid)
    LogTrace("KeypadProxy:ButtonPressed")
    local cmd = {}
    cmd.BUTTON_ID = buttonid
    cmd.ACTION = 1
    NOTIFY.KEYPAD_BUTTON_ACTION(self._BindingID,cmd)
    cmd.ACTION = 2
    NOTIFY.KEYPAD_BUTTON_ACTION(self._BindingID,cmd)
end


--[[=============================================================================
    KeypadProxy Proxy Commands(PRX_CMD)
===============================================================================]]

function KeypadProxy:prx_KEYPAD_BUTTON_ACTION(tParams)
    tParams = tParams or {}
    local cmd = {}
    local btnid = tParams["BUTTON_ID"]
    local action = tParams["ACTION"]
    print("btnid = ".. btnid .."action = "..action .. "typeof action = " .. type(action))
    cmd.BUTTON_ID = btnid
    cmd.ACTION = action
    NOTIFY.KEYPAD_BUTTON_ACTION(self._BindingID,cmd)
end

function KeypadProxy:prx_KEYPAD_BUTTON_INFO(tParams)
    LogTrace("KeypadProxy:prx_KEYPAD_BUTTON_INFO")
    LogTrace(tParams)
    tParams = tParams or {}
    local state = tParams["STATE"]
    local btnid = tParams["BUTTON_ID"]
    local led_state
    print("state = " .. state .. "type:" .. type(state))
    if(state == "True") then
        led_state = 1
    else
        led_state = 0
    end
    self:ButtonLedControl(btnid,led_state)
end





--[[=============================================================================
    Camera Proxy UIRequests
===============================================================================]]
--[[
	Return the query string required for an HTTP image push URL request.
--]]
--[[
function CameraProxy:req_GET_SNAPSHOT_QUERY_STRING(tParams)
	tParams = tParams or {}
    local size_x = tonumber(tParams["SIZE_X"]) or 640
    local size_y = tonumber(tParams["SIZE_Y"]) or 480

	return "<snapshot_query_string>" .. C4:XmlEscapeString(GET_SNAPSHOT_QUERY_STRING(size_x, size_y)) .. "</snapshot_query_string>"
end

]]

--[[=============================================================================
    Camera Proxy Notifies
===============================================================================]]
--[[
function CameraProxy:dev_PropertyDefaults()
	local property_defaults = {}
	property_defaults.HTTP_PORT = C4:GetCapability("default_http_port") or 80
	property_defaults.RTSP_PORT = C4:GetCapability("default_rtsp_port") or 554
	property_defaults.AUTHENTICATION_REQUIRED = C4:GetCapability("default_authentication_required") or true
	property_defaults.AUTHENTICATION_TYPE = C4:GetCapability("default_authentication_type") or "BASIC"
	property_defaults.USERNAME = C4:GetCapability("default_username") or "username"
	property_defaults.PASSWORD = C4:GetCapability("default_password") or "password"

	NOTIFY.PROPERTY_DEFAULTS(self._BindingID, property_defaults)
end

]]
--[[=============================================================================
    Camera Proxy Functions
===============================================================================]]
-- Create class functions required by the class
--[[
function CameraProxy:BuildHTTPURL(queryString)
	local httpUrl = ""
	
	if ((queryString ~= nil) and (string.len(queryString) > 0)) then
		httpUrl = "http://" .. self._Address .. ":" .. self._HttpPort .. "/" .. queryString
	end
	
	return httpUrl
end

]]


