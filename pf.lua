-- variables
local fakeTick;
local tickOffset = 2;
local eventIndexes = {
    ["newbullets"] = 2,
    ["equip"] = 2,
    ["spotplayers"] = 2,
    ["updatesight"] = 3,
    ["newgrenade"] = 3,
    ["bullethit"] = 5
};

-- modules
local shared = getrenv().shared;
local network = shared.require("network");

-- hooks
local old = network.send;
network.send = function(self, name, ...)
    local args = { ... };
    if name == "repupdate" then
        if not fakeTick then
            fakeTick = args[3];
        end

        args[3] = fakeTick; 
        fakeTick += tickOffset;
    elseif eventIndexes[name] then
        args[(eventIndexes[name])] = fakeTick;
    elseif name == "ping" then
        return;
    end
    return old(self, name, unpack(args));
end
