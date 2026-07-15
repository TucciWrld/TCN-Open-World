extends Node3D

# Player Spawn Point - Marks where the player spawns on the road

func _ready() -> void:
	# Position player spawn on the main road
	global_position = Vector3(0, 5, 0)
	print("✓ Player spawn point initialized at: ", global_position)
