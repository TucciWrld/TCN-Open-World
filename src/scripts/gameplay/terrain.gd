extends Node3D

# Terrain script - Handles grass, ground, and terrain features

func _ready() -> void:
	print("✓ Terrain initialized - 4000x4000 unit grass plane")
	
	# Create grass material
	var grass_material = StandardMaterial3D.new()
	grass_material.albedo_color = Color(0.2, 0.6, 0.2, 1.0)  # Green grass
	grass_material.metallic = 0.0
	grass_material.roughness = 0.8
	
	# Apply material to grass planes
	for child in get_children():
		if child is CSGBox3D:
			child.material_override = grass_material
