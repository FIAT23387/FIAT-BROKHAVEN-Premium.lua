--// FIAT HUB - UI Melhorada v2
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FIAT_HUB_UI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- UI Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300) -- tamanho mais compacto
mainFrame.Position = UDim2.new(0.25,0,0.25,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BackgroundTransparency = 0.15 -- levemente transparente
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- arrastar funciona
mainFrame.Parent = screenGui

-- Arredondar cantos
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = mainFrame

-- TopBar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,30)
topBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
topBar.BackgroundTransparency = 0.1
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0,12)
UICornerTop.Parent = topBar

-- Título
local title = Instance.new("TextLabel")
title.Text = "🚀 FIAT HUB"
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = topBar

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,0)
closeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16
closeButton.Parent = topBar

local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0,8)
cornerClose.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Funções (conteúdo)
local functionsFrame = Instance.new("Frame")
functionsFrame.Size = UDim2.new(1,-20,1,-50)
functionsFrame.Position = UDim2.new(0,10,0,40)
functionsFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
functionsFrame.BackgroundTransparency = 0.15
functionsFrame.BorderSizePixel = 0
functionsFrame.Parent = mainFrame

local funcCorner = Instance.new("UICorner")
funcCorner.CornerRadius = UDim.new(0,10)
funcCorner.Parent = functionsFrame

-- Botão de função exemplo
local getDiscordButton = Instance.new("TextButton")
getDiscordButton.Text = "🌟 Get Discord Link"
getDiscordButton.Size = UDim2.new(0,180,0,30)
getDiscordButton.Position = UDim2.new(0,10,0,10)
getDiscordButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
getDiscordButton.TextColor3 = Color3.fromRGB(255,255,255)
getDiscordButton.Font = Enum.Font.SourceSansBold
getDiscordButton.TextSize = 14
getDiscordButton.Parent = functionsFrame

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0,8)
cornerBtn.Parent = getDiscordButton

getDiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/CP2JYKNk")
end)

-- Sistema tecla K para mostrar/ocultar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

--// Lugar para futuras atualizações
