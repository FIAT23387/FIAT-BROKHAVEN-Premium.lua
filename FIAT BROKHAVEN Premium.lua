-- Fiat Hub - Tudo junto - Dark Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Janela Dark
local Window = Fluent:CreateWindow({
    Title="Fiat Hub",
    SubTitle="by_fiat",
    TabWidth=160,
    Size=UDim2.fromOffset(580,460),
    Acrylic=true,
    Theme="Dark"
})
Window.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Abas
local Tabs = {
    Main = Window:AddTab({Title="Main"}),
    Settings = Window:AddTab({Title="Settings"})
}

-- Estado
local SelectedPlayer = nil
local PlayerDropdown = nil
local ToggleTable = {}
local Spectating = false
local SpectateConnection = nil
local LastCameraState = {CameraType=nil, CameraSubject=nil, CameraCFrame=nil}

-- Notificação
local function notify(title, content, duration)
    Fluent:Notify({Title=title or "Fiat Hub", Content=content or "", Duration=duration or 4})
end

-- Dropdown players
local function buildPlayerList()
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(list,p.Name) end end
    return list
end

local function setSelectedPlayer(name)
    if not name or name=="" then SelectedPlayer=nil notify("Player","Nenhum player selecionado",3) return end
    local p = Players:FindFirstChild(name)
    if p then SelectedPlayer=p notify("Player","Selecionado: "..p.Name,3)
    else SelectedPlayer=nil notify("Player","Player não encontrado: "..tostring(name),3) end
end

PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {Title="Select Player", Values=buildPlayerList(), Multi=false, Default=1})
local initial = buildPlayerList()
if #initial>0 then PlayerDropdown:SetValue(initial[1]) setSelectedPlayer(initial[1]) end
PlayerDropdown:OnChanged(function(val) setSelectedPlayer(val) end)
Players.PlayerAdded:Connect(function() PlayerDropdown:SetValues(buildPlayerList()) end)
Players.PlayerRemoving:Connect(function(plr)
    PlayerDropdown:SetValues(buildPlayerList())
    if SelectedPlayer and SelectedPlayer.Name==plr.Name then SelectedPlayer=nil notify("Player","Player saiu: "..plr.Name,3) end
end)

-- Checagem de seleção
local function requireSelected(toggleObj)
    if not SelectedPlayer then
        notify("Erro","Selecione um player primeiro.",3)
        if toggleObj and toggleObj.SetValue then pcall(function() toggleObj:SetValue(false) end) end
        return false
    end
    return true
end

-- Toggles
local toggleNames={"fling ball","fling sofá","killsofa","lag lanterna","espectar player","fling ônibus","kill ônibus","fling barco","kill canoa"}
for _,name in ipairs(toggleNames) do
    local tog = Tabs.Main:AddToggle(name:gsub("%s","_"), {Title=name, Default=false})
    ToggleTable[name]=tog
end

-- Espectar player
local function startSpectate(p)
    if not p or not p.Character then return end
    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cam=Workspace.CurrentCamera
    LastCameraState.CameraType=cam.CameraType
    LastCameraState.CameraSubject=cam.CameraSubject
    LastCameraState.CameraCFrame=cam.CFrame
    cam.CameraType=Enum.CameraType.Scriptable
    Spectating=true
    SpectateConnection=RunService.RenderStepped:Connect(function()
        if not Spectating then return end
        if not p or not p.Character or not hrp.Parent then
            Spectating=false
            cam.CameraType=LastCameraState.CameraType or Enum.CameraType.Custom
            cam.CameraSubject=LastCameraState.CameraSubject or LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if LastCameraState.CameraCFrame then cam.CFrame=LastCameraState.CameraCFrame end
            notify("Espectar","Player saiu/morto. Parando espectar.",3)
            return
        end
        cam.CFrame=cam.CFrame:Lerp(CFrame.new(hrp.Position+Vector3.new(0,2,8),hrp.Position),0.25)
    end)
end

