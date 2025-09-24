-- Criar quadrado azul
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local square = Instance.new("Part") -- cria um novo Part
square.Size = Vector3.new(5,5,5) -- tamanho do quadrado
square.Color = Color3.fromRGB(0, 0, 255) -- azul
square.Anchored = true -- fica parado
square.Position = character.Head.Position + Vector3.new(0,5,0) -- acima da cabeça
square.Parent = workspace
