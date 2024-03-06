---@diagnostic disable: lowercase-global

unused_args = false

globals = {
	"vector",
	math = {
		fields = {
			"round",
			"hypot",
			"sign",
			"factorial",
			"ceil",
		}
	},

	"minetest", "core",

	"random_messages_api"
}

read_globals = {
	"DIR_DELIM",
	"dump", "dump2",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "PcgRandom",
	"ItemStack",
	"Settings",
	"unpack",
	"loadstring",

	"afk_indicator",

	table = {
		fields = {
			"copy",
			"indexof",
			"insert_all",
			"key_value_swap",
			"shuffle",
			"random",
		}
	},

	string = {
		fields = {
			"split",
			"trim",
		}
	},
}
