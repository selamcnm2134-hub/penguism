-- Black/White Modern Interface, Instant TP (Weld Abuse), Custom Binds & Detailed Kill Logs
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local character, humanoid, root
local targetPlayer = nil
local tpActive = false
local con = nil
local savedpos = nil

-- Default Settings
local toggleKey = Enum.KeyCode.RightControl
local tpToggleKey = Enum.KeyCode.K
local isBindingUI = false
local isBindingTP = false
local killNotifsEnabled = true

local function updateLocalCharacter(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
end

if LP.Character then updateLocalCharacter(LP.Character) end
LP.CharacterAdded:Connect(updateLocalCharacter)

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernTPMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "INSTANT TP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(0.8, 0, 0, 35)
TargetInput.Position = UDim2.new(0.1, 0, 0.09, 0)
TargetInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.TextColor3 = Color3.fromRGB(0, 0, 0)
TargetInput.PlaceholderText = "Search Player..."
TargetInput.Font = Enum.Font.Gotham
TargetInput.TextSize = 14
TargetInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = TargetInput

-- Player List Dropdown (ScrollingFrame)
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.8, 0, 0, 140)
PlayerListFrame.Position = UDim2.new(0.1, 0, 0.17, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ZIndex = 10
PlayerListFrame.Visible = false
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.Parent = MainFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = PlayerListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = PlayerListFrame

-- Avatar and Info
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 90, 0, 90)
AvatarImage.Position = UDim2.new(0.5, -45, 0.20, 0)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImage.BorderSizePixel = 0
AvatarImage.Image = ""
AvatarImage.Parent = MainFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Size = UDim2.new(1, 0, 0, 20)
DisplayNameLabel.Position = UDim2.new(0, 0, 0.39, 0)
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Text = "Display Name"
DisplayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameLabel.Font = Enum.Font.GothamBold
DisplayNameLabel.TextSize = 15
DisplayNameLabel.Parent = MainFrame

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, 0, 0, 20)
UsernameLabel.Position = UDim2.new(0, 0, 0.43, 0)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = "@username"
UsernameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextSize = 12
UsernameLabel.Parent = MainFrame

-- Buttons Container
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(0.8, 0, 0, 190)
ButtonsFrame.Position = UDim2.new(0.1, 0, 0.52, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Parent = MainFrame

local BtnLayout = Instance.new("UIListLayout")
BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
BtnLayout.Padding = UDim.new(0, 8)
BtnLayout.Parent = ButtonsFrame

local TPButton = Instance.new("TextButton")
TPButton.Size = UDim2.new(1, 0, 0, 45)
TPButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TPButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TPButton.Text = "INSTANT TP: OFF"
TPButton.Font = Enum.Font.GothamBold
TPButton.TextSize = 15
TPButton.Parent = ButtonsFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = TPButton

local NotifToggleButton = Instance.new("TextButton")
NotifToggleButton.Size = UDim2.new(1, 0, 0, 32)
NotifToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NotifToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifToggleButton.Text = "KILL LOGS: ON"
NotifToggleButton.Font = Enum.Font.GothamBold
NotifToggleButton.TextSize = 13
NotifToggleButton.Parent = ButtonsFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = NotifToggleButton

local UIBindButton = Instance.new("TextButton")
UIBindButton.Size = UDim2.new(1, 0, 0, 32)
UIBindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UIBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UIBindButton.Text = "TOGGLE UI BIND: " .. toggleKey.Name
UIBindButton.Font = Enum.Font.GothamBold
UIBindButton.TextSize = 13
UIBindButton.Parent = ButtonsFrame

local BtnCorner3 = Instance.new("UICorner")
BtnCorner3.CornerRadius = UDim.new(0, 6)
BtnCorner3.Parent = UIBindButton

local TPBindButton = Instance.new("TextButton")
TPBindButton.Size = UDim2.new(1, 0, 0, 32)
TPBindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBindButton.Text = "INSTANT TP BIND: " .. tpToggleKey.Name
TPBindButton.Font = Enum.Font.GothamBold
TPBindButton.TextSize = 13
TPBindButton.Parent = ButtonsFrame

local BtnCorner4 = Instance.new("UICorner")
BtnCorner4.CornerRadius = UDim.new(0, 6)
BtnCorner4.Parent = TPBindButton

-- Notification Container (Top Right)
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 250, 0.6, 0) -- Made slightly wider for longer names
NotifContainer.Position = UDim2.new(1, -20, 0, 20)
NotifContainer.AnchorPoint = Vector2.new(1, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Parent = NotifContainer

-- Target Selection Logic
local function selectTarget(p)
    targetPlayer = p
    TargetInput.Text = p.Name
    DisplayNameLabel.Text = p.DisplayName
    UsernameLabel.Text = "@" .. p.Name
    
    local content, isReady = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    if isReady then
        AvatarImage.Image = content
    end
    PlayerListFrame.Visible = false
end

local function updatePlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local filter = TargetInput.Text:lower():gsub("%s+", "")
    local count = 0
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local pName = p.Name:lower()
            local pDisplay = p.DisplayName:lower()
            
            if filter == "" or pName:find(filter) or pDisplay:find(filter) then
                count = count + 1
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -6, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.ZIndex = 11
                btn.Parent = PlayerListFrame
                
                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 4)
                bCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    selectTarget(p)
                end)
            end
        end
    end
    
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 31)
end

