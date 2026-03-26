-- Blade Ball Auto Parry for Xeno Executor
-- NO VISUAL, pure auto parry

_G.autoParry = true
_G.parryKey = "F"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cari remote parry (biar lebih akurat)
local parryRemote
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:lower():find("parry") or v.Name:lower():find("block")) then
        parryRemote = v
        break
    end
end

-- Auto parry function
local function doParry()
    if parryRemote then
        parryRemote:FireServer()
    else
        -- Fallback ke virtual key
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[_G.parryKey], false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[_G.parryKey], false, game)
    end
end

-- Main loop
RunService.Heartbeat:Connect(function()
    if not _G.autoParry then return end
    if not LocalPlayer.Character then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "Ball" or v.Name:find("Ball")) then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and v.Position then
                local dist = (v.Position - hrp.Position).Magnitude
                if dist < 35 then
                    doParry()
                end
            end
        end
    end
end)

print("Xeno Auto Parry ACTIVE - Tekan F otomatis")
print("Matikan dengan: _G.autoParry = false")
