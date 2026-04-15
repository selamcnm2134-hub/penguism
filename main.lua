--// LIBRARY
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

--// WINDOW
local Window = Library:CreateWindow({
    Title = "Penguizm Hub | Pro Sniper",
    Footer = "v1.4",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

--// TABS
local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Sniper = Window:AddTab("Sniper", "target"),
    Visuals = Window:AddTab("Visuals", "eye"),
    World = Window:AddTab("World", "globe"),
    Misc = Window:AddTab("Misc", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--// ================= MAIN TAB =================

local AimBox = Tabs.Main:AddLeftGroupbox("Aim")

AimBox:AddToggle("AimEnabled", {Text="Aimbot (Smooth)"}):AddKeyPicker("AimBind", {
    Default = "E",
    SyncToggleState = false,
    Mode = "Hold",
    Text = "Aimbot Key"
})

AimBox:AddToggle("Trigger", {Text="Triggerbot"}):AddKeyPicker("TriggerBind", {
    Default = "Q",
    SyncToggleState = false,
    Mode = "Hold",
    Text = "Triggerbot Key"
})

AimBox:AddToggle("ShowFOV", {Text="Show FOV Circle"})
AimBox:AddToggle("Silent", {Text="Silent Aim"})
AimBox:AddToggle("WallCheck", {Text="Wall Check"})
AimBox:AddToggle("VisibleCheck", {Text="Visible Check"})
AimBox:AddToggle("Prediction", {Text="Prediction"})
AimBox:AddToggle("RecoilControl", {Text="Recoil Control"})

AimBox:AddSlider("FOV", {Text="FOV", Default=150, Min=0, Max=500})
AimBox:AddSlider("Smooth", {Text="Smoothness", Default=50, Min=1, Max=100})
AimBox:AddSlider("TriggerDelay", {Text="Trigger Delay", Default=50, Min=0, Max=300})

AimBox:AddDropdown("Priority", {
    Values={"Closest","Lowest HP","Crosshair","Random"},
    Default=1,
    Text="Target Priority"
})

AimBox:AddDropdown("Hitbox", {
    Values={"Head","Neck","Chest","Pelvis","Random"},
    Default=1,
    Text="Hitbox"
})

local MoveBox = Tabs.Main:AddRightGroupbox("Movement")
MoveBox:AddToggle("Fly", {Text="Fly"})
MoveBox:AddToggle("Noclip", {Text="Noclip"})
MoveBox:AddToggle("Bhop", {Text="Bunny Hop"})
MoveBox:AddToggle("InfJump", {Text="Infinite Jump"})
MoveBox:AddToggle("Freecam", {Text="Free View"})
MoveBox:AddToggle("AntiAFK", {Text="Anti AFK"})

MoveBox:AddSlider("Speed", {Text="Speed", Default=16, Min=16, Max=200})
MoveBox:AddSlider("Jump", {Text="Jump Power", Default=50, Min=50, Max=200})

local RageBox = Tabs.Main:AddRightGroupbox("Rage")
RageBox:AddToggle("KillAll", {Text="Kill All (Manual Fly)"})
RageBox:AddToggle("AutoFire", {Text="Auto Fire"})
RageBox:AddToggle("NoRecoil", {Text="No Recoil"})
RageBox:AddToggle("NoSpread", {Text="No Spread"})
RageBox:AddToggle("InfAmmo", {Text="Unlimited Ammo"})
RageBox:AddToggle("InstantReload", {Text="Instant Reload"})
RageBox:AddToggle("Spinbot", {Text="Spinbot"})
RageBox:AddToggle("AntiAim", {Text="Anti Aim"})

--// ================= SNIPER TAB =================
local SniperBox = Tabs.Sniper:AddLeftGroupbox("Sniper Settings")

SniperBox:AddToggle("SniperNoScope", {Text="No Scope Overlay"})
SniperBox:AddToggle("CamLock", {Text="Camera Lock (Instant)"}):AddKeyPicker("CamLockBind", {
    Default = "C",
    SyncToggleState = false,
    Mode = "Hold",
    Text = "Cam Lock Key"
})
SniperBox:AddToggle("SniperKillAll", {Text="Sniper Kill All (Furthest First)"})


--// ================= VISUALS =================

local ESPBox = Tabs.Visuals:AddLeftGroupbox("ESP")
ESPBox:AddToggle("Box", {Text="Box ESP"})
ESPBox:AddToggle("Skeleton", {Text="Skeleton"})
ESPBox:AddToggle("Head", {Text="Head Dot"})
ESPBox:AddToggle("Health", {Text="Health Bar"})
ESPBox:AddToggle("Name", {Text="Name"})
ESPBox:AddToggle("Distance", {Text="Distance"})
ESPBox:AddToggle("Tracer", {Text="Tracer"})

ESPBox:AddSlider("MaxDist", {
    Text="Max Distance",
    Default=1000,
    Min=100,
    Max=5000
})

--// ================= WORLD =================

local WorldBox = Tabs.World:AddLeftGroupbox("World")
WorldBox:AddToggle("ItemESP", {Text="Item ESP"})
WorldBox:AddToggle("NoFog", {Text="No Fog"})
WorldBox:AddToggle("Night", {Text="Night Mode"})

WorldBox:AddSlider("Brightness", {Text="Brightness", Default=1, Min=0, Max=5})
WorldBox:AddSlider("FogDistance", {Text="Fog Distance", Default=100, Min=0, Max=1000})

--// ================= MISC =================

local MiscBox = Tabs.Misc:AddLeftGroupbox("Misc")
MiscBox:AddToggle("AutoRejoin", {Text="Auto Rejoin"})
MiscBox:AddToggle("HitSound", {Text="Hit Sound"})

MiscBox:AddToggle("CustomCrosshair", {Text="Custom Crosshair"})
MiscBox:AddSlider("CrosshairSize", {Text="Crosshair Size", Default=40, Min=10, Max=150})
MiscBox:AddSlider("CrosshairSpin", {Text="Spin Speed", Default=3, Min=0, Max=20})

MiscBox:AddButton("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local SkinBox = Tabs.Misc:AddRightGroupbox("Skin Changer")
SkinBox:AddInput("SkinID", {
    Default = "12345678",
    Numeric = true,
    Finished = true,
    Text = "Custom Texture ID",
})
SkinBox:AddButton("Apply Skin to Tool", function()
    local targetID = Options.SkinID.Value
    local character = game.Players.LocalPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            for _, part in pairs(tool:GetDescendants()) do
                if part:IsA("MeshPart") or part:IsA("SpecialMesh") then
                    part.TextureID = "rbxassetid://" .. targetID
                elseif part:IsA("Part") or part:IsA("UnionOperation") then
                    local tex = part:FindFirstChildOfClass("Texture") or Instance.new("Texture", part)
                    tex.Texture = "rbxassetid://" .. targetID
                    tex.Face = Enum.NormalId.Front
                end
            end
            Library:Notify("Skin Uygulandı: " .. targetID)
        else
            Library:Notify("Hata: Elinde bir silah olmalı!")
        end
    end
end)
SkinBox:AddToggle("RainbowSkin", {Text = "Rainbow Tool (RGB)"})

--// ================= UI SETTINGS =================

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("PenguizmHub")
SaveManager:SetFolder("PenguizmHub/configs")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

--// ================= ENGINE V5.5 =================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ESP_Objects = {}

-- [ FOV CIRCLE ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.NumSides = 60
FOVCircle.Visible = false

-- [ CUSTOM CROSSHAIR SETUP ]
local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "PenguizmCrosshair"
CrosshairGui.IgnoreGuiInset = true
if game.CoreGui:FindFirstChild("PenguizmCrosshair") then
    game.CoreGui.PenguizmCrosshair:Destroy()
end
CrosshairGui.Parent = game.CoreGui

local CrosshairImage = Instance.new("ImageLabel")
CrosshairImage.Parent = CrosshairGui
CrosshairImage.BackgroundTransparency = 1
CrosshairImage.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairImage.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairImage.Image = "rbxassetid://5830306048" 
CrosshairImage.Visible = false

-- [ UTILS ]
local function GetTarget()
    local closestDist = Options.FOV.Value
    local target = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(Options.Hitbox.Value == "Random" and "Head" or Options.Hitbox.Value) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < closestDist then
                        if Toggles.VisibleCheck.Value and #Camera:GetPartsObscuringTarget({Camera.CFrame.Position, part.Position}, {LocalPlayer.Character, player.Character}) > 0 then continue end
                        closestDist = dist; target = part
                    end
                end
            end
        end
    end
    return target
end

local function GetFurthestTarget()
    local furthestDist = 0
    local target = nil
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local dist = (myPos - part.Position).Magnitude
                if dist > furthestDist then
                    furthestDist = dist
                    target = part
                end
            end
        end
    end
    return target
end

local function HideESP(obj)
    obj.Box.Visible = false
    obj.Name.Visible = false
    obj.Distance.Visible = false
    obj.Tracer.Visible = false
    obj.HealthBar.Visible = false
    obj.HealthBG.Visible = false
    obj.HeadDot.Visible = false
    for _, line in ipairs(obj.Skeleton) do line.Visible = false end
end

local function CreateESP(player)
    local obj = {
        Box = Drawing.new("Square"), 
        Name = Drawing.new("Text"), 
        Distance = Drawing.new("Text"), 
        Tracer = Drawing.new("Line"),
        HealthBar = Drawing.new("Square"), 
        HealthBG = Drawing.new("Square"), 
        HeadDot = Drawing.new("Circle"),
        Skeleton = {Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")}
    }
    obj.Name.Size = 22; obj.Name.Center = true; obj.Name.Outline = true; obj.Name.Color = Color3.new(1, 1, 1)
    obj.Distance.Size = 18; obj.Distance.Center = true; obj.Distance.Outline = true; obj.Distance.Color = Color3.new(0.8, 0.8, 0.8)
    obj.HealthBG.Filled = true; obj.HealthBG.Color = Color3.new(0, 0, 0)
    obj.HealthBar.Filled = true
    HideESP(obj)
    ESP_Objects[player] = obj
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(p) if ESP_Objects[p] then HideESP(ESP_Objects[p]); ESP_Objects[p] = nil end end)

-- [ FIXED INFINITE JUMP ]
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [ NOCLIP ]
RunService.Stepped:Connect(function()
    if Toggles.Noclip.Value and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [ RAINBOW SKIN COROUTINE ]
task.spawn(function()
    while task.wait() do
        if Toggles.RainbowSkin and Toggles.RainbowSkin.Value then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local hue = tick() % 5 / 5
                    local color = Color3.fromHSV(hue, 1, 1)
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") then part.Color = color end
                    end
                end
            end
        end
    end
end)

-- [ CORE LOOP ]
RunService.RenderStepped:Connect(function()
    local target = GetTarget()
    
    -- FOV Update
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Options.FOV.Value
    FOVCircle.Visible = Toggles.ShowFOV.Value

    -- FIXED BUNNY HOP
    if Toggles.Bhop.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end

    -- FIXED SPINBOT
    if Toggles.Spinbot.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end

    -- FLY (UÇMA) MANTIĞI
    if Toggles.Fly.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local speed = Options.Speed.Value / 10
        local camCFrame = Camera.CFrame
        hrp.Velocity = Vector3.zero 

        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end

        if moveDir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (moveDir.Unit * speed) end
    end

    -- KILL ALL MANTIĞI (RAGE)
    if Toggles.KillAll.Value and target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        if mouse1click then mouse1click() end
    end

    -- SNIPER KILL ALL (EN UZAK OYUNCU)
    if Toggles.SniperKillAll.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local furthestTarget = GetFurthestTarget()
        if furthestTarget then
            -- Adamın biraz arkasına veya üstüne ışınlan
            LocalPlayer.Character.HumanoidRootPart.CFrame = furthestTarget.CFrame * CFrame.new(0, 3, 5)
            -- Kamerayı direk adama kilitle
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, furthestTarget.Position)
            -- Ateş et
            if mouse1click then mouse1click() end
        end
    end

    -- SNIPER CAMERA LOCK (INSTANT)
    local camLockPressed = Options.CamLockBind:GetState()
    if Toggles.CamLock.Value and camLockPressed and target then
        -- Saniyesinde şak diye kilitlenir, smoothing yoktur.
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end

    -- NO RECOIL / NO SPREAD
    if (Toggles.NoRecoil.Value or Toggles.NoSpread.Value) and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    local name = v.Name:lower()
                    if Toggles.NoRecoil.Value and (name:match("recoil") or name:match("kick") or name:match("camshake")) then v.Value = 0 end
                    if Toggles.NoSpread.Value and (name:match("spread") or name:match("accuracy") or name:match("bloom")) then v.Value = 0 end
                end
            end
        end
    end

    -- SNIPER NO SCOPE
    if Toggles.SniperNoScope.Value and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                local name = gui.Name:lower()
                if name:match("scope") or name:match("sniper") or name:match("reticle") or name:match("crosshair") then
                    gui.ImageTransparency = 1
                    gui.BackgroundTransparency = 1
                end
            end
        end
    end

    -- Normal Aimbot (Smooth)
    local aimKeyPressed = Options.AimBind:GetState()
    if Toggles.AimEnabled.Value and aimKeyPressed and target and not Toggles.KillAll.Value and not Toggles.CamLock.Value then
        local pos = Camera:WorldToViewportPoint(target.Position)
        local s = (101 - Options.Smooth.Value) / 10
        if mousemoverel then mousemoverel((pos.X - UserInputService:GetMouseLocation().X)/s, (pos.Y - UserInputService:GetMouseLocation().Y)/s) end
    end

    -- Triggerbot
    local triggerKeyPressed = Options.TriggerBind:GetState()
    if Toggles.Trigger.Value and triggerKeyPressed and not Toggles.KillAll.Value and not Toggles.SniperKillAll.Value then
        local hitTarget = Mouse.Target
        if hitTarget and hitTarget.Parent and hitTarget.Parent:FindFirstChild("Humanoid") then
            local targetPlayer = Players:GetPlayerFromCharacter(hitTarget.Parent)
            if targetPlayer and targetPlayer ~= LocalPlayer and targetPlayer.Character.Humanoid.Health > 0 then
                if mouse1click then mouse1click() end
                task.wait(Options.TriggerDelay.Value / 1000)
            end
        end
    end

    -- Custom Crosshair Logic
    if Toggles.CustomCrosshair.Value then
        UserInputService.MouseIconEnabled = false
        CrosshairImage.Visible = true
        CrosshairImage.Size = UDim2.new(0, Options.CrosshairSize.Value, 0, Options.CrosshairSize.Value)
        CrosshairImage.Rotation = CrosshairImage.Rotation + Options.CrosshairSpin.Value
    else
        UserInputService.MouseIconEnabled = true
        CrosshairImage.Visible = false
    end

    -- ESP
    for p, obj in pairs(ESP_Objects) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local p_hrp = p.Character.HumanoidRootPart
            local pos, screen = Camera:WorldToViewportPoint(p_hrp.Position)
            local dist = (Camera.CFrame.Position - p_hrp.Position).Magnitude
            
            if screen and dist <= Options.MaxDist.Value then
                local h = 3000 / pos.Z; local w = 2000 / pos.Z
                
                obj.Box.Visible = Toggles.Box.Value; obj.Box.Size = Vector2.new(w, h); obj.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                obj.Name.Visible = Toggles.Name.Value; obj.Name.Text = p.Name; obj.Name.Position = Vector2.new(pos.X, pos.Y - h/2 - 22)
                obj.Distance.Visible = Toggles.Distance.Value; obj.Distance.Text = math.floor(dist) .. "m"; obj.Distance.Position = Vector2.new(pos.X, pos.Y + h/2 + 5)
                obj.Tracer.Visible = Toggles.Tracer.Value; obj.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); obj.Tracer.To = Vector2.new(pos.X, pos.Y + h/2)
                
                if Toggles.Health.Value then
                    local health = p.Character.Humanoid.Health; local maxHealth = p.Character.Humanoid.MaxHealth; local healthPercent = health / maxHealth
                    obj.HealthBG.Visible = true; obj.HealthBG.Size = Vector2.new(4, h + 2); obj.HealthBG.Position = Vector2.new(pos.X - w/2 - 6, pos.Y - h/2 - 1)
                    obj.HealthBar.Visible = true; obj.HealthBar.Size = Vector2.new(2, h * healthPercent); obj.HealthBar.Position = Vector2.new(pos.X - w/2 - 5, (pos.Y + h/2) - (h * healthPercent))
                    obj.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                else
                    obj.HealthBG.Visible = false; obj.HealthBar.Visible = false
                end

                if p.Character:FindFirstChild("Head") then
                    local headPos = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    obj.HeadDot.Visible = Toggles.Head.Value; obj.HeadDot.Position = Vector2.new(headPos.X, headPos.Y); obj.HeadDot.Radius = 3
                end

                if Toggles.Skeleton.Value then
                    local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
                    for i, part in ipairs(parts) do
                        if p.Character:FindFirstChild(part) and obj.Skeleton[i] then
                            local p1 = Camera:WorldToViewportPoint(p.Character[part].Position)
                            obj.Skeleton[i].Visible = true; obj.Skeleton[i].From = Vector2.new(pos.X, pos.Y); obj.Skeleton[i].To = Vector2.new(p1.X, p1.Y)
                        end
                    end
                else 
                    for _, l in ipairs(obj.Skeleton) do l.Visible = false end 
                end
            else HideESP(obj) end
        else HideESP(obj) end
    end
end)

Library:Notify({Title = "Penguizm Hub", Description = "Engine V5.5 | Sniper Update & Fixes Applied!", Time = 5})
