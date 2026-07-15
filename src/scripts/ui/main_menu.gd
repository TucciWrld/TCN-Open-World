extends Control

@onready var music_player = $MusicPlayer
@onready var continue_button = $ButtonContainer/ContinueButton

func _ready() -> void:
	# Check if there's a save file
	if not SaveManager.has_save():
		continue_button.disabled = true
	
	# Play menu music
	music_player.play()

func _on_play_pressed() -> void:
	# Clear any existing save and start new game
	SaveManager.clear_save()
	get_tree().change_scene_to_file("res://src/scenes/gameplay/loading_screen.tscn")

func _on_continue_pressed() -> void:
	# Load existing game
	if SaveManager.has_save():
		get_tree().change_scene_to_file("res://src/scenes/gameplay/loading_screen.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/ui/settings_menu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/ui/credits_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
