--// FIAT HUB CINEMA FINAL - UI ANTIGA INTACTA COMPLETA
--// Fonte aplicada: 12187372175
--// Atualizações: Botão "Parar de Espectar", restrição de funções, correção UI Colorida, Aba 🤯 atualizada

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Variáveis globais
local SelectedPlayer = nil
local ActiveFunctions = {}

-- Criar ScreenGui
if LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("FiatHubUI") then
	LocalPlayer.PlayerGui.FiatHubUI:Destroy()
end

local FiatHubUI = Instance.new("ScreenGui")
FiatHubUI.Name = "FiatHubUI"
FiatHubUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
FiatHubUI.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 400)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = FiatHubUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "FIAT HUB"
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Parent = MainFrame

-- Fonte aplicada
task.spawn(function()
	for _,obj in ipairs(FiatHubUI:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			obj.FontFace = Font.new("rbxassetid://12187372175")
		end
	end
end)

-- Loop de cor no título
task.spawn(function()
	while task.wait(0.2) do
		Title.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
	end
end)

-- Min/Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-35,0,0)
CloseButton.Text = "X"
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseButton.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0,30,0,30)
MinimizeButton.Position = UDim2.new(1,-70,0,0)
MinimizeButton.Text = "-"
MinimizeButton.TextScaled = true
MinimizeButton.BackgroundColor3 = Color3.fromRGB(180,180,180)
MinimizeButton.Parent = MainFrame

MinimizeButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)
CloseButton.MouseButton1Click:Connect(function()
	FiatHubUI:Destroy()
end)
game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.K then
		MainFrame.Visible = true
	end
end)

-- Icon Frame
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
	btn.TextScaled = true
	btn.BackgroundTransparency = 1
	btn.Parent = IconFrame
	table.insert(IconButtons,btn)
end

-- Mid Scroll
local MidScroll = Instance.new("ScrollingFrame")
MidScroll.Size = UDim2.new(1,-70,1,-70)
MidScroll.Position = UDim2.new(0,60,0,60)
MidScroll.BackgroundTransparency = 1
MidScroll.ScrollBarThickness = 8
MidScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MidScroll.Parent = MainFrame

local MidUIList = Instance.new("UIListLayout")
MidUIList.Parent = MidScroll
MidUIList.SortOrder = Enum.SortOrder.LayoutOrder
MidUIList.Padding = UDim.new(0,5)

-- Funções auxiliares
local function LimparMidScroll()
	for _,v in pairs(MidScroll:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

local function CreateButton(name, callback, precisaPlayer)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,40)
	btn.Text = name
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
	btn.Parent = MidScroll

	local active = false
	btn.MouseButton1Click:Connect(function()
		if precisaPlayer and not SelectedPlayer then
			return -- precisa de player selecionado
		end
		active = not active
		if active then
			btn.BackgroundColor3 = Color3.fromRGB(100,200,100)
			ActiveFunctions[name] = callback
			callback()
		else
			btn.BackgroundColor3 = Color3.fromRGB(180,180,180)
			ActiveFunctions[name] = nil
		end
	end)
end

-- Player Frame
local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Size = UDim2.new(1,-70,0,120)
PlayerFrame.Position = UDim2.new(0,60,0,280)
PlayerFrame.BackgroundTransparency = 0.7
PlayerFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerFrame.CanvasSize = UDim2.new(0,0,0,0)
PlayerFrame.ScrollBarThickness = 6
PlayerFrame.Parent = MainFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerFrame
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0,5)

local function RefreshPlayerList()
	for _,v in pairs(PlayerFrame:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,-10,0,30)
			b.Text = plr.Name
			b.TextScaled = true
			b.BackgroundColor3 = Color3.fromRGB(150,150,150)
			b.Parent = PlayerFrame
			b.MouseButton1Click:Connect(function()
				SelectedPlayer = plr
			end)
		end
	end
end
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

-- Funções principais
local function EspiarPlayer()
	if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = SelectedPlayer.Character.Humanoid
	end
