-- Fiat Hub UI - Single-file Lua script
-- Coloque este código em um script LocalScript executado no ambiente do cliente (CoreGui/PlayerGui).
-- Suporta exploits que permitem manipular CoreGui (ex: Synapse, etc.).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

-- Root ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHub_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main window (porta deitada)
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 520, 0, 160)
Window.Position = UDim2.new(0.3, 0, 0.3, 0)
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundTransparency = 0.15
Window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Window.Active = true
Window.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 18)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.6
WindowStroke.Parent = Window

-- Top bar (title + controls)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
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
Subtitle.TextSize = 12
Subtitle.TextTransparency = 0.15
Subtitle.Font = Enum.Font.SourceSans
Subtitle.TextXAlignment = Enum.TextXAlignment.Right
Subtitle.Parent = TopBar

-- Control buttons on right (icons only)
local Controls = Instance.new("Frame")
Controls.Name = "Controls"
Controls.Size = UDim2.new(0, 96, 1, 0)
Controls.Position = UDim2.new(1, -96, 0, 0)
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
    btn.Size = UDim2.new(0, 28, 0, 28)
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

-- Content area (icones + function panel)
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -12, 1, -46)
Content.Position = UDim2.new(0, 6, 0, 36)
Content.BackgroundTransparency = 1
Content.Parent = Window

local LeftIcons = Instance.new("Frame")
LeftIcons.Name = "LeftIcons"
LeftIcons.Size = UDim2.new(0, 48, 1, 0)
LeftIcons.Position = UDim2.new(0, 6, 0, 0)
LeftIcons.BackgroundTransparency = 1
LeftIcons.Parent = Content

local leftLayout = Instance.new("UIListLayout")
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = LeftIcons

-- Middle area for function cards
local Middle = Instance.new("Frame")
Middle.Name = "Middle"
Middle.Size = UDim2.new(1, -120, 1, 0)
Middle.Position = UDim2.new(0, 60, 0, 0)
Middle.BackgroundTransparency = 1
Middle.Parent = Content

local middleLayout = Instance.new("UIListLayout")
middleLayout.FillDirection = Enum.FillDirection.Vertical
middleLayout.SortOrder = Enum.SortOrder.LayoutOrder
middleLayout.VerticalAlignment = Enum.VerticalAlignment.Top
middleLayout.Padding = UDim.new(0, 8)
middleLayout.Parent = Middle

-- Right small icon bar (just icons, no labels)
local RightIcons = Instance.new("Frame")
RightIcons.Name = "RightIcons"
RightIcons.Size = UDim2.new(0, 48, 1, 0)
RightIcons.Position = UDim2.new(1, -54, 0, 0)
RightIcons.AnchorPoint = Vector2.new(1, 0)
RightIcons.BackgroundTransparency = 1
RightIcons.Parent = Content

local rightLayout = Instance.new("UIListLayout")
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.VerticalAlignment = Enum.VerticalAlignment.Top
rightLayout.Padding = UDim.new(0, 8)
rightLayout.Parent = RightIcons

-- Home and Gear icons on left-top of middle area
local TopLeftIcons = Instance.new("Frame")
TopLeftIcons.Name = "TopLeftIcons"
TopLeftIcons.Size = UDim2.new(0, 60, 0, 28)
TopLeftIcons.Position = UDim2.new(0, 6, 0, 0)
TopLeftIcons.BackgroundTransparency = 1
TopLeftIcons.Parent = Middle

local homeBtn = Instance.new("TextButton")
homeBtn.Size = UDim2.new(0, 28, 0, 28)
homeBtn.Text = "🏠"
homeBtn.BackgroundTransparency = 0.25
homeBtn.Font = Enum.Font.SourceSansBold
homeBtn.Parent = TopLeftIcons
local hcorner = Instance.new("UICorner")
hcorner.CornerRadius = UDim.new(0, 8)
hcorner.Parent = homeBtn

