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

-- UI Player Selector (Etapa 1)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- cria ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FIAT_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- cria main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "FIAT HUB - Selecionar Player"
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Parent = mainFrame

-- botão Selecionar Player
local selectButton = Instance.new("TextButton")
selectButton.Size = UDim2.new(0, 150, 0, 30)
selectButton.Position = UDim2.new(0, 10, 0, 40)
selectButton.Text = "Selecionar Player"
selectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
selectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
selectButton.Font = Enum.Font.SourceSans
selectButton.TextSize = 16
selectButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner", selectButton)
btnCorner.CornerRadius = UDim.new(0, 6)

-- frame da lista de players
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0, 200, 0, 150)
playerListFrame.Position = UDim2.new(0, 10, 0, 80)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerListFrame.Visible = false
playerListFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner", playerListFrame)
listCorner.CornerRadius = UDim.new(0, 6)

-- scrolling para lista
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, 0, 1, 0)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 6
scrolling.Parent = playerListFrame

-- variável para armazenar player selecionado
local selectedPlayer = nil

-- função para atualizar lista de players
local function updatePlayerList()
    scrolling:ClearAllChildren()
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 25)
            btn.Position = UDim2.new(0, 3, 0, y)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 16
            btn.Parent = scrolling

            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 5)

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                print("Selecionado: " .. plr.Name)
                playerListFrame.Visible = false
            end)

            y = y + 30
        end
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- toggle da lista
selectButton.MouseButton1Click:Connect(function()
    playerListFrame.Visible = not playerListFrame.Visible
    if playerListFrame.Visible then
        updatePlayerList()
    end
end)

-- atualizar quando players entram/saem
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- coloque o resto do código aqui

