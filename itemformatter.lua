local TotalItems = {
    ["Armors"] = {},
    ["Helmets"] = {},
    ["Weapons"] = {}, 
    ["Spells"] = {}
}
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game.ReplicatedStorage

local function CalculatePotential(Base, MaxUpgrade)
    return Base + (MaxUpgrade * 10)
end

for Index, Thing in pairs(ReplicatedStorage:WaitForChild("remotes"):WaitForChild("reloadInvy"):InvokeServer()) do
    if Index == "weapons" then
        for SecondIndex, Item in next, Thing do
            if Item.physicalDamage > Item.spellPower then 
                table.insert(TotalItems["Weapons"], {Name = Item.name, Potential = CalculatePotential(Item.physicalDamage, (Item.maxUpgrades - Item.currentUpgrade)), Rarity = Item.rarity})
            elseif Item.physicalDamage < Item.spellPower then 
                table.insert(TotalItems["Weapons"], {Name = Item.name, Potential = CalculatePotential(Item.spellPower, (Item.maxUpgrades - Item.currentUpgrade)), Rarity = Item.rarity})
            end
        end 
    elseif Index == "chests" or Index == "helmets" then
        for SecondIndex, Item in next, Thing do
            local ItemSortThing = (Index == "helmets" and TotalItems["Helmets"]) or TotalItems["Armors"]
            if Item.physicalPower > Item.spellPower then 
                table.insert(ItemSortThing, {Name = Item.name, Potential = CalculatePotential(Item.physicalPower, (Item.maxUpgrades - Item.currentUpgrade)), Health = Item.health, Rarity = Item.rarity})
            elseif Item.physicalPower < Item.spellPower then 
                table.insert(ItemSortThing, {Name = Item.name, Potential = CalculatePotential(Item.spellPower, (Item.maxUpgrades - Item.currentUpgrade)), Health = Item.health, Rarity = Item.rarity})
            end
        end 
    elseif Index == "abilities" then
        for SecondIndex, Item in next, Thing do
            local IsDuplicate = false  
            for ThirdIndex, Item2 in next, TotalItems["Spells"] do 
                if Item2.Name:find(Item.name) then 
                    --table.insert(TotalItems["Spells"], {Name = string.format("%s %s", ColorThing, Item.name)})
                    Item2.Count = Item2.Count + 1
                    IsDuplicate = true
                    break 
                end 
            end 
            if IsDuplicate == false then
                table.insert(TotalItems["Spells"], {Name = Item.name, Rarity = Item.rarity, Count = 1})
            end 
        end 
    end 
end 

for Index, ItemType in next, TotalItems do 
    if Index ~= "Spells" then 
        table.sort(TotalItems[Index], function(a, b)
            return a.Potential > b.Potential
        end)
    end 
end 

local EncodedInfo = HttpService:JSONEncode(TotalItems)
