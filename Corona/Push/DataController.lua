module(..., package.seeall)

--====================================================================--
-- Data Controller
--====================================================================--

--[[


--]]

DataController = {}

--=======================--
-- Functions
--=======================--
local player1Queue = {}
local player2Queue = {}


function DataController:getPlayer1Queue()
	return player1Queue
end

function DataController:getPlayer2Queue()
	return player2Queue
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
		return newTarget

	end
	return nil
end

function DataController:player2HitTarget( userAction )
	if (userAction == player2Queue[1]) then
		
		table.remove(player2Queue, 1)
		local newTarget = DataController:getRandomTarget()
		table.insert(player2Queue, newTarget)
		return newTarget

	end
	return nil
end

function DataController:initTargetQueue()
	
	for i=1,10 do

		table.insert(player1Queue, DataController:getRandomTarget())
	
		table.insert(player2Queue, DataController:getRandomTarget())
	
	end

end

return DataController
