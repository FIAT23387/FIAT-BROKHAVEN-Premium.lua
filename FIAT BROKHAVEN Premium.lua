-- Fiat Hub Cinema Final - Corrigido para exibir todos os botões

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,0,0,0)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(230,230,230)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,20)

-- Abrir UI animada
TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,650,0,400)}):Play()

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "FIAT HUB"
Title.Size = UDim2.new(1,-60,0,30)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Parent = MainFrame

-- Min/Close
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

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
UserInputService.InputBegan:Connect(function(input,gpe)
    if not gpe and input.KeyCode==Enum.KeyCode.K then
        MainFrame.Visible = true
    end
end)

-- Icon Frame
local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0,50,1,0)
IconFrame.Position = UDim2.new(0,0,0,0)
IconFrame.BackgroundTransparency = 1
IconFrame.Parent = MainFrame

local Icons = {"🏠","⚙️","😈","💥","⏱️","🌟","🤯"}
local IconButtons = {}

for i,icon in pairs(Icons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,50*i)
    btn.Text = icon
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    btn.Parent = IconFrame
    table.insert(IconButtons,btn)
end

-- Mid Scroll
local MidScroll = Instance.new("ScrollingFrame")
MidScroll.Size = UDim2.new(1,-70,1,-70)
MidScroll.Position = UDim2.new(0,60,0,60)
MidScroll.BackgroundTransparency = 1
MidScroll.ScrollBarThickness = 8
MidScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MidScroll.Parent = MainFrame

local MidUIList = Instance.new("UIListLayout")
MidUIList.Parent = MidScroll
MidUIList.SortOrder = Enum.SortOrder.LayoutOrder
MidUIList.Padding = UDim.new(0,5)

-- Funções toggle
local ActiveFunctions = {}
local function CreateButton(name,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
    btn.Parent = MidScroll

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(100,200,100)
            ActiveFunctions[name] = callback
            callback()
        else
            btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
            ActiveFunctions[name] = nil
        end
        -- Corrige CanvasSize para exibir botões
        MidScroll.CanvasSize = UDim2.new(0,0,0,MidUIList.AbsoluteContentSize.Y + 10)
    end)

    -- Corrige CanvasSize ao criar botão
    MidScroll.CanvasSize = UDim2.new(0,0,0,MidUIList.AbsoluteContentSize.Y + 10)
end

local function LimparMidScroll()
    for _,v in pairs(MidScroll:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    MidScroll.CanvasSize = UDim2.new(0,0,0,MidUIList.AbsoluteContentSize.Y + 10)
end

-- Aba de players
local SelectedPlayer = nil
local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Size = UDim2.new(1,-70,0,120)
PlayerFrame.Position = UDim2.new(0,60,0,280)
PlayerFrame.BackgroundTransparency = 0.7
PlayerFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerFrame.CanvasSize = UDim2.new(0,0,0,0)
PlayerFrame.ScrollBarThickness = 6
PlayerFrame.Parent = MainFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerFrame
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0,5)

local function RefreshPlayerList()
    for _,v in pairs(PlayerFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-10,0,30)
            b.Text = plr.Name
            b.Font = Enum.Font.SourceSans
            b.TextScaled = true
            b.BackgroundColor3 = Color3.fromRGB(150,150,150)
            b.Parent = PlayerFrame
            b.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
            end)
        end
    end
    PlayerFrame.CanvasSize = UDim2.new(0,0,0,PlayerListLayout.AbsoluteContentSize.Y + 10)
end
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

-- Espiar Player
local function EspiarPlayer()
    RunService:UnbindFromRenderStep("EspiarPlayer")
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
        RunService:BindToRenderStep("EspiarPlayer",301,function()
            Camera.CameraSubject = SelectedPlayer.Character.Humanoid
        end)
    end
end

-- Teleport Tool
local function CreateTeleportTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "TeleportTool"
    Tool.RequiresHandle = false
    Tool.Parent = Player.Backpack

    Tool.Activated:Connect(function()
        if Mouse.Hit and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
        end
    end)
end

-- Limpar todas funções
local function PararTudo()
    ActiveFunctions = {}
    LimparMidScroll()
end

-- Funções dos ícones
local IconFunctions = {
    ["🏠"] = function()
        LimparMidScroll()
        CreateButton("Selecionar Player",RefreshPlayerList)
        CreateButton("Espiar Player",EspiarPlayer)
    end,
    ["⚙️"] = function()
        LimparMidScroll()
        CreateButton("UI Colorida",function()
            MainFrame.BackgroundColor3 = Color3.fromHSV(tick()%1,1,1)
        end)
        CreateButton("Parar Tudo",PararTudo)
    end,
    ["😈"] = function()
        LimparMidScroll()
        CreateButton("Kill Ônibus",function() print("Kill Ônibus") end)
        CreateButton("Kill Sofa",function() print("Kill Sofa") end)
    end,
    ["💥"] = function()
        LimparMidScroll()
        CreateButton("Fling Ônibus",function() print("Fling Ônibus") end)
        CreateButton("Fling Sofa",function() print("Fling Sofa") end)
    end,
    ["⏱️"] = function()
        LimparMidScroll()
        CreateButton("Almentar Speed",function() Player.Character.Humanoid.WalkSpeed = 130 end)
        CreateButton("Teleport Tool",CreateTeleportTool)
    end,
    ["🌟"] = function()
        LimparMidScroll()
        CreateButton("Anti Lag",function()
            RunService:BindToRenderStep("AntiLag",300,function()
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                        obj:Destroy()
                    end
                end
            end)
        end)
        CreateButton("Anti Colisão",function()
            RunService:BindToRenderStep("AntiCollide",301,function()
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name~="HumanoidRootPart" and obj.Parent~=Player.Character then
                        obj.CanCollide=false
                    end
                end
            end)
        end)
        CreateButton("Anti Sit",function()
            Player.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                if Player.Character.Humanoid.Sit then
                    Player.Character.Humanoid.Sit=false
                end
            end)
        end)
    end,
    ["🤯"] = function()
        LimparMidScroll()
        CreateButton("Lag Lanterna",function() print("Lag Lanterna") end)
    end
}

for i,btn in pairs(IconButtons) do
    btn.MouseButton1Click:Connect(function()
        IconFunctions[btn.Text]()
    end)
end

print("✅ FIAT HUB carregado com UI antiga intacta, todos os botões aparecerão corretamente!")