local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.new(0, 28, 0, 28)
gearBtn.Position = UDim2.new(0, 34, 0, 0)
gearBtn.Text = "⚙"
gearBtn.BackgroundTransparency = 0.25
gearBtn.Font = Enum.Font.SourceSansBold
gearBtn.Parent = TopLeftIcons
local gcorner = Instance.new("UICorner")
gcorner.CornerRadius = UDim.new(0, 8)
gcorner.Parent = gearBtn

-- Sidebar of function icons (appears when Home pressed)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.Position = UDim2.new(-1, 0, 0, 0)
Sidebar.BackgroundTransparency = 0.08
Sidebar.BackgroundColor3 = Color3.fromRGB(28,28,28)
Sidebar.Parent = Window
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 12)
sbCorner.Parent = Sidebar

local sbLayout = Instance.new("UIListLayout")
sbLayout.FillDirection = Enum.FillDirection.Vertical
sbLayout.Padding = UDim.new(0, 10)
sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sbLayout.Parent = Sidebar

-- State variables
local closedPermanently = false
local minimized = false
local sidebarOpen = false
local compactMode = false

-- Rainbow title effect
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
    if not compactMode then
        Title.TextColor3 = HSLToRGB(hue, 0.7, 0.52)
    else
        Title.TextColor3 = Color3.fromRGB(200,200,200)
    end
end)

-- Draggable window implementation
local dragging = false
local dragInput, dragStart, startPos

