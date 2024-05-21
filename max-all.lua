local Runes = {}

local DoNotChange = {
    UseGoldenCherries = false,
    UseKnowledgeScrolls = false,
    ApplyRunes = false,
    UsePrismaticScrolls = false,
    UseMagicPendants = false,
    Rune1 = "",
    Rune2 = "",
    Rune3 = ""
}

for i,v in game.ReplicatedStorage.Assets.Items:GetChildren() do
    if string.find(v.Name, "Rune") then
        table.insert(Runes, v.Name)
    end
end

local function ApplyTreat(PetID, Item, Amount)
    local args = {
        [1] = "UseTreat",
        [2] = PetID,
        [3] = Item,
        [4] = Amount
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer(unpack(args))
end

local function GetPets()
    local IDs = {}
    for _,Pets in game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Main.Content.Pets.Grid.Content:GetDescendants() do
        if Pets.Name == "Equipped" then
            if Pets.Visible == true then
                table.insert(IDs, Pets.Parent.Parent.Name)
            end
        end
    end
    return IDs
end

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Window = Library:CreateWindow({
    Title = "Pet Catchers",
    Center = true,
    AutoShow = true,
    TabPadding = 0,
    MenuFadeTime = 0.2
})

local Tabs = {
    Pets = Window:AddTab('Pets'),
    -- Hatching = Window:AddTab('Hatching')
}

local PetsLeft = Tabs.Pets:AddLeftGroupbox('Max Equipped Pets')

PetsLeft:AddToggle('Toggle1', {
    Text = 'Use Golden Cherries',
    Default = false, -- Default value (true / false)

    Callback = function(Value)
        DoNotChange.UseGoldenCherries = Value
    end
})
PetsLeft:AddToggle('Toggle1', {
    Text = 'Use Knowledge Scrolls',
    Default = false, -- Default value (true / false)

    Callback = function(Value)
        DoNotChange.UseKnowledgeScrolls = Value
    end
})
PetsLeft:AddToggle('Toggle1', {
    Text = 'Apply Runes',
    Default = false, -- Default value (true / false)

    Callback = function(Value)
        DoNotChange.ApplyRunes = Value
    end
})
PetsLeft:AddToggle('Toggle1', {
    Text = 'Use Prismatic Scrolls',
    Default = false, -- Default value (true / false)

    Callback = function(Value)
        DoNotChange.UsePrismaticScrolls = Value
    end
})
PetsLeft:AddToggle('Toggle1', {
    Text = 'Use Magic Pendants',
    Default = false, -- Default value (true / false)

    Callback = function(Value)
        DoNotChange.UseMagicPendants = Value
    end
})

PetsLeft:AddDropdown('Dropdown1', {
    Values = Runes,
    Default = 0,
    Text = 'Rune 1',
    Callback = function(Value)
        DoNotChange.Rune1 = Value
    end
})
PetsLeft:AddDropdown('Dropdown2', {
    Values = Runes,
    Default = 0,
    Text = 'Rune 2',
    Callback = function(Value)
        DoNotChange.Rune2 = Value
    end
})
PetsLeft:AddDropdown('Dropdown3', {
    Values = Runes,
    Default = 0,
    Text = 'Rune 3',
    Callback = function(Value)
        DoNotChange.Rune3 = Value
    end
})

PetsLeft:AddButton({
    Text = "Max Equipped Pets!",
    Func = function()
        for _,ID in GetPets() do
            if DoNotChange.UseGoldenCherries == true then
                ApplyTreat(ID, "Golden Cherry", 100)
            end
            if DoNotChange.UseKnowledgeScrolls == true then
                for i = 1,25 do
                    ApplyTreat(ID, "Knowledge Scroll", 1)
                end
            end
            if DoNotChange.ApplyRunes == true then
                for i = 1,4 do
                    ApplyTreat(ID, DoNotChange.Rune1, 1)
                    ApplyTreat(ID, DoNotChange.Rune2, 1)
                    ApplyTreat(ID, DoNotChange.Rune3, 1)
                end
            end
            if DoNotChange.UsePrismaticScrolls == true then
                ApplyTreat(ID, "Prismatic Scroll", 1)
            end
            if DoNotChange.UseMagicPendants == true then
                for i = 1,100 do
                    ApplyTreat(ID, "Magic Pendant", 1)
                end
            end
        end
    end
})
