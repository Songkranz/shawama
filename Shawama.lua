--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Player
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--// Remote
local UseBoost = ReplicatedStorage:WaitForChild("UseBoost")

--// Part
local ShawermaProx = workspace.Kit.shawerma.D2:FindFirstChild("ProximityPrompt")
local GargeProx = workspace.Kit.Garge.Button:FindFirstChild("ProximityPrompt")
local PopcanProx = workspace.Kit.popcan:FindFirstChild("ProximityPrompt")
local Union = workspace.Buld.Folder:FindFirstChild("Union")

--// UI elements
local selectedBoost
local slideCustomSpeedCT
local activeCustomerSpeed

--// Functions
local function GetCurrentCustomer()
  local closestName
  local closestDistance = math.huge

  for _, m in pairs(workspace.Hum:GetChildren()) do
    if m:IsA("Model") then
      if m.Name:match("^Man") or m.Name:match("^Anom") then
        local man1 = m:FindFirstChild("Man1")
        if man1 then
          local hrp = man1:FindFirstChild("HumanoidRootPart")
          if hrp then
            local distance = (hrp.Position - Union.Position).Magnitude
            if distance < closestDistance then
              closestDistance = distance
              closestName = m.Name
            end
          end
        end
      end
    end
  end
  return closestName, closestDistance
end

local function ActiveCustomerSpeed()
  task.spawn(function()
    while activeCustomerSpeed do
      task.wait()
      for _, m in pairs(workspace.Hum:GetChildren()) do
        if m:IsA("Model") then
          if m.Name:match("^Man") or m.Name:match("^Anom") then
            local man1 = m:FindFirstChild("Man1")
            if man1 then
              for _, v in pairs(man1:GetChildren()) do
                if v.Name == "Humanoid" then
                  v.WalkSpeed = slideCustomSpeedCT
                end
              end
            end
          end
        end
      end
    end
  end)
end

--[[
local function ServeSoda()
  local Popcan = workspace.Cans.Prompts:GetChildren()
  for _, Soda in pairs(Popcan) do
    if Soda:IsA("MeshPart") and Soda.Name == "popcan" then
      for _, Serve in pairs(Soda:GetChildren()) do
        if Serve:IsA("ProximityPrompt") then
          fireproximityprompt(Serve)
        end
      end
    end
  end
end
]]

local BoostList = {
  "Show Anomaly",
  "Summon Anomaly",
  "Internal Control",
  "Corruption Deal",
  "Dance For Friends [Screamer]",
  "Scare A Friend",
  "Tips 10%",
  "x2 Money",
  "Endless Meat Ticket"
}

local BoostData = {
  ['Show Anomaly'] = "ShowAnomaly",
  ['Summon Anomaly'] = "SummonAnomaly",
  ['Internal Control'] = "InternalC",
  ['Corruption Deal'] = "Ticket",
  ['Dance For Friends [Screamer]'] = "Scream",
  ['Scare A Friend'] = "ScreamPlayer",
  ['Tips 10%'] = "Tips",
  ['x2 Money'] = "2xEarn",
  ['Endless Meat Ticket'] = "MeatTicket"
}


local function ActiveBoots()
  local useBoost = BoostData[selectedBoost]
  if useBoost then
    UseBoost:FireServer(useBoost)
  end
end

local function Notify(title, text, second, icom)
  WindUI:Notify({
    Title = title,
    Content = text,
    Duration = second,
    Icon = icom,
  })
end


local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


local Window = WindUI:CreateWindow({
  Title = "🌯 Scary Shawarma Kiosk",
  Author = "by Songkranz",

  Size = UDim2.fromOffset(580, 460),
  MinSize = Vector2.new(560, 350),
  MaxSize = Vector2.new(850, 560),
  Transparent = true,
  Theme = "Dark",
  Resizable = true,
  SideBarWidth = 200,
  BackgroundImageTransparency = 0.42,
  HideSearchBar = false,
  ScrollBarEnabled = false,

})

Window:EditOpenButton({
  Title = "Open UI",
  CornerRadius = UDim.new(0, 16),
  StrokeThickness = 2,
  Color = ColorSequence.new(
    Color3.fromHex("292829"),
    Color3.fromHex("151411")
  ),
  OnlyMobile = false,
  Enabled = true,
  Draggable = true,
})

Window:Tag({
  Title = "v1.0.0",
  Color = Color3.fromHex("#30ff6a"),
  Radius = 13,
})

Window:Tag({
  Title = "Free",
  Color = Color3.fromHex("#1b1a1e"),
  Radius = 13,
})

