--!strict
--!optimize 2

-- TODO: add `Shuffle` method and other custom methods unrelated to Roblox's library

-- Random Library without Roblox Dependencies (v0.1)
-- (https://create.roblox.com/reference/engine/datatypes/Random)

-- Clones math library to become writable
local MathClone = table.clone(getfenv().math)

local oldrandom = math.random
MathClone.random = function(min: number?, max: number?): number
    local n
    if min and max then
        n = oldrandom(min, max)
    else
        n = oldrandom() -- pseudorandom number from 0 to 1, not inclusive to 1
    end
    math.randomseed(oldrandom(-1073741824, 1073741823))
    return n
end

getfenv().math = table.freeze(MathClone)

-- Types
type Random = {
    NextInteger: (self: Random, min: number, max: number) -> number,
    NextNumber: (self: Random, min: number?, max: number?) -> number,
    NextUnitVector: (self: Random) -> vector,
    Clone: (self: Random) -> Random,
}

-- Utils
@native const function ToInteger(x: number): number
    if x % 1 ~= 0 then
        return math.floor(x)
    end
    return x
end

-- A library for pseudorandom number generation.
local Random = {}

--[[
    Creates a new Random object (with an optional preset seed)
    for generating pseudorandom numbers & directions.
]]
function Random.new(seed: number?): Random
    if seed then seed = ToInteger(seed) end
    const seed: number? = seed

    local RandomObject = {}

    --[[
        Returns a pseudorandom integer between the `min` & `max` range,
        inclusive to both ends. If `min` is greater than `max`, the two values
        swap each other to successfully call the functcion. Both arguments are
        truncated into integers themselves (by truncating their decimal points).
    ]]
    local function NextInteger(self: Random, min: number, max: number): number
        min = ToInteger(min)
        max = ToInteger(max)

        if seed then
            math.randomseed(seed)
        end

        return math.random(min, max)
    end
    RandomObject.NextInteger = NextInteger
    
    --[[
        Returns a uniform pseudorandom real number in the range of 0 to 1,
        inclusive.

        Returns a pseudorandom number between the range of 0 to 1, inclusive. If `min`
        & `max` arguments are provided, it will generate a pseudorandom number
        between the `min` & `max` range, inclusive to the endpoints.
    ]]
    local function NextNumber(self: Random, min: number?, max: number?): number
        if seed then
            math.randomseed(seed)
        end

        local n: number
        if min and max then
            local range = max - min
            n = (math.random() * range) + min
        else
            n = math.random()
        end
        
        return n
    end
    RandomObject.NextNumber = NextNumber

    --[[
        Returns a normalized, pseudorandom vector with 3 axes.
    ]]
    local function NextUnitVector(self: Random): vector
        local p: {number} = {}

        local function randomCoord(i: number): number
            if seed then
                math.randomseed(seed + i - 1)
            end
            return math.random()
        end

        for i = 1, 3 do
            p[i] = randomCoord(i)
        end

        local x, y, z = table.unpack(p)
        local v = vector.create(x, y, z)
        return vector.normalize(v)
    end
    RandomObject.NextUnitVector = NextUnitVector

    --[[
        Clones the Random object.
    ]]
    local function Clone(self: Random): Random
        local Cloned = table.clone(RandomObject)
        return table.freeze(Cloned) :: Random
    end
    RandomObject.Clone = Clone

    return table.freeze(RandomObject) :: Random
end

return Random
