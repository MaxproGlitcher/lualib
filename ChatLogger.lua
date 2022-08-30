if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Redux by Relidium <3
-- Whoever made this originally sucks ass at lua and also didn't update their script for 3+ years
-- So not only did I have to spend time looking for a chatlog function that worked but i also had
-- to redo half of the code for the GUI lmao you're welcome

-- "Farewell Infortality~"

-- Settings
local defaultInstanceColor = Color3.fromRGB(255,255,255)
local defaultBackgroundColor = Color3.fromRGB(30, 30, 30)
local disabledColor = Color3.fromRGB(255,0,0)
local enabledColor = Color3.fromRGB(0,255,0)

-- Variables

local ChatGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local LogPanel = Instance.new("ScrollingFrame")
local Close = Instance.new("TextButton")
local Mini = Instance.new("TextButton")
local Log = Instance.new("TextButton")
local Clear = Instance.new("TextButton")
local title = Instance.new("TextLabel")

local logging = true
local minimized = false
local prevOutputPos = 0
local ChatEvent = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents

-- GUI

ChatGui.Name = "ChatGui"
ChatGui.Parent = game.Players.LocalPlayer.PlayerGui
ChatGui.ResetOnSpawn = false

Frame.Parent = ChatGui
Frame.BackgroundColor3 = defaultBackgroundColor
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.new(0.3,0.3,0.3)
Frame.Position = UDim2.new(0.028, 0, 0.57, 0)
Frame.Size = UDim2.new(0, 392, 0, 25)
Frame.Active = true
Frame.Draggable = true

LogPanel.Name = "LogPanel"
LogPanel.Parent = Frame
LogPanel.BackgroundColor3 = defaultBackgroundColor
LogPanel.BorderColor3 = Color3.new(0.3,0.3,0.3)
LogPanel.Position = UDim2.new(-0.00022, 0, 0.968, 0)
LogPanel.Size = UDim2.new(0, 392, 0, 256)
LogPanel.ScrollBarThickness = 6
LogPanel.ScrollingEnabled = true
LogPanel.CanvasSize=UDim2.new(2,0,100,0)

Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = disabledColor
Close.BackgroundTransparency = 0.9
Close.Position = UDim2.new(0.95, 0, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 24)
Close.Font = Enum.Font.Jura
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 14

Mini.Name = "Mini"
Mini.Parent = Frame
Mini.BackgroundTransparency = 0.9
Mini.Position = UDim2.new(0.8985, 0, 0, 0)
Mini.Size = UDim2.new(0, 20, 0, 24)
Mini.Font = Enum.Font.Jura
Mini.Text = "-"
Mini.TextColor3 = Color3.new(1, 1, 1)
Mini.TextSize = 14

Log.Name = "Log"
Log.Parent = Frame
Log.BackgroundColor3 = enabledColor
Log.BackgroundTransparency = 0.9
Log.Position = UDim2.new(0.284-0.1, 0, 0, 0)
Log.Size = UDim2.new(0, 58, 0, 24)
Log.Font = Enum.Font.SourceSans
Log.Text = "Enabled"
Log.TextColor3 = Color3.new(1, 1, 1)
Log.TextSize = 14

Clear.Name = "Clear"
Clear.Parent = Frame
Clear.BackgroundTransparency = 0.9
Clear.Position = UDim2.new(0.437-0.1, 0, 0, 0)
Clear.Size = UDim2.new(0, 63, 0, 24)
Clear.Font = Enum.Font.SourceSans
Clear.Text = "Clear Logs"
Clear.TextColor3 = Color3.new(1, 1, 1)
Clear.TextSize = 14

title.Name = "title"
title.Parent = Frame
title.Position = UDim2.new(0.01, 0, 0, 0)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 115, 0, 24)
title.Font = Enum.Font.SourceSans
title.Text = "Chat Logs"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Connections

Log.MouseButton1Down:Connect(function()
	logging = not logging
	if logging then 
        Log.Text = "Enabled"
        Log.BackgroundColor3 = enabledColor
    else 
        Log.Text = "Disabled"
        Log.BackgroundColor3 = disabledColor
    end
end)

Mini.MouseButton1Down:Connect(function()
	if minimized then
		LogPanel:TweenSize(UDim2.new(0, 392, 0, 256), "InOut", "Sine", 0.5, false, nil)
	else
		LogPanel:TweenSize(UDim2.new(0, 392, 0, 0), "InOut", "Sine", 0.5, false, nil)
	end
	minimized = not minimized
end)

Close.MouseButton1Down:Connect(function()
	ChatGui:Destroy()
end)

Clear.MouseButton1Down:Connect(function()
	for i,v in pairs(LogPanel:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end
    prevOutputPos = 0
end)

-- Functions

local function output(plr, msg)
	if not logging then 
        return 
    end

 	local outputInstance = Instance.new("TextLabel", LogPanel)
 	outputInstance.Text = string.format("%s: %s", plr, msg or "")
 	outputInstance.Size = UDim2.new(2,0,0.006,0)
 	outputInstance.Position = UDim2.new(0,0,prevOutputPos,0)
 	outputInstance.Font = Enum.Font.SourceSansSemibold
 	outputInstance.TextColor3 = defaultInstanceColor
 	outputInstance.TextStrokeTransparency = 0
 	outputInstance.BackgroundTransparency = 0.92
 	outputInstance.BorderSizePixel = 0
 	outputInstance.FontSize = "Size14"
    outputInstance.TextXAlignment = Enum.TextXAlignment.Left
 	outputInstance.ClipsDescendants = true

	prevOutputPos = prevOutputPos + 0.006
end

-- Events

ChatEvent.OnMessageDoneFiltering.OnClientEvent:Connect(function(obj)
    output(obj.FromSpeaker, obj.Message)
 end)
