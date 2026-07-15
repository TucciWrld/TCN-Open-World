extends Node

# Combat System - Handles combat and weapons

var player: CharacterBody3D

# Combat stats
var is_aiming: bool = false
var is_attacking: bool = false
var current_weapon: String = "punch"  # punch, kick, pistol, etc.
var attack_cooldown: float = 0.0

# Weapon stats
var weapons = {
	"punch": {"damage": 10, "cooldown": 0.5, "range": 1.5},
	"kick": {"damage": 15, "cooldown": 0.7, "range": 2.0},
}

func _ready() -> void:
	player = get_parent()
	print("✓ Combat System Ready")

func _process(delta: float) -> void:
	if not player:
		return
	
	# Update attack cooldown
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# Handle combat input
	handle_combat_input()

func handle_combat_input() -> void:
	if Input.is_action_pressed("aim"):
		if not is_aiming:
			start_aim()
	else:
		if is_aiming:
			end_aim()
	
	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0:
		perform_attack(current_weapon)
	
	if Input.is_action_just_pressed("kick") and attack_cooldown <= 0:
		perform_attack("kick")

func start_aim() -> void:
	is_aiming = true
	print("Aiming...")

func end_aim() -> void:
	is_aiming = false
	print("Not aiming")

func perform_attack(weapon: String) -> void:
	if not weapon in weapons:
		return
	
	var weapon_data = weapons[weapon]
	var damage = weapon_data["damage"]
	var range_val = weapon_data["range"]
	
	print("Performing %s attack! Damage: %d" % [weapon, damage])
	
	# Check for hit targets in range
	check_hit_in_range(range_val, damage)
	
	# Set cooldown
	attack_cooldown = weapon_data["cooldown"]

func check_hit_in_range(range_val: float, damage: int) -> void:
	# Simple range check for nearby enemies
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = range_val
	query.shape = sphere
	query.transform = Transform3D(Basis.IDENTITY, player.global_position + player.global_transform.basis.z * range_val)
	
	var results = space_state.intersect_shape(query)
	print("Targets hit: %d" % results.size())
