minetest.register_node("ductus_venosus:stone", {
	description = "Ductus Venosus Stone",
	tiles = {"default_stone.png^[colorize:red:120"},
	is_ground_content = true,
	groups = {cracky=3, stone=1, vein=1},
	drop = 'ductus_venosus:stone',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("ductus_venosus:stone_inactivated", {
	description = "Ductus Venosus Stone",
	tiles = {"default_stone.png^[colorize:red:120"},
	is_ground_content = true,
	groups = {cracky=3, stone=1, vein=1},
	drop = 'ductus_venosus:stone',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

-- Checks if a given position is already occupied
local function is_pos_occupied(pos)
	local name = minetest.get_node(pos).name
	if name == "air" then
		return false
	else
		return true
	end
end

-- Returns a random neighbour pos
local function get_neighbour(pos, prefer_horizontal)

	-- Generate three random integers from -1 to 1 that represent possible
	-- neighbour's coordinates projections
	local delta_x = math.random(3) - 2
	local delta_y
	local delta_z = math.random(3) - 2

	if prefer_horizontal then
		if math.random(5) == 1 then
			delta_y = math.random(3) - 2
		else
			delta_y = 0
		end
	else
		delta_y = math.random(3) - 2
	end

	-- Make sure that at least one delta is not equal to zero
	-- FIXME: I LAG FOR SOME REASON
--[[
	while delta_x == 0 and delta_y == 0 and delta_z == 0 do
		local delta_x = math.random(3) - 2
		local delta_y = math.random(3) - 2
		local delta_z = math.random(3) - 2
	end
--]]
	-- Finally, calculate the position
	local neighbour = {
		x = pos.x + delta_x,
		y = pos.y + delta_y,
		z = pos.z + delta_z}

	-- Return the result
	return neighbour
end

minetest.register_abm({
	nodenames = {"ductus_venosus:stone"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)

		local neighbour = get_neighbour(pos, true)
		if not is_pos_occupied(neighbour) then
			minetest.set_node(neighbour, node)
		end

		-- Inactivate the stem node (there is a 25% chance that it won't be inactivated)
		if math.random(3) ~= 1 then
			minetest.set_node(pos, {name = "ductus_venosus:stone_inactivated"})
		end
	end,
})

-- Finally, register this as an ore
minetest.register_ore({
    ore_type       = "scatter",
    ore            = "ductus_venosus:stone",
    wherein        = "default:stone",
    clust_scarcity = 16*16*16,
    clust_num_ores = 8,
    clust_size     = 3,
    height_min     = -31000,
    height_max     = 31000,
})