Window.InputBegan:Connect(function(input)
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

Window.InputChanged:Connect(function(input)
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

-- Minimize behavior (reduce size and hide content)
MinimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        -- restore
        Window:TweenSize(UDim2.new(0, 520, 0, 160), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        Content.Visible = true
        minimized = false
    else
        Window:TweenSize(UDim2.new(0, 220, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        Content.Visible = false
        minimized = true
    end
end)

-- Close permanently
CloseBtn.MouseButton1Click:Connect(function()
    closedPermanently = true
    ScreenGui:Destroy()
end)

-- Toggle with key K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        if closedPermanently then return end
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Sidebar open/close
homeBtn.MouseButton1Click:Connect(function()
    sidebarOpen = not sidebarOpen
    if sidebarOpen then
        Sidebar:TweenPosition(UDim2.new(0, 12, 0.3, -40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    else
        Sidebar:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    end
end)

-- Gear toggle compact mode
gearBtn.MouseButton1Click:Connect(function()
    compactMode = not compactMode
    if compactMode then
        -- shrink function icons
        for _, v in ipairs(RightIcons:GetChildren()) do
            if v:IsA("TextButton") then
                v:TweenSize(UDim2.new(0, 18, 0, 18), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                v.TextSize = 14
            end
        end
        Window.BackgroundTransparency = 0.3
    else
        for _, v in ipairs(RightIcons:GetChildren()) do
            if v:IsA("TextButton") then
                v:TweenSize(UDim2.new(0, 28, 0, 28), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                v.TextSize = 18
            end
        end
        Window.BackgroundTransparency = 0.15
    end
end)

-- Function helper: create a function card in middle
local function CreateFunctionCard(name, desc)
    local card = Instance.new("Frame")
    card.Name = name .. "_card"
    card.Size = UDim2.new(1, -12, 0, 44)
    card.BackgroundTransparency = 0.1
    card.BackgroundColor3 = Color3.fromRGB(22,22,22)
    card.Parent = Middle
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
    label.Position = UDim2.new(0, 10, 0, 0)

    -- Toggle switch
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 60, 0, 28)
    toggle.Position = UDim2.new(1, -70, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
    toggle.Parent = card
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 14)
    tc.Parent = toggle

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 24, 0, 24)
    dot.Position = UDim2.new(0, 2, 0.5, -12)
    dot.BackgroundColor3 = Color3.fromRGB(200,200,200)
    dot.Parent = toggle
    local dcorner = Instance.new("UICorner")
    dcorner.CornerRadius = UDim.new(1, 0)
    dcorner.Parent = dot

    local active = false
    local function SetState(state)
        active = state
        if active then
            dot:TweenPosition(UDim2.new(1, -26, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.15, true)
            toggle.BackgroundColor3 = Color3.fromRGB(60,130,240)
        else
            dot:TweenPosition(UDim2.new(0, 2, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.15, true)
            toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
        end
    end

    toggle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SetState(not active)
            -- fire a bindable or callback
            if card.OnToggle then
                pcall(card.OnToggle, active)
            end
        end
    end)

    return card
end

-- Example function: highlight players with white outline + name above
local highlightEnabled = false
local playerHighlights = {}

local function enableHighlightPlayers(enable)
    highlightEnabled = enable
    if enable then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Highlight instance
                    local h = Instance.new("Highlight")
                    h.Name = "FiatHighlight"
                    h.Adornee = char
                    h.FillTransparency = 1
                    h.OutlineTransparency = 0
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                    h.Parent = char
                    -- Billboard name
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "FiatName"
                    bg.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
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
        -- connect player added
        playerAddedConn = Players.PlayerAdded:Connect(function(plr)
            if highlightEnabled and plr ~= Players.LocalPlayer then
                delay(0.35, function()
                    if plr.Character then
                        enableHighlightPlayers(true)
                    end
                end)
            end
        end)
    else
        -- remove all
        for plr, objs in pairs(playerHighlights) do
            if objs.Highlight and objs.Highlight.Parent then
                objs.Highlight:Destroy()
            end
            if objs.Billboard and objs.Billboard.Parent then
                objs.Billboard:Destroy()
            end
            playerHighlights[plr] = nil
        end
        if playerAddedConn then
            playerAddedConn:Disconnect()
            playerAddedConn = nil
        end
    end
end

-- Create a function card for this highlight feature
local highlightCard = CreateFunctionCard("Player Outline", "Coloca contorno branco nos players e nome acima")
highlightCard.Parent = Middle
highlightCard.OnToggle = enableHighlightPlayers

-- Create some example icons on the right
local function AddRightIcon(symbol, name, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 28)
    b.BackgroundTransparency = 0.25
    b.Text = symbol
    b.Font = Enum.Font.SourceSansBold
    b.TextScaled = true
    b.Parent = RightIcons
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = b
    b.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
    return b
end

AddRightIcon("★", "Star", function()
    -- example: open/close sidebar
    homeBtn:Activate()
end)

AddRightIcon("⚡", "Zap", function()
    -- toggle highlight for convenience
    enableHighlightPlayers(not highlightEnabled)
    -- update card visual state
    -- simulate click on toggle
    local tog = highlightCard:FindFirstChild("Toggle")
    if tog then
        tog:FindFirstChild("Dot").Position = highlightEnabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
        tog.BackgroundColor3 = highlightEnabled and Color3.fromRGB(60,130,240) or Color3.fromRGB(45,45,45)
    end
end)

-- Populate Sidebar with some quick icons (smaller)
local function AddSidebarBtn(symbol, tname, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 120, 0, 36)
    b.Text = symbol .. "  " .. tname
    b.TextSize = 14
    b.BackgroundTransparency = 0.15
    b.Parent = Sidebar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = b
    b.MouseButton1Click:Connect(function()
        if func then pcall(func)
        end
    end)
    return b
end

AddSidebarBtn("👁", "Outline", function()
    enableHighlightPlayers(not highlightEnabled)
end)

AddSidebarBtn("🔒", "Empty", function()
    -- placeholder
end)

-- Final tweaks: ensure some layout
for i = 1, 4 do
    local filler = Instance.new("Frame")
    filler.Size = UDim2.new(1, 0, 0, 6)
    filler.BackgroundTransparency = 1
    filler.Parent = Middle
end

-- End of script
print("Fiat Hub UI loaded")