TargetInput.Focused:Connect(function()
    PlayerListFrame.Visible = true
    updatePlayerList()
end)

TargetInput:GetPropertyChangedSignal("Text"):Connect(function()
    if TargetInput:IsFocused() then
        PlayerListFrame.Visible = true
        updatePlayerList()
    end
end)

-- Instant TP Logic (Weld Abuse)
local function StopTP()
    if con then 
        con:Disconnect()
        con = nil
    end
    pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end)
    
    if savedpos and root and root.Parent then
        root.CFrame = savedpos
        root.Velocity = Vector3.new()
        root.AssemblyLinearVelocity = Vector3.new()
        root.AssemblyAngularVelocity = Vector3.new()
        root.RotVelocity = Vector3.new()
    end
    savedpos = nil
    tpActive = false
    TPButton.Text = "INSTANT TP: OFF"
    TPButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TPButton.TextColor3 = Color3.fromRGB(0, 0, 0)
end

local function StartTP()
    if not targetPlayer then return end
    if con then StopTP() end
    
    tpActive = true
    TPButton.Text = "INSTANT TP: ON"
    TPButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    savedpos = root.CFrame
    
    local tChar = targetPlayer.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    
    local PO = Vector3.new(0, 0, 0) 
    local RO = CFrame.Angles(0, 0, 0)
    
    con = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent or humanoid.Health <= 0 then
            StopTP()
            return
        end
        
        if not tRoot or not tRoot:IsDescendantOf(workspace) then
            tChar = targetPlayer.Character
            if tChar then
                tRoot = tChar:WaitForChild("HumanoidRootPart", 0.5)
            else
                tRoot = nil
            end
            if not tRoot then return end
        end
        
        local saved = tRoot.CFrame * CFrame.new(PO) * RO
        
        pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tRoot) end)
        
        root.CFrame = saved
        root.Velocity = Vector3.new()
        root.AssemblyLinearVelocity = Vector3.new()
        root.AssemblyAngularVelocity = Vector3.new()
        root.RotVelocity = Vector3.new()
    end)
    
    targetPlayer.CharacterAdded:Connect(function(newChar)
        tChar = newChar
        tRoot = newChar:WaitForChild("HumanoidRootPart")
    end)
end

TPButton.MouseButton1Click:Connect(function()
    if tpActive then StopTP() else StartTP() end
end)

-- Kill Logs Logic
local function sendKillNotification(message)
    if not killNotifsEnabled then return end
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 35)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifFrame.BackgroundTransparency = 1
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = NotifContainer
    
    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 6)
    nCorner.Parent = notifFrame
    
    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(255, 50, 50)
    nStroke.Thickness = 1
    nStroke.Transparency = 1
    nStroke.Parent = notifFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextTransparency = 1
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = 13
    notifText.TextXAlignment = Enum.TextXAlignment.Right
    notifText.Parent = notifFrame
    
    TweenService:Create(notifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(nStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(notifText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(4, function() -- Bildirim süresini biraz uzattım isimlerin rahat okunması için (4 saniye)
        local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenService:Create(nStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(notifText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        tweenOut:Play()
        tweenOut.Completed:Connect(function() notifFrame:Destroy() end)
    end)
end

local function trackPlayer(player)
    if player == LP then return end
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function() 
                sendKillNotification(player.DisplayName .. " (@" .. player.Name .. ") died") 
            end)
        end
    end)
    
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Died:Connect(function() 
            sendKillNotification(player.DisplayName .. " (@" .. player.Name .. ") died") 
        end)
    end
end

for _, p in ipairs(Players:GetPlayers()) do trackPlayer(p) end
Players.PlayerAdded:Connect(trackPlayer)

-- Buttons Connects
NotifToggleButton.MouseButton1Click:Connect(function()
    killNotifsEnabled = not killNotifsEnabled
    NotifToggleButton.Text = killNotifsEnabled and "KILL LOGS: ON" or "KILL LOGS: OFF"
    NotifToggleButton.TextColor3 = killNotifsEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
end)

UIBindButton.MouseButton1Click:Connect(function()
    isBindingUI = true
    UIBindButton.Text = "PRESS A KEY..."
end)

TPBindButton.MouseButton1Click:Connect(function()
    isBindingTP = true
    TPBindButton.Text = "PRESS A KEY..."
end)

-- Keyboard Inputs for Binds
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if isBindingUI then
            toggleKey = input.KeyCode
            UIBindButton.Text = "TOGGLE UI BIND: " .. toggleKey.Name
            isBindingUI = false
            return
        elseif isBindingTP then
            tpToggleKey = input.KeyCode
            TPBindButton.Text = "INSTANT TP BIND: " .. tpToggleKey.Name
            isBindingTP = false
            return
        end
    end
    
    if not gpe then
        if input.KeyCode == toggleKey then
            MainFrame.Visible = not MainFrame.Visible
            PlayerListFrame.Visible = false
        elseif input.KeyCode == tpToggleKey then
            if tpActive then StopTP() else StartTP() end
        end
    end
end)

-- UI Dragging
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isBindingUI and not isBindingTP then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
