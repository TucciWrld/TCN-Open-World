extends Node

# Settings system for TCN Open World
# Handles graphics, audio, and gameplay settings

const SETTINGS_FILE = "user://tcn_settings.json"

var current_settings: Dictionary = {
	"graphics_quality": 1,  # 0=Low, 1=Medium, 2=High, 3=Ultra
	"brightness": 1.0,
	"master_volume": 0.8,
	"music_volume": 0.6,
	"sfx_volume": 0.8,
	"target_fps": 0,  # 0=30 FPS, 1=60 FPS
	"vsync_enabled": true,
	"motion_blur": true,
	"controller_vibration": true
}

func _ready() -> void:
	load_settings_from_file()
	apply_settings()

func load_settings_from_file() -> Dictionary:
	if not ResourceLoader.exists(SETTINGS_FILE):
		return current_settings
	
	var file = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
	if file == null:
		return current_settings
	
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		var loaded_data = json.get_data() as Dictionary
		for key in loaded_data:
			if key in current_settings:
				current_settings[key] = loaded_data[key]
	
	return current_settings

func save_settings_to_file() -> bool:
	var json_string = JSON.stringify(current_settings)
	var file = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	
	if file == null:
		printerr("Failed to save settings")
		return false
	
	file.store_string(json_string)
	return true

func load_settings() -> Dictionary:
	return current_settings.duplicate()

func set_graphics_quality(quality: int) -> void:
	current_settings["graphics_quality"] = clamp(quality, 0, 3)
	apply_settings()
	save_settings_to_file()

func set_brightness(value: float) -> void:
	current_settings["brightness"] = clamp(value, 0.5, 1.5)
	apply_settings()
	save_settings_to_file()

func set_master_volume(value: float) -> void:
	current_settings["master_volume"] = clamp(value, 0.0, 1.0)
	apply_settings()
	save_settings_to_file()

func set_music_volume(value: float) -> void:
	current_settings["music_volume"] = clamp(value, 0.0, 1.0)
	apply_settings()
	save_settings_to_file()

func set_target_fps(fps_index: int) -> void:
	current_settings["target_fps"] = clamp(fps_index, 0, 1)
	apply_settings()
	save_settings_to_file()

func apply_settings() -> void:
	# Apply FPS setting
	var target_fps = 30 if current_settings["target_fps"] == 0 else 60
	Engine.physics_ticks_per_second = target_fps
	get_tree().root.msaa_3d = DisplayServer.MSAA_2X if current_settings["graphics_quality"] >= 2 else DisplayServer.MSAA_OFF
	
	# Apply audio settings
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(current_settings["master_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(current_settings["music_volume"]))
