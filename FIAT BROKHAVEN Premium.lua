-- INDIOT_HUB (Fluent-based) - versão revisada e com proteções
local function safeLoad(url, desc)
    desc = desc or url
    local ok, res = pcall(function()
        local body = game:HttpGet(url, true)
        return loadstring(body)()
    end)
    if not ok then
        warn("Falha ao carregar: "..tostring(desc).."\nErro: "..tostring(res))
    end
    return ok, res
end

-- Tenta carregar Fluent principal (usualmente a URL de releases funciona)
local fluentOk, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)
if not fluentOk or not Fluent then
    warn("Não foi possível carregar Fluent. Verifique conexão/URL/executor.")
    return
end

-- Addons (carregar com proteção)
local saveManagerOK, SaveManager = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua", true))()
end)
local interfaceManagerOK, InterfaceManager = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua", true))()
end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("LocalPlayer não encontrado.")
    return
end
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Janela Principal (Dark)
local Window = Fluent:CreateWindow({
    Title = "INDIOT_HUB",
    SubTitle = "by: fiat_bot",
    TabWidth = 160,
    Size = UDim2.fromOffset(580,460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = nil
})

-- tenta parent na PlayerGui; se não der, tenta CoreGui (com pcall para evitar erro)
pcall(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 5)
    if pg then Window.Parent = pg else Window.Parent = CoreGui end
end)

-- Ajusta aparência (se existir)
pcall(function()
    if Window.MainContainer then
        Window.MainContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Window.MainContainer.BackgroundTransparency = 0.2
    end
end)

-- Função de notify
local function notify(title, content, duration)
    duration = duration or 4
    pcall(function() Fluent:Notify({Title = title or "INDIOT_HUB", Content = content or "", Duration = duration}) end)
end

-- Piscando subtítulo (seguro)
spawn(function()
    local colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)}
    local idx = 1
    while task.wait(0.8) do
        if Window and Window.SubTitleLabel then
            idx = idx % 2 + 1
            pcall(function()
                TweenService:Create(Window.SubTitleLabel, TweenInfo.new(0.5), {TextColor3 = colors[idx]}):Play()
            end)
        else
            break
        end
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

-- Melhor versão de stopSpectate (definida antes para segurança)
local function stopSpectate()
    Spectating = false
    if SpectateConnection then
        pcall(function() SpectateConnection:Disconnect() end)
        SpectateConnection = nil
    end
    local cam = workspace.CurrentCamera
    if cam then
        cam.CameraType = LastCameraState.CameraType or Enum.CameraType.Custom
        pcall(function()
            cam.CameraSubject = LastCameraState.CameraSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"))
            if LastCameraState.CameraCFrame then
                cam.CFrame = LastCameraState.CameraCFrame
            end
        end)
    end
end

-- startSpectate usa stopSpectate quando necessário
local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso")
    if not hrp then return end
    local cam = workspace.CurrentCamera
    -- salva estado
    LastCameraState.CameraType = cam.CameraType
    LastCameraState.CameraSubject = cam.CameraSubject
    LastCameraState.CameraCFrame = cam.CFrame
    cam.CameraType = Enum.CameraType.Scriptable
    Spectating = true
    -- garante desconexão prévia
    if SpectateConnection then
        pcall(function() SpectateConnection:Disconnect() end)
        SpectateConnection = nil
    end
    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not Spectating then return end
        if not targetPlayer or not targetPlayer.Character or not hrp.Parent then
            stopSpectate()
            notify("Espectar", "Player saiu/morto. Parando espectar.", 3)
            return
        end
        local targetCFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 8), hrp.Position)
        pcall(function()
            cam.CFrame = cam.CFrame:Lerp(targetCFrame, 0.25)
        end)
    end)
end

-- util para criar lista de players
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
        notify("Player", "Selecionado: "..p.Name, 3)
    else
        SelectedPlayer = nil
        notify("Player", "Player não encontrado: "..tostring(name), 3)
    end
end

-- Dropdown players (com check se lista vazia)
PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = buildPlayerValueList(),
    Multi = false,
    Default = ""
})
-- se tiver players, seta primeiro
local initialValues = buildPlayerValueList()
if #initialValues > 0 then
    PlayerDropdown:SetValue(initialValues[1])
    setSelectedPlayerByName(initialValues[1])
else
    PlayerDropdown:SetValue("")
end
PlayerDropdown:OnChanged(setSelectedPlayerByName)

-- atualiza lista quando players entram/saem
Players.PlayerAdded:Connect(function(plr)
    pcall(function() PlayerDropdown:SetValues(buildPlayerValueList()) end)
end)
Players.PlayerRemoving:Connect(function(plr)
    pcall(function() PlayerDropdown:SetValues(buildPlayerValueList()) end)
    if SelectedPlayer and SelectedPlayer.Name == plr.Name then
        SelectedPlayer = nil
        notify("Player", "Player saiu: "..plr.Name, 3)
    end
end)

