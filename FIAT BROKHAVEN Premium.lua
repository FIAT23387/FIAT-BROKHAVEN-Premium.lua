--// Fiat Hub Cinema Final - UI antiga intacta
--// Fonte aplicada: 12187372175
--// Atualização final: scroll em players, botão "-" vira 🚘, todas lógicas incluídas

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FiatHubUI"
gui.ResetOnSpawn = false

-- Fonte customizada
local customFont = Font.new("rbxassetid://12187372175")

-- Estado
local ActiveFunctions = {}
local SelectedPlayer = nil
local UIColoredLoop = nil

-- MainFrame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,20)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "FIAT HUB"
title.FontFace = customFont
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,0,0)

-- Loop cores no título
task.spawn(function()
    local cores = {
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(0,0,255),
        Color3.fromRGB(255,255,0),
        Color3.fromRGB(255,0,255),
        Color3.fromRGB(0,255,255)
    }
    local i=1
    while task.wait(0.5) do
        title.TextColor3 = cores[i]
        i=i+1
        if i>#cores then i=1 end
    end
end)

-- Minimizar
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-35,0,5)
minimizeBtn.Text = "-"
minimizeBtn.FontFace = customFont
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(180,180,180)

local carBtn = Instance.new("TextButton")
carBtn.Parent = gui
carBtn.Size = UDim2.new(0,50,0,50)
carBtn.Position = UDim2.new(0.1,0,0.1,0)
carBtn.Text = "🚘"
carBtn.Visible = false
carBtn.FontFace = customFont
carBtn.TextScaled = true
carBtn.BackgroundTransparency = 0.3
carBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
carBtn.Active = true
carBtn.Draggable = true

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    carBtn.Visible = true
end)
carBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    carBtn.Visible = false
end)

-- Icon Frame
local iconFrame = Instance.new("Frame", mainFrame)
iconFrame.Size = UDim2.new(0,50,1,0)
iconFrame.BackgroundTransparency = 1

local icons = {"🏠","⚙️","😈","💥","⏱️","🌟","🤯"}
local iconButtons = {}

for i,icon in ipairs(icons) do
    local btn = Instance.new("TextButton", iconFrame)
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,50*(i-1))
    btn.Text = icon
    btn.FontFace = customFont
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    table.insert(iconButtons, btn)
end

-- Mid Scroll
local midScroll = Instance.new("ScrollingFrame", mainFrame)
midScroll.Size = UDim2.new(1,-70,1,-70)
midScroll.Position = UDim2.new(0,60,0,60)
midScroll.BackgroundTransparency = 1
midScroll.ScrollBarThickness = 8
midScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local midList = Instance.new("UIListLayout", midScroll)
midList.SortOrder = Enum.SortOrder.LayoutOrder
midList.Padding = UDim.new(0,5)

local function clearMid()
    for _,v in pairs(midScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function createButton(name,callback,needsPlayer)
    local btn = Instance.new("TextButton", midScroll)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name
    btn.FontFace = customFont
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
    btn.MouseButton1Click:Connect(function()
        if needsPlayer and not SelectedPlayer then return end
        callback()
    end)
end

-- Player Frame (com scroll)
local playerFrame = Instance.new("ScrollingFrame", mainFrame)
playerFrame.Size = UDim2.new(1,-70,0,120)
playerFrame.Position = UDim2.new(0,60,0,280)
playerFrame.BackgroundTransparency = 0.3
playerFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
playerFrame.ScrollBarThickness = 6

local playerList = Instance.new("UIListLayout", playerFrame)
playerList.SortOrder = Enum.SortOrder.LayoutOrder
playerList.Padding = UDim.new(0,5)

local function refreshPlayers()
    for _,v in pairs(playerFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player then
            local b = Instance.new("TextButton", playerFrame)
            b.Size = UDim2.new(1,-10,0,30)
            b.Text = plr.Name
            b.FontFace = customFont
            b.TextScaled = true
            b.BackgroundColor3 = Color3.fromRGB(150,150,150)
            b.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
            end)
        end
    end
    playerFrame.CanvasSize = UDim2.new(0,0,0,playerList.AbsoluteContentSize.Y+10)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

------------------------------------------------
-- Funções
------------------------------------------------

local function stopAll()
    for name,fn in pairs(ActiveFunctions) do
        if fn.Stop then fn.Stop() end
    end
    ActiveFunctions = {}
    clearMid()
end

local function spectate()
    if not SelectedPlayer then return end
    RunService:BindToRenderStep("Spectate",301,function()
        if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = SelectedPlayer.Character.Humanoid
        end
    end)
end

local function stopSpectate()
    RunService:UnbindFromRenderStep("Spectate")
    workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChild("Humanoid")
end

local function teleportTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "TeleportTool"
    Tool.RequiresHandle = false
    Tool.Parent = player.Backpack
    Tool.Activated:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(player:GetMouse().Hit.Position+Vector3.new(0,3,0))
        end
    end)
