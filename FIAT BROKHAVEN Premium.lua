-- Fiat Hub (Fluent-based) - by_fiat
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Janela Principal (Dark)
local Window = Fluent:CreateWindow({
    Title = "Fiat Hub",
    SubTitle = "by_fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(580,460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = nil
})
Window.Parent = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    if Window.MainContainer then
        Window.MainContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Window.MainContainer.BackgroundTransparency = 0.2
    end
end)

-- Abas
local Tabs = {
    Main = Window:AddTab({Title="Main", Icon=""}),
    Settings = Window:AddTab({Title="Settings", Icon="settings"})
}

local SelectedPlayer = nil
local PlayerDropdown = nil
local ToggleTable = {}
local SpectateConnection = nil
local Spectating = false
local LastCameraState = {CameraType=nil, CameraSubject=nil, CameraCFrame=nil}

local function notify(title,content,duration)
    Fluent:Notify({Title=title or "Fiat Hub", Content=content or "", Duration=duration or 4})
end

-- Dropdown players
local function buildPlayerValueList()
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then table.insert(list,p.Name) end
    end
    return list
end
local function setSelectedPlayerByName(name)
    if not name or name=="" then SelectedPlayer=nil; notify("Player","Nenhum player selecionado",3); return end
    local p = Players:FindFirstChild(name)
    if p then SelectedPlayer=p; notify("Player","Selecionado: "..p.Name,3)
    else SelectedPlayer=nil; notify("Player","Player não encontrado: "..tostring(name),3) end
end

PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown",{Title="Select Player", Values=buildPlayerValueList(), Multi=false, Default=1})
local initialValues = buildPlayerValueList()
if #initialValues>0 then PlayerDropdown:SetValue(initialValues[1]); setSelectedPlayerByName(initialValues[1]) end
PlayerDropdown:OnChanged(setSelectedPlayerByName)

Players.PlayerAdded:Connect(function(plr) PlayerDropdown:SetValues(buildPlayerValueList()) end)
Players.PlayerRemoving:Connect(function(plr)
    PlayerDropdown:SetValues(buildPlayerValueList())
    if SelectedPlayer and SelectedPlayer.Name==plr.Name then SelectedPlayer=nil; notify("Player","Player saiu: "..plr.Name,3) end
end)

local function requireSelected(toggleObj)
    if not SelectedPlayer then
        notify("Erro","Você precisa selecionar um player primeiro.",3)
        if toggleObj and toggleObj.SetValue then pcall(function() toggleObj:SetValue(false) end) end
        return false
    end
    return true
end

local toggleNames={"fling ball","fling sofá","killsofa","lag lanterna","espectar player","fling ônibus","kill ônibus","fling barco","kill canoa"}

-- Espectar player
local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso")
    if not hrp then return end
    local cam = workspace.CurrentCamera
    LastCameraState.CameraType=cam.CameraType
    LastCameraState.CameraSubject=cam.CameraSubject
    LastCameraState.CameraCFrame=cam.CFrame
    cam.CameraType=Enum.CameraType.Scriptable
    Spectating=true
    SpectateConnection=RunService.RenderStepped:Connect(function()
        if not Spectating then return end
        if not targetPlayer or not targetPlayer.Character or not hrp.Parent then stopSpectate(); notify("Espectar","Player saiu/morto. Parando espectar.",3); return end
        local targetCFrame=CFrame.new(hrp.Position+Vector3.new(0,2,8), hrp.Position)
        cam.CFrame=cam.CFrame:Lerp(targetCFrame,0.25)
    end)
end
local function stopSpectate()
    Spectating=false
    if SpectateConnection then SpectateConnection:Disconnect(); SpectateConnection=nil end
    local cam=workspace.CurrentCamera
    if cam then
        cam.CameraType=LastCameraState.CameraType or Enum.CameraType.Custom
        cam.CameraSubject=LastCameraState.CameraSubject or LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if LastCameraState.CameraCFrame then cam.CFrame=LastCameraState.CameraCFrame end
    end
end

local function makeToggleCallback(name,toggleObj)
    return function(value)
        if name=="espectar player" then
            if value then if not requireSelected(toggleObj) then return end; startSpectate(SelectedPlayer) else stopSpectate() end
            return
        end
        if not requireSelected(toggleObj) then return end
        if value then notify("Action",name.." ativado para "..(SelectedPlayer and SelectedPlayer.Name or "N/A"),4)
        else notify("Action",name.." desativado",3) end
    end
end

