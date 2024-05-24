local Version = "1.01"

do -- Functions
    function UseTreat(PetID, Item, Amount, Repeat)
        for i = 1, Repeat do
            local args = {
                [1] = "UseTreat",
                [2] = PetID,
                [3] = Item,
                [4] = Amount
            }
        
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer(unpack(args))
        end
    end
    
    function GetPagePets() -- Returns all pets on inventory page
        local PetIDs = {}
        for _,v in game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Main.Content.Pets.Grid.Content:GetChildren() do
            if v:IsA("Frame") then
                table.insert(PetIDs, v.Name)
            end
        end
        return PetIDs
    end
    
    function GetEquippedPets() -- Returns all equipped pets
        local PetIDs = {}
        local PetNames = {}
        for _,v in game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Main.Content.Pets.Grid.Content:GetDescendants() do
            if v.Name == "Equipped" and v.Visible == true then
                table.insert(PetIDs, v.Parent.Parent.Name)
            end
        end
        return PetIDs
    end

    function ColorChanger(Value, Color) -- Change Inventory Background Color
        if Value == true then
            game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Main.BackgroundColor3 = Color
        elseif Value == false then
            game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Main.BackgroundColor3 = Color3.fromRGB(225, 243, 255)
        end
    end   
end

do -- Ui
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Pet Catchers!",
        SubTitle = "v." .. Version,
        TabWidth = 150,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
    })

    --Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
    local Tabs = {
        Pets = Window:AddTab({ Title = "Pets", Icon = "" }),
        Misc = Window:AddTab({ Title = "Misc", Icon = "" }),
        Config = Window:AddTab({ Title = "Config", Icon = "" })
    }

    do -- Pets Tab
        local Runes = {}
        local Used = {}
        for _, v in game.ReplicatedStorage.Assets.Items:GetChildren() do
            if not Used[v.Name] and string.find(v.Name, "Rune") then
                table.insert(Runes, v.Name)
                Used[v.Name] = true
            end
        end

        local Defaults = {
            Mode = nil,
            Settings = {nil},
            Rune1 = nil,
            Rune2 = nil,
            Rune3 = nil
        }
        Tabs.Pets:AddButton({
            Title = "Max Pets!",
            Callback = function()
                if Defaults.Mode == "Equipped Pets" then
                    for i,ID in GetEquippedPets() do
                        for _,String in Defaults.Settings do -- Check Settings
                            if String == "Shiny" then
                                UseTreat(ID, "Golden Cherry", 1, 100)
                            elseif String == "Max Level" then
                                UseTreat(ID, "Knowledge Scroll", 1, 25)
                            elseif String == "Use Runes" then
                                UseTreat(ID, Defaults.Rune1, 1, 4)
                                UseTreat(ID, Defaults.Rune2, 1, 4)
                                UseTreat(ID, Defaults.Rune3, 1, 4)
                            elseif String == "Prismatic Scroll" then
                                UseTreat(ID, "Prismatic Scroll", 1, 1)
                            elseif String == "Magic Pendants" then
                                UseTreat(ID, "Magic Pendant", 1, 100)
                            end
                        end
                    end
                elseif Defaults.Mode == "Page Pets" then
                    for i,ID in GetPagePets() do
                        for _,String in Defaults.Settings do -- Check Settings
                            if String == "Shiny" then
                                UseTreat(ID, "Golden Cherry", 1, 100)
                            elseif String == "Max Level" then
                                UseTreat(ID, "Knowledge Scroll", 1, 25)
                            elseif String == "Use Runes" then
                                UseTreat(ID, Defaults.Rune1, 1, 4)
                                UseTreat(ID, Defaults.Rune2, 1, 4)
                                UseTreat(ID, Defaults.Rune3, 1, 4)
                            elseif String == "Prismatic Scroll" then
                                UseTreat(ID, "Prismatic Scroll", 1, 1)
                            elseif String == "Magic Pendants" then
                                UseTreat(ID, "Magic Pendant", 1, 100)
                            end
                        end
                    end
                end
            end
        })
        Tabs.Pets:AddDropdown("MaxMode", {
            Title = "Mode",
            Values = {"Equipped Pets", "Page Pets"},
            Multi = false,
            Default = nil,
            Callback = function(Value)
                Defaults.Mode = Value
            end
        })
        Tabs.Pets:AddDropdown("Settings", {
            Title = "Settings",
            Values = {"Shiny", "Max Level", "Use Runes", "Prismatic Scroll", "Magic Pendants"},
            Multi = true,
            Default = {nil},
            Callback = function(Value)
                Defaults.Settings = {}
                for i,v in Value do
                    table.insert(Defaults.Settings, i)
                end
            end
        })
        Tabs.Pets:AddDropdown("Rune1", {
            Title = "Rune 1",
            Values = Runes,
            Multi = false,
            Default = nil,
            Callback = function(Value)
                Defaults.Rune1 = Value
            end
        })
        Tabs.Pets:AddDropdown("Rune2", {
            Title = "Rune 2",
            Values = Runes,
            Multi = false,
            Default = nil,
            Callback = function(Value)
                Defaults.Rune2 = Value
            end
        })
        Tabs.Pets:AddDropdown("Rune3", {
            Title = "Rune 3",
            Values = Runes,
            Multi = false,
            Default = nil,
            Callback = function(Value)
                Defaults.Rune3 = Value
            end
        })
    end

    local Options = Fluent.Options
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:SetFolder("Fluent-PetCatchers")
    SaveManager:SetFolder("Fluent-PetCatchers")
    InterfaceManager:BuildInterfaceSection(Tabs.Config)
    SaveManager:BuildConfigSection(Tabs.Config)
    Window:SelectTab(1)
end
