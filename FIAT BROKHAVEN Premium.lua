--// FIAT HUB - UI Melhorada
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FIAT_HUB_UI"
screenGui.Parent = CoreGui

-- Função para criar botão
local function createButton(name, parent, text, size, position, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color or Color3.fromRGB(50,50,50)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.BorderSizePixel = 0
    button.Parent = parent
    return button
end

-- Criar UI principal (porta deitada maior e estilizada)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 900, 0, 450) -- um pouco maior
mainFrame.Position = UDim2.new(0.05,0,0.05,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- TopBar para arrastar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1,0,0,30)
topBar.Position = UDim2.new(0,0,0,0)
topBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Sistema de arrastar pela TopBar
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Botões minimizar e fechar
local minimizeButton = createButton("MinimizeButton", topBar, "-", UDim2.new(0,20,0,20), UDim2.new(0,5,0,5), Color3.fromRGB(80,80,80))
local closeButton = createButton("CloseButton", topBar, "x", UDim2.new(0,20,0,20), UDim2.new(1,-25,0,5), Color3.fromRGB(180,50,50))

-- Bola com F para restaurar UI
local restoreButton = createButton("RestoreButton", screenGui, "F", UDim2.new(0, 30, 0, 30), UDim2.new(0,5,0,5), Color3.fromRGB(50,50,50))
restoreButton.Visible = false

-- Funções de minimizar, restaurar e fechar
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    restoreButton.Visible = true
end)
restoreButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    restoreButton.Visible = false
end)
closeButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
    restoreButton:Destroy()
end)

-- Ícones laterais
local discordIcon = createButton("DiscordIcon", mainFrame, "🌟", UDim2.new(0,25,0,25), UDim2.new(0,10,0,50), Color3.fromRGB(70,70,70))
-- você pode adicionar mais ícones facilmente

-- Funções (parte inferior da UI)
local functionsFrame = Instance.new("Frame")
functionsFrame.Name = "FunctionsFrame"
functionsFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset - 20, 0, 180)
functionsFrame.Position = UDim2.new(0,10,1,-190)
functionsFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
functionsFrame.BorderSizePixel = 0
functionsFrame.Visible = false
functionsFrame.Parent = mainFrame

-- Botões de funções menores
local getDiscordButton = createButton("GetDiscordButton", functionsFrame, "Get Discord Link", UDim2.new(0, 150, 0, 25), UDim2.new(0.5,-75,0,60), Color3.fromRGB(90,90,90))

-- Função de copiar link para área de transferência
getDiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/CP2JYKNk")
end)

-- Abrir/fechar funções ao clicar no ícone
discordIcon.MouseButton1Click:Connect(function()
    functionsFrame.Visible = not functionsFrame.Visible
end)

--// Lugar para futuras atualizações
-- Aqui você pode adicionar novos ícones, abas, funções etc.
