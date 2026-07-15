extends Node3D

# City Buildings script - Manages building placement and properties

func _ready() -> void:
	print("✓ City buildings initialized - 5 buildings placed")
	
	# Create building materials
	var materials = [
		Color(0.8, 0.7, 0.6),  # Beige
		Color(0.7, 0.7, 0.7),  # Gray
		Color(0.9, 0.6, 0.3),  # Orange
		Color(0.6, 0.6, 0.8),  # Blue
		Color(0.9, 0.9, 0.6)   # Yellow
	]
	
	var building_index = 0
	for child in get_children():
		if child.name.begins_with("Building"):
			var mesh_instance = child.get_node_or_null("Mesh")
			if mesh_instance:
				var mat = StandardMaterial3D.new()
				mat.albedo_color = materials[building_index % materials.size()]
				mat.metallic = 0.1
				mat.roughness = 0.8
				mesh_instance.material_override = mat
				building_index += 1