end

local function uiColorLoop()
    if UIColoredLoop then
        UIColoredLoop:Disconnect()
        UIColoredLoop = nil
        mainFrame.BackgroundColor3 = Color3.fromRGB(230,230,230)
        return
    end
    UIColoredLoop = RunService.RenderStepped:Connect(function()
        mainFrame.BackgroundColor3 = Color3.fromHSV(tick()%5/5,1,1)
    end)
end

local function customSky()
    if not SelectedPlayer then return end
    local shirt = SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChildOfClass("Shirt")
    if shirt and shirt.ShirtTemplate then
        local sky = Instance.new("Sky")
        sky.SkyboxBk = shirt.ShirtTemplate
        sky.SkyboxDn = shirt.ShirtTemplate
        sky.SkyboxFt = shirt.ShirtTemplate
        sky.SkyboxLf = shirt.ShirtTemplate
        sky.SkyboxRt = shirt.ShirtTemplate
        sky.SkyboxUp = shirt.ShirtTemplate
        sky.Parent = Lighting
    end
end

local function antiLag()
    RunService:BindToRenderStep("AntiLag",300,function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
                obj:Destroy()
            end
        end
    end)
end

local function antiLagFull()
    RunService:BindToRenderStep("AntiLagFull",302,function()
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    end)
end

------------------------------------------------
-- Abas
------------------------------------------------

