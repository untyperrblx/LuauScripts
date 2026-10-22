--!nonstrict
-- Crappy function environment modifier

local globals = {
	['assert'] = assert,
	['error'] = error,
	['gcinfo'] = gcinfo,
	['getfenv'] = getfenv,
	['getmetatable'] = getmetatable,
	['next'] = next,
	['newproxy'] = newproxy,
	['print'] = print,
	['rawequal'] = rawequal,
	['rawget'] = rawget,
	['rawlen'] = rawlen,
	['rawset'] = rawset,
	['select'] = select,
	['setfenv'] = setfenv,
	['setmetatable'] = setmetatable,
	['tonumber'] = tonumber,
	['tostring'] = tostring,
	['type'] = type,
	['typeof'] = typeof,
	['ipairs'] = ipairs,
	['pairs'] = pairs,
	['pcall'] = pcall,
	['xpcall'] = xpcall,
	['unpack'] = unpack,
}

local function clone(t: any)
	return table.clone(t)
end

local libs = {
	['math'] = clone(math),
	['table'] = clone(table),
	['string'] = clone(string),
	['coroutine'] = clone(coroutine),
	['bit32'] = clone(bit32),
	['utf8'] = clone(utf8),
	['os'] = clone(os),
	['debug'] = clone(debug),
	['buffer'] = clone(buffer),
	['vector'] = clone(vector),
}

return function(t: any, properties: {[any]: any}): ()
	local genv = {}

	for k,v in globals do
		genv[k] = v
	end

	for k,v in libs do
		genv[k] = v
	end

	local function checkTables(tt: any)
		for i,v: unknown in tt do
			if typeof(v) == 'table' then
				for k,x in v do
					genv[i][k] = x
				end
			else
				genv[i] = v
			end
		end
	end

	checkTables(properties)
	
	setfenv(t, genv)
end
