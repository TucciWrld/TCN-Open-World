extends Node

# Player Movement - Handles all movement mechanics
# Walk, Run, Sprint, Jump, Crouch, Roll

var player: CharacterBody3D
var world: Node3D

# Movement speeds
const WALK_SPEED = 3.0
const RUN_SPEED = 6.0
const SPRINT_SPEED = 10.0
const CROUCH_SPEED = 1.5
const CROUCH_HEIGHT = 0.4
const NORMAL_HEIGHT = 2.0

# Physics
const ACCELERATION = 15.0
const FRICTION = 8.0
const GRAVITY = 9.8
const JUMP_FORCE = 6.5
const ROLL_SPEED = 12.0
const ROLL_DURATION = 0.4

var velocity = Vector3.ZERO
var current_speed: float = 0.0
var is_crouching: bool = false
var is_rolling: bool = false
var roll_timer: float = 0.0
var jump_cooldown: float = 0.0

func _ready() -> void:
	player = get_parent()
	world = player.get_parent()
	print("✓ Movement Controller Ready")

func _process(delta: float) -> void:
	if not player:
		return
	
	# Handle input and movement
	update_movement(delta)
	update_player()

func update_movement(delta: float) -> void:
	# Get input
	var input_vector = get_input_vector()
	
	# Handle rolling
	if Input.is_action_just_pressed("roll") and is_grounded() and not is_rolling:
		start_roll(input_vector if input_vector != Vector3.ZERO else player.global_transform.basis.z)
	
	# Update roll
	if is_rolling:
		update_roll(delta)
		return  # Skip normal movement during roll
	
	# Handle crouch
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			start_crouch()
	else:
		if is_crouching:
			end_crouch()
	
	# Calculate target speed
	var target_speed = 0.0
	if input_vector != Vector3.ZERO:
		if Input.is_action_pressed("sprint") and not is_crouching:
			target_speed = SPRINT_SPEED
		elif is_crouching:
			target_speed = CROUCH_SPEED
		elif Input.is_action_pressed("run"):
			target_speed = RUN_SPEED
		else:
			target_speed = WALK_SPEED
	
	# Apply acceleration/friction
	if target_speed > current_speed:
		current_speed += ACCELERATION * delta
	else:
		current_speed -= FRICTION * delta
	
	current_speed = clamp(current_speed, 0.0, target_speed)
	
	# Calculate movement direction
	var camera_basis = player.get_node("CameraMount").global_transform.basis
	var forward = -camera_basis.z
	var right = camera_basis.x
	
	var move_direction = (forward * input_vector.z + right * input_vector.x).normalized()
	velocity.x = move_direction.x * current_speed
	velocity.z = move_direction.z * current_speed
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_grounded():
		velocity.y = JUMP_FORCE
		jump_cooldown = 0.1
		print("JUMP!")
	
	jump_cooldown -= delta
	
	# Apply gravity
	if not is_grounded():
		velocity.y -= GRAVITY * delta

func update_player() -> void:
	if player.is_on_floor():
		velocity.y = 0.0
	
	player.velocity = velocity
	player.move_and_slide()

func get_input_vector() -> Vector3:
	var input_vector = Vector3.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	
	return input_vector.normalized()

func is_grounded() -> bool:
	var raycast = player.get_node_or_null("RayCast3D")
	if raycast:
		return raycast.is_colliding()
	return player.is_on_floor()

func get_current_speed() -> float:
	return current_speed

func start_crouch() -> void:
	is_crouching = true
	current_speed = CROUCH_SPEED
	print("Crouching...")

func end_crouch() -> void:
	is_crouching = false
	print("Standing up...")

func start_roll(direction: Vector3) -> void:
	if is_rolling:
		return
	
	is_rolling = true
	roll_timer = ROLL_DURATION
	velocity = direction.normalized() * ROLL_SPEED
	velocity.y = 0
	print("ROLL!")

func update_roll(delta: float) -> void:
	roll_timer -= delta
	
	if roll_timer <= 0:
		is_rolling = false
		current_speed = 0
