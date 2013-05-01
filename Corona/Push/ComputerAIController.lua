module(..., package.seeall)

--====================================================================--
-- Computer AI Controller
--====================================================================--

--[[
	Computer AI

--]]

ComputerAIController = {}

--=======================--
-- AI Constants
--=======================--
local hitRate = 500
local missRate


--=======================--
-- Global params
--=======================--
local triggerTimer = nil

--=======================--
-- Local functions
--=======================--
local processHit = {}

--=======================--
-- Trigger function
--=======================--
local triggerFunction = {}	-- this is resolveButtonWithPlayer2(target)


--=======================--
-- Functions
--=======================--
function processHit()
	print("computer hit target!")
	local currentQueue = DataController:getPlayer2Queue()
	triggerFunction(currentQueue[1])
end

function ComputerAIController:startHittingWithFunction( targetFuction )
	if not targetFuction then
		return
	end

	if triggerTimer then
		return
	end
	triggerFunction = targetFuction
	triggerTimer = timer.performWithDelay(hitRate, processHit, 0)
end

function ComputerAIController:stopHitting()
	if not triggerTimer then
		return 
	end

	timer.cancel(triggerTimer)
	triggerTimer = nil
end

return ComputerAIController
