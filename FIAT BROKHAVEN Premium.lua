-- Fiat Hub UI - Updated (Select Player & Spectate + fixes)
-- Single-file LocalScript for client (CoreGui/PlayerGui). Copy-paste pronto para colar.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHub_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main window
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 600, 0, 220) -- maior
Window.Position = UDim2.new(0.3, 0, 0.3, 0)
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundTransparency = 0.12
Window.BackgroundColor3 = Color3.fromRGB(36,36,36)
Window.Active = true
Window.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 18)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.6
WindowStroke.Parent = Window

-- Top bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Window

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, -12, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FIAT HUB"
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.TextStrokeTransparency = 0.85
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(0.3, -12, 1, 0)
Subtitle.Position = UDim2.new(0.7, 12, 0, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "by: fiat gordin"
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.SourceSans
Subtitle.TextXAlignment = Enum.TextXAlignment.Right
Subtitle.TextColor3 = Color3.fromRGB(230,230,230)
Subtitle.Parent = TopBar

-- Controls (icons only)
local Controls = Instance.new("Frame")
Controls.Name = "Controls"
Controls.Size = UDim2.new(0, 100, 1, 0)
Controls.Position = UDim2.new(1, -100, 0, 0)
Controls.AnchorPoint = Vector2.new(1, 0)
Controls.BackgroundTransparency = 1
Controls.Parent = TopBar

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlsLayout.Padding = UDim.new(0, 6)
controlsLayout.Parent = Controls

local function MakeIconButton(symbol, name)
    local btn = Instance.new("TextButton")
    btn.Name = name or "IconBtn"
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.AutoButtonColor = true
    btn.Text = symbol
    btn.TextScaled = true
    btn.BackgroundTransparency = 0.25
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Controls
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local MinimizeBtn = MakeIconButton("—", "Minimize")
local CloseBtn = MakeIconButton("✕", "Close")

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -56)
Content.Position = UDim2.new(0, 8, 0, 48)
Content.BackgroundTransparency = 1
Content.Parent = Window

-- Left icons (main icons column)
local LeftIcons = Instance.new("Frame")
LeftIcons.Name = "LeftIcons"
LeftIcons.Size = UDim2.new(0, 56, 1, 0)
LeftIcons.Position = UDim2.new(0, 8, 0, 0)
LeftIcons.BackgroundTransparency = 1
LeftIcons.Parent = Content

local leftLayout = Instance.new("UIListLayout")
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftLayout.Padding = UDim.new(0, 10)
leftLayout.Parent = LeftIcons

-- Middle area for function area and dynamic buttons below icons
local Middle = Instance.new("Frame")
Middle.Name = "Middle"
Middle.Size = UDim2.new(1, -160, 1, 0)
Middle.Position = UDim2.new(0, 80, 0, 0)
Middle.BackgroundTransparency = 1
Middle.Parent = Content

local middleTop = Instance.new("Frame")
middleTop.Size = UDim2.new(1, 0, 0.6, 0)
middleTop.Position = UDim2.new(0, 0, 0, 0)
middleTop.BackgroundTransparency = 1
middleTop.Parent = Middle

local middleBottom = Instance.new("Frame")
middleBottom.Size = UDim2.new(1, 0, 0.4, 0)
middleBottom.Position = UDim2.new(0, 0, 0.6, 0)
middleBottom.BackgroundTransparency = 1
middleBottom.Parent = Middle

local topLayout = Instance.new("UIListLayout")
topLayout.FillDirection = Enum.FillDirection.Vertical
topLayout.SortOrder = Enum.SortOrder.LayoutOrder
topLayout.Padding = UDim.new(0, 8)
topLayout.Parent = middleTop

local bottomLayout = Instance.new("UIListLayout")
bottomLayout.FillDirection = Enum.FillDirection.Horizontal
bottomLayout.SortOrder = Enum.SortOrder.LayoutOrder
bottomLayout.Padding = UDim.new(0, 8)
bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
bottomLayout.Parent = middleBottom

-- Right icons column
local RightIcons = Instance.new("Frame")
RightIcons.Name = "RightIcons"
RightIcons.Size = UDim2.new(0, 56, 1, 0)
RightIcons.Position = UDim2.new(1, -64, 0, 0)
RightIcons.AnchorPoint = Vector2.new(1, 0)
RightIcons.BackgroundTransparency = 1
RightIcons.Parent = Content

local rightLayout = Instance.new("UIListLayout")
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.VerticalAlignment = Enum.VerticalAlignment.Top
rightLayout.Padding = UDim.new(0, 10)
rightLayout.Parent = RightIcons

-- Top-left small icons (home, gear)
local TopLeftIcons = Instance.new("Frame")
TopLeftIcons.Name = "TopLeftIcons"
TopLeftIcons.Size = UDim2.new(0, 80, 0, 36)
TopLeftIcons.Position = UDim2.new(0, 0, 0, 0)
TopLeftIcons.BackgroundTransparency = 1
TopLeftIcons.Parent = Middle

