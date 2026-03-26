-- Blade Ball Auto Parry + Visual Circle MERAH
-- 100% WORK

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local run = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")

-- Drawing Circle
local circle = Drawing.new("Circle")
circle.Radius = 60
circle.Thickness = 2
circle.Filled = false
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Visible = false
circle.Transparency = 0.5
circle.NumSides = 64

-- Variables
local autoParry = false
local parryKey = Enum.KeyCode.F

-- Find Ball
local function getBall()
    for i,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Ball" and v:IsA("BasePart") then
            return v
        end
    end
    return nil
end

-- Auto Parry
local function doParry()
    vim:SendKeyEvent(true, parryKey, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, parryKey, false, game)
end

-- Update Circle
run.RenderStepped:Connect(function()
    local ball = getBall()
    if ball and autoParry then
        local pos, onScreen = cam:WorldToViewportPoint(ball.Position)
        if onScreen then
            circle.Position = Vector2.new(pos.X, pos.Y)
            circle.Visible = true
            
            local dist = (ball.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 35 then
                doParry()
                circle.Color = Color3.fromRGB(255, 50, 50)
                circle.Thickness = 3
            else
                circle.Color = Color3.fromRGB(255, 0, 0)
                circle.Thickness = 2
            end
        else
            circle.Visible = false
        end
    else
        circle.Visible = false
    end
end)

-- UI
local win = OrionLib:MakeWindow({Name = "Blade Ball", HidePremium = true})
local tab = win:MakeTab({Name = "Auto Parry"})

tab:AddToggle({
    Name = "Auto Parry + Visual Circle Merah",
    Default = false,
    Callback = function(val)
        autoParry = val
        if not val then circle.Visible = false end
    end
})

tab:AddSlider({
    Name = "Circle Radius",
    Min = 30,
    Max = 120,
    Default = 60,
    Callback = function(val)
        circle.Radius = val
    end
})

OrionLib:Init()
