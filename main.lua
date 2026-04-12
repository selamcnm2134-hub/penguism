--// LIBRARY
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

--// WINDOW
local Window = Library:CreateWindow({
    Title = "Penguizm Hub",
    Footer = "v1.2",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

--// TABS
local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Visuals = Window:AddTab("Visuals", "eye"),
    World = Window:AddTab("World", "globe"),
    Misc = Window:AddTab("Misc", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--// ================= MAIN TAB =================

local AimBox = Tabs.Main:AddLeftGroupbox("Aim")

AimBox:AddToggle("AimEnabled", {Text="Aimbot"}):AddKeyPicker("AimBind", {
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
RageBox:AddToggle("KillAll", {Text="Kill All"})
RageBox:AddToggle("AutoFire", {Text="Auto Fire"})
RageBox:AddToggle("NoRecoil", {Text="No Recoil"})
RageBox:AddToggle("NoSpread", {Text="No Spread"})
RageBox:AddToggle("InfAmmo", {Text="Unlimited Ammo"})
RageBox:AddToggle("InstantReload", {Text="Instant Reload"})
RageBox:AddToggle("Spinbot", {Text="Spinbot"})
RageBox:AddToggle("AntiAim", {Text="Anti Aim"})

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

--// ================= ENGINE V5.3 =================

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

-- ESP Gizleme (Ghosting'i önler)
local function HideESP(obj)
    obj.Box.Visible = false
    obj.Name.Visible = false
    obj.Distance.Visible = false
    obj.Tracer.Visible = false
    obj.HealthBar.Visible = false
    obj.HealthBG.Visible = false
    obj.HeadDot.Visible = false
    for _, line in ipairs(obj.Skeleton) do 
        line.Visible = false 
    end
end

-- [ ESP OLUŞTURMA ]
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
    
    -- Name ve Distance Ayarları (Büyütüldü)
    obj.Name.Size = 22
    obj.Name.Center = true
    obj.Name.Outline = true
    obj.Name.Color = Color3.new(1, 1, 1)

    obj.Distance.Size = 18
    obj.Distance.Center = true
    obj.Distance.Outline = true
    obj.Distance.Color = Color3.new(0.8, 0.8, 0.8)

    -- Can barı arkaplan ayarları
    obj.HealthBG.Filled = true
    obj.HealthBG.Color = Color3.new(0, 0, 0)
    
    -- Can barı ön plan ayarları
    obj.HealthBar.Filled = true

    HideESP(obj)
    ESP_Objects[player] = obj
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(p) 
    if ESP_Objects[p] then 
        HideESP(ESP_Objects[p]) 
        ESP_Objects[p] = nil 
    end 
end)

-- [ CORE LOOP ]
RunService.RenderStepped:Connect(function()
    local target = GetTarget()
    
    -- FOV Update
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Options.FOV.Value
    FOVCircle.Visible = Toggles.ShowFOV.Value

    -- KILL ALL MANTIĞI (Gökyüzüne TP, Kamera Kilidi, Oto Ateş)
    if Toggles.KillAll.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        -- Oyuncuyu gökyüzünde (Y ekseninde) sabit tut (500 stud yukarıda)
        hrp.CFrame = CFrame.new(hrp.Position.X, 500, hrp.Position.Z)
        hrp.Velocity = Vector3.new(0,0,0)

        -- Kilitlenecek kurban bul (GetTarget ekrandaki en yakını alır, istersen bunu rastgele biriyle değiştirebilirsin)
        if target then
            -- Kamerayı hedefe kilitle
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            
            -- Otomatik ateş et
            if mouse1click then 
                mouse1click() 
            end
        end
    end

    -- Normal Aimbot
    local aimKeyPressed = Options.AimBind:GetState()
    if Toggles.AimEnabled.Value and aimKeyPressed and target and not Toggles.KillAll.Value then
        local pos = Camera:WorldToViewportPoint(target.Position)
        local s = (101 - Options.Smooth.Value) / 10
        if mousemoverel then mousemoverel((pos.X - UserInputService:GetMouseLocation().X)/s, (pos.Y - UserInputService:GetMouseLocation().Y)/s) end
    end

    -- Triggerbot
    local triggerKeyPressed = Options.TriggerBind:GetState()
    if Toggles.Trigger.Value and triggerKeyPressed and not Toggles.KillAll.Value then
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

    -- ESP & Ghosting Fix & Yeni Eklemeler
    for p, obj in pairs(ESP_Objects) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local p_hrp = p.Character.HumanoidRootPart
            local pos, screen = Camera:WorldToViewportPoint(p_hrp.Position)
            local dist = (Camera.CFrame.Position - p_hrp.Position).Magnitude
            
            if screen and dist <= Options.MaxDist.Value then
                local h = 3000 / pos.Z; local w = 2000 / pos.Z
                
                -- Kutu
                obj.Box.Visible = Toggles.Box.Value; 
                obj.Box.Size = Vector2.new(w, h); 
                obj.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                
                -- İsim (Büyütüldü)
                obj.Name.Visible = Toggles.Name.Value; 
                obj.Name.Text = p.Name; 
                obj.Name.Position = Vector2.new(pos.X, pos.Y - h/2 - 22)
                
                -- Mesafe (Eklendi)
                obj.Distance.Visible = Toggles.Distance.Value
                obj.Distance.Text = math.floor(dist) .. "m"
                obj.Distance.Position = Vector2.new(pos.X, pos.Y + h/2 + 5)

                -- Tracer
                obj.Tracer.Visible = Toggles.Tracer.Value; 
                obj.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); 
                obj.Tracer.To = Vector2.new(pos.X, pos.Y + h/2)
                
                -- Healthbar (Eklendi)
                if Toggles.Health.Value then
                    local health = p.Character.Humanoid.Health
                    local maxHealth = p.Character.Humanoid.MaxHealth
                    local healthPercent = health / maxHealth
                    
                    obj.HealthBG.Visible = true
                    obj.HealthBG.Size = Vector2.new(4, h + 2)
                    obj.HealthBG.Position = Vector2.new(pos.X - w/2 - 6, pos.Y - h/2 - 1)
                    
                    obj.HealthBar.Visible = true
                    obj.HealthBar.Size = Vector2.new(2, h * healthPercent)
                    obj.HealthBar.Position = Vector2.new(pos.X - w/2 - 5, (pos.Y + h/2) - (h * healthPercent))
                    
                    -- Can azaldıkça yeşilden kırmızıya geçiş yapar
                    obj.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                else
                    obj.HealthBG.Visible = false
                    obj.HealthBar.Visible = false
                end

                if p.Character:FindFirstChild("Head") then
                    local headPos = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    obj.HeadDot.Visible = Toggles.Head.Value
                    obj.HeadDot.Position = Vector2.new(headPos.X, headPos.Y); obj.HeadDot.Radius = 3
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
            else 
                HideESP(obj)
            end
        else 
            HideESP(obj)
        end
    end
end)

Library:Notify({Title = "Penguizm Hub", Description = "Engine V5.3 | ESP Fixes & KillAll Added", Time = 5})
