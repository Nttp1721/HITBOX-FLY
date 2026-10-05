local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getPositionText()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return "Không tìm thấy nhân vật"
    end

    local p = hrp.Position

    return string.format(
        "X: %.3f\nY: %.3f\nZ: %.3f\n\nVector3.new(%.3f, %.3f, %.3f)",
        p.X, p.Y, p.Z,
        p.X, p.Y, p.Z
    )
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CoordinateViewer"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 210)
frame.Position = UDim2.fromScale(0.5, 0.2)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.05
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "📍 TỌA ĐỘ HIỆN TẠI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Tọa độ
local coordinateLabel = Instance.new("TextLabel")
coordinateLabel.Size = UDim2.new(1, -30, 0, 105)
coordinateLabel.Position = UDim2.fromOffset(15, 48)
coordinateLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
coordinateLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
coordinateLabel.TextSize = 16
coordinateLabel.Font = Enum.Font.Code
coordinateLabel.TextXAlignment = Enum.TextXAlignment.Left
coordinateLabel.TextYAlignment = Enum.TextYAlignment.Top
coordinateLabel.Text = getPositionText()
coordinateLabel.Parent = frame

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = coordinateLabel

-- Hàm tạo nút
local function createButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(110, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = button

    return button
end

-- 3 nút nằm riêng phía dưới
local copyButton = createButton(
    "📋 COPY",
    UDim2.fromOffset(15, 165)
)

local refreshButton = createButton(
    "🔄 REFRESH",
    UDim2.fromOffset(155, 165)
)

local resetButton = createButton(
    "✖ RESET",
    UDim2.fromOffset(295, 165)
)

-- COPY
copyButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hrp then
        return
    end

    local p = hrp.Position

    local text = string.format(
        "Vector3.new(%.3f, %.3f, %.3f)",
        p.X, p.Y, p.Z
    )

    -- Executor thường hỗ trợ setclipboard
    if typeof(setclipboard) == "function" then
        setclipboard(text)

        local old = copyButton.Text
        copyButton.Text = "✅ COPIED"

        task.delay(1, function()
            if copyButton and copyButton.Parent then
                copyButton.Text = old
            end
        end)
    else
        copyButton.Text = "❌ NO CLIPBOARD"

        task.delay(1.5, function()
            if copyButton and copyButton.Parent then
                copyButton.Text = "📋 COPY"
            end
        end)
    end
end)

-- REFRESH
refreshButton.MouseButton1Click:Connect(function()
    coordinateLabel.Text = getPositionText()
end)

-- RESET / XÓA GUI
resetButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