local MainTab = Window:Tab({
  Title = "Main",
  Icon = "cat",
  Locked = false,
})

local BoostTab = Window:Tab({
  Title = "Boots",
  Icon = "chevrons-up",
  Locked = false,
})
local LocalTab = Window:Tab({
  Title = "Local",
  Icon = "person-standing",
  Locked = false,
})

local Customer = MainTab:Section({
  Title = "Customer",
  Box = false,
  TextTransparency = 0.05,
  TextXAlignment = "Left",
  TextSize = 24,
  Opened = true,
})

local CustomerPara = MainTab:Paragraph({
  Title = "Custom Anomaly Check",
  Desc = "Status : N/A",
  Image = "user",
  ImageSize = 30,
})

slideCustomSpeedCT = MainTab:Slider({
  Title = "Customer Speed",
  Desc = "Custom speed for customer",
  Step = 1,
  Value = {
    Min = 6,
    Max = 10000,
    Default = 6,
  },
  Callback = function(value)
    slideCustomSpeedCT = value
  end
})

activeCustomerSpeed = MainTab:Toggle({
  Title = "Active Custom Speed",
  Desc = "Toggle custom speed",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    activeCustomerSpeed = state
    if activeCustomerSpeed then
      ActiveCustomerSpeed()
    end
  end
})

local testtt = MainTab:Button({
  Title = "Bring",
  Desc = "Serve immediately without making Shawarma",
  Locked = false,
  Callback = function()
    BringCustommer()
    print("[SUCCESS] Boost Activated")
  end

})

local Section = MainTab:Section({
  Title = "Serve",
  Box = false,
  TextTransparency = 0.05,
  TextXAlignment = "Left",
  TextSize = 24,
  Opened = true,
})

local Paragraph = MainTab:Paragraph({
  Title = "Read me",
  Desc = "You must near workstation for work",
  Color = "Orange",
  Image = "triangle-alert",
  ImageSize = 30,
})

local InstantServe = MainTab:Button({
  Title = "Instant Serve",
  Desc = "Serve immediately without making Shawarma",
  Locked = false,
  Callback = function()
    local Character = player.Character or player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Shawerma = workspace.Kit.shawerma.D2
    local distanceShawerma = (HumanoidRootPart.Position - Shawerma.Position).Magnitude

    if not HumanoidRootPart then return end

    if distanceShawerma > 5.2 then
      Notify("Distance alert", "Too much distance", 3, "triangle-alert")
    else
      fireproximityprompt(PopcanProx)
      fireproximityprompt(ShawermaProx)
    end
  end

})

local InstantSoda = MainTab:Button({
  Title = "Instant Soda",
  Desc = "Serve the soda immediately",
  Locked = false,
  Callback = function()

  end
})

local Garge = MainTab:Button({
  Title = "Open/Close Garge",
  Locked = false,
  Callback = function()
    local Character = player.Character or player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local GargeButton = workspace.Kit.Garge.Button
    local distanceGarge = (HumanoidRootPart.Position - GargeButton.Position).Magnitude

    if not HumanoidRootPart then return end

    if distanceGarge > 7.4 then
      Notify("Distance alert", "Too much distance", 3, "triangle-alert")
    else
      fireproximityprompt(GargeProx)
    end
  end

})


local Section = BoostTab:Section({
  Title = "Boost",
  Box = false,
  TextTransparency = 0.05,
  TextXAlignment = "Left",
  TextSize = 24,
  Opened = true,
})


local Paragraph = BoostTab:Paragraph({
  Title = "Read me",
  Desc = "Test Paragraph",
  Color = "Blue",
  Image = "arrow-big-up-dash",
  ImageSize = 30,
})

local selectBoots = BoostTab:Dropdown({
  Title = "Select Boost",
  Desc = "Select for summon",
  Values = BoostList,
  Value = "",
  Callback = function(value)
    selectedBoost = value
  end
})


local Button = BoostTab:Button({
  Title = "Active Boost",
  Locked = false,
  Callback = function()
    ActiveBoots()
  end
})

MainTab:Select()
InstantSoda:Lock()

--// Main loop

task.spawn(function()
  while task.wait(0.2) do
    local name, distance = GetCurrentCustomer()

    if not name then
      CustomerPara:SetDesc("Waiting for customer")
    elseif distance < 40 then
      if name:match("^Man") then
        CustomerPara:SetDesc("Current customer : Safe 🟢")
      elseif name:match("^Anom") then
        CustomerPara:SetDesc("Current customer : Not safe 🔴")
      end
    else
      CustomerPara:SetDesc("Waiting for customer")
    end
  end
end)
