-- Creates "hidden tables" from existing tables using userdata
return function(t: {[any]: any}, destroyTable: boolean?): any
	local t2 = table.clone(t)
	if destroyTable then table.clear(t) end

	local proxy = newproxy(true)
	local mt = getmetatable(proxy)

	rawset(mt, "__index", t2)
	rawset(mt, "__newindex", function(_, key, value)
		rawset(t2, key, value)
	end)
	rawset(mt, "__metatable", "Hidden table")

	table.freeze(mt)
	return proxy
end
