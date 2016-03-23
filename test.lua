--run in terminal
require "movement"
require "ai"
require 'busted.runner'()

closed_test_map = {{'X', 'X', 'X', 'X', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'NWLK', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'X', 'X', 'X', 'X'}}

open_test_map = {{'X', 'X', 'X', 'X', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'NWLK', 'X'},
					{'X', 'X', 'X', 'X', 'X'}}


describe("a test", function()
	it("tests simple maps", function()
		assert.is_true(ai.check_if_open(open_test_map,3,3))
		assert.is_false(ai.check_if_open(closed_test_map,3,3))
	end)
end)