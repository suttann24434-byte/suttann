--// Loader.lua - SuttannHub vStable
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- File simpan key/HWID
local keyFile = "SuttannHubKey.txt"

-- HWID unik
local HWID = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Ambil daftar key dari Pastebin
local success, ValidKeyData = pcall(function()
    return game:HttpGet("https://pastebin.com/raw/c7DnMX7z")
end)
if not success then
    warn("⚠️ Gagal ambil key data dari Pastebin!")
    ValidKeyData = ""
end

-- Sistem HWID tersimpan
local function LoadValidHWIDs()
    local hwids = {}
    if isfile and isfile(keyFile) then
        for _, line in pairs(string.split(readfile(keyFile), "\n")) do
            hwids[line] = true
        end
    end
    return hwids
end

local function SaveHWID(hwid)
    local hwids = LoadValidHWIDs()
    if not hwids[hwid] and writefile then
        local data = ""
        for k in pairs(hwids) do
            data = data .. k .. "\n"
        end
        data = data .. hwid .. "\n"
        writefile(keyFile, data)
    end
end

-- Cek akses key dan HWID
local function CheckKey(inputKey)
    for line in string.gmatch(ValidKeyData, "[^\r\n]+") do
        local key, usedHWID = string.match(line, "(%S+)|?(%S*)")
        if inputKey == key then
            if usedHWID == "" or usedHWID == HWID then
                return true
            else
                return false, "❌ Key sudah digunakan di device lain! Hubungi admin untuk meminta key baru."
            end
        end
    end
    return false, "❌ Key tidak valid atau sudah dihapus! Hubungi admin untuk meminta key baru."
end

local function HasAccess()
    local hwids = LoadValidHWIDs()
    return hwids[HWID] or false
end

-- Fungsi jalankan script utama
local function RunMainScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
end

-- GUI Intro
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
IntroFrame.BackgroundTransparency = 1

local Glow = Instance.new("ImageLabel", IntroFrame)
Glow.AnchorPoint = Vector2.new(0.5,0.5)
Glow.Position = UDim2.new(0.5,0,0.5,0)
Glow.Size = UDim2.new(0,600,0,600)
Glow.Image = "rbxassetid://5028857472"
Glow.ImageColor3 = Color3.fromRGB(0, 170, 255)
Glow.ImageTransparency = 0.6
Glow.BackgroundTransparency = 1

local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.AnchorPoint = Vector2.new(0.5,0.5)
IntroText.Position = UDim2.new(0.5,0,0.5,0)
IntroText.Size = UDim2.new(0,500,0,60)
IntroText.Text = "🌌 SuttannHub 🌌"
IntroText.TextColor3 = Color3.fromRGB(255,255,255)
IntroText.TextTransparency = 1
IntroText.TextScaled = true
IntroText.Font = Enum.Font.GothamBold
IntroText.BackgroundTransparency = 1

local Ambient = Instance.new("Sound", IntroFrame)
Ambient.SoundId = "rbxassetid://5410086212"
Ambient.Volume = 0.6
Ambient.Looped = true
Ambient:Play()

local Whoosh = Instance.new("Sound", IntroFrame)
Whoosh.SoundId = "rbxassetid://9127401354"
Whoosh.Volume = 1

TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()

task.spawn(function()
    while Glow.Parent do
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,700,0,700), ImageTransparency=0.3}):Play()
        task.wait(2)
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,600,0,600), ImageTransparency=0.6}):Play()
        task.wait(2)
    end
end)

wait(4.5)
Ambient:Stop()
Whoosh:Play()
TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency=1}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency=1}):Play()
TweenService:Create(Glow, TweenInfo.new(1.5), {ImageTransparency=1}):Play()
wait(1.6)
IntroFrame:Destroy()

-- FPS Boost Button
local FPSButton = Instance.new("TextButton", ScreenGui)
FPSButton.Position = UDim2.new(0.85,0,0.02,0)
FPSButton.Size = UDim2.new(0,90,0,30)
FPSButton.Text = "FPS Boost OFF"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 14
FPSButton.TextColor3 = Color3.fromRGB(255,255,255)
FPSButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
FPSButton.Visible = false
Instance.new("UICorner", FPSButton)

local FPSBoostEnabled = false
local function ApplyFPSBoost()
    local ToDisable = {
        Textures = true,
        VisualEffects = true,
        Parts = true,
        Particles = true,
        Sky = true
    }
    for _, v in next, game:GetDescendants() do
        if ToDisable.Parts and (v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart")) then
            v.Material = Enum.Material.SmoothPlastic
        end
        if ToDisable.Particles and (v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire")) then
            v.Enabled = false
        end
        if ToDisable.VisualEffects and (v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")) then
            v.Enabled = false
        end
        if ToDisable.Textures and (v:IsA("Decal") or v:IsA("Texture")) then
            v.Texture = ""
        end
        if ToDisable.Sky and v:IsA("Sky") then
            v.Parent = nil
        end
    end
end

FPSButton.MouseButton1Click:Connect(function()
    FPSBoostEnabled = not FPSBoostEnabled
    if FPSBoostEnabled then
        FPSButton.Text = "FPS Boost ON"
        ApplyFPSBoost()
    else
        FPSButton.Text = "FPS Boost OFF"
    end
end)

-- Jika HWID sudah tersimpan, langsung jalankan script utama
if HasAccess() then
    RunMainScript()
    FPSButton.Visible = true
    return
end

-- Key GUI
local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.Size = UDim2.new(0,340,0,250)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", Frame)
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0,200,255)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔑 Enter your Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.Size = UDim2.new(0.8,0,0.15,0)
KeyBox.PlaceholderText = "Masukkan Key..."
KeyBox.TextColor3 = Color3.fromRGB(0,0,0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)

local SubmitButton = Instance.new("TextButton", Frame)
SubmitButton.Position = UDim2.new(0.3,0,0.65,0)
SubmitButton.Size = UDim2.new(0.4,0,0.15,0)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 18
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", SubmitButton)

local Notif = Instance.new("TextLabel", Frame)
Notif.Size = UDim2.new(1,0,0,30)
Notif.Position = UDim2.new(0,0,0.85,0)
Notif.TextColor3 = Color3.fromRGB(255,80,80)
Notif.BackgroundTransparency = 1
Notif.Font = Enum.Font.Gotham
Notif.TextSize = 16

SubmitButton.MouseButton1Click:Connect(function()
    local inputKey = KeyBox.Text
    local success, message = CheckKey(inputKey)
    if success then
        SaveHWID(HWID)
        Notif.Text = "✅ Key benar & tersimpan!"
        Notif.TextColor3 = Color3.fromRGB(80,255,80)
        task.wait(1)
        Frame:Destroy()
        RunMainScript()
        FPSButton.Visible = true
    else
        Notif.Text = message
        Notif.TextColor3 = Color3.fromRGB(255,80,80)
        task.wait(2)
    end
end)
