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
    -- Value é string nome do player (no Fluent original Value)
    setSelectedPlayerByName(Value)
end)

-- Atualiza dropdown quando players entram/saem
Players.PlayerAdded:Connect(function(plr)
    local values = buildPlayerValueList()
    PlayerDropdown:SetValues(values)
end)
Players.PlayerRemoving:Connect(function(plr)
    local values = buildPlayerValueList()
    PlayerDropdown:SetValues(values)
    -- se o removed era o selecionado, limpa seleção
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
            -- reverte toggle para false (se existente)
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
    -- salvar estado atual
    LastCameraState.CameraType = cam.CameraType
    LastCameraState.CameraSubject = cam.CameraSubject
    -- set scriptable
    cam.CameraType = Enum.CameraType.Scriptable
    Spectating = true

    -- Atualizar cada frame
    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not Spectating then return end
        if not targetPlayer or not targetPlayer.Character then
            -- jogador morreu ou saiu
            notify("Espectar", "Player desconectado/morto. Parando espectar.", 3)
            -- desligar automaticamente
            Spectating = false
            if SpectateConnection then SpectateConnection:Disconnect() SpectateConnection = nil end
            -- restaurar camera
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraType = LastCameraState.CameraType or Enum.CameraType.Custom
                workspace.CurrentCamera.CameraSubject = LastCameraState.CameraSubject or LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") or nil
            end
            return
        end
        local newCFrame = hrp.CFrame * CFrame.new(0, 2, 8) -- offset de trás
        -- suaviza movimento com Lerp
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
    -- restaurar camera
    if workspace.CurrentCamera then
        workspace.CurrentCamera.CameraType = LastCameraState.CameraType or Enum.CameraType.Custom
        if LastCameraState.CameraSubject then
            workspace.CurrentCamera.CameraSubject = LastCameraState.CameraSubject
        else
            -- tenta setar pro humanoid local
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
        end
    end
end

-- Callback genérico para toggles (os outros toggles apenas mostram notificação por enquanto)
local function makeToggleCallback(name, toggleObj)
    return function(value)
        -- value = true/false
        if name == "espectar player" then
            if value then
                if not requireSelected(toggleObj) then return end
                startSpectate(SelectedPlayer)
            else
                stopSpectate()
            end
            return
        end

        -- demais toggles: checar player selecionado
        if not requireSelected(toggleObj) then return end

        -- Aqui você pode implementar lógicas reais para fling/kill/etc.
        -- Por enquanto apenas notifica e mantém o estado do toggle:
        if value then
            notify("Action", name .. " ativado para " .. (SelectedPlayer and SelectedPlayer.Name or "N/A"), 4)
            -- placeholder: executar rotina específica se desejar
        else
            notify("Action", name .. " desativado", 3)
            -- placeholder stop
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

-- Black Role: botão que abre textbox para executar código (não precisa de player)
local BlackRoleInput = nil
local function createBlackRoleUI()
    -- Adiciona botão que abre diálogo com textbox
    Tabs.Main:AddButton({
        Title = "Black Role",
        Description = "Open a code input. Paste Lua code and Execute.",
        Callback = function()
            -- janela simples com Input e dois botões (Execute / Cancel)
            local inputText = ""
            -- Many Fluent builds have Window:Dialog or similar; usar Window:Dialog se disponível
            if Window and Window.Dialog then
                Window:Dialog({
                    Title = "Black Role - Execute Code",
                    Content = "Cole seu código Lua abaixo e pressione Execute.",
                    Inputs = {
                        {
                            Placeholder = "print('hello')",
                            Text = "",
                            Callback = function(txt) inputText = txt end
                        }
                    },
                    Buttons = {
                        {
                            Title = "Execute",
                            Callback = function()
                                if inputText == "" then
                                    notify("Black Role", "Nenhum código informado.", 3)
                                    return
                                end
                                local ok, res = pcall(function()
                                    -- tentar compilar e executar em ambiente protegido (pcall)
                                    local fn, err = loadstring(inputText)
                                    if not fn then error(err) end
                                    return fn()
                                end)
                                if not ok then
                                    notify("Black Role - Error", tostring(res), 5)
                                else
                                    notify("Black Role", "Código executado com sucesso.", 3)
                                end
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function() end
                        }
                    }
                })
            else
                -- fallback: criar small input gui manual (simplificado)
                notify("Black Role", "Dialog não disponível na versão do Fluent. Use outra interface.", 4)
            end
        end
    })
end

createBlackRoleUI()

-- Botão/bola preta arrastável com "F" que simula a tecla Ctrl ao clicar
do
    -- criar ScreenGui e ImageButton (bola)
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FiatHubToggleBall"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local button = Instance.new("TextButton")
    button.Name = "ToggleBall"
    button.Size = UDim2.new(0,48,0,48)
    button.Position = UDim2.new(0,20,0,200)
    button.AnchorPoint = Vector2.new(0,0)
    button.Text = "F"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 24
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = screenGui
    button.BackgroundColor3 = Color3.new(0,0,0)
    button.TextColor3 = Color3.new(1,1,1)
    button.BackgroundTransparency = 0
    button.ZIndex = 9999
    button.ClipsDescendants = true
    button.Active = true

    -- UI Round
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(1,0)

    -- Color tween loop (muda suavemente)
    spawn(function()
        local TweenService = game:GetService("TweenService")
        local colors = {
            Color3.fromRGB(0,0,0),
            Color3.fromRGB(40,40,40),
            Color3.fromRGB(80,0,80),
            Color3.fromRGB(0,40,80)
        }
        local idx = 1
        while task.wait(2) do
            if button and button.Parent then
                local nextIdx = idx % #colors + 1
                local tweenInfo = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true)
                local tween = TweenService:Create(button, tweenInfo, { BackgroundColor3 = colors[nextIdx] })
                tween:Play()
                idx = nextIdx
            else
                break
            end
        end
    end)

    -- Dragging
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

    -- Ao clicar, simular a tecla LeftControl (pressionar e soltar)
    button.MouseButton1Click:Connect(function()
        -- Tenta usar VirtualInputManager (exploit env), senão tenta VirtualUser fallback
        local success = false
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            if vim and vim.SendKeyEvent then
                -- Press
                vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(0.06)
                -- Release
                vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
                success = true
            end
        end)
        if not success then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                -- VirtualUser doesn't send keyboard events reliably, but we can attempt to capture focus and click (best-effort)
                -- Simulating by capturing focus and sending capture focus action
                vu:CaptureController()
                -- No direct key simulation — as fallback we'll fire InputBegan/Ended on UserInputService (may not work)
                pcall(function()
                    UserInputService.InputBegan:Fire({UserInputType = Enum.UserInputType.Keyboard, KeyCode = Enum.KeyCode.LeftControl}, false)
                    task.wait(0.06)
                    UserInputService.InputEnded:Fire({UserInputType = Enum.UserInputType.Keyboard, KeyCode = Enum.KeyCode.LeftControl}, false)
                end)
            end)
        end
    end)
end

-- Integrar Add-ons (igual ao original)
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
    Content = "The script has been loaded.",
    Duration = 6
})

-- Carregar autoconfig (se existir)
pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

-- Garantir desligamento da espectate caso o script/unload aconteça
if Fluent then
    pcall(function()
        if Fluent.Unloaded then
            stopSpectate()
        end
    end)
end

-- FIM