-- util: exige player selecionado
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

-- Toggle names (mantidos)
local toggleNames = {"fling sofá","killsofa","lag lanterna","espectar player","fling ônibus","kill ônibus","fling barco","kill canoa"}

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
            notify("Action", name.." ativado para "..(SelectedPlayer and SelectedPlayer.Name or "N/A"), 4)
        else
            notify("Action", name.." desativado", 3)
        end
    end
end

for _, tname in ipairs(toggleNames) do
    local id = tname:gsub("%s","_")
    local tog = Tabs.Main:AddToggle(id, {Title = tname, Default = false})
    ToggleTable[tname] = tog
    tog:OnChanged(makeToggleCallback(tname, tog))
end

-- Black Role (carrega com pcall)
Tabs.Main:AddButton({
    Title = "Black Role",
    Description = "Executa código Lua",
    Callback = function()
        pcall(function()
            -- se essa URL falhar, não quebra o script
            local ok, _ = pcall(function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-black-hole-18879", true))()
            end)
            if ok then
                notify("Black Role", "Código executado.", 3)
            else
                notify("Black Role", "Falha ao executar (URL bloqueada ou offline).", 4)
            end
        end)
    end
})

-- Brookhaven Audio (carrega com pcall; verifique a URL)
Tabs.Main:AddButton({
    Title = "Brookhaven Audio",
    Description = "Executa código de áudio",
    Callback = function()
        pcall(function()
            local ok, _ = pcall(function()
                -- ajuste a URL se necessário
                loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/main/Brookhaven_audio.lua", true))()
            end)
            if ok then
                notify("Brookhaven Audio", "Código executado.", 3)
            else
                notify("Brookhaven Audio", "Falha ao executar (URL inválida).", 4)
            end
        end)
    end
})

-- Bolinha F para mobile (GUI segura)
pcall(function()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "INDIOT_HUB_Ball"
    screenGui.ResetOnSpawn = false
    -- tenta parent no PlayerGui (caso CoreGui proibido)
    local parentOk = pcall(function()
        screenGui.Parent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui
    end)
    if not parentOk then
        screenGui.Parent = CoreGui
    end

    local button = Instance.new("ImageButton")
    button.Name = "ToggleBall"
    button.Size = UDim2.new(0,50,0,50)
    button.Position = UDim2.new(0,20,0,200)
    button.AnchorPoint = Vector2.new(0,0)
    button.Image = "rbxassetid://104075185237723"
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = screenGui
    button.BackgroundColor3 = Color3.fromRGB(255,255,255)
    button.ZIndex = 9999
    button.ClipsDescendants = true
    button.Active = true
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(1,0)

    -- Dragging safe implementation
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Clique: simula LeftControl (tenta VirtualInputManager, depois VirtualUser)
    button.MouseButton1Click:Connect(function()
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            if vim and vim.SendKeyEvent then
                vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(0.06)
                vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
            else
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                -- disparar eventos de input de forma segura via pcall
                pcall(function()
                    UserInputService.InputBegan:Fire({UserInputType=Enum.UserInputType.Keyboard, KeyCode=Enum.KeyCode.LeftControl}, false)
                    task.wait(0.06)
                    UserInputService.InputEnded:Fire({UserInputType=Enum.UserInputType.Keyboard, KeyCode=Enum.KeyCode.LeftControl}, false)
                end)
            end
        end)
    end)

    -- efeito piscante do botão (seguro)
    spawn(function()
        local colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)}
        local idx = 1
        while task.wait(1) do
            if button and button.Parent then
                idx = idx % 2 + 1
                pcall(function()
                    TweenService:Create(button, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = colors[idx]}):Play()
                end)
            else
                break
            end
        end
    end)
end)

-- Add-ons: configurações seguras (só se carregaram)
if saveManagerOK and interfaceManagerOK then
    pcall(function()
        SaveManager:SetLibrary(Fluent)
        InterfaceManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
        InterfaceManager:SetFolder("INDIOT_HUB")
        SaveManager:SetFolder("INDIOT_HUB/specific-game")
        InterfaceManager:BuildInterfaceSection(Tabs.Settings)
        SaveManager:BuildConfigSection(Tabs.Settings)
    end)
end

-- Aba inicial e notify final
Window:SelectTab(1)
notify("INDIOT_HUB", "Script carregado com sucesso (versão protegida).", 6)

-- tenta autoload config sem travar
pcall(function() if SaveManager and SaveManager.LoadAutoloadConfig then SaveManager:LoadAutoloadConfig() end end)

-- quando Fluent for descarregado, garante stopSpectate
if Fluent then
    pcall(function()
        if Fluent.Unloaded then stopSpectate() end
    end)
end
