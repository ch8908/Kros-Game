module(..., package.seeall)

--====================================================================--
-- SCENE: SCREEN 1
--====================================================================--

--[[


--]]

system.activate( "multitouch" )

new = function ( params )
	
	------------------
	-- Imports
	------------------
	local physics = require "physics"
	physics.start()
	
	------------------
	-- Constant
	------------------
	local BLUE_TAEGET = "blue"
	local RED_TARGET = "red"
	local FORWARD_OFFSET = 20

	------------------
	-- Groups
	------------------
	local localGroup = display.newGroup()
	local buttonGroup = display.newGroup()
	local targetQueueGroup = display.newGroup()

	------------------
	-- Functions
	------------------
	local pressedRed = {}
	local pressedBlue = {}
	local resolveButton = {}
	local getRandomTarget = {}
	local initGamePath = {}
	local createTargetQueue = {}
	local hitTarget = {}

	------------------
	-- Global params
	------------------
	local targetQueue = {}
	local targetQueueView = {}
	local buttonLock = false

	------------------
	-- Display Objects
	------------------
	local text = display.newText(localGroup, "Text", 0, 0, nil, 22)
		
	
	--====================================================================--
	-- BUTTONS
	--====================================================================--

	local onRedPress = function( event )
		
		if "ended" == event.phase then
			pressedRed();
		end
			
		return true
	end

	local redButton=ui.newButton{
		--Images for Button
		default = "image/red_button_normal.png",
		over = "image/red_button_pressed.png",
		--
		onRelease = onRedPress,			
	}
	redButton.id = "red"
	redButton.x = redButton.width + 20
	redButton.y = _H - redButton.width - 10
	buttonGroup:insert(redButton)


	local onBluePress = function( event )
		
		if "ended" == event.phase then
			pressedBlue();
		end
			
		return true
	end

	local blueButton=ui.newButton{
		--Images for Button
		default = "image/blue_button_normal.png",
		over = "image/blue_button_pressed.png",
		--
		onRelease = onBluePress,			
	}
	blueButton.id = "blue"
	blueButton.x = _W - blueButton.width + 22
	blueButton.y = redButton.y
	buttonGroup:insert(blueButton)


	------------------
	-- Functions
	------------------
	function pressedBlue()
		resolveButton(BLUE_TAEGET)
	end
	
	function pressedRed()
		resolveButton(RED_TARGET)
	end

	function resolveButton(target)
		local queueTarget = targetQueue[1]
		if target == queueTarget then
			print("right");
			hitTarget()
		else
			print("wrong");
		end
	end

	function hitTarget()
		table.remove(targetQueue, 1)
		local hitTarget = table.remove(targetQueueView, 1)
		display.remove(hitTarget)
		hitTarget = nil
	end
	
	function getRandomTarget()
		if math.random() > 0.5 then
			return BLUE_TAEGET
		else
			return RED_TARGET
		end
	end

	function initGamePath()

		for i=1,10 do
			table.insert(targetQueue, getRandomTarget())
			print(targetQueue[i])
		end

		createTargetQueue()

	end

	function createTargetQueue()

		-- local gameGround = display.newRect(targetQueueGroup, -200, 0, _W + 200, 10)
		-- gameGround:setFillColor(255)
		-- gameGround.x = _W * 0.5
		-- gameGround.y = _H * 0.5
		-- physics.addBody(gameGround, "static", {density=0.0, friction=0.0, bounce=0})

		-- local stopWall = display.newRect(targetQueueGroup, 0, 0, 10, 100)
		-- stopWall:setFillColor(255, 0, 0)
		-- stopWall.x = _W * .6
		-- stopWall.y = gameGround.y - gameGround.height - stopWall.height * .5
		-- physics.addBody(stopWall, "static", {density=0.0, friction=0.0, bounce=0})

		for i,v in ipairs(targetQueue) do

			print(i,v)

			local targetPath

			if BLUE_TAEGET == v then
				targetPath = "image/blue_target.png"
			elseif RED_TARGET == v then
				targetPath = "image/red_target.png"
			end

			local target = display.newImage(targetQueueGroup,targetPath, 0, 0, true)

			-- physics.addBody(target, "dynamic", {density=0, friction=0, bounce=0 })

			target.x = _W * .5 - (i-1) * target.width
			target.y = _H * .5

			table.insert(targetQueueView, target)

		end

	end
	------------------
	-- UI Objects
	------------------
	

	
	--====================================================================--
	-- INITIALIZE
	--====================================================================--
	
	local initVars = function ()
		
		------------------
		-- Inserts
		------------------
		localGroup:insert(buttonGroup)
		localGroup:insert(targetQueueGroup)

		initGamePath()

		local isSimulator = "simulator" == system.getInfo("environment") 
		-- Multitouch Events not supported on Simulator		
		if isSimulator then
				msg = display.newText( "Multitouch not supported on Simulator!", 0, 380, nil, 14 )
				msg.x = display.contentWidth/2          -- center title
				msg:setTextColor( 255,255,0 )
		end

	end
	
	------------------
	-- Initiate variables
	------------------
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end
