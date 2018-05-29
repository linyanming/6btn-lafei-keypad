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
    self._PackLen = 8
	self._SyncDevid = Properties["DeviceID"]
	self._SyncMode = false
end

function KeypadProxy:dev_Newbuttoncreate(buttonid,buttonname)
	local new_button = {}
     new_button.BUTTON_ID = buttonid
	new_button.NAME = buttonname
	new_button.LOCK_COLORS = true

	NOTIFY.NEW_KEYPAD_BUTTON(self._BindingID, new_button)
end

function KeypadProxy:HandleMessage(message,msglen)
    LogTrace("EX_CMD.RECVMSG")
    hexdump(message)
    if(#message ~= self._PackLen) then
        return nil
    else
        local msg_data = {}
        for i = 1,#message do
    	    msg_data[i] = string.byte(message,i)
    	    print(i .. ":" .. msg_data[i])
        end
        if(msg_data[1] == 0x55 and msg_data[2] == 0x2a and msg_data[3] == 0x30) then
            local sum = 0
		    for i = 1,7 do
		        sum = sum + msg_data[i]
		    end
		    if(bit.band(sum,0xff) == msg_data[8]) then
		        local dev_id = bit.band(msg_data[4],0xf8)/8
			    local btn_id = bit.band(msg_data[4],0x07)
			    LogTrace("dev_id = %d btn_id = %d", dev_id,btn_id)
			    if(dev_id == self._SyncDevid) then
			        self:ButtonPressed(btn_id)
			    end
		    end
		else
		    return nil
        end
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

--[[=============================================================================
    Camera Proxy Commands(PRX_CMD)
===============================================================================]]
--[[
function CameraProxy:prx_SET_ADDRESS(tParams)
	tParams = tParams or {}
	self._Address = tParams["ADDRESS"] or self._Address
end

function CameraProxy:prx_SET_ADDRESS(tParams)
	tParams = tParams or {}
	self._Address = tParams["ADDRESS"] or self._Address
end
]]



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


