-- FIAT HUB UI COMPLETA
-- Corrigido para TODOS os botões aparecerem
-- Inclui: parar tudo, teleporttool, anti-lag, anti-colisão, anti-sit, etc.

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variáveis globais
local ativo = {}
local funcoesAtivas = {}

-- Função de desligar todas as funções
local function pararTudo()
	for nome, conn in pairs(funcoesAtivas) do
		if typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		elseif typeof(conn) == "Instance" and conn:IsA("Tool") then
			conn:Destroy()
		end
	end
	funcoesAtivas = {}
	ativo = {}
end

-- Criar UI principal
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "FiatHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Navegação
local NavBar = Instance.new("Frame", MainFrame)
NavBar.Size = UDim2.new(1, 0, 0, 40)
NavBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", NavBar)

-- Conteúdo rolável
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -10, 1, -50)
Content.Position = UDim2.new(0, 5, 0, 45)
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
Content.ScrollBarThickness = 6
Content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0, 6)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Criar abas
local abas = {
	["🏠"] = {
		"Spect Player", "TeleportTool", "Kill Ônibus", "Kill Sofá",
		"Fling Ônibus", "Fling Sofá", "Speed 130"
	},
	["⚙️"] = {
		"UI Colorida", "Parar Tudo"
	},
	["😈"] = {
		"Kill Ônibus", "Kill Sofá"
	},
	["💥"] = {
		"Fling Ônibus", "Fling Sofá"
	},
	["⏱️"] = {
		"Speed 130", "TeleportTool"
	},
	["🌟"] = {
		"Anti Lag", "Anti Colisão", "Anti Sit"
	},
	["🤯"] = {
		"Lag", "Lanterna", "Super Mega Lag"
	}
}

-- Criar botões de navegação
local function criarBotaoNav(emoji, conteudo)
	local btn = Instance.new("TextButton", NavBar)
	btn.Size = UDim2.new(0, 40, 1, 0)
	btn.Text = emoji
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		for _, child in ipairs(Content:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		for _, nome in ipairs(conteudo) do
			local b = Instance.new("TextButton", Content)
			b.Size = UDim2.new(0.9, 0, 0, 40)
			b.Text = nome
			b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			Instance.new("UICorner", b)

			b.MouseButton1Click:Connect(function()
				if nome == "Parar Tudo" then
					pararTudo()
				elseif nome == "TeleportTool" then
					if ativo[nome] then
						pararTudo()
						ativo[nome] = false
					else
						local tool = Instance.new("Tool")
						tool.RequiresHandle = false
						tool.Name = "TeleportTool"
						tool.Parent = LocalPlayer.Backpack
						tool.Activated:Connect(function()
							local pos = Mouse.Hit.p
							LocalPlayer.Character:MoveTo(pos)
						end)
						funcoesAtivas[nome] = tool
						ativo[nome] = true
					end
				elseif nome == "Anti Lag" then
					if ativo[nome] then
						pararTudo()
						ativo[nome] = false
					else
						funcoesAtivas[nome] = RunService.Stepped:Connect(function()
							for _, l in ipairs(workspace:GetDescendants()) do
								if l:IsA("PointLight") or l:IsA("SpotLight") or l:IsA("SurfaceLight") then
									l:Destroy()
								end
							end
						end)
						ativo[nome] = true
					end
				elseif nome == "Anti Colisão" then
					if ativo[nome] then
						pararTudo()
						ativo[nome] = false
					else
						funcoesAtivas[nome] = RunService.Stepped:Connect(function()
							for _, obj in ipairs(workspace:GetDescendants()) do
								if obj:IsA("BasePart") then
									obj.CanCollide = false
								end
							end
						end)
						ativo[nome] = true
					end
				elseif nome == "Anti Sit" then
					if ativo[nome] then
						pararTudo()
						ativo[nome] = false
					else
						funcoesAtivas[nome] = RunService.Stepped:Connect(function()
							if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
								LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
							end
						end)
						ativo[nome] = true
					end
				elseif nome == "Speed 130" then
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
						LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 130
					end
				end
			end)
		end
	end)
end

-- Criar botões de todas as abas
local posX = 0
for emoji, conteudo in pairs(abas) do
	criarBotaoNav(emoji, conteudo)
end

-- Atalhos
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Minus then
		MainFrame.Visible = false
	elseif input.KeyCode == Enum.KeyCode.K then
		MainFrame.Visible = true
	end
end)
