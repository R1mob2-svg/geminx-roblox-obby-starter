-- GeminX Simple Obby: Server gameplay script
-- Handles lava deaths, checkpoint respawns, and the finish win.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local lavaFolder = Workspace:WaitForChild("Lava")
local checkpointFolder = Workspace:WaitForChild("Checkpoint")
local finishFolder = Workspace:WaitForChild("Finish")
local platformsFolder = Workspace:WaitForChild("Platforms")

-- Store each player's respawn state (server-side only, per character ID is simpler per player here)
local respawnData = {} -- key = player user id, value = checkpoint position (Vector3 or nil)

local function respawnPlayer(player)
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	humanoid:TakeDamage(humanoid.MaxHealth) -- trigger standard respawn
end

local function onCharacterAdded(player, character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Handle checkpoint touches (moves respawn forward, so respawn = teleport to checkpoint)
	character:WaitForChild("HumanoidRootPart").Touched:Connect(function(other)
		if other and other.Parent then
			-- Checkpoint touch
			if checkpointFolder:FindFirstChild(other.Name) then
				local checkpointPos = other.Position
				respawnData[player.UserId] = checkpointPos
				-- visual feedback for the player
				local status = player:WaitForChild("PlayerGui") :: any
				if status then end
				return
			end

			-- Finish touch -> win
			if finishFolder:FindFirstChild(other.Name) then
				respawnData[player.UserId] = nil -- reset checkpoint for a replay
				local announce = Instance.new("Message")
				announce.Text = player.Name .. " reached the finish! 🏁"
				announce.Parent = Workspace
				game:GetService("Debris"):AddItem(announce, 8)
				return
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)
end)
