--[[=============================================================================
    Command Functions Received From Proxy to the Camera Driver

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.keypad_proxy_commands = "2018.05.23"
end


function PRX_CMD.KEYPAD_BUTTON_INFO(idBinding, tParams)
	gKeypadProxy:prx_KEYPAD_BUTTON_INFO(tParams)
end

function PRX_CMD.KEYPAD_BUTTON_ACTION(idBinding, tParams)
	gKeypadProxy:prx_KEYPAD_BUTTON_ACTION(tParams)
end



--[[UI Requests
function UI_REQ.GET_SNAPSHOT_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_SNAPSHOT_QUERY_STRING(tParams)
end

function UI_REQ.GET_MJPEG_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_MJPEG_QUERY_STRING(tParams)
end

function UI_REQ.GET_RTSP_H264_QUERY_STRING(tParams)
	return gCameraProxy:req_GET_RTSP_H264_QUERY_STRING(tParams)
end

]]