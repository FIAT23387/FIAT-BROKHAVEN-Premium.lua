--// Fiat Hub Cinema Totalmente Funcional ON/OFF

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mensagens carinhosas
local Messages = {
    "Tenha um bom dia!",
    "Seja feliz!",
    "Aproveite o momento!",
    "Você é incrível!",
    "Sorria sempre!"
}

-- Remove UI antiga
if Player:FindFirstChild("PlayerGui"):FindFirstChild("FiatHubUI") then
    Player.PlayerGui.FiatHubUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHubUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Janela principal da UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,0,0,350)
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
TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,500,0,350)}):Play()

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

-- Frame lateral dos ícones
local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0,50,1,0)
IconFrame.Position = UDim2.new(0,0,0,0)
IconFrame.BackgroundTransparency = 1
IconFrame.Parent = MainFrame

-- Ícones Casa e Engrenagem
local CasaIcon = Instance.new("TextButton")
CasaIcon.Size = UDim2.new(1,0,0,50)
CasaIcon.Position = UDim2.new(0,0,0,50)
CasaIcon.Text = "🏠"
CasaIcon.Font = Enum.Font.SourceSans
CasaIcon.TextScaled = true
CasaIcon.BackgroundTransparency = 1
CasaIcon.Parent = IconFrame

local GearIcon = Instance.new("TextButton")
GearIcon.Size = UDim2.new(1,0,0,50)
GearIcon.Position = UDim2.new(0,0,0,120)
GearIcon.Text = "⚙️"
GearIcon.Font = Enum.Font.SourceSans
GearIcon.TextScaled = true
GearIcon.BackgroundTransparency = 1
GearIcon.Parent = IconFrame

-- Frame de botões do meio
local MidButtonFrame = Instance.new("Frame")
MidButtonFrame.Size = UDim2.new(1,-70,1,-70)
MidButtonFrame.Position = UDim2.new(0,60,0,60)
MidButtonFrame.BackgroundTransparency = 1
MidButtonFrame.Parent = MainFrame

-- Função para limpar botões do meio
local function ClearMidButtons()
    for _,v in pairs(MidButtonFrame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end
    end
end

-- Função toggle ON/OFF
local function CreateToggle(name,callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1,-10,0,40)
    Toggle.BackgroundColor3 = Color3.fromRGB(220,220,220)
    Toggle.Parent = MidButtonFrame

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

-- Seleção de player
local SelectedPlayer = nil
local function RefreshPlayerButtons()
    ClearMidButtons()
    local y = 10
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = CreateToggle(plr.Name,function(state)
                if state then
                    SelectedPlayer = plr
                    print("Selecionou: "..plr.Name)
                else
                    SelectedPlayer = nil
                    print("Deselecionou player")
                end
            end)
            btn.Position = UDim2.new(0,10,0,y)
            btn.Parent = MidButtonFrame
            y = y + 50
        end
    end
end

-- Espiar Player só funciona após selecionar
local function EspiarPlayer(state)
    if state and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
        RunService:BindToRenderStep("EspiarPlayer",301,function()
            Camera.CameraSubject = SelectedPlayer.Character.Humanoid
        end)
    else
        RunService:UnbindFromRenderStep("EspiarPlayer")
        Camera.CameraSubject = Player.Character and Player.Character:FindFirstChild("Humanoid") or nil
    end
end

-- Botões Casa
local CasaButtons = {
    {Name="Selecionar Player",Func=function(state)
        if state then
            RefreshPlayerButtons()
        else
            ClearMidButtons()
        end
    end},
    {Name="Espiar Player",Func=EspiarPlayer}
}

-- Botão Engrenagem
local GearButtons = {
    {Name="UI Colorida",Func=function(state)
        if state then
            MainFrame.BackgroundColor3 = Color3.fromHSV(tick()%1,1,1)
        else
            MainFrame.BackgroundColor3 = Color3.fromRGB(230,230,230)
        end
    end}
}

local function CreateMidButtons(buttons)
    ClearMidButtons()
    local y = 10
    for _,b in pairs(buttons) do
        local btn = CreateToggle(b.Name,b.Func)
        btn.Position = UDim2.new(0,10,0,y)
        btn.Parent = MidButtonFrame
        y = y + 50
    end
end

CasaIcon.MouseButton1Click:Connect(function()
    CreateMidButtons(CasaButtons)
end)

GearIcon.MouseButton1Click:Connect(function()
    CreateMidButtons(GearButtons)
end)

-- Mensagem aleatória Fiat Botizin
local RandomMessage = Instance.new("TextLabel")
RandomMessage.Size = UDim2.new(1,-20,0,30)
RandomMessage.Position = UDim2.new(0,10,1,-40)
RandomMessage.BackgroundTransparency = 1
RandomMessage.Font = Enum.Font.SourceSansItalic
RandomMessage.TextScaled = true
RandomMessage.TextColor3 = Color3.fromRGB(0,0,0)
RandomMessage.Text = "Fiat Botizin: "..Messages[math.random(1,#Messages)]
RandomMessage.Parent = MainFrame
