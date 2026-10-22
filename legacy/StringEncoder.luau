--[=[
Made by Untyper (@UntyperSoftworks)

Current version: v1.0

Description:
A simple obfuscation tool with encodes strings into
a set of shuffled bytechar data with a number key & operation key.

(Originally developed from Lune -> https://github.com/lune-org/lune)

TODO:
* Add parameter table as 2nd argument in both functions
	* Add custom number & operation key parameters
	* Add custom separation character parameters
	* Add custom length parameters (both number & operation keys)
	* Add custom number randomization range parameter
	* Add key index order parameter (normal or reverse)
	* Add operation modes parameter
		* Add multiply & divide options for operation key
* Rewrite into .lua version of module
]=]

local Encoder = {}

local DEFAULT_KEY_SEP = "\\=" -- constant separator varaible

-- Encodes string into shuffled byte characters
function Encoder.Encode(text: string): string
	local numberKey = ""
	local opKey = ""
	local sepr = "_"
	
	-- Generate keys
	local numLength = math.random(4, 16)
	for _ = 1, numLength do
		local n = math.random(0, 9)
		numberKey = `{numberKey}{tostring(n)}`
	end
	local p, m = "+", "-"
	local keyLength = math.random(4, 10)
	for _ = 1, keyLength do
		local op = (math.random(1, 2) == 1) and p or m
		opKey = `{opKey}{op}`
	end

	local result: string = `{numberKey}{DEFAULT_KEY_SEP}{opKey}{DEFAULT_KEY_SEP}`

	-- Split text/key characters into tables
	local splitText = string.split(text, "")
	local splitNumKey = string.split(numberKey, "")
	local splitOpKey = string.split(opKey, "")

	local numIndex = 1
	local opIndex = #splitOpKey -- default is reverse indexing
	for i,v in splitText do
		-- Convert selected count number: string -> number? (number OR nil)
		local count = tonumber(splitNumKey[numIndex])
		-- Luau's typesolver errors when trying to do arithmetic with varaibles w/ type `number?`
		-- because some cases can be nil.
		-- To fix this, using the assert function will remove the "nil" part
		-- but as a sacrifice for showing errors if so.
		assert(count ~= nil, "Variable `count` returned nil!")
		local newop = splitOpKey[opIndex]
		local mul = (newop == "-") and -1 or 1

		local byte = string.byte(v)
		-- "shuffles" bytechar with its corresponding count & operation
		-- i.e. Adds/subtracts the byte number with the current `count` number
		local byte2 = byte + (count * mul)
		if i == #splitText then
			result = `{result}{tostring(byte2)}`
		else
			result = `{result}{tostring(byte2)}{sepr}`
		end

		-- increments indexes
		numIndex += 1
		if numIndex > #splitNumKey then
			numIndex = 1
		end
		opIndex -= 1
		if opIndex < 1 then
			opIndex = #splitOpKey
		end
	end

	return result
end

-- Encode aliases
Encoder.Obfuscate = Encoder.Encode
Encoder.Encrypt = Encoder.Encode

function Encoder.Decode(data: string): string
	-- splits data with constant separator
	local splitData = string.split(data, DEFAULT_KEY_SEP)

	-- Gets the keys & bytechar data from `splitData`
	local key1 = splitData[1]
	local key2 = splitData[2]
	local realData = splitData[3]

	local sepr = "_"
	local result: string = ""

	-- Splits keys & bytechar data into tables
	local splitNumKey = string.split(key1, "")
	local splitOpKey = string.split(key2, "")
	local splitBytes = string.split(realData, sepr)

	local numIndex = 1
	local opIndex = #splitOpKey
	for _,v in splitBytes do
		-- Convert selected count: string -> number?
		-- (number? indicates number OR nil)
		local count = tonumber(splitNumKey[numIndex])
		-- (i hate Luau's new typesolver) Asserting `count` will remove the "nil" part of the type with the sacrifice of errors
		-- Without the assert function, the compiler will error
		assert(count ~= nil, "Variable `count` returned nil!")
		local newop = splitOpKey[opIndex]
		local mul = (newop == "-") and 1 or -1 -- inverse versions

		-- Convert selected bytechar: string -> number? (same as above)
		local byte = tonumber(v)
		-- same as above; assert `byte` to remove "nil" part yet with errors
		assert(byte ~= nil, "Variable `byte` returned nil!")
		-- Calculates back to original bytechar
		local byte2 = byte + (count * mul)
		local newChar = string.char(byte2)
		-- Concatenate decoded char into result
		result = `{result}{newChar}`

		-- Increment indexes
		numIndex += 1
		if numIndex > #splitNumKey then
			numIndex = 1
		end
		opIndex -= 1
		if opIndex < 1 then
			opIndex = #splitOpKey
		end
	end

	return result
end

-- Decode aliases
Encoder.Deobfuscate = Encoder.Decode
Encoder.Unobfuscate = Encoder.Decode
Encoder.Decrypt = Encoder.Decode

return Encoder
