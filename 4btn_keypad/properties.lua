--[[=============================================================================
    Properties Code

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.properties = "2017.01.13"
end

function ON_PROPERTY_CHANGED.DeviceID(propertyValue)
   gKeypadProxy._SyncDevid = tonumber(propertyValue)
end

--[[
function ON_PROPERTY_CHANGED.MJPEGStreamID(propertyValue)
	gCameraProxy._MJPEG_Stream_ID = tonumber(propertyValue)
end

function ON_PROPERTY_CHANGED.MJPEGStreamProfile(propertyValue)
	gCameraProxy._MJPEG_Stream_Profile = propertyValue
end

function ON_PROPERTY_CHANGED.H264StreamID(propertyValue)
	gCameraProxy._H264_Stream_ID = tonumber(propertyValue)
end

function ON_PROPERTY_CHANGED.H264720pStreamID(propertyValue)
	gCameraProxy._H264_720p_Stream_ID = tonumber(propertyValue)
end

function ON_PROPERTY_CHANGED.H2641080pStreamID(propertyValue)
	gCameraProxy._H264_1080p_Stream_ID = tonumber(propertyValue)
end

function ON_PROPERTY_CHANGED.H2644KStreamID(propertyValue)
	gCameraProxy._H264_4K_Stream_ID = tonumber(propertyValue)
end

function ON_PROPERTY_CHANGED.H264StreamProfile(propertyValue)
	gCameraProxy._H264_Stream_Profile = propertyValue
end

function ON_PROPERTY_CHANGED.H264720pStreamProfile(propertyValue)
	gCameraProxy._H264_720p_Stream_Profile = propertyValue
end

function ON_PROPERTY_CHANGED.H2641080pStreamProfile(propertyValue)
	gCameraProxy._H264_1080p_Stream_Profile = propertyValue
end

function ON_PROPERTY_CHANGED.H2644KStreamProfile(propertyValue)
	gCameraProxy._H264_4K_Stream_Profile = propertyValue
end
]]