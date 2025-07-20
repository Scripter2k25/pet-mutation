-- Cool Minimalist Pet Mutation Finder UI with ESP + OMG Hook
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetMutationFinderUI"
gui.ResetOnSpawn = false

-- Main UI Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 1
uiStroke.Color = Color3.fromRGB(80, 80, 100)
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🔬 Mutation Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Button Generator
local function createButton(text, yPos, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 28)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local rerollBtn = createButton("🎲 Reroll", 38, Color3.fromRGB(110, 180, 255))
local toggleBtn = createButton("👁 ESP Toggle", 72, Color3.fromRGB(150, 255, 170))

-- Credit Label
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 16)
credit.Position = UDim2.new(0, 0, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "made by redo + omg hub"
credit.TextColor3 = Color3.fromRGB(140, 140, 140)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11

-- Mutation pool
local mutations = { "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny", "Tranquil", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended" }
local current = mutations[math.random(#mutations)]
local espOn = true
local loadedExternal = false

-- Locate Mutation Machine
local function findMachine()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj:FindFirstChildWhichIsA("BasePart")
		end
	end
end

local part = findMachine()
if not part then
	warn("Mutation machine not found.")
	return
end

-- ESP Billboard Setup
local esp = Instance.new("BillboardGui", part)
esp.Adornee = part
esp.Size = UDim2.new(0, 200, 0, 40)
esp.StudsOffset = Vector3.new(0, 3, 0)
esp.AlwaysOnTop = true

local label = Instance.new("TextLabel", esp)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 20
label.TextStrokeTransparency = 0.4
label.TextStrokeColor3 = Color3.new(0, 0, 0)
label.Text = current

-- Rainbow Effect
local hue = 0
RunService.RenderStepped:Connect(function()
	if espOn then
		hue = (hue + 0.005) % 1
		label.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

-- Reroll Button Logic
rerollBtn.MouseButton1Click:Connect(function()
	rerollBtn.Text = "⏳ Rolling..."
	for i = 1, 20 do
		label.Text = mutations[math.random(#mutations)]
		wait(0.07)
	end
	current = mutations[math.random(#mutations)]
	label.Text = current
	rerollBtn.Text = "🎲 Reroll"
end)

-- Toggle ESP and Load OMG Hub
toggleBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	esp.Enabled = espOn
	if espOn and not loadedExternal then
		loadedExternal = true
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter2k25/OMG/refs/heads/main/omg-hub.lua"))()
		end)
		if not ok then
			warn("OMG Hub failed to load:", err)
		end
	end
end)
