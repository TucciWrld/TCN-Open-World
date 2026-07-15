extends Node3D

# Street Light script - Street light that turns on at night

var light_node: OmniLight3D
var is_night: bool = false

func _ready() -> void:
	light_node = get_node_or_null("OmniLight3D")
	if light_node:
		light_node.visible = false

func _process(delta: float) -> void:
	# Toggle light based on time (simplified)
	if light_node:
		# For now, lights are always visible for debugging
		light_node.visible = true
