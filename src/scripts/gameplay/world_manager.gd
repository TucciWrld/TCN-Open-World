extends Node3D

# World Manager - Handles world initialization and game state

var player_character: Node3D
var world_time: float = 12.0  # Start at noon
var time_speed: float = 0.1  # Real-time multiplier

func _ready() -> void:
	print("=== TCN OPEN WORLD - STAGE 2 ===")
	print("First Playable World Loaded")
	print("Player spawning on road...")
	
	# Initialize world systems
	initialize_world()

func initialize_world() -> void:
	# World initialization
	print("Initializing world systems...")
	
	# Find player spawn point
	var spawn_point = get_node_or_null("PlayerSpawn")
	if spawn_point:
		print("Player spawn point found at: ", spawn_point.global_position)
	else:
		print("WARNING: Player spawn point not found!")
	
	# Initialize environment
	setup_environment()
	
	print("✓ World systems initialized")

func setup_environment() -> void:
	# Setup world environment and lighting
	var world_env = get_node_or_null("Environment")
	if world_env:
		var env = Environment.new()
		env.ambient_light_source = Environment.AMBIENT_LIGHT_DISABLED
		env.ambient_light_energy = 0.5
		world_env.environment = env

func _process(delta: float) -> void:
	# Update world time
	update_time(delta)
	
	# Update HUD
	update_hud()

func update_time(delta: float) -> void:
	# Update world time for day/night cycle
	world_time += delta * time_speed
	if world_time >= 24.0:
		world_time = 0.0

func update_hud() -> void:
	# Update HUD display
	var hud = get_node_or_null("GameplayUI/HUD")
	if hud:
		if player_character:
			var pos = player_character.global_position
			var pos_label = hud.get_node_or_null("Position")
			if pos_label:
				pos_label.text = "Position: (%.1f, %.1f, %.1f)" % [pos.x, pos.y, pos.z]
