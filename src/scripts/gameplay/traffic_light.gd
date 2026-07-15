extends MeshInstance3D

# Traffic Light script - Cycles through red, yellow, green

var light_state: int = 0  # 0=Red, 1=Yellow, 2=Green
var state_timer: float = 0.0
var state_duration: float = 3.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	state_timer += delta
	
	if state_timer >= state_duration:
		state_timer = 0.0
		light_state = (light_state + 1) % 3
		update_light_color()

func update_light_color() -> void:
	var color = Color.RED
	
	match light_state:
		0:  # Red
			color = Color.RED
		1:  # Yellow
			color = Color.YELLOW
		2:  # Green
			color = Color.GREEN
	
	if material_override:
		material_override.albedo_color = color
