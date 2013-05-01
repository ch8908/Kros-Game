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
	-- Groups
	------------------
	local localGroup = display.newGroup()
	local buttonGroup = display.newGroup()
	local targetQueueGroup = display.newGroup()

	------------------
	-- Functions
	------------------
	local resolveButton = {}
	local getTargetView = {}
	local initGameQueue = {}
	local createTargetQueueView = {}
	local hitTargetWithPlayer = {}
	local resolveButtonWithPlayer1 = {}
	local resolveButtonWithPlayer2 = {}

	------------------
	-- Global params
	------------------
	local targetQueueView = {}
	local enemyQueueView = {}
	local buttonLock = false

	------------------
	-- Display Objects
	------------------
	local text = display.newText(localGroup, "Text", 0, 0, nil, 22)
		
	
	--====================================================================--
	-- BUTTONS
	--====================================================================--
	local onButtonPressed = function ( event )
		if "began" == event.phase then
			-- resolveButtonWithPlayer1(event.target.id)
			resolveButtonWithPlayer2(event.target.id)
		end
		return true
	end

	local redButtonLeft=ui.newButton{
		--Images for Button
		default = "image/red_button_normal.png",
		over = "image/red_button_pressed.png",
		--
		onPress = onButtonPressed,			
	}
	redButtonLeft.id = RED_TARGET
	redButtonLeft.x = redButtonLeft.width + 20
	redButtonLeft.y = _H - redButtonLeft.width - 10
	buttonGroup:insert(redButtonLeft)

	local redButtonRight=ui.newButton{
		--Images for Button
		default = "image/red_button_normal.png",
		over = "image/red_button_pressed.png",
		--
		onPress = onButtonPressed,			
	}
	redButtonRight.id = RED_TARGET
	redButtonRight.x = _W - redButtonRight.width - 20
	redButtonRight.y = redButtonLeft.y
	buttonGroup:insert(redButtonRight)

	local blueButtonLeft=ui.newButton{
		--Images for Button
		default = "image/blue_button_normal.png",
		over = "image/blue_button_pressed.png",
		--
		onPress = onButtonPressed,			
	}
	blueButtonLeft.id = BLUE_TAEGET
	blueButtonLeft.x = redButtonRight.x - blueButtonLeft.width
	blueButtonLeft.y = redButtonLeft.y
	buttonGroup:insert(blueButtonLeft)


	local blueButtonRight=ui.newButton{
		--Images for Button
		default = "image/blue_button_normal.png",
		over = "image/blue_button_pressed.png",
		--
		onPress = onButtonPressed,			
	}
	blueButtonRight.id = BLUE_TAEGET
	blueButtonRight.x = redButtonLeft.x + blueButtonRight.width
	blueButtonRight.y = redButtonLeft.y
	buttonGroup:insert(blueButtonRight)

	------------------
	-- Functions
	------------------
	function resolveButtonWithPlayer1(target)
		result = DataController:player1HitTarget(target)
		if result then
			hitTargetWithPlayer(PLAYER_1, result)
		end
	end

	function resolveButtonWithPlayer2(target)
		result = DataController:player2HitTarget(target)
		if result then
			hitTargetWithPlayer(PLAYER_2, result)
		end
	end

	function hitTargetWithPlayer( player, newTarget )
		print("hitTargetWithPlayer:player"..player.."newTarget"..newTarget)
		local myQueueView
		local positionFactor = 0
		if PLAYER_1 == player then
			positionFactor = -1
			myQueueView = targetQueueView
		elseif PLAYER_2 == player then
			positionFactor = 1
			myQueueView = enemyQueueView
		end

		-- target explore animation
		local hitTargetView = table.remove(myQueueView, 1)
		transition.to(hitTargetView, {time=100, alpha = 0, xScale = 3.0, yScale = 3.0, onComplete = function()
			display.remove(hitTargetView)
			hitTargetView = nil
		  end})

		-- create new target view
		local newTargetView = getTargetView(newTarget)

		-- set new target view position and insert
		local lastTargetView = table.remove(myQueueView)
		newTargetView.x = lastTargetView.x + newTargetView.width * positionFactor
		newTargetView.y = lastTargetView.y

		table.insert(myQueueView, lastTargetView)
		table.insert(myQueueView, newTargetView)

		-- forward animation
		for i,v in ipairs(myQueueView) do
			transition.to(v, {time=100,  x = v.x - v.width * positionFactor, onComplete = function()  end})
		end

	end

	function getTargetView( target )

		local targetPath

		if BLUE_TAEGET == target then
			targetPath = "image/blue_target.png"
		elseif RED_TARGET == target then
			targetPath = "image/red_target.png"
		end

		local targetView = display.newImage(targetQueueGroup,targetPath, 0, 0, true)

		return targetView

	end

	function initGameQueue()

		DataController:initTargetQueue()

		createTargetQueueView()

	end

	function createTargetQueueView()

		-- Player 1
		for i,v in ipairs(DataController:getPlayer1Queue()) do

			print(i,v)

			local target = getTargetView(v)

			target.x = _W * .5 - (i-1) * target.width
			target.y = _H * .5

			table.insert(targetQueueView, target)

		end

		-- Player 2
		for i,v in ipairs(DataController:getPlayer2Queue()) do
			print(i,v)

			local target = getTargetView(v)

			target.x = _W * .5 + (i-1) * target.width
			target.y = _H * .7

			table.insert(enemyQueueView, target)

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

		initGameQueue()

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
