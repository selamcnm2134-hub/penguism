local Players_3 = game:GetService("Players")
local ContextActionService_3 = game:GetService("ContextActionService")
local RunService_3 = game:GetService("RunService")

-- PLAYER
local player_3 = Players_3.LocalPlayer
local character_3 = nil
local root_3 = nil
local humanoid_3 = nil -- Humanoid kontrolü için eklendi

----------------------------------------------------
-- CAMERA FOV LOCK (80)
----------------------------------------------------
local camera_3 = workspace.CurrentCamera
local TARGET_FOV_3 = 70
camera_3.FieldOfView = TARGET_FOV_3

RunService_3.RenderStepped:Connect(function()
	if camera_3.FieldOfView ~= TARGET_FOV_3 then
		camera_3.FieldOfView = TARGET_FOV_3
	end
end)

----------------------------------------------------
-- CONFIG
----------------------------------------------------
local WALL_HEIGHT_3 = 7.2
local WALL_THICKNESS_3 = 0.95        
local ROOF_THICKNESS_3 = 1
local ACTION_NAME_3 = "PalletContainmentToggle"

local INSET_3 = 0.55                 
local BEVEL_THICKNESS_3 = 0.9        
local BEVEL_DEPTH_3 = 1.6            
local AUTO_CLOSE_DELAY_3 = 0.20

local barriers_3 = {}
local containmentEnabled_3 = false
local activePallet_3 = nil
local leaveTime_3 = nil

----------------------------------------------------
-- CLEANUP
----------------------------------------------------
local function cleanup_3()
	for _, part in ipairs(barriers_3) do
		if part and part.Parent then
			part:Destroy()
		end
	end
	barriers_3 = {}
	if activePallet_3 then
		activePallet_3:SetAttribute("HasCage", false)
	end
	activePallet_3 = nil
	containmentEnabled_3 = false
	leaveTime_3 = nil
end

----------------------------------------------------
-- CHARACTER
----------------------------------------------------
local function onCharacterAdded_3(char)
	cleanup_3()
	character_3 = char
	root_3 = char:WaitForChild("HumanoidRootPart", 5)
	humanoid_3 = char:WaitForChild("Humanoid", 5)
end

player_3.CharacterAdded:Connect(onCharacterAdded_3)
if player_3.Character then onCharacterAdded_3(player_3.Character) end
player_3.CharacterRemoving:Connect(cleanup_3)

----------------------------------------------------
-- PALLET CHECK
----------------------------------------------------
local function isStandingOnActivePallet_3()
	if not root_3 or not activePallet_3 then return false end
	local palletPos = activePallet_3.Position
	local rootPos = root_3.Position

	return math.abs(rootPos.X - palletPos.X) <= activePallet_3.Size.X / 2
		and math.abs(rootPos.Z - palletPos.Z) <= activePallet_3.Size.Z / 2
		and rootPos.Y >= palletPos.Y
		and rootPos.Y <= palletPos.Y + activePallet_3.Size.Y + 6
end

----------------------------------------------------
-- BARRIER CREATION
----------------------------------------------------
local function makeBarrier_3(size, cframe, pallet, rotate)
	local part = Instance.new("Part")
	part.Size = size
	part.CFrame = rotate and (cframe * rotate) or cframe
	part.Transparency = 0
	part.LocalTransparencyModifier = 0.45
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(0,170,255)

	part.CanCollide = true
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.Anchored = false
	part.CastShadow = false

	part.Parent = character_3

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = pallet
	weld.Part1 = part
	weld.Parent = part

	table.insert(barriers_3, part)
end

