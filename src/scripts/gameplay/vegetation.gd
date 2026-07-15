extends Node3D

# Vegetation script - Manages trees, plants, and foliage

func _ready() -> void:
	print("✓ Vegetation system initialized - Trees placed")
	
	# Create tree materials
	var trunk_material = StandardMaterial3D.new()
	trunk_material.albedo_color = Color(0.4, 0.2, 0.0, 1.0)  # Brown
	trunk_material.metallic = 0.0
	trunk_material.roughness = 0.9
	
	var foliage_material = StandardMaterial3D.new()
	foliage_material.albedo_color = Color(0.2, 0.6, 0.2, 1.0)  # Green
	foliage_material.metallic = 0.0
	foliage_material.roughness = 0.7
	
	# Apply materials to all trees
	for tree_group in get_children():
		for tree in tree_group.get_children():
			var trunk = tree.get_node_or_null("Trunk")
			var foliage = tree.get_node_or_null("Foliage")
			
			if trunk:
				trunk.material_override = trunk_material
			if foliage:
				foliage.material_override = foliage_material
