--// Fiat Hub UI Completo Real com Rainbow e Espiar Player

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Remove UI antiga
if Player:FindFirstChild("PlayerGui"):FindFirstChild("FiatHubUI") then
    Player.PlayerGui.FiatHubUI:Destroy()
end

--// Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHubUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

--// Janela principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,20)
UICorner.Parent = MainFrame

--// Título rainbow
local Title = Instance.new("TextLabel")
Title.Text = "FIAT HUB"
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Parent = MainFrame

-- Texto secundário
local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "by: fiat gordin"
SubTitle.Size = UDim2.new(0, 150, 0, 20)
SubTitle.Position = UDim2.new(0,10,0,30)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.SourceSans
SubTitle.TextScaled = true
SubTitle.TextColor3 = Color3.fromRGB(100,100,100)
SubTitle.Parent = MainFrame

-- Rainbow real
RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
end)

--// Botões minimizar/fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-35,0,0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseButton.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0,30,0,30)
MinimizeButton.Position = UDim2.new(1,-70,0,0)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextScaled = true
MinimizeButton.BackgroundColor3 = Color3.fromRGB(180,180,180)
MinimizeButton.Parent = MainFrame

local Minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    for _, obj in pairs(MainFrame:GetChildren()) do
        if obj ~= Title and obj ~= SubTitle and obj ~= CloseButton and obj ~= MinimizeButton and not obj:IsA("UICorner") then
            obj.Visible = not Minimized
        end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

--// Funções frame
local FunctionFrame = Instance.new("Frame")
FunctionFrame.Size = UDim2.new(1,-70,1,-70)
FunctionFrame.Position = UDim2.new(0,60,0,60)
FunctionFrame.BackgroundColor3 = Color3.fromRGB(240,240,240)
FunctionFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = FunctionFrame

--// Função toggle
local function CreateToggle(name,callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1,-10,0,40)
    Toggle.BackgroundColor3 = Color3.fromRGB(220,220,220)
    Toggle.Parent = FunctionFrame

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Size = UDim2.new(0.7,0,1,0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.TextScaled = true
    Label.TextColor3 = Color3.fromRGB(0,0,0)
    Label.Parent = Toggle

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0.3,-10,0.8,0)
    Switch.Position = UDim2.new(0.7,5,0.1,0)
    Switch.BackgroundColor3 = Color3.fromRGB(180,180,180)
    Switch.Text = "OFF"
    Switch.Font = Enum.Font.SourceSansBold
    Switch.TextScaled = true
    Switch.Parent = Toggle

    local state = false
    Switch.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Switch.Text = "ON"
            Switch.BackgroundColor3 = Color3.fromRGB(100,200,100)
        else
            Switch.Text = "OFF"
            Switch.BackgroundColor3 = Color3.fromRGB(180,180,180)
        end
        callback(state)
    end)
end

--// Selecionar Player Frame
local PlayerSelectionFrame = Instance.new("Frame")
PlayerSelectionFrame.Size = UDim2.new(0,200,0,150)
PlayerSelectionFrame.Position = UDim2.new(1,10,0,60)
PlayerSelectionFrame.BackgroundColor3 = Color3.fromRGB(200,200,200)
PlayerSelectionFrame.Visible = false
PlayerSelectionFrame.Parent = MainFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0,5)
PlayerListLayout.Parent = PlayerSelectionFrame

local SelectedPlayer = nil

-- Atualizar lista de players
local function RefreshPlayerList()
    PlayerSelectionFrame:ClearAllChildren()
    PlayerListLayout.Parent = PlayerSelectionFrame
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,25)
            btn.BackgroundColor3 = Color3.fromRGB(150,150,150)
            btn.TextColor3 = Color3.fromRGB(0,0,0)
            btn.Font = Enum.Font.SourceSans
            btn.TextScaled = true
            btn.Text = p.Name
            btn.Parent = PlayerSelectionFrame

            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = p
                print("Player selecionado: "..p.Name)
            end)
        end
    end
end

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

--// Espiar Player
local FollowCameraConnection
CreateToggle("Espiar Player", function(state)
    if state and SelectedPlayer and SelectedPlayer.Character then
        local HumanoidRootPart = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then return end
        Camera.CameraType = Enum.CameraType.Scriptable
        FollowCameraConnection = RunService.RenderStepped:Connect(function()
            if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position:Lerp(SelectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,5,10),0.2), SelectedPlayer.Character.HumanoidRootPart.Position)
            end
        end)
    else
        if FollowCameraConnection then
            FollowCameraConnection:Disconnect()
            FollowCameraConnection = nil
        end
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid")
    end
end)

--// Outros toggles de exemplo
CreateToggle("ESP", function(state)
    print("ESP "..(state and "ativado" or "desativado"))
end)
CreateToggle("Colorir UI", function(state)
    MainFrame.BackgroundColor3 = state and Color3.fromRGB(200,200,255) or Color3.fromRGB(230,230,230)
end)
CreateToggle("Selecionar Player", function(state)
    PlayerSelectionFrame.Visible = state
end)
