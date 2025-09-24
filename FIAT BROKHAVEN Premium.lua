
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FIAT_HUB_UI"
screenGui.Parent = CoreGui

-- Função para criar botão
local function createButton(name, parent, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(60,60,60)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Parent = parent
    return button
end

-- Criar UI principal (formato porta deitada)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 200) -- tamanho inicial
mainFrame.Position = UDim2.new(0.3,0,0.3,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tornar UI arrastável
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Botão minimizar (-)
local minimizeButton = createButton("MinimizeButton", mainFrame, "-", UDim2.new(0, 30, 0, 30), UDim2.new(0,5,0,5))

-- Bola com F (para restaurar UI)
local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreButton"
restoreButton.Size = UDim2.new(0, 40, 0, 40)
restoreButton.Position = UDim2.new(0,5,0,5)
restoreButton.Text = "F"
restoreButton.TextColor3 = Color3.fromRGB(255,255,255)
restoreButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
restoreButton.BorderColor3 = Color3.fromRGB(255,255,255)
restoreButton.Visible = false
restoreButton.Parent = screenGui

-- Botão fechar (x)
local closeButton = createButton("CloseButton", mainFrame, "x", UDim2.new(0, 30,0,30), UDim2.new(1,-35,0,5))

-- Função minimizar e restaurar
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

-- Ícone Discord
local discordIcon = createButton("DiscordIcon", mainFrame, "🌟", UDim2.new(0,40,0,40), UDim2.new(0,10,0,50))

-- Função para abrir/fechar funções do meio
local functionsFrame = Instance.new("Frame")
functionsFrame.Name = "FunctionsFrame"
functionsFrame.Size = UDim2.new(0, 300, 0, 120)
functionsFrame.Position = UDim2.new(0.5,-150,0.5,-60)
functionsFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
functionsFrame.Visible = false
functionsFrame.Parent = mainFrame

-- Botão Get Discord Link
local getDiscordButton = createButton("GetDiscordButton", functionsFrame, "Get Discord Link", UDim2.new(0, 200, 0, 40), UDim2.new(0.5,-100,0,40))

getDiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/CP2JYKNk")
end)

discordIcon.MouseButton1Click:Connect(function()
    functionsFrame.Visible = not functionsFrame.Visible
end)

--// Lugar para futuras atualizações
-- Aqui você pode adicionar novos ícones, abas, funções etc.
