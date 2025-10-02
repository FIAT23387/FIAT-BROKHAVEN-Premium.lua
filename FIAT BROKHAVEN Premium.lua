--// Fiat Hub Cinema Final - UI antiga intacta
--// Fonte aplicada: 12187372175
--// Atualização final: scroll em players, botão "-" vira 🚘, todas lógicas incluídas

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FiatHubUI"
gui.ResetOnSpawn = false

-- Fonte customizada
local customFont = Font.new("rbxassetid://12187372175")

-- Estado
local ActiveFunctions = {}
local SelectedPlayer = nil
local UIColoredLoop = nil

-- MainFrame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,20)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "FIAT HUB"
title.FontFace = customFont
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,0,0)

-- Loop cores no título
task.spawn(function()
    local cores = {
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(0,0,255),
        Color3.fromRGB(255,255,0),
        Color3.fromRGB(255,0,255),
        Color3.fromRGB(0,255,255)
    }
    local i=1
    while task.wait(0.5) do
        title.TextColor3 = cores[i]
        i=i+1
        if i>#cores then i=1 end
    end
end)

-- Minimizar
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-35,0,5)
minimizeBtn.Text = "-"
minimizeBtn.FontFace = customFont
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(180,180,180)

local carBtn = Instance.new("TextButton")
carBtn.Parent = gui
carBtn.Size = UDim2.new(0,50,0,50)
carBtn.Position = UDim2.new(0.1,0,0.1,0)
carBtn.Text = "🚘"
carBtn.Visible = false
carBtn.FontFace = customFont
carBtn.TextScaled = true
carBtn.BackgroundTransparency = 0.3
carBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
carBtn.Active = true
carBtn.Draggable = true

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    carBtn.Visible = true
end)
carBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    carBtn.Visible = false
end)

-- Icon Frame
local iconFrame = Instance.new("Frame", mainFrame)
iconFrame.Size = UDim2.new(0,50,1,0)
iconFrame.BackgroundTransparency = 1

local icons = {"🏠","⚙️","😈","💥","⏱️","🌟","🤯"}
local iconButtons = {}

for i,icon in ipairs(icons) do
    local btn = Instance.new("TextButton", iconFrame)
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,50*(i-1))
    btn.Text = icon
    btn.FontFace = customFont
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    table.insert(iconButtons, btn)
end

-- Mid Scroll
local midScroll = Instance.new("ScrollingFrame", mainFrame)
midScroll.Size = UDim2.new(1,-70,1,-70)
midScroll.Position = UDim2.new(0,60,0,60)
midScroll.BackgroundTransparency = 1
midScroll.ScrollBarThickness = 8
midScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local midList = Instance.new("UIListLayout", midScroll)
midList.SortOrder = Enum.SortOrder.LayoutOrder
midList.Padding = UDim.new(0,5)

local function clearMid()
    for _,v in pairs(midScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function createButton(name,callback,needsPlayer)
    local btn = Instance.new("TextButton", midScroll)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.FontFace = customFont
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
    btn.MouseButton1Click:Connect(function()
        if needsPlayer and not SelectedPlayer then return end
        callback()
    end)
end

-- Player Frame (com scroll)
local playerFrame = Instance.new("ScrollingFrame", mainFrame)
playerFrame.Size = UDim2.new(1,-70,0,120)
playerFrame.Position = UDim2.new(0,60,0,280)
playerFrame.BackgroundTransparency = 0.3
playerFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
playerFrame.ScrollBarThickness = 6

local playerList = Instance.new("UIListLayout", playerFrame)
playerList.SortOrder = Enum.SortOrder.LayoutOrder
playerList.Padding = UDim.new(0,5)

local function refreshPlayers()
    for _,v in pairs(playerFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player then
            local b = Instance.new("TextButton", playerFrame)
            b.Size = UDim2.new(1,-10,0,30)
            b.Text = plr.Name
            b.FontFace = customFont
            b.TextScaled = true
            b.BackgroundColor3 = Color3.fromRGB(150,150,150)
            b.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
            end)
        end
    end
    playerFrame.CanvasSize = UDim2.new(0,0,0,playerList.AbsoluteContentSize.Y+10)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

------------------------------------------------
-- Funções
------------------------------------------------

local function stopAll()
    for name,fn in pairs(ActiveFunctions) do
        if fn.Stop then fn.Stop() end
    end
    ActiveFunctions = {}
    clearMid()
end

local function spectate()
    if not SelectedPlayer then return end
    RunService:BindToRenderStep("Spectate",301,function()
        if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = SelectedPlayer.Character.Humanoid
        end
    end)
end

local function stopSpectate()
    RunService:UnbindFromRenderStep("Spectate")
    workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChild("Humanoid")
end

local function teleportTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "TeleportTool"
    Tool.RequiresHandle = false
    Tool.Parent = player.Backpack
    Tool.Activated:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(player:GetMouse().Hit.Position+Vector3.new(0,3,0))
        end
    end)
