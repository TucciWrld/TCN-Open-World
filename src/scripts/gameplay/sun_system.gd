extends DirectionalLight3D

# Sun System - Handles dynamic sun movement for day/night cycle

var time_of_day: float = 12.0  # 0-24 hours
var sun_rotation_speed: float = 15.0  # Degrees per hour

func _process(delta: float) -> void:
	# Update sun position based on time
	var hours_passed = delta / 3600.0  # Convert delta to hours
	time_of_day += hours_passed * sun_rotation_speed
	
	if time_of_day >= 24.0:
		time_of_day = 0.0
	
	# Calculate sun angle
	var sun_angle = (time_of_day / 24.0) * TAU  # Full rotation per day
	
	# Update rotation
	rotation.x = sin(sun_angle) * PI / 2.0 - PI / 4.0
	rotation.z = cos(sun_angle) * PI / 6.0
	
	# Update light intensity based on sun height
	var sun_height = sin(sun_angle)
	if sun_height < 0:
		light_energy_multiplier = 0.1  # Night
	else:
		light_energy_multiplier = 0.5 + sun_height * 1.5  # Day
