extends Node

# Save system for TCN Open World
# Handles all game state persistence

const SAVE_DIR = "user://tcn_saves/"
const SAVE_FILE = "save_game.json"
const SETTINGS_FILE = "settings.json"

func _ready() -> void:
	# Create save directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_abs_absolute(SAVE_DIR)

func has_save() -> bool:
	return ResourceLoader.exists(SAVE_DIR + SAVE_FILE)

func save_game(game_data: Dictionary) -> bool:
	# Save game state to JSON
	var save_data = {
		"version": "1.0",
		"timestamp": Time.get_ticks_msec(),
		"player_data": game_data.get("player_data", {}),
		"world_state": game_data.get("world_state", {}),
		"missions": game_data.get("missions", []),
		"vehicles": game_data.get("vehicles", []),
		"properties": game_data.get("properties", [])
	}
	
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_DIR + SAVE_FILE, FileAccess.WRITE)
	
	if file == null:
		printerr("Failed to open save file for writing")
		return false
	
	file.store_string(json_string)
	return true

func load_game() -> Dictionary:
	# Load game state from JSON
	if not has_save():
		return {}
	
	var file = FileAccess.open(SAVE_DIR + SAVE_FILE, FileAccess.READ)
	
	if file == null:
		printerr("Failed to open save file for reading")
		return {}
	
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		printerr("Failed to parse save file")
		return {}
	
	return json.get_data() as Dictionary

func clear_save() -> void:
	# Delete save file
	if has_save():
		DirAccess.remove_absolute(SAVE_DIR + SAVE_FILE)

func export_save() -> String:
	# Export save data as JSON string
	var save_data = load_game()
	return JSON.stringify(save_data)

func import_save(json_string: String) -> bool:
	# Import save data from JSON string
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		printerr("Failed to parse import data")
		return false
	
	var save_data = json.get_data() as Dictionary
	return save_game(save_data)
