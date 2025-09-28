--// FIAT HUB UI Completa
-- Cola direto no executor

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variáveis globais de funções
local FuncoesAtivas = {
	AntiLag = false,
	AntiColisao = false,
	AntiSit = false,
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FIAT HUB"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Animação FIAT HUB arco-íris
task.spawn(function()
	local cores = {
		Color3.fromRGB(255,0,0),
		Color3.fromRGB(0,255,0),
		Color3.fromRGB(0,0,255),
		Color3.fromRGB(255,255,0),
		Color3.fromRGB(255,0,255),
		Color3.fromRGB(0,255,255)
	}
	local i = 1
	while task.wait(1) do
		local tween = TweenService:Create(Title, TweenInfo.new(1), {TextColor3 = cores[i]})
		tween:Play()
		i = i + 1
		if i > #cores then i = 1 end
	end
end)

-- Frames
local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0, 50, 1, -40)
IconFrame.Position = UDim2.new(0, 0, 0, 40)
IconFrame.BackgroundTransparency = 1
IconFrame.Parent = MainFrame

local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -60, 1, -50)
ButtonFrame.Position = UDim2.new(0, 60, 0, 50)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

-- Criar botão
local function CriarBotao(pai, texto, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 40)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.Text = texto
	b.Parent = pai
	b.MouseButton1Click:Connect(callback)
	return b
end

-- Limpar botões
local function LimparBotoes()
	for _,v in pairs(ButtonFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

-- Criar ícone
local function CriarIcone(texto, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Text = texto
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = IconFrame
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Aba Casa
CriarIcone("🏠", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Selecionar Player", function()
		print("Selecionar Player")
	end)
	CriarBotao(ButtonFrame,"Espectar Player", function()
		print("Spectar Player")
	end)
	CriarBotao(ButtonFrame,"Kill Ônibus", function() print("Kill ônibus") end)
	CriarBotao(ButtonFrame,"Kill Sofá", function() print("Kill sofá") end)
	CriarBotao(ButtonFrame,"Fling Ônibus", function() print("Fling ônibus") end)
	CriarBotao(ButtonFrame,"Fling Sofá", function() print("Fling sofá") end)
	CriarBotao(ButtonFrame,"Speed", function()
		LocalPlayer.Character.Humanoid.WalkSpeed = 130
	end)
	CriarBotao(ButtonFrame,"Teleport Tool", function()
		local tool = Instance.new("Tool")
		tool.RequiresHandle = false
		tool.Name = "TeleportTool"
		tool.Activated:Connect(function()
			local pos = Mouse.Hit.p
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character:MoveTo(pos)
			end
		end)
		tool.Parent = LocalPlayer.Backpack
	end)
end)

-- Aba Config (⚙️)
CriarIcone("⚙️", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"UI Colorida", function()
		MainFrame.BackgroundColor3 = Color3.fromRGB(math.random(50,255),math.random(50,255),math.random(50,255))
	end)
	CriarBotao(ButtonFrame,"Parar Tudo", function()
		for k,_ in pairs(FuncoesAtivas) do
			FuncoesAtivas[k] = false
		end
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
		print("Todas as funções foram paradas.")
	end)
end)

-- Aba 🌟 (Funções especiais)
CriarIcone("🌟", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Anti Lag", function()
		FuncoesAtivas.AntiLag = not FuncoesAtivas.AntiLag
		print("Anti Lag:", FuncoesAtivas.AntiLag)
	end)
	CriarBotao(ButtonFrame,"Anti Colisão", function()
		FuncoesAtivas.AntiColisao = not FuncoesAtivas.AntiColisao
		print("Anti Colisão:", FuncoesAtivas.AntiColisao)
	end)
	CriarBotao(ButtonFrame,"Anti Sit", function()
		FuncoesAtivas.AntiSit = not FuncoesAtivas.AntiSit
		print("Anti Sit:", FuncoesAtivas.AntiSit)
	end)
end)

-- Outras abas
CriarIcone("😈", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Kill Ônibus", function() print("Kill ônibus") end)
	CriarBotao(ButtonFrame,"Kill Sofá", function() print("Kill sofá") end)
end)

CriarIcone("💥", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Fling Ônibus", function() print("Fling ônibus") end)
	CriarBotao(ButtonFrame,"Fling Sofá", function() print("Fling sofá") end)
end)

CriarIcone("⏱️", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Speed", function() LocalPlayer.Character.Humanoid.WalkSpeed = 130 end)
	CriarBotao(ButtonFrame,"TeleportTool", function()
		local tool = Instance.new("Tool")
		tool.RequiresHandle = false
		tool.Name = "TeleportTool"
		tool.Activated:Connect(function()
			local pos = Mouse.Hit.p
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character:MoveTo(pos)
			end
		end)
		tool.Parent = LocalPlayer.Backpack
	end)
end)

CriarIcone("🤯", function()
	LimparBotoes()
	CriarBotao(ButtonFrame,"Lag Lanterna", function()
		print("Lag Lanterna")
	end)
	CriarBotao(ButtonFrame,"Super Mega Lag", function()
		print("Super Mega Lag")
	end)
end)

-- Loops das funções
RunService.Heartbeat:Connect(function()
	if FuncoesAtivas.AntiLag then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
				v:Destroy()
			end
		end
	end
	if FuncoesAtivas.AntiColisao and LocalPlayer.Character then
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
	if FuncoesAtivas.AntiSit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Sit = false
	end
end)

print("✅ FIAT HUB carregado com sucesso (versão completa)")
