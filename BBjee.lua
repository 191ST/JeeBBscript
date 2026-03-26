-- Blade Ball Auto Parry Keyless
-- Visual lingkaran merah telah dihilangkan

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

local function checkDistanceToBall()
    local ball = findBall()
    if ball and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance < 30 then
            parry()
        end
    end
end

-- Auto Parry Loop
RunService.Heartbeat:Connect(function()
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

OrionLib:Init()

print "work"
