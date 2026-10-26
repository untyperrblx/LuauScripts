--!strict
--!native

-- Base64 Library

-- Note: I assume there's a more optimized way of encoding/decoding with
-- more usage of the `bit32` library but I'm too lazy and dumb to learn so :)

type Base64Lib = {
	encode: (input: string) -> string,
	decode: (encoded: string) -> string,
}

-- Constants
const _debug = false

const maxBits = 6
const maxBitsDecode = 8
const baseMultiple = 4
const padding = '='

local mapping: { [number]: string } = {}

-- automated character mapping because too repetitive
do
	for i = 0, 25 do
		local c1 = string.char(i + 65)
		local c2 = string.char(i + 97)

		mapping[i] = c1
		mapping[i + 26] = c2
	end
	
	for i = 0, 9 do
		mapping[i + 52] = tostring(i)
	end

	mapping[62] = '+'
	mapping[63] = '/'
end

-- Converts a byte number into 8-bit binary number (6-bit if cropped is true)
local function byteToBinary(byte: number, cropped: boolean?): string
	local binary = ''

	local max = if cropped then 5 else 7
	-- Skidded
	for i = max, 0, -1 do
		local b = bit32.rshift(byte, i) % 2
		binary ..= tostring(b)
	end

	return binary
end

-- Converts a binary number into a byte number
local function binaryToByte(binary: string): number
	local newByte = tonumber(binary, 2)
	if not newByte then
		error(`Attempted to encode invalid binary - parameter: ""{newByte}""`)
	end
	return newByte
end

local function dprint<T>(...: T)
	if _debug then print(...) end
end

-- Swaps the table's keys and values
local function swapTable<K, V>(t: { [K]: V }): { [V]: K }
	local t2 = {}
	for k: K, v: V in t do
		t2[v] = k
	end
	return t2
end

-- Encodes a 6-bit binary number into a preset character
local function encodeChar(bit: string): string
	local newDigit = binaryToByte(bit)
	
	local newChar = mapping[newDigit]
	return newChar
end

local base64 = {} :: Base64Lib

function base64.encode(input: string): string
	local encoded = ''
	
	local inputBuffer = buffer.fromstring(input)
	local length = buffer.len(inputBuffer)

	local bitstream = ''
	local index = 0
	local times = 0
	
	repeat
		if string.len(bitstream) >= maxBits then
			-- If enough stored bits, get the first 6 bits and assign a preset character according to the mapped table
			local fetchBits = string.sub(bitstream, 1, maxBits)
			bitstream = string.sub(bitstream, maxBits + 1)

			local newChar = encodeChar(fetchBits)
			encoded ..= newChar

			if index > length - 1 then
				break
			end
			if string.len(bitstream) < maxBits then
				index += 1
			end
		else
			-- If not enough, extract another character and store as binary
			local byte = buffer.readu8(inputBuffer, index)
			local binary = byteToBinary(byte)
			bitstream ..= binary
		end

		times += 1
	until index > length - 1

	-- Debug results
	dprint(`Times encoding: {times}`)
	dprint(`Remaining prior bits: ""{bitstream}""`)

	-- Adds empty bits for any remaining bits
	local remLength = string.len(bitstream)
	if remLength > 0 then
		-- just to make sure
		if remLength > 6 then
			error(`Remaining bit length exceeds 6 bits - reading at {remLength}`)
		end

		dprint('Encoding extra bits...')
		
		local extraBits = 6 - remLength
		bitstream ..= string.rep('0', extraBits)

		local newChar = encodeChar(bitstream)
		encoded ..= newChar
	end

	-- Adds padding (=) if `encoded` is not a multiple of 4
	local encLength = string.len(encoded)
	local encRemainder = encLength % baseMultiple
	if encRemainder ~= 0 then
		local extraPads = baseMultiple - encRemainder
		encoded ..= string.rep(padding, extraPads)
	end

	return encoded
end

function base64.decode(encoded: string): string
	local decoded = ''
	
	-- Remove padding (=)
	encoded = string.gsub(encoded, '=', '')
	
	local reverseMap = swapTable(mapping)
	local decodeBits = buffer.create(string.len(encoded))

	local bitstream = ''
	local dtimes = 0
	
	local encLength = string.len(encoded) -- length is 4 if `Cat`
	for i = 1, encLength do
		-- Gets the character from an index, finds the mapped number, and converts into binary
		local char = string.sub(encoded, i, i)
		local mapIndex = reverseMap[char]
		local binary = byteToBinary(mapIndex, true)
		bitstream ..= binary

		-- If there's an 8-bit number available, convert back to its original character
		if string.len(bitstream) >= maxBitsDecode then
			local newBits = string.sub(bitstream, 1, maxBitsDecode)
			bitstream = string.sub(bitstream, maxBitsDecode + 1)

			local newByte = binaryToByte(newBits)
			local newChar = string.char(newByte)
			decoded ..= newChar
		end

		dtimes += 1
	end

	dprint(`Decoding times: {dtimes}`)
	
	return decoded
end

return base64