for _,tname in ipairs(toggleNames) do
    local id=tname:gsub("%s","_")
    local tog=Tabs.Main:AddToggle(id,{Title=tname,Default=false})
    ToggleTable[tname]=tog
    tog:OnChanged(makeToggleCallback(tname,tog))
end

-- Black Role
Tabs.Main:AddButton({
    Title="Black Role",
    Description="Executa código Lua",
    Callback=function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-black-hole-18879"))()
        end)
        notify("Black Role","Código executado.",3)
    end
})

-- Brookhaven Audio
Tabs.Main:AddButton({
    Title="Brookhaven Audio",
    Description="Executa código de áudio",
    Callback=function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio"))()
        end)
        notify("Brookhaven Audio","Código executado.",3)
    end
})

-- Ball girando em torno do player
local BallPart = nil
local BallConnection = nil
local BallNames = {"Ball","bola","Bola","bola futebol"}
local BallRadius = 3
local BallSpeed = 10

local function findBall()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and table.find(BallNames, part.Name) then
            return part
        end
    end
    return nil
end

local function startBallFling()
    BallPart = findBall()
    if not BallPart then notify("Fling Ball","Nenhuma bola encontrada no workspace",3); return end
    BallConnection = RunService.RenderStepped:Connect(function(dt)
        if not ToggleTable["fling ball"]:GetValue() or not SelectedPlayer or not SelectedPlayer.Character then
            if BallConnection then BallConnection:Disconnect(); BallConnection=nil end
            return
        end
        local torso = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") or SelectedPlayer.Character:FindFirstChild("Torso")
        if not torso then return end
        local angle = tick()*BallSpeed
        local x = math.cos(angle)*BallRadius
        local z = math.sin(angle)*BallRadius
        BallPart.CFrame = CFrame.new(torso.Position + Vector3.new(x,2,z))
    end)
end

ToggleTable["fling ball"]:OnChanged(function(value)
    if value then
        if not requireSelected(ToggleTable["fling ball"]) then return end
        startBallFling()
    else
        if BallConnection then BallConnection:Disconnect(); BallConnection=nil end
    end
end)

-- Bolinha F que simula tecla (volta ao comportamento anterior)
do
    local CoreGui=game:GetService("CoreGui")
    local screenGui=Instance.new("ScreenGui")
    screenGui.Name="FiatHubToggleBall"
    screenGui.ResetOnSpawn=false
    screenGui.Parent=CoreGui

    local button=Instance.new("TextButton")
    button.Name="ToggleBall"
    button.Size=UDim2.new(0,48,0,48)
    button.Position=UDim2.new(0,20,0,200)
    button.AnchorPoint=Vector2.new(0,0)
    button.Text="F"
    button.Font=Enum.Font.SourceSansBold
    button.TextSize=24
    button.BorderSizePixel=0
    button.AutoButtonColor=false
    button.Parent=screenGui
    button.BackgroundColor3=Color3.new(0,0,0)
    button.TextColor3=Color3.new(1,1,1)
    button.BackgroundTransparency=0
    button.ZIndex=9999
    button.ClipsDescendants=true
    button.Active=true
    local corner=Instance.new("UICorner",button)
    corner.CornerRadius=UDim.new(1,0)

    -- Drag
    local dragging,dragInput,dragStart,startPos
    local function update(input)
        local delta=input.Position-dragStart
        button.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=button.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    button.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end end)
    UserInputService.InputChanged:Connect(function(input) if input==dragInput and dragging then update(input) end end)

    -- Clicar: simula tecla que você mencionou
    button.MouseButton1Click:Connect(function()
        pcall(function()
            local vim=game:GetService("VirtualInputManager")
            if vim and vim.SendKeyEvent then
                vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(0.06)
                vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
            else
                local vu=game:GetService("VirtualUser")
                vu:CaptureController()
                UserInputService.InputBegan:Fire({UserInputType=Enum.UserInputType.Keyboard,KeyCode=Enum.KeyCode.LeftControl},false)
                task.wait(0.06)
                UserInputService.InputEnded:Fire({UserInputType=Enum.UserInputType.Keyboard,KeyCode=Enum.KeyCode.LeftControl},false)
            end
        end)
    end)
end

-- Add-ons
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FiatHub")
SaveManager:SetFolder("FiatHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Aba inicial
Window:SelectTab(1)
Fluent:Notify({Title="Fiat Hub", Content="Script carregado com sucesso!", Duration=6})
pcall(function() SaveManager:LoadAutoloadConfig() end)
if Fluent then pcall(function() if Fluent.Unloaded then stopSpectate() end end) end