local homeBtn = Instance.new("TextButton")
homeBtn.Size = UDim2.new(0, 32, 0, 32)
homeBtn.Position = UDim2.new(0, 4, 0, 2)
homeBtn.Text = "🏠"
homeBtn.BackgroundTransparency = 0.25
homeBtn.Font = Enum.Font.SourceSansBold
homeBtn.Parent = TopLeftIcons
local hcorner = Instance.new("UICorner")
hcorner.CornerRadius = UDim.new(0, 8)
hcorner.Parent = homeBtn

local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.new(0, 32, 0, 32)
gearBtn.Position = UDim2.new(0, 44, 0, 2)
gearBtn.Text = "⚙"
gearBtn.BackgroundTransparency = 0.25
gearBtn.Font = Enum.Font.SourceSansBold
gearBtn.Parent = TopLeftIcons
local gcorner = Instance.new("UICorner")
gcorner.CornerRadius = UDim.new(0, 8)
gcorner.Parent = gearBtn

-- Sidebar (slides from left)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.Position = UDim2.new(-1, 0, 0, 0)
Sidebar.BackgroundTransparency = 0.08
Sidebar.BackgroundColor3 = Color3.fromRGB(28,28,28)
Sidebar.Parent = Window
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 12)
sbCorner.Parent = Sidebar

local sbLayout = Instance.new("UIListLayout")
sbLayout.FillDirection = Enum.FillDirection.Vertical
sbLayout.Padding = UDim.new(0, 8)
sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sbLayout.Parent = Sidebar

-- State
local closedPermanently = false
local minimized = false
local sidebarOpen = false
local compactMode = false

-- Title rainbow (only title; other letters white)
local hue = 0
local function HSLToRGB(h, s, l)
    local function hue2rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1/6 then return p + (q - p) * 6 * t end
        if t < 1/2 then return q end
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
        return p
    end
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local q = l < 0.5 and (l * (1 + s)) or (l + s - l * s)
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end
    return Color3.new(r, g, b)
end

RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.09) % 1
    Title.TextColor3 = HSLToRGB(hue, 0.7, 0.52)
end)