local tabs = {
    ["🏠"] = function()
        clearMid()
        createButton("Selecionar Player",refreshPlayers,false)
        createButton("Espectar Player",spectate,true)
        createButton("Parar de Espectar",stopSpectate,false)
    end,
    ["⚙️"] = function()
        clearMid()
        createButton("UI Colorida",uiColorLoop,false)
        createButton("Parar Tudo",stopAll,false)
    end,
    ["😈"] = function()
        clearMid()
        createButton("Kill Ônibus",function() print("Kill Ônibus") end,true)
        createButton("Kill Sofá",function() print("Kill Sofá") end,true)
    end,
    ["💥"] = function()
        clearMid()
        createButton("Fling Ônibus",function() print("Fling Ônibus") end,true)
        createButton("Fling Sofá",function() -- ControlSequenceServer_FixedUnequip.lua
-- Coloque em ServerScriptService
-- Corrigido: desequipa o Tool assim que teleporta para as coords longes (antes de girar)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local EVENT_NAME = "SelectedPlayerEvent"
local initialPos = CFrame.new(-84, 20, -131)
local farPos = CFrame.new(-917199, 8282828, 817181891)

-- Busca/Cria o RemoteEvent
local remote = ReplicatedStorage:FindFirstChild(EVENT_NAME)
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = EVENT_NAME
    remote.Parent = ReplicatedStorage
    warn("[ControlSequence] RemoteEvent criado automaticamente em ReplicatedStorage (nome: " .. EVENT_NAME .. ")")
end

-- Teleporta character de forma segura
local function safeTeleportCharacter(character, cf)
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cf
        return true
    end
    return false
end

-- Equipar primeiro Tool disponível (Character primeiro, depois Backpack)
local function equipFirstTool(humanoid, character)
    if not humanoid or not character then return nil end
    -- procura tool no Character
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Tool") then
            pcall(function() humanoid:EquipTool(v) end)
            return v
        end
    end
    -- procura no Backpack
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, v in pairs(backpack:GetChildren()) do
                if v:IsA("Tool") then
                    v.Parent = character
                    pcall(function() humanoid:EquipTool(v) end)
                    return v
                end
            end
        end
    end
    return nil
end

-- Desequipar (coloca o Tool no Backpack se possível)
local function unequipTool(tool, character)
    if not tool or not character then return end
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            -- tenta mover o tool para o Backpack (desequipando)
            pcall(function() tool.Parent = backpack end)
            return
        end
    end
    -- fallback: remove o tool com segurança
    pcall(function() tool.Parent = nil end)
end

-- Começa a orbitar em volta de um alvo; retorna função para parar
local function startOrbit(character, targetRoot, radius, speedRadiansPerSec)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetRoot then
        return function() end
    end

    local running = true
    local angle = 0
    coroutine.wrap(function()
        while running and hrp.Parent do
            local dt = RunService.Heartbeat:Wait()
            angle = angle + speedRadiansPerSec * dt
            local tx, ty, tz = targetRoot.Position.X, targetRoot.Position.Y, targetRoot.Position.Z
            local x = tx + math.cos(angle) * radius
            local z = tz + math.sin(angle) * radius
            local y = ty + 2
            local look = CFrame.new(Vector3.new(x,y,z), targetRoot.Position)
            hrp.CFrame = look
        end
    end)()

    return function() running = false end
end

-- Handler principal do RemoteEvent
remote.OnServerEvent:Connect(function(invoker, targetUserId)
    if not invoker or typeof(targetUserId) ~= "number" then return end

    local invChar = invoker.Character
    if not invChar then
        invoker:LoadCharacter()
        invChar = invoker.Character
        if not invChar then return end
    end

    -- Teleporta invocador para a posição inicial
    safeTeleportCharacter(invChar, initialPos)

    local humanoid = invChar:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Loop up/down enquanto espera sentar e ganhar tool
    local upDownRunning = true
    local upAngle = 0
    local hrp = invChar:FindFirstChild("HumanoidRootPart")
    local basePos = initialPos.Position
    local upDownCoroutine = coroutine.wrap(function()
        while upDownRunning and hrp and hrp.Parent do
            upAngle = upAngle + (math.pi * 1.5) * (RunService.Heartbeat:Wait())
            local yOffset = math.sin(upAngle) * 1.5
            hrp.CFrame = CFrame.new(basePos + Vector3.new(0, yOffset, 0))
            if humanoid.Sit then
                break
            end
        end
    end)
    upDownCoroutine()

    -- Espera até humanoid.Sit e que haja um Tool no inventário
    local foundTool = nil
    local maxWait = 60
    local t0 = tick()
    while tick() - t0 < maxWait do
        if humanoid.Sit then
            foundTool = equipFirstTool(humanoid, invChar)
            if foundTool then break end
        end
        task.wait(0.1)
    end

    upDownRunning = false

    if not foundTool then
        foundTool = equipFirstTool(humanoid, invChar)
    end

    -- Vai até o player selecionado e orbita até o selecionado sentar
    local targetPlayer = Players:GetPlayerByUserId(targetUserId)
    if not targetPlayer or not targetPlayer.Character then
        safeTeleportCharacter(invChar, initialPos)
        return
    end

    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        safeTeleportCharacter(invChar, initialPos)
        return
    end

    -- Posiciona perto do target e começa a orbitar
    local radius = 3
    if hrp then
        hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(radius, 2, 0), targetHRP.Position)
    end
    local stopOrbit = startOrbit(invChar, targetHRP, radius, math.rad(6)) -- velocidade ajustada

    -- Espera target sentar
    local waitStart = tick()
    local satTimeout = 120
    while tick() - waitStart < satTimeout do
        local tHum = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if tHum and tHum.Sit then break end
        task.wait(0.05)
    end

    -- Quando target senta: para orbitar e teleporta invocador para coords longes
    stopOrbit()
    safeTeleportCharacter(invChar, farPos)

    -- >>> CORREÇÃO AQUI: Desequipa IMEDIATAMENTE ao chegar nas coords longes (antes de girar)
    if foundTool and foundTool.Parent and foundTool.Parent:IsDescendantOf(invChar) then
        pcall(function() unequipTool(foundTool, invChar) end)
    end

    -- Agora girar rápido enquanto estiver longe (em si mesmo)
    local invHrp = invChar:FindFirstChild("HumanoidRootPart")
    local rapidStop = function() end
    if invHrp then
        rapidStop = startOrbit(invChar, invHrp, 1.5, math.rad(3600)) -- girando muito rápido
    end
    task.wait(1.0) -- duração do giro (ajuste se quiser)
    rapidStop()

    -- Retornar para coordenadas iniciais
    safeTeleportCharacter(invChar, initialPos)

    -- Tenta garantir estado neutro
    if humanoid then
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
    end

    print("[ControlSequence] Sequência finalizada para:", invoker.Name)
end)
				
    ["⏱️"] = function()
        clearMid()
        createButton("Almentar Speed",function() player.Character.Humanoid.WalkSpeed = 130 end,true)
        createButton("Teleport Tool",teleportTool,false)
    end,
    ["🌟"] = function()
        clearMid()
        createButton("Anti Lag",antiLag,false)-- Script: AutoRemoveNewLights.lua
-- Cria uma proteção para eliminar apenas luzes novas
-- sem afetar as que já existiam no início do jogo.

local Workspace = game:GetService("Workspace")

-- Tipos de luz que vamos monitorar
local LightTypes = {
    "PointLight",
    "SpotLight",
    "SurfaceLight"
}

-- Guarda todas as luzes que já existiam no início
local existingLights = {}

for _, obj in pairs(Workspace:GetDescendants()) do
    if table.find(LightTypes, obj.ClassName) then
        existingLights[obj] = true
    end
end

-- Função que apaga luzes novas
local function checkNewLight(obj)
    if table.find(LightTypes, obj.ClassName) then
        if not existingLights[obj] then
            -- Nova luz detectada → destrói imediatamente
            obj:Destroy()
        end
    end
end

-- Detecta quando algo novo for adicionado no jogo
Workspace.DescendantAdded:Connect(checkNewLight)

print("[Proteção de Luz] Ativa: luzes antigas preservadas, novas serão removidas.")
        
        createButton("Anti Colisão",function()
        -- Script: SmartNoCollisionOnNewParts.lua
-- Faz o jogador ter colisão normal com o mapa original
-- mas ignorar tudo que for gerado novo no workspace

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Lista de partes originais do mapa (com colisão permitida)
local originalParts = {}

-- Armazena todas as partes existentes no começo
for _, obj in pairs(Workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		originalParts[obj] = true
	end
end

-- Função que aplica sem colisão entre personagem e uma nova parte
local function disableCollisionForCharacterWithPart(character, part)
	for _, charPart in pairs(character:GetDescendants()) do
		if charPart:IsA("BasePart") then
			charPart.CanCollide = true
			if not originalParts[part] then
				-- Desativa colisão apenas com objetos novos
				pcall(function()
					charPart.CollisionGroup = "NoCollisionGroup"
				end)
			end
		end
	end
end

-- Cria o grupo de colisão para ignorar os objetos novos
local PhysicsService = game:GetService("PhysicsService")

if not pcall(function() PhysicsService:GetCollisionGroupId("NoCollisionGroup") end) then
	PhysicsService:CreateCollisionGroup("NoCollisionGroup")
end

-- Garante que o grupo não colida com o próprio personagem
PhysicsService:CollisionGroupSetCollidable("NoCollisionGroup", "Default", false)

-- Detecta novos objetos no mapa
Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and not originalParts[obj] then
		-- Marca como novo objeto
		originalParts[obj] = false
		-- Faz todos os personagens ignorarem essa parte
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				disableCollisionForCharacterWithPart(player.Character, obj)
			end
		end
	end
end)

-- Garante que novos jogadores também sigam a regra
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Espera um pouco o personagem carregar
		task.wait(1)
		for _, part in pairs(Workspace:GetDescendants()) do
			if part:IsA("BasePart") and not originalParts[part] then
				disableCollisionForCharacterWithPart(character, part)
			end
		end
	end)
end)

