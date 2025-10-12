-- Fiat Hub (Fluent-based) - by_fiat
-- Requisitos: Fluent + Addons (carregados abaixo)
-- Cole isso num LocalScript no cliente

-- Carregar Fluent e Add-ons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Criar Janela Principal (theme adaptado para visual branco/transparente)
local Window = Fluent:CreateWindow({
    Title = "Fiat Hub",
    SubTitle = "by_fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Light", -- deixa mais claro (tentativa de UI branca/transparente)
    MinimizeKey = nil -- sem atalho de minimizar
})

-- Ajuste extra de aparência (caso Fluent exponha frames)
pcall(function()
    if Window.MainContainer then
        if Window.MainContainer.BackgroundColor3 then
            Window.MainContainer.BackgroundColor3 = Color3.fromRGB(255,255,255)
        end
        if Window.MainContainer.BackgroundTransparency then
            Window.MainContainer.BackgroundTransparency = 0.4
        end
    end
end)

-- Abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Estado interno
local SelectedPlayer = nil
local PlayerDropdown = nil
local ToggleTable = {}
local SpectateConnection = nil
local Spectating = false
local LastCameraState = {
    CameraType = nil,
    CameraSubject = nil,
    CameraCFrame = nil
}

-- Util: notificar
local function notify(title, content, duration)
    Fluent:Notify({
        Title = title or "Fiat Hub",
        Content = content or "",
        Duration = duration or 4
    })
end

-- Dropdown dinâmico de players (estilo dropdown do exemplo)
local function buildPlayerValueList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- Função para definir o SelectedPlayer por nome (ou nil)
local function setSelectedPlayerByName(name)
    if not name or name == "" then
        SelectedPlayer = nil
        notify("Player", "Nenhum player selecionado", 3)
        return
    end
    local p = Players:FindFirstChild(name)
    if p then
        SelectedPlayer = p
        notify("Player", "Selecionado: " .. p.Name, 3)
    else
        SelectedPlayer = nil
        notify("Player", "Player não encontrado: " .. tostring(name), 3)
    end
end

-- Criar Dropdown de players (single select)
PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = buildPlayerValueList(),
    Multi = false,
    Default = 1
})
-- Set initial to first if exists
local initialValues = buildPlayerValueList()
if #initialValues > 0 then
    PlayerDropdown:SetValue(initialValues[1])
    setSelectedPlayerByName(initialValues[1])
end

PlayerDropdown:OnChanged(function(Value)
    setSelectedPlayerByName(Value)
end)

Players.PlayerAdded:Connect(function(plr)
    local values = buildPlayerValueList()
    PlayerDropdown:SetValues(values)
end)
Players.PlayerRemoving:Connect(function(plr)
    local values = buildPlayerValueList()
    PlayerDropdown:SetValues(values)
    if SelectedPlayer and SelectedPlayer.Name == plr.Name then
        SelectedPlayer = nil
        notify("Player", "Player saiu: " .. plr.Name, 3)
    end
end)

-- Função util para checar seleção antes de ação
local function requireSelected(toggleObj)
    if not SelectedPlayer then
        notify("Erro", "Você precisa selecionar um player primeiro.", 3)
        if toggleObj and toggleObj.SetValue then
            pcall(function() toggleObj:SetValue(false) end)
        end
        return false
    end
    return true
end

-- Lista de nomes dos 9 toggles
local toggleNames = {
    "fling ball",
    "fling sofá",
    "killsofa",
    "lag lanterna",
    "espectar player",
    "fling ônibus",
    "kill ônibus",
    "fling barco",
    "kill canoa"
}

-- Handler para o toggle 'espectar player' — lógica real
local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso") or targetPlayer.Character:FindFirstChild("UpperTorso")
    if not hrp then
        notify("Espectar", "O player não possui HumanoidRootPart.", 3)
        return
    end

    local cam = workspace.CurrentCamera
    LastCameraState.CameraType = cam.CameraType
    LastCameraState.CameraSubject = cam.CameraSubject
    cam.CameraType = Enum.CameraType.Scriptable
    Spectating = true

    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not Spectating then return end
        if not targetPlayer or not targetPlayer.Character then
            notify("Espectar", "Player desconectado/morto. Parando espectar.", 3)
            Spectating = false
            if SpectateConnection then SpectateConnection:Disconnect() SpectateConnection = nil end
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraType = LastCameraState.CameraType or Enum.CameraType.Custom
                workspace.CurrentCamera.CameraSubject = LastCameraState.CameraSubject or LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") or nil
            end
            return
        end
        local newCFrame = hrp.CFrame * CFrame.new(0, 2, 8)
        local currentCFrame = workspace.CurrentCamera.CFrame
        workspace.CurrentCamera.CFrame = currentCFrame:Lerp(newCFrame, 0.25)
    end)
end

local function stopSpectate()
    Spectating = false
    if SpectateConnection then
        SpectateConnection:Disconnect()
        SpectateConnection = nil
    end
    if workspace.CurrentCamera then
        workspace.CurrentCamera.CameraType = LastCameraState.CameraType or Enum.CameraType.Custom
        if LastCameraState.CameraSubject then
            workspace.CurrentCamera.CameraSubject = LastCameraState.CameraSubject
        else
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
        end
    end
end

-- Callback genérico para toggles
local function makeToggleCallback(name, toggleObj)
    return function(value)
        if name == "espectar player" then
            if value then
                if not requireSelected(toggleObj) then return end
                startSpectate(SelectedPlayer)
            else
                stopSpectate()
            end
            return
        end

        if not requireSelected(toggleObj) then return end
        if value then
            notify("Action", name .. " ativado para " .. (SelectedPlayer and SelectedPlayer.Name or "N/A"), 4)
        else
            notify("Action", name .. " desativado", 3)
        end
    end
end

-- Criar os 9 toggles na aba Main
for _, tname in ipairs(toggleNames) do
    local id = tname:gsub("%s","_")
    local tog = Tabs.Main:AddToggle(id, { Title = tname, Default = false })
    ToggleTable[tname] = tog
    tog:OnChanged(makeToggleCallback(tname, tog))
end

-- ======= NOVOS BOTÕES =======

-- Black Role (executa código remoto)
Tabs.Main:AddButton({
    Title = "Black Role",
    Description = "Executa código remoto",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))("More Scripts: t.me/arceusxscripts")
    end
})

-- Brookhaven Audio (executa código remoto)
Tabs.Main:AddButton({
    Title = "Brookhaven Audio",
    Description = "Executa script de áudio",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio"))()
    end
})

-- Integrar Add-ons
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FiatHub")
SaveManager:SetFolder("FiatHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Selecionar aba e notificar
Window:SelectTab(1)
Fluent:Notify({
    Title = "Fiat Hub",
    Content = "O script foi carregado com sucesso.",
    Duration = 6
})

pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

if Fluent then
    pcall(function()
        if Fluent.Unloaded then
            stopSpectate()
        end
    end)
end

-- FIM
