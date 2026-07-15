extends Control

@onready var progress_bar = $ProgressBarContainer/ProgressBar
@onready var loading_label = $LoadingLabel

var loading_progress: float = 0.0
var world_scene_path: String = "res://src/scenes/gameplay/world.tscn"

func _ready() -> void:
	# Start loading the world
	set_progress(0.0)
	load_world_async()

func _process(delta: float) -> void:
	# Smooth progress animation
	if loading_progress < 90.0:
		loading_progress += delta * 30.0
		set_progress(loading_progress)

func set_progress(value: float) -> void:
	progress_bar.value = clamp(value, 0.0, 100.0)

func load_world_async() -> void:
	# Load the world scene
	var error = ResourceLoader.load_threaded_request(world_scene_path)
	
	if error == OK:
		while ResourceLoader.is_threaded_loading():
			await get_tree().process_frame
		
		var world_scene = ResourceLoader.load_threaded_get(world_scene_path)
		set_progress(100.0)
		await get_tree().create_timer(0.5).timeout
		get_tree().root.add_child(world_scene)
		queue_free()
	else:
		printerr("Failed to load world scene: ", error)
