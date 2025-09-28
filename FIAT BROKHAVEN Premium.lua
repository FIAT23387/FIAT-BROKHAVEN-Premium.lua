--// Fiat Hub Ultra Professional

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove UI antiga
if Player:FindFirstChild("PlayerGui"):FindFirstChild("FiatHubUI") then
    Player.PlayerGui.FiatHubUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHubUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Janela principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,500,0,350)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(230,230,230)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,20)
UICorner.Parent = MainFrame

-- Título rainbow
local Title = Instance.new("TextLabel")
Title.Text = "FIAT HUB"
Title.Size = UDim2.new(1,-60,0,30)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "by: fiat gordin"
SubTitle.Size = UDim2.new(0,150,0,20)
SubTitle.Position = UDim2.new(0,10,0,30)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.SourceSans
SubTitle.TextScaled = true
SubTitle.TextColor3 = Color3.fromRGB(100,100,100)
SubTitle.Parent = MainFrame

RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
end)

-- Min/Close buttons
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

UserInputService.InputBegan:Connect(function(input,gpe)
    if not gpe and input.KeyCode==Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Porta deitada animada (ScrollingFrame)
local FunctionFrame = Instance.new("ScrollingFrame")
FunctionFrame.Size = UDim2.new(1,-70,1,-70)
FunctionFrame.Position = UDim2.new(0,60,0,60)
FunctionFrame.BackgroundColor3 = Color3.fromRGB(240,240,240)
FunctionFrame.ScrollBarThickness = 6
FunctionFrame.CanvasSize = UDim2.new(0,0,0,0)
FunctionFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.Parent = FunctionFrame

-- Toggle com bolinha animada
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

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0.3,0,0.8,0)
    Switch.Position = UDim2.new(0.7,0,0.1,0)
    Switch.BackgroundColor3 = Color3.fromRGB(180,180,180)
    Switch.Parent = Toggle
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0,20)
    SwitchCorner.Parent = Switch

    local Ball = Instance.new("Frame")
    Ball.Size = UDim2.new(0.5,0,1,0)
    Ball.Position = UDim2.new(0,0,0,0)
    Ball.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Ball.Parent = Switch
    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = UDim.new(0,20)
    BallCorner.Parent = Ball

    local state = false
    Switch.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            state = not state
            if state then
                Ball:TweenPosition(UDim2.new(0.5,0,0,0),"Out","Quad",0.2,true)
                Switch.BackgroundColor3 = Color3.fromRGB(100,200,100)
            else
                Ball:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.2,true)
                Switch.BackgroundColor3 = Color3.fromRGB(180,180,180)
            end
            callback(state)
        end
    end)
    return Toggle
end

-- Icones laterais
local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0,50,1,-40)
IconFrame.Position = UDim2.new(0,0,0,60)
IconFrame.BackgroundTransparency = 1
IconFrame.Parent = MainFrame

local UIListLayoutIcons = Instance.new("UIListLayout")
UIListLayoutIcons.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutIcons.Padding = UDim.new(0,10)
UIListLayoutIcons.Parent = IconFrame

-- Frame seleção de players
local PlayerSelectionFrame = Instance.new("ScrollingFrame")
PlayerSelectionFrame.Size = UDim2.new(0,200,0,150)
PlayerSelectionFrame.Position = UDim2.new(1,10,0,60)
PlayerSelectionFrame.BackgroundColor3 = Color3.fromRGB(200,200,200)
PlayerSelectionFrame.Visible = false
PlayerSelectionFrame.Parent = MainFrame
PlayerSelectionFrame.ScrollBarThickness = 6

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0,5)
PlayerListLayout.Parent = PlayerSelectionFrame

local SelectedPlayer = nil
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
            end)
        end
    end
end
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

-- Abrir abas com animação
local CurrentTabButtons = {}
local function OpenTab(buttons)
    for _, b in pairs(CurrentTabButtons) do 
        b:TweenSize(UDim2.new(1,-10,0,0),"Out","Quad",0.2,true)
        task.delay(0.2,function() b:Destroy() end)
    end
    CurrentTabButtons = {}
    for i, f in ipairs(buttons) do
        task.delay(i*0.05,function()
            local t = CreateToggle(f.Name,f.Callback)
            t.Size = UDim2.new(1,-10,0,0)
            t:TweenSize(UDim2.new(1,-10,0,40),"Out","Quad",0.2,true)
            table.insert(CurrentTabButtons,t)
        end)
    end
    task.delay(#buttons*0.05+0.2,function()
        FunctionFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
    end)
end

-- Espiar player com câmera suave
local FollowCameraConnection
local function EspiarPlayer(state)
    if state and SelectedPlayer and SelectedPlayer.Character then
        Camera.CameraType = Enum.CameraType.Scriptable
        FollowCameraConnection = RunService.RenderStepped:Connect(function()
            if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = SelectedPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(Camera.CFrame.Position:Lerp(HRP.Position + Vector3.new(0,5,10),0.2),HRP.Position)
            end
        end)
    else
        if FollowCameraConnection then FollowCameraConnection:Disconnect() FollowCameraConnection=nil end
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid")
    end
end

-- Abas e botões
local CasaButtons = {
    {Name="ESP",Callback=function(state) print("ESP "..(state and "ativado" or "desativado")) end},
    {Name="Selecionar Player",Callback=function(state) PlayerSelectionFrame.Visible=state end},
    {Name="Espiar Player",Callback=EspiarPlayer}
}

local EngrenagemButtons = {
    {Name="UI Colorida",Callback=function(state)
        MainFrame.BackgroundColor3 = Color3.fromRGB(200,200,255)
        print("UI colorida permanente ativada")
    end}
}

-- Ícones
local CasaIcon = Instance.new("TextButton")
CasaIcon.Size=UDim2.new(1,0,0,50)
CasaIcon.Text="🏠"
CasaIcon.Font=Enum.Font.SourceSansBold
CasaIcon.TextScaled=true
CasaIcon.Parent=IconFrame

local EngrenagemIcon = Instance.new("TextButton")
EngrenagemIcon.Size=UDim2.new(1,0,0,50)
EngrenagemIcon.Text="⚙️"
EngrenagemIcon.Font=Enum.Font.SourceSansBold
EngrenagemIcon.TextScaled=true
EngrenagemIcon.Parent=IconFrame

CasaIcon.MouseButton1Click:Connect(function()
    OpenTab(CasaButtons)
end)
EngrenagemIcon.MouseButton1Click:Connect(function()
    OpenTab(EngrenagemButtons)
end)
