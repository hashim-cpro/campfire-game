extends Node

var settings = {
	"displayMode": DisplayServer.WINDOW_MODE_FULLSCREEN,
	"resolution": [1280, 720],
	"vsync": false,
	"showFPS": false,
	"fpsLimit": 60,
	"borderless": false,
	"brightness": 100,
	"masterVolume": 100,
	"sfxVolume": 100,
	"musicVolume": 100
}

var color_groups: Array[String] = [
	"Color_Red",      # 0
	"Color_Green",    # 1
	"Color_Blue",     # 2
	"Color_Yellow",   # 3
	"Color_Magenta",  # 4
	"Color_Cyan",     # 5
	"Color_Orange",   # 6
	"Color_Purple"    # 7
]

signal world_color_changed(new_color: Color, player_pos: Vector2)

func change_world_color(new_color: Color, segment_index: int, player_pos: Vector2 = Vector2.ZERO) -> void:
	world_color_changed.emit(new_color, player_pos)
	
	
	var active_group_name = color_groups[segment_index % color_groups.size()]
	
	for group_name in color_groups:
		var nodes = get_tree().get_nodes_in_group(group_name)
		if group_name == active_group_name:
			for node in nodes:
				node.visible = false
				node.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			for node in nodes:
				node.visible = true
				node.process_mode = Node.PROCESS_MODE_INHERIT

const gameData = "user://savedata.bin"

func _ready() -> void:
	if (!FileAccess.file_exists(gameData)):
		var file = FileAccess.open(gameData, FileAccess.WRITE_READ)
		file.store_var(settings)
