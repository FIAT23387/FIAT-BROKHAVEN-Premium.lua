--// Fiat Hub Ultra Cinema Final
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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

-- Mid Buttons Frame
local MidButtonFrame = Instance.new("Frame")
MidButtonFrame.Size = UDim2.new(1,-70,1,-70)
MidButtonFrame.Position = UDim2.new(0,60,0,60)
MidButtonFrame.BackgroundTransparency = 1
MidButtonFrame.Parent = MainFrame

local function ClearMidButtons()
    for _,v in pairs(MidButtonFrame:GetChildren()) do
        v:Destroy()
    end
end

-- Função criar botão simples com feedback
local ActiveFunctions = {}
local function CreateButton(name,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,200,0,40)
    btn.Position = UDim2.new(0,10,0,#MidButtonFrame:GetChildren()*50+10)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
    btn.Parent = MidButtonFrame

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
end

-- Botão Parar Tudo
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0,100,0,30)
StopButton.Position = UDim2.new(1,-110,0,350)
StopButton.Text = "Parar Tudo"
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextScaled = true
StopButton.BackgroundColor3 = Color3.fromRGB(255,50,50)
StopButton.Parent = MainFrame
StopButton.MouseButton1Click:Connect(function()
    for name,func in pairs(ActiveFunctions) do
        print("Parando "..name)
    end
    ActiveFunctions = {}
    ClearMidButtons()
end)

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

-- Funções dos ícones
local IconFunctions = {
    ["🏠"] = function()
        ClearMidButtons()
        CreateButton("Selecionar Player",RefreshPlayerList)
        CreateButton("Espiar Player",EspiarPlayer)
    end,
    ["⚙️"] = function()
        ClearMidButtons()
        CreateButton("UI Colorida",function()
            MainFrame.BackgroundColor3 = Color3.fromHSV(tick()%1,1,1)
        end)
    end,
    ["😈"] = function()
        ClearMidButtons()
        CreateButton("Kill Ônibus",function() print("a lógica Kill Ônibus") end)
        CreateButton("Kill Sofa",function() print("a lógica Kill Sofa") end)
    end,
    ["💥"] = function()
        ClearMidButtons()
        CreateButton("Fling Ônibus",function() print("a lógica Fling Ônibus") end)
        CreateButton("Fling Sofa",function() print("a lógica Fling Sofa") end)
    end,
    ["⏱️"] = function()
        ClearMidButtons()
        CreateButton("Almentar Speed",function() Player.Character.Humanoid.WalkSpeed = 130 end)
        CreateButton("Teleport Tool",function() print("a lógica Teleport Tool") end)
    end,
    ["🌟"] = function()
        ClearMidButtons()
        CreateButton("Anti Lag",function() print("a lógica Anti Lag") end)
        CreateButton("Anti Colisão",function() print("a lógica Anti Colisão") end)
        CreateButton("Anti Sit",function() print("a lógica Anti Sit") end)
    end,
    ["🤯"] = function()
        ClearMidButtons()
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
