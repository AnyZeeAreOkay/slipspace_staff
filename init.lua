--TODO:
--	1. Get a restricted mode working, since in its current form, it's way overpowered. I tried earlier, then gave up for now.
--	2. Figure out what to do when used on enemies...Kill them? Teleport them elsewhere? Hmmm....
--	3. ?????
--	4. Profit
-- 	5. Fix the stupid bug with protection...It works, but...?????????????????
--	6. Thorough commenting

local radius = 4
local c_randomize_restore = 2



minetest.register_tool("slipspace_staff:slipspace_staff", {
	description = "Move blocks into, or from, slipspace",
	inventory_image = "slipspace_bore.png",
	wield_image = "slipspace_bore.png",
	liquids_pointable = true,
	range = 15,
	on_place = function(itemstack, user, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		if pointed_thing.type == "node" then
			local pos1 = {x=pos.x-20, y=pos.y-20, z=pos.z-20}
			local pos2 = {x=pos.x+20, y=pos.y+20, z=pos.z+20}

			local manip = minetest.get_voxel_manip()
			local min_c, max_c = manip:read_from_map(pos1, pos2)
			local area = VoxelArea:new({MinEdge=min_c, MaxEdge=max_c})

			local data = manip:get_data()
			local changed = false

		local isu_id = minetest.get_content_id("slipspace_staff:slipspace_light")
		local air_id = minetest.get_content_id("air")
		local light_id = minetest.get_content_id("slipspace_staff:slipspace")

	-- check each node in the area
	for i in area:iterp(pos1, pos2) do
		local nodepos = area:position(i)
		local cur_id = data[i]
		if cur_id == light_id or cur_id == isu_id then
			local meta = minetest.get_meta(area:position(i))
			local cur_name = minetest.get_name_from_content_id(cur_id)
			local data = meta:to_table()
			minetest.get_node(area:position(i))
			meta:from_table(data)
			summon2 = data.fields.summon
			minetest.get_meta(area:position(i)):set_string("summon2", summon2)
			data[i] = isu_id
			changed = true

			end
			end
			end
			-- save changes if needed
			if changed then
			manip:set_data(data)
			manip:write_to_map()
end

	end,
	on_use = function(itemstack, user, pointed_thing)
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		if pointed_thing.type == "node" then
			local node = minetest.get_node(pos)


	local pos1 = {x=pos.x-radius, y=pos.y-radius, z=pos.z-radius}
	local pos2 = {x=pos.x+radius, y=pos.y+radius, z=pos.z+radius}

	local manip = minetest.get_voxel_manip()
	local min_c, max_c = manip:read_from_map(pos1, pos2)
	local area = VoxelArea:new({MinEdge=min_c, MaxEdge=max_c})

	local data = manip:get_data()
	local changed = false

	local isu_id = minetest.get_content_id("slipspace_staff:slipspace_light")
	local air_id = minetest.get_content_id("air")
	local light_id = minetest.get_content_id("slipspace_staff:slipspace")

	-- check each node in the area
	for i in area:iterp(pos1, pos2) do
		local nodepos = area:position(i)

			local cur_id = data[i]
			--if nodes in area and nodes do not equal slipspace_light or air or slipspace
			if cur_id and cur_id ~= isu_id and cur_id ~= air_id and cur_id ~= light_id then
				local cur_name = minetest.get_name_from_content_id(cur_id)
					minetest.get_node(area:position(i))

					minetest.get_meta(area:position(i)):set_string("summon", cur_name)
					data[i] = isu_id
					changed = true


			end
	end
	-- save changes if needed
	if changed then
		manip:set_data(data)
		manip:write_to_map()

	end
end
end
}
)
minetest.register_node("slipspace_staff:slipspace_light", {
	description = "Slipspace light",
	drawtype = "glasslike",
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"light.png"},
	light_source = 3,
	buildable_to = true,
	use_texture_alpha = true,
	pointable = false,
	is_ground_content = false,
	groups = {unbreakable = 1},
	walkable = false,
	on_timer = function(pos)
	        minetest.swap_node(pos, { name = "slipspace_staff:slipspace" })
	        return false
	    end,
  on_construct = function(pos)
		local timer = minetest.get_node_timer(pos)
timer:start(2)
end
}
)
minetest.register_node("slipspace_staff:slipspace", {
	description = ("Slipspace"),
	range = 12,
	stack_max = 10000,
	inventory_image = "default_steel_block.png^default_mese_crystal_fragment.png",
	drawtype = "airlike",
	walkable = false,
	pointable = false,
	buildable_to = true,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = 1},

})
-- ABM to restore blocks
minetest.register_abm({
	nodenames = {"slipspace_staff:slipspace"},
	interval = 2,
	chance = 2,
	action = function(pos, node, active_object_count,
            active_object_count_wider)
		if node.name == 'ignore' or node.name == nil then
			return
		end
		local can_be_restored = true

		--restore them
		if can_be_restored then
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			local data = meta:to_table()
			node.name = data.fields.summon2
			if node.name == 'ignore' or node.name == nil then
				return end
			data.fields.summon2 = nil
			data.fields.summon = nil
			meta:from_table(data)
			minetest.swap_node(pos, node)
		end
	end
})
minetest.register_abm({
	nodenames = { "slipspace_staff:slipspace_light" },
	interval = 2,
	chance = c_randomize_restore,
	action = function(pos, node)
		if node.name == 'ignore' then
			return
		end
		local can_be_restored = true
			minetest.swap_node(pos, {name = "slipspace_staff:slipspace"})
		end
})

