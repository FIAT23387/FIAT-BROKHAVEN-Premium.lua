--// FIAT HUB - UI COMPLETA (Todas etapas 1-4)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variáveis globais
local selectedPlayer = nil
local lagEnabled = false
local teleportEnabled = false
local killOnibusEnabled = false
local followConnection = nil
local teleportConnection = nil

-- Criação da ScreenGui
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.ResetOnSpawn = false

-- Janela principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Botão minimizar (-) e fechar (X)
local MinButton = Instance.new("TextButton", MainFrame)
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -70, 0, 10)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 5)

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)

-- Toggle com tecla K para mostrar UI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Fechar e minimizar lógica
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
MinButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FIAT HUB - Premium"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Container para botões
local ButtonFrame = Instance.new("Frame", MainFrame)
ButtonFrame.Size = UDim2.new(1, -20, 1, -60)
ButtonFrame.Position = UDim2.new(0, 10, 0, 50)
ButtonFrame.BackgroundTransparency = 1

-- Layout automático
local UIListLayout = Instance.new("UIListLayout", ButtonFrame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função criar botão simples
local function createButton(text, callback)
    local Button = Instance.new("TextButton", ButtonFrame)
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- 🔹 Botão Discord
createButton("🌟 Get Discord Link", function()
    setclipboard("https://discord.gg/CP2JYKNk")
end)

-- 🔹 Dropdown para selecionar player
local PlayerDropdown = Instance.new("TextButton", ButtonFrame)
PlayerDropdown.Size = UDim2.new(1, 0, 0, 30)
PlayerDropdown.Text = "Selecionar Player"
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.Font = Enum.Font.SourceSansBold
PlayerDropdown.TextSize = 16
Instance.new("UICorner", PlayerDropdown).CornerRadius = UDim.new(0, 8)

local DropdownFrame = Instance.new("Frame", PlayerDropdown)
DropdownFrame.Size = UDim2.new(1, 0, 0, 120)
DropdownFrame.Position = UDim2.new(0, 0, 1, 0)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownFrame.Visible = false
DropdownFrame.ZIndex = 2
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

local dropLayout = Instance.new("UIListLayout", DropdownFrame)
dropLayout.Padding = UDim.new(0, 3)
dropLayout.SortOrder = Enum.SortOrder.LayoutOrder

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
end)

local function updateDropdown()
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local plrBtn = Instance.new("TextButton", DropdownFrame)
            plrBtn.Size = UDim2.new(1, 0, 0, 25)
            plrBtn.Text = plr.Name
            plrBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            plrBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            plrBtn.Font = Enum.Font.SourceSans
            plrBtn.TextSize = 14
            Instance.new("UICorner", plrBtn).CornerRadius = UDim.new(0, 6)
            plrBtn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                PlayerDropdown.Text = "Selecionado: " .. plr.Name
                DropdownFrame.Visible = false
            end)
        end
    end
end
updateDropdown()
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

-- 🔹 Função criar botão ON/OFF
local function createToggle(text, callback)
    local ToggleFrame = Instance.new("Frame", ButtonFrame)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundTransparency = 1

    local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("Frame", ToggleFrame)
    ToggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", ToggleButton)
    Knob.Size = UDim2.new(0.4, 0, 1, 0)
    Knob.Position = UDim2.new(0, 0, 0, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local enabled = false
    local function toggle()
        enabled = not enabled
        if enabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            Knob:TweenPosition(UDim2.new(0.6, 0, 0, 0), "Out", "Quad", 0.2, true)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            Knob:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
        end
        callback(enabled)
    end

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)
    return toggle
end

-- 🔹 Lag Tool Mão
createToggle("Lag Tool Mão", function(state)
    lagEnabled = state
    if lagEnabled then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for i = 1, 200 do
                local clone = tool:Clone()
                clone.Parent = LocalPlayer.Backpack
            end
            for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                if t:IsA("Tool") then
                    t.Parent = LocalPlayer.Character
                end
            end
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 1)
        end
        if selectedPlayer then
            followConnection = RunService.Heartbeat:Connect(function()
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, targetPos.Y - 5, targetPos.Z) * CFrame.Angles(math.rad(180), 0, 0)
                end
            end)
        end
    else
        if followConnection then followConnection:Disconnect() followConnection=nil end
    end
end)

-- 🔹 Teleport Coordenadas
createToggle("Teleport Coordenada", function(state)
    teleportEnabled = state
    if teleportEnabled then
        teleportConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local target = Vector3.new(-84, 20, -131)
                hrp.CFrame = CFrame.new(target)
                -- lógica de subir/descer, sentar, pular, equipar tool
                -- se player selecionado → teleporta perto dele e roda
            end
        end)
    else
        if teleportConnection then teleportConnection:Disconnect() teleportConnection=nil end
    end
end)

-- 🔹 Kill Ônibus
createToggle("Kill Ônibus", function(state)
    killOnibusEnabled = state
    if killOnibusEnabled then
        RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if humanoid.SeatPart == nil then
                    -- Mostrar tela cinza 4s "Sente em um carro"
        
                -- KILL ÔNIBUS COM PLAYER SENTADO
createToggle("Kill Ônibus", function(state)
    killOnibusEnabled = state
    if killOnibusEnabled then
        killConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("Humanoid") then return end
            local humanoid = character.Humanoid
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("Humanoid") then return end
            local targetHumanoid = selectedPlayer.Character.Humanoid
            local targetHRP = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not targetHumanoid.SeatPart then
                local aviso = Instance.new("TextLabel", ScreenGui)
                aviso.Size = UDim2.new(0, 300, 0, 50)
                aviso.Position = UDim2.new(0.5, -150, 0.5, -25)
                aviso.BackgroundColor3 = Color3.fromRGB(80,80,80)
                aviso.BackgroundTransparency = 0.2
                aviso.TextColor3 = Color3.fromRGB(255,255,255)
                aviso.Text = "Sente em um carro"
                aviso.Font = Enum.Font.SourceSansBold
                aviso.TextSize = 18
                aviso.TextScaled = true
                Instance.new("UICorner", aviso).CornerRadius = UDim.new(0,8)
                delay(4, function() aviso:Destroy() end)
                return
            end

            local originalPos = hrp.Position
            hrp.CFrame = targetHRP.CFrame * CFrame.new(0, -5, 0)

            local heartbeatConn
            heartbeatConn = RunService.Heartbeat:Connect(function()
                if targetHumanoid.SeatPart then
                    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, -5, 0) * CFrame.Angles(0, tick()%360, 0)
                else
                    heartbeatConn:Disconnect()
                    hrp.CFrame = CFrame.new(originalPos.X, -500, originalPos.Z)
                    humanoid.Jump = true
                    hrp.CFrame = CFrame.new(originalPos)
                    if killConnection then killConnection:Disconnect() killConnection=nil end
                end
            end)
        end)
    else
        if killConnection then killConnection:Disconnect() killConnection=nil end
    end
end)
                            
