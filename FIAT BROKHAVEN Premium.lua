--// Fiat Hub Ultra Cinema - Final Atualizado
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Mouse = Players.LocalPlayer:GetMouse()
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mensagens carinhosas
local Messages = {"Tenha um bom dia!","Seja feliz!","Aproveite o momento!","Você é incrível!","Sorria sempre!"}

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

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0,20)
UICornerMain.Parent = MainFrame

-- Abrir UI animada
TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,650,0,400)}):Play()

-- Title rainbow
local Title = Instance.new("TextLabel")
Title.Text = "FIAT HUB"
Title.Size = UDim2.new(1,-60,0,30)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Parent = MainFrame

RunService.RenderStepped:Connect(function()
    Title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
end)

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

-- Frame lateral ícones
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

-- Mid Buttons Frame com Scroll
local MidScroll = Instance.new("ScrollingFrame")
MidScroll.Size = UDim2.new(1,-70,1,-70)
MidScroll.Position = UDim2.new(0,60,0,60)
MidScroll.BackgroundTransparency = 1
MidScroll.CanvasSize = UDim2.new(0,0,0,0)
MidScroll.ScrollBarThickness = 8
MidScroll.Parent = MainFrame

local MidUIList = Instance.new("UIListLayout")
MidUIList.Parent = MidScroll
MidUIList.SortOrder = Enum.SortOrder.LayoutOrder
MidUIList.Padding = UDim.new(0,5)

-- Função criar botão simples com feedback
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
            print(name.." desligado")
        end
    end)
    MidScroll.CanvasSize = UDim2.new(0,0,0,MidUIList.AbsoluteContentSize.Y + 10)
end

-- Aba transparente de players
local SelectedPlayer = nil
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Size = UDim2.new(1,-70,0,120)
PlayerFrame.Position = UDim2.new(0,60,0,280)
PlayerFrame.BackgroundTransparency = 0.7
PlayerFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerFrame.Parent = MainFrame

local function RefreshPlayerList()
    for _,v in pairs(PlayerFrame:GetChildren()) do v:Destroy() end
    local y = 10
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-20,0,30)
            b.Position = UDim2.new(0,10,0,y)
            b.Text = plr.Name
            b.Font = Enum.Font.SourceSans
            b.TextScaled = true
            b.Parent = PlayerFrame
            b.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
                print("Selecionou "..plr.Name)
            end)
            y = y + 35
        end
    end
end
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

-- Espiar Player
local function EspiarPlayer()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
        RunService:BindToRenderStep("EspiarPlayer",301,function()
            Camera.CameraSubject = SelectedPlayer.Character.Humanoid
        end)
    else
        RunService:UnbindFromRenderStep("EspiarPlayer")
        Camera.CameraSubject = Player.Character and Player.Character:FindFirstChild("Humanoid") or nil
    end
end

-- Teleport Tool
local TeleportToolActive = false
local function TeleportTool()
    TeleportToolActive = not TeleportToolActive
    if TeleportToolActive then
        print("Teleport Tool ativado, clique no mapa para teleportar")
        Mouse.Button1Down:Connect(function()
            if TeleportToolActive and Mouse.Hit then
                local pos = Mouse.Hit.Position
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                end
            end
        end)
    else
        print("Teleport Tool desativado")
    end
end

-- Funções dos ícones
local IconFunctions = {
    ["🏠"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Selecionar Player",RefreshPlayerList)
        CreateButton("Espiar Player",EspiarPlayer)
    end,
    ["⚙️"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("UI Colorida",function()
            MainFrame.BackgroundColor3 = Color3.fromHSV(tick()%1,1,1)
        end)
        CreateButton("Parar Tudo",function()
            for name,func in pairs(ActiveFunctions) do
                print("Parando "..name)
            end
            ActiveFunctions = {}
            MidScroll:ClearAllChildren()
        end)
    end,
    ["😈"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Kill Ônibus",function() print("a lógica Kill Ônibus") end)
        CreateButton("Kill Sofa",function() print("a lógica Kill Sofa") end)
    end,
    ["💥"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Fling Ônibus",function() print("a lógica Fling Ônibus") end)
        CreateButton("Fling Sofa",function() print("a lógica Fling Sofa") end)
    end,
    ["⏱️"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Almentar Speed",function() Player.Character.Humanoid.WalkSpeed = 130 end)
        CreateButton("Teleport Tool",TeleportTool)
    end,
    ["🌟"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Anti Lag",function()
            if not RunService:FindFirstChild("AntiLagLoop") then
                local loop = Instance.new("BindableEvent")
                loop.Name = "AntiLagLoop"
                loop.Parent = RunService
                loop.Event:Connect(function()
                    for _,obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                            obj:Destroy()
                        end
                    end
                end)
                RunService:BindToRenderStep("AntiLagStep",300,function() loop:Fire() end)
            end
        end)
        CreateButton("Anti Colisão",function()
            if not RunService:FindFirstChild("AntiCollideLoop") then
                local loop = Instance.new("BindableEvent")
                loop.Name = "AntiCollideLoop"
                loop.Parent = RunService
                loop.Event:Connect(function()
                    for _,obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name~="HumanoidRootPart" and obj.Parent~=Player.Character then
                            obj.CanCollide=false
                        end
                    end
                end)
                RunService:BindToRenderStep("AntiCollideStep",301,function() loop:Fire() end)
            end
        end)
        CreateButton("Anti Sit",function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                    if Player.Character.Humanoid.Sit then
                        Player.Character.Humanoid.Sit=false
                    end
                end)
            end
        end)
    end,
    ["🤯"] = function()
        MidScroll:ClearAllChildren()
        CreateButton("Lag Lanterna",function() print("a lógica Lag Lanterna") end)
    end
}

for i,btn in pairs(IconButtons) do
    btn.MouseButton1Click:Connect(function()
        IconFunctions[btn.Text]()
    end)
end

-- Mensagem carinhosa Fiat Botizin
local RandomMessage = Instance.new("TextLabel")
RandomMessage.Size = UDim2.new(1,-20,0,30)
RandomMessage.Position = UDim2.new(0,10,1,-40)
RandomMessage.BackgroundTransparency = 1
RandomMessage.Font = Enum.Font.SourceSansItalic
RandomMessage.TextScaled = true
RandomMessage.TextColor3 = Color3.fromRGB(0,0,0)
RandomMessage.Text = "Fiat Botizin: "..Messages[math.random(1,#Messages)]
RandomMessage.Parent = MainFrame
