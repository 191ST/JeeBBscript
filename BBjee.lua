-- Blade Ball Auto Parry Keyless
-- Full Script dengan Visual Lingkaran Merah

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Players = game:Players
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variables
local autoParry = false
local parryKey = Enum.KeyCode.F
local parryDelay = 0.1
local prediction = 0.05
local circleVisible = true

-- Drawing objects for visual circle
local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 64
circle.Radius = 50
circle.Filled = false
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Visible = false
circle.Transparency = 0.7
circle.ZIndex = 10

-- Functions
local function parry()
    if autoParry then
        task.wait(parryDelay)
        VirtualInputManager:SendKeyEvent(true, parryKey, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, parryKey, false, game)
    end
end

local function findBall()
    local ball = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Ball" and v:IsA("BasePart") then
            ball = v
            break
        end
    end
    return ball
end

local function updateVisualCircle(ball)
    if not circleVisible then
        circle.Visible = false
        return
    end
    
    if ball and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local vector, onScreen = camera:WorldToViewportPoint(ball.Position)
        if onScreen then
            circle.Position = Vector2.new(vector.X, vector.Y)
            circle.Visible = true
            local distance = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < 30 then
                circle.Color = Color3.fromRGB(255, 0, 0)
                circle.Thickness = 3
            else
                circle.Color = Color3.fromRGB(255, 100, 0)
                circle.Thickness = 2
            end
        else
            circle.Visible = false
        end
    else
        circle.Visible = false
    end
end

local function checkDistanceToBall()
    local ball = findBall()
    if ball and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance < 30 then
            parry()
        end
    end
    updateVisualCircle(ball)
end

-- Get camera
local camera = workspace.CurrentCamera

-- Auto Parry Loop
RunService.RenderStepped:Connect(function()
    if autoParry then
        checkDistanceToBall()
    end
end)

-- UI
local Window = OrionLib:MakeWindow({Name = "Blade Ball Auto Parry", HidePremium = false, SaveConfig = true, ConfigFolder = "BladeBall"})

local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
    Name = "Auto Parry",
    Default = false,
    Callback = function(value)
        autoParry = value
        if not value then
            circle.Visible = false
        end
    end
})

MainTab:AddToggle({
    Name = "Show Visual Circle (Merah)",
    Default = true,
    Callback = function(value)
        circleVisible = value
        if not value then
            circle.Visible = false
        end
    end
})

MainTab:AddSlider({
    Name = "Parry Delay (ms)",
    Min = 0,
    Max = 500,
    Default = 100,
    Callback = function(value)
        parryDelay = value / 1000
    end
})

MainTab:AddSlider({
    Name = "Prediction",
    Min = 0,
    Max = 0.2,
    Default = 0.05,
    Callback = function(value)
        prediction = value
    end
})

MainTab:AddSlider({
    Name = "Circle Radius",
    Min = 20,
    Max = 150,
    Default = 50,
    Callback = function(value)
        circle.Radius = value
    end
})

OrionLib:Init()
