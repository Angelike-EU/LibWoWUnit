local itFn = function(scope)
	it('it ' .. scope, function()
		-- print('it outer');
	end);
	
	fit('fit ' .. scope, function()
		-- print('fit outer');
	end);

	xit('xit ' .. scope, function()
		-- print('xit outer');
	end);
end;

local descFn = function()
	afterEach(function()
		-- print('afterEach outer');
	end);

	beforeEach(function()
		-- print('beforeEach outer');
	end);
	
	itFn('outer');
	
	describe('describe inner', function()
		beforeEach(function()
			-- print('beforeEach inner');
		end);

		afterEach(function()
			-- print('afterEach inner');
		end);
		
        itFn('inner');
	end)
end;

itFn('outside');

describe('describe outer', descFn);
--fdescribe('fdescribe outer', descFn);
--xdescribe('xdescribe outer', descFn);