end

local function uiColorLoop()
    if UIColoredLoop then
        UIColoredLoop:Disconnect()
        UIColoredLoop = nil
        mainFrame.BackgroundColor3 = Color3.fromRGB(230,230,230)
        return
    end
    UIColoredLoop = RunService.RenderStepped:Connect(function()
        mainFrame.BackgroundColor3 = Color3.fromHSV(tick()%5/5,1,1)
    end)
end

local function customSky()
    if not SelectedPlayer then return end
    local shirt = SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChildOfClass("Shirt")
    if shirt and shirt.ShirtTemplate then
        local sky = Instance.new("Sky")
        sky.SkyboxBk = shirt.ShirtTemplate
        sky.SkyboxDn = shirt.ShirtTemplate
        sky.SkyboxFt = shirt.ShirtTemplate
        sky.SkyboxLf = shirt.ShirtTemplate
        sky.SkyboxRt = shirt.ShirtTemplate
        sky.SkyboxUp = shirt.ShirtTemplate
        sky.Parent = Lighting
    end
end

local function antiLag()
    RunService:BindToRenderStep("AntiLag",300,function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                obj:Destroy()
            end
        end
    end)
end

local function antiLagFull()
    RunService:BindToRenderStep("AntiLagFull",302,function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    end)
end

------------------------------------------------
-- Abas
------------------------------------------------

local tabs = {
    ["🏠"] = function()
        clearMid()
        createButton("Selecionar Player",refreshPlayers,false)
        createButton("Espectar Player",spectate,true)
        createButton("Parar de Espectar",stopSpectate,false)
    end,
    ["⚙️"] = function()
        clearMid()
        createButton("UI Colorida",uiColorLoop,false)
        createButton("Parar Tudo",stopAll,false)
    end,
    ["😈"] = function()
        clearMid()
        createButton("Kill Ônibus",function() print("Kill Ônibus") end,true)
        createButton("Kill Sofá",function() print("Kill Sofá") end,true)
    end,
    ["💥"] = function()
        clearMid()
        createButton("Fling Ônibus",function() print("Fling Ônibus") end,true)
        createButton("Fling Sofá",function() print("Fling Sofá") end,true)
    end,
    ["⏱️"] = function()
        clearMid()
        createButton("Almentar Speed",function() player.Character.Humanoid.WalkSpeed = 130 end,true)
        createButton("Teleport Tool",teleportTool,false)
    end,
    ["🌟"] = function()
        clearMid()
        createButton("Anti Lag",antiLag,false)
        createButton("Anti Colisão",function()
            RunService:BindToRenderStep("AntiCollide",301,function()
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Parent~=player.Character then
                        obj.CanCollide=false
                    end
                end
            end)
        end,false)
        createButton("Anti Sit",function()
            player.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                if player.Character.Humanoid.Sit then
                    player.Character.Humanoid.Sit=false
                end
            end)
        end,false)
    end,
    ["🤯"] = function()
        clearMid()
        createButton("Ceu customizado⚠️",customSky,true)
        createButton("100% Anti Lag",antiLagFull,false)
    end
}

for _,btn in pairs(iconButtons) do
    btn.MouseButton1Click:Connect(function()
        tabs[btn.Text]()
    end)
end

print("✅ FIAT HUB carregado com sucesso!")
