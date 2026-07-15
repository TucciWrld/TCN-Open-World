extends Node3D

# World Manager Updated for Stage 3
# Handles world initialization and player management

var player_character: Node3D
var world_time: float = 12.0  # Start at noon
var time_speed: float = 0.1  # Real-time multiplier

func _ready() -> void:
	print("=== TCN OPEN WORLD - STAGE 3 ===")
	print("First Playable World Loaded")
	print("Player spawning on road...")
	
	# Initialize world systems
	initialize_world()

func initialize_world() -> void:
	# World initialization
	print("Initializing world systems...")
	
	# Find player
	player_character = get_node_or_null("Player")
	if player_character:
		print("✓ Player found at: ", player_character.global_position)
		print("✓ Player health: ", player_character.health)
	else:
		print("WARNING: Player not found!")
	
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

func update_time(delta: float) -> void:
	# Update world time for day/night cycle
	world_time += delta * time_speed
	if world_time >= 24.0:
		world_time = 0.0
