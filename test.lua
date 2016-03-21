require "movement"
require "ai"
require 'busted.runner'()

print("hello world")

function foo()
	return true
end

describe("a test", function()
	it("tests some assertions", function()
		assert.is_true(true)
		assert.True(foo())
		assert.are.equal(1,1)
		assert.has.errors(function() error("this will fail") end)
	end)
end)