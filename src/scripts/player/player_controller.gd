extends CharacterBody3D

# Player Controller - Main player control script
# Handles input, state management, and coordinates all player systems

const PLAYER_VERSION = "1.0"

var movement_controller: Node
var camera_controller: Node
var current_state: String = "idle"
var current_action: String = "none"

# Player stats
var health: int = 100
var max_health: int = 100
var armor: int = 0
var max_armor: int = 100
var money: int = 0
var experience: int = 0

func _ready() -> void:
	print("=== PLAYER INITIALIZED ===")
	print("Player Version: ", PLAYER_VERSION)
	
	movement_controller = get_node("MovementController")
	camera_controller = get_node("CameraMount")
	
	if movement_controller:
		movement_controller.player = self
	if camera_controller:
		camera_controller.player = self
	
	print("✓ Player Controller Ready")

func _process(delta: float) -> void:
	# Update player state from input
	update_player_state()
	
	# Update HUD
	update_hud()

func update_player_state() -> void:
	# Determine current state based on input and movement
	var input_vector = get_input_vector()
	
	if movement_controller:
		var speed = movement_controller.get_current_speed()
		
		if input_vector == Vector3.ZERO and speed < 0.1:
			current_state = "idle"
		elif Input.is_action_pressed("sprint"):
			current_state = "sprint"
		elif input_vector != Vector3.ZERO:
			if Input.is_action_pressed("crouch"):
				current_state = "crouch"
			else:
				current_state = "walk" if speed < 3.0 else "run"
		elif Input.is_action_just_pressed("jump") and movement_controller.is_grounded():
			current_state = "jump"
		elif Input.is_action_just_pressed("roll"):
			current_state = "roll"

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

func take_damage(damage: int) -> void:
	if armor > 0:
		var armor_reduction = min(damage / 2, armor)
		damage -= armor_reduction
		armor -= armor_reduction
	
	health -= damage
	if health < 0:
		health = 0
		print("Player defeated!")

func heal(amount: int) -> void:
	health = min(health + amount, max_health)

func add_money(amount: int) -> void:
	money += amount

func add_experience(amount: int) -> void:
	experience += amount

func update_hud() -> void:
	var world = get_parent()
	if world:
		var hud = world.get_node_or_null("GameplayUI/HUD")
		if hud:
			var health_label = hud.get_node_or_null("Health")
			var money_label = hud.get_node_or_null("Money")
			var position_label = hud.get_node_or_null("Position")
			
			if health_label:
				health_label.text = "Health: %d/%d" % [health, max_health]
			if money_label:
				money_label.text = "Money: $%d" % money
			if position_label:
				var pos = global_position
				position_label.text = "Position: (%.1f, %.1f, %.1f) | State: %s" % [pos.x, pos.y, pos.z, current_state]
