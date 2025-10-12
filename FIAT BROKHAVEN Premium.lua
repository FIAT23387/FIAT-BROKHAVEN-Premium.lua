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

-- Criar Janela Principal (UI cinza clara/transparente)
local Window = Fluent:CreateWindow({
    Title = "Fiat Hub",
    SubTitle = "by_fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark", -- manter Dark e ajustar cor manualmente
    MinimizeKey = nil
})

-- Forçar Parent para PlayerGui
Window.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Ajuste extra de aparência
pcall(function()
    if Window.MainContainer then
        Window.MainContainer.BackgroundColor3 = Color3.fromRGB(200,200,200)
        Window.MainContainer.BackgroundTransparency = 0.3
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

-- Dropdown dinâmico de players
local function buildPlayerValueList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

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

-- Criar Dropdown de players
PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = buildPlayerValueList(),
    Multi = false,
    Default = 1
})
local initialValues = buildPlayerValueList()
if #initialValues > 0 then
    PlayerDropdown:SetValue(initialValues[1])
    setSelectedPlayerByName(initialValues[1])
end

PlayerDropdown:OnChanged(setSelectedPlayerByName)

-- Atualiza dropdown quando players entram/saem
Players.PlayerAdded:Connect(function(plr)
    PlayerDropdown:SetValues(buildPlayerValueList())
end)
Players.PlayerRemoving:Connect(function(plr)
    PlayerDropdown:SetValues(buildPlayerValueList())
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

-- Callback genérico
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

-- Criar toggles
for _, tname in ipairs(toggleNames) do
    local id = tname:gsub("%s","_")
    local tog = Tabs.Main:AddToggle(id, { Title = tname, Default = false })
    ToggleTable[tname] = tog
    tog:OnChanged(makeToggleCallback(tname, tog))
end

-- Black Role
Tabs.Main:AddButton({
    Title = "Black Role",
    Description = "Executa BringFlingPlayers",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))("More Scripts: t.me/arceusxscripts")
    end
})

-- Brookhaven Audio
Tabs.Main:AddButton({
    Title = "Brookhaven Audio",
    Description = "Executa áudio",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio"))()
    end
})

-- Bola preta F
do
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FiatHubToggleBall"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,48,0,48)
    button.Position = UDim2.new(0,20,0,200)
    button.Text = "F"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 24
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = screenGui
    button.BackgroundColor3 = Color3.new(0,0,0)
    button.TextColor3 = Color3.new(1,1,1)
    button.BackgroundTransparency = 0
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(1,0)

    -- Drag
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Clicar = simula Ctrl
    button.MouseButton1Click:Connect(function()
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            task.wait(0.06)
            vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
        end)
    end)
end

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
        if Fluent.Unloaded then stopSpectate() end
    end)
end
