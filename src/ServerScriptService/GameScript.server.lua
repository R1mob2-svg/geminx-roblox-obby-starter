-- GeminX Simple Obby: server gameplay script
-- Respawning on lava, checkpoint advancement, and finish win.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local lavaFolder = Workspace:WaitForChild("Lava")
local checkpointFolder = Workspace:WaitForChild("Checkpoint")
local finishFolder = Workspace:WaitForChild("Finish")
local spawnLocation = Workspace:WaitForChild("SpawnLocation")

-- Per-player respawn position (Vector3) or nil for the default spawn.
local respawnData = {}

local function currentSpawnPos(player)
	local saved = respawnData[player.UserId]
	if saved then
		return saved
	end
	return spawnLocation.Position + Vector3.new(0, 3, 0)
end

-- Teleport a character to a safe spot. Used on lava touch AND as the
-- "respawn" behaviour so a missed checkpoint means going back to spawn.
local function sendToRespawn(player)
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	-- Teleport to the current respawn point (spawn or checkpoint + a bit up)
	root.CFrame = CFrame.new(currentSpawnPos(player))
	humanoid.Health = humanoid.MaxHealth
end

local function wireGlue(character)
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	-- Prevent falling below the world as a safety net (also respawn).
	humanoid.StateChanged:Connect(function(old, new)
		if new == Enum.HumanoidStateType.Dead then
			-- Happens after falling off or into lava; respawn at spawn/checkpoint.
			spawnLocation:LoadCharacter(player)
		end
	end)

	root.Touched:Connect(function(other)
		if not other or not other.Parent then return end
		local parent = other.Parent
		local name = parent.Name

		-- LAVA -> send back to spawn/checkpoint
		if other.Parent ~= nil and lavaFolder:IsAncestorOf(other) then
			sendToRespawn(player)
			return
		end

		-- CHECKPOINT -> save new respawn position
		if checkpointFolder:IsAncestorOf(other) then
			respawnData[player.UserId] = other.Position + Vector3.new(0, 3, 0)
			local hint = Instance.new("Message")
			hint.Text = "Checkpoint saved! Respawn will be here from now on."
			hint.Parent = Workspace
			game:GetService("Debris"):AddItem(hint, 4)
			return
		end

		-- FINISH -> win!
		if finishFolder:IsAncestorOf(other) then
			respawnData[player.UserId] = nil
			local announce = Instance.new("Message")
			announce.Text = player.Name .. " reached the finish! 🏁"
			announce.Parent = Workspace
			game:GetService("Debris"):AddItem(announce, 8)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		player = player -- capture player in the closure via outer scope below
	end)
end)

-- Re-do cleanly with a proper closure:
Players.PlayerAdded:Connect(function(newPlayer)
	newPlayer.CharacterAdded:Connect(function(character)
		player = newPlayer
		wireGlue(character)
	end)
end)