----------------------------------------------------
-- SPAWN BARRIERS
----------------------------------------------------
local function spawnBarriers_3(pallet)
	if containmentEnabled_3 then return end
    
    -- HAVADA MI KONTROLÜ (Donmayı engeller)
    if humanoid_3 and (humanoid_3:GetState() == Enum.HumanoidStateType.Freefall or humanoid_3:GetState() == Enum.HumanoidStateType.Jumping) then
        return 
    end

	local size = pallet.Size
	local cf = pallet.CFrame
	if cf.UpVector:Dot(Vector3.new(0,1,0)) < 0 then
		cf = cf * CFrame.Angles(math.pi,0,0)
	end

	local wallY = (size.Y/2) + (WALL_HEIGHT_3/2)

	makeBarrier_3(Vector3.new(size.X, WALL_HEIGHT_3, WALL_THICKNESS_3), cf * CFrame.new(0, wallY, size.Z/2 - INSET_3), pallet)
	makeBarrier_3(Vector3.new(size.X, WALL_HEIGHT_3, WALL_THICKNESS_3), cf * CFrame.new(0, wallY, -size.Z/2 + INSET_3), pallet)
	makeBarrier_3(Vector3.new(WALL_THICKNESS_3, WALL_HEIGHT_3, size.Z), cf * CFrame.new(size.X/2 - INSET_3, wallY, 0), pallet)
	makeBarrier_3(Vector3.new(WALL_THICKNESS_3, WALL_HEIGHT_3, size.Z), cf * CFrame.new(-size.X/2 + INSET_3, wallY, 0), pallet)

	makeBarrier_3(
		Vector3.new(size.X, ROOF_THICKNESS_3, size.Z),
		cf * CFrame.new(0, (size.Y/2)+WALL_HEIGHT_3+ROOF_THICKNESS_3/2, 0),
		pallet
	)

	local bSize = Vector3.new(BEVEL_DEPTH_3, WALL_HEIGHT_3, BEVEL_THICKNESS_3)
	local rot45 = CFrame.Angles(0, math.rad(45), 0)
	local rot_45 = CFrame.Angles(0, math.rad(-45), 0)

	makeBarrier_3(bSize, cf * CFrame.new(size.X/2 - BEVEL_DEPTH_3, wallY, size.Z/2 - BEVEL_DEPTH_3), pallet, rot45)
	makeBarrier_3(bSize, cf * CFrame.new(-size.X/2 + BEVEL_DEPTH_3, wallY, size.Z/2 - BEVEL_DEPTH_3), pallet, rot_45)
	makeBarrier_3(bSize, cf * CFrame.new(size.X/2 - BEVEL_DEPTH_3, wallY, -size.Z/2 + BEVEL_DEPTH_3), pallet, rot_45)
	makeBarrier_3(bSize, cf * CFrame.new(-size.X/2 + BEVEL_DEPTH_3, wallY, -size.Z/2 + BEVEL_DEPTH_3), pallet, rot45)

	containmentEnabled_3 = true
	activePallet_3 = pallet
	pallet:SetAttribute("HasCage", true)
end

----------------------------------------------------
-- AUTO CLOSE
----------------------------------------------------
RunService_3.RenderStepped:Connect(function()
	if not containmentEnabled_3 then return end

	if isStandingOnActivePallet_3() then
		leaveTime_3 = nil
	else
		if not leaveTime_3 then
			leaveTime_3 = tick()
		elseif tick() - leaveTime_3 >= AUTO_CLOSE_DELAY_3 then
			cleanup_3()
		end
	end
end)

----------------------------------------------------
-- TOGGLE (F BASILI TUTMA)
----------------------------------------------------
local function handleAction_3(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		local pallet = workspace:FindPartOnRayWithIgnoreList(
			Ray.new(root_3.Position, Vector3.new(0,-10,0)),
			{character_3}
		)
		if pallet and pallet:IsA("BasePart") then
			spawnBarriers_3(pallet)
		end
	elseif inputState == Enum.UserInputState.End then
		cleanup_3()
	end
	return Enum.ContextActionResult.Sink
end

ContextActionService_3:BindAction(
	ACTION_NAME_3,
	handleAction_3,
	false,
	Enum.KeyCode.F
)
