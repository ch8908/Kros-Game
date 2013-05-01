module(..., package.seeall)

--====================================================================--
-- Data Controller
--====================================================================--

--[[


--]]

DataController = {}

--=======================--
-- Params
--=======================--
local player1Queue = nil
local player2Queue = nil

local player1Score = nil
local player2Score = nil

function DataController:getPlayer1Queue()
	return player1Queue
end

function DataController:getPlayer2Queue()
	return player2Queue
end

function DataController:getPlayer1Score()
	return player1Score
end

function DataController:getPlayer2Score()
	return player2Score
end

function DataController:getRandomTarget()
	if math.random() > 0.5 then
		return BLUE_TAEGET
	else
		return RED_TARGET
	end
end

function DataController:player1HitTarget( userAction )
	if (userAction == player1Queue[1]) then
		table.remove(player1Queue, 1)
		local newTarget = DataController:getRandomTarget()
		table.insert(player1Queue, newTarget)
		player1Score = player1Score + 1;
		return newTarget
	end
	return nil
end

function DataController:player2HitTarget( userAction )
	if (userAction == player2Queue[1]) then
		table.remove(player2Queue, 1)
		local newTarget = DataController:getRandomTarget()
		table.insert(player2Queue, newTarget)
		player2Score = player2Score + 1;
		return newTarget
	end
	return nil
end

function DataController:initTargetQueue()
	player1Queue = {}
	player2Queue = {}
	player1Score = 0
	player2Score = 0
	for i=1,10 do

		table.insert(player1Queue, DataController:getRandomTarget())
	
		table.insert(player2Queue, DataController:getRandomTarget())
	
	end
end

function DataController:resetData()
	player1Score = 0
	player2Score = 0
	player1Queue = nil
	player2Queue = nil
	DataController:initTargetQueue()
end

return DataController
