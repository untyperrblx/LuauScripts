local module = {}

-- module constants
local bitSep = "\0"
local byteSep = "\t"

-- internal module functions
local function lettersToBuffers(text: string): {buffer}
  	local letterBuffers: {buffer} = {}
  	for _,v in string.split(text, "") do
    	local byte = string.byte(v)
    	local buff = buffer.create(1)
    	buffer.writeu8(buff, 0, byte)
    	table.insert(letterBuffers, buff)
  	end
  	return letterBuffers
end

function module.encodeFromJson(data: string): string
  	local letterBuffers = lettersToBuffers(data)
  	local bits: {string} = {}
  	
  	for _,b in letterBuffers do
		local _bitTable: {number} = {}
    	for i = 1,8 do
      		local _bit = buffer.readbits(b, 0, i)
      		table.insert(_bitTable, _bit)
    	end
    	local _bitConcat = table.concat(_bitTable, bitSep)
    	table.insert(bits, _bitConcat)
  	end
  	
  	local result = table.concat(bits, byteSep)
  	return result
end

function module.decodeToJson(data: string): string
	local bits = string.split(data, byteSep)
	local resultTable: {string} = {}
	
	for _,v in bits do
		local _buff = buffer.create(1)
    	for i,b in string.split(v, bitSep) do
      		local nb = tonumber(b)
			if nb then
				buffer.writebits(_buff, 0, i, nb)
			end
		end
		table.insert(resultTable, buffer.tostring(_buff))
	end
	
	local result = table.concat(resultTable)
	return result
end

local json = [[{
  "name": "Untyper",
  "id": 16,
  "data": {
    "kills": 480,
    "deaths": 140,
    "wins": 62,
  }
}]]

local encoded = module.encodeFromJson(json)
print(encoded)

local decoded = module.decodeToJson(encoded)
print(decoded)