end
local function PararEspectar()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = LocalPlayer.Character.Humanoid
	end
end
local function CreateTeleportTool()
	local Tool = Instance.new("Tool")
	Tool.Name = "TeleportTool"
	Tool.RequiresHandle = false
	Tool.Parent = LocalPlayer.Backpack
	Tool.Activated:Connect(function()
		if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
		end
	end)
end

-- Icon Functions
local IconFunctions = {
	["🏠"] = function()
		LimparMidScroll()
		CreateButton("Selecionar Player",RefreshPlayerList,false)
		CreateButton("Espiar Player",EspiarPlayer,true)
		CreateButton("Parar de Espectar",PararEspectar,false)
	end,
	["⚙️"] = function()
		LimparMidScroll()
		CreateButton("UI Colorida",function()
			RunService:UnbindFromRenderStep("UIColorida")
			RunService:BindToRenderStep("UIColorida",300,function()
				MainFrame.BackgroundColor3 = Color3.fromHSV(tick()%5/5,1,1)
			end)
		end,false)
		CreateButton("Parar Tudo",function()
			ActiveFunctions = {}
			LimparMidScroll()
			PararEspectar()
		end,false)
	end,
	["😈"] = function()
		LimparMidScroll()
		CreateButton("Kill Ônibus",function() print("Kill Ônibus") end,true)
		CreateButton("Kill Sofa",function() print("Kill Sofa") end,true)
	end,
	["💥"] = function()
		LimparMidScroll()
		CreateButton("Fling Ônibus",function() print("Fling Ônibus") end,true)
		CreateButton("Fling Sofa",function() print("Fling Sofa") end,true)
	end,
	["⏱️"] = function()
		LimparMidScroll()
		CreateButton("Almentar Speed",function() LocalPlayer.Character.Humanoid.WalkSpeed = 130 end,true)
		CreateButton("Teleport Tool",CreateTeleportTool,false)
	end,
	["🌟"] = function()
		LimparMidScroll()
		CreateButton("Anti Lag",function()
			RunService:BindToRenderStep("AntiLag",300,function()
				for _,obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight") then
						obj:Destroy()
					end
				end
			end)
		end,false)
		CreateButton("Anti Colisão",function()
			RunService:BindToRenderStep("AntiCollide",301,function()
				for _,obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("BasePart") and obj.Name~="HumanoidRootPart" and obj.Parent~=LocalPlayer.Character then
						obj.CanCollide=false
					end
				end
			end)
		end,false)
		CreateButton("Anti Sit",function()
			LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
				if LocalPlayer.Character.Humanoid.Sit then
					LocalPlayer.Character.Humanoid.Sit=false
				end
			end)
		end,false)
	end,
	["🤯"] = function()
		LimparMidScroll()
		CreateButton("Lanterna⚠️",function()
			local tool = Instance.new("Tool")
			tool.RequiresHandle = false
			tool.Name = "Lanterna"
			tool.Parent = LocalPlayer.Backpack
		end,false)
		CreateButton("Céu Customizado⚠️",function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Shirt") then
				local shirt = LocalPlayer.Character:FindFirstChild("Shirt")
				local asset = shirt.ShirtTemplate
				local sky = Instance.new("Sky")
				sky.SkyboxBk = asset
				sky.SkyboxDn = asset
				sky.SkyboxFt = asset
				sky.SkyboxLf = asset
				sky.SkyboxRt = asset
				sky.SkyboxUp = asset
				sky.Parent = Lighting
			end
		end,false)
		CreateButton("100% Anti Lag",function()
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or obj:IsA("ParticleEmitter") then
					obj:Destroy()
				end
			end
		end,false)
	end
}

for _,btn in pairs(IconButtons) do
	btn.MouseButton1Click:Connect(function()
		IconFunctions[btn.Text]()
	end)
end

print("✅ FIAT HUB carregado com UI antiga intacta, fonte aplicada e todas as atualizações")
