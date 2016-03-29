--run in terminal
require "navigator"
require "ai"
require 'busted.runner'()

closed_test_map = {{'X', 'X', 'X', 'X', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'NWLK', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'X', 'X', 'X', 'X'}}

open_test_map = {{'X', 'X', 'X', 'X', 'X', 'X'},
					{'X', 'NWLK', 'NWLK', 'NWLK', 'NWLK', 'X'},
					{'X', 'NWLK', 'WALK', 'WALK', 'NWLK', 'X'},
					{'X', 'NWLK', 'NWLK', 'Walk', 'NWLK', 'X'},
					{'X', 'X', 'X', 'X', 'X', 'X'}}


-- describe("a test", function()
-- 	it("tests simple maps", function()
-- 		--assert.is_true(ai.find_path_out(open_test_map,3,3))
-- 		--assert.is_false(ai.find_path_out(closed_test_map,3,3))
-- 		assert.is_true(table.maxn{{},{}}==2)
-- 	end)
-- end)

function main()
	test_table = {}
	test_table[100] = "g"
	print(test_table[99])
end

main()