print("[Sistema de Colisão Inteligente] Ativo: mapa original colidível, novos objetos ignorados.")
            end)
        createButton("Anti Sit",function()
            -- Script: PreventSit.lua
-- Colocar em ServerScriptService

local Players = game:GetService("Players")

local function preventHumanoidSitting(humanoid)
    if not humanoid then return end

    -- Se já estiver sentado tentamos levantar
    if humanoid.Sit then
        humanoid.Sit = false
        humanoid.Jump = true
        humanoid.PlatformStand = false
    end

    -- Conectar mudança da propriedade Sit
    humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if humanoid.Sit then
            -- forçar ficar em pé
            humanoid.Sit = false
            humanoid.Jump = true
            humanoid.PlatformStand = false
        end
    end)
end

local function onCharacterAdded(character)
    -- espera humanoid aparecer
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        preventHumanoidSitting(humanoid)
    else
        character.ChildAdded:Connect(function(child)
            if child:IsA("Humanoid") then
                preventHumanoidSitting(child)
            end
        end)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    -- se já tiver personagem carregado no momento
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
-- para jogadores já conectados (útil no Play Solo/testes)
for _, plr in pairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
                end
                
    ["⚠️"] = function()
        clearMid()
        createButton("fling ball em beta⚠️",customSky,true)
        createButton("fling power 100% ⚠️",antiLagFull,false)
    end
}

for _,btn in pairs(iconButtons) do
    btn.MouseButton1Click:Connect(function()
        tabs[btn.Text]()
    end)
end

print("✅ FIAT HUB carregado com sucesso!")
