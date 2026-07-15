extends Node3D

# Player Camera Controller - Handles third-person camera system
# Smooth rotation, zoom, and collision avoidance

var player: CharacterBody3D
var camera: Camera3D

# Camera settings
const MIN_DISTANCE = 1.0
const MAX_DISTANCE = 5.0
const DEFAULT_DISTANCE = 3.5
const CAMERA_SENSITIVITY = 0.005
const MOUSE_SENSITIVITY = 0.003
const ZOOM_SPEED = 0.5
const ROTATION_SPEED = 8.0

var camera_distance: float = DEFAULT_DISTANCE
var camera_rotation_x: float = -0.3  # Slightly tilted down
var camera_rotation_y: float = 0.0
var camera_velocity = Vector3.ZERO
var desired_position = Vector3.ZERO

func _ready() -> void:
	player = get_parent()
	camera = get_node("Camera3D")
	
	if camera:
		camera.global_position = global_position + Vector3(0, 0, camera_distance)
	
	print("✓ Camera Controller Ready")

func _process(delta: float) -> void:
	if not player or not camera:
		return
	
	# Handle camera rotation
	handle_camera_input(delta)
	
	# Handle zoom
	handle_zoom(delta)
	
	# Update camera position
	update_camera_position(delta)
	
	# Point camera at player
	camera.look_at(player.global_position + Vector3(0, 0.5, 0), Vector3.UP)

func handle_camera_input(delta: float) -> void:
	# Joystick/Controller input
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	
	# Mouse input for camera look
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		# Right mouse button for look around
		pass
	
	# Smooth camera rotation
	if input_vector.length() > 0:
		camera_rotation_y -= input_vector.x * CAMERA_SENSITIVITY * ROTATION_SPEED

func handle_zoom(delta: float) -> void:
	# Mouse wheel zoom or trigger inputs
	if Input.is_action_just_pressed("zoom_in"):
		camera_distance = max(MIN_DISTANCE, camera_distance - ZOOM_SPEED)
	elif Input.is_action_just_pressed("zoom_out"):
		camera_distance = min(MAX_DISTANCE, camera_distance + ZOOM_SPEED)

func update_camera_position(delta: float) -> void:
	# Calculate desired camera position
	var basis = Basis.from_euler(Vector3(camera_rotation_x, camera_rotation_y, 0))
	var offset = basis.z * camera_distance
	
	desired_position = player.global_position + offset + Vector3(0, 0.5, 0)
	
	# Smooth camera movement
	camera.global_position = camera.global_position.lerp(desired_position, delta * ROTATION_SPEED)
	
	# Collision avoidance
	check_collision_avoidance()

func check_collision_avoidance() -> void:
	# Check for obstacles between player and camera
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, camera.global_position)
	var result = space_state.intersect_ray(query)
	
	if result and result.collider != player:
		# Move camera closer to avoid obstacle
		camera_distance = max(MIN_DISTANCE, camera_distance - 0.1)
