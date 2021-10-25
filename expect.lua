local lib = LibStub:GetLibrary("LibWoWUnit");

local index = function(t, name)
	local mt = getmetatable(t)
	
	if (name == 'Not') then
		mt.expectedResult = not mt.expectedResult;
	end

	mt.operator = name;
	
	return setmetatable(t, mt);
end
	
local call = function(t, ...)
	local mt = getmetatable(t)
	local input = mt.input;
	local operator = mt.operator;
	local expectedResult = mt.expectedResult;

	mt.test.expects = mt.test.expects + 1;
	
	if (lib.matcher[operator]) then
		local result = lib.matcher[operator](input, ...)
		
		if (result == expectedResult) then
			return;
		end
		
		table.insert(test.errors, 'operator ' .. operator .. ' failed.')
		return;
	end
	
	table.insert(test.errors, 'operator ' .. operator .. ' is not registered.')
end

function lib:expect(input)
	local mt = {
			__index = index,
			__call = call,
			['input'] = input,
			['expectedResult'] = true,
			['operator'] = nil,
			['test'] = lib:getRunningTest() or {expects = 0, errors = {}}
		}

	return setmetatable({}, mt);
end

_G['expect'] = function(...) return lib:expect(...); end;