--// Loader.lua - SuttannHub
--// Fitur: Intro GUI + Key System + Auto Save + 1 Key per Device

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- File simpan key
local keyFile = "SuttannHubKey.txt"

-- HWID unik (per device)
local HWID = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Ambil daftar key dari Pastebin (ubah link sesuai punyamu)
local ValidKeyData = game:HttpGet("https://pastebin.com/raw/a74Lfr6w")

-- Fungsi cek key
local function CheckKey(inputKey)
    for key in string.gmatch(ValidKeyData, "[^\r\n]+") do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- Simpan key
local function SaveKey(k)
    if writefile then
        writefile(keyFile, k .. "||" .. HWID)
    end
end

-- Load key tersimpan
local function LoadKey()
    if isfile and isfile(keyFile) then
        local data = readfile(keyFile)
        local savedKey, savedHWID = unpack(string.split(data, "||"))
        if savedKey and savedHWID and savedHWID == HWID then
            return savedKey
        end
    end
    return nil
end

-- Kalau sudah ada key valid → langsung load script utama
local savedKey = LoadKey()
if savedKey and CheckKey(savedKey) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
    return
end

--// GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- INTRO FRAME
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
IntroFrame.BackgroundTransparency = 1

local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.AnchorPoint = Vector2.new(0.5,0.5)
IntroText.Position = UDim2.new(0.5,0,0.5,0)
IntroText.Size = UDim2.new(0,400,0,50)
IntroText.Text = "🌌 Welcome to SuttannHub 🌌"
IntroText.TextColor3 = Color3.fromRGB(255,255,255)
IntroText.TextScaled = true
IntroText.Font = Enum.Font.GothamBold
IntroText.BackgroundTransparency = 1

-- Tween fade in + fade out
local TweenService = game:GetService("TweenService")
TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 0}):Play()
wait(2.5)
TweenService:Create(IntroFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1}):Play()
wait(1)
IntroFrame:Destroy()

-- KEY GUI
local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 340, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,10)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔑 Enter your Key"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.Size = UDim2.new(0.8, 0, 0.2, 0)
KeyBox.PlaceholderText = "Masukkan Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local SubmitButton = Instance.new("TextButton", Frame)
SubmitButton.Position = UDim2.new(0.3, 0, 0.65, 0)
SubmitButton.Size = UDim2.new(0.4, 0, 0.2, 0)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 18
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local UICornerBtn = Instance.new("UICorner", SubmitButton)

local Notif = Instance.new("TextLabel", Frame)
Notif.Size = UDim2.new(1, 0, 0, 30)
Notif.Position = UDim2.new(0, 0, 0.85, 0)
Notif.Text = ""
Notif.TextColor3 = Color3.fromRGB(255, 80, 80)
Notif.BackgroundTransparency = 1
Notif.Font = Enum.Font.Gotham
Notif.TextSize = 16

-- Event submit
SubmitButton.MouseButton1Click:Connect(function()
    local InputKey = KeyBox.Text
    if CheckKey(InputKey) then
        SaveKey(InputKey)
        Notif.Text = "✅ Key benar & tersimpan!"
        Notif.TextColor3 = Color3.fromRGB(80, 255, 80)
        wait(1)
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
    else
        Notif.Text = "❌ Key salah!"
        Notif.TextColor3 = Color3.fromRGB(255, 80, 80)
        wait(1.5)
        LocalPlayer:Kick("Key salah!")
    end
end)