local function stopSpectate()
    Spectating=false
    if SpectateConnection then SpectateConnection:Disconnect() SpectateConnection=nil end
    local cam=Workspace.CurrentCamera
    if cam then
        cam.CameraType=LastCameraState.CameraType or Enum.CameraType.Custom
        cam.CameraSubject=LastCameraState.CameraSubject or LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if LastCameraState.CameraCFrame then cam.CFrame=LastCameraState.CameraCFrame end
    end
end

-- Toggle callbacks
for name,tog in pairs(ToggleTable) do
    tog:OnChanged(function(value)
        if name=="espectar player" then
            if value then if not requireSelected(tog) then return end startSpectate(SelectedPlayer) else stopSpectate() end
            return
        end
        if not requireSelected(tog) then return end
        if value then notify("Action",name.." ativado para "..(SelectedPlayer and SelectedPlayer.Name or "N/A"),4)
        else notify("Action",name.." desativado",3) end
    end)
end

-- Botões Main
Tabs.Main:AddButton({Title="Black Role", Description="Executa código Lua", Callback=function()
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-black-hole-18879"))() end)
    notify("Black Role","Executado.",3)
end})
Tabs.Main:AddButton({Title="Brookhaven Audio", Description="Executa áudio", Callback=function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio"))() end)
    notify("Brookhaven Audio","Executado.",3)
end})

-- Bola girando
do
    local ballEnabled=false
    local ballPart=nil
    local screenGui=Instance.new("ScreenGui",CoreGui)
    screenGui.Name="FiatHubToggleBall"
    local button=Instance.new("TextButton",screenGui)
    button.Size=UDim2.new(0,48,0,48)
    button.Position=UDim2.new(0,20,0,200)
    button.Text="F"
    button.Font=Enum.Font.SourceSansBold
    button.TextSize=24
    button.BackgroundColor3=Color3.fromRGB(0,0,0)
    button.TextColor3=Color3.new(1,1,1)
    button.BorderSizePixel=0
    local corner=Instance.new("UICorner",button); corner.CornerRadius=UDim.new(1,0)

    local dragging,dragInput,dragStart,startPos
    local function update(input)
        local delta=input.Position-dragStart
        button.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true dragStart=input.Position startPos=button.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    button.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input==dragInput and dragging then update(input) end end)

    button.MouseButton1Click:Connect(function()
        ballEnabled = not ballEnabled
        if ballEnabled and SelectedPlayer and SelectedPlayer.Character then
            if not ballPart then
                ballPart=Instance.new("Part",Workspace)
                ballPart.Name="FiatHubBall"
                ballPart.Shape="Ball"
                ballPart.Size=Vector3.new(2,2,2)
                ballPart.Anchored=false
                ballPart.CanCollide=false
                ballPart.Material=Enum.Material.Neon
                ballPart.BrickColor=BrickColor.new("Bright red")
            end
        elseif ballPart then
            ballPart:Destroy()
            ballPart=nil
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        if ballEnabled and ballPart and SelectedPlayer and SelectedPlayer.Character then
            local hrp=SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local t=tick()*10
                local r=3
                ballPart.CFrame=CFrame.new(hrp.Position+Vector3.new(math.cos(t)*r,2,math.sin(t)*r),hrp.Position)
                -- Fling
                for _,p in ipairs(Workspace:GetChildren()) do
                    if p:IsA("BasePart") and (p.Position-hrp.Position).Magnitude<=30 then
                        p.Velocity=(hrp.Position-p.Position).Unit*100
                    end
                end
            end
        end
    end)
end

-- Add-ons Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FiatHub")
SaveManager:SetFolder("FiatHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Inicialização
Window:SelectTab(1)
Fluent:Notify({Title="Fiat Hub",Content="Script carregado com sucesso!",Duration=6})
pcall(function() SaveManager:LoadAutoloadConfig() end)
if Fluent then pcall(function() if Fluent.Unloaded then stopSpectate() end end) end
