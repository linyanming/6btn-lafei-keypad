--[[=============================================================================
    Initialization Functions

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "keypad.keypad_proxy_class"
require "keypad.keypad_proxy_commands"
require "keypad.keypad_proxy_notifies"


DEVICE_ADDR = {}
-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_init = "2017.01.13"
end

function ON_DRIVER_EARLY_INIT.proxy_init()
	-- declare and initialize global variables
	C4:AllowExecute(false)
end

function ON_DRIVER_INIT.proxy_init()

	gKeypadProxy = KeypadProxy:new(DEFAULT_PROXY_BINDINGID)
end

function ON_DRIVER_LATEINIT.proxy_init()

	gKeypadProxy:dev_Newbuttoncreate(1,"button1")
	gKeypadProxy:dev_Newbuttoncreate(2,"button2")
	gKeypadProxy:dev_Newbuttoncreate(3,"button3")
	gKeypadProxy:dev_Newbuttoncreate(4,"button4")
	gKeypadProxy:dev_Newbuttoncreate(5,"button5")
	gKeypadProxy:dev_Newbuttoncreate(6,"button6")
	StartTimer(gKeypadProxy._MsgTimer)
	StartTimer(gKeypadProxy._CmdTimer)
end


