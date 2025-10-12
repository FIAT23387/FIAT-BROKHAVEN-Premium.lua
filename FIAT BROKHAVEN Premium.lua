--// Fiat Hub UI Final - Cinza
--// by_fiat

-- Carregar Fluent e Add-ons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Criar Janela Principal (cinza)
local Window = Fluent:CreateWindow({
    Title = "Fiat Hub",
    SubTitle = "by_fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(700, 500),
    Acrylic = true,
    Theme = "Dark", -- cinza escuro
    MinimizeKey = nil
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Player selecionado
local selectedPlayer = nil

-- Dropdown dinâmico de players
local function GetPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local Dropdown = Tabs.Main:AddDropdown("PlayersDropdown", {
    Title = "Selecionar Player",
    Values = GetPlayerNames(),
    Multi = false,
})

Dropdown:OnChanged(function(Value)
    selectedPlayer = Players:FindFirstChild(Value)
end)

Players.PlayerAdded:Connect(function(p)
    Dropdown:SetValues(GetPlayerNames())
end)
Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then
        selectedPlayer = nil
    end
    Dropdown:SetValues(GetPlayerNames())
end)

local function CheckPlayer()
    if not selectedPlayer or not selectedPlayer.Character then
        Fluent:Notify({
            Title = "Aviso",
            Content = "Nenhum player selecionado!",
            Duration = 3
        })
        return false
    end
    return true
end

-- Toggles
local toggleNames = {
    "fling ball", "fling sofá", "killsofa", "lag lanterna",
    "espectar player", "fling ônibus", "kill ônibus", "fling barco", "kill canoa"
}

for _, name in ipairs(toggleNames) do
    local tgl = Tabs.Main:AddToggle(name, { Title = name, Default = false })
    tgl:OnChanged(function(Value)
        if not CheckPlayer() then
            tgl:SetValue(false)
            return
        end
        if name == "espectar player" then
            if Value then
                task.spawn(function()
                    while tgl.Value and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") do
                        Camera.CameraSubject = selectedPlayer.Character:FindFirstChild("Head")
                        task.wait(0.1)
                    end
                    Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                end)
            else
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            end
        else
            if Value then
                Fluent:Notify({
                    Title = "Action",
                    Content = name.." ativado para "..selectedPlayer.Name,
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "Action",
                    Content = name.." desativado",
                    Duration = 2
                })
            end
        end
    end)
end

-- Botão Black Role
Tabs.Main:AddButton({
    Title = "Black Role",
    Description = "Executa código remoto",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))("More Scripts: t.me/arceusxscripts")
    end
})

-- Botão Brookhaven Audio
Tabs.Main:AddButton({
    Title = "Brookhaven Audio",
    Description = "Executa script de áudio",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio"))()
    end
})

-- Bola preta "F" (simula Ctrl)
do
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "FiatHubBall"

    local ball = Instance.new("TextButton", gui)
    ball.Size = UDim2.new(0, 70, 0, 70)
    ball.Position = UDim2.new(0.05, 0, 0.5, 0)
    ball.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ball.Text = "F"
    ball.TextColor3 = Color3.fromRGB(255,255,255)
    ball.TextScaled = true
    ball.Font = Enum.Font.GothamBold
    ball.Active = true
    ball.BorderSizePixel = 0
    ball.AutoButtonColor = false
    ball.Draggable = true

    -- Color animation
    task.spawn(function()
        local t = 0
        while ball.Parent do
            t += 0.05
            ball.BackgroundColor3 = Color3.fromHSV((tick()%5)/5, 0.8, 0.9)
            task.wait(0.05)
        end
    end)

    -- Clique simula Ctrl
    ball.MouseButton1Click:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        if vim then
            vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
        end
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

Window:SelectTab(1)
Fluent:Notify({
    Title = "Fiat Hub",
    Content = "Interface carregada com sucesso.",
    Duration = 5
})
SaveManager:LoadAutoloadConfig()
