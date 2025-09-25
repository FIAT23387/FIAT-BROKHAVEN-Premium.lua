--// FIAT HUB - UI MULTIFUNÇÃO (Completo Etapas 1,2,3)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variáveis globais
local selectedPlayer = nil
local lagEnabled = false
local followConnection = nil

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

-- Toggle com tecla K
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
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

-- Função atualizar lista de players
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

-- 🔹 Botão Lag Tool Mão (ON/OFF com bolinha deslizando)
local ToggleFrame = Instance.new("Frame", ButtonFrame)
ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
ToggleFrame.BackgroundTransparency = 1

local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Lag Tool Mão"
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

-- Função ativar lag + seguir player
local function toggleLag()
    lagEnabled = not lagEnabled
    if lagEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        Knob:TweenPosition(UDim2.new(0.6, 0, 0, 0), "Out", "Quad", 0.2, true)

        -- Lógica do Lag Tool
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

        -- Seguir player selecionado
        if selectedPlayer then
            followConnection = RunService.Heartbeat:Connect(function()
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, targetPos.Y - 5, targetPos.Z) * CFrame.Angles(math.rad(180), 0, 0)
                end
            end)
        end
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        Knob:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
    end
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleLag()
    end
end)

-- PONHA RESTO AQUI
