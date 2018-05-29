--[[=============================================================================
    Commands received from the camera proxy (ReceivedFromProxy)

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_commands = "2017.01.13"
end

--[[
	Implement the following commands as required by capabilities. 
--]]
--[[
function PAN_LEFT()
	-- TODO: Set the value of the PAN_LEFT command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("PAN_LEFT(): Ticket = " .. ticket .. " URL = " .. url)
end

function PAN_RIGHT()
	-- TODO: Set the value of the PAN_RIGHT command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("PAN_RIGHT(): Ticket = " .. ticket .. " URL = " .. url)
end

function PAN_SCAN()
	-- TODO: Set the value of the PAN_SCAN command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("PAN_SCAN(): Ticket = " .. ticket .. " URL = " .. url)
end

function TILT_UP()
	-- TODO: Set the value of the TILT_UP command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("TILT_UP(): Ticket = " .. ticket .. " URL = " .. url)
end

function TILT_DOWN()
	-- TODO: Set the value of the TILT_DOWN command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("TILT_DOWN(): Ticket = " .. ticket .. " URL = " .. url)
end

function TILT_SCAN()
	-- TODO: Set the value of the TILT_SCAN command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("TILT_SCAN(): Ticket = " .. ticket .. " URL = " .. url)
end

function ZOOM_IN()
	-- TODO: Set the value of the ZOOM_IN command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("ZOOM_IN(): Ticket = " .. ticket .. " URL = " .. url)
end

function ZOOM_OUT()
	-- TODO: Set the value of the ZOOM_OUT command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("ZOOM_OUT(): Ticket = " .. ticket .. " URL = " .. url)
end

function HOME()
	-- TODO: Set the value of the HOME command
	local command = "" 

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("HOME(): Ticket = " .. ticket .. " URL = " .. url)
end
]]

--[[

function PRESET(index)
	-- TODO: Set the value of the PRESET command
	local command = ""

	local url = gCameraProxy:BuildHTTPURL(command)
	local ticket = gCon:UrlGet(gCameraProxy:BuildGetRequest(url), gCameraProxy:AuthHeader())
	
	LogTrace("PRESET(" .. tostring(index) .. "): Ticket = " .. ticket .. " URL = " .. url)
end
]]
-- UI Requests
--[[
	Return the query string required for an HTTP snapshot URL request.
--]]
--[[
function GET_SNAPSHOT_QUERY_STRING(size_x, size_y)
	-- TODO: Set the URL query string between the quotes.  Remember there should be no leading /
	-- If the camera has the ability to send a snapshot of a particular size then use the size_x and size_y variables in the query.
	local snapshotQueryString = "sample/queryString?parameter=value&parameter2=value2"

	return snapshotQueryString
end
]]
--[[
	Return the query string required for an MJPEG HTTP image push URL request.
--]]
--[[
function GET_MJPEG_QUERY_STRING(size_x, size_y, period)
    local mjpegQueryString = ""
    
	-- TODO: Set the MJPEG URL query string between the quotes.  Remember there should be no leading /
	-- If the camera has the ability to provide an MJPEG stream of a particular resolution, then use the size_x and size_y variables in the query.
    -- If the camera has the ability to provide an MJPEG stream at a particular frame rate/period, then use the period variable in the query.
    
    -- If the camera supports multiple stream configurations, the property gCameraProxy._MJPEG_Stream_ID can be used in the query to specify
    --   which stream to use for MJPEG.
    -- mjpegQueryString = "sample/queryString?camera=" .. tostring(gCameraProxy._MJPEG_Stream_ID) .. "&parameter2=value2"
    
    -- If the camera supports multiple stream configurations using profiles, the property gCameraProxy._MJPEG_Stream_Profile can be used in the query to specify
    --   which stream to use for MJPEG.
    -- mjpegQueryString = "sample/queryString?profile=" .. gCameraProxy._MJPEG_Stream_Profile .. "&parameter2=value2"
    
    -- mjpegQueryString = "sample/queryString?resolution=" .. tostring(size_x) .. "x" .. tostring(size_y) .. "&parameter2=value2"

	return mjpegQueryString
end
]]
--[[
	Return the query string required to establish Rtsp connection.
--]]
--[[
function GET_RTSP_H264_QUERY_STRING(size_x, size_y, period)
    local rtspH264QueryString = ""
    
	-- TODO: Set the H264 URL query string between the quotes.  Remember there should be no leading /
	-- If the camera has the ability to provide an H264 stream of a particular resolution then use the size_x and size_y variables in the query.
    -- If the camera has the ability to provide an H264 stream at a particular frame rate/period, then use the period variable in the query.
    
    -- If the camera supports multiple stream configurations using stream IDs or profiles,  
    --   use the size to specify the best stream for the resolution requested.
    if (size_y == 2160) then -- 4K
        -- The property gCameraProxy._H264_4K_Stream_ID can be used in the query to specify which stream to use for H264 4K.
        -- rtspH264QueryString = "sample/queryString?camera=" .. tostring(gCameraProxy._H264_4K_Stream_ID) .. "&parameter2=value2"
        
        -- The property gCameraProxy._H264_4K_Stream_Profile can be used in the query to specify which stream to use for H264 4K.
        -- rtspH264QueryString = "sample/queryString?profile=" .. gCameraProxy._H264_4K_Stream_Profile .. "&parameter2=value2"
    elseif (size_y == 1080) then
        -- The property gCameraProxy._H264_1080p_Stream_ID can be used in the query to specify which stream to use for H264 1080p.
        -- rtspH264QueryString = "sample/queryString?camera=" .. tostring(gCameraProxy._H264_1080p_Stream_ID) .. "&parameter2=value2"
        
        -- The property gCameraProxy._H264_1080p_Stream_Profile can be used in the query to specify which stream to use for H264 1080p.
        -- rtspH264QueryString = "sample/queryString?profile=" .. gCameraProxy._H264_1080p_Stream_Profile .. "&parameter2=value2"   
    elseif (size_y == 720) then
        -- The property gCameraProxy._H264_720p_Stream_ID can be used in the query to specify which stream to use for H264 720p.
        -- rtspH264QueryString = "sample/queryString?camera=" .. tostring(gCameraProxy._H264_720p_Stream_ID) .. "&parameter2=value2"
        
        -- The property gCameraProxy._H264_720p_Stream_Profile can be used in the query to specify which stream to use for H264 720p.
        -- rtspH264QueryString = "sample/queryString?profile=" .. gCameraProxy._H264_720p_Stream_Profile .. "&parameter2=value2"
    else
        -- The property gCameraProxy._H264_Stream_ID can be used in the query to specify which stream to use for H264.
	    -- rtspH264QueryString = "sample/queryString?camera=" .. tostring(gCameraProxy._H264_Stream_ID) .. "&parameter2=value2"
        
        -- The property gCameraProxy._H264_Stream_Profile can be used in the query to specify which stream to use for H264.
        -- rtspH264QueryString = "sample/queryString?profile=" .. gCameraProxy._H264_Stream_Profile .. "&parameter2=value2"   
    end
    
    -- rtspH264QueryString = "sample/queryString?resolution=" .. tostring(size_x) .. "x" .. tostring(size_y) .. "&parameter2=value2"
	
	return rtspH264QueryString
end
]]