-- Draggable window (fix: drag TopBar only for reliability)
local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        Window:TweenSize(UDim2.new(0, 600, 0, 220), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        Content.Visible = true
        minimized = false
    else
        Window:TweenSize(UDim2.new(0, 260, 0, 48), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        Content.Visible = false
        minimized = true
    end
end)

-- Close permanently
CloseBtn.MouseButton1Click:Connect(function()
    closedPermanently = true
    ScreenGui:Destroy()
end)

-- Toggle with K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        if closedPermanently then return end
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Sidebar toggle
homeBtn.MouseButton1Click:Connect(function()
    sidebarOpen = not sidebarOpen
    if sidebarOpen then
        Sidebar:TweenPosition(UDim2.new(0, 12, 0.2, -20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    else
        Sidebar:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    end
end)

-- Gear compact
gearBtn.MouseButton1Click:Connect(function()
    compactMode = not compactMode
    if compactMode then
        for _, v in ipairs(RightIcons:GetChildren()) do
            if v:IsA("TextButton") then
                v:TweenSize(UDim2.new(0, 20, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                v.TextSize = 14
            end
        end
        Window.BackgroundTransparency = 0.3
    else
        for _, v in ipairs(RightIcons:GetChildren()) do
            if v:IsA("TextButton") then
                v:TweenSize(UDim2.new(0, 30, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                v.TextSize = 18
            end
        end
        Window.BackgroundTransparency = 0.12
    end
end)

-- Utility: clear middle top (function cards) and bottom (buttons)
local function ClearMiddle()
    for _, v in ipairs(middleTop:GetChildren()) do
        if v.Name:find("_card") or v:IsA("Frame") then
            v:Destroy()
        end
    end
    for _, v in ipairs(middleBottom:GetChildren()) do
        if v.Name:find("_btn") or v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

-- Function card creator (fixed toggle behavior and dot movement)
local function CreateFunctionCard(name, desc)
    local card = Instance.new("Frame")
    card.Name = name .. "_card"
    card.Size = UDim2.new(1, -12, 0, 46)
    card.BackgroundTransparency = 0.08
    card.BackgroundColor3 = Color3.fromRGB(22,22,22)
    card.Parent = middleTop
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local label = Instance.new("TextLabel")
    label.Parent = card
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextSize = 16
    label.Font = Enum.Font.SourceSansSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextColor3 = Color3.fromRGB(230,230,230)

    -- Toggle
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = UDim2.new(1, -76, 0.5, -15)
    toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    toggle.Parent = card
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 15)
    tc.Parent = toggle

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 24, 0, 24)
    dot.Position = UDim2.new(0, 3, 0.5, -12)
    dot.BackgroundColor3 = Color3.fromRGB(240,240,240)
    dot.Parent = toggle
    local dcorner = Instance.new("UICorner")
    dcorner.CornerRadius = UDim.new(1, 0)
    dcorner.Parent = dot

    local active = false
    local function SetState(state)
        active = state
        if active then
            dot:TweenPosition(UDim2.new(1, -27, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.14, true)
            toggle.BackgroundColor3 = Color3.fromRGB(200,200,200) -- branco em vez de azul
            dot.BackgroundColor3 = Color3.fromRGB(36,36,36)
        else
            dot:TweenPosition(UDim2.new(0, 3, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.14, true)
            toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
            dot.BackgroundColor3 = Color3.fromRGB(240,240,240)
        end
    end

    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SetState(not active)
            if card.OnToggle then
                pcall(card.OnToggle, active)
            end
        end
    end)

    card.SetState = SetState
    return card
end

-- Player highlight feature
local highlightEnabled = false
local playerHighlights = {}
local playerAddedConn, playerRemovedConn

local function ClearHighlights()
    for plr, objs in pairs(playerHighlights) do
        if objs.Highlight and objs.Highlight.Parent then objs.Highlight:Destroy() end
        if objs.Billboard and objs.Billboard.Parent then objs.Billboard:Destroy() end
    end
    playerHighlights = {}
end

local function updateHighlights()
    ClearHighlights()
    if not highlightEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local h = Instance.new("Highlight")
            h.Name = "FiatHighlight"
            h.Adornee = char
            h.FillTransparency = 1
            h.OutlineTransparency = 0
            h.OutlineColor = Color3.fromRGB(255,255,255)
            h.Parent = char
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if head then
                local bg = Instance.new("BillboardGui")
                bg.Name = "FiatName"
                bg.Adornee = head
                bg.Size = UDim2.new(0, 120, 0, 30)
                bg.StudsOffset = Vector3.new(0, 2.2, 0)
                bg.AlwaysOnTop = true
                bg.Parent = char
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = plr.Name
                txt.Font = Enum.Font.SourceSansSemibold
                txt.TextSize = 14
                txt.TextColor3 = Color3.fromRGB(255,255,255)
                txt.Parent = bg
                playerHighlights[plr] = {Highlight = h, Billboard = bg}
            end
        end
    end
end

local function enableHighlightPlayers(enable)
    highlightEnabled = enable
    if enable then
        updateHighlights()
        playerAddedConn = Players.PlayerAdded:Connect(function() updateHighlights() end)
        playerRemovedConn = Players.PlayerRemoving:Connect(function() updateHighlights() end)
    else
        ClearHighlights()
        if playerAddedConn then playerAddedConn:Disconnect() playerAddedConn = nil end
        if playerRemovedConn then playerRemovedConn:Disconnect() playerRemovedConn = nil end
    end
end

-- Select player UI / Spectate implementation
local selectedPlayer = nil
local spectateEnabled = false
local spectateConn

local function CreateSelectPlayerPanel()
    local panel = Instance.new("Frame")
    panel.Name = "SelectPlayerPanel"
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.Parent = middleTop

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 1, 0)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.BackgroundTransparency = 1
    list.Parent = panel

    local ui = Instance.new("UIListLayout")
    ui.Parent = list
    ui.Padding = UDim.new(0, 6)

    local function refresh()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local y = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            local btn = Instance.new("TextButton")
            btn.Name = "playerBtn_" .. plr.UserId
n            btn.Size = UDim2.new(1, -12, 0, 28)
            btn.Position = UDim2.new(0, 6, 0, y)
            btn.AnchorPoint = Vector2.new(0,0)
            btn.BackgroundTransparency = 0.12
            btn.Text = plr.Name
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.Parent = list
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                -- highlight selection visually
                for _, b in ipairs(list:GetChildren()) do if b:IsA("TextButton") then b.BackgroundTransparency = 0.12 end end
                btn.BackgroundTransparency = 0.02
            end)
            y = y + 36
        end
        list.CanvasSize = UDim2.new(0, 0, 0, y)
    end

    refresh()
    -- refresh when players change
    Players.PlayerAdded:Connect(refresh)
    Players.PlayerRemoving:Connect(function() if selectedPlayer and not Players:FindFirstChild(selectedPlayer.Name) then selectedPlayer = nil end refresh() end)

    return panel
end

-- Spectate follow logic
local function StartSpectate(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    if spectateConn then spectateConn:Disconnect() spectateConn = nil end
    spectateConn = RunService.RenderStepped:Connect(function()
        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = target.Character.HumanoidRootPart
        -- smooth camera lerp
        Camera.CFrame = root.CFrame * CFrame.new(0, 2, 6) -- behind and above
    end)
end

local function StopSpectate()
    if spectateConn then spectateConn:Disconnect() spectateConn = nil end
end

-- Create function cards and bottom buttons depending on icon clicked
local function ShowFunctionsForIcon(iconName)
    ClearMiddle()
    if iconName == "home" then
        -- Add Player Outline card
        local card = CreateFunctionCard("Player Outline", "Coloca contorno branco nos players e nome acima")
        middleTop.UIListLayout = nil
        card.OnToggle = function(on)
            enableHighlightPlayers(on)
        end
        -- Add Spectate card
        local specCard = CreateFunctionCard("Spectate", "Seguir jogador selecionado (ativa/desativa)")
        specCard.OnToggle = function(on)
     
