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
	local ComputerAIController = require("ComputerAIController")
	local physics = require "physics"
	physics.start()

	------------------
	-- UI Constant
	------------------
	local FORWARD_TIME = 80
	local HIT_DISAPPERT_TIME = 300
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
	local cleanQueueView = {}
	local restartGame = {}

	------------------
	-- Global params
	------------------
	local player1TargetQueueView = {}
	local player2TargetQueueView = {}
	local buttonLock1 = false
	local player1Lock = false
	local player2Lock = false

	------------------
	-- Register notification
	------------------
	local onPlayerWinNotification = {}

	------------------
	-- Display Objects
	------------------
	local player1ScoreView = display.newText(localGroup, "0", 220, 50, nil, 60)
	local player2ScoreView = display.newText(localGroup, "0", 760, 50, nil, 60)
	local finishedView = display.newText("", _W * .5, _H * .35, nil, 100)

	--====================================================================--
	-- BUTTONS
	--====================================================================--
	local onButtonPressed = function ( event )
		if "began" == event.phase and not buttonLock1 then
			resolveButtonWithPlayer1(event.target.id)
			-- resolveButtonWithPlayer2(event.target.id)
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
	redButtonLeft.x = redButtonLeft.width * .5 + 40
	redButtonLeft.y = _H - redButtonLeft.width + 50
	buttonGroup:insert(redButtonLeft)

	local redButtonRight=ui.newButton{
		--Images for Button
		default = "image/red_button_normal.png",
		over = "image/red_button_pressed.png",
		--
		onPress = onButtonPressed,			
	}
	redButtonRight.id = RED_TARGET
	redButtonRight.x = _W - redButtonRight.width * .5 - 30
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
	blueButtonLeft.x = redButtonLeft.x + blueButtonLeft.width + 20
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
	blueButtonRight.x = redButtonRight.x - blueButtonRight.width - 20
	blueButtonRight.y = redButtonLeft.y
	buttonGroup:insert(blueButtonRight)

	-- Restart Button
	local onRestart = function(event)
		if "ended" == event.phase then
			restartGame()
		end
	end

	local restartButton=ui.newButton{
		--Images for Button
		default = "image/restart_button.png",
		over = "image/restart_button.png",
		--
		onRelease = onRestart,			
	}
	restartButton.id = RED_TARGET
	restartButton.x = _W * .5
	restartButton.y = _H * .2
	restartButton.isVisible = false
	buttonGroup:insert(restartButton)

	------------------
	-- Functions
	------------------
	function resolveButtonWithPlayer1(target)
		result = DataController:player1HitTarget(target)
		if not player1Lock and result then
			hitTargetWithPlayer(PLAYER_1, result)
		end
	end

	function resolveButtonWithPlayer2(target)
		result = DataController:player2HitTarget(target)
		if not player2Lock and result then
			hitTargetWithPlayer(PLAYER_2, result)
		end
	end

	function hitTargetWithPlayer( player, newTarget )

		local myQueueView
		local positionFactor = 0
		local scoreView
		if PLAYER_1 == player then
			buttonLock1 = true
			positionFactor = -1
			myQueueView = player1TargetQueueView
			player1ScoreView.text = DataController:getPlayer1Score()
			timer.performWithDelay(FORWARD_TIME, function() buttonLock1 = false end, 1)
		elseif PLAYER_2 == player then
			positionFactor = 1
			myQueueView = player2TargetQueueView
			player2ScoreView.text = DataController:getPlayer2Score()
		end

		-- target explore animation
		local hitTargetView = table.remove(myQueueView, 1)
		transition.to(hitTargetView, {time=HIT_DISAPPERT_TIME, alpha = 0, xScale = 3.0, yScale = 3.0, onComplete = function()
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
			transition.to(v, {time=FORWARD_TIME,  x = v.x - v.width * positionFactor, onComplete = function() end})
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

		ComputerAIController:startHittingWithFunction(resolveButtonWithPlayer2)

	end

	function createTargetQueueView()

		-- Player 1
		for i,v in ipairs(DataController:getPlayer1Queue()) do

			print(i,v)

			local target = getTargetView(v)

			target.x = _W * .5 - (i-1) * target.width
			target.y = _H * .5

			table.insert(player1TargetQueueView, target)

		end

		-- Player 2
		for i,v in ipairs(DataController:getPlayer2Queue()) do
			print(i,v)

			local target = getTargetView(v)

			target.x = _W * .5 + (i-1) * target.width
			target.y = _H * .7

			table.insert(player2TargetQueueView, target)

		end

	end

	function onPlayerWinNotification(player)
		ComputerAIController:stopHitting()
		finishedView.text = player.." Win"
		localGroup:insert(finishedView)
		restartButton.isVisible = true
		if PLAYER_1 == player then
			player2Lock = true
		else
			player1Lock = true
		end
	end

	function cleanQueueView()
		for k in pairs (player2TargetQueueView) do
    		display.remove(player2TargetQueueView[k])
    		player2TargetQueueView[k] = nil
		end

		for k in pairs (player1TargetQueueView) do
    		display.remove(player1TargetQueueView[k])
    		player1TargetQueueView[k] = nil
		end
	end

	function restartGame()
		DataController:resetData()
		cleanQueueView()
		createTargetQueueView()
		restartButton.isVisible = false
		finishedView.text = ""
		player1ScoreView.text = "0"
		player2ScoreView.text = "0"
		player1Lock = false
		player2Lock = false
		ComputerAIController:startHittingWithFunction(resolveButtonWithPlayer2)
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
		DataController:addWhoWinObserver(onPlayerWinNotification)

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
