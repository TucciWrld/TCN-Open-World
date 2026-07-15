extends Node3D

# Sky System - Handles sky dome, clouds, and atmospheric effects

var cloud_speed: float = 10.0  # Units per second
var cloud_layers: Array[Node3D] = []
var time_of_day: float = 0.5  # 0-1, where 0.5 is noon

func _ready() -> void:
	print("✓ Sky system initialized")
	
	# Collect cloud layers
	for child in get_children():
		if child.name.contains("CloudLayer"):
			cloud_layers.append(child)
	
	# Initialize sky dome material
	update_sky_color()

func _process(delta: float) -> void:
	# Move clouds
	for layer in cloud_layers:
		layer.position.x += cloud_speed * delta
		if layer.position.x > 1000:
			layer.position.x = -2000

func update_sky_color() -> void:
	# Update sky color based on time of day
	var sky_color = Color(0.5, 0.7, 1.0, 1.0)  # Daytime blue
	
	if time_of_day < 0.25:  # Evening
		sky_color = Color(1.0, 0.5, 0.3, 1.0)
	elif time_of_day < 0.5:  # Night
		sky_color = Color(0.1, 0.1, 0.2, 1.0)
	
	var sky_dome = get_node_or_null("SkyDome")
	if sky_dome and sky_dome.material_override:
		sky_dome.material_override.albedo_color = sky_color
